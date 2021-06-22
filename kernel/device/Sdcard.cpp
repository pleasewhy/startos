
#include "device/SdCard.hpp"

#include "common/printk.hpp"
#include "common/string.hpp"
#include "driver/dmac.hpp"
#include "driver/gpiohs.hpp"
#include "driver/spi.hpp"
#include "os/SpinLock.hpp"
#include "riscv.hpp"
#include "types.hpp"

#define BSIZE 512
namespace dev {
void SD_CS_HIGH(void)
{
  gpiohs_set_pin(7, GPIO_PV_HIGH);
}

void SD_CS_LOW(void)
{
  gpiohs_set_pin(7, GPIO_PV_LOW);
}

void SD_HIGH_SPEED_ENABLE(void)
{
  // spi_set_clk_rate(SPI_DEVICE_0, 10000000);
}

static void sd_lowlevel_init(uint8_t spi_index)
{
  gpiohs_set_drive_mode(7, GPIO_DM_OUTPUT);
  // spi_set_clk_rate(SPI_DEVICE_0, 200000);     /*set clk rate*/
}

// #define SPI_CHIP_SELECT_0
static void sd_write_data(uint8_t const *data_buff, uint32_t length)
{
  spi_init(SPI_DEVICE_0, SPI_WORK_MODE_0, SPI_FF_STANDARD, 8, 0);
  spi_send_data_standard(SPI_DEVICE_0, SPI_CHIP_SELECT_3, NULL, 0, data_buff,
                         length);
}

static void sd_read_data(uint8_t *data_buff, uint32_t length)
{
  spi_init(SPI_DEVICE_0, SPI_WORK_MODE_0, SPI_FF_STANDARD, 8, 0);
  spi_receive_data_standard(SPI_DEVICE_0, SPI_CHIP_SELECT_3, NULL, 0, data_buff,
                            length);
}

static void sd_write_data_dma(uint8_t const *data_buff, uint32_t length)
{
  spi_init(SPI_DEVICE_0, SPI_WORK_MODE_0, SPI_FF_STANDARD, 8, 0);
  spi_send_data_standard_dma(DMAC_CHANNEL0, SPI_DEVICE_0, SPI_CHIP_SELECT_3,
                             NULL, 0, data_buff, length);
}

static void sd_read_data_dma(uint8_t *data_buff, uint32_t length)
{
  spi_init(SPI_DEVICE_0, SPI_WORK_MODE_0, SPI_FF_STANDARD, 8, 0);
  spi_receive_data_standard_dma((dmac_channel_number_t)-1, DMAC_CHANNEL0,
                                SPI_DEVICE_0, SPI_CHIP_SELECT_3, NULL, 0,
                                data_buff, length);
}

/*
 * @brief  Send 5 bytes command to the SD card.
 * @param  Cmd: The user expected command to send to SD card.
 * @param  Arg: The command argument.
 * @param  Crc: The CRC.
 * @retval None
 */
static void sd_send_cmd(uint8_t cmd, uint32_t arg, uint8_t crc)
{
  uint8_t frame[6];
  frame[0] = (cmd | 0x40);
  frame[1] = (uint8_t)(arg >> 24);
  frame[2] = (uint8_t)(arg >> 16);
  frame[3] = (uint8_t)(arg >> 8);
  frame[4] = (uint8_t)(arg);
  frame[5] = (crc);
  SD_CS_LOW();
  sd_write_data(frame, 6);
}

static void sd_end_cmd(void)
{
  uint8_t frame[1] = {0xFF};
  /*!< SD chip select high */
  SD_CS_HIGH();
  /*!< Send the Cmd bytes */
  sd_write_data(frame, 1);
}

/*
 * Be noticed: all commands & responses below
 * 		are in SPI mode format. May differ from
 * 		what they are in SD mode.
 */

#define SD_CMD0 0
#define SD_CMD8 8
#define SD_CMD58 58   // READ_OCR
#define SD_CMD55 55   // APP_CMD
#define SD_ACMD41 41  // SD_SEND_OP_COND
#define SD_CMD16 16   // SET_BLOCK_SIZE
#define SD_CMD17 17   // READ_SINGLE_BLOCK
#define SD_CMD24 24   // WRITE_SINGLE_BLOCK
#define SD_CMD13 13   // SEND_STATUS

/*
 * Read sdcard response in R1 type.
 */
static uint8_t sd_get_response_R1(void)
{
  uint8_t  result;
  uint16_t timeout = 0xff;

  while (timeout--) {
    sd_read_data(&result, 1);
    if (result != 0xff)
      return result;
  }

  // timeout!
  return 0xff;
}

/*
 * Read the rest of R3 response
 * Be noticed: frame should be at least 4-byte long
 */
static void sd_get_response_R3_rest(uint8_t *frame)
{
  sd_read_data(frame, 4);
}

/*
 * Read the rest of R7 response
 * Be noticed: frame should be at least 4-byte long
 */
static void sd_get_response_R7_rest(uint8_t *frame)
{
  sd_read_data(frame, 4);
}

static int switch_to_SPI_mode(void)
{
  int timeout = 0xff;

  while (--timeout) {
    sd_send_cmd(SD_CMD0, 0, 0x95);
    uint64_t result = sd_get_response_R1();
    sd_end_cmd();

    if (0x01 == result)
      break;
  }
  if (0 == timeout) {
    printf("SD_CMD0 failed\n");
    return 0xff;
  }

  return 0;
}

// verify supply voltage range
static int verify_operation_condition(void)
{
  uint64_t result;

  // Stores the response reversely.
  // That means
  // frame[2] - VCA
  // frame[3] - Check Pattern
  uint8_t frame[4];

  sd_send_cmd(SD_CMD8, 0x01aa, 0x87);
  result = sd_get_response_R1();
  sd_get_response_R7_rest(frame);
  sd_end_cmd();

  if (0x09 == result) {
    printf("invalid CRC for CMD8\n");
    return 0xff;
  }
  else if (0x01 == result && 0x01 == (frame[2] & 0x0f) && 0xaa == frame[3]) {
    return 0x00;
  }

  printf("verify_operation_condition() fail!\n");
  return 0xff;
}

// read OCR register to check if the voltage range is valid
// this step is not mandotary, but I advise to use it
static int read_OCR(void)
{
  uint64_t result = 0;
  uint8_t  ocr[4];

  int timeout;

  timeout = 0xff;
  while (--timeout) {
    sd_send_cmd(SD_CMD58, 0, 0);
    result = sd_get_response_R1();
    sd_get_response_R3_rest(ocr);
    sd_end_cmd();

    if (0x01 == result &&                   // R1 response in idle status
        (ocr[1] & 0x1f) && (ocr[2] & 0x80)  // voltage range valid
    ) {
      return 0;
    }
  }

  // timeout!
  printf("read_OCR() timeout!\n");
  printf("result = %d\n", result);
  return 0xff;
}

// send ACMD41 to tell sdcard to finish initializing
static int set_SDXC_capacity(void)
{
  uint8_t result = 0xff;

  int timeout = 0xfff;
  while (--timeout) {
    sd_send_cmd(SD_CMD55, 0, 0);
    result = sd_get_response_R1();
    sd_end_cmd();
    if (0x01 != result) {
      printf("SD_CMD55 fail! result = %d\n", result);
      return 0xff;
    }

    sd_send_cmd(SD_ACMD41, 0x40000000, 0);
    result = sd_get_response_R1();
    sd_end_cmd();
    if (0 == result) {
      return 0;
    }
  }

  // timeout!
  printf("set_SDXC_capacity() timeout!\n");
  printf("result = %d\n", result);
  return 0xff;
}

// Used to differ whether sdcard is SDSC type.
static int is_standard_sd = 0;

// check OCR register to see the type of sdcard,
// thus determine whether block size is suitable to buffer size
static int check_block_size(void)
{
  uint8_t result = 0xff;
  uint8_t ocr[4];

  int timeout = 0xff;
  while (timeout--) {
    sd_send_cmd(SD_CMD58, 0, 0);
    result = sd_get_response_R1();
    sd_get_response_R3_rest(ocr);
    sd_end_cmd();

    if (0 == result) {
      if (ocr[0] & 0x40) {
        printf("SDHC/SDXC detected\n");
        if (512 != BSIZE) {
          printf("BSIZE != 512\n");
          return 0xff;
        }

        is_standard_sd = 0;
      }
      else {
        printf("SDSC detected, setting block size\n");

        // setting SD card block size to BSIZE
        int timeout = 0xff;
        int result = 0xff;
        while (--timeout) {
          sd_send_cmd(SD_CMD16, BSIZE, 0);
          result = sd_get_response_R1();
          sd_end_cmd();

          if (0 == result)
            break;
        }
        if (0 == timeout) {
          printf("check_OCR(): fail to set block size");
          return 0xff;
        }

        is_standard_sd = 1;
      }

      return 0;
    }
  }

  // timeout!
  printf("check_OCR() timeout!\n");
  printf("result = %d\n", result);
  return 0xff;
}

/*
 * @brief  Initializes the SD/SD communication.
 * @param  None
 * @retval The SD Response:
 *         - 0xFF: Sequence failed
 *         - 0: Sequence succeed
 */
static int sd_init(void)
{
  uint8_t frame[10];

  sd_lowlevel_init(0);
  // SD_CS_HIGH();
  SD_CS_LOW();

  // send dummy bytes for 80 clock cycles
  for (int i = 0; i < 10; i++)
    frame[i] = 0xff;
  sd_write_data(frame, 10);

  if (0 != switch_to_SPI_mode())
    return 0xff;
  if (0 != verify_operation_condition())
    return 0xff;
  if (0 != read_OCR())
    return 0xff;
  if (0 != set_SDXC_capacity())
    return 0xff;
  if (0 != check_block_size())
    return 0xff;

  return 0;
}

SdCard::SdCard(const char *name)
{
  memset(this->name, 0, DEV_NAME_SIZE);
  strncpy(this->name, name, strlen(name));
}

void SdCard::init()
{
  int result = sd_init();
  // initsleeplock(&sdcard_lock, "sdcard");
  this->sleepLock.init("sdcard");

  if (0 != result) {
    panic("sdcard_init failed");
  }
}

void SdCard::sdcard_read_sector(char *buf, int sectorno)
{
  uint8_t  result;
  uint32_t address;
  uint8_t  dummy_crc[2];
  memset(buf, 0, 512);
#ifdef DEBUG
  printf("sdcard_read_sector()\n");
#endif

  if (is_standard_sd) {
    address = sectorno << 9;
  }
  else {
    address = sectorno;
  }

  // enter critical section!
  // acquiresleep(&sdcard_lock);
  this->sleepLock.lock();

  sd_send_cmd(SD_CMD17, address, 0);
  result = sd_get_response_R1();

  if (0 != result) {
    // releasesleep(&sdcard_lock);
    this->sleepLock.unlock();
    panic("sdcard: fail to read");
  }

  int timeout = 0xffffff;
  while (--timeout) {
    sd_read_data(&result, 1);
    if (0xfe == result)
      break;
  }
  if (0 == timeout) {
    panic("sdcard: timeout waiting for reading");
  }
  sd_read_data_dma(reinterpret_cast<uint8_t *>(buf), BSIZE);
  sd_read_data(dummy_crc, 2);

  sd_end_cmd();
  this->sleepLock.unlock();
  // leave critical section!
}

void SdCard::sdcard_write_sector(char *buf, int sectorno)
{
  uint32_t             address;
  static uint8_t const START_BLOCK_TOKEN = 0xfe;
  uint8_t              dummy_crc[2] = {0xff, 0xff};
#ifdef DEBUG
  printf("sdcard_write_sector()\n");
#endif

  if (is_standard_sd) {
    address = sectorno << 9;
  }
  else {
    address = sectorno;
  }

  // enter critical section!
  // acquiresleep(&sdcard_lock);
  this->sleepLock.lock();

  sd_send_cmd(SD_CMD24, address, 0);
  if (0 != sd_get_response_R1()) {
    // releasesleep(&sdcard_lock);
    this->sleepLock.unlock();
    panic("sdcard: fail to write");
  }

  // sending data to be written
  sd_write_data(&START_BLOCK_TOKEN, 1);
  sd_write_data_dma(reinterpret_cast<uint8_t *>(buf), BSIZE);
  sd_write_data(dummy_crc, 2);

  // waiting for sdcard to finish programming
  uint8_t result;
  int     timeout = 0xfff;
  while (--timeout) {
    sd_read_data(&result, 1);
    if (0x05 == (result & 0x1f)) {
      break;
    }
  }
  if (0 == timeout) {
    // releasesleep(&sdcard_lock);
    this->sleepLock.unlock();
    panic("sdcard: invalid response token");
  }

  timeout = 0xffffff;
  while (--timeout) {
    sd_read_data(&result, 1);
    if (0 != result)
      break;
  }
  if (0 == timeout) {
    // releasesleep(&sdcard_lock);
    this->sleepLock.unlock();
    panic("sdcard: timeout waiting for response");
  }
  sd_end_cmd();

  // send SD_CMD13 to check if writing is correctly done
  uint8_t error_code = 0xff;
  sd_send_cmd(SD_CMD13, 0, 0);
  result = sd_get_response_R1();
  sd_read_data(&error_code, 1);
  sd_end_cmd();
  if (0 != result || 0 != error_code) {
    // releasesleep(&sdcard_lock);
    this->sleepLock.unlock();
    printf("result: %x\n", result);
    printf("error_code: %x\n", error_code);
    panic("sdcard: an error occurs when writing");
  }

  this->sleepLock.unlock();
  // leave critical section!
}

int SdCard::read(char *buf, int offset, int n)
{
  if (512 != n || 0 != offset % 512) {
    return -1;
  }
  int sector = offset / 512;
  this->sdcard_read_sector(buf, sector);
  return 512;
}

int SdCard::write(char *buf, int offset, int n)
{
  if (512 != n || 0 != offset % 512) {
    return -1;
  }
  int sector = offset / 512;
  this->sdcard_write_sector(buf, sector);
  return 512;
}
}  // namespace dev
