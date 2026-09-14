from pathlib import Path
import sys, re

root = Path(sys.argv[1] if len(sys.argv) > 1 else '.').resolve()

def read(rel):
    return (root/rel).read_text()

def write(rel, text):
    p=root/rel; p.parent.mkdir(parents=True, exist_ok=True); p.write_text(text)

def replace(rel, old, new, count=1):
    p=root/rel; s=p.read_text()
    if old not in s:
        raise SystemExit(f'pattern not found in {rel}: {old[:100]!r}')
    p.write_text(s.replace(old,new,count))

def ensure_src(make_rel, line):
    p=root/make_rel; s=p.read_text()
    if line in s: return
    marker='  $(PROJ_DIR)/app/game/port/common/driver.c \\\n'
    if marker in s:
        s=s.replace(marker, marker+line+' \\\n',1)
    else:
        raise SystemExit('Makefile marker not found')
    p.write_text(s)

board='fw/application/src/boards/board_oled.h'
s=read(board)
s=s.replace('#define BUTTONS_NUMBER 3','#define BUTTONS_NUMBER 4')
s=s.replace('#define BUTTON_3       7\n#define BUTTON_STOP    7', '#define BUTTON_3       7\n#define BUTTON_4       8\n#define BUTTON_STOP    8')
s=s.replace('#define BUTTONS_LIST { BUTTON_1, BUTTON_2, BUTTON_3}', '#define BUTTONS_LIST { BUTTON_1, BUTTON_2, BUTTON_3, BUTTON_4}')
s=s.replace('#define BSP_BUTTON_2   BUTTON_3', '#define BSP_BUTTON_2   BUTTON_3\n#define BSP_BUTTON_3   BUTTON_4')
s=s.replace('// #define APP_GAME_ENABLE','#define APP_GAME_ENABLE')
write(board,s)

bsp='fw/application/src/mod/bsp_btn.c'
s=read(bsp)
needle='    {BSP_BUTTON_2, false, BUTTON_PULL, bsp_button_event_handler},\n};'
if needle not in s: raise SystemExit('bsp button table marker not found')
s=s.replace(needle,'    {BSP_BUTTON_2, false, BUTTON_PULL, bsp_button_event_handler},\n    {BSP_BUTTON_3, false, BUTTON_PULL, bsp_button_event_handler},\n};',1)
write(bsp,s)

replace('fw/application/src/mui/mui_input.h', '    INPUT_KEY_RIGHT\n} input_key_t;', '    INPUT_KEY_RIGHT,\n    INPUT_KEY_BACK\n} input_key_t;')
replace('fw/application/src/app/game/view/game_view.c', 'uint8_t key_state[3] = {0};', 'uint8_t key_state[4] = {0};')

wuz_games_h = r'''#pragma once
#ifdef __cplusplus
extern "C" {
#endif
void wuz_snake_run(void);
void wuz_pong_run(void);
void wuz_dodge_run(void);
void wuz_reaction_run(void);
void wuz_nba2k_run(void);
#ifdef __cplusplus
}
#endif
'''
write('fw/application/src/app/game/port/wuz/wuz_games.h', wuz_games_h)

