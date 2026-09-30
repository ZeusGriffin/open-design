#!/usr/bin/env python3
"""Wuzplay Cyberdeck v9 - feature layer applied AFTER apply_patch.py and post_patch_fixes.py.

1. copies overlay/ (real C sources) over the generated placeholders
2. generates the 5x7 pixel font header used by the games
3. rotates direct-write game output 180 degrees (JOY_OLED layer)
4. makes BACK exit every game and work in stock list menus / Chameleon main view
5. restricts NFC button shortcuts to the home screen
Every text substitution fails loudly if the upstream text is not found.
"""
from pathlib import Path
import re, shutil, sys

harness = Path(__file__).resolve().parent
root = Path(sys.argv[1] if len(sys.argv) > 1 else '.').resolve()


def read(rel):
    return (root / rel).read_text()


def write(rel, text):
    p = root / rel
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(text)


def replace(rel, old, new):
    s = read(rel)
    if old not in s:
        raise SystemExit(f'pattern not found in {rel}: {old[:90]!r}')
    write(rel, s.replace(old, new, 1))


# ---------------------------------------------------------------- 1. overlay
shutil.copytree(harness / 'overlay', root, dirs_exist_ok=True)

# ---------------------------------------------------------------- 2. font
FONT = ("0000000000 00005F0000 0007000700 147F147F14 242A7F2A12 2313086462 3649562050 0000070000 001C224100 "
        "0041221C00 2A1C7F1C2A 08083E0808 0080703000 0808080808 0000606000 2010080402 3E5149453E 00427F4000 "
        "7249494946 2141494D33 1814127F10 2745454539 3C4A494931 4121110907 3649494936 464949291E 0000140000 "
        "0040340000 0008142241 1414141414 0041221408 0201590906 3E415D594E 7C1211127C 7F49494936 3E41414122 "
        "7F4141413E 7F49494941 7F09090901 3E41415173 7F0808087F 00417F4100 2040413F01 7F08142241 7F40404040 "
        "7F021C027F 7F0408107F 3E4141413E 7F09090906 3E4151215E 7F09192946 2649494932 03017F0103 3F4040403F "
        "1F2040201F 3F4038403F 6314081463 0304780403 6159494D43 007F414141 0204081020 004141417F 0402010204 "
        "4040404040 0003070800 2054547840 7F28444438 3844444428 384444287F 3854545418 00087E0902 18A4A49C78 "
        "7F08040478 00447D4000 2040403D00 7F10284400 00417F4000 7C04780478 7C08040478 3844444438 FC18242418 "
        "18242418FC 7C08040408 4854545424 04043F4424 3C4040207C 1C2040201C 3C4030403C 4428102844 4C9090907C "
        "4464544C44 0008364100 0000770000 0041360800 0201020402").split()
assert len(FONT) == 95, len(FONT)
rows = ['    {' + ','.join('0x' + g[i * 2:i * 2 + 2] for i in range(5)) + '},' for g in FONT]
write('fw/application/src/app/game/port/wuz/wuz_font5x7.h',
      '#pragma once\n#include <stdint.h>\n'
      '/* Classic 5x7 GLCD font, ASCII 32..126. 5 column bytes per glyph, bit0 = top row. */\n'
      'static const uint8_t wuz_font5x7[95][5] = {\n' + '\n'.join(rows) + '\n};\n')

# ---------------------------------------------------------------- 2b. ONE switch for screen orientation
# Both display paths read this: the UI (u8g2 rotation) and direct-write games (JOY_OLED layer).
# Set WUZ_ROTATE_180 to 0 to get stock orientation on BOTH paths at once.
replace('fw/application/src/boards/board_oled.h', '#define OLED_SCREEN\n', '''#define OLED_SCREEN

/* Wuzplay screen orientation: single source of truth for the UI and the games.
 * 1 = rotated 180 degrees (Wuzplay), 0 = stock Pixl.js orientation. */
#define WUZ_ROTATE_180 1
/* The SH1106 RAM is 132 columns wide and the visible 128 start at column 2. u8g2 uses that
 * offset for the UI, so the direct-write game path must use it too or games sit ~2 px off. */
#define WUZ_OLED_COL_OFFSET 2
#if WUZ_ROTATE_180
#define WUZ_U8G2_ROT U8G2_R2
#else
#define WUZ_U8G2_ROT U8G2_R0
#endif
''')
replace('fw/application/src/mui/mui_u8g2.c',
        'u8g2_Setup_sh1106_128x64_noname_f(p_u8g2, U8G2_R2,',
        'u8g2_Setup_sh1106_128x64_noname_f(p_u8g2, WUZ_U8G2_ROT,')

