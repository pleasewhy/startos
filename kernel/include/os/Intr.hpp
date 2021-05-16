#ifndef INTR_HPP
#define INTR_HPP
namespace Intr {
/**
 * 关中断，可嵌套使用
 */
void push_off(void);

/**
 * 开中断，可嵌套使用
 */
void pop_off(void);
}  // namespace Intr
#endif