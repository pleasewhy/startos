#ifndef _STL_LIST_HPP
#define _STL_LIST_HPP
// linux链表实现
struct list_head
{
  struct list_head *next, *prev;
};

static inline void INIT_LIST_HEAD(struct list_head *list)
{
  list->next = list;
  list->prev = list;
}

/**
 * @brief 插入一个新的节点在两个连续的节点之间
 *
 * @note 只有在我们知道prev/next节点的情况下，才能使用该函数
 * 进行操作
 */
static inline void __list_add(struct list_head *new_node,
                              struct list_head *prev,
                              struct list_head *next)
{
  next->prev = new_node;
  new_node->next = next;
  new_node->prev = prev;
  prev->next = new_node;
}

/**
 * @brief 添加一个新的节点
 * @param new_node 需要添加的节点
 * @param head new_node会被添加到该节点之后
 *
 * 将new_node添加到head之后，使用该函数可以很好的实现栈
 */
static inline void list_add(struct list_head *new_node, struct list_head *head)
{
  __list_add(new_node, head, head->next);
}

/**
 * @brief 删除一个链表节点通过将prev/next节点指向对方
 * @note 只有在我们知道prev/next节点的情况下，才能使用该函数
 * 进行操作
 */
static inline void __list_del(struct list_head *prev, struct list_head *next)
{
  next->prev = prev;
  prev->next = next;
}

// 一个垃圾地址，访问这里会触发panic，防止使用无效的entry
#define LIST_POISON ((struct list_head *)0x0505050505)

/**
 * @brief 将entry从链表中删除
 * @param entry 需要从链表中删除的节点
 * @note list_empty()不会对被删除节点返回true,
 * 该节点处于已失效状态。
 */
static inline void list_del(struct list_head *entry)
{
  __list_del(entry->prev, entry->next);
  entry->next = LIST_POISON;
  entry->prev = LIST_POISON;
}

static inline bool list_empty(const struct list_head *head)
{
  return head->next == head;
}

#endif
