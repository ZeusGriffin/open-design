#include "app_cyberdeck.h"
#include "mini_app_launcher.h"
#include "mini_app_registry.h"
#include "mui_include.h"
#include "vfs.h"
#include <stdbool.h>
#include <stdint.h>
#include <string.h>

#include "cyberdeck_data.h"

#define CY_VIEW 1
#define CY_TEXT_MAX 320 /* bounded file buffer, one static allocation per app run */
#define CY_LINE_CHARS 21
#define CY_PAGE_LINES 4
#define CY_ROW_H 11

typedef enum {
    CY_MAIN,
    CY_MED,
    CY_MED_FULL,
    CY_FILE,
    CY_NFC_LIST,
    CY_NFC_DETAIL,
    CY_TOOLS
} cy_screen_t;

typedef struct {
    mui_view_dispatcher_t *vd;
    mui_view_t *view;
    cy_screen_t screen;
    cy_screen_t parent; /* where BACK goes from CY_FILE */
    uint8_t main_sel;
    uint8_t med_sel;
    uint8_t nfc_sel;
    uint8_t tool_sel;
    uint8_t page;
    const char *title;
    const char *text; /* points at flash text or at buf */
    char buf[CY_TEXT_MAX];
} cyber_t;

static const char *const cy_main_items[] = {"Meditations", "Games",    "NFC Cards", "Cyber Dashboard",
                                            "Calendar",    "Contacts", "Notes",     "Cyber Tools"};
#define CY_MAIN_COUNT ((uint8_t)(sizeof(cy_main_items) / sizeof(cy_main_items[0])))

/* NFC list = every card + nfc.txt + shortcut into the Chameleon app */
#define CY_NFC_ROWS ((uint8_t)(CY_NFC_COUNT + 2))

/* ---------- text helpers ---------- */

/* Word-wraps s at CY_LINE_CHARS. Draws the lines that belong to `page`
 * (CY_PAGE_LINES per page) when c != NULL. Returns the total line count. */
static uint8_t cy_wrap(mui_canvas_t *c, const char *s, uint8_t page) {
    char line[CY_LINE_CHARS + 1];
    uint8_t lines = 0;
    const char *p = s;

    while (*p && lines < 250) {
        const char *start = p;
        const char *brk = NULL;
        uint8_t len = 0;

        while (*p && *p != '\n' && len < CY_LINE_CHARS) {
            if (*p == ' ') {
                brk = p;
            }
            p++;
            len++;
        }
        if (*p && *p != '\n' && *p != ' ' && brk) { /* mid-word: back up to last space */
            p = brk;
            len = (uint8_t)(brk - start);
        }
        memcpy(line, start, len);
        line[len] = 0;
        if (*p == '\n' || *p == ' ') {
            p++;
        }

        if (c && lines >= (uint8_t)(page * CY_PAGE_LINES) && lines < (uint8_t)((page + 1) * CY_PAGE_LINES)) {
            uint8_t row = (uint8_t)(lines - page * CY_PAGE_LINES);
            mui_canvas_draw_utf8(c, 3, (uint16_t)(25 + row * CY_ROW_H), line);
        }
        lines++;
    }
    return lines;
}

static uint8_t cy_pages(const char *s) {
    uint8_t lines = cy_wrap(NULL, s, 0);
    uint8_t pages = (uint8_t)((lines + CY_PAGE_LINES - 1) / CY_PAGE_LINES);
    return pages ? pages : 1;
}

static void cy_header(mui_canvas_t *c, const char *title, uint8_t n, uint8_t total) {
    mui_canvas_set_font(c, u8g2_font_wqy12_t_gb2312a);
    mui_canvas_draw_utf8(c, 3, 10, title);
    if (total > 1) {
        char b[8];
        uint8_t k = 0;
        if (n >= 10) {
            b[k++] = (char)('0' + n / 10);
        }
        b[k++] = (char)('0' + n % 10);
        b[k++] = '/';
        if (total >= 10) {
            b[k++] = (char)('0' + total / 10);
        }
        b[k++] = (char)('0' + total % 10);
        b[k] = 0;
        mui_canvas_draw_utf8(c, (uint16_t)(127 - 6 * k), 10, b);
    }
    mui_canvas_draw_line(c, 0, 12, 127, 12);
}

typedef const char *(*cy_label_fn)(uint8_t idx);

static void cy_draw_list(mui_canvas_t *c, const char *title, uint8_t count, uint8_t sel, cy_label_fn label) {
    cy_header(c, title, (uint8_t)(sel + 1), count);
    uint8_t start = sel > 1 ? (uint8_t)(sel - 1) : 0;
    if (count > 4 && start > count - 4) {
        start = (uint8_t)(count - 4);
    }
    for (uint8_t r = 0; r < 4 && (uint8_t)(start + r) < count; r++) {
        uint8_t idx = (uint8_t)(start + r);
        uint16_t y = (uint16_t)(25 + r * CY_ROW_H);
        if (idx == sel) {
            mui_canvas_draw_box(c, 0, (uint16_t)(y - 9), 128, 11);
            mui_canvas_set_draw_color(c, 0);
        }
        mui_canvas_draw_utf8(c, 4, y, label(idx));
        if (idx == sel) {
            mui_canvas_set_draw_color(c, 1);
        }
    }
}

