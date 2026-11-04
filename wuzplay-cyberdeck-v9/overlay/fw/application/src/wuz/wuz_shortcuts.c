#include "wuz_shortcuts.h"

#include "app_scheduler.h"
#include "app_timer.h"
#include "settings.h"
#include "tag_emulation.h"
#include <string.h>

/* Button indexes as delivered by bsp_btn: 0=LEFT 1=SELECT 2=RIGHT 3=BACK. */
#define WUZ_KEY_LEFT 0
#define WUZ_KEY_RIGHT 2
#define WUZ_KEY_BACK 3

#define WUZ_SEQ_MAX 8   /* bounded sequence buffer */
#define WUZ_GAP_MS 450  /* max gap between presses of one sequence */

typedef struct {
    uint8_t len;
    uint8_t keys[WUZ_SEQ_MAX];
    uint8_t slot;
} wuz_pattern_t;

static const wuz_pattern_t k_patterns[] = {
    /* Last field = Chameleon slot INDEX (0-based), unchanged from the original v9 mapping. */
    /* BACK, RIGHT, BACK, BACK -> Meditation Cyber -> slot index 0 */
    {4, {WUZ_KEY_BACK, WUZ_KEY_RIGHT, WUZ_KEY_BACK, WUZ_KEY_BACK}, 0},
    /* BACK x5 -> Govee preset -> slot index 1 */
    {5, {WUZ_KEY_BACK, WUZ_KEY_BACK, WUZ_KEY_BACK, WUZ_KEY_BACK, WUZ_KEY_BACK}, 1},
    /* LEFT x5 -> Find My Car -> slot index 3 */
    {5, {WUZ_KEY_LEFT, WUZ_KEY_LEFT, WUZ_KEY_LEFT, WUZ_KEY_LEFT, WUZ_KEY_LEFT}, 3},
    /* RIGHT x6 -> Flashlight -> slot index 2 */
    {6, {WUZ_KEY_RIGHT, WUZ_KEY_RIGHT, WUZ_KEY_RIGHT, WUZ_KEY_RIGHT, WUZ_KEY_RIGHT, WUZ_KEY_RIGHT}, 2},
};
#define WUZ_PATTERN_COUNT (sizeof(k_patterns) / sizeof(k_patterns[0]))

static uint8_t m_seq[WUZ_SEQ_MAX];
static uint8_t m_seq_len = 0;
static uint32_t m_last_tick = 0;
static volatile bool m_enabled = false;

void wuz_shortcuts_set_enabled(bool on) {
    m_enabled = on;
    m_seq_len = 0;
}

/* Runs from the main-loop scheduler, never from the button interrupt/timer
 * context, because it touches flash-backed settings. */
static void wuz_activate_slot(void *p_event_data, uint16_t event_size) {
    (void)event_size;
    uint8_t slot = *(uint8_t *)p_event_data;
    if (!tag_emulation_slot_is_enabled(slot, TAG_SENSE_HF)) {
        return; /* empty slot: never activate it */
    }
    tag_emulation_change_slot(slot, false);
    settings_get_data()->chameleon_default_slot_index = slot;
    tag_emulation_save();
    settings_save();
}

bool wuz_shortcuts_feed(uint8_t btn) {
    if (!m_enabled) {
        return false;
    }

    uint32_t now = app_timer_cnt_get();
    if (m_seq_len && app_timer_cnt_diff_compute(now, m_last_tick) > APP_TIMER_TICKS(WUZ_GAP_MS)) {
        m_seq_len = 0;
    }
    m_last_tick = now;

    if (m_seq_len >= WUZ_SEQ_MAX) {
        m_seq_len = 0;
    }
    m_seq[m_seq_len++] = btn;

    for (uint8_t i = 0; i < WUZ_PATTERN_COUNT; i++) {
        const wuz_pattern_t *p = &k_patterns[i];
        if (m_seq_len == p->len && memcmp(m_seq, p->keys, p->len) == 0) {
            uint8_t slot = p->slot;
            m_seq_len = 0;
            app_sched_event_put(&slot, sizeof(slot), wuz_activate_slot);
            return true;
        }
    }
    return false;
}
