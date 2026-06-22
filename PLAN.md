# Programming the Sony AIBO ERS-7 (MIND 2) 

_A work plan_

## Summary

```
ERS-7 “hello body” program

1. Boot from OPEN-R stick.
2. Set Illume-Face LEDs.
3. Read head/back touch sensor.
4. On touch: nod head once.
5. Log event over wireless console.
```

## Overview

The Sony AIBO ERS-7 supports several levels of programmability, ranging from simple behavior customization to complete low-level robot control.

For an ERS-7 running **AIBO MIND 2**, there are three primary development approaches:

1. **R-CODE**

   * Easiest entry point.
   * Create scripted behaviors while preserving the MIND personality system.
   * Ideal for custom tricks, interactions, and entertainment behaviors.

2. **AIBO Remote Framework / Entertainment Player**

   * Control the robot remotely from a PC over Wi-Fi.
   * Useful for experimentation and automation.
   * Requires less knowledge of the internal architecture.

3. **OPEN-R SDK**

   * Sony's native robotics development platform.
   * Provides full access to sensors, actuators, vision, audio, networking, and LEDs.
   * Intended for robotics research and advanced development.

OPEN-R is the most powerful option and the focus of this guide.

---

# What is OPEN-R?

OPEN-R is Sony's robotics development environment built on top of the **Aperios** operating system.

Applications are written in C++ and execute as independent objects that communicate through asynchronous message passing.

This architecture is notable because it encourages event-driven design rather than traditional polling loops.

An OPEN-R application can access:

* Joint servos
* Camera frames
* Audio input/output
* Touch sensors
* Accelerometers
* Distance sensors
* LEDs and Illume-Face
* Wireless networking
* Memory Stick storage

Unlike MIND 2, OPEN-R does not provide the companion-pet personality layer.

When booted into OPEN-R, the robot behaves as a programmable robotics platform rather than an autonomous pet.

---

# Recommended Learning Path

## Step 1: Obtain the OPEN-R SDK

Locate:

* OPEN-R SDK documentation
* Sample applications
* ERS-7 hardware references
* OPEN-R API manuals

The SDK includes examples demonstrating:

* Motion control
* Sensor reading
* LED control
* Camera access
* Audio playback

Study the samples before attempting custom development.

---

## Step 2: Build the Development Environment

Historically, OPEN-R development used:

* Linux
* Sony's MIPS cross-compiler
* OPEN-R SDK build tools

Modern hobbyist setups typically use:

```bash
git
gcc
make
flex
bison
```

along with preserved Sony toolchain archives.

The target processor is a MIPS-based embedded system.

---

## Step 3: Compile a Sample Program

Before writing new code:

1. Build a sample project.
2. Generate the OPEN-R binaries.
3. Copy them to a test Memory Stick.
4. Confirm successful booting on the robot.

Good first examples include:

* Head movement
* LED flashing
* Touch sensor reading
* Audio playback

---

## Step 4: Prepare a Dedicated Memory Stick

Do **not** modify your working MIND 2 Memory Stick.

Instead:

1. Obtain a second compatible Memory Stick.
2. Install OPEN-R software on it.
3. Configure networking separately.
4. Use it exclusively for development.

This allows easy switching between:

* MIND 2 mode
* OPEN-R development mode

by swapping Memory Sticks.

---

## Step 5: Learn the OPEN-R Object Model

OPEN-R applications are composed of independent objects.

Typical architecture:

```text
+-------------------+
| Perception Object |
+---------+---------+
          |
          v
+-------------------+
| State Machine     |
+---------+---------+
          |
          v
+-------------------+
| Motion Controller |
+---------+---------+
          |
          v
+-------------------+
| Joint Outputs     |
+-------------------+
```

Each object:

* Receives messages
* Processes events
* Sends messages to other objects
* Returns control quickly

Avoid long-running loops.

The system is designed around asynchronous event handling.

---

# First Project: "Hello Body"

A useful introductory project:

## Objectives

* Boot from an OPEN-R Memory Stick
* Control LEDs
* Read touch sensors
* Move the head
* Log events over Wi-Fi

## Behavior

```text
Robot boots

↓

Set Illume-Face expression

↓

Wait for head touch

↓

Touch detected

↓

Nod head once

↓

Send event log message

↓

Return to waiting state
```

This exercise teaches:

* Deployment
* Boot process
* Sensor input
* Servo control
* State machines
* Wireless communication

---

# Suggested Progression

After completing "Hello Body":

## Level 1

* LED animations
* Touch interactions
* Sound playback

## Level 2

* Head tracking
* Vision processing
* Object detection

## Level 3

* Wireless control
* Multi-state behaviors
* Autonomous navigation

## Level 4

* Distributed robot behaviors
* Vision-guided interaction
* Research-grade robotics experiments

---

# MIND 2 vs OPEN-R

| Feature              | MIND 2  | OPEN-R |
| -------------------- | ------- | ------ |
| Pet personality      | Yes     | No     |
| Autonomous companion | Yes     | No     |
| Behavior scripting   | Limited | Full   |
| Sensor access        | Limited | Full   |
| Servo control        | Limited | Full   |
| Camera access        | Limited | Full   |
| Research use         | No      | Yes    |
| Custom robotics      | No      | Yes    |

---

# Recommendation

For users interested primarily in custom tricks and pet behaviors:

* Start with **R-CODE**.

For users interested in robotics, embedded systems, computer vision, or autonomous behavior:

* Move directly to **OPEN-R**.

The ERS-7 remains one of the most sophisticated consumer robotics platforms of its era, and OPEN-R provides unusually deep access to the hardware compared to modern consumer robots.
