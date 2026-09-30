#include "wuz_games.h"

#include "app_timer.h"
#include "driver.h"
#include "wuz_font5x7.h"
#include <stdbool.h>
#include <stdint.h>
#include <string.h>

/* Wuzplay mini-games. They draw a 128x64 page-format framebuffer through the
 * JOY_OLED_* layer, which applies the global 180 degree rotation, so nothing
 * here needs to know about display orientation.
 * Controls: LEFT / SELECT / RIGHT as game input, BACK (or long SELECT) exits
 * via JOY_exit(). */

#define W 128
#define H 64

static uint8_t fb[W * 8];

/* ---------- drawing ---------- */
static void clear_fb(void) { memset(fb, 0, sizeof(fb)); }
static void px(int x, int y) {
    if (x >= 0 && x < W && y >= 0 && y < H) {
        fb[(y >> 3) * W + x] |= (uint8_t)(1u << (y & 7));
    }
}
static void box(int x, int y, int w, int h) {
    for (int yy = y; yy < y + h; yy++) {
        for (int xx = x; xx < x + w; xx++) {
            px(xx, yy);
        }
    }
}
static void frame(int x, int y, int w, int h) {
    for (int i = 0; i < w; i++) {
        px(x + i, y);
        px(x + i, y + h - 1);
    }
    for (int i = 0; i < h; i++) {
        px(x, y + i);
        px(x + w - 1, y + i);
    }
}
static void flush_fb(void) {
    for (uint8_t p = 0; p < 8; p++) {
        JOY_OLED_data_start(p);
        for (uint8_t x = 0; x < W; x++) {
            JOY_OLED_send(fb[p * W + x]);
        }
        JOY_OLED_end();
    }
}

/* ---------- text (5x7 font, 6px advance) ---------- */
static void ch(int x, int y, char c, int s) {
    if (c < 32 || c > 126) {
        c = '?';
    }
    const uint8_t *g = wuz_font5x7[c - 32];
    for (int col = 0; col < 5; col++) {
        for (int row = 0; row < 7; row++) {
            if (g[col] & (1u << row)) {
                box(x + col * s, y + row * s, s, s);
            }
        }
    }
}
static void text_s(int x, int y, const char *t, int s) {
    for (; *t; t++) {
        ch(x, y, *t, s);
        x += 6 * s;
    }
}
static int text_w(const char *t, int s) { return (int)strlen(t) * 6 * s; }
static void text_c(int y, const char *t, int s) { text_s((W - text_w(t, s)) / 2, y, t, s); }
static void text(int x, int y, const char *t) { text_s(x, y, t, 1); }

static char *put_s(char *d, const char *s) {
    while (*s) {
        *d++ = *s++;
    }
    *d = 0;
    return d;
}
static char *put_u(char *d, uint32_t v) {
    char t[11];
    int k = 0;
    if (!v) {
        t[k++] = '0';
    }
    while (v && k < 10) {
        t[k++] = (char)('0' + v % 10);
        v /= 10;
    }
    while (k) {
        *d++ = t[--k];
    }
    *d = 0;
    return d;
}

/* ---------- input latching: quick taps are never missed ---------- */
static bool prev_l, prev_r, prev_s;
static bool edge_l, edge_r, edge_s;

static void poll_keys(void) {
    bool l = JOY_left_pressed(), r = JOY_right_pressed(), s = JOY_act_pressed();
    if (l && !prev_l) edge_l = true;
    if (r && !prev_r) edge_r = true;
    if (s && !prev_s) edge_s = true;
    prev_l = l;
    prev_r = r;
    prev_s = s;
}
static void reset_keys(void) {
    edge_l = edge_r = edge_s = false;
    prev_l = JOY_left_pressed();
    prev_r = JOY_right_pressed();
    prev_s = JOY_act_pressed();
}
static bool exit_now(void) { return JOY_exit(); }
static void idle_ms(uint16_t ms) {
    for (uint16_t i = 0; i < ms / 5; i++) {
        JOY_idle();
        poll_keys();
        DLY_ms(5);
    }
}
static void blink(void) {
    for (int i = 0; i < 4; i++) {
        if (i & 1) {
            clear_fb();
        } else {
            memset(fb, 0xff, sizeof(fb));
        }
        flush_fb();
        idle_ms(90);
    }
}
static void game_over(const char *title, uint16_t score) {
    char b[24];
    blink();
    clear_fb();
    text_c(14, title, 2);
    char *e = put_s(b, "SCORE ");
    put_u(e, score);
    text_c(42, b, 1);
    flush_fb();
    idle_ms(1600);
}

/* ================= SNAKE ================= */
#define SN_COLS 30
#define SN_ROWS 13
#define SN_MAX 64

