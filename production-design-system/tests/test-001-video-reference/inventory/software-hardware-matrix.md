# Test 001 - Software / Hardware Matrix

| Layer | Confirmed | Reference implementation candidates | Verification needed |
|---|---|---|---|
| Smart-home platform | Home Assistant (Video 2) | Home Assistant OS/Core | exact version/install |
| Vision | AI vision (Video 2) | OpenCV, MediaPipe, YOLO, LLM Vision, dedicated vision sensor | exact engine/model |
| Human input | hand observation (Video 2) | hand landmarks, gesture classifier, pose rules | exact gestures |
| Automation | smart-device control (Video 2) | HA automations, scripts, MQTT, REST, WebSocket | exact path |
| Robot | physical robot exists (Video 2) | desktop robot / pan-tilt unit | exact chassis |
| Fabrication | 3D-printing context (Video 2) | FDM printed shell, mounts, brackets | CAD/STL + material |
| Controller | not confirmed | ESP32 / RP2040 / robot controller | board marking |
| Compute | not confirmed | HA server + separate vision compute, or combined SBC | device marking |
| Actuation | not confirmed | micro servos / smart servos | servo type/count |
| Camera | not confirmed | USB camera / Pi camera / ESP32 camera / AI sensor | sensor marking |
| Power | not confirmed | USB-C 5V, buck converter, battery pack | connector/rail |
| Network | smart-device connectivity implied | Wi-Fi / Ethernet + MQTT/API | exact protocol |
