#include "StartOS.hpp"
#include "common/logger.h"
#include "common/printk.hpp"
#include "common/string.hpp"
#include "file.h"
#include "fs/fat/Fat32.hpp"
#include "fs/fat/thinternal.h"
#include "fs/vfs/Vfs.hpp"
#include "os/TaskScheduler.hpp"
#include "types.hpp"
#include "fcntl.h"
#include "os/SleepLock.hpp"

#define SECTOR_SIZE 512

SleepLock sleep_lock;  // 用于控制并发访问

void Fat32FileSystem::init()
{
  LOG_DEBUG("fat32 init");
  sleep_lock.init("fat32");
  if (tf_init() != 0) {
    panic("fat32 init");
  }
}

int Fat32FileSystem::open(const char *filePath, uint64_t flags, struct file *fp)
{
  sleep_lock.lock();
  TFFile *tf = NULL;
  if (flags & O_CREATE) {
    tf = tf_fopen(filePath, "w");
  }
  else {
    LOG_DEBUG("open flag r");
    tf = tf_fopen(filePath, "r");
    // LOG_DEBUG("tf=%s", tf->filename);
  }
  // LOG_INFO("tf=%p flags=%x", tf, flags);
  if (tf == nullptr && flags == O_DIRECTORY) {
    tf_mkdir(filePath, 0);
    tf = tf_fopen(filePath, "r");
  }
  if (tf == nullptr) {
    sleep_lock.unlock();
    return -1;
  }
  // 若flags包含O_DIRECTORY,且path为文件类型，应该打开失败
  if (flags == O_DIRECTORY && !(tf->attributes & TF_ATTR_DIRECTORY)) {
    tf_fclose(tf);
    sleep_lock.unlock();
    return -1;
  }
  fp->size = tf->size;
  fp->type = fp->FD_ENTRY;
  if (tf->attributes & TF_ATTR_DIRECTORY) {
    fp->directory = true;
  }
  else {
    fp->directory = false;
  }
  tf_fclose(tf);
  sleep_lock.unlock();
  return 0;
}

int Fat32FileSystem::mkdir(const char *filepath)
{
  sleep_lock.lock();
  int code = tf_mkdir(filepath, 0);
  sleep_lock.unlock();
  return code;
}

size_t
Fat32FileSystem::read(const char *path, bool user, char *buf, int offset, int n)
{
  sleep_lock.lock();
  // LOG_DEBUG("read filepath=%s", path);
  TFFile *fp = tf_fopen(path, "r");

  if (fp == NULL) {
    sleep_lock.unlock();
    return -1;
  }
  if (offset >= fp->size) {
    return 0;
  }
  tf_fseek(fp, 0, offset);
  int x = tf_fread(buf, n, fp, user);
  tf_fclose(fp);
  sleep_lock.unlock();
  return x;
}

size_t Fat32FileSystem::write(
    const char *path, bool user, const char *buf, int offset, int n)
{
  sleep_lock.lock();
  TFFile *fp = tf_fopen(path, "+");
  tf_fseek(fp, 0, offset);
  int x = tf_fwrite(buf, n, fp, user);
  tf_fclose(fp);
  sleep_lock.unlock();
  return x;
}

size_t Fat32FileSystem::clear(const char *filepath,
                              size_t      count,
                              size_t      offset,
                              size_t &    written)
{
  return 0;
}

size_t Fat32FileSystem::truncate(const char *filepath, size_t size)
{
  return 0;
}

int Fat32FileSystem::get_file(const char *filepath, struct file *fp)
{
  TFFile *tf = tf_fopen(filepath, "r");
  if (tf == NULL) {
    return -1;
  }
  fp->size = tf->size;
  fp->type = fp->FD_ENTRY;
  tf_fclose(tf);
  return NULL;
}

size_t Fat32FileSystem::touch(const char *filepath)
{
  tf_create((char *)filepath);
  return 0;
}

size_t Fat32FileSystem::rm(const char *filepath)
{
  tf_remove((char *)filepath);
  return 0;
}

static int copysfn(char *sfn, char *dst, bool user)
{
  int n = 0, i = 0;
  // 计算文件名的长度
  for (i = 0; i < 8 && sfn[i] != 0x20; i++) {
    n++;
  }
  either_copyout(user, reinterpret_cast<uint64_t>(dst), sfn, i);
  // 计算扩展名的长度
  for (i = 8; i < 11 && sfn[i] != 0x20; i++) {}
  // 扩展名为空
  if (i == 8) {
    return n;
  }
  either_copyout(user, reinterpret_cast<uint64_t>(dst + n), (void *)".", 1);
  n += 1;
  either_copyout(user, reinterpret_cast<uint64_t>(dst + n), sfn + 8, i - 8);
  return n + i - 8;
}

// fat32长文件目录项的文件名的储存格式为unicode
// 其宽度为2, 为了方便处理将所有的Unicode都装换为
// 单字节格式
static int copylfn(FatFileEntry &entry, uint64_t dst, bool user)
{
  int sno = entry.lfn.sequence_number & ~0x40;

  // 通过长文件名目录项的序列号，计算当前lfn的name偏移量
  int offset = 13 * (sno - 1);
  // 复制第一部分1-5字节, unincode编码，0xff为空
  int i = 0, n = 0;
  // note:
  // uint16_t *name = entry.lfn.name1;
  // 通过name[i]这种方式进行访问会LoadMisaligned
  //
  // printf("size=%d", NELEM(entry.lfn.name1));
  char tmp[10];
  for (i = 0; i < NELEM(entry.lfn.name1) && entry.lfn.name1[i] != 0xffff; i++) {
    tmp[i] = entry.lfn.name1[i] & 0xff;
  }
  // printf("name1=%d", i);
  if (either_copyout(user, dst + offset, tmp, i) < 0) {
    panic("either copyout");
  }
  n += i;
  // 6-11
  // name = entry.lfn.name2;
  for (i = 0; i < NELEM(entry.lfn.name2) && entry.lfn.name2[i] != 0xffff; i++) {
    tmp[i] = entry.lfn.name2[i] & 0xff;
  }
  // printf("name2=%d", i);
  either_copyout(user, dst + n + offset, tmp, i);
  n += i;
  // 11-13
  // name = entry.lfn.name3;
  for (i = 0; i < NELEM(entry.lfn.name3) && entry.lfn.name3[i] != 0xffff; i++) {
    tmp[i] = entry.lfn.name3[i] & 0xff;
  }
  // printf("name3=%d", i);
  either_copyout(user, dst + n + offset, tmp, i);
  n += i;
  return n;
}

// void setDirent(FatFileEntry *entry, struct dirent *dt, TFFile *fp) {
//   dt->d_ino = entry->msdos.firstCluster;
//   if (fp->attributes & TF_ATTR_DIRECTORY) {
//     dt->d_type = DT_DIR;
//   } else {
//     dt->d_type = DT_FIFO;
//   }
// }

