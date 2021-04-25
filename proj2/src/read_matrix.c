#include <stdio.h>
#include <stdlib.h>
// fopen() (and other functions) is a built-in function, here I just add a '_' to declare my version

// Opens file with name a1 with permissions a2.
int fopen_(char *a1, int a2);

// Reads a3 bytes of the file into the buffer a2.
int fread_(int a1, void *a2, size_t a3);

// Closes the file descriptor a1.
int fclose_(int a1);

// Allocates heap memory (a0 bytes) and return a pointer to it
void *malloc_(int a0);

int *read_matrix(char *file_path, int *rows, int *cols) {
    int fd = fopen_(file_path, 0);
    if (fd == -1) {
        exit(50);
    }

    int tmp = fread_(fd, rows, 4);
    if (tmp != 4) {
        exit(51);
    }
    tmp = fread_(fd, cols, 4);
    if (tmp != 4) {
        exit(51);
    }

    int size = *rows * *cols;
    void *p_matrix = malloc_(size);
    tmp = fread_(fd, p_matrix, size);
    if (tmp != size) {
        exit(51);
    }
    tmp = fclose_(fd);
    if (tmp != 0) {
        exit(52);
    }
    return p_matrix;
}
