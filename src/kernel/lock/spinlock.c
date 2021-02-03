//
// Created by hy on 2020/12/26.
//

#include "../types.h"
#include "../param.h"
#include "lock.h"
#include "../riscv.h"
#include "../process.h"
#include "../defs.h"

void spinlock_init(struct spinlock *lk, char *name) {
    lk->cpu = 0;
    lk->name = name;
    lk->locked = 0;
}

void spin_lock(struct spinlock *lk) {
    push_off(); // 禁用中断以避免死锁。
    if (spin_holding(lk)){
        printf("lock=%s",lk->name);
        panic("re-acquire");
    }

    // 在RISC-V中，sync_lock_test_and_set会转化成原子swap：
    //   a5 = 1
    //   s1 = &lk->locked
    //   amoswap.w.aq a5, a5, (s1)
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0);

    // 告诉C编译器和处理器在这之后就不要不要移动load和store指令，
    // 确保临界区中的内存引用会在锁获取之后进行。
    // 在RISC-V中, 这个函数生成fence指令。
    __sync_synchronize();

    // 记录获取锁的cpu
    lk->cpu = mycpu();
}

// 自旋锁unlock
void spin_unlock(struct spinlock *lk) {
    if (!spin_holding(lk)){
        printf("%s\n", lk->name);
        panic("release");
    }

    lk->cpu = 0;

    // 内存屏障，防止将编译器或者CPU将该语句上方的
    // 语句re-order到语句下方。
    // 在RISC-V中，将生成fence指令
    __sync_synchronize();

    // 释放锁, 相当于lk->locked=0.
    // 代码里不能使用C引用, 因为C标准指明了引用会被翻译成多个store机器指令
    // 在RISC-V中,sync_lock_release会被翻译为原子交换：
    // s1 = &lk->locked
    // amoswap.w zero, zero, (s1)
    __sync_lock_release(&lk->locked);

    pop_off();
}

// 检查当前cpu是否持有这个锁
// 需要关中断
int spin_holding(struct spinlock *lk) {
    int r;
    r = (lk->locked && lk->cpu == mycpu());
    return r;
}

// push_off/pop_off 和 intr_off/intr_on 差不多，只是使得
// 开关中断可以嵌套使用。
void push_off(void) {
    int old = intr_get();
    intr_off();
    if (mycpu()->noff == 0)
        mycpu()->intr_enable = old;
    mycpu()->noff += 1;
}

void pop_off(void) {
    struct cpu *c = mycpu();
    if (intr_get())
        panic("pop_off - interruptible");
    if (c->noff < 1)
        panic("pop_off");
    c->noff -= 1;
    if (c->noff == 0 && c->intr_enable)
        intr_on();
}
