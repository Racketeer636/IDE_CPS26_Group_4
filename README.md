# IDE_CPS26_Group_4
# This is a project by group 4 to make a playable music box with a CV input.

# Cyber Physical Systems 2026 - Group 4

## Overall concept

This project is a camera controlled strings-based music box. The user’s left hand height controls the instrument’s pitch and their right hand’s speed its tempo.

The instrument is inspired by the concept of an air guitar, being a gesture that anyone can emulate even if they cannot play a guitar.

![Initial sketch](images/Racketeer_Mainpic.jpg)

A computer vision system tracks the user’s hands, classifying their positions based on a pre-trained machine learning (ML) model. This information is then sent to the Arduino in the instrument to perform the corresponding action. For further details, refer to the dedicated section in software design.

![Initial sketch](images/Simplified-UX-BlockDiagram.jpg)

The Arduino controlling the instrument controls three servo motors and one DC motor. Each string has its own servo motor, allowing each string to produce two notes. The DC motor is responsible for strumming all three strings. For further details, refer to the dedicated section in software design.

## Mechanical Design

This section details the development of the mechanical design for this project.

![Initial sketch](images/Concept_sketch.jpeg)
![Initial sketch](images/Labelled_cutout.jpeg)

The instrument relies on the basic principle of an acoustic string instrument. In which a vibrating string is coupled to a soundboard via a bridge. The string's vibrations are transmitted through the bridge and to the soundboard, producing sound that is amplified by the resonance chamber.

The design was guided by form, with suitable materials sourced from IDE’s Makerspace in Battersea to construct the resonance chamber’s walls. Off-cuts of MDF board were mounted to an FDM 3D printed frame.

The 3D printed frame provides mounts for the wheels which strum the strings. Tuners to tension the strings are designed into the 3D printed frame.

Each servo controls an arm that presses into its respective string. The thinness of each arm is intentional, allowing it to flex as it presses into the string. This allows a more constant pressure to be applied.

![Initial sketch](images/Racketeer_Xsection.jpeg)

Two wheels strum the three strings. The lower one is responsible for the left and middle, while the upper is dedicated to the right string. Originally intended as a single wheel similar to a Hurdy Gurdy, the current design was adopted in favour of easier fine-tuning of the wheel to string contact distance. Both wheels are driven by a DC motor connected to a pulley system that uses a rubber-band as a belt.

## Hardware Design

| No. | Item | Count | Description |
|---|---|---|---|
| 1 | Servo Motor | 3 | SG90 used for this project, For pressing the strings to change tones. |
| 2 | DC Motor with Reduction Gearbox | 1 | Anreak GW1812 N20 used, can be substituted for any other high-torque DC motor given adjustments to the mounting. |
| 3 | Arduino Nano Every | 1 | The "Brain" of the instrument. Provided for the module, can be substituted with a similar microcontroller given adjustments to the code for pin connections. |
| 4 | USB DC Power Supply | 1 | DC Power supply that provides power to the motors. Provided as part of the course materials and can be substituted with a similar power supply. |
| 5 | L293D Half H Driver | 1 | H-Bridge for safely controlling the DC motor using the chosen microcontroller. |

![Initial sketch](images/CircuitDiagram-01.jpg)

## Software Design

This section details the communication between the programming and machine learning softwares used in this project. 

![Initial sketch](images/BlockDiagram.jpg)

**Mediapipe OSC:** This project uses Mediapipe OSC hand tracking script, hands.py, to track movement of two hands through a webcam and send the data, 1 hand-count value and 168 landmark values (84 per hand), to Processing via OSC on port 7500.

Pending image (Hands)

**Processing:** Receives the raw data. Checks the hand count value. Draws a visual interface to display the hand tracking points and UI elements. 

Pending image (Hand tracker, notes, metronome)
