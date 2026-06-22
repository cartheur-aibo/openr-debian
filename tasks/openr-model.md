# OPEN-R programming model

OPEN-R programs are built as objects running on Sony Aperios.

The practical mental model:

- Objects communicate through messages.
- An object receives a message, handles it, and returns quickly.
- Long blocking loops can make the robot unresponsive.
- Separate perception, state, and actuation into small cooperating objects.

## Common object responsibilities

```text
SensorObject      reads touch, posture, paw, distance, battery events
VisionObject      receives camera frames or high-level vision events
MotionObject      emits joint or motion commands
FaceObject        controls Illume-Face / LEDs
BrainObject       state machine and behavior selection
LoggerObject      serial or wireless diagnostics
```

## First behavior design

```text
State: IDLE
Event: head touch
Action: set face LED + nod head once
Return to: IDLE
```

Avoid walking until the build/deploy loop is stable.