wuz_games_c = r'''#include "wuz_games.h"
#include "driver.h"
#include <stdbool.h>
#include <stdint.h>
#include <string.h>
#define W 128
#define H 64
static uint8_t fb[W*8];
static void clear_fb(void){ memset(fb,0,sizeof(fb)); }
static void px(int x,int y){ if(x>=0&&x<W&&y>=0&&y<H) fb[(y>>3)*W+x] |= (uint8_t)(1u<<(y&7)); }
static void box(int x,int y,int w,int h){ for(int yy=y;yy<y+h;yy++) for(int xx=x;xx<x+w;xx++) px(xx,yy); }
static void frame(int x,int y,int w,int h){ for(int i=0;i<w;i++){px(x+i,y);px(x+i,y+h-1);} for(int i=0;i<h;i++){px(x,y+i);px(x+w-1,y+i);} }
static void flush_fb(void){ for(uint8_t p=0;p<8;p++){ JOY_OLED_data_start(p); for(uint8_t x=0;x<W;x++) JOY_OLED_send(fb[p*W+x]); JOY_OLED_end(); } }
static bool exit_now(void){ return JOY_exit() || game_view_key_pressed(INPUT_KEY_BACK); }
static void idle_ms(uint16_t ms){ for(uint16_t i=0;i<ms/5;i++){ JOY_idle(); DLY_ms(5); } }
static void blink(void){ for(int i=0;i<4;i++){ if(i&1) memset(fb,0xff,sizeof(fb)); else clear_fb(); flush_fb(); idle_ms(90);} }
static void score_ticks(uint16_t s){ for(uint16_t i=0;i<(s%20);i++) box(2+i*6,2,4,3); }
void wuz_snake_run(void){
  int8_t sx[64], sy[64]; uint8_t len=5, dir=0; int fx=24, fy=8; bool pl=false,pr=false;
  for(uint8_t i=0;i<len;i++){ sx[i]=12-i; sy[i]=8; }
  while(!exit_now()){
    bool l=JOY_left_pressed(), r=JOY_right_pressed();
    if(l&&!pl) dir=(dir+3)&3; if(r&&!pr) dir=(dir+1)&3; pl=l; pr=r;
    int nx=sx[0], ny=sy[0]; if(dir==0)nx++; if(dir==1)ny++; if(dir==2)nx--; if(dir==3)ny--;
    if(nx<0)nx=31; if(nx>31)nx=0; if(ny<0)ny=15; if(ny>15)ny=0;
    for(uint8_t i=0;i<len;i++) if(sx[i]==nx&&sy[i]==ny){ blink(); return; }
    bool eat=(nx==fx&&ny==fy); if(eat && len<63) len++;
    for(int i=len-1;i>0;i--){sx[i]=sx[i-1];sy[i]=sy[i-1];}
    sx[0]=nx;sy[0]=ny; if(eat){ fx=JOY_random()%32; fy=JOY_random()%16; }
    clear_fb(); for(uint8_t i=0;i<len;i++) box(sx[i]*4,sy[i]*4,3,3); box(fx*4,fy*4,3,3); flush_fb(); idle_ms(115);
  }
}
void wuz_pong_run(void){
  int py=24, ai=24, bx=64, by=32, vx=2, vy=1; uint16_t score=0;
  while(!exit_now()){
    if(JOY_left_pressed()) py-=3; if(JOY_right_pressed()) py+=3; if(py<5)py=5; if(py>51)py=51;
    if(ai+6<by) ai+=2; else if(ai+6>by) ai-=2; if(ai<5)ai=5; if(ai>51)ai=51;
    bx+=vx;by+=vy; if(by<5||by>59){vy=-vy;by+=vy;}
    if(bx<=7 && by>=py && by<=py+13){ vx=2; bx=8; score++; }
    if(bx>=120 && by>=ai && by<=ai+13){ vx=-2; bx=119; }
    if(bx<0){ blink(); return; } if(bx>127){ bx=64;by=32;vx=-2; }
    clear_fb(); frame(0,0,128,64); box(4,py,3,14); box(121,ai,3,14); box(bx,by,2,2); score_ticks(score); flush_fb(); idle_ms(30);
  }
}
void wuz_dodge_run(void){
  int lane=1, olane=0, oy=-8, tick=0; uint16_t score=0; bool pl=false,pr=false;
  while(!exit_now()){
    bool l=JOY_left_pressed(),r=JOY_right_pressed(); if(l&&!pl&&lane>0)lane--; if(r&&!pr&&lane<2)lane++; pl=l;pr=r;
    if(oy>64){oy=-8;olane=JOY_random()%3;score++;} oy+=2; tick++;
    int cx=21+lane*43, ox=21+olane*43; if(oy>49 && oy<63 && lane==olane){blink();return;}
    clear_fb(); for(int y=(tick%8);y<64;y+=8){box(42,y,1,4);box(85,y,1,4);} box(cx-4,52,9,9); box(ox-4,oy,9,7); score_ticks(score); flush_fb(); idle_ms(55);
  }
}
void wuz_reaction_run(void){
  uint16_t wait=1000+(JOY_random()%2500); uint16_t e=0; clear_fb(); frame(18,18,92,28); flush_fb();
  while(e<wait){ if(exit_now())return; if(JOY_act_pressed()){blink();return;} idle_ms(10); e+=10; }
  memset(fb,0xff,sizeof(fb)); flush_fb(); uint16_t ms=0;
  while(!JOY_act_pressed()){ if(game_view_key_pressed(INPUT_KEY_BACK))return; idle_ms(5); ms+=5; if(ms>2000)break; }
  clear_fb(); frame(4,22,120,18); int bar=ms>=1000?116:(116-(ms*100/1000)); if(bar<4)bar=4; box(6,24,bar,14); flush_fb(); idle_ms(1200);
}
void wuz_nba2k_run(void){
  while(!exit_now()){
    clear_fb(); frame(0,0,128,64); box(14,12,7,38); box(21,12,15,7); box(21,27,15,7); box(21,43,15,7); box(52,12,7,38); box(59,12,7,7); box(66,19,7,7); box(59,26,7,7); box(66,33,7,17); for(int i=0;i<8;i++) box(88+i*4,46-(i%3)*4,2,4+(i%3)*4); flush_fb(); idle_ms(60);
  }
}
'''
write('fw/application/src/app/game/port/wuz/wuz_games.c', wuz_games_c)
ensure_src('fw/application/Makefile', '  $(PROJ_DIR)/app/game/port/wuz/wuz_games.c')

