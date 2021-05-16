#include "os/Intr.hpp"
#include "common/printk.hpp"
#include "os/Cpu.hpp"
#include "riscv.hpp"

namespace Intr {

// push_off/pop_off 和 intr_off/intr_on 差不多，只是使得
// 开关中断可以嵌套使用。
void push_off(void) {
  int old = intr_get();
  intr_off();
  if (Cpu::mycpu()->noff == 0) Cpu::mycpu()->intr_enable = old;
  Cpu::mycpu()->noff += 1;
}

void pop_off(void) {
  Cpu *c = Cpu::mycpu();
  if (intr_get()) panic("pop_off - interruptible");
  if (c->noff < 1) {
    panic("pop_off");
  }
  c->noff -= 1;
  if (c->noff == 0 && c->intr_enable) intr_on();
}
}  // namespace Intr