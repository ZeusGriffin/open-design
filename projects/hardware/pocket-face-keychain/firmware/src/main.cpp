// Pocket Face: original stand-alone Arduino firmware for XIAO ESP32-C3.
// Inspired by Tech Talkies MIT Hackster project. Not hardware-tested.
#include <Arduino.h>
#include <Wire.h>
#include <U8g2lib.h>
#include <math.h>
#ifndef FACE_USE_SH1106
#define FACE_USE_SH1106 1
#endif
#if FACE_USE_SH1106
U8G2_SH1106_128X64_NONAME_F_HW_I2C oled(U8G2_R0,U8X8_PIN_NONE);
#else
U8G2_SSD1306_128X64_NONAME_F_HW_I2C oled(U8G2_R0,U8X8_PIN_NONE);
#endif
struct Shape {float x,y,w,h;};
struct Preset {float ew,eh,ey,mw,mh;};
Preset styles[6]={
 {23,37,26,15,4}, {26,20,21,28,9}, {20,23,33,12,4},
 {18,41,22,10,10}, {24,8,36,8,3}, {21,22,30,21,3}
};
Shape current[3]={{40,26,23,37},{88,26,23,37},{64,55,15,4}};
int mood=0,lookX=0,lookY=0;
bool autoMode=true,liquid=false,blink=false;
uint32_t lastFrame=0,nextBlink=0,blinkEnd=0,nextAction=0;
void moodSet(int m){mood=m;lookX=0;lookY=0;}
void serialCommands(){
 while(Serial.available()){
  char c=Serial.read();
  int target=-1;
  if(c=='n')target=0;else if(c=='h')target=1;else if(c=='s')target=2;
  else if(c=='u')target=3;else if(c=='z')target=4;else if(c=='a')target=5;
  if(target>=0){moodSet(target);autoMode=false;}
  if(c=='l'){liquid=!liquid;Serial.println(liquid?"Liquid ON":"Liquid OFF");}
  if(c=='r'){autoMode=true;Serial.println("Auto ON");}
  if(c=='?')Serial.println("n neutral / h happy / s sad / u surprised / z sleepy / a angry / l liquid / r auto");
 }
}
void drawShape(Shape s){
 int w=constrain((int)roundf(s.w),2,128),h=constrain((int)roundf(s.h),2,64);
 int x=constrain((int)roundf(s.x-s.w/2),0,128-w),y=constrain((int)roundf(s.y-s.h/2),0,64-h);
 int r=max(0,min((int)(min(w,h)*0.44f),min(w,h)/2-1));
 oled.drawRBox(x,y,w,h,r);
}
void setup(){
 Serial.begin(115200);
 Wire.begin(6,7); // XIAO ESP32-C3 D4=SDA GPIO6 / D5=SCL GPIO7
 Wire.setClock(400000);
 oled.setI2CAddress(0x3C*2); // verify 0x3C vs 0x3D
 oled.begin();
 randomSeed(micros());
 uint32_t t=millis();nextBlink=t+2500;nextAction=t+1700;
 Serial.println("Pocket Face ready; ? for commands");
}
void loop(){
 uint32_t t=millis();serialCommands();
 if(!blink && (int32_t)(t-nextBlink)>=0){blink=true;blinkEnd=t+145;nextBlink=t+random(2100,5700);}
 if(blink && (int32_t)(t-blinkEnd)>=0)blink=false;
 if(autoMode && (int32_t)(t-nextAction)>=0){
  if(random(100)<40){lookX=random(-12,13);lookY=random(-8,9);}
  else moodSet(random(0,6));
  nextAction=t+random(1500,4000);
 }
 if(t-lastFrame<33)return;
 lastFrame=t;
 const Preset p=styles[mood];
 float wave=liquid?sinf(t/260.f)*1.1f:0.f;
 Shape target[3]={
  {40.f+lookX,p.ey+lookY+wave,p.ew+wave*.35f,blink?2.f:p.eh},
  {88.f+lookX,p.ey+lookY+wave,p.ew+wave*.35f,blink?2.f:p.eh},
  {64.f+lookX*.4f,55.f,p.mw,p.mh}
 };
 float e=liquid?.12f:.24f;
 oled.clearBuffer();
 for(int i=0;i<3;i++){
  current[i].x+=(target[i].x-current[i].x)*e;
  current[i].y+=(target[i].y-current[i].y)*e;
  current[i].w+=(target[i].w-current[i].w)*e;
  current[i].h+=(target[i].h-current[i].h)*e;
  drawShape(current[i]);
 }
 oled.sendBuffer();
}
