#ifndef __SSTL_TYPE_TRAITS_HPP
#define __SSTL_TYPE_TRAITS_HPP
namespace std {
/// integral_constant
template <typename _Tp, _Tp __v>
struct integral_constant
{
  static constexpr _Tp                value = __v;
  typedef _Tp                         value_type;
  typedef integral_constant<_Tp, __v> type;
  constexpr                           operator value_type() const noexcept
  {
    return value;
  }
  constexpr value_type operator()() const noexcept
  {
    return value;
  }
};

// __void_t (std::void_t for C++11)
template <typename...>
using __void_t = void;

// 用于编译时判断类型
typedef integral_constant<bool, true> true_type;

// 用于编译时判断类型
typedef integral_constant<bool, false> false_type;

/// remove_const
template <typename _Tp>
struct remove_const
{
  typedef _Tp type;
};

template <typename _Tp>
struct remove_const<_Tp const>
{
  typedef _Tp type;
};

/// remove_volatile
template <typename _Tp>
struct remove_volatile
{
  typedef _Tp type;
};

template <typename _Tp>
struct remove_volatile<_Tp volatile>
{
  typedef _Tp type;
};

/// remove_cv
template <typename _Tp>
struct remove_cv
{
  typedef typename remove_const<typename remove_volatile<_Tp>::type>::type type;
};

template <typename>
struct __is_pointer_helper : public false_type
{
};

template <typename _Tp>
struct __is_pointer_helper<_Tp *> : public true_type
{
};

/// is_pointer
template <typename _Tp>
struct is_pointer
    : public __is_pointer_helper<typename remove_cv<_Tp>::type>::type
{
};
}  // namespace std
#endif