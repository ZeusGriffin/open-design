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
    '  $(PROJ_DIR)/app/cyberdeck \\\n',
]:
    if inc not in s:
        s = s.replace(anchor, anchor + inc, 1)
makefile.write_text(s)

cyber = root / 'fw/application/src/app/cyberdeck/app_cyberdeck.c'
if cyber.exists():
    t = cyber.read_text()
    t = t.replace('u8g2_font_6x10_tf', 'u8g2_font_wqy12_t_gb2312a')
    cyber.write_text(t)

print('post-patch include/font fixes applied')
