#include <stdio.h>
#include <stdlib.h>

// Opens file with name a1 with permissions a2.
int fopen_(char *a1, int a2);

// Writes a3 * a4 bytes from the buffer in a2 to the file descriptor a1.
int fwrite_(int a1, void *a2, size_t a3, size_t a4);

// Closes the file descriptor a1.
int fclose_(int a1);

void write_matrix(char *file_path, int *p_matrix, int rows, int cols) {
    int fd = fopen_(file_path, 1);
    if (fd == -1) {
        exit(53);
    }
    int tmp = fwrite_(fd, &rows, 1, 4);
    if (tmp != 1) {
        exit(54);
    }
    tmp = fwrite_(fd, &cols, 1, 4);
    if (tmp != 1) {
        exit(54);
    }
    tmp = fwrite_(fd, p_matrix, rows * cols, 4);
    if (tmp != rows * cols) {
        exit(54);
    }
    tmp = fclose_(fd);
    if(tmp != 0){
        exit(55);
    }
}
