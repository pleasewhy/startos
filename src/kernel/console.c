#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "lock/lock.h"
#include "process.h"
#include "printf.h"

#define Enter (13)
#define BACKSPACE (0x100)
#define CTRL(x) (x - '@')

#define INPUT_BUF 200

struct
{
    struct spinlock lock;
    char buf[INPUT_BUF];
    int read_index;
    int write_index;
} consloe_buf;

void putc(int fd, char ch)
{
    uartputc_sync(ch);
}

int read_line(char* s)
{
    int cnt = 0;

    spin_lock(&consloe_buf.lock);
    sleep(&consloe_buf, &consloe_buf.lock);
    for (int i = consloe_buf.read_index; i < consloe_buf.write_index; i++) {
        s[cnt++] = consloe_buf.buf[i % INPUT_BUF];
        if (consloe_buf.buf[i % INPUT_BUF] == '\n') {
            consloe_buf.read_index = i + 1;
            s[cnt - 1] = 0;
            spin_unlock(&consloe_buf.lock);
            return cnt - 1;
        }
    }
    spin_unlock(&consloe_buf.lock);
    return -1;
}

void console_putc(int c)
{
    if (c == BACKSPACE) {
        // if the user typed backspace, overwrite with a space.
        uartputc_sync('\b');
        uartputc_sync(' ');
        uartputc_sync('\b');
    } else {
        uartputc_sync(c);
    }
}

void console_intr(char c)
{
    switch (c) {

    case '\x7f': // 退格
        if (consloe_buf.read_index != consloe_buf.write_index) {
            consloe_buf.write_index--;
            console_putc(BACKSPACE);
            console_putc('\a');
        }
        break;
    case CTRL('P'):
        print_proc();
        break;
    default:
        // 显示输出字符
        c = (c == '\r') ? '\n' : c;
        console_putc(c);
        // 保存输入字符
        consloe_buf.buf[consloe_buf.write_index++ % INPUT_BUF] = c;
        if (c == '\n') {
            wakeup(&consloe_buf);
        }
        break;
    }
}

void backtrace()
{
    uint64 s0 = r_fp();
    uint64 stack_top = PGROUNDUP(s0);
    uint64 stack_bottom = PGROUNDDOWN(s0);
    uint64 fp = s0;

    printf("backtrace:\n");
    while (fp != stack_top && fp != stack_bottom)
    {
        printf("%p\n", *(uint64*)(fp - 8));
        fp = *(uint64*)(fp - 16);
    }
}

void panic(char* s)
{
    printf("panic:%s", s);
    backtrace();
    for (;;) {
    }
}
