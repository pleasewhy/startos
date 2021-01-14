#include "types.h"
#include "param.h"
#include "riscv.h"
#include "lock/lock.h"
#include "process.h"
#include "defs.h"

void main()
{
    uart_init();            // 初始化uart
    printf("\n");
    printf("xv6 kernel is booting\n");
    printf("\n");
    trapinit();             // 初始化trap
    plicinit();             // 初始化plic
    plicinithart();
    virtio_disk_init();     // 初始化磁盘
//    init_fs();              // 初始化文件系统
    init_inode_cache();     // 初始化inode cache
    init_buf();          // 初始化磁盘块缓冲
    init_process_table();   // 初始化进程表
    init_first_process();   // 初始化第一个进程
    scheduler();
}
