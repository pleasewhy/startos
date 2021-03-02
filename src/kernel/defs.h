struct buf;
struct context;
struct spinlock;
struct sleeplock;
struct cpu;
struct stat;
struct superblock;
struct inode;

// uart.c
void            uart_init();
void            uartputc_sync(int);
int             uartgetc();
void            uart_intr();


// virtio.c
void            virtio_disk_init();
void            virtio_disk_rw(struct buf *, int write);
void            virtio_disk_intr();

// console.c
int             read_line(char *);
void            console_init();
void            console_intr(char);
void            putc(int, char);

// printf.c
void            printf(const char* fmt, ...);
void            panic(char *s);
void            puts(const char* str);


// plic.c
void            plicinit(void);
void            plicinithart(void);
int             plic_claim(void);
void            plic_complete(int);

// trap.c
void            trapinit();
void            usertrapret();

// process.c
void            init_process_table();
void            init_first_process();
struct proc*    alloc_proc();
int             cpuid();
struct cpu*     mycpu(void);
struct proc*    myproc(void);
pagetable_t     proc_pagetable(struct proc *p);
void            sleep(void* chan, struct spinlock*);
void            sleep_time(uint64 sleep_ticks);
void            wakeup(void* chan);
void            scheduler();
int             fork();
void            exit(int);
int             wait(uint64 status);
void            print_proc();
void            before_sched();
void            yield();
int             either_copyout(int, uint64, void *, int);
int             either_copyin(void *, int, uint64, uint64);

// string.c
void*           memset(void *, int, uint);
void*           memmove(void*, const void*, int);
uint            strlen(const char* s);
char*           strcpy(char* s, const char* t);
char*           strncpy(char *s, const char *t, int n);
char*           safestrcpy(char *s, const char *t, int n);
int             strncmp(const char *p, const char *q, uint n);
int             strcmp(const char* p, const char* q);

// pswitch.S
void            pswitch(struct context*, struct context*);

// buf_cache.c
void            init_buf();
struct buf*     alloc_buf(int, int);
void            relse_buf(struct buf*);
struct buf*     buf_read(int, int);
void            buf_write(struct buf*);

// spinlock.c
void            spinlock_init(struct spinlock*, char*);
void            spin_lock(struct spinlock*);
void            spin_unlock(struct spinlock*);
int             spin_holding(struct spinlock*);
void            pop_off(void);
void            push_off(void);

// sleeplock.c
void            sleeplock_init(struct sleeplock*, char*);
void            sleep_lock(struct sleeplock*);
void            sleep_unlock(struct sleeplock*);
int             sleep_holding(struct sleeplock*);


//file.c
void            fileinit(void);
struct file *   file_alloc(void);
struct file *   file_dup(struct file *f);
void            file_close(struct file *f);
int             file_stat(struct file *f, uint64 addr);
int             file_read(struct file *f, uint64 addr, int n);
int             file_write(struct file *f, uint64 addr, int n);

// fs.c
void            read_superblock(struct superblock*);
void            init_fs();
void            zero_block(int blockno);
uint            alloc_disk_block();
void            free_disk_block(int blockno);
void            init_inode_cache();
struct inode*   alloc_inode(short type);
void            update_inode(struct inode* ip);
struct inode*   get_inode(int inum);
void            putback_inode(struct inode* ip);
uint            bmap(struct inode* ip, uint bn);
void            stat_inode(struct inode *ip, struct stat *stat);
int             read_inode(struct inode *ip, int user_dst, uint64 dst, uint off, int n);
int             write_inode(struct inode *ip, int user_src, uint64 src, uint64 off, int n);
void            lock_inode(struct inode *ip);
void            unlock_inode(struct inode *ip);
void            unlock_and_putback(struct inode *ip);
struct inode*   dup_inode(struct inode *ip);
void            trunc_inode(struct inode *ip) ;
struct          inode* namei(char *path);
struct          inode* nameiparent(char *path, char *name);
struct inode *  dirlookup(struct inode *dp, char *name, uint *poff);
int             dirlink(struct inode *dp, char *name, uint inum);


// kalloc.c
void            kfree(void *pa);
void *          kalloc(void);
void            kernel_mem_init();

// vm.c
void            kernel_vm_init();
void            vm_hart_init();
int             mappages(pagetable_t, uint64, uint64, uint64, int);
void            kernel_vm_map(uint64 va, uint64 pa, uint64 sz, int perm);
uint64          walkaddr(pagetable_t pagetable, uint64 va);
pte_t *         walk(pagetable_t pagetable, uint64 va, int alloc);
uint64          user_vm_alloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz);
pagetable_t     user_vm_create();
void            user_vm_init(pagetable_t, uchar *, uint);
int             user_vm_copy(pagetable_t old, pagetable_t new, int sz);
int             copyin(pagetable_t, char *, uint64, uint64);
int             copyinstr(pagetable_t, char *, uint64, int);
int             copyout(pagetable_t, uint64, char *, int);

void            vmprint(pagetable_t pagetable, int n);

// exec.c
int             exec(char *path, char **argv);

// osh.c
//int             osh();

// syscall.c
uint64          argraw(int n);
int             argint(int n, int *addr);
int             fetchaddr(uint64 addr, uint64 *ip);
int             argaddr(int n, uint64 *ip);
int             fetchstr(uint64 addr, char *buf, int max);
int             argstr(int n, char *buf, int max);
void            syscall(void);



