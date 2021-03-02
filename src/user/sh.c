#include "../kernel/types.h"
#include "user.h"
#include "../kernel/param.h"

#define MAX_BUFFER_SIZE 64
#define MAX_HISTORY_NUM 5

char arg_mem[MAXARG][MAX_BUFFER_SIZE];
typedef struct History {
    char cmdlist[MAX_HISTORY_NUM][MAX_BUFFER_SIZE];
    int currentP;
} history;

history h;

struct cmd {
    char *argv[MAXARG];
};

void showHistory() {
    int startP = h.currentP;
    for (int k = MAX_HISTORY_NUM, i = (MAX_HISTORY_NUM + startP) % MAX_HISTORY_NUM; k > 0; i++, k--) {
        if (i >= MAX_HISTORY_NUM)
            i = i % MAX_HISTORY_NUM;
        if (h.cmdlist[i][0] == '\0')
            continue;
        else {
            printf("#%d\t%s\n", k, h.cmdlist[i]);
        }
    }
}

void get_cmd(struct cmd *cmd) {
    int start;
    int argc = 0;
    char buf[MAX_BUFFER_SIZE];
    memset(buf, 0, sizeof(buf));

    while (read(0, buf, sizeof(buf)) <= 0);
    start = 0;
    int i;
    for (i = 0; i < strlen(buf); ++i) {
        if (buf[i] == ' ' || buf[i] == '\n') {
            strncpy(arg_mem[argc],buf + start,  i - start);
            cmd->argv[argc] = arg_mem[argc];
            start = i + 1;
            argc++;
        }
    }
    cmd->argv[argc] = 0;
}

void run_cmd(struct cmd *cmd) {
    if (strcmp(cmd->argv[0], "!!") == 0)
        showHistory();
    else {
        int pid = fork();
        if (pid == 0) {
            exec(cmd->argv[0], cmd->argv);
        } else {
            wait(0);
        }
        if (h.currentP >= MAX_HISTORY_NUM)
            h.currentP = h.currentP % MAX_HISTORY_NUM;
//        strcpy(h.cmdlist[h.currentP++], buf);
    }
}

void help() {
    printf("All available commmands:\n");
    printf("help\tshow this helping message\n");
    printf("hello\tprint test hello world message\n");
    printf("history\tshow recent commands you input\n");
    printf("usertests\texec test function\n");
    printf("cowsay\tcowsay\n");
    printf("mew\tmew mew\n");
    exit(0);
}

int main() {
    printf("\n==========================Start OS=========================\n");
    printf("Welcome to startOS! Use following commands to get started.\n");
    printf("  * hello - print test hello world message\n");
    printf("  * help - list all available commands\n");
    struct cmd cmd;
    h.currentP = 0; //当前指令即将写入的位置

    while (1) {
        printf("osh>> ");
        get_cmd(&cmd);
        run_cmd(&cmd);
    }
    exit(0);
}
