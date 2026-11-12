#pragma once
#include <stdbool.h>
#include <stdint.h>

/* Multi-press NFC slot shortcuts (Wuzplay Cyberdeck v9).
 * Sequences are matched only while the home screen is active, so games,
 * Chameleon slot browsing and menus can never trigger them by accident. */
void wuz_shortcuts_set_enabled(bool on);

/* Returns true when this press completed a shortcut (the press is consumed). */
bool wuz_shortcuts_feed(uint8_t btn);
