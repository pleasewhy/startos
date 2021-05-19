#ifndef PIPE_HPP
#define PIPE_HPP
#include "fs/Pipe.hpp"
#include "os/SpinLock.hpp"
#define PIPESIZE 512

class Pipe {
 private:
  bool readopen;
  bool writeopen;
  uint_t nwrite;
  uint_t nread;
  SpinLock lock_;
  char data[PIPESIZE];

 public:
  enum EndType { READ_END, WRITE_END };

 public:
  Pipe(struct file *f0, struct file *f1);
  // ~Pipe();
  int read(uint64_t addr, int n);
  int write(uint64_t addr, int n);
  void close(EndType ty);
};
#endif
