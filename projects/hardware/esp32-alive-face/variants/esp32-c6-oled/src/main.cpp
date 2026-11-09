#include <Arduino.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
// Tamagotchi New Juke: ORIGINAL tiny OLED face demo.
// CHANGE these placeholders to verified pins for YOUR ESP32-C6 board.
// Many 1.3-inch OLEDs use SH1106 instead of SSD1306.
#ifndef JUKE_SDA
#define JUKE_SDA -1
#endif
#ifndef JUKE_SCL
#define JUKE_SCL -1
#endif
#if JUKE_SDA < 0 || JUKE_SCL < 0
#error "Set JUKE_SDA and JUKE_SCL to verified pins before building."
#endif
Adafruit_SSD1306 oled(128,64,&Wire,-1);
void drawFace(bool blink,bool happy){
  oled.clearDisplay();
  if(blink){
    oled.drawFastHLine(25,23,25,SSD1306_WHITE);
    oled.drawFastHLine(78,23,25,SSD1306_WHITE);
  }else{
    oled.fillRoundRect(29,12,18,28,7,SSD1306_WHITE);
    oled.fillRoundRect(81,12,18,28,7,SSD1306_WHITE);
  }
  if(happy) oled.drawRoundRect(44,44,40,14,7,SSD1306_WHITE);
  else oled.fillRoundRect(57,44,14,14,6,SSD1306_WHITE);
  oled.display();
}
void setup(){
  Serial.begin(115200);
  Wire.begin(JUKE_SDA,JUKE_SCL);
  if(!oled.begin(SSD1306_SWITCHCAPVCC,0x3C)){
    Serial.println("OLED init failed; verify controller/address/pins");
    while(true) delay(1000);
  }
}
void loop(){
  unsigned long t=millis();
  drawFace(t%3200<160,(t/5000)%2==0);
  delay(60);
}