int Fat32FileSystem::ls(const char *filepath,
                        char *      contents,
                        int         len,
                        bool        user)
{
  LOG_DEBUG("fat32 ls");
  sleep_lock.lock();
  struct linux_dirent *dirent;
  struct linux_dirent  dt;
  FatFileEntry   entry;
  int            readn = 0, lfn_entries = 0;
  TFFile *       fp = tf_fopen(filepath, "r");
  if (fp == NULL || (fp->attributes & TF_ATTR_DIRECTORY) == 0) {
    sleep_lock.unlock();
    return -1;
  }
  while (tf_fread((char *)&entry, sizeof(FatFileEntry), fp) ==
         sizeof(FatFileEntry)) {
    if (entry.msdos.filename[0] == 0x00 ||
        readn + NELEM(entry.msdos.filename) >= len) {  // 结束
      LOG_DEBUG("over");
      sleep_lock.unlock();
      return readn;
    }
    // 短文件目录项
    if (entry.msdos.attributes != TF_ATTR_LONG_NAME) {
      // 设置ino，由于fat32不存在ino，所以这里使用第一个簇号作为ino
      dt.d_ino = entry.msdos.firstCluster;

      // 设置目录项类型
      if (entry.msdos.attributes & TF_ATTR_DIRECTORY) {
        dt.d_type = DT_DIR;
      }
      else {
        dt.d_type = DT_FIFO;
      }
      // 将contents转换为struct dirent *类型，方便得到d_name的偏移量
      dirent = reinterpret_cast<struct linux_dirent *>(contents);
      // 将sfn的文件名复制到目录项对应位置中
      int n = copysfn(entry.msdos.filename, dirent->d_name, user);

      // 计算该目录项的总长度
      dt.d_reclen = DIENT_BASE_LEN + n;  // n为短文件目录项的文件名长度

      // 计算下一个目录项的偏移量
      dt.d_off = reinterpret_cast<uint64_t>(contents) + dt.d_reclen;

      // 将dt的数据copy到对应的位置
      either_copyout(user, (uint64_t)contents, (void *)&dt, DIENT_BASE_LEN);
      // LOG_DEBUG("sfn=%s", dirent->d_name);

      // 更新content
      contents += dt.d_reclen;
      readn += dt.d_reclen;
    }
    else if ((entry.lfn.sequence_number & 0xc0) == 0x40) {  // 长文件名目录项
      dirent = reinterpret_cast<struct linux_dirent *>(contents);
      // 计算lfn的数量
      lfn_entries = entry.lfn.sequence_number & ~0x40;
      if (lfn_entries * LFN_NAME_CAPACITY + readn >= len) {
        LOG_DEBUG("over");
        tf_fclose(fp);
        sleep_lock.unlock();
        return readn;
      }
      LOG_DEBUG("lfn sno=%p  lfns=%d readn=%d len=%d",
                entry.lfn.sequence_number, lfn_entries, readn, len);
      // LOG_DEBUG("temp lfn len=%d name1=%p", sizeof(FatFileEntry),
      // entry.lfn.name1);

      // 将当前lfn储存的name copy到对应位置中
      int n = copylfn(entry, (uint64_t)dirent->d_name,
                      user);  // 将当前name copy到指定位置
      // copy剩余的长文件目录项
      for (int i = 1; i < lfn_entries; i++) {
        if (tf_fread((char *)&entry, sizeof(FatFileEntry), fp) !=
            sizeof(FatFileEntry)) {
          LOG_DEBUG("expect lfn entry, but not found");
          tf_fclose(fp);
          sleep_lock.unlock();
          return -1;
        }
        if (entry.lfn.attributes != TF_ATTR_LONG_NAME) {
          LOG_DEBUG("expect lfn entry, but not sfn entry");
          tf_fclose(fp);
          sleep_lock.unlock();
          return -1;
        }
        n += copylfn(entry, (uint64_t)dirent->d_name,
                     user);  // 将当前name copy到指定位置
      }

      // 读取对应的短文件目录项
      if (tf_fread((char *)&entry, sizeof(FatFileEntry), fp) !=
          sizeof(FatFileEntry)) {
        LOG_DEBUG("expect sfn entry, but not found");
        tf_fclose(fp);
        sleep_lock.unlock();
        return -1;
      }

      // 设置ino，由于fat32不存在ino，所以这里使用第一个簇号作为ino
      dt.d_ino = entry.msdos.firstCluster;

      // 设置目录项类型
      if (entry.msdos.attributes & TF_ATTR_DIRECTORY) {
        dt.d_type = DT_DIR;
      }
      else {
        dt.d_type = DT_FIFO;
      }

      // 计算该目录项的总长度
      dt.d_reclen = (DIENT_BASE_LEN + n);  // n为长文件目录项的文件名长度

      dt.d_reclen = ALIGN(dt.d_reclen, 8); // 8字节对齐

      // 计算下一个目录项的偏移量
      dt.d_off = reinterpret_cast<uint64_t>(contents) + dt.d_reclen;

      // 将dt的数据copy到对应的位置
      either_copyout(user, (uint64_t)contents, (void *)&dt, DIENT_BASE_LEN);

      // LOG_DEBUG("lfn=%s n=%d", dirent->d_name, n);
      // 更新content
      contents += dt.d_reclen;
      readn += dt.d_reclen;
    }
    else {
      LOG_ERROR("fat file system format error");
    }
  }
  tf_fclose(fp);
  sleep_lock.unlock();
  return readn;
}

// USERLAND
int read_sector(int dev, char *data, uint32_t sector)
{
  dev::RwDevRead(dev, data, sector * 512, 512);
  return 0;
}

int write_sector(int dev, char *data, uint32_t sector)
{
  dev::RwDevWrite(dev, data, sector * 512, 512);
  return 0;
}

/*
 * Fetch a single sector from disk.
 * ARGS
 *   sector - the sector number to fetch.
 * SIDE EFFECTS
 *   tf_info.buffer contains the 512 byte sector requested
 *   tf_info.currentSector contains the sector number retrieved
 *   if tf_info.buffer already contained a fetched sector, and was marked dirty,
 * that sector is tf_store()d back to its appropriate location before executing
 * the fetch. RETURN the return code given by the users read_sector() (should be
 * zero for NO ERROR, nonzero otherwise)
 */
int Fat32FileSystem::tf_fetch(uint32_t sector)
{
  int rc = 0;
  // Don't actually do the fetch if we already have it in memory
  if (sector == tf_info.currentSector) {
    return 0;
  }

  // If the sector we already have prefetched is dirty, write it before reading
  // out the new one
  if (tf_info.sectorFlags & TF_FLAG_DIRTY) {
    rc |= tf_store();

    dbg_printf(
        "\r\n[DEBUG-tf_fetch] Current sector (%d) dirty... storing to disk.",
        tf_info.currentSector);
#ifdef TF_DEBUG
    tf_stats.sector_writes += 1;
#endif
  }

  dbg_printf("\r\n[DEBUG-tf_fetch] Fetching sector (%d) from disk.", sector);
#ifdef TF_DEBUG
  tf_stats.sector_reads += 1;
#endif
  // Do the read, pass up the error flag
  rc |= read_sector(this->dev, tf_info.buffer, sector);
  if (!rc)
    tf_info.currentSector = sector;
  return rc;
}

/*
 * Store the current sector back to disk
 * SIDE EFFECTS
 *   512 bytes of tf_info.buffer are stored on disk in the sector specified by
 * tf_info.currentSector RETURN the error code given by the users write_sector()
 * (should be zero for NO ERROR, nonzero otherwise)
 */
int Fat32FileSystem::tf_store()
{
  dbg_printf("\r\n[DEBUG-tf_store] Writing sector (%d) to disk.",
             tf_info.currentSector);
  tf_info.sectorFlags &= ~TF_FLAG_DIRTY;
  return write_sector(this->dev, tf_info.buffer, tf_info.currentSector);
}

/*
 * Initialize the filesystem
 * Reads filesystem info from disk into tf_info and checks that info for
 * validity SIDE EFFECTS Sector 0 is fetched into tf_info.buffer If TF_DEBUG is
 * specified tf_stats is initialized RETURN 0 for a successfully initialized
 * filesystem, nonzero otherwise.
 */
int Fat32FileSystem::tf_init()
{
  BPB_struct * bpb;
  uint32_t     fat_size, root_dir_sectors, data_sectors, temp;
  uint32_t     cluster_count;
  TFFile *     fp;
  FatFileEntry e;

  // Initialize the runtime portion of the TFInfo structure, and read sec0
  tf_info.currentSector = -1;
  tf_info.sectorFlags = 0;
  tf_fetch(0);

  // Cast to a BPB, so we can extract relevant data
  bpb = (BPB_struct *)tf_info.buffer;

  /* Some sanity checks to make sure we're really dealing with FAT here
   * see fatgen103.pdf pg. 9ff. for details */
  /* BS_jmpBoot needs to contain specific instructions */
  // LOG_DEBUG("bytes per sector=%d", bpb->BytesPerSector);
  if (!(bpb->BS_JumpBoot[0] == 0xEB && bpb->BS_JumpBoot[2] == 0x90) &&
      !(bpb->BS_JumpBoot[0] == 0xE9)) {
    LOG_DEBUG(
        "  tf_init FAILED: stupid jmp instruction isn't exactly right...");
    return TF_ERR_BAD_FS_TYPE;
  }

  /* Only specific bytes per sector values are allowed
   * FIXME: Only 512 bytes are supported by thinfat at the moment */
  if (bpb->BytesPerSector != 512) {
    dbg_printf(
        "  tf_init() FAILED: Bad Filesystem Type (!=512 bytes/sector)\r\n");
    return TF_ERR_BAD_FS_TYPE;
  }

  if (bpb->ReservedSectorCount == 0) {
    dbg_printf("  tf_init() FAILED: ReservedSectorCount == 0!!\r\n");
    return TF_ERR_BAD_FS_TYPE;
  }

  /* Valid media types */
  if ((bpb->Media != 0xF0) && ((bpb->Media < 0xF8) || (bpb->Media > 0xFF))) {
    dbg_printf("  tf_init() FAILED: Invalid Media Type!  (0xf0, or 0xf8 <= "
               "type <= 0xff)\r\n");
    return TF_ERR_BAD_FS_TYPE;
  }

  // See the FAT32 SPEC for how this is all computed
  fat_size = (bpb->FATSize16 != 0) ? bpb->FATSize16 :
                                     bpb->FSTypeSpecificData.fat32.FATSize;
  root_dir_sectors = ((bpb->RootEntryCount * 32) + (bpb->BytesPerSector - 1)) /
                     (512);  // The 512 here is a hardcoded bpb->bytesPerSector
                             // (TODO: Replace /,* with shifts?)
  tf_info.totalSectors =
      (bpb->TotalSectors16 != 0) ? bpb->TotalSectors16 : bpb->TotalSectors32;
  data_sectors =
      tf_info.totalSectors -
      (bpb->ReservedSectorCount + (bpb->NumFATs * fat_size) + root_dir_sectors);
  tf_info.sectorsPerCluster = bpb->SectorsPerCluster;
  cluster_count = data_sectors / tf_info.sectorsPerCluster;
  tf_info.reservedSectors = bpb->ReservedSectorCount;
  tf_info.firstDataSector =
      bpb->ReservedSectorCount + (bpb->NumFATs * fat_size) + root_dir_sectors;

  // LOG_INFO("cluster count=%d", cluster_count);
  // Now that we know the total count of clusters, we can compute the FAT type
  if (cluster_count < 65525) {
    tf_info.type = TF_TYPE_FAT32;
    // return TF_ERR_BAD_FS_TYPE;
  }
  else
    tf_info.type = TF_TYPE_FAT32;

#ifdef TF_DEBUG
  tf_stats.sector_reads = 0;
  tf_stats.sector_writes = 0;
#endif

  // TODO ADD SANITY CHECKING HERE (CHECK THE BOOT SIGNATURE, ETC... ETC...)
  tf_info.rootDirectorySize = 0xffffffff;
  temp = 0;

  // Like recording the root directory size!
  // TODO, THis probably isn't necessary.  Remove later
  fp = tf_fopen("/", "r");
  do {
    temp += sizeof(FatFileEntry);
    tf_fread((char *)&e, sizeof(FatFileEntry), fp);
  } while (e.msdos.filename[0] != '\x00');
  tf_fclose(fp);
  tf_info.rootDirectorySize = temp;

  // printf("\r\n[DEBUG-tf_init] Size of root directory: %d bytes",
  // tf_info.rootDirectorySize);
#ifdef TF_DEBUG
  tf_fetch(0);
  printBPB((BPB_struct *)tf_info.buffer);
#endif
  memset(tf_file_handles, 0, sizeof(TFFile) * TF_FILE_HANDLES);

  tf_fclose(fp);
  tf_release_handle(fp);
  dbg_printf("\r\ntf_init() successful...\r\n");
  return 0;
}

