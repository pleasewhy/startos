#include "../types.h"
#include "../lock/lock.h"
#include "../param.h"
#include "fs.h"
#include "../riscv.h"
#include "buf.h"
#include "file.h"
#include "virtio.h"
#include "../process.h"
#include "../defs.h"

#define min(a, b) ((a) < (b) ? (a) : (b))
struct superblock sb;

// 读取超级块
void read_superblock(struct superblock *sb) {
    struct buf b;
    b.blockno = 1;
    virtio_disk_rw(&b, 0);
    memmove(sb, &b.data, sizeof(*sb));
    return;
}

// 初始化文件系统
void init_fs() {
    read_superblock(&sb);
    if (sb.magic != FSMAGIC) {
        panic("fs init");
    }
}

//
// 数据块，下面的block通常指数据块
//

// 格式化磁盘块中的数据
void zero_block(int blockno) {
    struct buf *bp;
    bp = buf_read(0, blockno);
    memset(bp->data, 0, BSIZE);
    buf_write(bp);
    relse_buf(bp);
}

// 申请空闲的磁盘块, 且格式化为0，返回块号。
uint alloc_disk_block() {
    int b, bi, m;
    struct buf *bitmap;

    for (b = 0; b < sb.size; b += BPB) { // 遍历bitmap
        bitmap = buf_read(0, BBLOCK(b, sb));
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) { //遍历bitmap的每一位
            m = 1 << (bi % 8);
            if ((bitmap->data[bi / 8] & m) == 0) { // 判断块是否被使用
                bitmap->data[bi / 8] |= m; // 标记块被使用
                relse_buf(bitmap);
                zero_block(b + bi);
                return b + bi;
            }
        }
        relse_buf(bitmap);
    }
    panic("balloc: out of blocks");
    return 0;
}

// 释放磁盘块, 通过重置bitmap对应位。
void free_disk_block(int blockno) {
    struct buf *bitmap;
    int bi, m;
    bitmap = buf_read(0, BBLOCK(blockno, sb));
    bi = blockno % BPB;
    m = 1 << (bi % 8);
    bitmap->data[bi / 8] &= ~m;
    relse_buf(bitmap);
}


//
// inode层, 只是简单的实现
//
// inode用来描述一个未命名的文件。
// 磁盘上的inode结构维护下列元数据：文件的类型(文件，目录，设备),
// 文件size，链接该inode的目录项，文件内容块的数组。
//
// inode在sb.startinode上按顺序排列在磁盘上，每个inode都有一个编号,
// 表明它在磁盘上的位置。
//
// 内核在内存中维护了使用中inode的cache，这样可以在多进程的环境中
// 同步访问inode。cached inode包含了磁盘上没有的book-keeping属性:
// ip->ref,ip->valid。
//
// inode和内存中的代表在被文件系统其余部分使用之前会经历一系列的操作,
//
// * Allocation: 当一个inode(磁盘中的)的type为0时，意味着该inode是被分配的
//   alloc_inode()分配inode, putback_inode()在inode的引用数(ip->ref)
//   为0且链接数为0时, 会释放该inode。
//
// * referencing in cache: 若ip->ref==0,则该缓存项是可用的。不然ip->ref记录了内存中指向
//   该缓存项的指针的数量(e.g. 打开的文件和当前目录)。get_inode()寻找或创建一个
//   缓存项，并递增它的ref。putback_inode()递减ref。
//
// * valid: inode缓存项的信息(type, size, ....)只有在valid为1时才有效。
//   lock_inode()从磁盘中读取inode的信息并设置ip->valid,当ip->ref减为0
//   时，putback_inode会重置ip->valid。
//
// * locked: 文件系统只有在锁定了inode之后才能够检查和修改inode的信息和它的内容
//
// 一个具有代表性的代码序列：
//   ip = get_inode(inum)
//   lock_inode(ip)
//   ... 检查和修改ip->xxx ...
//   unlock_inode(ip)
//   putback_inode(ip)
//
// 将lock_inode()从get_inode()抽离出来是为了能够同时获得一个"长期地"引用
// inode(打开的文件)和“短期的”引用(e.g., read())。
// 这种分离也帮助在查找路径名时避免死锁和竞争。 在get_inode()中递增ip->ref
// 是为了让inode保持cached和指向inode的指针有效。
//
// 很多内部的文件系统函数都期望调用者能够锁定相关的inode; 这可以让caller创建
// 多阶段原子操作。
//
// 自旋锁inode_cache.lock 保护inode缓存项的分配。这是因为ip->ref表明缓存项
// 是否可用，ip->inum表明哪一个inode被持有，当使用这些字段时，必须持有
// inode_cache.lock。
//
// 睡眠锁ip->lock保护inode除了ref的全部字段。当读/写inode字段时必须持有ip->lock。
//
//
struct {
    struct spinlock lock;
    struct inode inode[NINODE];
} inode_cache;


