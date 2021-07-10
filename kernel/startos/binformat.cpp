#include "startos/binformat.hpp"
#include "param.hpp"
#include "common/string.hpp"
#include "memory/VmManager.hpp"

int BinProgram::CopyString2Stack(char *strs[])
{
  int i = stack_top;

  for (; strs[i]; i++) {
    if (i > MAXARG)
      return -1;
    sp -= strlen(strs[i]) + 1;
    sp -= sp % 16;
    if (sp < stackbase) {
      return -1;
    }
    if (copyout(pagetable, sp, strs[i], strlen(strs[i]) + 1) < 0)
      return -1;
    ustack[i] = sp;
  }
  ustack[i] = 0;
  int c = i - stack_top;
  stack_top = i + 1;
  return c;
}

uint64_t BinProgram::CopyString(const char *s)
{
  sp -= strlen(s) + 1;
  sp -= sp % 16;
  if (copyout(pagetable, sp, (char *)s, strlen(s) + 1) < 0)
    return -1;
  return sp;
}
