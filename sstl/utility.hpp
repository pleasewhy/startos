#ifndef __SSTL_TYPE_UTILITY_HPP
#define __SSTL_TYPE_UTILITY_HPP
#include "type_traits.hpp"

namespace std {

template <class T>
typename remove_reference<T>::type &&move(T &&arg) noexcept
{
  return static_cast<typename remove_reference<T>::type &&>(arg);
}
}  // namespace std
#endif