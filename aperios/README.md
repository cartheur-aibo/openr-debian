# OPEN-R / Aperios

`Aperios` is Sony's embedded runtime environment for AIBO, while `OPEN-R` is the developer-facing object framework and API layer that AIBO applications are written against. The Sony docs and community material often blur those terms together, so this note uses both names to stay close to the original sources without claiming a sharper boundary than the manuals actually give us.

## Included Documentation

Official SDK documentation are in `../docs/aperios/`:

- `../docs/aperios/ProgrammersGuide_E.pdf`
- `../docs/aperios/Level2ReferenceGuide_E.pdf`
- `../docs/aperios/ModelInformation_7_E.pdf`

Academic AIBO programming papers are in:

- `../docs/papers/`

General information and historical background:

- https://en.wikipedia.org/wiki/AIBO

The public web is thin on Aperios internals. The Sony OPEN-R manuals are the only source of truth.

## Documentation overview

### 1. OPEN-R objects are single-threaded message processors

From the Programmer's Guide:

- objects exchange information using message passing
- a message contains data and a selector
- when a message arrives, the method for that selector is invoked
- an object can process only one message at a time
- if another message arrives while one is being processed, it is queued

Practical simulator implication:

- treat each `OObject` as an actor with a single in-order mailbox
- do not model concurrent handler execution inside one object

### 2. The core communication pattern is subject/observer, not free-form shared state

From the Programmer's Guide:

- sender side is the `subject`
- receiver side is the `observer`
- data travels in a `NotifyEvent`
- readiness travels in a `ReadyEvent`

Practical simulator implication:

- model links explicitly
- separate data delivery from readiness state
- do not let observers consume data unless they have asserted ready

### 3. Readiness is a handshake, not just a callback

The manuals describe this flow:

1. observer sends `ASSERT-READY`
2. subject may send data
3. observer handles it
4. observer asserts ready again for the next transfer

And on shutdown or backpressure:

- observer sends `DEASSERT-READY`
- subject stops forwarding to that observer

Practical simulator implication:

- observers need explicit ready state
- a simulator should let us test late-ready and deasserted paths

### 4. Subject-side buffering matters

From the Level 2 Reference Guide:

- `SetData()` copies data into subject-side transmission buffers
- `NotifyObserver()` / `NotifyObservers()` behave differently depending on ready state
- if observer is `ASSERT-READY`, data is sent immediately
- if observer is `DEASSERT-READY`, data is deleted
- if observer is neither, data is retained and sent later when it becomes ready

Practical simulator implication:

- the simulator should not be just "function call now"
- it should have per-link buffering and explicit discard behavior

### 5. Lifecycle order is explicit and important

From the Programmer's Guide:

- `DoInit()` creates subjects/observers and registers entries
- `DoStart()` enables subjects and usually sends `ASSERT_READY`
- `DoStop()` disables subjects and sends `DEASSERT_READY`
- `DoDestroy()` deletes subjects/observers

Practical simulator implication:

- a host-side shim should replay this exact lifecycle order
- many sample objects assume connections are not usable before `DoStart()`

### 6. Objects do not terminate themselves like normal processes

The Programmer's Guide describes the object lifecycle as an event loop that persists while the system is active.

Practical simulator implication:

- model objects as long-lived services
- termination should be system-driven, not handler-driven

### 7. ERS-7 device timing is uneven and device-specific

From `ModelInformation_7_E.pdf`:

- head distance sensor alternates near/far readings
- head distance sensor period is about 50 ms
- chest distance sensor period is about 40 ms
- some samples mention 16 ms notification cadence for certain data paths

Practical simulator implication:

- sensor replay should be channel-specific
- one global "tick" is too crude for believable ERS-7 behavior

## What We Can Safely Extrapolate For Simulation

These are reasonable simulator rules for this repo:

1. Each object has a FIFO mailbox.
2. Only one handler runs at a time per object.
3. Subject-to-observer delivery depends on observer ready state.
4. `NotifyObservers()` is delivery intent, not a guarantee of immediate handling.
5. `DoInit -> DoStart -> runtime messages -> DoStop -> DoDestroy` is the minimum lifecycle.
6. Sensor and actuator timing should be modeled as asynchronous event sources, not blocking calls.

## What We Should Not Pretend Yet

We still do not know enough to claim:

- exact Aperios scheduler policy
- exact queue limits for every system object
- interrupt timing behavior
- precise kernel-level priority inheritance or preemption semantics

So our simulator should present itself as:

- OPEN-R object-model simulation
- not a full Aperios emulator

## First Host Shim

This repo now includes a first host-side shim under:

- `include/OPENR`

It currently provides minimal versions of:

- `OObject`
- `OSystemEvent`
- `ONotifyEvent`
- `OSubject`
- `OObserver`
- `OSyslog` macros

This is intentionally small. The goal is to compile original OPEN-R sample source on Debian for lifecycle proof, not to claim ABI compatibility with Sony runtime binaries.

## HelloWorld Host Run

The original Sony `HelloWorld` sample can now be compiled natively and driven through its lifecycle:

```bash
make -C aperios run-hello-world
```

That host run exercises:

1. `DoInit`
2. `DoStart`
3. `DoStop`
4. `DoDestroy`

using the original `../samples/common/HelloWorld/HelloWorld/HelloWorld.cc` source.

## Next Step

The next useful implementation is to extend this shim so one real subject/observer sample can run with:

- explicit ready/deassert-ready transitions
- buffered notify behavior
- a small mailbox scheduler
- one fake sensor-driven event path
