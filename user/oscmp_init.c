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

void print_success(char *name, char *argv[])
{
  printf("testcase %s ", name);
  for (int i = 0; argv[i] != 0; i++)
    printf("%s ", argv[i]);
  printf("success\n");
}

void print_fail(char *name, char *argv[])
{
  printf("testcase %s ", name);
  for (int i = 0; argv[i] != 0; i++)
    printf("%s ", argv[i]);
  printf("fail\n");
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
      print_success(name, argv);
    }
    else {
      print_fail(name, argv);
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
  char *df_args[] = {"df", 0};
  char *dirname_args[] = {"dirname", "/aaa/bbb", 0};
  char *dmesg_args[] = {"dmesg", 0};
  char *du_args[] = {"du", 0};
  char *expr_args[] = {"expr", "1", "+", "1", 0};
  char *true_args[] = {"true", 0};
  char *false_args[] = {"false", 0};
  char *which_args[] = {"which", "ls", 0};
  char *uname_args[] = {"uname", 0};
  char *uptime_args[] = {"uptime", 0};
  char *printf_args[] = {"printf", "abc\\n", 0};
  char *ps[] = {"ps", 0};
  char *pwd_args[] = {"pwd", 0};
  char *free_args[] = {"free", 0};
  char *hwclock[] = {"hwclock", 0};
  char *kill_args[] = {"kill", "10", 0};
  char *ls_args[] = {"ls", 0};
  char *sleep_args[] = {"sleep", 0};

  char *fecho_args[] = {"echo", "\"#### file opration test\"", 0};
  char *touch_args[] = {"touch", "test.txt", 0};
  char *cat_args[] = {"cat", "test.txt", 0};
  char *cut_args[] = {"cut", "-c", "3", "test.txt", 0};
  char *od_args[] = {"od", "test.txt", 0};
  char *head_args[] = {"head", "test.txt", 0};
  char *tail_args[] = {"tail", "test.txt", 0};
  char *hexdump_args[] = {"hexdump", "-C", "test.txt", 0};
  char *md5sum_args[] = {"md5sum", "test.txt", 0};
  char *stat_args[] = {"stat", "test.txt", 0};
  char *strings_args[] = {"strings", "test.txt", 0};
  char *wc_args[] = {"wc", "test.txt", 0};
  char *cond_args[] = {"[", "-f", "test.txt", "]", 0};
  char *more_args[] = {"more", "test.txt", 0};
  char *rm_args[] = {"rm", "test.txt", 0};
  char *mkdir_args[] = {"mkdir", "test_dir", 0};
  char *mv_args[] = {"mv", "test_dir", "test", 0};
  char *rmdir_args[] = {"rmdir", "test", 0};
  char *grep_args[] = {"grep", "hello", "busybox_cmd.txt", 0};
  char *cp_args[] = {"cp", "busybox_cmd.txt", "busybox_cmd.bak", 0};
  // rm busybox_cmd.bak
  char *find_args[] = {"find", "-name", "busybox_cmd.txt", 0};

  char *lua_date[] = {"date.lua", 0};
  char *lua_file_io[] = {"file_io.lua", 0};
  char *lua_max_min[] = {"max_min.lua", 0};
  char *lua_random[] = {"random.lua", 0};
  char *lua_remove[] = {"remove.lua", 0};
  char *lua_round_num[] = {"round_num.lua", 0};
  char *lua_sin32[] = {"sin32.lua", 0};
  char *lua_sort[] = {"sort.lua", 0};
  char *lua_strings[] = {"strings.lua", 0};

  test("busybox", echo_args);
  test("busybox", ash_args);
  test("busybox", sh_args);
  test("busybox", basename_args);
  test("busybox", cal_args);
  test("busybox", clear_args);
  test("busybox", date_args);
  test("busybox", df_args);
  test("busybox", dirname_args);
  test("busybox", dmesg_args);
  // test("busybox", du_args);
  test("busybox", expr_args);
  test("busybox", true_args);
  test("busybox", false_args);
  test("busybox", which_args);
  test("busybox", uname_args);
  test("busybox", uptime_args);
  test("busybox", printf_args);
  test("busybox", pwd_args);
  test("busybox", hwclock);
  test("busybox", kill_args);
  test("busybox", ls_args);
  test("busybox", sleep_args);
  test("busybox", free_args);

  test("busybox", fecho_args);
  test("busybox", touch_args);
  int fd = open("test.txt", O_RDWR);
  if (fd < 0)
    kernel_panic();
  int n = write(fd, "hello world\n", 13);
  if (n < 0)
    kernel_panic();
  close(fd);
  test("busybox", cat_args);
  test("busybox", cut_args);
  test("busybox", od_args);
  test("busybox", head_args);
  test("busybox", tail_args);
  test("busybox", hexdump_args);
  test("busybox", md5sum_args);
  test("busybox", stat_args);
  test("busybox", strings_args);
  test("busybox", wc_args);
  test("busybox", cond_args);
  test("busybox", more_args);
  test("busybox", rm_args);
  test("busybox", mkdir_args);
  // test("busybox", mv_args);
  test("busybox", rmdir_args);
  test("busybox", grep_args);
  test("busybox", cp_args);
  test("busybox", find_args);

  test("lua", lua_date);
  test("lua", lua_file_io);
  test("lua", lua_max_min);
  test("lua", lua_random);
  test("lua", lua_remove);
  test("lua", lua_round_num);
  test("lua", lua_sin32);
  test("lua", lua_sort);
  test("lua", lua_strings);

  // kernel_panic();
  while (1) {}
}