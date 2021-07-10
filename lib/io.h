#ifndef STARTOS_IO_HPP
#  include "types.h"
struct iovec
{
  void * iov_base; /* Starting address */
  size_t iov_len;  /* Number of bytes to transfer */
};
#endif