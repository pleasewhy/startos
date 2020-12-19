#include "types.h"
#include "param.h"
#include "riscv.h"
#include "process.h"
#include "defs.h"

// uart芯片地址
#define UART0 0x10000000L

#define Reg(reg) ((volatile unsigned char *)(UART0 + reg))
#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, value) (*(Reg(reg)) = (value))

#define RHR 0 // receive holding register, 用于接收数据
#define THR 0 // transmit holding register 用于传输数据
#define IER 1 // 中断允许寄存器
#define LCR 3 // 行控制寄存器
#define FCR 2 // FIFO控制寄存器
#define LSR 5 // 行状态寄存器

#define LSR_RX_READY (1 << 0)    // 输入可以被RHR读
#define LSR_TX_IDLE (1 << 5)     // 允许THR传输字节
#define LCR_BAUD_LATCH (1 << 7)  // 设置波特率模式
#define LCR_EIGHT_BITS (1 << 3)  // 设置字宽为8位
#define FCR_FIFO_ENABLE (1 << 0) // 允许FIFO
#define FCR_FIFO_CLEAR (3 << 1)  // 清除两个FIFO的内容
#define IER_RX_ENABLE (1 << 0)   // 读中断允许
#define IER_TX_ENABLE (1 << 1)   // 传输中断允许

void uart_init()
{
  // 禁用中断
  WriteReg(IER, 0x0);

  // 配置波特率模式
  WriteReg(LCR, LCR_BAUD_LATCH);

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);

  // 退出 设置波特率模式
  // 设置字宽为8位，不校验
  WriteReg(LCR, LCR_EIGHT_BITS);

  // 重置和允许FIFO
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);

  // 允许传输和接受中断
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);

  // initlock(&uart_tx_lock, "uart");
}

void uartputc_sync(int c)
{
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    ;
  WriteReg(THR, c);
}

int uartgetc(void)
{
  //
  if (ReadReg(LSR) & 0x01)
  {
    return ReadReg(RHR);
  }
  else
  {
    return -1;
  }
}

void uart_intr()
{
  while (1)
  {
    int c = uartgetc();
    if (c == -1)
      break;
    console_intr(c);
  }
}