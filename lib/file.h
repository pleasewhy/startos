#ifndef FILE_H
#define FILE_H

#define DT_FIFO 1
#define DT_DIR 4

#define DIENT_BASE_LEN sizeof(long) * 2 + sizeof(short) + sizeof(char)

struct dirent {
    unsigned long d_ino;	// 索引结点号
    long d_off;	// 到下一个dirent的偏移
    unsigned short d_reclen;	// 当前dirent的长度
    unsigned char d_type;	// 文件类型
    char d_name[];	//文件名
};
#endif