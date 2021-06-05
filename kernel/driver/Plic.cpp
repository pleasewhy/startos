#include "driver/Plic.hpp"
#include "StartOS.hpp"
#include "common/printk.hpp"
#include "memlayout.hpp"
#include "os/Cpu.hpp"
#include "types.hpp"

namespace plic {
void init()
{
  // 设置IRQ的属性为非零，即启用plic
  *(uint32_t *)(PLIC + UART_IRQ * 4) = 1;
#ifdef QEMU
  *(uint32_t *)(PLIC + VIRTIO_IRQ * 4) = 1;
#else
  *(uint32_t *)(PLIC + DMA0_IRQ * 4) = 1;
#endif
}

void initHart(void)
{
  int hart = Cpu::cpuid();
#ifdef QEMU
  // 为当前hart的S模式设置uart的enable
  *(uint32_t *)PLIC_SENABLE(hart) = (1 << UART_IRQ) | (1 << VIRTIO_IRQ);
  // 将当前hart的S模式优先级阈值设置为0
  *(uint32_t *)PLIC_SPRIORITY(hart) = 0;
#else
  uint32_t *hart_m_enable = (uint32_t *)PLIC_MENABLE(hart);
  *(hart_m_enable) = readd(hart_m_enable) | (1 << DMA0_IRQ);
  uint32_t *hart0_m_int_enable_high = hart_m_enable + 1;
  *(hart0_m_int_enable_high) =
      readd(hart0_m_int_enable_high) | (1 << (UART_IRQ % 32));
#endif
}

// 向PLIC询问中断
int claim(void)
{
  int hart = Cpu::cpuid();
  int irq;
#ifndef QEMU
  irq = *(uint32_t *)PLIC_MCLAIM(hart);
#else
  irq = *(uint32_t *)PLIC_SCLAIM(hart);
#endif
  return irq;
}

// 告知PLIC已经处理了当前IRQ
void complete(int irq)
{
  int hart = Cpu::cpuid();
#ifndef QEMU
  *(uint32_t *)PLIC_MCLAIM(hart) = irq;
#else
  *(uint32_t *)PLIC_SCLAIM(hart) = irq;
#endif
}
}  // namespace plic