#pragma once
#include <stdint.h>

/* 180 degree rotation helpers for SH1106 / SSD1306 style page-format frame data
 * (128 columns x 8 pages, bit0 of each byte = TOP pixel row of its 8-pixel page).
 *
 * Rotating a whole frame by 180 degrees means: source page p is written to page (7 - p),
 * the 128 columns are emitted in reverse order, and every byte is bit-reversed.
 *
 * Pure functions with no hardware dependency, so CI unit-tests them on the host
 * (wuzplay-cyberdeck-v9/tests/rotation_test.c). */

static inline uint8_t wuz_bitrev(uint8_t b) {
    b = (uint8_t)(((b & 0xF0) >> 4) | ((b & 0x0F) << 4));
    b = (uint8_t)(((b & 0xCC) >> 2) | ((b & 0x33) << 2));
    b = (uint8_t)(((b & 0xAA) >> 1) | ((b & 0x55) << 1));
    return b;
}

/* Destination page for source page `page` (0..7). */
static inline uint8_t wuz_rot_page_index(uint8_t page) { return (uint8_t)(7 - (page & 7)); }

/* Byte to send as output column `out_col` (0..127, in the order they are sent).
 * Columns beyond n_valid read as blank. */
static inline uint8_t wuz_rot_page_byte(const uint8_t *page_buf, uint8_t n_valid, int out_col) {
    int src = 127 - out_col;
    return wuz_bitrev((src >= 0 && src < n_valid) ? page_buf[src] : 0);
}
