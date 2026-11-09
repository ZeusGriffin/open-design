#include <Arduino.h>
#include <TFT_eSPI.h>
// Tamagotchi New Juke: ORIGINAL color-face animation demo.
// IMPORTANT: exact LilyGO T-Display S3 pin map and TFT_eSPI config
// MUST be verified before uploading to real hardware.
TFT_eSPI tft;
void drawFace(bool blink, bool happy) {
  const int w=tft.width(), h=tft.height();
  const int cx=w/2, cy=h/2;
  tft.fillScreen(TFT_BLACK);
  tft.fillRoundRect(cx-65,cy-62,130,124,22,TFT_MAGENTA);
  tft.fillRoundRect(cx-60,cy-57,120,114,18,TFT_BLACK);
  if(blink){
    tft.drawFastHLine(cx-40,cy-20,24,TFT_WHITE);
    tft.drawFastHLine(cx+16,cy-20,24,TFT_WHITE);
  }else{
    tft.fillRoundRect(cx-40,cy-37,24,34,9,TFT_WHITE);
    tft.fillRoundRect(cx+16,cy-37,24,34,9,TFT_WHITE);
  }
  if(happy) tft.drawRoundRect(cx-25,cy+20,50,20,9,TFT_CYAN);
  else tft.fillRoundRect(cx-9,cy+20,18,22,8,TFT_CYAN);
}
void setup(){
  Serial.begin(115200);
  tft.init();
  tft.setRotation(1);
  Serial.println("New Juke LILYGO starter: verify screen pin mapping!");
}
void loop(){
  unsigned long t=millis();
  drawFace(t%3100<140,(t/5000)%2==0);
  delay(80);
}
