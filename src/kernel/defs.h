
// uart.c
void            uart_init();
void            uartputc_sync(int);
int             uartgetc();
void            uart_intr();

// io.c
int             read_line(char *);
void            console_intr(char);
void            panic();
void            putc(int , char );
void            printf(const char* , ...);
void            puts(const char* );


// plic.c
void            plicinit(void);
void            plicinithart(void);
int             plic_claim(void);
void            plic_complete(int);

// trap.c
void            trapinit();

// process.c
void            init_process_table();
void            init_first_process();
struct proc*    alloc_proc();
int             cpuid();
struct cpu*     mycpu(void);
struct proc*    myproc(void);
void            sleep(void* chan);
void            sleep_time(uint64 sleep_ticks);
void            wakeup(void* chan);
void            scheduler();
void            exit(int);
int             wait(int* status);
void            exec(uint64);
void            print_proc();

// string.c
void*           memset(void *, int, uint);
void*           memmove(void*, const void*, int);

// pswitch.S
void            pswitch(struct context*, struct context*);


// syscall.c
int             fork();
void            sleep_sec(int);
void            yeild();