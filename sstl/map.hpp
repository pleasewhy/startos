#ifndef _STL_MAP_HPP
#define _STL_MAP_HPP
#include "common/printk.hpp"
#include "common/string.hpp"
#include "os/SpinLock.hpp"
#include "type_traits.hpp"
#include "iterator.hpp"

// #include <type_traits>
namespace std {

/* 2^31 + 2^29 - 2^25 + 2^22 - 2^19 - 2^16 + 1 */
#define GOLDEN_RATIO_PRIME_32 0x9e370001UL
/*  2^63 + 2^61 - 2^57 + 2^54 - 2^51 - 2^18 + 1 */
#define GOLDEN_RATIO_PRIME_64 0x9e37fffffffc0001UL

#define hash_long(val, bits) hash_64(val, bits)
#define GOLDEN_RATIO_PRIME GOLDEN_RATIO_PRIME_64

static inline uint64_t hash_64(uint64_t val, uint_t bits)
{
  uint64_t hash = val;
  uint64_t n = hash;
  n <<= 18;
  hash -= n;
  n <<= 33;
  hash -= n;
  n <<= 3;
  hash += n;
  n <<= 3;
  hash -= n;
  n <<= 4;
  hash += n;
  n <<= 2;
  hash += n;

  // 高位随机程度更大
  return hash >> (64 - bits);
}

static inline unsigned long hash_ptr(void *ptr, uint_t bits)
{
  return hash_64((unsigned long)ptr, bits);
}

template <typename K, typename V>
struct MapIterator;

template <typename K, typename V>
struct HashMapNode
{
  static_assert(std::is_pointer<V>::value, "HashMapNode只支持指针");
  HashMapNode<K, V> *next;

  K key;
  V val;
  HashMapNode() = default;
  HashMapNode(const K &key, const V &val) : next(nullptr), key(key), val(val) {}
  HashMapNode(const HashMapNode &node)
      : next(node.next), val(node.val), key(node.key)
  {
  }
  // hashtable_node(hashtable_node &&node)
  //     : next(node.next), value(mystl::move(node.value))
  // {
  //   node.next = nullptr;
  // }
};

/**
 * @brief hashmap的简要实现
 * @note 该实现使用spinlock来保证并发安全，由于
 * spinlock只能在内核中使用，所以它只能在内核中
 * 测试. 另外它使用最简单的开链法解决冲突。
 *
 * @note 该实现不允许put一个已存在的key。
 */
template <typename K, typename V>
class map {
  friend MapIterator<K, V>;

public:
  typedef struct HashMapNode<K, V> Node;

public:
  map() = delete;
  /**
   * @brief Construct a new map object
   *
   * @param order 用2^order作为散列表的长度
   */
  map(uint_t order) : bits_(order)
  {
    this->num_bucket_ = 1 << order;
    this->hashtable_ = new Node *[(1 << order)];
    memset(this->hashtable_, 0, (1 << order) * sizeof(Node *));
    spinlock_.init("hash map");
  }
  ~map() = default;

  /**
   * @brief 将(key, val)键值对添加到哈希表中
   * @return 返回key对应的hash值
   */
  void put(K key, V val)
  {
    // LOG_WARN("put key=%d", key);
    spinlock_.lock();
    uint64_t h = hash(key);
    Node *   node = hashtable_[h];
    while (node != nullptr && node->key != key) {
      node = node->next;
    }
    if (node != nullptr) {
      panic("hash map put");
      node->val = val;
    }
    Node *putval = new Node(key, val);
    putval->next = hashtable_[h];
    hashtable_[h] = putval;
    spinlock_.unlock();
  }

  /**
   * @brief 获取key对应的val
   */
  V get(K key)
  {
    spinlock_.lock();
    uint64_t h = hash(key);
    Node *   node = hashtable_[h];
    while (node != nullptr && node->key != key) {
      node = node->next;
    }
    spinlock_.unlock();
    return node == nullptr ? NULL : node->val;
  }

  /**
   * @brief 删除key对应的键值对,并返回对应的val。
   */
  V poll(K key)
  {
    spinlock_.lock();
    uint64_t h = hash(key);
    Node *   dummy = new Node;
    Node *   head = hashtable_[h];
    // LOG_WARN("poll key=%d", key);
    if (head == nullptr) {
      LOG_WARN("poll error: key=%d", key);
      panic("poll");
    }
    Node *node = head;
    dummy->next = node;

    while (node->next != nullptr && node->key != key) {
      dummy = node;
      node = node->next;
    }
    if (node == nullptr) {
      return nullptr;
    }

    dummy->next = node->next;
    V v = node->val;
    if (head == node) {
      hashtable_[h] = node->next;
    }
    spinlock_.unlock();
    delete node;
    return v;
  }

  MapIterator<K, V> begin()
  {
    for (int i = 0; i < num_bucket_; i++) {
      if (hashtable_[i] != nullptr) {
        return MapIterator<K, V>(hashtable_[i], this);
      }
    }
    return MapIterator<K, V>(nullptr, this);
  }

  /**
   * @brief 获取当前map中元素的数量
   */
  size_t size()
  {
    return sz_;
  }

  // // 重载运算符
  // V operator[](K key) {
  //   return
  // }

private:
  uint_t hash(K key)
  {
    return hash_64(key, bits_ - 1);
  }

private:
  Node **  hashtable_;
  SpinLock spinlock_;
  uint_t   bits_;
  size_t   sz_;  // 元素个数
  size_t   num_bucket_;
};

template <typename K, typename V>
struct MapIterator : public std::iterator<std::forward_iterator_tag, V>
{
  typedef map<K, V>          map_type;
  typedef HashMapNode<K, V> *node_ptr;
  typedef HashMapNode<K, V> &node_reference;
  typedef MapIterator<K, V>  iterator;
  typedef map_type *         contain_ptr;
  typedef const node_ptr     const_node_ptr;
  typedef const contain_ptr  const_contain_ptr;

  typedef size_t    size_type;
  typedef ptrdiff_t difference_type;

public:
  MapIterator() = default;

  MapIterator(node_ptr n, contain_ptr t)
  {
    node_ = n;
    map_ = t;
  }

  iterator &operator=(const iterator &rhs)
  {
    if (this != &rhs) {
      node_ = rhs.node_;
      map_ = rhs.map_;
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
    const node_ptr old = node_;
    node_ = node_->next;
    if (node_ == nullptr) {  // 如果下一个位置为空，跳到下一个 bucket 的起始处
      int index = map_->hash(old->key);
      while (!node_ && ++index < map_->num_bucket_)
        node_ = map_->hashtable_[index];
    }
    return *this;
  }

  iterator operator++(int)  // 后缀:i++
  {
    iterator tmp = *this;
    ++*this;
    return tmp;
  }

private:
  node_ptr    node_;  // 迭代器当前所指节点
  contain_ptr map_;   // 保持与容器的连结
};
}  // namespace std
#endif