// 初始化inode的缓存
void init_inode_cache() {
    spinlock_init(&inode_cache.lock, "inode cache");
    for (int i = 0; i < NINODE; i++) {
        sleeplock_init(&inode_cache.inode[i].lock, "inode");
    }
}

// 分配一个磁盘上inode并将其type设置为参数type
// 返回一个unlocked的inode, 但是已经在磁盘上分配
// 且ref=1。
struct inode *alloc_inode(short type) {
    int inum;
    struct buf *bp;
    struct dinode *dip;
    for (inum = 1; inum < sb.ninodes; inum++) {
        bp = buf_read(0, IBLOCK(inum, sb));
        dip = (struct dinode *) bp->data + inum % IPB;
        if (dip->type == 0) { // a free inode
            memset(dip, 0, sizeof(*dip));
            dip->type = type;
            buf_write(bp); // 写回磁盘
            relse_buf(bp);
            return get_inode(inum);
        }
        relse_buf(bp);
    }
    panic("alloc_inode: no inodes");
    return 0;
}

// 将内存中的inode写入到磁盘中,
// 每次改变磁盘上的ip->xxx字段都需要调用该函数，
// 因为inode cache是write-through。
// 调用者必须持有ip->lock.
void update_inode(struct inode *ip) {
    struct buf *bp;
    struct dinode *dip;

    bp = buf_read(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode *) bp->data + ip->inum % IPB;
    dip->type = ip->type;
    dip->major = ip->major;
    dip->minor = ip->minor;
    dip->nlink = ip->nlink;
    dip->size = ip->size;
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    buf_write(bp);
    relse_buf(bp);
}

// 通过inum从缓冲池中获取一个inode
struct inode *get_inode(int inum) {
    struct inode *ip;
    struct inode *empty;
//    struct buf *bp;
//    struct dinode *dip;

    spin_lock(&inode_cache.lock);
    empty = 0;
    for (ip = &inode_cache.inode[0]; ip < &inode_cache.inode[NINODE]; ip++) {
        if (ip->ref > 0 && ip->inum == inum) {
            ip->ref++;
            spin_unlock(&inode_cache.lock);
            return ip;
        }
        if (empty == 0 && ip->ref == 0) { // 记住未使用缓冲项
            empty = ip;
        }
    }
    if (empty == 0) {
        panic("get_inode");
    }

    ip = empty;
    ip->inum = inum;
    ip->ref = 1;
    ip->valid = 0;
    spin_unlock(&inode_cache.lock);
    return ip;
}

// 移除一个对inode的引用
// 如果是最后一个引用，则这个缓存inode能够被重新使用。
// 如果是最后一个引用，并且并且没有链接到该inode目录项,
// 则在磁盘上释放该inode和它的内容。
void putback_inode(struct inode *ip) {
    spin_lock(&inode_cache.lock);
    if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
        // 当没有目录项链接该inode，以及该inode的链接数为0时，释放inode的数据块。
        sleep_lock(&ip->lock);

        spin_unlock(&inode_cache.lock);

        trunc_inode(ip);
        ip->type = 0;
        update_inode(ip);
        ip->valid = 0;
        sleep_unlock(&ip->lock);
        spin_lock(&inode_cache.lock);
    }
    ip->ref--;
    spin_unlock(&inode_cache.lock);
}