void wuz_snake_run(void) {
    int8_t sx[SN_MAX], sy[SN_MAX];
    uint8_t len = 4, dir = 0; /* 0=right 1=down 2=left 3=up */
    int8_t fx = 20, fy = 6;
    uint16_t score = 0;
    reset_keys();
    for (uint8_t i = 0; i < len; i++) {
        sx[i] = (int8_t)(10 - i);
        sy[i] = 6;
    }
    while (!exit_now()) {
        if (edge_l) dir = (uint8_t)((dir + 3) & 3); /* LEFT = turn counter-clockwise */
        if (edge_r) dir = (uint8_t)((dir + 1) & 3); /* RIGHT = turn clockwise */
        edge_l = edge_r = false;

        int nx = sx[0], ny = sy[0];
        switch (dir) {
        case 0: nx++; break;
        case 1: ny++; break;
        case 2: nx--; break;
        default: ny--; break;
        }
        if (nx < 0 || nx >= SN_COLS || ny < 0 || ny >= SN_ROWS) {
            game_over("GAME OVER", score);
            return;
        }
        for (uint8_t i = 0; i < len; i++) {
            if (sx[i] == nx && sy[i] == ny) {
                game_over("GAME OVER", score);
                return;
            }
        }
        bool eat = (nx == fx && ny == fy);
        if (eat && len < SN_MAX) {
            len++;
        }
        if (eat) {
            score++;
        }
        for (int i = len - 1; i > 0; i--) {
            sx[i] = sx[i - 1];
            sy[i] = sy[i - 1];
        }
        sx[0] = (int8_t)nx;
        sy[0] = (int8_t)ny;
        if (eat) { /* new food, not on the snake (bounded retries) */
            for (uint8_t t = 0; t < 24; t++) {
                fx = (int8_t)(JOY_random() % SN_COLS);
                fy = (int8_t)(JOY_random() % SN_ROWS);
                bool clash = false;
                for (uint8_t i = 0; i < len; i++) {
                    if (sx[i] == fx && sy[i] == fy) {
                        clash = true;
                        break;
                    }
                }
                if (!clash) {
                    break;
                }
            }
        }
        clear_fb();
        char b[16];
        put_u(put_s(b, "SNAKE "), score);
        text(2, 1, b);
        frame(0, 10, W, 54);
        for (uint8_t i = 0; i < len; i++) {
            box(4 + sx[i] * 4, 12 + sy[i] * 4, 3, 3);
        }
        frame(4 + fx * 4, 12 + fy * 4, 3, 3);
        flush_fb();
        idle_ms(110);
    }
}

/* ================= PONG ================= */
void wuz_pong_run(void) {
    int py = 28, ai = 28, bx = 64, by = 36, vx = 2, vy = 1, tick = 0;
    uint8_t ps = 0, cs = 0;
    reset_keys();
    while (!exit_now()) {
        if (JOY_left_pressed()) py -= 3;   /* LEFT  = paddle up   */
        if (JOY_right_pressed()) py += 3;  /* RIGHT = paddle down */
        if (py < 11) py = 11;
        if (py > 50) py = 50;

        tick++;
        if ((tick & 1) && vx > 0) { /* CPU is deliberately beatable */
            if (ai + 6 < by) ai += 2;
            else if (ai + 6 > by) ai -= 2;
            if (ai < 11) ai = 11;
            if (ai > 50) ai = 50;
        }

        bx += vx;
        by += vy;
        if (by <= 11) { by = 11; vy = -vy; }
        if (by >= 61) { by = 61; vy = -vy; }

        if (vx < 0 && bx <= 8 && bx >= 3 && by + 1 >= py && by <= py + 12) {
            vx = 2;
            bx = 9;
            vy = (by - (py + 6)) / 3;
            if (vy == 0) vy = (JOY_random() & 1) ? 1 : -1;
        }
        if (vx > 0 && bx >= 118 && bx <= 123 && by + 1 >= ai && by <= ai + 12) {
            vx = -2;
            bx = 117;
            vy = (by - (ai + 6)) / 3;
            if (vy == 0) vy = (JOY_random() & 1) ? 1 : -1;
        }
        if (vy > 2) vy = 2;
        if (vy < -2) vy = -2;

        bool point = false;
        if (bx < 0) { cs++; point = true; }
        if (bx > 127) { ps++; point = true; }
        if (point) {
            bx = 64;
            by = 36;
            vx = ((ps + cs) & 1) ? 2 : -2;
            vy = 1;
        }

        clear_fb();
        char b[16];
        char *e = put_u(b, ps);
        e = put_s(e, " : ");
        put_u(e, cs);
        text_c(1, b, 1);
        frame(0, 10, W, 54);
        for (int y = 12; y < 62; y += 4) box(63, y, 1, 2);
        box(4, py, 3, 12);
        box(121, ai, 3, 12);
        box(bx, by, 2, 2);
        flush_fb();

        if (ps >= 5 || cs >= 5) {
            blink();
            clear_fb();
            text_c(20, ps >= 5 ? "YOU WIN" : "CPU WINS", 2);
            char r[16];
            char *e2 = put_u(r, ps);
            e2 = put_s(e2, " : ");
            put_u(e2, cs);
            text_c(46, r, 1);
            flush_fb();
            idle_ms(1800);
            return;
        }
        idle_ms(30);
    }
}

