import oscP5.*;
import netP5.*;
import processing.serial.*;

Serial arduinoPort;
OscP5 trackerOsc; 
OscP5 wekinatorOsc;
NetAddress wekinator;

//variables to calculate speed average
float speedTotal = 0; //sum of speed readings
int speedSampleCount = 0; //total number of readings
int speedWindowStart = 0; //records the averaging window

//variables to detect hands
int handsDetected = 0;
float[] handX = new float[2]; //x co-ordinates of hands
float[] handY = new float[2]; //y co-ordinates of hands

float previousRightX; //stores right hand's wrist x position
float previousRightY; //stores right hand's wrist y position
int previousTime; //keeps the time of last position's recording
float rightHandSpeed = 0;
boolean havePreviousRightPosition = false;

int speedClass = 0;//stores the calculated sorted speed class to send to arduino
int lastOutput1 = 0;//stores wekinator's nost recent classification
boolean hadTwoHands = false;
int missingStartTime = -1;//to start the grace-period timer

void setup() {
  size(640, 480);
  textSize(18);

  arduinoPort = new Serial(this, "/dev/cu.usbmodem101", 9600);
  arduinoPort.bufferUntil('\n');

  // Receive hand tracking on port 7500
  trackerOsc = new OscP5(this, 7500);

  // Receive Wekinator's predictions on port 12000
  wekinatorOsc = new OscP5(this, 12000);

  // Send inputs to Wekinator on port 6448
  wekinator = new NetAddress("127.0.0.1", 6448);

  speedWindowStart = millis();
}

void draw() {
  background(30);
  fill(255);
  text("Hands detected: " + handsDetected, 20, 30);
  //text("Inputs: left screen hand x,y; right screen hand x,y", 20, 55);
  
// left hand strings and pitch UI
stroke(255, 205, 0);
strokeWeight(2);
line(50, 130, width / 2, 130);
noFill();
ellipse(width / 2 - 60, 130, 20, 14);
line(width / 2 -50, 130, width / 2 -50, 100);
fill(255);
text("G", 55, 125);

stroke(240, 148, 77);
strokeWeight(2);
line(50, 190, width / 2, 190);
noFill();
ellipse(width / 2 - 120, 190, 20, 14);
line(width / 2 -110, 190, width / 2 -110, 160);
fill(255);
text("G&A", 55, 185);

stroke(200, 100, 100);
strokeWeight(2);
line(50, 250, width / 2, 250);
noFill();
ellipse(width / 2 - 180, 250, 20, 14);
line(width / 2 -170, 250, width / 2 -170, 220);
fill(255);
text("A", 55, 245);

stroke(145, 110, 153);
strokeWeight(2);
line(50, 310, width / 2, 310);
noFill();
ellipse(width / 2 - 180, 310, 20, 14);
line(width / 2 -170, 310, width / 2 -170, 280);
fill(255);
text("A&D", 55, 305);

stroke(100, 100, 200);
strokeWeight(2);
line(50, 370, width / 2, 370);
noFill();
ellipse(width / 2 - 120, 370, 20, 14);
line(width / 2 -110, 370, width / 2 -110, 340);
fill(255);
text("D", 55, 365);

stroke(123, 178, 116);
strokeWeight(2);
line(50, 430, width / 2, 430);
noFill();
ellipse(width / 2 - 60, 430, 20, 14);
line(width / 2 -50, 430, width / 2 -50, 400);
fill(255);
text("D&G", 55, 425);

// Right hand's metronome-inspired UI
stroke(255);
strokeWeight(2);
line(480, 70, 480, 430);

  float trapezoidY;

if (speedClass == 0) {
  trapezoidY = 360;
} else if (speedClass == 1) {
  trapezoidY = 270;
} else if (speedClass == 2) {
  trapezoidY = 180;
} else {
  trapezoidY = 90;
}

stroke(255);
strokeWeight(2);
fill(192, 192, 192);

quad(450, trapezoidY,
     510, trapezoidY,
     540, trapezoidY + 50,
     420, trapezoidY + 50);
     
fill(255);
textAlign(CENTER, CENTER);
text("Tempo " + speedClass, 480, trapezoidY + 35);
textAlign(LEFT, BASELINE);

// markers for each hand's movement
  for (int i = 0; i < handsDetected; i++) {
    float screenX = handX[i] * width;
    float screenY = handY[i] * height;

    fill(i == 0 ? color(255, 100, 100) : color(100, 180, 255));
    ellipse(screenX, screenY, 30, 30);

    fill(255);
    text(i == 0 ? "Left hand" : "Right hand",
         screenX + 20, screenY);
  }
}
// printing out arduino's received messages- troubleshooting check
void serialEvent(Serial port) {
  String reply = port.readStringUntil('\n');

  if (reply != null) {
    println("Arduino says: " + reply.trim());
  }
}
// Calculating the average speed and classifying it
void addSpeedSample(float speed) {
  speedTotal += speed;
  speedSampleCount++;

  if (millis() - speedWindowStart >= 1000) { // averaging speed over 1 second
    float averageSpeed = speedTotal / speedSampleCount;
    
   //adding a buffer with hysteresis
   int measuredClass;

if (averageSpeed < 0.05) {
  measuredClass = 0;
} else if (averageSpeed < 0.3) {
  measuredClass = 1;
} else if (averageSpeed < 0.60) {
  measuredClass = 2;
} else {
  measuredClass = 3;
}

// Using buffered limits when changing class up and down
if (speedClass == 0) {
  if (averageSpeed >= 0.07) speedClass = measuredClass;
} else if (speedClass == 1) {
  if (averageSpeed < 0.03) speedClass = 0;
  else if (averageSpeed >= 0.35) speedClass = measuredClass;
} else if (speedClass == 2) {
  if (averageSpeed < 0.25 || averageSpeed >= 0.67) { //made this buffer thicker after testing
    speedClass = measuredClass;
  }
} else if (speedClass == 3) {
  if (averageSpeed < 0.55) speedClass = measuredClass;
}

    println("Average: " + nf(averageSpeed, 1, 3)
          + " | Speed class: " + speedClass);

    speedTotal = 0;
    speedSampleCount = 0;
    speedWindowStart = millis();
  }
}
// Grace period for if tracking on one hand is skipping
void handleMissingHands() {
  if (missingStartTime == -1) {
    missingStartTime = millis();
  }

  if (hadTwoHands && millis() - missingStartTime >= 500) { // clear the speed-calculating variables after half a second
    speedClass = 0;
    havePreviousRightPosition = false;
    speedTotal = 0;
    speedSampleCount = 0;
    speedWindowStart = millis();

    // Sending class 0 after the hand has been missing for over half a second
    arduinoPort.write(lastOutput1 + ",0\n");
    hadTwoHands = false;
  }
}

