#include "user.h"
#include "file.h"
#include "fcntl.h"

#define MAX_SPACE 13
char *DIR_STR = "DIR ";
char *FILE_STR = "FILE";
char *OTHER_STR = "OTHER";
char *BLK_STR = "BLK ";
char *CHR_STR = "CHR ";

char *fmtname(char *path)
{
  static char buf[MAX_SPACE + 1];
  char *      p;

  // 找到路径中的最后一段
  for (p = path + strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;

  // 返回空白填充的name
  if (strlen(p) >= MAX_SPACE)
    return p;
  memmove(buf, p, strlen(p));
  memset(buf + strlen(p), ' ', MAX_SPACE - strlen(p));
  return buf;
}

void ls(const char *filepath)
{
  char         buf[512];
  struct kstat kst;
  int          fd;
  char *       type;

  struct linux_dirent *dirents_ptr = buf;
  fd = open(filepath, O_RDONLY);
  fstat(fd, &kst);
  if (!S_ISDIR(kst.st_mode)) {
    printf("%s %s %d\n", fmtname(filepath), DIR_STR, kst.st_size);
  }
  getdents64(fd, dirents_ptr, 512);
  while (dirents_ptr->d_reclen != 0) {
    int fd1 = openat(fd, dirents_ptr->d_name, O_RDONLY, 0);
    fstat(fd1, &kst);
    if (S_ISDIR(kst.st_mode))
      type = DIR_STR;
    else if (S_ISREG(kst.st_mode))
      type = FILE_STR;
    else if(S_ISBLK(kst.st_mode))
      type = BLK_STR;
    else if(S_ISCHR(kst.st_mode))
      type = CHR_STR;
    else
      type = OTHER_STR;
    printf("%s %s %d\n", fmtname(dirents_ptr->d_name), type, kst.st_size);
    dirents_ptr = dirents_ptr->d_off;
    close(fd1);
  }
  close(fd);
}

int main(int argc, char *argv[])
{
  int i;

  if (argc < 2) {
    ls(".");
    exit(0);
  }
  for (i = 1; i < argc; i++)
    ls(argv[i]);
  exit(0);
}
