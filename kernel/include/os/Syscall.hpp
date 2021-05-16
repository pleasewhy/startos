#ifndef SYS_CALL_HPP
#define SYS_CALL_HPP

#include "types.hpp"
#include "StartOS.hpp"

void syscall(void);
void syscall_init();
uint64_t argraw(int n);
int argint(int n, int *addr);
int fetchaddr(uint64_t addr, uint64_t *ip);
int argaddr(int n, uint64_t *ip);
int fetchstr(uint64_t addr, char *buf, int max);
int argstr(int n, char *buf, int max);
void syscall(void);
#endif