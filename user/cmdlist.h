// 定义所有可用的命令
#include "kernel/defs.h"
#include "user/ulib.c"
#include "user/hello.c"
#include "user/usertests.c"

void showHistory();

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
    else if (strcmp(cmdstr, "usertests") == 0)
        run((uint64)usertests);
    else if(strcmp(cmdstr, "cowsay") == 0)
        run((uint64)cowsay);
    else if(strcmp(cmdstr, "mew") == 0)
        run((uint64)mew);
    else {
        puts("■■No such command.");
        return;
    }
}