void oscEvent(OscMessage message) {
  if (message.addrPattern().equals("/mediapipe/hands")) {
    // Check that the message contains a hand count
    if (message.arguments().length < 1) {
      return;
    }

    int count = message.get(0).intValue();
    handsDetected = min(count, 2);

    // Start or continue the half second grace period if a hand is missing
    if (handsDetected < 2) {
      handleMissingHands();
      return;
    }

    int valuesPerHand = 21 * 4;

    // Checking that all expected values are there
    if (message.arguments().length < 1 + handsDetected * valuesPerHand) {
      handleMissingHands();
      return;
    }

    // stop the missing-hand timer when tracking continues
    missingStartTime = -1;
    hadTwoHands = true;

    // Reading each hand's wrist position
    for (int i = 0; i < handsDetected; i++) {
      int wristValue = 1 + i * valuesPerHand;
      handX[i] = message.get(wristValue).floatValue();
      handY[i] = message.get(wristValue + 1).floatValue();
    }

    // Sort hands by screen positions
    if (handX[0] > handX[1]) {
      float tempX = handX[0];
      float tempY = handY[0];

      handX[0] = handX[1];
      handY[0] = handY[1];

      handX[1] = tempX;
      handY[1] = tempY;
    }

    int currentTime = millis();

    // Calculate the right hand's speed
    if (havePreviousRightPosition) {
      float seconds = (currentTime - previousTime) / 1000.0;

      if (seconds > 0) {
        float dx = handX[1] - previousRightX;
        float dy = handY[1] - previousRightY;
        rightHandSpeed = sqrt(dx * dx + dy * dy) / seconds;

        addSpeedSample(rightHandSpeed);
      } else {
        rightHandSpeed = 0;
      }
    } else {
      // First position after startup or a long gap in readings
      rightHandSpeed = 0;
    }

    // Saving the pos and time for the next speed calculation
    previousRightX = handX[1];
    previousRightY = handY[1];
    previousTime = currentTime;
    havePreviousRightPosition = true;

    // Sending only left hand wrist X and Y position to Wekinator
    OscMessage input = new OscMessage("/wek/inputs");
    input.add(handX[0]);
    input.add(handY[0]);
    //input.add(handX[1]); sending right hand coordinates is not needed after revision
    //input.add(handY[1]);

    trackerOsc.send(input, wekinator);
  }

  // Keep Wekinator's Output 1 and use Processing's speedClass as Output 2.
  if (message.addrPattern().equals("/wek/outputs")) {
    if (message.arguments().length >= 1) {
      lastOutput1 = round(message.get(0).floatValue());
      
 //printing out outputs- troubleshooting check
      println("Sending classes to Arduino: "
            + lastOutput1 + ", " + speedClass);
      arduinoPort.write(lastOutput1 + "," + speedClass + "\n");
    }
  }
}
