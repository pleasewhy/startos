//
// Created by hy on 2021/2/3.
//

#include "types.h"
#include "param.h"
#include "riscv.h"
#include "memlayout.h"
#include "lock/lock.h"
#include "process.h"
#include "defs.h"

#define MAX_BUFFER_SIZE 64
#define MAX_HISTORY_NUM 5

typedef struct History {
    char cmdlist[MAX_HISTORY_NUM][MAX_BUFFER_SIZE];
    int currentP;
} history;

history h;

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

void hello()
{
    puts("Hello, world!\n\t\tfrom startOS with osh");
    exit(0);
}

void cowsay(){
    puts("    ____________");
    puts("    < hi, there >");
    puts("    ------------");
    puts("         \\   ^__^");
    puts("          \\  (oo)\\_______");
    puts("             (__)\\       )\\/\\");
    puts("                 ||----w |");
    puts("                 ||     ||");
    exit(0);
}

void mew(){
    puts("          ＿＿");
    puts("　　　／＞　　フ");
    puts("　　　|   _　 _ |");
    puts("　　／`  ミ＿xノ");
    puts(" 　 /　　　 　 |");
    puts("　 /　 ヽ　　 ﾉ");
    exit(0);
}

void help()
{
    puts("All available commmands:");
    puts("help\tshow this helping message");
    puts("hello\tprint test hello world message");
    puts("history\tshow recent commands you input");
    puts("usertests\texec test function");
    puts("cowsay\tcowsay");
    puts("mew\tmew mew");
    exit(0);
}

void run(uint64 fn)
{
    if (fork() > 0) {
        wait(0);
    } else {
        exec(fn);
    }
}

void runcmd(char* cmdstr)
{
    if (strlen(cmdstr) == 0)
        return;
    else if (strcmp(cmdstr, "hello") == 0)
        run((uint64)hello);
    else if (strcmp(cmdstr, "help") == 0)
        run((uint64)help);
    else if (strcmp(cmdstr, "history") == 0)
        run((uint64)showHistory);
//    else if (strcmp(cmdstr, "usertests") == 0)
//        run((uint64)usertests);
    else if(strcmp(cmdstr, "cowsay") == 0)
        run((uint64)cowsay);
    else if(strcmp(cmdstr, "mew") == 0)
        run((uint64)mew);
    else {
        puts("■■No such command.");
        return;
    }
}

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


