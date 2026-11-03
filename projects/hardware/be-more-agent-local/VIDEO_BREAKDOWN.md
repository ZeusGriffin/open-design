# Full component extraction — brenpoly video

Video: https://youtu.be/l5ggH-YhuAw (published February 2, 2026)
Source summary and the creator's video description: https://zolotube.com/watch?v=l5ggH-YhuAw
3D model/PCB project: https://www.printables.com/model/1582055-bmo-from-adventure-time-local-ai-agent-project
Creator's enclosure ZIP/Gerbers/Feather script release: https://github.com/brenpoly/be-more-agent/releases/tag/v1.0-enclosure

## Listed original build components
| Item | Model / specification | Qty |
| --- | --- | --- |
| Main computer | Raspberry Pi 5, **16 GB** RAM | 1 |
| Camera | Raspberry Pi Camera Module v2 | 1 |
| NVMe adapter | Pimoroni NVMe Base Duo | 1 |
| UPS power management | Geekworm X1203 5V UPS shield | 1 |
| Display | Freenove 5-inch touchscreen monitor | 1 |
| Button controller | Adafruit Feather 32u4 Basic Proto | 1 |
| Microphone | Mini USB microphone | 1 |
| Speaker | Mini external USB 2.0 speaker | 1 |
| Momentary pushbuttons | 6 mm momentary switches | 7 |
| Magnets | 5 x 2 mm round magnets | 16 |
| Battery | 3.7 V lithium-ion (capacity/part number not specified) | 1+ as designed |

Also needed but not fully specified in the video description: compatible power supply, storage drive, wire/connectors, custom PCB, appropriate battery wiring/protection, printed enclosure components, fasteners as designed, cooling, and OS media. **Do not guess electrical wiring, battery cell size, UPS connection or charger behavior.** Follow the actual schematic/board manufacturer specs before powering.

## Creator links
- Video: https://youtu.be/l5ggH-YhuAw
- Original full Python project: https://github.com/brenpoly/be-more-agent
- Printable STL/OBJ/PCB designs: https://www.printables.com/model/1582055-bmo-from-adventure-time-local-ai-agent-project
- GitHub enclosure release: https://github.com/brenpoly/be-more-agent/releases/tag/v1.0-enclosure
- Software license: MIT; 3D and PCB design assets: CC BY-NC-SA 4.0 (personal/non-commercial, attribution/share-alike).

## What has NOT been downloaded into GitHub
We do not mirror copyrighted/independently licensed 3D models, binary sound/image assets, large AI model weights, or battery CAD in this public project folder. The linked source and deployment cloning step give access to them, with their original attribution and terms.

## Video chapters
- 00:00 intro
- 02:25 hardware
- 04:10 enclosure/3D design
- 07:15 software
- 15:49 physical assembly
- 18:55 demonstration
- 21:54 closing

## Default build approach
**Phase A:** Pi 5 on desk / mains power with plain monitor and microphone, demonstrate fully local text and voice. **Phase B:** add screen and camera. **Phase C:** buttons and enclosure. **Phase D:** validated UPS/battery after confirming board, cells and circuit.