static const char *cy_main_label(uint8_t i) { return cy_main_items[i]; }
static const char *cy_tool_label(uint8_t i) { return cy_tool_files[i].label; }
static const char *cy_nfc_label(uint8_t i) {
    if (i < CY_NFC_COUNT) {
        return cy_nfc[i].name;
    }
    return i == CY_NFC_COUNT ? "nfc.txt (file)" : "Open Chameleon";
}

/* ---------- companion files (VFS) ---------- */

static void cy_open_file(cyber_t *a, const char *title, const char *path, cy_screen_t parent) {
    vfs_driver_t *d = vfs_get_default_driver();
    int32_t n = -1;
    memset(a->buf, 0, sizeof(a->buf));
    if (d && d->read_file_data) {
        n = d->read_file_data(path, a->buf, sizeof(a->buf) - 1);
    }
    if (n < 0) {
        strcpy(a->buf, "FILE NOT FOUND");
    } else if (n == 0) {
        strcpy(a->buf, "NO DATA");
    } else {
        for (int32_t i = 0; i < n && i < (int32_t)sizeof(a->buf) - 1; i++) {
            if (a->buf[i] == '\r') {
                a->buf[i] = ' ';
            }
        }
    }
    a->title = title;
    a->text = a->buf;
    a->page = 0;
    a->parent = parent;
    a->screen = CY_FILE;
}

/* ---------- drawing ---------- */

static void cy_on_draw(mui_view_t *v, mui_canvas_t *c) {
    cyber_t *a = v->user_data;
    mui_canvas_clear(c);
    mui_canvas_set_font(c, u8g2_font_wqy12_t_gb2312a);

    switch (a->screen) {
    case CY_MAIN:
        cy_draw_list(c, "CYBERDECK", CY_MAIN_COUNT, a->main_sel, cy_main_label);
        break;
    case CY_TOOLS:
        cy_draw_list(c, "CYBER TOOLS", CY_TOOL_COUNT, a->tool_sel, cy_tool_label);
        break;
    case CY_NFC_LIST:
        cy_draw_list(c, "NFC CARDS", CY_NFC_ROWS, a->nfc_sel, cy_nfc_label);
        break;
    case CY_MED: {
        const cy_med_t *m = &cy_meds[a->med_sel];
        cy_header(c, m->who, (uint8_t)(a->med_sel + 1), CY_MED_COUNT);
        cy_wrap(c, m->brief, 0);
        mui_canvas_draw_utf8(c, 3, 62, "<   OK = more   >");
        break;
    }
    case CY_MED_FULL: {
        const cy_med_t *m = &cy_meds[a->med_sel];
        cy_header(c, m->who, (uint8_t)(a->page + 1), cy_pages(m->full));
        cy_wrap(c, m->full, a->page);
        break;
    }
    case CY_FILE:
    case CY_NFC_DETAIL:
        cy_header(c, a->title, (uint8_t)(a->page + 1), cy_pages(a->text));
        cy_wrap(c, a->text, a->page);
        break;
    }
}

/* ---------- navigation ---------- */

static void cy_step(uint8_t *sel, uint8_t count, bool next) {
    *sel = next ? (uint8_t)((*sel + 1) % count) : (uint8_t)((*sel + count - 1) % count);
}

static void cy_page_step(cyber_t *a, uint8_t pages, bool next) {
    if (next && a->page + 1 < pages) {
        a->page++;
    } else if (!next && a->page > 0) {
        a->page--;
    }
}

/* One logical level up. Returns false if the app was closed (do not touch a). */
static bool cy_back(cyber_t *a) {
    switch (a->screen) {
    case CY_MAIN:
        mini_app_launcher_kill(mini_app_launcher(), MINI_APP_ID_CYBERDECK);
        return false;
    case CY_MED_FULL:
        a->screen = CY_MED;
        a->page = 0;
        break;
    case CY_NFC_DETAIL:
        a->screen = CY_NFC_LIST;
        a->page = 0;
        break;
    case CY_FILE:
        a->screen = a->parent;
        a->page = 0;
        break;
    default: /* CY_MED, CY_NFC_LIST, CY_TOOLS -> main */
        a->screen = CY_MAIN;
        a->page = 0;
        break;
    }
    return true;
}