/*
 * Return the FAT entry for the given cluster
 * ARGS
 *   cluster - The cluster number for the requested FAT entry
 * SIDE EFFECTS
 *   Retreives whatever sector happens to contain that FAT entry (if it's not
 * already in memory) RETURN The value of the fat entry for the specified
 * cluster.
 */
uint32_t Fat32FileSystem::tf_get_fat_entry(uint32_t cluster)
{
  tf_printf("\r\n        [DEBUG-tf_get_fat_entry] %x ", cluster);
  uint32_t offset = cluster * 4;
  tf_fetch(tf_info.reservedSectors +
           (offset / 512));  // 512 is hardcoded bpb->bytesPerSector
  tf_printf("\r\n        [DEBUG-tf_get_fat_entry] done");
  return *((uint32_t *)&(tf_info.buffer[offset % 512]));
}

/*
 * Sets the fat entry on disk for a given cluster to the specified value.
 * ARGS
 *   cluster - The cluster number for which to set the FAT entry
 *     value - The new value for the FAT entry
 * SIDE EFFECTS
 *   Fetches whatever sector happens to contain the pertinent fat entry (if it's
 * not already in memory) RETURN 0 for no error, or nonzero for error with fetch
 * TODO
 *   Does the sector modified here need to be flagged as dirty?
 */
int Fat32FileSystem::tf_set_fat_entry(uint32_t cluster, uint32_t value)
{
  uint32_t offset;
  int      rc;
  tf_printf("\r\n        [DEBUG-tf_set_fat_entry] %x  %x ", cluster, value);
  offset = cluster * 4;  // FAT32
  rc = tf_fetch(tf_info.reservedSectors +
                (offset / 512));  // 512 is hardcoded bpb->bytesPerSector
  if (*((uint32_t *)&(tf_info.buffer[offset % 512])) != value) {
    tf_info.sectorFlags |= TF_FLAG_DIRTY;  // Mark this sector as dirty
    *((uint32_t *)&(tf_info.buffer[offset % 512])) = value;
  }
  tf_printf("\r\n        [DEBUG-tf_set_fat_entry] done");
  return rc;
}

/*
 * Return the index of the first sector for the provided cluster
 * ARGS
 *   cluster - The cluster of interest
 * RETURN
 *   The first sector of the provided cluster
 */
uint32_t Fat32FileSystem::tf_first_sector(uint32_t cluster)
{
  return ((cluster - 2) * tf_info.sectorsPerCluster) + tf_info.firstDataSector;
}

/*
 * Walks the path provided, returning a valid file pointer for each successive
 * level in the path.
 *
 * example:  tf_walk("/home/ryan/myfile.txt", fp to "/")
 *           Call once: returns pointer to string: home/ryan/myfile.txt, fp now
 * points to directory for / Call again: returns pointer to string:
 * ryan/myfile.txt, fp now points to directory for /home Call again: returns
 * pointer to string: myfile.txt, fp now points to directory for /home/ryan Call
 * again: returns pointer to the end of the string, fp now points to
 * /home/ryan/myfile.txt Call again: returns NULL pointer. fp is unchanged ARGS
 *   filename - a string containing the full path
 *
 * SIDE EFFECTS
 *   The filesystem is traversed, so files are opened and closed, sectors are
 * read, etc... RETURN A string pointer to the next level in the path, or NULL
 * if this is the end of the path
 */
char *Fat32FileSystem::tf_walk(char *filename, TFFile *fp)
{
  FatFileEntry entry;
  tf_printf("\r\n  [DEBUG-tf_walk] Walking path '%s'", filename);
  // We're out of path. this walk is COMPLETE
  if (*filename == '/') {
    filename++;
    if (*filename == '\x00') {
      // LOG_DEBUG("error");
      return NULL;
    }
  }
  // There's some path left
  if (*filename != '\x00') {
    // fp is the handle for the current directory
    // filename is the name of the current file in that directory
    // Go fetch the FatFileEntry that corresponds to the current file
    // Remember that tf_find_file is only going to search from the beginning of
    // the filename up until the first path separation character LOG_DEBUG("")
    if (tf_find_file(fp, filename)) {
      // This happens when we couldn't actually find the file
      fp->flags = 0xff;
      dbg_printf("\r\n  [DEBUG-tf_walk] Exiting - not found");
      return NULL;
    }
    tf_fread((char *)&entry, sizeof(FatFileEntry), fp);
    // Walk over path separators
    while ((*filename != '/') && (*filename != '\x00'))
      filename += 1;
    if (*filename == '/')
      filename += 1;
    // Set up the file pointer now that we've got information for the next level
    // in the path hierarchy
    fp->parentStartCluster = fp->startCluster;
    fp->startCluster = ((uint32_t)(entry.msdos.eaIndex & 0xffff) << 16) |
                       (entry.msdos.firstCluster & 0xffff);
    fp->attributes = entry.msdos.attributes;
    fp->currentCluster = fp->startCluster;
    fp->currentClusterIdx = 0;
    fp->currentSector = 0;
    fp->currentByte = 0;
    fp->pos = 0;
    fp->flags = TF_FLAG_OPEN;
    fp->size = (entry.msdos.attributes & TF_ATTR_DIRECTORY) ?
                   0xffffffff :
                   entry.msdos.fileSize;
    if (*filename == '\x00')
      return NULL;
    tf_printf("\r\n  [DEBUG-tf_walk] Done: '%s'  (fp->startCluster=%x",
              filename, fp->startCluster);
    return filename;
  }
  // We're out of path.  This walk is COMPLETE.
  return NULL;
}

// TFFile *tf_get_free_handle();
/*
 * Searches the list of system file handles for a free one, and returns it.
 * RETURN
 *   NULL if no system file handles are free, or the free handle if one is
 * available.
 */
TFFile *Fat32FileSystem::tf_get_free_handle()
{
  int     i;
  TFFile *fp;
  for (i = 0; i < TF_FILE_HANDLES; i++) {
    fp = &tf_file_handles[i];
    if (fp->flags & TF_FLAG_OPEN)
      continue;
    // We get here if we find a free handle
    fp->flags = TF_FLAG_OPEN;
    return fp;
  }
  return NULL;
}

/*
 * Release a filesystem handle (mark as available)
 */
void Fat32FileSystem::tf_release_handle(TFFile *fp)
{
  fp->flags &= ~TF_FLAG_OPEN;
}

// Convert a character to uppercase
// TODO: Re-do how filename conversions are done.
char upper(char c)
{
  if (c >= 'a' && c <= 'z') {
    return c + ('A' - 'a');
  }
  else {
    return c;
  }
}

char temp[13];

void Fat32FileSystem::tf_choose_sfn(char *dest, char *src, TFFile *fp)
{
  int    results, num = 1;
  TFFile xfile;
  // throwaway fp that doesn't muck with the original
  memcpy(&xfile, fp, sizeof(TFFile));

  dbg_printf("\r\n[DEBUG-tf_choose_sfn] Trialing SFN's:  ");
  while (1) {
    results = tf_shorten_filename(dest, src, num);
    switch (results) {
      case 0:  // ok
        // does the file collide with the current directory?
        // tf_fseek(xfile, 0, 0);
        memcpy(temp, dest, 8);
        memcpy(temp + 9, dest + 8, 3);
        temp[8] = '.';
        temp[12] = 0;

        dbg_printf("'%s'   ", temp);

        if (0 > tf_find_file(&xfile, temp)) {
          // tf_
          dbg_printf("\r\n          [DEBUG-tf_choose_sfn] found "
                     "non-conflicting filename: %s",
                     temp);
          return;
          break;
        }
        // tf
        dbg_printf("trying again with index:", num);
        num++;
        break;

      case -1:  // error
        dbg_printf("\r\n[DEBUG-tf_choose_sfn] error selecting short filename!");
        return;
    }
  }
}

