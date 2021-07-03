#include "user.h"

char *argv[] = {"sh", 0};

int main(void)
{
  int pid, wpid;

  open("/dev/tty", O_RDWR);
  dup(0);  // stdout
  dup(0);  // stderr

  for (;;) {
    printf("init: starting sh\n");
    pid = fork();
    if (pid < 0) {
      printf("init: fork failed\n");
      exit(1);
    }

    if (pid == 0) {
      execve("shell", argv, 0);
      printf("init: exec sh failed\n");
      exit(1);
    }

    for (;;) {
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *)0);
      if (wpid == pid) {
        // the shell exited; restart it.
        while (1)
          ;
        break;
      }
      else if (wpid < 0) {
        printf("init: wait returned an error\n");
        exit(1);
      }
      else {
        // it was a parentless process; do nothing.
      }
    }
  }
}