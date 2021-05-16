#ifndef DISK_HPP
#define DISK_HPP
#include "fs/inodefs/BufferLayer.hpp"
void disk_init(void);

void disk_read(struct buf *b);

void disk_write(struct buf *b);

void disk_intr(void);
#endif