/*
 * Take the long filename (filename only, not full path) specified by src,
 * and convert it to an 8.3 compatible filename, storing the result at dst
 * TODO: This should return something, an error code for conversion failure.
 * TODO: This should handle special chars etc.
 * TODO: Test for short filenames, (<7 characters)
 * TODO: Modify this to use the basis name generation algorithm described in the
 * FAT32 whitepaper.
 */
int Fat32FileSystem::tf_shorten_filename(char *dest, char *src, char num)
{
  // int l = strlen(src);
  int   i;
  int   lossy_flag = 0;
  char *tmp;

  i = lossy_flag;
  tmp = 0;
#ifdef TF_DEBUG
  char *orig_dest = dest;
  char *orig_src = src;
#endif
  // strip through and chop special chars

  tmp = strrchr(src, '.');
  // copy the extension
  for (i = 0; i < 3; i++) {
    while (tmp != 0 && *tmp != 0 &&
           !(*tmp < 0x7f && *tmp > 20 && *tmp != 0x22 && *tmp != 0x2a &&
             *tmp != 0x2e && *tmp != 0x2f && *tmp != 0x3a && *tmp != 0x3c &&
             *tmp != 0x3e && *tmp != 0x3f && *tmp != 0x5b && *tmp != 0x5c &&
             *tmp != 0x5d && *tmp != 0x7c))
      tmp++;
    if (tmp == 0 || *tmp == 0)
      *(dest + 8 + i) = ' ';
    else
      *(dest + 8 + i) = upper(*(tmp++));
  }

  // Copy the basename
  i = 0;
  tmp = strrchr(src, '.');
  while (1) {
    if (i == 8)
      break;
    if (src == tmp) {
      dest[i++] = ' ';
      continue;
    }

    if ((*dest == ' ')) {
      lossy_flag = 1;
    }
    else {
      while (*src != 0 &&
             !(*src < 0x7f && *src > 20 && *src != 0x22 && *src != 0x2a &&
               *src != 0x2e && *src != 0x2f && *src != 0x3a && *src != 0x3c &&
               *src != 0x3e && *src != 0x3f && *src != 0x5b && *src != 0x5c &&
               *src != 0x5d && *src != 0x7c))
        src++;
      if (*src == 0)
        dest[i] = ' ';
      else if (*src == ',' || *src == '[' || *src == ']')
        dest[i] = '_';
      else
        dest[i] = upper(*(src++));
    }
    i += 1;
  }
  // now that they are populated, do analysis.
  // if num>4, do 2 letters
  if (num > 4) {
    // snprintf(dest+2, 6, "%.4X~", num);// TODO
    dest[7] = '1';
  }
  else {
    tmp = strchr(dest, ' ');
    // printf("\r\n=-=-=- tf_shorten_filename:  %x - %x = %x",
    //       tmp, dest, tmp-dest);
    if (tmp == 0 || tmp - dest > 6) {
      dest[6] = '~';
      dest[7] = num + 0x30;
    }
    else {
      *tmp++ = '~';
      *tmp++ = num + 0x30;
    }
  }
  /*
  // Copy the basename
  while(1) {
      if(i==8) break;
      if((i==6) || (*src == '.') || (*src == '\x00'))break;
      if((*dest == ' '))  {lossy_flag = 1; } else {
          *(dest++) = upper(*(src++));
      }
      i+=1;
  }
  // Funny tail if basename was too long
  if(i==6) {
      *(dest++) = '~';
      *(dest++) = num+0x30;        // really? hard coded? wow. FIXME: make check
  filesystem i+=2;
  }
  // Or Not
  else {
      while(i<8) {
          *(dest++) = ' ';
          i++;
      }
  }

  // Last . in the filename
  src = strrchr(src, '.');

  *(dest++) = ' ';
  *(dest++) = ' ';
  *(dest++) = ' ';
  dest -= 3;
  // *(dest++) = '\x00';   // this field really *is* 11 bytes long, no
  terminating NULL necessary.
  //dest -= 4;            // and thank you to not since it clobbers the next
  byte (.attributes) if(src != NULL) { src +=1; while(i < 11) {     // this
  field really *is* 11 bytes long, no terminating NULL necessary. if(*src ==
  '\x00') break;
      *(dest++) = upper(*(src++));
      i+=1;
      }
  }*/
  return 0;
}

/*
 * Create a LFN entry from the filename provided.
 * - The entry is constructed from all, or the first 13 characters in the
 * filename (whichever is smaller)
 * - If filename is <=13 bytes long, the NULL pointer is returned
 * - If the filename >13 bytes long, an entry is constructed for the first 13
 * bytes, and a pointer is returned to the remainder of the filename. ARGS
 *   filename - string containing the filename for which to create an entry
 *   entry - pointer to a FatFileEntry structure, which is populated as an LFN
 * entry RETURN NULL if this is the last entry for this file, or a string
 * pointer to the remainder of the string if the entire filename won't fit in
 * one entry WARNING Because this function works in forward order, and LFN
 * entries are stored in reverse, it does NOT COMPUTE LFN SEQUENCE NUMBERS.  You
 * have to do that on your own.  Also, because the function acts on partial
 * filenames IT DOES NOT COMPUTE LFN CHECKSUMS.  You also have to do that on
 * your own.
 * TODO
 *   Test and further improve on this function
 */
char *Fat32FileSystem::tf_create_lfn_entry(char *filename, FatFileEntry *entry)
{
  int i, done = 0;
  tf_printf("\r\n--tf_create_lfn_entry: %s", filename);
  for (i = 0; i < 5; i++) {
    if (!done)
      entry->lfn.name1[i] = (unsigned short)*(filename);
    else
      entry->lfn.name1[i] = 0xffff;
    if (*filename++ == '\x00')
      done = 1;
  }
  for (i = 0; i < 6; i++) {
    if (!done)
      entry->lfn.name2[i] = (unsigned short)*(filename);
    else
      entry->lfn.name2[i] = 0xffff;
    if (*filename++ == '\x00')
      done = 1;
  }
  for (i = 0; i < 2; i++) {
    if (!done)
      entry->lfn.name3[i] = (unsigned short)*(filename);
    else
      entry->lfn.name3[i] = 0xffff;
    if (*filename++ == '\x00')
      done = 1;
  }

  entry->lfn.attributes = TF_ATTR_LONG_NAME;
  entry->lfn.reserved = 0;
  entry->lfn.firstCluster = 0;
  if (done)
    return NULL;
  if (*filename)
    return filename;
  else
    return NULL;
}
// Taken from http://en.wikipedia.org/wiki/File_Allocation_Table
//
char tf_lfn_checksum(const char *pFcbName)
{
  int  i;
  char sum = 0;

  for (i = 11; i; i--)
    sum = ((sum & 1) << 7) + (sum >> 1) + *pFcbName++;
  return sum;
}

int Fat32FileSystem::tf_place_lfn_chain(TFFile *fp, char *filename, char *sfn)
{
  // Windows does reverse chaining:  0x44, 0x03, 0x02, 0x01
  char *       strptr = filename;
  int          entries = 1;
  int          i;
  char *       last_strptr = filename;
  FatFileEntry entry;
  char         seq;
  // char sfn[12];

  // tf_choose_sfn(sfn, filename, fp);
  // tf_shorten_filename(sfn, filename, 1);
  // sfn[11] = 0;     // tf_shorten_filename no longer does this...

  // create the chains - probably only to get a count!?
  // FIXME: just pre-calculate and don't do all this recomputing!
  while ((strptr = tf_create_lfn_entry(strptr, &entry)) != 0) {
    tf_printf("\r\n=====PRECOMPUTING LFN LENGTH: strptr: %s", strptr);
    last_strptr = strptr;
    entries += 1;
  }

  // LFN sequence number (first byte of LFN)
  seq = entries | 0x40;
  tf_printf("\r\n===== Applying LFNs (%d) =====", entries);
  for (i = 0; i < entries; i++) {
    tf_create_lfn_entry(last_strptr, &entry);
    entry.lfn.sequence_number = seq;
    entry.lfn.checksum = tf_lfn_checksum(sfn);

    dbg_printf("\r\n[DEBUG-tf_place_lfn_chain] Placing LFN chain entry @ %d",
               fp->pos);
    tf_fwrite((char *)&entry, sizeof(FatFileEntry), fp);
    seq = ((seq & ~0x40) - 1);
    last_strptr -= 13;
  }
  return 0;
}

