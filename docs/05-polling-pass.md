# First optimisation pass: the polling loops

Date: 2026-10-29. All 56 scripts still compile, zero errors.

The brief here was behaviour-preserving. Nothing below changes what the mod does; it changes how
often it wakes up to do it. That matters more in VR than on flatscreen, where there is far less
frame budget to give away to Papyrus.

## What changed

### `aaafortplayerquestscript` — a 1 second poll running for the entire game

`OnInit` armed a 1 second update and `OnUpdate` re-armed it unconditionally. Both of its checks
need `isRaid`, so outside a raid it woke every second, evaluated two conditions, did nothing and
went round again. Forever.

Now the watch is armed when a raid starts and stops when it ends. A `BeginRaid()` helper sets the
flag and arms the poll, replacing 27 bare `isRaid = True` assignments across the nine raid
functions, so the two can never drift apart. `OnUpdate` only re-arms while `isRaid` is still set,
and `EndRaid` already clears it.

Checked first that only this script writes `isRaid` — four others read it, none assign it.

**Outside a raid this script now costs nothing. It used to cost 3,600 wake-ups an hour.**

### `aaafortobjectcloningquestscript` — a poll that did nothing at all

```papyrus
Event OnUpdate()
  Self.RegisterForSingleUpdate(5 as Float)
EndEvent
```

That was the whole event. It woke every 5 seconds for the life of the save purely to schedule
itself again. The quest exists to hold its `ClosestObject` aliases, which the quest system fills
without any script tick. Both events removed; nothing else called into the script.

### `aaafortidlemarkerscript` — per-marker polling, multiplied

This runs on **every idle marker the player places**, each polling every 120 seconds forever, only
to apply a show/hide choice. A built-up fort has a lot of them.

Now gated on `OnCellAttach` / `OnCellDetach`, so markers only tick while the fort is loaded, and
the visibility is applied immediately on attach rather than up to two minutes later. It also stops
entirely once a marker has been broken down.

### `aaafortcitizenscript` — per-citizen polling, multiplied

Every citizen woke every 180 seconds to maybe move between the inn and its entrance — something
nobody can observe when the player is elsewhere. Now gated the same way.

### `aaaforttravelingmerchantscript` — real-time polling to watch the clock

The merchant packs up after two game days. It was waking every 120 seconds of real time to ask
whether the game day had changed: roughly **1,440 wake-ups to notice two events**.

Papyrus has `RegisterForSingleUpdateGameTime` for exactly this. One tick per game day, same
outcome, 1,438 fewer wake-ups.

## Left alone, deliberately

**`aaafortrandomquestscript`** polls on a player-configurable interval (`randomFrequency`,
default 90 s) and genuinely needs to — it drives random raids, merchant arrivals and tutorial
notes. This is the mod's core mechanic, not waste.

**`aaafortmainquestscript`'s 100 Hz loop** is guarded by `stage == 1`, which is object-placement
mode, where it has to track the object the player is positioning. It stops the moment placement
ends. It looks far worse than it is, and it is the thing to examine in the headset before touching.

## On SKSE

Permission was given to use SKSE where it helps. **It would not have helped here**, and no
dependency was added.

The one candidate was replacing the idle-marker visibility poll with a mod event — the flag is
toggled in exactly one place, so the main quest could simply announce the change. But mod events
need SKSE, and the polling is already gated to "player is at the fort". Trading a hard SKSE
requirement for one saved tick per marker per two minutes, while the player is present, is not a
good deal. The mod currently needs no SKSE at all, which is worth keeping unless something real is
bought with it.

Where SKSE may genuinely earn its place later is the VR placement system, but that is a question to
answer in the headset, not from reading code.

## Verification

```
Batch compile of 56 files finished. 56 succeeded, 0 failed.
```

Sizes against the originally shipped bytecode: 185,223 → 186,884 bytes (+0.9%). The growth is
expected — `BeginRaid` plus 28 call sites, the new cell events, and the split-out `ApplyVisibility`
function. Larger bytecode doing less work is the right trade.

**None of this has been tested in game yet.** It compiles and the reasoning is recorded; that is
not the same as working.
