#include "user.h"

// void test_cwd() {
//   char buf[100];
//   memset(buf, 0, 100);
//   getcwd(buf, 100);
//   printf("cwd=%s\n", buf);
//   chdir("bi");

//   memset(buf, 0, 100);
//   getcwd(buf, 100);
//   printf("cwd=%s\n", buf);
// }

// void test_getpid() { printf("pid=%d\n", getpid()); }

// void waitChild(int pid) {
//   int status, child;
//   if (pid == -1) {
//     child = wait(&status);
//   } else {
//     child = wait4(pid, &status);
//   }
//   printf("wait=%d child pid=%d exit code=%d\n", pid, child, status);
// }

// void test_mkdir() {}
// void test_fork() {
//   int pid = fork();
//   int status;
//   if (pid == 0) {
//     printf("I'm child pid=%d\n", getpid());
//     printf("my parent pid=%d\n", getppid());
//     exit(-1);
//   } else if (pid > 0) {
//     wait(&status);
//     printf("my child pid=%d\n", pid);
//     printf("child status=%d\n", status);
//   }
//   for (int i = 0; i < 2; i++) {
//     pid = fork();
//     if (pid == 0) {
//       printf("I'm child pid=%d\n", getpid());
//       printf("my parent pid=%d\n", getppid());
//       exit(-1);
//     }
//   }
//   waitChild(1);
//   waitChild(2);
// }

// // void test(){
// //   mkdirat();
// // }

// void test_close() {
//   close(0);
//   if (write(0, "close 0", 8) == 0) {
//     printf("close failed\n");
//     return;
//   } else {
//     open("/dev/tty", O_RDWR);
//     printf("close success\n");
//   }
// }

void test_getpid() {
  const char *argc = "/riscv64/getpid";
  char *argv[] = {"getpid", 0};
  int pid = fork();
  if (pid == 0) {
    execve(argc, argv, NULL);
  } else {
    wait(0);
  }
}

void test_getppid() {
  const char *argc = "/riscv64/getppid";
  char *argv[] = {"getppid", 0};
  int pid = fork();
  if (pid == 0) {
    execve(argc, argv, NULL);
  } else {
    wait(0);
  }
}

void test_getcwd() {
  const char *argc = "/riscv64/getcwd";
  char *argv[] = {"getcwd", 0};
  int pid = fork();
  if (pid == 0) {
    execve(argc, argv, NULL);
  } else {
    wait(0);
  }
}

void test_fork() {
  const char *argc = "/riscv64/fork";
  char *argv[] = {"fork", 0};
  int pid = fork();
  if (pid == 0) {
    execve(argc, argv, NULL);
  } else {
    wait(0);
  }
}

void test_exit() {
  const char *argc = "/riscv64/exit";
  char *argv[] = {"exit", 0};
  int pid = fork();
  if (pid == 0) {
    execve(argc, argv, NULL);
  } else {
    wait(0);
  }
}

// void test

void main() {
  open("dev/tty", O_RDWR);
  dup(0);
  dup(0);
  test_getpid();
  test_getppid();
  test_getcwd();
  test_fork();
  test_exit();
  while (1) {
  };
}