// 数据块包含直接块和间接块，这里只实现了直接块
// 获取inode的第bn个数据块对应的磁盘块号
uint bmap(struct inode *ip, uint bn) {
    uint64 addr;
    if (bn < NDIRECT) {
        if ((addr = ip->addrs[bn]) == 0)
            ip->addrs[bn] = addr = alloc_disk_block();
        return addr;
    }

    panic("bmap");
    return 0;
}

// Truncate inode(移除内容)
// 调用者必须持有ip->lock
void trunc_inode(struct inode *ip) {
    int i, j;
    struct buf *bp;
    uint *a;

    for (i = 0; i < NDIRECT; i++) {
        if (ip->addrs[i]) {
            free_disk_block(ip->addrs[i]);
            ip->addrs[i] = 0;
        }
    }

    if (ip->addrs[NDIRECT]) {
        bp = buf_read(ip->dev, ip->addrs[NDIRECT]);
        a = (uint *) bp->data;
        for (j = 0; j < NINDIRECT; j++) {
            if (a[j])
                free_disk_block(a[j]);
        }
        relse_buf(bp);
        free_disk_block(ip->addrs[NDIRECT]);
        ip->addrs[NDIRECT] = 0;
    }

    ip->size = 0;
    update_inode(ip);
}

// 递增ip->ref
struct inode *dup_inode(struct inode *ip) {
    spin_lock(&inode_cache.lock);
    ip->ref++;
    spin_unlock(&inode_cache.lock);
    return ip;
}

// 锁定给定的inode
// 需要时读取从磁盘读数据
void lock_inode(struct inode *ip) {
    struct buf *bp;
    struct dinode *dip;

    if (ip == 0 || ip->ref < 1)
        panic("lock_inode");

    sleep_lock(&ip->lock);

    if (ip->valid == 0) {
        bp = buf_read(ip->dev, IBLOCK(ip->inum, sb));
        dip = (struct dinode *) bp->data + ip->inum % IPB;
        ip->type = dip->type;
        ip->major = dip->major;
        ip->minor = dip->minor;
        ip->nlink = dip->nlink;
        ip->size = dip->size;
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
        relse_buf(bp);
        ip->valid = 1;
        if (ip->type == 0)
            panic("lock_inode: no type");
    }
}

// 解锁inode.
void unlock_inode(struct inode *ip) {
    if (ip == 0 || !sleep_holding(&ip->lock) || ip->ref < 1)
        panic("unlock_inode");
    sleep_unlock(&ip->lock);
}

void unlock_and_putback(struct inode *ip) {
    unlock_inode(ip);
    putback_inode(ip);
}

// 从inode中读取数据
int read_inode(struct inode *ip, uint64 dst, uint off, int n) {
    int total = 0, m = 0;
    struct buf *bp;
    if (off > ip->size || off + n < off) {
        return 0;
    }
    if (off + n > ip->size) {
        n = ip->size - off;
    }

    for (; total < n; total += m, off += m, dst += m) {
        bp = buf_read(0, bmap(ip, off / BSIZE));
        m = min(BSIZE - off % BSIZE, n - total);
        memmove((uint64 *) (dst), bp->data + (off % BSIZE), m);
        relse_buf(bp);
    }
    return total;
}

// 将数据写入inode
int write_inode(struct inode *ip, uint64 src, uint64 off, int n) {
    uint total, m;
    struct buf *bp;

    if (off > ip->size || off + n < off)
        return -1;
    if (off + n > MAXFILE * BSIZE)
        return -1;
    for (total = 0; total < n; total += m, off += m, src += m) {
        bp = buf_read(0, bmap(ip, off / BSIZE));
        m = min(BSIZE - off % BSIZE, n - total);
        memmove(bp->data + (off % BSIZE), (uint64 *) (src), m);
        buf_write(bp);
        relse_buf(bp);
    }
    if (n > 0) {
        if (off > ip->size)
            ip->size = off;
        // 将内存中的inode写入磁盘，即使没有写入数据，也需要更新，因为循环中可能
        //调用了bmap()或者在ip->addrs[]里面添加了数据块
        update_inode(ip);
    }
    return n;
}


// 目录层
//
// 第一个inode为根目录，该目录在mkfs/makefs下创建
//

