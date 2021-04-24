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