int Fat32FileSystem::tf_create(const char *filename)
{
  TFFile *     fp = tf_parent(filename, "r", false);
  FatFileEntry entry;
  uint32_t     cluster;
  char *       temp;
  dbg_printf("\r\n[DEBUG-tf_create] Creating new file: '%s'", filename);
  if (!fp)
    return 1;
  tf_fclose(fp);
  fp = tf_parent(filename, "r+", false);
  // Now we have the directory in which we want to create the file, open for
  // overwrite
  do {
    //"seek" to the end
    tf_fread((char *)&entry, sizeof(FatFileEntry), fp);
    tf_printf("Skipping existing directory entry... %d\r\n", fp->pos);
  } while (entry.msdos.filename[0] != '\x00');
  // Back up one entry, this is where we put the new filename entry
  tf_fseek(fp, -sizeof(FatFileEntry), fp->pos);
  cluster = tf_find_free_cluster();
  tf_set_fat_entry(cluster, TF_MARK_EOC32);  // Marks the new cluster as the
                                             // last one (but no longer free)
  // TODO shorten these entries with memset
  entry.msdos.attributes = 0;
  entry.msdos.creationTimeMs = 0x25;
  entry.msdos.creationTime = 0x7e3c;
  entry.msdos.creationDate = 0x4262;
  entry.msdos.lastAccessTime = 0x4262;
  entry.msdos.eaIndex = (cluster >> 16) & 0xffff;
  entry.msdos.modifiedTime = 0x7e3c;
  entry.msdos.modifiedDate = 0x4262;
  entry.msdos.firstCluster = cluster & 0xffff;
  entry.msdos.fileSize = 0;
  temp = strrchr(filename, '/') + 1;
  dbg_printf("\r\n[DEBUG-tf_create] FILENAME CONVERSION: %s", temp);
  tf_choose_sfn(entry.msdos.filename, temp, fp);
  tf_printf("\r\n==== tf_create: SFN: %s", entry.msdos.filename);
  tf_place_lfn_chain(fp, temp, entry.msdos.filename);
  // tf_choose_sfn(entry.msdos.filename, temp, fp);
  // tf_shorten_filename(entry.msdos.filename, temp);
  // printf("\r\n==== tf_create: SFN: %s", entry.msdos.filename);
  tf_fwrite((char *)&entry, sizeof(FatFileEntry), fp);
  memset(&entry, 0, sizeof(FatFileEntry));
  // entry.msdos.filename[0] = '\x00';
  tf_fwrite((char *)&entry, sizeof(FatFileEntry), fp);
  tf_fclose(fp);
  return 0;
}

/* tf_mkdir attempts to create a new directory in the filesystem.  duplicates
are *not* allowed!

returns 1 on failure
returns 0 on success
*/
int Fat32FileSystem::tf_mkdir(const char *filename, int mkParents)
{
  LOG_DEBUG("tf_mkdir=%s", filename);
  // FIXME: verify that we can't create multiples of the same one.
  // FIXME: figure out how the root directory location is determined.
  if (filename[0] == '/' && filename[1] == '.' && filename[2] == '/') {
    filename += 2;
  }
  if (filename[0] == '/' && filename[1] == '.' && filename[2] == '.' &&
      filename[3] == '/') {
    return NULL;
  }
  char         orig_fn[TF_MAX_PATH];
  TFFile *     fp;
  FatFileEntry entry, blank;

  // uint32_t psc;
  uint32_t cluster;
  char *   temp;

  strncpy(orig_fn, filename, TF_MAX_PATH - 1);
  orig_fn[TF_MAX_PATH - 1] = 0;

  memset(&blank, 0, sizeof(FatFileEntry));

  fp = tf_fopen(filename, "r");
  if (fp)  // if not NULL, the filename already exists.
  {
    tf_fclose(fp);
    tf_release_handle(fp);
    if (mkParents) {
      tf_printf(
          "\r\n[DEBUG-tf_mkdir] Skipping creation of existing directory.");
      return 0;
    }
    dbg_printf(
        "\r\n[DEBUG-tf_mkdir] Hey there, duffy, DUPLICATES are not allowed.");
    return 1;
  }
  dbg_printf("\r\n[DEBUG-tf_mkdir] The directory does not currently exist... "
             "Creating now.  %s",
             filename);
  fp = tf_parent(filename, "r+", mkParents);
  if (!fp) {
    dbg_printf("\r\n[DEBUG-tf_mkdir] Parent Directory doesn't exist.");
    return 1;
  }

  dbg_printf("\r\n[DEBUG-tf_mkdir] Creating new directory: '%s'", filename);
  // Now we have the directory in which we want to create the file, open for
  // overwrite
  do {
    tf_fread((char *)&entry, sizeof(FatFileEntry), fp);
    tf_printf("Skipping existing directory entry... %d\n", fp->pos);
  } while (entry.msdos.filename[0] != '\x00');
  // Back up one entry, this is where we put the new filename entry
  tf_fseek(fp, -sizeof(FatFileEntry), fp->pos);

  // go find some space for our new friend
  cluster = tf_find_free_cluster();
  tf_set_fat_entry(cluster, TF_MARK_EOC32);  // Marks the new cluster as the
                                             // last one (but no longer free)

  // set up our new directory entry
  // TODO shorten these entries with memset
  entry.msdos.attributes = TF_ATTR_DIRECTORY;
  entry.msdos.creationTimeMs = 0x25;
  entry.msdos.creationTime = 0x7e3c;
  entry.msdos.creationDate = 0x4262;
  entry.msdos.lastAccessTime = 0x4262;
  entry.msdos.eaIndex = (cluster >> 16) & 0xffff;
  entry.msdos.modifiedTime = 0x7e3c;
  entry.msdos.modifiedDate = 0x4262;
  entry.msdos.firstCluster = cluster & 0xffff;
  entry.msdos.fileSize = 0;
  temp = strrchr(filename, '/') + 1;
  dbg_printf("\r\n[DEBUG-tf_mkdir] DIRECTORY NAME CONVERSION: %s", temp);
  tf_choose_sfn(entry.msdos.filename, temp, fp);
  dbg_printf("\r\n==== tf_mkdir: SFN: %s", entry.msdos.filename);
  tf_place_lfn_chain(fp, temp, entry.msdos.filename);
  // tf_choose_sfn(entry.msdos.filename, temp, fp);
  // tf_shorten_filename(entry.msdos.filename, temp, 1);
  // printf("\r\n==== tf_mkdir: SFN: %s", entry.msdos.filename);
  //    dbg_printf("  3 mkdir: attr: %x ", entry.msdos.attributes); // attribute
  //    byte still getting whacked.
  // entry.msdos.attributes = TF_ATTR_DIRECTORY ;
  //    dbg_printf("  4 mkdir: attr: %x ", entry.msdos.attributes);
  tf_fwrite((char *)&entry, sizeof(FatFileEntry), fp);

  // psc = fp->startCluster; // store this for later

  // placing a 0 at the end of the FAT
  tf_fwrite((char *)&blank, sizeof(FatFileEntry), fp);
  tf_fclose(fp);
  tf_release_handle(fp);

  dbg_printf("\r\n  initializing directory entry: %s", orig_fn);
  fp = tf_fopen(orig_fn, "w");

  // set up .
  memcpy(entry.msdos.filename, ".          ", 11);
  // entry.msdos.attributes = TF_ATTR_DIRECTORY;
  // entry.msdos.firstCluster = cluster & 0xffff
  tf_fwrite((char *)&entry, sizeof(FatFileEntry), fp);

  // set up ..
  memcpy(entry.msdos.filename, "..         ", 11);
  // entry.msdos.attributes = TF_ATTR_DIRECTORY;
  // entry.msdos.firstCluster = cluster & 0xffff
  tf_fwrite((char *)&entry, sizeof(FatFileEntry), fp);

  // placing a 0 at the end of the FAT
  tf_fwrite((char *)&blank, sizeof(FatFileEntry), fp);

  tf_fclose(fp);
  tf_release_handle(fp);
  return 0;
}

TFFile *Fat32FileSystem::tf_fopen(const char *filename, const char *mode)
{
  if (filename[0] == '/' && filename[1] == '.' && filename[2] == '.' &&
      filename[3] == '/') {
    return NULL;
  }
  if (filename[0] == '/' && filename[1] == '.') {
    filename += 2;
  }
  TFFile *fp;
  dbg_printf("\r\n[DEBUG-tf_fopen] tf_fopen(%s, %s)\r ", filename, mode);

  fp = tf_fnopen(filename, mode, strlen(filename));
  if (fp == NULL) {
    if (strchr(mode, '+') || strchr(mode, 'w') || strchr(mode, 'a')) {
      LOG_DEBUG("fopen create");
      tf_create(filename);
    }
    LOG_DEBUG("fopen failed");
    return tf_fnopen(filename, mode, strlen(filename));
  }
  return fp;
}

