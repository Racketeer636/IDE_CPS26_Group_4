# IDE_CPS26_Group_4
# This is a project by group 4 to make a playable music box with a CV input.


# Cyber Physical Systems 2026 - Group 4

This project’s goal was to create a music box controlled by a user with a camera as an input. This was inspired by the concept of an air guitar, a gesture that anyone can emulate even if they do not know how to play a guitar.

*Insert main pic here

The computer vision system tracks the user's left and right hands, with their movements being the two inputs for the machine learning (ML) model. The user's left hand controls the pitch of the music box and their right controls the strumming action.

*Insert simplified block diagram

Mechanically, the music box has 3 strings placed in the center of the resonance chamber. Each string is of a different length and has its own actuator to change its tone. All 3 strings share the same actuator for strumming. This allows the music box to generate a total of 6 tones.

*Pic of tone mechanism
*Pic of strummer mechanism

## Typical Behaviour

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

*Pic of input & output

If typical behaviour is not observed, please refer to the dedicated troubleshooting folder for both a flowchart and possible common solutions.

## Development

The current concept was chosen based on aesthetics, with adjustments made to the design based on the available materials and timeframe. The changes made to the original concept are detailed in each section.

![Initial sketch](images/Racketeer_Mainpic.jpg)

## Software
This section details the development of the software for this project. For details on troubleshooting, refer to the dedicated section in the repository.

### Computer Vision (CV) input
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

### Wekinator

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

### Processing

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

### Arduino

## Mechanical
This section details the development of the mechanical design for this project. For details on troubleshooting, refer to the dedicated section in the repository.

Materials used were primarily hand-cut MDF boards, combined with FDM 3D printed parts in PLA. These materials were chosen due to their availability in the IDE Battersea Makerspace, with off-cuts chosen to reduce material waste.

Should this concept be further developed, the use of laser-cut plywood for the side panels would enable a more polished prototype. Other materials like plastics may not have favourable characteristics for function as the walls of the resonance chamber.

## Electronics

This section details the development of the electronics for this project. For details on troubleshooting, refer to the dedicated section in the repository.

The music box utilises the following electronic components:
- SG90 servo motor 1 (Left string)
- SG90 servo motor (Middle string)
- SG90 servo motor (Right string)
- DC Motor (Strummer)

*Insert Block diagram
*Insert circuit diagram
