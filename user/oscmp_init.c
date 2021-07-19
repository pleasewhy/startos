#include "oscmp/oscom_user.h"

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

void print_success(char *argv[])
{
  printf("testcase busybox ");
  for (int i = 0; argv[i] != 0; i++)
    printf("%s ", argv[i]);
  printf("success\n");
}

void test(char *name, char *argv[])
{
  int pid = fork();
  if (pid == 0) {
    execve(name, argv, NULL);
  }
  else {
    int status;
    wait(&status);
    if (status >= 0) {
      print_success(argv);
    }
  }
}

void test_file_operation();
void main()
{
  open("dev/tty", O_RDWR);
  dup(0);
  dup(0);
  char *echo_args[] = {"echo", "#### independent command test", 0};
  char *ash_args[] = {"ash", "-c", "exit", 0};
  char *sh_args[] = {"sh", "-c", "exit", 0};
  char *basename_args[] = {"basename", "/aaa/bbb", 0};
  char *cal_args[] = {"cal", 0};
  char *clear_args[] = {"clear", 0};
  char *date_args[] = {"date", 0};
  // df
  char *dirname_args[] = {"dirname", "/aaa/bbb", 0};
  // dmesg
  // du
  char *expr_args[] = {"expr", "1", "+", "1", 0};
  char *true_args[] = {"true", 0};
  char *false_args[] = {"false", 0};
  char *which_args[] = {"which", "ls", 0};
  char *uname_args[] = {"uname", 0};
  // uptime
  char *printf_args[] = {"abc\\n", 0};
  // ps
  char *pwd_args[] = {"pwd", 0};
  char *free_args[] = {"free", 0};
  char *kill_args[] = {"kill", "10", 0};
  char *ls_args[] = {"ls", 0};
  char *sleep_args[] = {"sleep", 0};

  test("busybox", echo_args);
  test("busybox", ash_args);
  test("busybox", sh_args);
  test("busybox", basename_args);
  test("busybox", cal_args);
  test("busybox", clear_args);
  test("busybox", date_args);
  test("busybox", dirname_args);
  test("busybox", expr_args);
  test("busybox", true_args);
  test("busybox", false_args);
  test("busybox", which_args);
  test("busybox", uname_args);
  test("busybox", printf_args);
  test("busybox", pwd_args);
  test("busybox", kill_args);
  test("busybox", ls_args);
  test("busybox", sleep_args);
  test("busybox", free_args);

  // char *shell_args[] = {"ash", "busybox_testcode.sh", 0};
  // int   pid = fork();
  // if (pid == 0) {
  //   printf("test file\n");
  //   execve("busybox", shell_args, NULL);
  // }
  // else {
  //   int status;
  //   wait(&status);
  // }

  // kernel_panic();
  while (1) {}
}