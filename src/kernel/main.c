#include "types.h"
#include "param.h"
#include "riscv.h"
#include "lock/lock.h"
#include "process.h"
#include "defs.h"

void main() {
    console_init();         // 初始化控制台
    printf("\n");
    printf("xv6 kernel is booting\n");
    printf("\n");
    trapinit();             // 初始化trap
    plicinit();             // 初始化plic
    plicinithart();
    kernel_mem_init();      // 初始化内存
    kernel_vm_init();       // 初始化内核虚拟内存
    vm_hart_init();         // 启用分页
    virtio_disk_init();     // 初始化磁盘
    init_inode_cache();     // 初始化inode cache
    init_buf();             // 初始化磁盘块缓冲
    init_process_table();   // 初始化进程表
    init_first_process();   // 初始化第一个进程
    scheduler();
}