# ---------------------------------------------------------------- 3/4a. game driver: rotation + BACK exit
drv = 'fw/application/src/app/game/port/common/driver.c'
replace(drv, 'void JOY_OLED_clear() {', r'''/* Wuzplay: every game streams one 128-byte page at a time through
 * JOY_OLED_data_start / JOY_OLED_send / JOY_OLED_end. To rotate ALL games
 * 180 degrees the page is buffered and emitted reversed: page order reversed,
 * column order reversed and bits mirrored inside each byte. */
void JOY_OLED_write_data(uint8_t is_data, uint8_t data);
void JOY_OLED_set_pos(uint8_t column, uint8_t page);
static uint8_t wuz_page_buf[128];
static uint8_t wuz_page_n;
static uint8_t wuz_page_idx;

void JOY_OLED_clear() {''')
replace(drv, '#include "driver.h"\n', '#include "driver.h"\n#include "wuz_rotate.h"\n')
replace(drv, 'void JOY_OLED_end() { hal_spi_bus_release(mui_u8g2_get_spi_device()); }',
        r'''void JOY_OLED_end() {
#if WUZ_ROTATE_180
    /* tested on the host in CI: wuzplay-cyberdeck-v9/tests/rotation_test.c */
    JOY_OLED_set_pos(WUZ_OLED_COL_OFFSET, wuz_rot_page_index(wuz_page_idx));
    for (int c = 0; c < 128; c++) {
        JOY_OLED_write_data(1, wuz_rot_page_byte(wuz_page_buf, wuz_page_n, c));
    }
#else
    JOY_OLED_set_pos(0, wuz_page_idx);
    for (int c = 0; c < 128; c++) {
        JOY_OLED_write_data(1, (c < wuz_page_n) ? wuz_page_buf[c] : 0);
    }
#endif
    hal_spi_bus_release(mui_u8g2_get_spi_device());
}''')
replace(drv, 'void JOY_OLED_send(uint8_t b) { JOY_OLED_write_data(1, b); }',
        'void JOY_OLED_send(uint8_t b) {\n    if (wuz_page_n < 128) {\n        wuz_page_buf[wuz_page_n++] = b;\n    }\n}')
replace(drv, '    hal_spi_bus_aquire(mui_u8g2_get_spi_device());\n    JOY_OLED_set_pos(0, y);',
        '    hal_spi_bus_aquire(mui_u8g2_get_spi_device());\n    wuz_page_idx = (uint8_t)(y & 7);\n    wuz_page_n = 0;')
replace(drv, 'return game_view_center_key_repeat_cnt() > 10; // about 3 sec',
        'return game_view_center_key_repeat_cnt() > 10 || game_view_key_pressed(INPUT_KEY_BACK); // hold SELECT ~3 s, or BACK')

# ---------------------------------------------------------------- 4b. BACK in stock list menus
lv = 'fw/application/src/mui/view/mui_list_view.c'
replace(lv, '        case INPUT_KEY_CENTER:\n            if (p_mui_list_view->selected_cb) {', r'''        case INPUT_KEY_BACK:
            /* Wuzplay: BACK activates the list's own back / exit / home entry, if it has one. */
            if (event->type == INPUT_TYPE_SHORT && p_mui_list_view->selected_cb) {
                uint16_t wuz_n = (uint16_t)mui_list_item_array_size(p_mui_list_view->items);
                for (uint16_t wuz_i = 0; wuz_i < wuz_n; wuz_i++) {
                    mui_list_item_t *wuz_it = mui_list_item_array_get(p_mui_list_view->items, wuz_i);
                    if (wuz_it->icon == ICON_BACK || (wuz_i == 0 && wuz_it->icon == ICON_HOME)) {
                        p_mui_list_view->selected_cb(MUI_LIST_VIEW_EVENT_SELECTED, p_mui_list_view, wuz_it);
                        break;
                    }
                }
            }
            break;

        case INPUT_KEY_CENTER:
            if (p_mui_list_view->selected_cb) {''')
s = read(lv)
if '#include "mui_icons.h"' not in s:
    first = s.index('\n') + 1
    write(lv, s[:first] + '#include "mui_icons.h"\n' + s[first:])

# ---------------------------------------------------------------- 4c. BACK in Chameleon main view -> menu
cv = 'fw/application/src/app/chameleon/view/chameleon_view.c'
s = read(cv)
pat = re.compile(r'(CHAMELEON_VIEW_EVENT_NEXT,\s*p_chameleon_view\);\s*\}\s*)\}')
if not pat.search(s):
    raise SystemExit('chameleon_view RIGHT handler not found')
s = pat.sub(lambda m: m.group(1) + '} else if (event->key == INPUT_KEY_BACK) {\n'
            '            if (p_chameleon_view->event_cb) {\n'
            '                p_chameleon_view->event_cb(CHAMELEON_VIEW_EVENT_MENU, p_chameleon_view);\n'
            '            }\n        }', s, count=1)
write(cv, s)

# ---------------------------------------------------------------- 5. shortcuts only on the home screen
desk = 'fw/application/src/app/desktop/app_desktop.c'
replace(desk, '#include "app_desktop.h"\n', '#include "app_desktop.h"\n#include "wuz_shortcuts.h"\n')
replace(desk, 'void app_desktop_on_run(mini_app_inst_t *p_app_inst) {\n',
        'void app_desktop_on_run(mini_app_inst_t *p_app_inst) {\n    wuz_shortcuts_set_enabled(true);\n')
replace(desk, 'void app_desktop_on_kill(mini_app_inst_t *p_app_inst) {\n',
        'void app_desktop_on_kill(mini_app_inst_t *p_app_inst) {\n    wuz_shortcuts_set_enabled(false);\n')

# ---------------------------------------------------------------- game list label
replace('fw/application/src/app/game/scene/game_scene_game_list.c', '"NBA 2K - SOON"', '"NBA 2K - COMING SOON"')

# Orientation check screen (direct-write path); its UI-path twin lives in Cyberdeck > Cyber Tools.
replace('fw/application/src/app/game/port/wuz/wuz_games.h', 'void wuz_nba2k_run(void);',
        'void wuz_nba2k_run(void);\nvoid wuz_screentest_run(void);')
replace('fw/application/src/app/game/scene/game_scene_game_list.c',
        '    mui_list_view_add_item(app->p_list_view, ICON_FILE, "NBA 2K - COMING SOON", wuz_nba2k_run);\n',
        '    mui_list_view_add_item(app->p_list_view, ICON_FILE, "NBA 2K - COMING SOON", wuz_nba2k_run);\n'
        '    mui_list_view_add_item(app->p_list_view, ICON_FILE, "SCREEN TEST", wuz_screentest_run);\n')

print('Wuzplay Cyberdeck v9 feature layer applied')
