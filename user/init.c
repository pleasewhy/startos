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

void test(char *argc, char *argv[]) {
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
  // char *getpid[] = {"getpid", 0};
  // char *getppid[] = {"getppid", 0};
  // char *getcwd[] = {"getcwd", 0};
  // char *fork[] = {"fork", 0};
  // char *exit[] = {"exit", 0};
  // char *mkdir_[] = {"mkdir_", 0};
  // char *dup[] = {"dup", 0};
  // char *write[] = {"write", 0};
  // char *open[] = {"open", 0};
  // char *openat[] = {"openat", 0};
  // char *wait[] = {"wait", 0};
  // char *waitpid[] = {"waitpid", 0};
  // char *yield[] = {"yield", 0};
  // char *read[] = {"read", 0};
  // char *close[] = {"close", 0};
  // char *clone[] = {"clone", 0};
  // char *chdir[] = {"chdir", 0};
  // char *execve[] = {"execve", 0};
  test("/getpid", NULL);
  test("/getppid", NULL);
  test("/getcwd", NULL);
  test("/fork", NULL);
  test("/exit", NULL);
  test("/mkdir_", NULL);
  test("/dup", NULL);
  test("/write", NULL);
  test("/read", NULL);
  test("/open", NULL);
  test("/wait", NULL);
  test("/waitpid", NULL);
  test("/yield", NULL);
  test("/openat", NULL);
  test("/close", NULL);
  // test("/clone", NULL);
  test("/chdir", NULL);
  test("/execve", NULL);
  test("/dup2", NULL);
  test("/brk", NULL);
  test("/uname", NULL);
  test("/pipe", NULL);
  test("/getdents", NULL);
  test("/mount", NULL);
  test("/umount", NULL);
  test("/times", NULL);
  test("/gettimeofday", NULL);
  test("/mmap", NULL);
  test("/munmap", NULL);
  test("/fstat", NULL);
  while (1) {
  };
}