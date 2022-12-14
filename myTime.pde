/**
 * Clock. 
 * 
 * The current time can be read with the second(), minute(), 
 * and hour() functions. In this example, sin() and cos() values
 * are used to set the position of the hands.
 */

import processing.serial.*;
Serial myPort;


int cx, cy;
float secondsRadius;
float minutesRadius;
float hoursRadius;
float clockDiameter;
float secondsValue;
float minutesValue;
float hoursValue;

int dock = 0;

void setup() {
  print(Serial.list());
  myPort = new Serial(this, Serial.list()[2], 57600);
  size(640, 360);
  stroke(255);

  int radius = min(width, height) / 2;
  secondsRadius = radius * 0.72;
  minutesRadius = radius * 0.60;
  hoursRadius = radius * 0.50;
  clockDiameter = radius * 1.8;

  cx = width / 2;
  cy = height / 2;

  secondsValue = second();
  minutesValue = minute();
  hoursValue = hour();
}

void draw() {
  background(0);
  frameRate(30);

  // Draw the clock background
  fill(80);
  noStroke();
  ellipse(cx, cy, clockDiameter, clockDiameter);

  // Angles for sin() and cos() start at 3 o'clock;
  // subtract HALF_PI to make them start at the top
  //float s = map(second(), 0, 2, 0, TWO_PI/30) - HALF_PI;
  float s = map(secondsValue, 0, 60, 0, TWO_PI) - HALF_PI;

  //float m = map(minute() + norm(second(), 0, 60), 0, 60, 0, TWO_PI) - HALF_PI; 
  float m = map(minutesValue + norm(secondsValue, 0, 60), 0, 60, 0, TWO_PI) - HALF_PI; 

  //float h = map(hour() + norm(minute(), 0, 60), 0, 24, 0, TWO_PI * 2) - HALF_PI;
  float h = map(hoursValue + norm(minutesValue, 0, 60), 0, 24, 0, TWO_PI * 2) - HALF_PI;
  String signal = myPort.readStringUntil('\n');
  if (signal != null) { 
    signal = trim(signal); 
    println(signal);
    if (int(signal) > 550) {
      dock += 1;
    }
    if (dock == 2) {
      secondsValue += 1;
      dock = 0;
    }
  }


  // Draw the hands of the clock
  stroke(255);
  strokeWeight(1);
  line(cx, cy, cx + cos(s) * secondsRadius, cy + sin(s) * secondsRadius);
  strokeWeight(2);
  line(cx, cy, cx + cos(m) * minutesRadius, cy + sin(m) * minutesRadius);
  strokeWeight(4);
  line(cx, cy, cx + cos(h) * hoursRadius, cy + sin(h) * hoursRadius);

  // Draw the minute ticks
  strokeWeight(2);
  beginShape(POINTS);
  for (int a = 0; a < 360; a+=6) {
    float angle = radians(a);
    float x = cx + cos(angle) * secondsRadius;
    float y = cy + sin(angle) * secondsRadius;
    vertex(x, y);
  }
  endShape();
}