glist='fw/application/src/app/game/scene/game_scene_game_list.c'
s=read(glist)
if '#include "wuz_games.h"' not in s: s=s.replace('#include "tiny_tris.h"', '#include "tiny_tris.h"\n#include "wuz_games.h"')
start=s.index('static void game_scene_game_list_reload_folders')
end=s.index('void game_scene_game_list_on_enter',start)
newfun=r'''static void game_scene_game_list_reload_folders(app_game_t *app) {
    mui_list_view_clear_items(app->p_list_view);
    mui_list_view_add_item(app->p_list_view, ICON_HOME, _T(MAIN_MENU), (void *)-1);
    mui_list_view_add_item(app->p_list_view, ICON_FILE, "SNAKE", wuz_snake_run);
    mui_list_view_add_item(app->p_list_view, ICON_FILE, "PONG", wuz_pong_run);
    mui_list_view_add_item(app->p_list_view, ICON_FILE, "BREAKOUT", tiny_arkanoid_run);
    mui_list_view_add_item(app->p_list_view, ICON_FILE, "DODGE", wuz_dodge_run);
    mui_list_view_add_item(app->p_list_view, ICON_FILE, "REACTION", wuz_reaction_run);
    mui_list_view_add_item(app->p_list_view, ICON_FILE, "NBA 2K - SOON", wuz_nba2k_run);
}

'''
s=s[:start]+newfun+s[end:]
write(glist,s)

short_h=r'''#pragma once
#include <stdbool.h>
#include <stdint.h>
bool wuz_shortcuts_feed(uint8_t btn);
'''
short_c=r'''#include "wuz_shortcuts.h"
#include "app_timer.h"
#include "tag_emulation.h"
#include "settings.h"
static uint8_t seq[8]; static uint8_t seq_len=0; static uint32_t last_tick=0;
static bool same(const uint8_t *p, uint8_t n){ if(seq_len!=n)return false; for(uint8_t i=0;i<n;i++) if(seq[i]!=p[i])return false; return true; }
static void activate(uint8_t slot){ tag_emulation_init(); tag_emulation_change_slot(slot,false); settings_get_data()->chameleon_default_slot_index=slot; settings_save(); }
bool wuz_shortcuts_feed(uint8_t btn){
    uint32_t now=app_timer_cnt_get(); if(seq_len && app_timer_cnt_diff_compute(now,last_tick) > APP_TIMER_TICKS(1100)) seq_len=0; last_tick=now;
    if(seq_len>=sizeof(seq)) seq_len=0; seq[seq_len++]=btn;
    static const uint8_t med[]={3,2,3,3}; static const uint8_t gov[]={3,3,3,3,3}; static const uint8_t car[]={0,0,0,0,0}; static const uint8_t lit[]={2,2,2,2,2,2};
    if(same(med,4)){activate(0);seq_len=0;return true;} if(same(gov,5)){activate(1);seq_len=0;return true;} if(same(car,5)){activate(3);seq_len=0;return true;} if(same(lit,6)){activate(2);seq_len=0;return true;} return false;
}
'''
write('fw/application/src/wuz/wuz_shortcuts.h', short_h)
write('fw/application/src/wuz/wuz_shortcuts.c', short_c)
ensure_src('fw/application/Makefile', '  $(PROJ_DIR)/wuz/wuz_shortcuts.c')
mk=read('fw/application/Makefile')
if '$(PROJ_DIR)/wuz' not in mk: mk=mk.replace('INC_FOLDERS += \\\n', 'INC_FOLDERS += \\\n  $(PROJ_DIR)/wuz \\\n  $(PROJ_DIR)/app/game/port/wuz \\\n',1)
write('fw/application/Makefile',mk)

