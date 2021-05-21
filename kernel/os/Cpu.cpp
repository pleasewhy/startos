#include "os/Cpu.hpp"
#include "common/string.hpp"
#include "common/printk.hpp"

extern "C" Cpu cpus[];  // cpu数组，定义在boot/main.c

void Cpu::init() {
  // memset(cpus, 0, sizeof(Cpu) * NCPU);
  this->intr_enable = false;
  this->noff = 0;
}

int Cpu::cpuid() {
  int id = r_tp();
  return id;
}

Cpu *Cpu::mycpu() {
  int id = cpuid();
  Cpu *c = &cpus[id];
  return c;
}