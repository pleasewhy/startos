#ifndef START_OS_HPP
#define START_OS_HPP
#include "types.hpp"

void *operator new(uint64_t size);
void  operator delete(void *p);

void *operator new[](uint64_t size);
void  operator delete[](void *p);

/**
 * @brief 获取结构体某一个成员的偏移量
 * @param TYPE 结构体
 * @param MEMBER 给定结构体的成员变量
 */
#ifdef __compiler_offsetof
#  define offsetof(TYPE, MEMBER) __compiler_offsetof(TYPE, MEMBER)
#else
#  define offsetof(TYPE, MEMBER) ((size_t) & ((TYPE *)0)->MEMBER)
#endif

/**
 * container_of - cast a member of a structure out to the containing structure
 * @brief 获取包含给定member的结构体指针
 * @ptr:	member的地址
 * @type:	结构体类型
 * @member:	结构体中member的名称
 *
 */
#define container_of(ptr, type, member)                                        \
  ({                                                                           \
    char *__mptr = (char *)(ptr);                                              \
    ((type *)(__mptr - offsetof(type, member)));                               \
  })

#define min(x, y) (x < y) ? x : y
#define max(x, y) (x > y) ? x : y
// #define ATEXIT_MAX_FUNCS 32

// extern "C" {

// typedef int uarch_t;

// struct atexit_func_entry_t {
//     void (*destructor_func)(void *);
//     void *obj_ptr;
//     void *dso_handle;
// };

// int __cxa_atexit(void (*f)(void *), void *objptr, void *dso);
// void __cxa_finalize(void *f);

// } // end of extern "C"

#endif