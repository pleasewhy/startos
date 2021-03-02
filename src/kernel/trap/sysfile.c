//
// Created by hy on 2021/2/3.
//

#include "../types.h"
#include "../param.h"
#include "../riscv.h"
#include "../memlayout.h"
#include "../lock/lock.h"
#include "../process.h"
#include "../fs/fs.h"
#include "../fs/file.h"
#include "../fs/stat.h"
#include "../fs/fcntl.h"
#include "../defs.h"


int argfd(int n, int *fdp, struct file **fp) {
    int fd;
    struct file *f;
    if (argint(n, &fd) < 0) {
        return -1;
    }
    if (fd < 0 || fd > NFILE || (f = myproc()->open_file[fd]) == 0) {
        return -1;
    }
    if (fdp)
        *fdp = fd;
    if (fp)
        *fp = f;
    return 0;
}

static int
fdalloc(struct file *f) {
    int fd;
    struct proc *p = myproc();
    for (fd = 0; fd < NOFILE; fd++) {
        if (p->open_file[fd] == 0) {
            p->open_file[fd] = f;
            return fd;
        }
    }
    return -1;
}

uint64 sys_putchar(void) {
    putc(0, argraw(0));
    return 0;
}

static struct inode *
create(char *path, short type, short major, short minor) {
    struct inode *ip, *dp;
    char name[DIRSIZ];

    if ((dp = nameiparent(path, name)) == 0) {
        return 0;
    }
    lock_inode(dp);

    // 查看该path是否存在，存在直接返回
    if ((ip = dirlookup(dp, name, 0)) != 0) {
        unlock_and_putback(dp);
        lock_inode(ip);
        return ip;
//        if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE)) {
//
//        }
    }
    if ((ip = alloc_inode(type)) == 0) {
        panic("alloc inode");
    }

    lock_inode(ip);
    ip->major = major;
    ip->minor = minor;
    ip->nlink = 1;
    update_inode(ip);

    if (type == T_DIR) {
        // 若type为目录，需要创建
        // . 和 .. 目录项
        dp->nlink++; // .. 链接父目录
        update_inode(dp);
        // 注意 ip不用因为.目录项，增长nlink，
        // 避免循环引用。

        // 链接.目录项到ip， ..目录项到dp
        if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum)) {
            panic("create .. , . dir entry");
        }
    }
    // 在父目录中创建相应的目录项
    if (dirlink(dp, name, ip->inum)) {
        panic("create: dirlink");
    }

    unlock_and_putback(dp);
    return ip;
}

uint64 sys_open(void) {
    char path[MAXPATH];
    int fd, mode;
    struct file *f;
    struct inode *ip;
    int n;
    if ((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &mode)) {
        return -1;
    }

    if (mode & O_CREATE) {
        ip = create(path, T_FILE, 0, 0);
        if (ip == 0) {
            return -1;
        }
    } else {
        if ((ip = namei(path)) == 0) {
            return -1;
        }
        lock_inode(ip);
        if (ip->type == T_DIR && mode != O_RDONLY) {
            unlock_and_putback(ip);
            return -1;
        }
    }
    // 目录权限限制为仅可读
    if (ip->type == T_DIR && (mode != O_RDONLY)) {
        unlock_and_putback(ip);
        return -1;
    }

    if (ip->type == T_DEVICE && (ip->major < 0 || ip->minor > NDEV)) {
        unlock_and_putback(ip);
        return -1;
    }

    if ((f = file_alloc()) == 0 || (fd = fdalloc(f)) < 0) {
        if (f)
            file_close(f);
        putback_inode(ip);
        return -1;
    }
    if (ip->type == T_DEVICE) {
        f->type = FD_DEVICE;
        f->major = ip->major;
    } else {
        f->type = FD_INODE;
        f->off = 0;
    }

    f->ip = ip;
    f->readable = !(mode & O_WRONLY);
    f->writable = (mode & O_WRONLY) || (mode & O_RDWR);
    if ((mode & O_TRUNC) && ip->type == T_FILE) {
        trunc_inode(ip);
    }
    unlock_inode(ip);
    return fd;
}

uint64
sys_mknod() {
    struct inode *ip;
    char path[MAXPATH];
    printf("mknod\n");
    int major, minor;
    if (argstr(0, path, MAXPATH) < 0 ||
        argint(1, &major) ||
        argint(2, &minor) ||
        (ip = create(path, T_DEVICE, major, minor)) == 0) {
        return -1;
    }

    unlock_and_putback(ip);
    return 0;
}

uint64 sys_mkdir() {
    char path[MAXPATH];
    struct inode *ip;
    if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
        return -1;
    }
    unlock_and_putback(ip);
    return 0;
}

uint64 sys_chdir() {
    char path[MAXPATH];
    struct inode *ip;
    struct proc *p = myproc();

    if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0)
        return -1;
    lock_inode(ip);

    if (ip->type != T_DIR) {
        unlock_and_putback(ip);
        return -1;
    }
    unlock_inode(ip);
    putback_inode(p->current_dir);
    p->current_dir = ip;
    return 0;
}

uint64
sys_dup(void) {
    struct file *f;
    int fd;

    if (argfd(0, 0, &f) < 0)
        return -1;
    if ((fd = fdalloc(f)) < 0)
        return -1;
    file_dup(f);
    return fd;
}

uint64 sys_read(void) {
    struct file *f;
    int n;
    uint64 uaddr;

    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &uaddr) < 0)
        return -1;
    return file_read(f, uaddr, n);
}

uint64 sys_write(void) {
    struct file *f;
    int n;
    uint64 uaddr;
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &uaddr) < 0)
        return -1;

    return file_write(f, uaddr, n);
}

uint64 sys_close(void) {
    int fd;
    struct file *f;

    if (argfd(0, &fd, &f) < 0)
        return -1;
    myproc()->open_file[fd] = 0;
    file_close(f);
    return 0;
}

uint64 sys_fstat(void) {
    struct file *f;
    uint64 uaddr;
    if (argfd(0, 0, &f) < 0) {
        return -1;
    }
    if (argaddr(1, &uaddr) < 0) {
        return -1;
    }
    file_stat(f, uaddr);
    return 0;
}

uint64 sys_exec(void) {
    char path[MAXPATH], *argv[MAXARG];
    uint64 uargv, uarg=0;
    if (argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0)
        return -1;
    if (strlen(path) < 1)
        return -1;
    memset(argv, 0, sizeof(argv));
    for (int i = 0;; i++) {
        if (i > MAXARG)
            goto bad;
        if (fetchaddr(uargv + sizeof(uint64) * i, &uarg) < 0)
            goto bad;
        if (uarg == 0) {
            argv[i] = 0;
            break;
        }
        argv[i] = kalloc();
        if(argv[i] == 0)
            goto bad;
        if(fetchstr(uarg, argv[i], PGSIZE) < 0)
            goto bad;
    }
    int ret = exec(path,argv);
    for(int i = 0; i <= MAXARG && argv[i] != 0; i++)
        kfree(argv[i]);
    return ret;

bad:
    for(int i = 0; i <= MAXARG && argv[i] != 0; i++)
        kfree(argv[i]);
    return -1;
}


//
// 进程相关的系统调用
//
uint64 sys_exit(void) {
    int status = 0;
    if (argint(0, &status) < 0) {
        return -1;
    }
    exit(status);
    return 0;
}

uint64 sys_fork(void) {
    return fork();
}

uint64 sys_wait(void) {
    uint64 vaddr;
    argaddr(0, &vaddr);
    return wait(vaddr);
}