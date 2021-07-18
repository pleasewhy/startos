//
// formatted console output -- printf, panic.
//

#include <stdarg.h>

#include "StartOS.hpp"
#include "common/printk.hpp"
#include "device/Console.hpp"
#include "os/Cpu.hpp"
#include "os/SpinLock.hpp"
#include "os/TaskScheduler.hpp"
#include "riscv.hpp"
#include "types.hpp"

volatile int panicked = 0;

extern "C" Console console;
// lock to avoid interleaving concurrent printf's.
static struct
{
  SpinLock lock;
  bool     locking;
} pr;

static char digits[] = "0123456789abcdef";

static void printint(int xx, int base, int sign)
{
  char   buf[16];
  int    i;
  uint_t x;

  if (sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;

  i = 0;
  do {
    buf[i++] = digits[x % base];
  } while ((x /= base) != 0);

  if (sign)
    buf[i++] = '-';

  while (--i >= 0)
    console.putc(buf[i]);
}

static void printptr(uint64_t x)
{
  uint64_t i;
  console.putc('0');
  console.putc('x');
  for (i = 0; i < (sizeof(uint64_t) * 2); i++, x <<= 4)
    console.putc(digits[x >> (sizeof(uint64_t) * 8 - 4)]);
}

void printstr(const char *s)
{
  for (int i = 0; s[i] != 0; i++) {
    console.putc(s[i]);
  }
}
// Print to the console. only understands %d, %x, %p, %s.
void printf(const char *fmt, ...)
{
  va_list     ap;
  int         i, c, locking;
  const char *s;

  locking = pr.locking;

  if (locking)
    pr.lock.lock();
  if (fmt == 0)
    panic("null fmt");

  va_start(ap, fmt);
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    if (c != '%') {
      console.putc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if (c == 0)
      break;
    switch (c) {
      case 'd':
        printint(va_arg(ap, int), 10, 1);
        break;
      case 'x':
        printint(va_arg(ap, int), 16, 1);
        break;
      case 'p':
        printptr(va_arg(ap, uint64_t));
        break;
      case 's':
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          console.putc(*s);
        break;
      case '%':
        console.putc('%');
        break;
      default:
        // Print unknown % sequence to draw attention.
        console.putc('%');
        console.putc(c);
        break;
    }
  }

  if (locking)
    pr.lock.unlock();
}
void backtrace()
{
  uint64_t s0 = r_fp();
  uint64_t stack_top = PGROUNDUP(s0);
  uint64_t stack_bottom = PGROUNDDOWN(s0);
  uint64_t fp = s0;

  printf("backtrace:\n");
  while (fp != stack_top && fp != stack_bottom) {
    printf("%p\n", *(uint64_t *)(fp - 8));
    fp = *(uint64_t *)(fp - 16);
  }
}

extern Cpu cpus[2];

// static void trapframedump(struct trapframe *tf) {
//   printf("a0: %p\t", tf->a0);
//   printf("a1: %p\t", tf->a1);
//   printf("a2: %p\t", tf->a2);
//   printf("a3: %p\n", tf->a3);
//   printf("a4: %p\t", tf->a4);
//   printf("a5: %p\t", tf->a5);
//   printf("a6: %p\t", tf->a6);
//   printf("a7: %p\n", tf->a7);
//   printf("t0: %p\t", tf->t0);
//   printf("t1: %p\t", tf->t1);
//   printf("t2: %p\t", tf->t2);
//   printf("t3: %p\n", tf->t3);
//   printf("t4: %p\t", tf->t4);
//   printf("t5: %p\t", tf->t5);
//   printf("t6: %p\t", tf->t6);
//   printf("s0: %p\n", tf->s0);
//   printf("s1: %p\t", tf->s1);
//   printf("s2: %p\t", tf->s2);
//   printf("s3: %p\t", tf->s3);
//   printf("s4: %p\n", tf->s4);
//   printf("s5: %p\t", tf->s5);
//   printf("s6: %p\t", tf->s6);
//   printf("s7: %p\t", tf->s7);
//   printf("s8: %p\n", tf->s8);
//   printf("s9: %p\t", tf->s9);
//   printf("s10: %p\t", tf->s10);
//   printf("s11: %p\t", tf->s11);
//   printf("ra: %p\n", tf->ra);
//   printf("sp: %p\t", tf->sp);
//   printf("gp: %p\t", tf->gp);
//   printf("tp: %p\t", tf->tp);
//   printf("epc: %p\n", tf->epc);
// }

static void contextdump(struct context *ctx)
{
  printf("ra=%p sp=%p\n", ctx->ra, ctx->sp);
}

void cpudump(int cpuid)
{
  Cpu *cpu = cpus + cpuid;
  printf("cpu id=%d, task=%p\n", cpuid, cpu->task);
  contextdump(&cpu->context);
  // if (cpu->task != reinterpret_cast<Task *>( -1))
  // trapframedump(cpu->task->trapframe);
}

extern int inkerneltrap;
void       panic(const char *s)
{
  pr.locking = false;
  backtrace();
  printf("taskid=%d\n", Cpu::mycpu()->task->pid);
  // cpudump(0);
  // cpudump(1);
  printf("panic: ");
  printf(s);
  printf("\n");
  panicked = 1;  // freeze uart output from other CPUs
  for (;;)
    ;
}

void printfinit(void)
{
  pr.lock.init("pr");
  pr.locking = true;
}
