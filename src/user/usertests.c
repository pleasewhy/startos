#include "../kernel/types.h"
#include "../kernel/fs/fs.h"
#include "user.h"
void forktest()
{
  int a = 1, pid;
  pid = fork();
  int status;
  if (pid > 0) {
    printf("pid=%d,child=%d\n", myproc()->pid, pid);
    pid = wait(&status);
    sleep_sec(1);
    printf("child=%d killed status=%d\n", pid, status);
    return;
  }
  a = ((int*)(&a))[0xfffffffffffff];
  printf("a=%d\n", a); // 不能删除这一句，不然上一句会被编译器优化掉。
  for (;;) {
    printf("%d\n", myproc()->pid);
    sleep_sec(1);
  }
}

void timertest()
{ //时间片测试
  int pid;
  for (int i = 0; i < 4; i++) {
    pid = fork();
    if (pid < 0) {
      exit(-1);
    } else if (pid == 0) {
      for (int j = 0; j < 5; j++) {
        printf("I'm process %d\n", myproc()->pid);
        sleep_sec(1);
      }
      exit(0);
    }
  }
  wait(0);
}

void print_hello()
{
  printf("hello world!\n");
  exit(0);
}

void exectest()
{ //exec测试
  if (fork() > 0) {
    wait(0);
    printf("child exit\n");
  } else {
    exec((uint64)print_hello);
  }
}

void fstest()
{
  struct inode* inode;
  inode = alloc_inode(T_FILE);
  char* str = "hello world!";
  write_inode(inode, (uint64)str, 0, strlen(str));
  char s[20];
  read_inode(inode, (uint64)s, 0, 30);
  printf("%s",s);
}

void runtest(void f(void), char* s)
{
  printf("\ntest %s: \n", s);
  int pid = fork();
  if (pid < 0) {
    printf("fork error\n");
    exit(-1);
  } else if (pid == 0) {
    f();
    exit(0);
  }
  wait(0);
}

struct test {
  void (*f)(void);
  char* s;
} tests[] = {
  // { exectest, "exectest" },
  // { timertest, "timertest" },
  // { forktest, "forktest" },
  { fstest, "fstest" },
  { 0, 0 },
};

void usertests()
{
  struct test* t;
  int i = 0;
  printf("usertest:\n");
  while (1) {
    t = &tests[i++];
    if (t->f == 0 && t->s == 0) {
      break;
    }
    runtest(t->f, t->s);
  }
  printf("\nusertest finish\n\n");
  exit(0);
}