int namecmp(const char *s, const char *t) {
    return strncmp(s, t, DIRSIZ);
}

//
//  dirlookup 在一个目录中搜索一个带有给定名称的条目。如果找到
// 了，它返回一个指向相应 inode 的指针，解锁该 inode，并将*poff
// 设置为目录中条目的字节偏移量，以便调用者编辑它。
//
struct inode *dirlookup(struct inode *dp, char *name, uint *poff) {
    uint off, inum;
    struct direntry de;

    if (dp->type != T_DIR)
        panic("dirlookup not DIR");

    for (off = 0; off < dp->size; off += sizeof(de)) {
        if (read_inode(dp, (uint64) &de, off, sizeof(de)) != sizeof(de))
            panic("dirlookup read");
        if (de.inum == 0)
            continue;
        if (namecmp(name, de.name) == 0) {
            // 该目录包含该该名称
            if (poff)
                *poff = off;
            inum = de.inum;
            return get_inode(inum);
        }
    }

    return 0;
}

// dirlink会在当前目录 dp中,通过给定的名称和 inode号创建一个新的目录项。
// 如果名称已经存在，dirlink 将返回一个错误
int dirlink(struct inode *dp, char *name, uint inum) {
    int off;
    struct direntry de;
    struct inode *ip;

    // 检查该name是否存在
    if ((ip = dirlookup(dp, name, 0)) != 0) {
        putback_inode(ip);
        return -1;
    }

    // 寻找一个空的目录项
    for (off = 0; off < dp->size; off += sizeof(de)) {
        if (read_inode(dp, (uint64) &de, off, sizeof(de)) != sizeof(de))
            panic("dirlink read");
        if (de.inum == 0)
            break;
    }
    strncpy(de.name, name, DIRSIZ);
    de.inum = inum;
    if (write_inode(dp, (uint64) &de, off, sizeof(de)) != sizeof(de))
        panic("dirlink");

    return 0;
}

// Path层

// 复制path第一个path元素到name中。
// 返回这个path元素后面的path
// 返回的path没有前缀 “/”，所以可以通过检测*path="\0"来
// 知道name是否为最后一个元素。
//
//如果没有name可以移除，则返回0
//
//例子：
//   skipelem("a/bb/c", name) = "bb/c", setting name = "a"
//   skipelem("///a//bb", name) = "bb", setting name = "a"
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char *skipelem(char *path, char *name) {
    char *s;
    int len;

    while (*path == '/')
        path++;
    if (*path == 0)
        return 0;
    s = path;
    while (*path != '/' && *path != 0)
        path++;
    len = path - s;
    if (len >= DIRSIZ)
        memmove(name, s, DIRSIZ);
    else {
        memmove(name, s, len);
        name[len] = 0;
    }
    while (*path == '/')
        path++;
    return path;
}

// 根据path返回一个inode
// 该函数供nameiparent和namei使用
// 如果parent!=0返回父目录的inode并且复制最后一个元素到name中，
// name必须拥有足够的空间来存储DIRSIZE字节的字符串。
static struct inode *namex(char *path, int nameiparent, char *name) {
    struct inode *ip, *next;
    struct proc *p = myproc();
    if (*path == '/')
        ip = get_inode(ROOTINO);
    else
        ip = get_inode(p->current_dir->inum); // TODO 修改：从进程的当前path

    while ((path = skipelem(path, name)) != 0) {
        lock_inode(ip);
        if (ip->type != T_DIR) {
            unlock_and_putback(ip);
            return 0;
        }
        if (nameiparent && *path == '\0') {
            // Stop one level early.
            unlock_inode(ip);
            return ip;
        }
        if ((next = dirlookup(ip, name, 0)) == 0) {
            unlock_and_putback(ip);
            return 0;
        }
        unlock_and_putback(ip);
        ip = next;
    }
    if (nameiparent) {
        putback_inode(ip);
        return 0;
    }
    return ip;
}

struct inode *namei(char *path) {
    char name[DIRSIZ];
    return namex(path, 0, name);
}

struct inode *nameiparent(char *path, char *name) {
    return namex(path, 1, name);
}