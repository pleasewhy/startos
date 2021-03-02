//
// Created by hy on 2021/2/18.
//
#include "../kernel/types.h"
#include "../kernel/fs/stat.h"
#include "../kernel/fs/fcntl.h"
#include "../kernel/fs/fs.h"
#include "user.h"

char *
fmtname(char *path) {
    static char buf[DIRSIZ + 1];
    char *p;

    // Find first character after last slash.
    for (p = path + strlen(path); p >= path && *p != '/'; p--);
    p++;

    // Return blank-padded name.
    if (strlen(p) >= DIRSIZ)
        return p;
    memmove(buf, p, strlen(p));
    memset(buf + strlen(p), ' ', DIRSIZ - strlen(p));
    return buf;
}

char *
filetype(int type) {
    if (type == T_FILE) {
        return "File";
    } else if (type == T_DIR) {
        return "Dir ";
    } else {
        return "Dev ";
    }
}


void ls(char *path) {
    int fd;
    struct stat st;
    char prefix[512];
    char *p;
    struct direntry entry;


    if ((fd = open(path, O_RDONLY)) < 0) {
        printf("ls: can't open %s\n", path);
        return;
    }

    if (fstat(fd, &st) < 0) {
        printf("ls: cant't stat %s\n", path);
        return;
    }
    switch (st.type) {
        case T_FILE:
            printf("%s %d %l\n", fmtname(prefix), filetype(st.type), st.size);
            break;
        case T_DIR:
            strcpy(prefix, path);
            p = prefix + strlen(prefix);
            *p++ = '/';
            while (read(fd, &entry, sizeof(entry)) == sizeof(entry)) {
                memmove(p, entry.name, DIRSIZ);
                p[DIRSIZ] = 0;
                if (stat(prefix, &st) < 0) {
                    printf("can't stat %s\n", prefix);
                    continue;
                }
                printf("%s %s %l\n", fmtname(prefix), filetype(st.type), st.size);
            }
            break;
    }
}

void main(int argc, char *argv[]) {
    if (argc < 2)
        ls(".");
    else if (argc > 2)
        printf("too many argument\n");
    else
        ls(argv[1]);

    exit(0);
}