static void cy_select_main(cyber_t *a) {
    switch (a->main_sel) {
    case 0:
        a->screen = CY_MED;
        break;
    case 1: /* Games: hand over to the native Game app */
        mini_app_launcher_run(mini_app_launcher(), MINI_APP_ID_GAME);
        break;
    case 2:
        a->screen = CY_NFC_LIST;
        break;
    case 3:
        cy_open_file(a, "Cyber Dashboard", "/cyber.txt", CY_MAIN);
        break;
    case 4:
        cy_open_file(a, "Calendar", "/calendar.txt", CY_MAIN);
        break;
    case 5:
        cy_open_file(a, "Contacts", "/contacts.txt", CY_MAIN);
        break;
    case 6:
        cy_open_file(a, "Notes", "/notes.txt", CY_MAIN);
        break;
    default:
        a->screen = CY_TOOLS;
        break;
    }
}

static void cy_select_nfc(cyber_t *a) {
    if (a->nfc_sel < CY_NFC_COUNT) {
        a->title = cy_nfc[a->nfc_sel].name;
        a->text = cy_nfc[a->nfc_sel].details;
        a->page = 0;
        a->screen = CY_NFC_DETAIL;
    } else if (a->nfc_sel == CY_NFC_COUNT) {
        cy_open_file(a, "nfc.txt", "/nfc.txt", CY_NFC_LIST);
    } else {
        mini_app_launcher_run(mini_app_launcher(), MINI_APP_ID_CHAMELEON);
    }
}

static void cy_on_input(mui_view_t *v, mui_input_event_t *e) {
    cyber_t *a = v->user_data;
    if (e->type != INPUT_TYPE_SHORT && e->type != INPUT_TYPE_REPEAT) {
        return;
    }
    bool repeat = (e->type == INPUT_TYPE_REPEAT);

    if (e->key == INPUT_KEY_BACK) {
        if (!repeat) {
            cy_back(a);
        }
        return;
    }

    bool left = (e->key == INPUT_KEY_LEFT);
    bool right = (e->key == INPUT_KEY_RIGHT);
    bool ok = (e->key == INPUT_KEY_CENTER && !repeat);

    switch (a->screen) {
    case CY_MAIN:
        if (left || right) {
            cy_step(&a->main_sel, CY_MAIN_COUNT, right);
        } else if (ok) {
            cy_select_main(a);
        }
        break;
    case CY_TOOLS:
        if (left || right) {
            cy_step(&a->tool_sel, CY_TOOL_COUNT, right);
        } else if (ok) {
            cy_open_file(a, cy_tool_files[a->tool_sel].label, cy_tool_files[a->tool_sel].path, CY_TOOLS);
        }
        break;
    case CY_NFC_LIST:
        if (left || right) {
            cy_step(&a->nfc_sel, CY_NFC_ROWS, right);
        } else if (ok) {
            cy_select_nfc(a);
        }
        break;
    case CY_MED:
        if (left || right) {
            cy_step(&a->med_sel, CY_MED_COUNT, right);
        } else if (ok) {
            a->page = 0;
            a->screen = CY_MED_FULL;
        }
        break;
    case CY_MED_FULL:
        if (left || right) {
            cy_page_step(a, cy_pages(cy_meds[a->med_sel].full), right);
        } else if (ok) {
            cy_back(a);
        }
        break;
    case CY_FILE:
    case CY_NFC_DETAIL:
        if (left || right) {
            cy_page_step(a, cy_pages(a->text), right);
        } else if (ok) {
            cy_back(a);
        }
        break;
    }
}

/* ---------- app lifecycle ---------- */

static void cy_run(mini_app_inst_t *inst) {
    cyber_t *a = mui_mem_malloc(sizeof(cyber_t));
    memset(a, 0, sizeof(*a));
    inst->p_handle = a;
    a->vd = mui_view_dispatcher_create();
    a->view = mui_view_create();
    a->view->user_data = a;
    a->view->draw_cb = cy_on_draw;
    a->view->input_cb = cy_on_input;
    mui_view_dispatcher_add_view(a->vd, CY_VIEW, a->view);
    mui_view_dispatcher_attach(a->vd, MUI_LAYER_WINDOW);
    mui_view_dispatcher_switch_to_view(a->vd, CY_VIEW);
}

static void cy_kill(mini_app_inst_t *inst) {
    cyber_t *a = inst->p_handle;
    mui_view_dispatcher_switch_to_view(a->vd, VIEW_NONE);
    mui_view_dispatcher_detach(a->vd, MUI_LAYER_WINDOW);
    mui_view_dispatcher_free(a->vd);
    mui_view_free(a->view);
    mui_mem_free(a);
    inst->p_handle = NULL;
}

static void cy_event(mini_app_inst_t *inst, mini_app_event_t *ev) {
    (void)inst;
    (void)ev;
}

mini_app_t app_cyberdeck_info = {.id = MINI_APP_ID_CYBERDECK,
                                 .name = "Cyberdeck",
                                 .icon = 0xe1f0,
                                 .deamon = false,
                                 .sys = false,
                                 .hibernate_enabled = false,
                                 .run_cb = cy_run,
                                 .kill_cb = cy_kill,
                                 .on_event_cb = cy_event};
