from pathlib import Path
import sys

root = Path(sys.argv[1] if len(sys.argv) > 1 else '.').resolve()
makefile = root / 'fw/application/Makefile'
s = makefile.read_text()
anchor = 'INC_FOLDERS += \\\n'
if anchor not in s:
    raise SystemExit('INC_FOLDERS anchor not found')

for inc in [
    '  $(PROJ_DIR)/wuz \\\n',
    '  $(PROJ_DIR)/app/game/port/wuz \\\n',
    '  $(PROJ_DIR)/app/game/port/common \\\n',
    '  $(PROJ_DIR)/app/cyberdeck \\\n',
]:
    if inc not in s:
        s = s.replace(anchor, anchor + inc, 1)
makefile.write_text(s)

cyber = root / 'fw/application/src/app/cyberdeck/app_cyberdeck.c'
if cyber.exists():
    t = cyber.read_text()
    t = t.replace('u8g2_font_6x10_tf', 'u8g2_font_wqy12_t_gb2312a')
    t = t.replace('u8g2_font_wqy12_t_gb2312a_lite', 'u8g2_font_wqy12_t_gb2312a')
    cyber.write_text(t)

u8 = root / 'fw/application/src/mui/mui_u8g2.c'
if u8.exists():
    t = u8.read_text()
    old = 'u8g2_Setup_sh1106_128x64_noname_f(p_u8g2, U8G2_R0, u8x8_HW_com_spi_nrf52832, u8g2_nrf_gpio_and_delay_spi_cb);'
    new = 'u8g2_Setup_sh1106_128x64_noname_f(p_u8g2, U8G2_R2, u8x8_HW_com_spi_nrf52832, u8g2_nrf_gpio_and_delay_spi_cb);'
    if old in t:
        t = t.replace(old, new, 1)
    elif new not in t:
        raise SystemExit('OLED rotation marker not found')
    u8.write_text(t)

print('post-patch include/font/OLED rotation fixes applied')
