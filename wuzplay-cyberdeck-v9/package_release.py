#!/usr/bin/env python3
from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED
import argparse, hashlib, json, shutil, tempfile

EXTERNAL = {
    'alerts.txt': 'CYBER ALERTS\nUse this file for short alerts synchronized from the phone.\n',
    'calendar.txt': 'CALENDAR\nAdd short upcoming events here.\n',
    'commands.txt': 'COMMANDS\nQuick phone-assisted command notes.\n',
    'contacts.txt': 'CONTACTS\nKeep only the small contact list you want available on Wuzplay.\n',
    'cyber.txt': 'CYBER DASHBOARD\nWuzplay Cyberdeck v9\nNFC + BLE companion ready\n',
    'emergency.txt': 'EMERGENCY\nStore non-sensitive emergency reference information here.\n',
    'govee.txt': 'GOVEE\nCreate Apple Shortcuts matching the Govee preset names you import.\nNFC launches the phone-side Shortcut; Wuzplay does not control the Internet directly.\n',
    'home.txt': 'HOME\nHome quick actions and notes.\n',
    'links.txt': 'LINKS\nShort URLs and references.\n',
    'network.txt': 'NETWORK\nNon-secret network reference notes only. Do not store passwords.\n',
    'nfc.txt': 'NFC CARDS\nImport NFC preset BIN files in Card Emulator / Tag Explorer, not Firmware Upgrade.\n',
    'notes.txt': 'NOTES\nQuick notes.\n',
    'quick.txt': 'QUICK ACTIONS\nGovee / Flashlight / Find Car / Meditation Cyber\n',
    'system.txt': 'SYSTEM\nWuzplay Cyberdeck v9 companion data.\n',
    'todo.txt': 'TODO\n- Add items here\n',
    'tools.txt': 'CYBER TOOLS\nGames / NFC / Meditations / Dashboard\n',
}

NFC_DETAILS = {
    'cybersync_alerts': 'Tap the phone to open the configured CyberSync Alerts action.',
    'cybersync_all': 'Tap the phone to run the configured full CyberSync action.',
    'cybersync_dashboard': 'Tap the phone to open the Cyber Dashboard phone action.',
    'cybersync_network': 'Tap the phone to open the configured network-reference action.',
    'cybersync_system': 'Tap the phone to open the configured system action.',
    'cybersync_tools': 'Tap the phone to open the configured Cyber Tools action.',
    'drive_home': 'Tap the phone to start the phone-side Drive Home shortcut.',
    'find_car': 'Tap the phone to run the configured Find My Car shortcut.',
    'flashlight': 'Tap the phone to run the configured flashlight shortcut.',
    'govee_blue': 'Tap the phone to run the Govee Blue shortcut.',
    'govee_bright': 'Tap the phone to run the Govee Bright shortcut.',
    'govee_movie': 'Tap the phone to run the Govee Movie shortcut.',
    'govee_off': 'Tap the phone to run the Govee Off shortcut.',
    'govee_on': 'Tap the phone to run the Govee On shortcut.',
    'govee_red': 'Tap the phone to run the Govee Red shortcut.',
    'govee_relax': 'Tap the phone to run the Govee Relax shortcut.',
    'open_wuzsync': 'Tap the phone to open the configured WuzSync action.',
    'quick_note': 'Tap the phone to open the configured Quick Note action.',
    'timer_10m': 'Tap the phone to start the configured ten-minute timer action.',
    'meditations_tap': 'Tap the phone to open the compact Stoic meditation experience.',
    'meditation_cyber': 'Tap the phone to open Meditation Cyber: stone/mist parallax text that fades away after about 15 seconds.',
}

README = '''WUZPLAY CYBERDECK v9 — READ ME FIRST

1. Unzip THIS OUTER package.
2. DO NOT unzip 01_INSTALL_WUZPLAY_DFU_KEEP_ZIPPED.zip.
3. In Wuzplay Firmware Upgrade / Nordic DFU, select 01_INSTALL_WUZPLAY_DFU_KEEP_ZIPPED.zip.
4. Transfer files from 02_COMPANION_FILES_UNZIP_FIRST/External_Storage to Wuzplay external storage separately.
5. Import NFC preset BIN files through Card Emulator / Tag Explorer. NFC files do NOT go in Firmware Upgrade.
6. Phone-assisted actions such as Govee, Flashlight, Find Car, timers, and Meditation Cyber run on the phone. NFC launches them; Wuzplay itself has no Internet connection.

BUTTON SHORTCUT DESIGN
- BACK x5: Govee preset/action
- BACK, RIGHT, BACK, BACK: Meditation Cyber
- LEFT x5: Find My Car
- RIGHT x6: Flashlight

IMPORTANT
CI can verify compilation and the DFU archive structure. Physical button mapping, NFC behavior, screen orientation on the actual device, and phone interactions remain DEVICE TEST REQUIRED until tested on hardware.
'''

