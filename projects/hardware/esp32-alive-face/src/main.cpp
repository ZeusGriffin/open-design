#include <Arduino.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

// ORIGINAL demo. Assumes generic ESP32 + external 128x64 SSD1306 I2C OLED.
// DO NOT flash to M5Stack Cardputer ADV or LilyGO without board/display adaptation.
constexpr int SCREEN_WIDTH = 128;
constexpr int SCREEN_HEIGHT = 64;
constexpr int OLED_RESET = -1;
constexpr uint8_t OLED_ADDR = 0x3C;
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

void face(bool blink, bool smile) {
  display.clearDisplay();
  if (blink) {
    display.drawFastHLine(26, 24, 26, SSD1306_WHITE);
    display.drawFastHLine(76, 24, 26, SSD1306_WHITE);
  } else {
    display.fillRoundRect(28, 12, 20, 26, 8, SSD1306_WHITE);
    display.fillRoundRect(80, 12, 20, 26, 8, SSD1306_WHITE);
  }
  if (smile) {
    display.drawRoundRect(44, 43, 40, 14, 7, SSD1306_WHITE);
  } else {
    display.fillRoundRect(57, 44, 14, 14, 6, SSD1306_WHITE);
  }
  display.display();
}

void setup() {
  Serial.begin(115200);
  Wire.begin(); // Default ESP32 pins typically SDA=21, SCL=22; VERIFY for your board.
  if (!display.begin(SSD1306_SWITCHCAPVCC, OLED_ADDR)) {
    Serial.println("SSD1306 init failed: check address, wiring and display model");
    while (true) delay(1000);
  }
  Serial.println("ESP32 Alive Face original demo started");
}

void loop() {
  const uint32_t t = millis();
  const bool blink = (t % 3400) < 150;
  const bool smile = ((t / 5000) % 2) == 0;
  face(blink, smile);
  delay(50);
}
