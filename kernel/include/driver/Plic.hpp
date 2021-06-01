#ifndef PLIC_HPP
#define PLIC_HPP

#ifdef QEMU
// qemu puts UART registers here in physical memory.
#define UART 0x10000000L
#define UART_IRQ 10
#else
#define UARTHS 0x38000000L
#define UART_IRQ 33
#define UARTHS_IRQ 33
#endif

#ifdef QEMU
// virtio mmio interface
#define DISK 0x10001000
#define DISK_IRQ 1
#else
#define DISK 0x10001000
#define DISK_IRQ 27
#endif

// RTC tick and alarm interrupt
#define IRQN_RTC_INTERRUPT 20


#ifdef __cplusplus
namespace plic {
/**
 * 初始化PLIC
 */
void init();

void initHart();

/**
 * 向PLIC询问中断
 */
int claim();

/**
 * 告知PLIC已经处理了当前IRQ
 */
void complete(int irq);
};  // namespace plic
#endif
#endif
