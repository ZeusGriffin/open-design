# Video 02 Inventory

Source: https://youtube.com/shorts/peF3yi4RKAU?is=dKJqEAi5Z8-ATh0g

Indexed title: **My Home Assistant has AI Vision now**

## Confirmed from indexed video metadata

| Item | Type | Status | Evidence |
|---|---|---|---|
| Home Assistant | software/platform | CONFIRMED | Named in title |
| AI vision | software/capability | CONFIRMED | Named in title/description |
| Robot | created hardware/output | CONFIRMED | Description says a robot was made |
| Hand-watching / hand interaction | interaction | CONFIRMED | Description says it watches the creator's hands |
| Smart-device control | integration/output | CONFIRMED | Description says it controls smart devices |
| "Raccoon System" | system/project name | CONFIRMED | Named in description |
| 3D-printing context | fabrication context | CONFIRMED | Video metadata includes 3D-printing context |

## Reproduction references - not claimed as the original implementation

These are practical candidates for recreating the demonstrated behavior and must remain **LIKELY/REFERENCE** until frames/source files verify them:

- Camera or vision sensor
- Home Assistant automation layer
- Hand-tracking / gesture-recognition pipeline
- Python/OpenCV/MediaPipe-style CV layer, or equivalent
- MQTT / Home Assistant API / WebSocket event bridge
- ESP32/ESPHome actuator bridge, if local physical I/O is needed
- SBC / mini PC / Raspberry Pi-class compute for vision, depending on model
- Servo or pan/tilt actuation if the robot physically follows the hand
- 3D-printed enclosure/chassis
- Power regulator / USB-C supply / battery depending on mobility

## Do not lock yet

Exact camera, MCU, SBC, model, servos, printer, filament, slicer, wiring, protocol, AI model, and smart-home devices are all still UNKNOWN until frame-level inspection.