//
// Just like fopen, but only look at n uint8_tacters of the path
TFFile *
Fat32FileSystem::tf_fnopen(const char *filename, const char *mode, int n)
{
  // Request a new file handle from the system
  TFFile * fp = tf_get_free_handle();
  char     myfile[256];
  char *   temp_filename = myfile;
  uint32_t cluster;

  if (fp == NULL)
    return nullptr;

  strncpy(myfile, filename, n);
  myfile[n] = 0;
  fp->currentCluster =
      2;  // FIXME: this is likely supposed to be the first cluster of the Root
          // directory... however, this is set in the BPB...
  fp->startCluster = 2;
  fp->parentStartCluster = 0xffffffff;
  fp->currentClusterIdx = 0;
  fp->currentSector = 0;
  fp->currentByte = 0;
  fp->attributes = TF_ATTR_DIRECTORY;
  fp->pos = 0;
  fp->flags |= TF_FLAG_ROOT;
  fp->size = 0xffffffff;
  // fp->size=tf_info.rootDirectorySize;
  fp->mode = TF_MODE_READ | TF_MODE_WRITE | TF_MODE_OVERWRITE;

  // LOG_DEBUG("temp filename=%s",temp_filename);

  while (temp_filename != NULL) {
    temp_filename = tf_walk(temp_filename, fp);
    // LOG_DEBUG("temp filename=%s", temp_filename);
    if (fp->flags == 0xff) {
      tf_release_handle(fp);
      LOG_DEBUG("tf_fnopen: cannot open file: fp->flags == 0xff ");
      return NULL;
    }
  }

  if (strchr(mode, 'r')) {
    fp->mode |= TF_MODE_READ;
  }
  if (strchr(mode, 'a')) {
    dbg_printf("\r\n[DEBUG-tf_fnopen] File opened for APPEND.  Seeking to "
               "offset 0+%d ",
               fp->size);
    tf_unsafe_fseek(fp, fp->size, 0);
    fp->mode |= TF_MODE_WRITE | TF_MODE_OVERWRITE;
  }
  if (strchr(mode, '+'))
    fp->mode |= TF_MODE_OVERWRITE | TF_MODE_WRITE;
  if (strchr(mode, 'w')) {
    /* Opened for writing. Truncate file only if it's not a directory*/
    if (!(fp->attributes & TF_ATTR_DIRECTORY)) {
      fp->size = 0;
      tf_unsafe_fseek(fp, 0, 0);
      /* Free the clusterchain starting with the second one if the file
       * uses more than one */
      if ((cluster = tf_get_fat_entry(fp->startCluster)) != TF_MARK_EOC32) {
        tf_free_clusterchain(cluster);
        tf_set_fat_entry(fp->startCluster, TF_MARK_EOC32);
      }
    }
    fp->mode |= TF_MODE_WRITE;
  }

  strncpy(fp->filename, myfile, n);

  fp->filename[n] = 0;
  return fp;
}

int Fat32FileSystem::tf_free_clusterchain(uint32_t cluster)
{
  uint32_t fat_entry;
  dbg_printf("\r\n[DEBUG-tf_free_clusterchain] Freeing clusterchain starting "
             "at cluster %d... ",
             cluster);
  fat_entry = tf_get_fat_entry(cluster);
  while (fat_entry < TF_MARK_EOC32) {
    if (fat_entry <=
        2)  // catch-all to save root directory from corrupted stuff
    {
      dbg_printf("\r\n\r\n+++++++++++++++++ SOMETHING WICKED THIS WAY COMES!  "
                 "End of FAT cluster chain is <=2 (end should be "
                 "0x0ffffff8)\r\n");
      break;
    }
    dbg_printf("\r\n[DEBUG-tf_free_clusterchain] Freeing cluster %d... ",
               fat_entry);
    tf_set_fat_entry(cluster, 0x00000000);
    fat_entry = tf_get_fat_entry(fat_entry);
    cluster = fat_entry;
  }
  return 0;
}

int Fat32FileSystem::tf_fseek(TFFile *fp, size_t base, long offset)
{
  long pos = base + offset;
  if (pos > fp->size) {
    return TF_ERR_INVALID_SEEK;
  }
  return tf_unsafe_fseek(fp, base, offset);
}

/*
 * TODO: Make it so seek fails aren't destructive to the file handle
 */
int Fat32FileSystem::tf_unsafe_fseek(TFFile *fp, int32_t base, long offset)
{
  uint32_t cluster_idx;
  long     pos = base + offset;
  uint32_t mark = tf_info.type ? TF_MARK_EOC32 : TF_MARK_EOC16;
  uint32_t temp;
  // We're only allowed to seek one past the end of the file (For writing new
  // stuff)
  if (pos > fp->size) {
    dbg_printf("\r\n[DEBUG-tf_unsafe_fseek] SEEK ERROR (pos=%ld > fp.size=%d) ",
               pos, fp->size);
    return TF_ERR_INVALID_SEEK;
  }
  if (pos == fp->size) {
    fp->size += 1;
    fp->flags |= TF_FLAG_SIZECHANGED;
  }
  // dbg_printf("\r\n[DEBUG-tf_unsafe_fseek] SEEK %d+%ld ", base, offset);

  // Compute the cluster index of the new location
  cluster_idx = pos / (tf_info.sectorsPerCluster *
                       512);  // The cluster we want in the file
  // print_TFFile(fp);
  // If the cluster index matches the index we're already at, we don't need to
  // look in the FAT If it doesn't match, we have to follow the linked list to
  // arrive at the correct cluster
  if (cluster_idx != fp->currentClusterIdx) {
    temp = cluster_idx;
    /* Shortcut: If we are looking for a cluster that comes *after* the current
     * we don't need to start at the beginning */
    if (cluster_idx > fp->currentClusterIdx) {
      cluster_idx -= fp->currentClusterIdx;
    }
    else {
      fp->currentCluster = fp->startCluster;
    }
    fp->currentClusterIdx = temp;
    while (cluster_idx > 0) {
      // TODO Check file mode here for r/w/a/etc...
      temp = tf_get_fat_entry(fp->currentCluster);  // next, next, next
      if ((temp & 0x0fffffff) != mark)
        fp->currentCluster = temp;
      else {
        // We've reached the last cluster in the file (omg)
        // If the file is writable, we have to allocate new space
        // If the file isn't, our job is easy, just report an error
        // Also, probably report an error if we're out of space
        temp = tf_find_free_cluster_from(fp->currentCluster);
        tf_set_fat_entry(fp->currentCluster, temp);  // Allocates new space
        tf_set_fat_entry(temp, mark);  // Marks the new cluster as the last one
        fp->currentCluster = temp;
      }
      cluster_idx--;
      if (fp->currentCluster >= mark) {
        if (cluster_idx > 0) {
          return TF_ERR_INVALID_SEEK;
        }
      }
    }
    // We now have the correct cluster number (whether we had to fetch it from
    // the fat, or realized we already had it) Now we need just compute the
    // correct sector and byte index into the cluster
  }
  fp->currentByte =
      pos % (tf_info.sectorsPerCluster * 512);  // The offset into the cluster
  fp->pos = pos;
  return 0;
}

/*
 * Given a file handle to the current directory and a filename, populate the
 * provided FatFileEntry with the file information for the given file. SIDE
 * EFFECT: the position in current_directory will be set to the beginning of the
 * fatfile entry (for overwriting purposes) returns 0 on match, -1 on fail
 */
