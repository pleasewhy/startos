#include "cmdlist.h"
#include "kernel/defs.h"
#include "kernel/types.h"

#define MAX_BUFFER_SIZE 64
#define MAX_HISTORY_NUM 5

typedef struct History {
    char cmdlist[MAX_HISTORY_NUM][MAX_BUFFER_SIZE];
    int currentP;
} history;

history h;

int osh()
{
    printf("\n==========================Start OS=========================\n");
    puts("Welcome to startOS! Use following commands to get started.");
    puts("  * hello - print test hello world message");
    puts("  * help - list all available commands");

    char buf[MAX_BUFFER_SIZE];
    h.currentP = 0; //当前指令即将写入的位置

    while (1) {
        printf("osh>> ");
        if (read_line(buf) != 0) {
            if (strcmp(buf, "!!") == 0)
                showHistory();
            else {
                runcmd(buf);
                if (h.currentP >= MAX_HISTORY_NUM)
                    h.currentP = h.currentP % MAX_HISTORY_NUM;
                strcpy(h.cmdlist[h.currentP++], buf);
            }
        }
    }
    exit(0);
}

void showHistory()
{
    int startP=h.currentP;
    for (int k = MAX_HISTORY_NUM, i = (MAX_HISTORY_NUM + startP) % MAX_HISTORY_NUM; k > 0; i++, k--) {
        if (i >= MAX_HISTORY_NUM)
            i = i % MAX_HISTORY_NUM;
        if (h.cmdlist[i][0] == '\0') 
            continue;
        else {
            printf("#%d\t%s\n", k, h.cmdlist[i]);
        }
    }
    exit(0);
}
