#include <stdlib.h>

int dot(const int *v0, const int *v1, int len, int stride1, int stride2) {
    if (len < 1) {
        exit(5);
    }
    if (stride1 < 1 || stride2 < 1) {
        exit(6);
    }
    int res = 0;
    for (int i = 0; i < len; i++) {
        int temp1 = *(v0 + stride1);
        int temp2 = *(v1 + stride2);
        int temp3 = temp1 * temp2;
        res += temp3;
    }
    return res;
}

void matmul(int *m0, int r0, int c0, int *m1, int r1, int c1, int *d) {
    if (r0 < 1 || c0 < 1) {
        exit(2);
    }
    if (r1 < 1 || c1 < 1) {
        exit(3);
    }
    if (c0 != r1) {
        exit(4);
    }
    int n = r0, m = c0, k = c1;
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < k; j++) {
            *(d + j + i * k) = dot(m0 + i * c0, m1 + j, m, 1, c1);
        }
    }
}