int Fat32FileSystem::tf_find_file(TFFile *current_directory, char *name)
{
  int rc;
  tf_fseek(current_directory, 0, 0);
  // LOG_DEBUG("dir=%s name=%s", current_directory->filename, name);
  tf_printf("\r\n    [DEBUG-tf_find_file] Searching for filename: '%s' in "
            "directory '%s' ",
            name, current_directory->filename);

  while (1) {
    tf_printf(
        "\r\n    [DEBUG-tf_find_file]     iteration: '%s' in directory '%s' ",
        name, current_directory->filename);

    rc = tf_compare_filename(current_directory, name);
    if (rc < 0)
      break;
    else if (rc == 1)  // found!
    {
      tf_printf(
          "\r\n    [DEBUG-tf_find_file] (match) Exiting... rc==1, returning 0");
      return 0;
    }
  }
  tf_printf("\r\n    [DEBUG-tf_find_file] Exiting... returning -1");
  return -1;
}
/*! tf_compare_filename_segment compares a given filename against a particular
FatFileEntry (a 32-byte structure pulled off disk, all of these are back-to-back
in a typical Directory entry on the disk)

figures out formatted name, does comparison, and returns 0:failure, 1:match
*/
int tf_compare_filename_segment(FatFileEntry *entry, char *name)
{  //, char last) {
  int  i, j;
  char reformatted_file[16];
  memset(reformatted_file, 0, 16);
  char *entryname = entry->msdos.filename;
  tf_printf("\r\n        [DEBUG-tf_compare_filename_segment] -- '%s'", name);
  if (entry->msdos.attributes != TF_ATTR_LONG_NAME) {
    tf_printf(" 8.3 Segment: ");
    // Filename
    j = 0;
    for (i = 0; i < 8; i++) {
      if (entryname[i] != ' ') {
        reformatted_file[j++] = entryname[i];
      }
    }
    reformatted_file[j++] = '.';
    // Extension
    bool hasAlaph = false;
    for (i = 8; i < 11; i++) {
      if (entryname[i] != ' ') {
        hasAlaph = true;
        reformatted_file[j++] = entryname[i];
      }
    }
    if (!hasAlaph)
      j--;
  }
  else {
    tf_printf(" LFN Segment: ");
    j = 0;
    for (i = 0; i < 5; i++) {
      reformatted_file[j++] = (char)entry->lfn.name1[i];
    }
    for (i = 0; i < 6; i++) {
      reformatted_file[j++] = (char)entry->lfn.name2[i];
    }
    for (i = 0; i < 2; i++) {
      reformatted_file[j++] = (char)entry->lfn.name3[i];
    }
  }
  reformatted_file[j++] = '\x00';
  i = 0;
  while ((name[i] != '/') && (name[i] != '\x00'))
    i++;  // will this work for 8.3?  this should be calculated in the section
          // with knowledge of lfn/8.3

  tf_printf("\r\n        [DEBUG] Comparing filename segment '%s' (given) to "
            "'%s' (from disk) ",
            name, reformatted_file);
  // FIXME: only compare the 13 or less bytes left in the reformatted_file
  // string... but that doesn't match all the way to the end of the test
  // string....

  // the role of 'i' changes here to become the return value.  perhaps this
  // doesn't gain us enough in performance to avoid using a real retval?
  /// PROBLEM: THIS FUNCTION assumes that if the length of the "name" is tested
  /// by the caller.
  ///   if the LFN pieces all match, but the "name" is longer... this will never
  ///   fail.
  // LOG_DEBUG("name=%s entry=%s i=%d", name, reformatted_file,i);
  if (i > 13) {
    if (strncasecmp(name, reformatted_file, 13)) {
      tf_printf("  - 0 (doesn't match)\r\n");
      i = 0;
    }
    else {
      tf_printf("  - 1 (match)\r\n");
      i = 1;
    }
  }
  else {
    if (reformatted_file[i] != 0 || strncasecmp(name, reformatted_file, i)) {
      // LOG_DEBUG("does't match %d", reformatted_file[i]);
      i = 0;
      tf_printf("  - 0 (doesn't match)\r\n");
    }
    else {
      i = 1;
      tf_printf("  - 1 (match)\r\n");
    }
  }
  return i;
}
//
// Reads a single FatFileEntry from fp, compares it to the MSDOS filename
// specified by *name Returns:
//   1 for entry matches filename.  Side effect: fp seeks to that entry
//   0 for entry doesn't match filename.  Side effect: fp seeks to next entry
//   -1 for couldn't read an entry, due to EOF or other fread error
//
int Fat32FileSystem::tf_compare_filename(TFFile *fp, char *name)
{
  uint32_t     i;
  uint32_t     namelen;
  FatFileEntry entry;
  char *       compare_name = name;
  uint32_t     lfn_entries;

  // Read a single directory entry
  tf_printf("\r\n      [DEBUG-tf_compare_filename] Comparing filename @ %d ",
            fp->pos);
  tf_fread((char *)&entry, sizeof(FatFileEntry), fp);

  // Fail if its bogus
  if (entry.msdos.filename[0] == 0x00)
    return -1;

  // If it's a DOS entry, then:
  if (entry.msdos.attributes != TF_ATTR_LONG_NAME) {
    // If it's a match, seek back an entry to the beginning of it, return 1
    if (1 == tf_compare_filename_segment(&entry, name)) {  //, true)) {
      tf_fseek(fp, -sizeof(FatFileEntry), fp->pos);
      tf_printf("\r\n      [DEBUG-tf_compare_filename] 8.3 Exiting... "
                "returning 1 (match)");
      return 1;
    }
    else {
      tf_printf("\r\n      [DEBUG-tf_compare_filename] 8.3 Exiting... "
                "returning 0 (doesn't match)");
      return 0;
    }
  }
  else if ((entry.lfn.sequence_number & 0xc0) == 0x40) {
    // CHECK FOR 0x40 bit set or this is not the first (last) LFN entry!
    // If this is the first LFN entry, mask off the extra bit (0x40) and you get
    // the number of entries in the chain
    lfn_entries = entry.lfn.sequence_number & ~0x40;
    dbg_printf("\r\n=== LFN entries: %x   pos: %x  last entry:", lfn_entries,
               fp->pos);
    dbg_printHex((char *)&entry, 32);

    // Seek to the last entry in the chain (LFN entries store name in reverse,
    // so the last shall be first)
    tf_fseek(fp, (int32_t)sizeof(FatFileEntry) * (lfn_entries - 1), fp->pos);
    tf_printf("\r\n pos: %x", fp->pos);

    // get the length of the file first off.  LFN count should be easily checked
    // from here.
    namelen = strlen(name);
    if (((namelen + 12) / LFN_ENTRY_CAPACITY) != lfn_entries) {
      // skip this LFN, it isn't it.
      //  not necessary, we're already there.  // tf_fseek(fp,
      //  (int32_t)((i))*sizeof(FatFileEntry), fp->pos);
      tf_printf("\r\n pos: %x", fp->pos);
      tf_printf("\r\n      [DEBUG-tf_compare_filename] LFN Exiting... "
                "returning 0  (no match)");
      return 0;
    }

    for (i = 0; i < lfn_entries; i++) {
      // Seek back one and read it
      tf_printf("\r\n      [DEBUG-tf_compare_filename] LFN loop... %x::%x", i,
                lfn_entries);
      tf_fseek(fp, -sizeof(FatFileEntry), fp->pos);
      tf_printf("\r\n pos: %x", fp->pos);
      tf_fread((char *)&entry, sizeof(FatFileEntry), fp);
      tf_printf("\r\n pos: %x", fp->pos);

      // Compare it.  If it's not a match, jump to the end of the chain, return
      // failure Otherwise, continue looping until there's no entries left.
      if (!tf_compare_filename_segment(
              &entry, compare_name)) {  //, (i==lfn_entries-1))) {
        tf_fseek(fp, (int32_t)((i)) * sizeof(FatFileEntry), fp->pos);
        tf_printf("\r\n pos: %x", fp->pos);
        tf_printf("\r\n      [DEBUG-tf_compare_filename] LFN Exiting... "
                  "returning 0  (no match)");
        return 0;
      }
      tf_fseek(fp, -sizeof(FatFileEntry), fp->pos);
      tf_printf("\r\n pos: %x", fp->pos);

      compare_name += 13;
    }
    // If we made it here, match was a success!  Return so...
    // ONLY if next entry is valid!
    tf_fseek(fp, (int32_t)sizeof(FatFileEntry) * lfn_entries, fp->pos);
    tf_printf(
        "\r\n      [DEBUG-tf_compare_filename] LFN Exiting... returning 1 ");
    return 1;
  }
  tf_printf(
      "\r\n      [DEBUG-tf_compare_filename] (---) Exiting... returning -1 ");
  return -1;
}

int Fat32FileSystem::tf_fread(char *dest, int size, TFFile *fp, bool user)
{
  uint32_t sector;
  int      n = 0;  // count that have been read
  size = size > fp->size ? fp->size : size;
  while (n <= fp->size && size > 0) {
    sector = tf_first_sector(fp->currentCluster) + (fp->currentByte / 512);
    tf_fetch(sector);  // wtfo?  i know this is cached, but why!?
    size_t x = SECTOR_SIZE - (fp->currentByte % 512);
    if (x > fp->size - fp->pos) {
      x = fp->size - fp->pos;
    }
    if (x > (size_t)size) {
      x = size;
    }

    either_copyout(user, reinterpret_cast<uint64_t>(dest),
                   &tf_info.buffer[fp->currentByte % 512], x);
    // memmove(dest, &tf_info.buffer[fp->currentByte % 512], x);
    // printHex(&tf_info.buffer[fp->currentByte % 512], 1);
    // *dest++ = tf_info.buffer[fp->currentByte % 512];
    dest += x;
    size -= x;
    n += x;
    if (fp->attributes & TF_ATTR_DIRECTORY) {
      // dbg_printf("READING DIRECTORY");
      if (tf_fseek(fp, 0, fp->pos + x)) {
        return n;
      }
    }
    else {
      if (tf_fseek(fp, 0, fp->pos + x) != 0) {
        return n;
      }
    }
  }
  return n;
}

int Fat32FileSystem::tf_fwrite(const char *src, int sz, TFFile *fp, bool user)
{
  int      tracking;
  uint32_t sector;
  int      n = 0;  // count that have been read

  fp->flags |= TF_FLAG_DIRTY;
  while (sz > 0) {  // really suboptimal for performance.  optimize.
    // FIXME: even this new algorithm could be more efficient by elegantly
    // combining count/size
    sector = tf_first_sector(fp->currentCluster) + (fp->currentByte / 512);
    tf_fetch(sector);

    tracking = fp->currentByte % 512;
    size_t x = SECTOR_SIZE - (fp->currentByte % 512);
    if (x > fp->size - fp->pos) {
      x = fp->size - fp->pos;
    }

    if (x > (size_t)sz) {
      x = sz;
    }

    // memcpy(&tf_info.buffer[tracking], src, x);
    either_copyin(user, &tf_info.buffer[tracking], (uint64_t)src, x);
    tf_info.sectorFlags |= TF_FLAG_DIRTY;  // Mark this sector as dirty

    if (fp->pos + x > fp->size) {
      fp->flags |= TF_FLAG_SIZECHANGED;
      fp->size = x + fp->pos;
    }

    if (tf_unsafe_fseek(fp, 0, fp->pos + x)) {
      return -1;
    }
    src += x;
    n += x;
    sz -= x;
  }
  return n;
}