def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open('rb') as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b''):
            h.update(chunk)
    return h.hexdigest()


def validate_dfu(path: Path):
    if not path.is_file() or path.stat().st_size == 0:
        raise SystemExit(f'DFU missing or empty: {path}')
    with ZipFile(path) as z:
        names = set(z.namelist())
        if 'manifest.json' not in names:
            raise SystemExit('DFU does not contain manifest.json')
        manifest = json.loads(z.read('manifest.json').decode('utf-8'))
        app = manifest.get('manifest', {}).get('application')
        if not app:
            raise SystemExit('manifest.json has no application entry')
        bin_name = app.get('bin_file')
        dat_name = app.get('dat_file')
        if not bin_name or not dat_name or bin_name not in names or dat_name not in names:
            raise SystemExit('manifest application BIN/DAT references do not match ZIP contents')
        if len(z.read(bin_name)) == 0 or len(z.read(dat_name)) == 0:
            raise SystemExit('application BIN or DAT is empty')
        return manifest, bin_name, dat_name, hashlib.sha256(z.read(bin_name)).hexdigest(), hashlib.sha256(z.read(dat_name)).hexdigest()


def make_release(dfu: Path, out_dir: Path, repo_root: Path):
    manifest, bin_name, dat_name, bin_hash, dat_hash = validate_dfu(dfu)
    out_dir.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory() as td:
        root = Path(td) / 'Wuzplay_Cyberdeck_v9_Verified_Package'
        root.mkdir()
        install = root / '01_INSTALL_WUZPLAY_DFU_KEEP_ZIPPED.zip'
        shutil.copy2(dfu, install)
        companion = root / '02_COMPANION_FILES_UNZIP_FIRST'
        ext = companion / 'External_Storage'
        nfc = companion / 'NFC_Pack'
        web = companion / 'Meditation_Cyber_Web'
        instructions = companion / 'instructions'
        for p in (ext, nfc, web, instructions): p.mkdir(parents=True, exist_ok=True)
        for name, text in EXTERNAL.items(): (ext / name).write_text(text)
        (nfc / 'NFC_DETAILS.json').write_text(json.dumps(NFC_DETAILS, indent=2) + '\n')
        (nfc / 'READ_ME_FIRST.txt').write_text('Raw NFC BIN presets are imported with Card Emulator / Tag Explorer. Details metadata belongs in the supported metadata/UI layer; do not insert instruction text into unknown raw dump bytes.\n')
        source_web = repo_root / 'wuzplay-cyberdeck-v9' / 'companion' / 'Meditation_Cyber_Web' / 'index.html'
        if source_web.exists(): shutil.copy2(source_web, web / 'index.html')
        else: (web / 'README.txt').write_text('Meditation Cyber web source was not found in this checkout.\n')
        (instructions / 'PHONE_ACTIONS.txt').write_text('Phone-assisted actions require matching phone-side Shortcuts/automations. NFC does not remotely press a phone action without the phone reading the tag.\n')
        (root / 'READ_ME_FIRST.txt').write_text(README)
        verify = {
            'status': 'COMPILE VERIFIED - DEVICE TEST REQUIRED',
            'dfu_file': install.name,
            'dfu_sha256': sha256(install),
            'manifest': manifest,
            'application_bin': bin_name,
            'application_bin_sha256': bin_hash,
            'application_dat': dat_name,
            'application_dat_sha256': dat_hash,
        }
        (root / 'DFU_VERIFICATION.json').write_text(json.dumps(verify, indent=2) + '\n')
        outer = out_dir / 'Wuzplay_Cyberdeck_v9_Verified_Package.zip'
        with ZipFile(outer, 'w', ZIP_DEFLATED) as z:
            for p in root.rglob('*'):
                if p.is_file(): z.write(p, p.relative_to(root))
        print(outer)
        print('SHA256', sha256(outer))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('dfu')
    ap.add_argument('--out', default='wuzplay-output')
    ap.add_argument('--repo-root', default='.')
    args = ap.parse_args()
    make_release(Path(args.dfu), Path(args.out), Path(args.repo_root).resolve())

if __name__ == '__main__':
    main()
