//
// Created by hy on 2021/1/6.
//

// Sleeping locks

#include "../types.h"
#include "../param.h"
#include "../riscv.h"
#include "lock.h"
#include "../process.h"
#include "../defs.h"

void sleeplock_init(struct sleeplock* lk, char* name)
{
  spinlock_init(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
}

void sleep_lock(struct sleeplock* lk)
{
  spin_lock(&lk->lk);
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  spin_unlock(&lk->lk);
}

void sleep_unlock(struct sleeplock* lk)
{
  spin_lock(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  spin_unlock(&lk->lk);
}

int sleep_holding(struct sleeplock* lk)
{
  int r;
  spin_lock(&lk->lk);
  r = lk->locked && (lk->pid == myproc()->pid);
  spin_unlock(&lk->lk);
  return r;
}
