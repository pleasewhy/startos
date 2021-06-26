#ifndef _SSTL_LIST_HPP
#define _SSTL_LIST_HPP
#include <os/SpinLock.hpp>
#include "iterator.hpp"
#include "type_traits.hpp"
#include "utility.hpp"

namespace std {

template <typename T>
struct ListIterator;

template <typename T>
struct ListNode
{
  static_assert(std::is_pointer<T>::value, "HashMapNode只支持指针");
  struct ListNode *next;
  T                data;
  ListNode() = default;
  ListNode(const T &data) : next(nullptr), data(data) {}
  ListNode(const ListNode &node) : data(node.data), next(node.next) {}
};

template <typename T>  // 数据类型
struct list
{
  typedef struct ListNode<T> Node;

  list()
  {
    spinlock_.init("list");
    // head_.next == nullptr; // 编译器报错not affect
    memset(&head_.next, 0, sizeof(&head_.next));
    sz_ = 0;
  }

  ~list()
  {
    Node *now = head_.next;
    Node *tmp;
    while (now != nullptr) {
      tmp = now;
      now = now->next;
      delete tmp;
    }
  }

  // void insert(T data)
  // {
  //   Node *n = new Node(data);
  //   spinlock_.lock();
  //   n->next = head_.next;
  //   head_.next = n;
  //   sz_++;
  //   spinlock_.unlock();
  // }

    void insert(T&& data)
  {
    Node *n = new Node(data);
    spinlock_.lock();
    n->next = head_.next;
    head_.next = n;
    sz_++;
    spinlock_.unlock();
  }

  ListIterator<T> begin()
  {
    return ListIterator<T>(head_.next, this);
  }

private:
  SpinLock spinlock_;
  Node     head_;
  int      sz_;
};

template <typename T>
struct ListIterator : public std::iterator<std::forward_iterator_tag, T>
{
  typedef struct list<T>         list_type;
  typedef struct ListNode<T> *   node_ptr;
  typedef struct ListNode<T> &   node_reference;
  typedef struct ListIterator<T> iterator;
  typedef list_type *            contain_ptr;
  typedef const node_ptr         const_node_ptr;
  typedef const contain_ptr      const_contain_ptr;

  typedef size_t    size_type;
  typedef ptrdiff_t difference_type;

  node_ptr    node_;  // 迭代器当前所指节点
  contain_ptr list_;  // 保持与容器的连结

  ListIterator() = default;

  ListIterator(node_ptr n, contain_ptr t)
  {
    node_ = n;
    list_ = t;
  }

  iterator &operator=(const iterator &rhs)
  {
    if (this != &rhs) {
      node_ = rhs.node_;
      list_ = rhs.list_;
    }
    return *this;
  }

  // 重载操作符
  bool operator==(const node_ptr ptr) const
  {
    return node_ == ptr;
  }

  bool operator!=(const node_ptr ptr) const
  {
    return node_ != ptr;
  }

  node_reference operator*() const
  {
    return *node_;
  }

  node_ptr operator->() const
  {
    return &(operator*());
  }

  iterator &operator++()  // 前缀:++i
  {
    node_ = node_->next;
    return *this;
  }

  iterator operator++(int)  // 后缀:i++
  {
    iterator tmp = *this;
    ++*this;
    return tmp;
  }
};
}  // namespace std
#endif