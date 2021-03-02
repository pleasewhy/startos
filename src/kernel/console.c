#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "lock/lock.h"
#include "process.h"
#include "fs/fs.h"
#include "fs/file.h"
#include "defs.h"

#define Enter (13)
#define BACKSPACE (0x100)
#define CTRL(x) (x - '@')

#define INPUT_BUF 200

struct {
    struct spinlock lock;
    char buf[INPUT_BUF];
    int read_index;
    int write_index;
} consloe;

void putc(int fs, char ch) {
    uartputc_sync(ch);
}

/**
 * 向控制台写入数据
 */
int console_write(int user_src, uint64 src, int n) {
    int i;
    for (i = 0; i < n; i++) {
        char c;
        if (either_copyin(&c, user_src, src + i, 1) < 0) {
            break;
        }
        uartputc_sync(c);
    }
    return i;
}

/**
 * 从控制台读取数据，每次读取一行或者n个字节
 */
int console_read(int user_dst, uint64 dst, int n) {
    char c;
    int expect = n;
    spin_lock(&consloe.lock);
    while (n > 0) {
        while (consloe.read_index == consloe.write_index) {
            sleep(&consloe.read_index, &consloe.lock);
        }
        c = consloe.buf[consloe.read_index++ % INPUT_BUF];
        if (either_copyout(user_dst, dst, &c, 1) < 0)
            break;
        dst++;
        n--;
        // 当输入一整行时，需要返回
        if (c == '\n') {
            break;
        }
    }
    spin_unlock(&consloe.lock);
    return expect - n;
}

int read_line(char *s) {
    int cnt = 0;
    spin_lock(&consloe.lock);
    sleep(&consloe.read_index, &consloe.lock);
    for (int i = consloe.read_index; i < consloe.write_index; i++) {
        s[cnt++] = consloe.buf[i % INPUT_BUF];
        if (consloe.buf[i % INPUT_BUF] == '\n') {
            consloe.read_index = i + 1;
            s[cnt - 1] = 0;
            spin_unlock(&consloe.lock);
            return cnt - 1;
        }
    }
    spin_unlock(&consloe.lock);
    return -1;
}

void console_putc(int c) {
    if (c == BACKSPACE) {
        // if the user typed backspace, overwrite with a space.
        uartputc_sync('\b');
        uartputc_sync(' ');
        uartputc_sync('\b');
    } else {
        uartputc_sync(c);
    }
}

void console_intr(char c) {
    switch (c) {

        case '\x7f': // 退格
            if (consloe.read_index != consloe.write_index) {
                consloe.write_index--;
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
            consloe.buf[consloe.write_index++ % INPUT_BUF] = c;
            if (c == '\n') {
                wakeup(&consloe.read_index);
            }
            break;
    }
}

void console_init() {
    spinlock_init(&consloe.lock, "console");
    uart_init();

    dev_rw[CONSOLE].read = console_read;
    dev_rw[CONSOLE].write = console_write;
}


