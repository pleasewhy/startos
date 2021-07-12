#ifndef FCNTL_H
#define FCNTL_H
#define AT_FDCWD -100

/***************mmap*****************/
#define PROT_NONE 0x0  // 申请内存用
#define PROT_READ 0x1
#define PROT_WRITE 0x2
#define PROT_EXEC 0x4

#define MAP_SHARED 0x01
#define MAP_PRIVATE 0x02
/***************mmap*****************/

/***************************fstat********************************/
#define __S_IFMT 0170000 /* These bits determine file type.  */

/* File types.  */
#define __S_IFDIR 0040000  /* Directory.  */
#define __S_IFCHR 0020000  /* Character device.  */
#define __S_IFBLK 0060000  /* Block device.  */
#define __S_IFREG 0100000  /* Regular file.  */
#define __S_IFIFO 0010000  /* FIFO.  */
#define __S_IFLNK 0120000  /* Symbolic link.  */
#define __S_IFSOCK 0140000 /* Socket.  */

#define __S_ISTYPE(mode, mask) (((mode)&__S_IFMT) == (mask))

#define S_ISDIR(mode) __S_ISTYPE((mode), __S_IFDIR)
#define S_ISCHR(mode) __S_ISTYPE((mode), __S_IFCHR)
#define S_ISBLK(mode) __S_ISTYPE((mode), __S_IFBLK)
#define S_ISREG(mode) __S_ISTYPE((mode), __S_IFREG)
#ifdef __S_IFIFO
#  define S_ISFIFO(mode) __S_ISTYPE((mode), __S_IFIFO)
#endif
#ifdef __S_IFLNK
#  define S_ISLNK(mode) __S_ISTYPE((mode), __S_IFLNK)
#endif
/***************************fstat********************************/

/**********open flags*********/
#define O_RDONLY 0x000
#define O_WRONLY 0x001
#define O_RDWR 0x002
#define O_CREATE 0x40
#define O_TRUNC 0x400
#define O_DIRECTORY 0x0200000

#define DIR 0x040000
#define FILE 0x100000
/**********open flags*********/

/**********fcntl() second argument*********/
#define F_DUPFD 0          /* Duplicate file descriptor.  */
#define F_GETFD 1          /* Get file descriptor flags.  */
#define F_SETFD 2          /* Set file descriptor flags.  */
#define F_GETFL 3          /* Get file status flags.  */
#define F_SETFL 4          /* Set file status flags.  */
#define F_DUPFD_CLOEXEC 12 /* 复制文件描述符，并设置close_on_exec标志位 */
/**********fcntl flags*********/

#endif
