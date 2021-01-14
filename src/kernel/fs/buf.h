struct buf {
    int valid; // has data been read from disk?
    int disk; // does disk "own" buf?
    uint dev;
    uint blockno;
    uint64 last_use_tick;
    struct sleeplock lock;
    uint refcnt;
    uchar data[BSIZE];
};
