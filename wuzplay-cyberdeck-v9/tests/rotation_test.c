/* Host unit test: the 180 degree page-format rotation used for game output must equal a
 * true 180 degree rotation of the 128x64 bitmap: out(x,y) == in(127-x, 63-y).
 * Also proves it is NOT a mirror. Build: gcc -std=c99 -Wall -Werror rotation_test.c */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../overlay/fw/application/src/wuz/wuz_rotate.h"

static int px(const uint8_t *fb, int x, int y) { return (fb[(y >> 3) * 128 + x] >> (y & 7)) & 1; }

static void rotate_frame(const uint8_t *in, uint8_t *out, int n_valid) {
    memset(out, 0, 1024);
    for (int p = 0; p < 8; p++) {
        uint8_t q = wuz_rot_page_index((uint8_t)p);
        for (int c = 0; c < 128; c++) out[q * 128 + c] = wuz_rot_page_byte(in + p * 128, (uint8_t)n_valid, c);
    }
}

static int check(const uint8_t *in, const uint8_t *out, const char *name) {
    for (int y = 0; y < 64; y++)
        for (int x = 0; x < 128; x++)
            if (px(out, x, y) != px(in, 127 - x, 63 - y)) {
                printf("FAIL %s at (%d,%d)\n", name, x, y);
                return 1;
            }
    return 0;
}

int main(void) {
    uint8_t in[1024], out[1024];
    int fails = 0;

    /* 1. single pixel in the top-left corner must land in the bottom-right corner */
    memset(in, 0, sizeof in);
    in[0] = 0x01;
    rotate_frame(in, out, 128);
    if (!px(out, 127, 63)) { printf("FAIL corner: (0,0) did not land at (127,63)\n"); fails++; }
    fails += check(in, out, "corner");

    /* 2. asymmetric 'F' at top-left, so mirror/flip errors are detectable */
    memset(in, 0, sizeof in);
    for (int y = 4; y < 24; y++) in[(y >> 3) * 128 + 6] |= (uint8_t)(1u << (y & 7));
    for (int x = 6; x < 16; x++) in[0 * 128 + x] |= 0x10;
    for (int x = 6; x < 13; x++) in[1 * 128 + x] |= 0x02;
    rotate_frame(in, out, 128);
    fails += check(in, out, "F-glyph");

    /* 3. a true 180 rotation is NOT a horizontal or vertical mirror of an asymmetric image */
    int same_as_hmirror = 1, same_as_vmirror = 1;
    for (int y = 0; y < 64; y++)
        for (int x = 0; x < 128; x++) {
            if (px(out, x, y) != px(in, 127 - x, y)) same_as_hmirror = 0;
            if (px(out, x, y) != px(in, x, 63 - y)) same_as_vmirror = 0;
        }
    if (same_as_hmirror || same_as_vmirror) { printf("FAIL: output equals a mirror, not a rotation\n"); fails++; }

    /* 4. random frames */
    srand(1234);
    for (int t = 0; t < 500; t++) {
        for (int i = 0; i < 1024; i++) in[i] = (uint8_t)rand();
        rotate_frame(in, out, 128);
        fails += check(in, out, "random");
    }

    /* 5. rotating twice returns the original */
    uint8_t twice[1024];
    rotate_frame(out, twice, 128);
    if (memcmp(twice, in, 1024)) { printf("FAIL: double rotation is not identity\n"); fails++; }

    /* 6. short page buffers (fewer than 128 columns written) pad with blank on the far side */
    memset(in, 0, sizeof in);
    for (int c = 0; c < 100; c++) in[c] = 0xFF;
    rotate_frame(in, out, 100);
    for (int c = 0; c < 28; c++)
        if (out[7 * 128 + c] != 0) { printf("FAIL: padding col %d not blank\n", c); fails++; break; }
    if (out[7 * 128 + 127] != 0xFF) { printf("FAIL: col 127 of last page should hold source col 0\n"); fails++; }

    if (fails) { printf("ROTATION TEST FAILED (%d)\n", fails); return 1; }
    printf("ROTATION TEST PASSED\n");
    return 0;
}