/* ================= DODGE ================= */
void wuz_dodge_run(void) {
    int lane = 1, olane = (int)(JOY_random() % 3), oy = 10, speed = 2;
    uint16_t score = 0;
    reset_keys();
    while (!exit_now()) {
        if (edge_l && lane > 0) lane--;
        if (edge_r && lane < 2) lane++;
        edge_l = edge_r = false;

        oy += speed;
        if (oy >= 64) {
            score++;
            oy = 10;
            olane = (int)(JOY_random() % 3);
            speed = 2 + score / 6;
            if (speed > 5) speed = 5;
        }
        if (lane == olane && oy + 7 >= 53 && oy <= 61) {
            game_over("CRASH!", score);
            return;
        }

        clear_fb();
        char b[16];
        put_u(put_s(b, "DODGE "), score);
        text(2, 1, b);
        for (int y = 10; y < 64; y += 4) {
            box(42, y, 1, 2);
            box(85, y, 1, 2);
        }
        int cx = 21 + lane * 43, ox = 21 + olane * 43;
        box(cx - 5, 53, 11, 9);
        frame(ox - 5, oy, 11, 8);
        flush_fb();
        idle_ms(45);
    }
}

/* ================= REACTION ================= */
static uint32_t ms_since(uint32_t t0) {
    uint32_t ticks_per_ms = APP_TIMER_TICKS(1000) / 1000;
    if (ticks_per_ms == 0) ticks_per_ms = 1;
    return app_timer_cnt_diff_compute(app_timer_cnt_get(), t0) / ticks_per_ms;
}

void wuz_reaction_run(void) {
    while (!exit_now()) {
        reset_keys();
        clear_fb();
        text_c(16, "REACTION", 2);
        text_c(44, "WAIT FOR GO...", 1);
        flush_fb();

        uint16_t wait = (uint16_t)(1200 + (JOY_random() % 2800));
        uint16_t e = 0;
        bool early = false;
        while (e < wait) {
            if (exit_now()) return;
            if (edge_s) { early = true; break; }
            idle_ms(10);
            e += 10;
        }
        if (early) {
            clear_fb();
            text_c(16, "TOO EARLY", 2);
            text_c(44, "SELECT = retry", 1);
            flush_fb();
        } else {
            edge_s = false;
            clear_fb();
            frame(0, 0, W, H);
            text_c(20, "GO!", 3);
            flush_fb();
            uint32_t t0 = app_timer_cnt_get();
            uint32_t ms = 0;
            bool hit = false;
            while (!exit_now()) {
                idle_ms(5);
                ms = ms_since(t0);
                if (edge_s) { hit = true; break; }
                if (ms > 2000) break;
            }
            if (exit_now()) return;
            clear_fb();
            if (!hit) {
                text_c(16, "TOO SLOW", 2);
            } else {
                char b[16];
                put_s(put_u(b, ms), " MS");
                text_c(8, b, 2);
                int bar = 116 - (int)(ms / 10);
                if (bar < 4) bar = 4;
                if (bar > 116) bar = 116;
                frame(4, 30, 120, 12);
                box(6, 32, bar, 8);
                text_c(45, ms < 200 ? "GREAT" : ms < 300 ? "GOOD" : ms < 450 ? "OK" : "SLOW", 1);
            }
            text_c(56, "SELECT = again", 1);
            flush_fb();
        }
        edge_s = false;
        while (!edge_s) { /* SELECT = again, BACK exits */
            if (exit_now()) return;
            idle_ms(20);
        }
    }
}

/* ================= NBA 2K (joke screen) ================= */
void wuz_nba2k_run(void) {
    clear_fb();
    frame(0, 0, W, H);
    text_c(5, "NBA 2K", 2);
    text_c(23, "COMING SOON", 1);
    text_c(35, "Salary cap:", 1);
    text_c(44, "2 KB RAM", 1);
    text_c(54, "No microtransactions", 1);
    flush_fb();
    while (!exit_now()) {
        idle_ms(50);
    }
}