int Fat32FileSystem::tf_fputs(char *src, TFFile *fp)
{
  return tf_fwrite(src, strlen(src), fp);
}

int Fat32FileSystem::tf_fclose(TFFile *fp)
{
  int rc;

  dbg_printf("\r\n[DEBUG-tf_close] Closing file... ");
  rc = tf_fflush(fp);
  fp->flags &=
      ~TF_FLAG_OPEN;  // Mark the file as available for the system to use
  // FIXME: is there any reason not to release the handle here?
  return rc;
}

/* tf_parent attempts to open the parent directory of whatever file you request

returns basically a fp the tf_fnopen returns
*/
TFFile *Fat32FileSystem::tf_parent(const char *filename,
                                   const char *mode,
                                   int         mkParents)
{
  TFFile *retval;
  char *  f2;
  dbg_printf("\r\n[DEBUG-tf_parent] Opening parent of '%s' ", filename);
  f2 = (char *)strrchr((char const *)filename, '/');
  dbg_printf(" found / at offset %d\r\n", (int)(f2 - filename));
  retval = tf_fnopen(filename, "rw", (int)(f2 - filename));
  // if retval == NULL, why!?  we could be out of handles
  if (retval == NULL && mkParents) {  // warning: recursion could fry some
                                      // resources on smaller procs
    char tmpbuf[260];
    if (f2 - filename > 260) {
      dbg_printf("F* ME, something is wrong... copying %d bytes into 260",
                 f2 - filename);
      return NULL;
    }
    strncpy(tmpbuf, filename, f2 - filename);
    tmpbuf[f2 - filename] = 0;
    dbg_printf("\r\n[DEBUG-tf_parent] === recursive mkdir=== %s ", tmpbuf);
    tf_mkdir(tmpbuf, mkParents);
    retval = tf_parent(filename, mode, mkParents);
  }
  else if (retval == (void *)-1) {
    dbg_printf(
        "\r\n[DEBUG-tf_parent] uh oh.  tf_fopen() return -1, out of handles?");
  }

  dbg_printf("\r\n[DEBUG-tf_parent] Returning parent of %s", filename);
  return retval;
}

int Fat32FileSystem::tf_fflush(TFFile *fp)
{
  int          rc = 0;
  TFFile *     dir;
  FatFileEntry entry;
  char *       filename = entry.msdos.filename;

  if (!(fp->flags & TF_FLAG_DIRTY))
    return 0;

  dbg_printf("\r\n[DEBUG-tf_fflush] Flushing file... ");
  // First write any pending data to disk
  if (tf_info.sectorFlags & TF_FLAG_DIRTY) {
    rc = tf_store();
  }
  // Now go modify the directory entry for this file to reflect changes in the
  // file's size (If they occurred)
  if (fp->flags & TF_FLAG_SIZECHANGED) {
    if (fp->attributes & 0x10) {
      // TODO Deal with changes in the root directory size here
    }
    else {
      // Open the parent directory
      dir = tf_parent(fp->filename, "r+", false);
      if (dir == (void *)-1) {
        dbg_printf("\r\n[DEBUG-tf_fflush] FAILED to get parent!");
        return -1;
      }

      filename = (char *)strrchr((char const *)fp->filename, '/');

      dbg_printf("\r\n[DEBUG-tf_fflush] Opened %s's parent for directory entry "
                 "modification... ",
                 fp->filename);

      // Seek to the entry we want to modify and pull it from disk
      tf_find_file(dir, filename + 1);
      tf_fread((char *)&entry, sizeof(FatFileEntry), dir);
      tf_fseek(dir, -sizeof(FatFileEntry), dir->pos);
      dbg_printf("\r\n[DEBUG-tf_fflush] Updating file size from %d to %d ",
                 entry.msdos.fileSize, fp->size - 1);

      // Modify the entry in place to reflect the new file size
      entry.msdos.fileSize = fp->size - 1;
      tf_fwrite((char *)&entry, sizeof(FatFileEntry),
                dir);  // Write fatfile entry back to disk
      tf_fclose(dir);
    }
    fp->flags &= ~TF_FLAG_SIZECHANGED;
  }

  dbg_printf("\r\n[DEBUG-tf_fflush] Flushed. ");
  fp->flags &= ~TF_FLAG_DIRTY;
  return rc;
}

/*
 * Remove a file from the filesystem
 * @param filename - The full path of the file to be removed
 * @return
 */
int Fat32FileSystem::tf_remove(char *filename)
{
  TFFile *     fp;
  FatFileEntry entry;
  int          rc;
  uint32_t     startCluster;

  // Sanity check
  fp = tf_fopen(filename, "r");
  if (fp == NULL)
    return -1;  // return an error if we're removing a file that doesn't exist
  startCluster = fp->startCluster;  // Remember first cluster of the file so we
                                    // can remove the clusterchain
  tf_fclose(fp);

  // TODO Don't leave an orphaned LFN
  fp = tf_parent(filename, "r", false);
  rc = tf_find_file(fp, (strrchr((char *)filename, '/') + 1));
  LOG_DEBUG("rm parent=%s sz=%d", fp->filename, fp->size);
  if (!rc) {
    while (1) {
      rc = tf_fseek(fp, sizeof(FatFileEntry), fp->pos);
      if (rc)
        break;
      tf_fread((char *)&entry, sizeof(FatFileEntry),
               fp);  // Read one entry ahead
      LOG_DEBUG("attr=%x name=%s", entry.msdos.attributes,
                entry.msdos.filename);
      tf_fseek(fp, -((int32_t)3 * sizeof(FatFileEntry)), fp->pos);
      tf_fwrite((char *)&entry, sizeof(FatFileEntry), fp);
      if (entry.msdos.filename[0] == 0)
        break;
    }
    fp->size -= sizeof(FatFileEntry);
    fp->flags |= TF_FLAG_SIZECHANGED;
  }
  tf_fclose(fp);
  tf_free_clusterchain(startCluster);  // Free the data associated with the file

  return 0;
}

// Walk the FAT from the very first data sector and find a cluster that's
// available Return the cluster index
// TODO: Rewrite this function so that you can start finding a free cluster at
// somewhere other than the beginning
uint32_t Fat32FileSystem::tf_find_free_cluster()
{
  uint32_t i, entry, totalClusters;

  dbg_printf(
      "\r\n[DEBUG-tf_find_free_cluster] Searching for a free cluster... ");
  totalClusters = tf_info.totalSectors / tf_info.sectorsPerCluster;
  for (i = 0; i < totalClusters; i++) {
    entry = tf_get_fat_entry(i);
    if ((entry & 0x0fffffff) == 0)
      break;
    tf_printf("cluster %x: %x", i, entry);
  }
  dbg_printf("\r\n[DEBUGtf_find_free_cluster] Returning Free cluster number: "
             "%d for allocation",
             i);
  return i;
}

/* Optimize search for a free cluster */
uint32_t Fat32FileSystem::tf_find_free_cluster_from(uint32_t c)
{
  uint32_t i, entry, totalClusters;
  dbg_printf("\r\n[DEBUG-tf_find_free_cluster_from] Searching for a free "
             "cluster from %x... ",
             c);
  totalClusters = tf_info.totalSectors / tf_info.sectorsPerCluster;
  for (i = c; i < totalClusters; i++) {
    entry = tf_get_fat_entry(i);
    if ((entry & 0x0fffffff) == 0)
      break;
    tf_printf("cluster %x: %x", i, entry);
  }
  /* We couldn't find anything here so search from the beginning */
  if (i == totalClusters) {
    dbg_printf("\r\n[DEBUG-tf_find_free_cluster_from] Couldn't find one from "
               "there... starting from beginning");
    return tf_find_free_cluster();
  }

  dbg_printf("\r\n[DEBUG-tf_find_free_cluster_from] Free cluster number: %d ",
             i);
  return i;
}

void Fat32FileSystem::tf_print_open_handles(void)
{
  int     i;
  TFFile *fp;
  dbg_printf("\r\n-=-=- Open File Handles : ");
  for (i = 0; i < TF_FILE_HANDLES; i++) {
    fp = &tf_file_handles[i];
    if (fp->flags & TF_FLAG_OPEN)
      dbg_printf(" %2x", i);
    else
      dbg_printf("   ");
  }
}
/*! tf_get_open_handles()
    returns a bitfield where the handles are open (1) or free (0)
    assumes there are <64 handles
*/
uint64_t Fat32FileSystem::tf_get_open_handles(void)
{
  int      i;
  TFFile * fp;
  uint64_t retval = 0;

  dbg_printf("\r\n-=-=- Open File Handles : ");
  for (i = 0; i < min(TF_FILE_HANDLES, 64); i++) {
    retval <<= 1;
    fp = &tf_file_handles[i];
    if (fp->flags & TF_FLAG_OPEN)
      retval |= 1;
  }
  return retval;
}

void printHex(char *st, uint32_t length)
{
  while (length--)
    printf("%.2x", *st++);
}
