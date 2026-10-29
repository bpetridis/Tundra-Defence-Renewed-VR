# Converting held waits to timers

15 of the mod's 17 `Utility.Wait` calls are gone. The two that remain are documented in place and
explained at the bottom.

## Why this was the right target

A `Utility.Wait` does not just delay — it **suspends the calling script and keeps its stack**.
The VM has a finite number of stacks, and a suspended one is unavailable to anything else for
the whole duration. That is the mechanism behind script lag on a heavy load order: not timer
count, but held stacks.

`RegisterForSingleUpdate` behaves completely differently. The function returns, the stack is
released immediately, and the VM schedules a callback. Same delay, nothing held.

The two worst offenders made this specific:

```papyrus
Event OnDeath(Actor akKiller)
  ...
  Utility.Wait(120 as Float)
  Self.Delete()
EndEvent
```

That is `aaafortraiderscript` and `aaafortstationaryguardscript`. Every corpse held a suspended
stack for **two full minutes**. A raid kills many actors on both sides at once, so the held
stacks piled up and overlapped — and they did it precisely when the engine was busiest. The cost
did not show up in steady state; it showed up at the worst moment.

## What changed, by script

| script | wait | now |
|---|---|---|
| `aaafortraiderscript` | `OnDeath` **120 s** | timer, salvage still evaluated on the delayed side |
| `aaafortstationaryguardscript` | `OnDeath` **120 s** | timer, same |
| `aaafortguardscript` | `OnDeath` 30 s | timer |
| `aaafortcitizenscript` | `OnDeath` 30 s | timer, and the wander tick now stops on death |
| `aaafortscavengerscript` | `OnDeath` 30 s | timer |
| `aaafortminerscript` | `OnDeath` 30 s | timer |
| `aaafortraiderscript` | `OnActivate` 5 s | timer |
| `aaafortguardscript` | `OnActivate` 5 s | timer |
| `aaafortstationaryguardscript` | `OnActivate` 5 s | timer |
| `aaafortcitizenscript` | `OnActivate` 5 s | timer |
| `aaafortscavengerscript` | `OnActivate` 5 s | timer |
| `aaafortguardscript` | `OnLoad` 1 s | timer |
| `aaafortstationaryguardscript` | `OnLoad` 1 s | timer |
| `aaaforttutorialscript` | `OnInit` 5 s | timer |
| `aaafortplayerquestscript` | `KillStationaryGuards` 60 s | deadline on the existing tick |
| `aaaforthousescript` | 1 s ×2 | **left alone**, see below |

## The problem that made this non-trivial

**A script instance has exactly one update timer.** Several of these scripts already used it, so
a converted wait cannot simply register its own — it would clobber whatever was pending, or be
clobbered.

Three different solutions, matched to the situation:

### Dead actors: a flag with priority

`aaafortguardscript` and `aaafortstationaryguardscript` have three things wanting the timer — the
post-load settle, the delayed corpse removal, and the normal 60 second cycle. `OnUpdate` now
dispatches on flags, delete first:

```papyrus
Event OnUpdate()
  If pendingDelete != 0
    If pendingDelete == 2
      ... salvage to the scavenger crate ...
    EndIf
    pendingDelete = 0
    Self.Delete()
    Return
  EndIf
  If pendingLoadInit
    pendingLoadInit = False
    Self.LoadInit()
    Return
  EndIf
  ... the normal 60 second body ...
EndEvent
```

This is safe because death is terminal: `OnDeath` unregisters and sets the flag, and nothing
re-arms the periodic branch afterwards because `OnUpdate` returns before reaching it.

`pendingDelete == 2` exists because the original read `ScavengerCount`, `equipBoxEnabled` and
`ScavengerCrateRef` **after** the wait, not before. A scavenger hired during those two minutes
still collects from the corpse. Moving that check earlier would have been a quiet behaviour
change, so it stayed on the delayed side.

### The player quest: a deadline, not a timer

`aaafortplayerquestscript` runs the raid watcher at 1 second while a raid is on.
`KillStationaryGuards` needed a 60 second window. Two registrations would have fought, so the
purge compares against a stored deadline on the watcher's own tick:

```papyrus
Function KillStationaryGuards()
  purgeEndTime = Utility.GetCurrentRealTime() + 60.0
  Self.RegisterForSingleUpdate(1 as Float)
EndFunction
```

and `OnUpdate` re-arms while `isRaid || purgeEndTime > 0.0`. Accurate to within a second, which
is far better than the window needs.

### The tutorial: a first-run flag

`OnInit` waited 5 seconds before handing out the opening items and spells. That is a held stack
**during quest startup** — during a load screen, the worst possible moment. Now `OnInit` only
arms a 5 second timer and `OnUpdate` runs the intro on its first tick via `introDone`. The intro
re-arms the normal 10 second cycle itself, so the first tutorial tick still lands at 15 seconds,
exactly as before.

## Two bugs fixed on the way

Both were introduced by the conversion and caught before building, but they are worth recording
because they are the trap in this kind of change.

`aaafortcitizenscript` has `OnCellAttach` and `OnCellDetach` from the earlier polling pass.
`OnCellDetach` calls `UnregisterForUpdate()` — which would have **cancelled a pending delete**,
stranding the corpse permanently if the player walked away during the 30 seconds. The original
`Utility.Wait` ran to completion regardless of where the player went. Both handlers are now
guarded on `pendingDelete`.

`aaafortcitizenscript.OnDeath` also never unregistered its wander tick. A dead citizen was still
waking every 180 seconds to consider moving between the inn and its entrance. Now fixed as a
side effect of needing the timer for the delete.

## What was left, and why

The two `Utility.Wait(1)` calls in `aaaforthousescript`. Each follows a `PlaceAtMe` of a citizen
and precedes a cast of the new reference to `aaafortcitizenscript` to set its `House` property.
The wait is very likely there because the author found that cast unreliable immediately after
`PlaceAtMe`, and getting it wrong means citizens never link back to their house, silently
breaking the occupancy counts.

Converting rather than removing is also a bad trade: the second sits inside a `While` loop over
`indoorCitizens`, so a timer version needs a spawn queue carried across ticks. That is real
complexity for a path that is player-initiated, runs at most `maxCitizens` times (3 by default),
and holds a stack for one second each.

Chasing 17 out of 17 would have meant taking a real risk on the one case where the delay looks
load-bearing, to remove two seconds of held stack on a menu click. Not worth it.

## Build

56 of 56 compile, zero errors. 185,223 → 188,814 bytes against the originally shipped bytecode.
The growth is expected: flags, dispatch branches and the comments explaining them.

**None of this has been tested in game.** The dead-actor paths are the ones to watch — corpses
should still vanish after their delay, and the scavenger crate should still collect from them.
