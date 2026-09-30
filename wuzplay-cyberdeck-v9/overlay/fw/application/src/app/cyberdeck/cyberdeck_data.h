#pragma once
/* Static, read-only Cyberdeck content. Lives in flash; no RAM cost.
 * Meditations are ORIGINAL PARAPHRASES of Stoic ideas (Marcus Aurelius,
 * Seneca) - no modern translation text is copied. */

typedef struct {
    const char *who;
    const char *brief; /* shown in the browse view (3 lines max) */
    const char *full;  /* shown on SELECT, paged */
} cy_med_t;

static const cy_med_t cy_meds[] = {
    {"Marcus Aurelius", "Your mind is yours.\nEvents are not.",
     "You cannot command events, only your judgment of them. Choose a calm judgment and the day stays yours."},
    {"Marcus Aurelius", "The obstacle\nbecomes the path.",
     "What blocks the road becomes the road. Turn each hindrance into the next thing you practice."},
    {"Marcus Aurelius", "Do the work of\na human being.",
     "At dawn remind yourself: I rise to do human work and help others. Why resent the task I was made for?"},
    {"Marcus Aurelius", "Live as if each\nday is your last.",
     "Act, speak and think like someone who may leave today. Then nothing is wasted and nothing is feared."},
    {"Marcus Aurelius", "Drop the opinion,\nkeep the peace.",
     "Remove the opinion 'I am harmed' and the harm disappears. Peace is a choice of view."},
    {"Seneca", "We suffer more in\nimagination.",
     "Much of our pain is rehearsed in the mind. Meet trouble when it arrives, not a thousand times before."},
    {"Seneca", "Begin now.\nLife is short.",
     "It is not that we have little time; we waste much of it. Guard each hour as you would guard money."},
    {"Seneca", "Wealth is\nwanting less.",
     "Whoever needs little is rich. Now and then practice plain food and plain clothes to prove it."},
    {"Seneca", "Prepare for\nhardship early.",
     "Rehearse the loss of comforts in advance. Fortune strikes hardest those who never expected it."},
    {"Seneca", "Be a friend to\nyourself first.",
     "Judge yourself as you judge a friend: kindly but honestly. Then keep the promises you make to yourself."},
};
#define CY_MED_COUNT ((uint8_t)(sizeof(cy_meds) / sizeof(cy_meds[0])))

/* NFC card Details. These are shown by the Cyberdeck NFC Cards screen and are
 * NEVER written into raw NFC dump bytes. Phone-side actions run on the iPhone;
 * Wuzplay has no Internet connection and only presents the NFC tag. */
typedef struct {
    const char *name;
    const char *details;
} cy_nfc_t;

#define CY_NFC_TAIL " Hold iPhone near Wuzplay. Wuzplay is offline; the phone does the work."

static const cy_nfc_t cy_nfc[] = {
    {"CyberSync Alerts", "Runs the CyberSync Alerts phone action. Setup: WuzSync/CyberSync companion and this tag's action on iPhone." CY_NFC_TAIL},
    {"CyberSync All", "Runs the full CyberSync phone action. Setup: WuzSync/CyberSync companion and this tag's action on iPhone." CY_NFC_TAIL},
    {"CyberSync Dashboard", "Opens the Cyber Dashboard phone action. Setup: WuzSync/CyberSync companion and this tag's action on iPhone." CY_NFC_TAIL},
    {"CyberSync Network", "Opens the network reference phone action. Setup: WuzSync/CyberSync companion and this tag's action on iPhone." CY_NFC_TAIL},
    {"CyberSync System", "Opens the system phone action. Setup: WuzSync/CyberSync companion and this tag's action on iPhone." CY_NFC_TAIL},
    {"CyberSync Tools", "Opens the Cyber Tools phone action. Setup: WuzSync/CyberSync companion and this tag's action on iPhone." CY_NFC_TAIL},
    {"Drive Home", "Starts a drive-home route on iPhone. Setup: Apple Shortcut named Drive Home with your home address; needs Maps and Location." CY_NFC_TAIL},
    {"Find Car", "Navigates to your parked car. Setup: Apple Shortcut named Find My Car; needs saved car location. LEFT x5 arms it." CY_NFC_TAIL},
    {"Flashlight", "Turns the iPhone flashlight on. Setup: Apple Shortcut named Flashlight; iOS may ask to confirm. RIGHT x6 arms it." CY_NFC_TAIL},
    {"Govee Blue", "Sets your Govee lights to blue. Setup: Apple Shortcut named Govee Blue using your Govee integration." CY_NFC_TAIL},
    {"Govee Bright", "Sets your Govee lights bright. Setup: Apple Shortcut named Govee Bright using your Govee integration." CY_NFC_TAIL},
    {"Govee Movie", "Sets your Govee lights to movie mode. Setup: Apple Shortcut named Govee Movie using your Govee integration." CY_NFC_TAIL},
    {"Govee Off", "Turns your Govee lights off. Setup: Apple Shortcut named Govee Off using your Govee integration." CY_NFC_TAIL},
    {"Govee On", "Turns your Govee lights on. Setup: Apple Shortcut named Govee On using your Govee integration." CY_NFC_TAIL},
    {"Govee Red", "Sets your Govee lights to red. Setup: Apple Shortcut named Govee Red using your Govee integration." CY_NFC_TAIL},
    {"Govee Relax", "Sets your Govee lights to relax mode. Setup: Apple Shortcut named Govee Relax using your Govee integration." CY_NFC_TAIL},
    {"Open WuzSync", "Opens the WuzSync page or app on iPhone. Setup: WuzSync installed, or its real HTTPS URL written into the tag." CY_NFC_TAIL},
    {"Quick Note", "Starts a new note on iPhone. Setup: Apple Shortcut named Quick Note." CY_NFC_TAIL},
    {"Timer 10m", "Starts a 10 minute timer on iPhone. Setup: Apple Shortcut named Timer 10m." CY_NFC_TAIL},
    {"Meditations Tap", "Shows a short Stoic thought on iPhone. Setup: Apple Shortcut named Meditations Tap." CY_NFC_TAIL},
    {"Meditation Cyber", "Opens the stone/mist Stoic quote page on iPhone. Setup: host Meditation_Cyber_Web/index.html on a real HTTPS URL and write that URL into the tag. BACK, RIGHT, BACK, BACK arms it. The phone loads the page; Wuzplay only sends the link."},
};
#define CY_NFC_COUNT ((uint8_t)(sizeof(cy_nfc) / sizeof(cy_nfc[0])))

/* Companion text files reachable from Cyber Tools. Missing files show
 * FILE NOT FOUND and never crash. */
typedef struct {
    const char *label;
    const char *path;
} cy_file_t;

static const cy_file_t cy_tool_files[] = {
    {"tools.txt", "/tools.txt"},   {"commands.txt", "/commands.txt"}, {"quick.txt", "/quick.txt"},
    {"home.txt", "/home.txt"},     {"links.txt", "/links.txt"},       {"network.txt", "/network.txt"},
    {"system.txt", "/system.txt"}, {"alerts.txt", "/alerts.txt"},     {"emergency.txt", "/emergency.txt"},
    {"govee.txt", "/govee.txt"},   {"todo.txt", "/todo.txt"},
};
#define CY_TOOL_COUNT ((uint8_t)(sizeof(cy_tool_files) / sizeof(cy_tool_files[0])))
