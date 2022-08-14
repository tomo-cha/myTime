#include <LiquidCrystal.h>

int PulseSensorPurplePin = 0;
int LED13 = 13;
int Signal;
int Threshold = 550;  //閾値
char Time[3];
int Second = 0;
int Minute = 0;
int Hour = 0;

int dock = 0; //ドックンドックン


LiquidCrystal lcd(7, 8, 9, 10, 11, 12);

void setup() {

  lcd.begin(16, 2);          // LCDの桁数と行数を指定する(16桁2行)
  lcd.clear();               // LCD画面をクリア
  lcd.setCursor(0, 0);       // カーソルの位置を指定
  lcd.print("heart time");       // 文字の表示
  pinMode(LED13, OUTPUT);
  Serial.begin(57600);
  delay(2000);
}

void loop() {
  if(Second == 60){
    Second = 0;
    Minute += 1;
  }
  if(Minute == 60){
    Minute = 0;
    Hour += 1;
  }
  if(Hour == 24){
    Hour = 0;
  }
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("heart time");
  lcd.setCursor(0, 1);
  lcd.print(String(Hour) + ":" + String(Minute) + ":" + String(Second));
  int count = 0;
  Signal = analogRead(PulseSensorPurplePin);
  if (Signal > Threshold) {                        // If the signal is above "550", then "turn-on" Arduino's on-Board LED.
    digitalWrite(LED13, HIGH);
  } else {
    digitalWrite(LED13, LOW);               //  Else, the sigal must be below "550", so "turn-off" this LED.
    count = 1;
  }
  if (count == 0) {
    dock += 1;
  }
  if (dock == 2) {
    Second += 1;
    dock = 0;
  }
  Serial.println(Signal);
  delay(100);
}
