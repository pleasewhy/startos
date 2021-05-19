#ifndef VMMANAGER_HPP
#define VMMANAGER_HPP

#include "types.hpp"
#include "StartOS.hpp"
typedef uint64_t pte_t;
typedef uint64_t *pagetable_t;  // 512 PTEs

/**
 * @brief 将内核运行时的会使用的内存映射到kernel_pagetable中
 *
 * @note 现在的实现是direct map，即vm = pm
 *
 */
 void initKernelVm();

/**
 * @brief 切换到内核页表
 *
 */
 void initHartVm();

/**
 * @brief 返回pagetable中与va相关联的PTE地址, 如果alloc!=0, 就会创建
 * 任何需要的页表。
 *
 * risc-v Sv39方案中，虚拟地址有三级页表页。一个页表页包含512个64位的PTE
 * 64位的虚拟地址被分为5个区域
 *   39..63 -- 必须为0
 *   30..38 -- level-2索引的9位
 *   21..29 -- level-1索引的9位
 *   12..20 -- level-0索引的9位
 *    0..11 -- 页内偏移量的12位
 *
 * @param pagetable 页表
 * @param va 需要查找PTE的va
 * @param alloc 是否创建缺失的页表
 * @return
 */
 pte_t *walk(pagetable_t pagetable, uint64_t va, int alloc);

/**
 * @brief 将pagetable的[va,va+size)映射到[pa,pa+size)
 *
 *
 * 为虚拟地址创建PTE, 将连续的虚拟地址映射到连续的物理地址。
 * 虚拟地址可能没有对齐页的大小。成功返回0, 如果walk()
 * 不能分配一个页表页就返回-1。
 *
 * @param pagetable 页表
 * @param va 虚拟地址起始地址
 * @param sz 要映射地址的大小
 * @param pa 物理地址的起始地址
 * @param perm PTE的权限
 */
 int mappages(pagetable_t pagetable, uint64_t va, uint64_t size, uint64_t pa, int perm);

/**
 * 翻译一个虚拟地址, 返回相应的物理地址，如果虚拟地址不存在返回0。
 * 只能用于翻译用户空间地址。
 *
 * @param pagetable 虚拟地址所属根页表
 * @param va 虚拟地址
 * @return va对应pa
 */
 uint64_t walkAddr(pagetable_t pagetable, uint64_t va);

/**
 * 添加虚拟地址和物理地址的映射到内核页表，只会在
 * 启动的过程中使用，在调用该函数时还没有flush TLB
 * 也没有启用分页。
 *
 */
 void kernel_vm_map(uint64_t va, uint64_t pa, uint64_t sz, int perm);

/**
 * @brief 移除以va为起始地址的n页, va必须按页对齐，并且
 * 这个映射关系必须存在。可以根据需要移除物理页
 * 
 * @param pagetable va所在的页表
 * @param va 虚拟地址，需要按页对齐
 * @param npages 移除页的数量
 * @param do_free 是否释放物理内存
 */
void userUnmap(pagetable_t pagetable, uint64_t va, uint64_t npages, bool do_free);

void userFreePagetable(pagetable_t pagetable, uint64_t sz);
/**
 * 增长进程的sz从oldsz到newsz, 并分配相应PTE和物理内存
 * ，newsz不需要对齐页，返回新的sz，错误返回0
 *
 * @param pagetable 用户页表
 * @param oldsz 当前sz
 * @param newsz 新sz
 * @return
 */
 uint64_t userAlloc(pagetable_t pagetable, uint64_t oldsz, uint64_t newsz);

 /**
 * 缩减进程的sz从oldsz到newsz, 并释放相应PTE和物理内存
 * ，newsz不需要对齐页，返回新的sz，错误返回0
 *
 * @param pagetable 用户页表
 * @param oldsz 当前sz
 * @param newsz 新sz
 * @return
 */
 uint64_t userDealloc(pagetable_t pagetable, uint64_t oldsz, uint64_t newsz);

/**
 * 创建空的用户页表
 * 失败返回0
 * @return 用户进程可用的页表
 */
 pagetable_t userCreate();

/**
 * 将用户initcode加载进入pagetable，只在
 * 初始化第一个进程时才会调用该函数，sz必须
 * 小于PGSIZE
 */
 void UserVmInit(pagetable_t pagetable, uchar_t *src, uint_t sz);

/**
 * 将用户页表中的数据copy到内核中。
 * 从给定的pagetable中，以vsrc为起点向后copy
 * len字节到内核中的dst处。
 * 成功返回0，失败返回-1。
 */
 int copyin(pagetable_t pagetable, char *dst, uint64_t vsrc, uint64_t len);

/**
 * copy用户空间的以0结束的字符串到内核空间中。
 *
 * @param pagetable 用户页表
 * @param dst 内核空间目的地址
 * @param vsrc 用户页表字符串虚拟地址
 * @param maxsz  复制字符串的最大长度
 * @return 成功返回0，错误返回-1。
 */
 int copyinstr(pagetable_t pagetable, char *dst, uint64_t vsrc, int maxsz);

/**
 * 复制内核数据到用户页表中
 * @param pagetable 用户页表
 * @param vdst 目的用户虚拟地址
 * @param src 内核数据
 * @param len copy长度
 * @return 成功返回0，失败返回-1
 */
 int copyout(pagetable_t pagetable, uint64_t vdst, char *src, int len);

/**
 * 将父进程的内存复制到子进程中，页表和物理内存都会被复制。
 * 成功返回0, 失败返回-1。
 * 失败会释放任何已经分配的页。
 */
 int userVmCopy(pagetable_t oldPg, pagetable_t newPg, int sz);

/**
 * @brief 打印一个页表，用于调试
 * 其输出大致如下:
 *    page table 0x0000000087f6e000
 *    ..0: pte 0x0000000021fda801 pa 0x0000000087f6a000
 *    .. ..0: pte 0x0000000021fda401 pa 0x0000000087f69000
 *    .. .. ..0: pte 0x0000000021fdac1f pa 0x0000000087f6b000
 *    .. .. ..1: pte 0x0000000021fda00f pa 0x0000000087f68000
 *    .. .. ..2: pte 0x0000000021fd9c1f pa 0x0000000087f67000
 *    ..255: pte 0x0000000021fdb401 pa 0x0000000087f6d000
 *    .. ..511: pte 0x0000000021fdb001 pa 0x0000000087f6c000
 *    .. .. ..510: pte 0x0000000021fdd807 pa 0x0000000087f76000
 *    .. .. ..511: pte 0x0000000020001c0b pa 0x0000000080007000
 * .. 的数量表明页表的深度，
 * @param pagetable
 * @param n
 */
 void vmprint(pagetable_t pagetable, int n);


#endif  // VMMANAGER_HPP