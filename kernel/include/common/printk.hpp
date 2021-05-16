#ifndef PRINTK_HPP
#define PRINTK_HPP
void printf(const char *fmt, ...);
void panic(const char *s);
void printfinit(void);
#endif  // printk.hpp