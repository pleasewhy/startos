#include "../types.h"
#include "../lock/lock.h"
#include "fs.h"
#include "buf.h"
#include "file.h"
#include "virtio.h"
#include "../defs.h"

#define DISK_WRITE (1)
#define DISK_READ (0)
#define NINODE 50

#define min(a, b) ((a) < (b) ? (a) : (b))
struct superblock sb;

// 读取超级块
void read_superblock(struct superblock* sb)
{
  struct buf b;
  b.blockno = 1;
  virtio_disk_rw(&b, DISK_READ);
  memmove(sb, &b.data, sizeof(*sb));
  printf("num=%d\n", b.data[0]);
  return;
}

// 初始化文件系统
void init_fs()
{
  read_superblock(&sb);
  if (sb.magic != FSMAGIC) {
    panic("fs init");
  }
}

// 格式化磁盘块中的数据
void zero_block(int blockno)
{
  struct buf *bp;
  bp = buf_read(0,blockno);
  memset(bp->data, 0, BSIZE);
  buf_write(bp);
  relse_buf(bp);
}

// 申请空闲的磁盘块, 返回块号
uint alloc_disk_block()
{
  int b, bi, m;
  struct buf* bitmap;

  bitmap = 0;
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

// 释放磁盘块
void free_disk_block(int blockno)
{
  struct buf* bitmap;
  int bi, m;
  bitmap = buf_read(0, BBLOCK(blockno, sb));
  bi = blockno % BPB;
  m = 1 << (bi % 8);

  bitmap->data[bi / 8] &= ~m;
  relse_buf(bitmap);
}

// inode层, 只是简单的实现
struct {
  struct spinlock lock;
  struct inode inode[NINODE];
} inode_cache;

//static struct inode* get_inode(int inum);

// 初始化inode的缓存
void init_inode_cache()
{
  spinlock_init(&inode_cache.lock, "inode cache");
//  struct inode i;
  for (int i = 0; i < NINODE; i++) {
    sleeplock_init(&inode_cache.inode[i].lock, "inode");
  }
}

// 根据type申请一个inode, 返回struct inode
struct inode* alloc_inode(short type)
{
  int inum;
  struct buf* bp;
  struct dinode* dip;
  for (inum = 1; inum < sb.ninodes; inum++) {
    bp = buf_read(0, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum % IPB;
    if (dip->type == 0) { // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      buf_write(bp); // mark it allocated on the disk
      relse_buf(bp);
      return get_inode(inum);
    }
    relse_buf(bp);
  }
  panic("alloc_inode: no inodes");
  return 0;
}

// 将内存中的inode写入到磁盘中,
void update_inode(struct inode* ip)
{
  struct buf* bp;
  struct dinode* dip;

  bp = buf_read(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum % IPB;
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
struct inode* get_inode(int inum)
{
  struct inode* ip;
  struct inode* empty;
  struct buf* bp;
  struct dinode* dip;

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
  bp = buf_read(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum % IPB;
  ip->type = dip->type;
  ip->major = dip->major;
  ip->minor = dip->minor;
  ip->nlink = dip->nlink;
  ip->size = dip->size;
  memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  relse_buf(bp);
  if (ip->type == 0)
    panic("ilock: no type");

  spin_unlock(&inode_cache.lock);
  return ip;
}

// 通过inum从缓冲池中获取一个inode
void putback_inode(struct inode* ip)
{
  spin_lock(&inode_cache.lock);
  ip->ref--;
  spin_unlock(&inode_cache.lock);
}

// 数据块包含直接块和间接块，这里只实现了直接块
// 获取inode的第bn个数据块对应的磁盘块号
uint bmap(struct inode* ip, uint bn)
{
  uint64 addr;
  if (bn < NDIRECT) {
    if ((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = alloc_disk_block();
    return addr;
  }
  panic("bmap");
  return 0;
}

// 从inode中读取数据
int read_inode(struct inode* ip, uint64 dst, uint off, int n)
{
  int total = 0, m = 0;
  struct buf* bp;
  if (off > ip->size || off + n < off) {
    return 0;
  }
  if (off + n > ip->size) {
    n = ip->size - off;
  }

  for (; total < n; total += m, off += m, dst += m) {
    bp = buf_read(0, bmap(ip, off / BSIZE));
    m = min(BSIZE - off % BSIZE, n - total);
    memmove((uint64*)(dst), bp->data + (off % BSIZE), m);
    relse_buf(bp);
  }
  return total;
}

int write_inode(struct inode* ip, uint64 src, uint64 off, int n)
{
  uint total, m;
  struct buf* bp;

  if (off > ip->size || off + n < off)
    return -1;
  if (off + n > MAXFILE * BSIZE)
    return -1;
  for (total=0; total < n; total += m, off += m, src += m) {
    bp = buf_read(0, bmap(ip, off / BSIZE));
    m = min(BSIZE - off % BSIZE, n - total);
    memmove((uint64*)(src), bp->data + (off % BSIZE), m);
    relse_buf(bp);
  }
  if (n > 0) {
    if (off > ip->size)
      ip->size = off;
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    // 将内存中的inode写入磁盘，即使没有写入数据，也需要更新，因为循环中可能
    //调用了bmap()或者在ip->addrs[]里面添加了数据块
    update_inode(ip);
  }
  return n;
}
