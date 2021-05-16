#include "types.hpp"
#include "driver/utils.hpp"

void set_bit(volatile uint32_t *bits, uint32_t mask, uint32_t value)
{
    uint32_t org = (*bits) & ~mask;
    *bits = org | (value & mask);
}

void set_bit_offset(volatile uint32_t *bits, uint32_t mask, uint64_t offset, uint32_t value)
{
    set_bit(bits, mask << offset, value << offset);
}

void set_gpio_bit(volatile uint32_t *bits, uint64_t offset, uint32_t value)
{
    set_bit_offset(bits, 1, offset, value);
}

uint32_t get_bit(volatile uint32_t *bits, uint32_t mask, uint64_t offset)
{
    return ((*bits) & (mask << offset)) >> offset;
}

uint32_t get_gpio_bit(volatile uint32_t *bits, uint64_t offset)
{
    return get_bit(bits, 1, offset);
}
