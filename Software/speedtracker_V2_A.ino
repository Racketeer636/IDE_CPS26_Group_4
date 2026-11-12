#include <Stepper.h>

#include <Servo.h>

// ---- DC motor (BOW) ----
const int HB_PIN2 = 6;
const int HB_PIN7 = 7;
const int HB_PIN1 = 8;

Servo servo1;
Servo servo2;
Servo servo3;


void setup() {
  pinMode(HB_PIN2, OUTPUT);
  pinMode(HB_PIN7, OUTPUT);
  pinMode(HB_PIN1, OUTPUT);

  servo1.attach(12);// left srevo, to press string G
  servo2.attach(11);// middle servo, to press string A
  servo3.attach(10);//right servo, to press string D

  servo1.write(0);
  servo2.write(0);
  servo3.write(0);

  digitalWrite(HB_PIN2, HIGH);
  digitalWrite(HB_PIN7, LOW);

  Serial.begin(9600);
}

void loop() {
  if (Serial.available() > 0) {
    String line = Serial.readStringUntil('\n');
    int comma = line.indexOf(',');
    
    if (comma > 0) {
      int output1 = round(line.substring(0, comma).toFloat());
      int output2 = round(line.substring(comma + 1).toFloat());
    
      // Output 1 chooses the position of the servos
      if (output1 == 1) {
        //move left servo to press position
        servo1.write(17);
        //move middle srevo to off position
        servo2.write(10);
        //move right servo to off position
        servo3.write(10);
      } else if (output1 == 2) {
        // move middle servo to press position
        servo2.write(15);
        //move left servo to press position
        servo1.write(17);
        //move right servo to off position
        servo3.write(10);
      } else if (output1 == 3) {
        // move middle servo to press position
        servo2.write(15);
        //move left servo to off position
        servo1.write(10);
        //move right servo to off position
        servo3.write(10);
        } else if (output1 == 4) {
        // move middle servo to press position
        servo2.write(15);
        //move right servo to press position
        servo3.write(17);
        //move left servo to off position
        servo1.write(10);
      } else if (output1 == 5) {
        // move right servo to press position
        servo3.write(17);
        //move left servo to off position
        servo1.write(10);
        //move middle servo to off position
        servo2.write(10);
        } else if (output1 == 6) {
        // move right servo to press position
        servo3.write(17);
        //move left servo to press position
        servo1.write(17);
        //move middle servo to off position
        servo2.write(10);
      } else {
        // move all servos to off position
       servo1.write(10);
       servo2.write(10);
       servo3.write(10);
      }

      // Output 2 chooses the DC motor's speed/ instrument's tempo
      if (output2 == 1) {
        analogWrite(HB_PIN1, 200);
        delay(100);
        analogWrite(HB_PIN1, 0);//make it pause, to replicate strumming
        delay(250);
        analogWrite(HB_PIN1, 200);
        delay(100);
      } else if (output2 == 2) {
        analogWrite(HB_PIN1, 250);
        delay(100);
        analogWrite(HB_PIN1, 0);
        delay(100);
        analogWrite(HB_PIN1, 250);
      } else if (output2 == 3) {
        analogWrite(HB_PIN1, 250);
      } else { // if output is 0, stop playing
        analogWrite(HB_PIN1, 0);
      }
      
      Serial.print("Output 1: ");
      Serial.print(output1);
      Serial.print(" | Output 2: ");
      Serial.println(output2);
    }
  }
}
