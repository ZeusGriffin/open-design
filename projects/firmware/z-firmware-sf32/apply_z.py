#!/usr/bin/env python3
"""Patch the pinned LILYGO menu_app example in place, safely and repeatably.

Uses the official board support and firmware code. Never touches factory binaries.
Run from the Z-Firmware project directory after preparing the upstream source.
"""
from __future__ import annotations
import argparse
from pathlib import Path
import sys

START = 'static void app_icon_ui_init(struct Page *page)\n{'
END = 'static void home_page_on_create(struct Page *page)\n{'
SIGNATURE = '/* Z-Firmware v0.1 custom home screen'


def apply(upstream: Path, patchfile: Path) -> str:
    source = upstream / 'examples/menu_app/src/ui.c'
    if not source.is_file():
        raise ValueError(f'Cannot find upstream source: {source}')
    content = source.read_text(encoding='utf-8')
    newfunc = patchfile.read_text(encoding='utf-8').rstrip() + '\n\n'
    if SIGNATURE in content:
        if newfunc.strip() in content:
            return 'already applied (no changes)'
        raise ValueError('Found unknown Z-Firmware changes; refusing to overwrite')
    if content.count(START) != 1 or content.count(END) != 1:
        raise ValueError('Unexpected LILYGO source layout; pin the documented commit. No changes made')
    before, after_start = content.split(START, 1)
    _, after = after_start.split(END, 1)
    # Content before and after the single launcher function is left untouched.
    backup = source.with_suffix('.c.z-original-backup')
    if backup.exists():
        raise ValueError(f'Backup already exists without Z marker: {backup}. Refusing to overwrite')
    backup.write_text(content, encoding='utf-8')
    source.write_text(before + newfunc + END + after, encoding='utf-8')
    return f'patched {source}; original saved to {backup}'


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Apply Z-Firmware launcher overlay')
    parser.add_argument('--upstream', type=Path, required=True)
    args = parser.parse_args()
    try:
        print(apply(args.upstream.expanduser().resolve(), Path(__file__).resolve().parent / 'patches/z_launcher_home.c'))
    except (OSError, ValueError) as error:
        print(f'ERROR: {error}', file=sys.stderr)
        sys.exit(1)
