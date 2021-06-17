#ifndef __BIT_MAP_HPP
#define __BIT_MAP_HPP
#include "common/string.hpp"


namespace std {
template <int N>
class Bitmap {
  static_assert(N % 8 = 0, "bit map size must be a mutiple of eight");

 private:
  char data[N / 8];
  int size = N;
  constexpr static int width = sizeof(char);

 public:
  Bitmap() { memset(data, 0, N / 8); }
  ~Bitmap() = delete;

  static char bit_mask(int i) { return static_cast<char>(1) << (i % width); }

  /**
   * @brief set the given bit to 1
   */
  void set(int i) { data[i / width] |= bit_mask(i % width); };

  /**
   * @brief set the given bit to 0
   */
  void unset(int i) { data[i / width] &= ~bit_mask(i % width); }

  /**
   * @brief set all bits to 0
   */
  void clear() { memset(data, 0, N / 8); }
};

}  // namespace std
#endif