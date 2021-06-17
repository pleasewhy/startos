#ifndef _STL_ITERATOR_HPP
#define _STL_ITERATOR_HPP
#include "type_traits.hpp"
// 这个文件定义了迭代器的基本结构体
namespace std {

/**
 *  @defgroup iterator_tags Iterator Tags
 *  These are empty types, used to distinguish different iterators.  The
 *  distinction is not made by what they contain, but simply by what they
 *  are.  Different underlying algorithms can then be used based on the
 *  different operations supported by different iterator types.
 */
/**
 *  @defgroup iterator tags
 *  这些结构体是空的，它用于标识不同的迭代器.
 */

/// 输入迭代器
struct input_iterator_tag
{
};

/// 输出迭代器
struct output_iterator_tag
{
};

/// 前向迭代器：支持一些输入迭代器没有的操作
struct forward_iterator_tag : public input_iterator_tag
{
};

/// Bidirectional iterators support a superset of forward iterator
/// operations.
/// 双向迭代器：支持一些前向迭代器没有的操作
struct bidirectional_iterator_tag : public forward_iterator_tag
{
};

/// 随机访问迭代器：支持一些双向迭代器没有操作
struct random_access_iterator_tag : public bidirectional_iterator_tag
{
};

/**
 *  @brief  通用iterator类.
 *
 *  这个类只是简单的定义了一些内置的类型，不涉及任何功能。
 *  这些类型是是大多数迭代器都具有的，所以可以抽离出来作
 *  为基类，从而避免做重复的事情。
 *
 */
typedef long int ptrdiff_t;

template <typename _Category,
          typename _Tp,
          typename _Distance = ptrdiff_t,
          typename _Pointer = _Tp *,
          typename _Reference = _Tp &>
struct iterator
{
  /// 迭代器的类型：iterator_tags的一种
  typedef _Category iterator_category;
  /// 值类型
  typedef _Tp value_type;
  /// 值类型对应的距离类型
  typedef _Distance difference_type;
  /// 值类型的指针
  typedef _Pointer pointer;
  /// 值类型的引用类型
  typedef _Reference reference;
};

// /**
//  *  @brief  迭代器Traits类.
//  *
//  *  This class does nothing but define nested typedefs.  The general
//  *  version simply @a forwards the nested typedefs from the Iterator
//  *  argument.  Specialized versions for pointers and pointers-to-const
//  *  provide tighter, more correct semantics.
//  */

// template <typename _Iterator, typename = __void_t<>>
// struct __iterator_traits
// {
// };

// template <typename _Iterator>
// struct __iterator_traits<_Iterator,
//                          __void_t<typename _Iterator::iterator_category,
//                                   typename _Iterator::value_type,
//                                   typename _Iterator::difference_type,
//                                   typename _Iterator::pointer,
//                                   typename _Iterator::reference>>
// {
//   typedef typename _Iterator::iterator_category iterator_category;
//   typedef typename _Iterator::value_type        value_type;
//   typedef typename _Iterator::difference_type   difference_type;
//   typedef typename _Iterator::pointer           pointer;
//   typedef typename _Iterator::reference         reference;
// };

// template <typename _Iterator>
// struct iterator_traits : public __iterator_traits<_Iterator>
// {
// };
// /// Partial specialization for pointer types.
// template <typename _Tp>
// struct iterator_traits<_Tp *>
// {
//   typedef random_access_iterator_tag iterator_category;
//   typedef _Tp                        value_type;
//   typedef ptrdiff_t                  difference_type;
//   typedef _Tp *                      pointer;
//   typedef _Tp &                      reference;
// };

// /// Partial specialization for const pointer types.
// template <typename _Tp>
// struct iterator_traits<const _Tp *>
// {
//   typedef random_access_iterator_tag iterator_category;
//   typedef _Tp                        value_type;
//   typedef ptrdiff_t                  difference_type;
//   typedef const _Tp *                pointer;
//   typedef const _Tp &                reference;
// };

}  // namespace std
#endif