#ifndef FILE_H
#define FILE_H

/*
 * File types
 *
 * NOTE! These match bits 12..15 of stat.st_mode
 * (ie "(i_mode >> 12) & 15").
 */
#define DT_UNKNOWN	0
#define DT_FIFO		1
#define DT_CHR		2
#define DT_DIR		4
#define DT_BLK		6
#define DT_REG		8
#define DT_LNK		10
#define DT_SOCK		12
#define DT_WHT		14

typedef unsigned int mode_t;
typedef long int off_t;

#define DIENT_BASE_LEN sizeof(long) * 2 + sizeof(short) + sizeof(char)

struct linux_dirent {
    unsigned long d_ino;	// 索引结点号
    long d_off;	// 到下一个dirent的偏移
    unsigned short d_reclen;	// 当前dirent的长度
    unsigned char d_type;	// 文件类型
    char d_name[];	//文件名
};

struct kstat {
        uint64_t st_dev;
        uint64_t st_ino;
        mode_t st_mode;
        uint32_t st_nlink;
        uint32_t st_uid;
        uint32_t st_gid;
        uint64_t st_rdev;
        unsigned long __pad;
        off_t st_size;
        uint32_t st_blksize;
        int __pad2;
        uint64_t st_blocks;
        long st_atime_sec;
        long st_atime_nsec;
        long st_mtime_sec;
        long st_mtime_nsec;
        long st_ctime_sec;
        long st_ctime_nsec;
        unsigned __unused[2];
};

#endif