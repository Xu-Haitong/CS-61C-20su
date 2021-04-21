#include <stdio.h>

#define MAX_LEN 80


int main(int argc, char *argv[]) {
    // freopen() 重定向输入流
//    freopen("C:\\CODE\\C\\CS 61C\\su20-lab-starter\\lab01\\a.txt", "r", stdin);
    char a_word[MAX_LEN];

    printf("What's your name?\n");
    fgets(a_word, MAX_LEN, stdin);
    printf("Hey, %sI just really wanted to say hello to you.\nI hope you have a wonderful day.", a_word);

    return 0;
}