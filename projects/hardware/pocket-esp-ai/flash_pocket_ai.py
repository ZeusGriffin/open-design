#!/usr/bin/env python3
"""Safety-first one-image ESP32-C3 flasher. No write without user's confirmation."""
import argparse
import hashlib
import importlib.util
import pathlib
import re
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent
FIRMWARE = ROOT / "firmware" / "pocket-esp-ai-by-huy-vector-english.bin"
EXPECTED_SHA256 = "3d9dc6d68cc0eebaacb05f20fb4cc49fda7802eda21400483f1d9fcf2a01cf98"
EXPECTED_BYTES = 3541630

def check_image():
    if not FIRMWARE.is_file():
        raise RuntimeError("Firmware missing: " + str(FIRMWARE))
    data = FIRMWARE.read_bytes()
    sha = hashlib.sha256(data).hexdigest()
    if sha != EXPECTED_SHA256 or len(data) != EXPECTED_BYTES:
        raise RuntimeError("STOP: firmware size or SHA-256 mismatch; do not flash.")
    if data[0] != 0xE9:
        raise RuntimeError("STOP: unexpected ESP image header.")
    print("PASS: original firmware hash, size, and ESP image marker checked.")
    print("SHA-256:", sha)
    return len(data)

def run_esptool(args):
    command = [sys.executable, "-m", "esptool", "--chip", "esp32c3"] + args
    print("Running:", " ".join(command))
    result = subprocess.run(command, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    print(result.stdout)
    if result.returncode:
        raise RuntimeError("esptool failed: exit code " + str(result.returncode))
    return result.stdout

def main():
    parser = argparse.ArgumentParser(description="Huy Vector Pocket ESP AI / ESP32-C3")
    parser.add_argument("--check-only", action="store_true", help="Verify package offline, do not flash.")
    parser.add_argument("--port", help="Serial port, e.g. COM7 or /dev/ttyACM0")
    args = parser.parse_args()
    image_size = check_image()
    if args.check_only:
        print("Package ready; hardware has NOT been flashed or tested.")
        return
    if importlib.util.find_spec("esptool") is None:
        raise RuntimeError("Install esptool: python -m pip install esptool")
    port = args.port or input("Enter ESP32-C3 serial port (e.g. COM7): ").strip()
    if not re.fullmatch(r"(COM\d{1,3}|/dev/[A-Za-z0-9._/-]+)", port, re.IGNORECASE):
        raise RuntimeError("Invalid port; disconnect other ESP devices.")
    print("Checking ESP32-C3 identity and flash capacity before writing...")
    output = run_esptool(["--port", port, "--baud", "115200", "flash-id"])
    match = re.search(r"Detected flash size:\s*(\d+)\s*(MB|KB|GB)", output, re.IGNORECASE)
    if not match:
        raise RuntimeError("STOP: flash capacity not confirmed.")
    size = int(match.group(1)) * {"KB":1024,"MB":1024**2,"GB":1024**3}[match.group(2).upper()]
    if size < image_size:
        raise RuntimeError("STOP: image does not fit the detected flash.")
    print("WARNING: Writing from 0x0 can replace existing firmware, partitions and settings.")
    print("Confirm exact Huy Vector ESP32-C3 SuperMini hardware: NOT S3, C6 or Cardputer.")
    if input("Type FLASH to write exactly one image: ").strip() != "FLASH":
        print("Cancelled: no write.")
        return
    run_esptool(["--port", port, "--baud", "460800",
                 "--before", "default-reset", "--after", "hard-reset",
                 "write-flash", "0x0", str(FIRMWARE)])
    print("Write command completed. Test OLED, Wi-Fi, microphone, speaker and wake word on hardware.")

if __name__ == "__main__":
    try:
        main()
    except (RuntimeError, KeyboardInterrupt, OSError) as exc:
        print("ERROR:", exc, file=sys.stderr)
        sys.exit(1)