mui='fw/application/src/mui/mui_input.c'
s=read(mui)
if '#include "wuz_shortcuts.h"' not in s: s=s.replace('#include "cache.h"', '#include "cache.h"\n#include "wuz_shortcuts.h"')
old='''    case BSP_BTN_EVENT_SHORT: {\n        NRF_LOG_DEBUG("Key %d short push", btn);\n        mui_input_event_t input_event = {.key = btn,\n                                         .type = INPUT_TYPE_SHORT};\n        mui_input_post_event(&input_event);\n        break;\n    }'''
new='''    case BSP_BTN_EVENT_SHORT: {\n        NRF_LOG_DEBUG("Key %d short push", btn);\n        if (wuz_shortcuts_feed(btn)) break;\n        mui_input_event_t input_event = {.key = btn,\n                                         .type = INPUT_TYPE_SHORT};\n        mui_input_post_event(&input_event);\n        break;\n    }'''
if old not in s: raise SystemExit('mui short event block not found')
s=s.replace(old,new,1); write(mui,s)

cy_h=r'''#pragma once
#include "mini_app_defines.h"
extern mini_app_t app_cyberdeck_info;
'''
cy_c=r'''#include "app_cyberdeck.h"
#include "mini_app_registry.h"
#include "mini_app_launcher.h"
#include "mui_include.h"
#include "vfs.h"
#include <string.h>
#define CY_VIEW 1
typedef struct { mui_view_dispatcher_t *vd; mui_view_t *view; uint8_t selected; uint8_t screen; char detail[192]; } cyber_t;
static const char *items[]={"Meditations","Games","NFC Cards","Cyber Dashboard","Calendar","Contacts","Notes","Cyber Tools"};
static const char *paths[]={NULL,NULL,NULL,"/cyber.txt","/calendar.txt","/contacts.txt","/notes.txt","/tools.txt"};
#define ITEM_COUNT (sizeof(items)/sizeof(items[0]))
static void load_detail(cyber_t *a,const char *path){ memset(a->detail,0,sizeof(a->detail)); vfs_driver_t *d=vfs_get_default_driver(); int32_t n=d->read_file_data(path,a->detail,sizeof(a->detail)-1); if(n<0) strncpy(a->detail,"File not uploaded yet. Use MTools BLE.",sizeof(a->detail)-1); }
static void draw_wrapped(mui_canvas_t *c,const char *s){ char line[24]; int li=0,y=17; for(size_t i=0;;i++){ char ch=s[i]; if(ch=='\r')continue; if(ch=='\n'||ch==0||li>=21){ line[li]=0; mui_canvas_draw_utf8(c,4,y,line); y+=11; li=0; if(y>61||ch==0)break; if(ch!='\n') line[li++]=ch; } else line[li++]=ch; } }
static void on_draw(mui_view_t *v,mui_canvas_t *c){ cyber_t *a=v->user_data; mui_canvas_clear(c); mui_canvas_set_font(c,u8g2_font_6x10_tf); mui_canvas_draw_utf8(c,3,10,a->screen?"CYBERDECK / DETAIL":"CYBERDECK"); mui_canvas_draw_line(c,0,12,127,12); if(a->screen){draw_wrapped(c,a->detail);return;} int start=a->selected>2?a->selected-2:0; if(start>ITEM_COUNT-4)start=ITEM_COUNT-4; for(int i=0;i<4&&start+i<ITEM_COUNT;i++){int idx=start+i,y=24+i*10;if(idx==a->selected){mui_canvas_draw_box(c,1,y-8,126,10);mui_canvas_set_draw_color(c,0);}mui_canvas_draw_utf8(c,5,y,items[idx]);if(idx==a->selected)mui_canvas_set_draw_color(c,1);} }
static void on_input(mui_view_t *v,mui_input_event_t *e){ cyber_t *a=v->user_data; if(e->type!=INPUT_TYPE_SHORT)return; if(e->key==INPUT_KEY_BACK){if(a->screen)a->screen=0;else mini_app_launcher_kill(mini_app_launcher(),MINI_APP_ID_CYBERDECK);return;} if(a->screen){if(e->key==INPUT_KEY_CENTER)a->screen=0;return;} if(e->key==INPUT_KEY_LEFT){a->selected=(a->selected+ITEM_COUNT-1)%ITEM_COUNT;return;} if(e->key==INPUT_KEY_RIGHT){a->selected=(a->selected+1)%ITEM_COUNT;return;} if(e->key==INPUT_KEY_CENTER){if(a->selected==1){mini_app_launcher_run(mini_app_launcher(),MINI_APP_ID_GAME);return;} if(a->selected==2){mini_app_launcher_run(mini_app_launcher(),MINI_APP_ID_CHAMELEON);return;} if(a->selected==0){strncpy(a->detail,"BACK RIGHT BACK BACK\nthen hold near iPhone.\nNFC slot 0 = Meditations.",sizeof(a->detail)-1);a->screen=1;return;} load_detail(a,paths[a->selected]);a->screen=1;} }
static void run(mini_app_inst_t *inst){ cyber_t *a=mui_mem_malloc(sizeof(cyber_t)); memset(a,0,sizeof(*a)); inst->p_handle=a; a->vd=mui_view_dispatcher_create(); a->view=mui_view_create(); a->view->user_data=a; a->view->draw_cb=on_draw; a->view->input_cb=on_input; mui_view_dispatcher_add_view(a->vd,CY_VIEW,a->view); mui_view_dispatcher_attach(a->vd,MUI_LAYER_WINDOW); mui_view_dispatcher_switch_to_view(a->vd,CY_VIEW); }
static void kill(mini_app_inst_t *inst){ cyber_t *a=inst->p_handle; mui_view_dispatcher_switch_to_view(a->vd,VIEW_NONE); mui_view_dispatcher_detach(a->vd,MUI_LAYER_WINDOW); mui_view_dispatcher_free(a->vd); mui_view_free(a->view); mui_mem_free(a); inst->p_handle=NULL; }
static void event(mini_app_inst_t *inst,mini_app_event_t *ev){}
mini_app_t app_cyberdeck_info={.id=MINI_APP_ID_CYBERDECK,.name="Cyberdeck",.icon=0xe1f0,.deamon=false,.sys=false,.hibernate_enabled=false,.run_cb=run,.kill_cb=kill,.on_event_cb=event};
'''
write('fw/application/src/app/cyberdeck/app_cyberdeck.h',cy_h)
write('fw/application/src/app/cyberdeck/app_cyberdeck.c',cy_c)
ensure_src('fw/application/Makefile','  $(PROJ_DIR)/app/cyberdeck/app_cyberdeck.c')
mk=read('fw/application/Makefile')
if '$(PROJ_DIR)/app/cyberdeck' not in mk: mk=mk.replace('INC_FOLDERS += \\\n','INC_FOLDERS += \\\n  $(PROJ_DIR)/app/cyberdeck \\\n',1)
write('fw/application/Makefile',mk)

reg='fw/application/src/core/mini_app_registry.h'; s=read(reg); s=s.replace('    MINI_APP_ID_GAME = 9\n','    MINI_APP_ID_GAME = 9,\n    MINI_APP_ID_CYBERDECK = 10\n'); write(reg,s)
data='fw/application/src/core/mini_app_data.c'; s=read(data)
if '#include "app_cyberdeck.h"' not in s: s=s.replace('#include "app_game.h"','#include "app_game.h"\n#include "app_cyberdeck.h"')
s=s.replace('#ifdef APP_GAME_ENABLE\n    &app_game_info,\n#endif', '&app_cyberdeck_info,\n#ifdef APP_GAME_ENABLE\n    &app_game_info,\n#endif'); write(data,s)
desk='fw/application/src/app/desktop/app_desktop.c'; s=read(desk); s=s.replace('if (is_enabled || p_app->id == MINI_APP_ID_SETTINGS) {','if (is_enabled || p_app->id == MINI_APP_ID_SETTINGS || p_app->id == MINI_APP_ID_CYBERDECK || p_app->id == MINI_APP_ID_GAME) {'); write(desk,s)
print('Wuzplay Cyberdeck v9 patch applied')
