# First look at the decompiled scripts

All 56 scripts decompiled with Champollion v1.3.2 in under a tenth of a second, no failures.

## Decompile quality: good

The output is readable source, not salvage. Script names keep their original capitalisation,
properties come through intact, and every line carries a `#DEBUG_LINE_NO` comment mapping it back to
the original. Example, complete and unedited:

```papyrus
ScriptName aaaFortAddPlanScript Extends activemagiceffect

Potion Property Plan Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
  akCaster.AddItem(Plan as Form, 1, False) ; #DEBUG_LINE_NO:6
EndEvent
```

This is as good as decompiled Papyrus gets, and it is down to the author having shipped the scripts
with debug info left in.

## These scripts are from 2012, not 2017

Every header carries two dates:

```
Modified : 2012-09-16 19:41:14
Compiled : 2017-12-29 05:44:30
```

The 2017 release was a recompile of code written in **2012**, within a year of Skyrim's release. So
the practices in here are 14 years old, and predate most of what the community later worked out
about writing Papyrus that does not wreck a save.

## What the code actually looks like

### No repeating timers — better than expected

| call | uses |
|---|---|
| `RegisterForUpdate(` | **0** |
| `RegisterForSingleUpdate(` | 44 |
| `UnregisterForUpdate(` | 15 |

`RegisterForUpdate` sets up a timer that fires forever until something stops it, and it is the
classic cause of Papyrus grinding a save down. **There is not a single one.** Everything uses
`RegisterForSingleUpdate`, which fires once and has to be asked again — the pattern that is still
recommended today. For 2012 code that is genuinely surprising, and it means the mod is not carrying
the worst structural problem it could have.

> Correction worth recording: an earlier scan of mine reported 15 uses of `RegisterForUpdate`. That
> was wrong — the search was matching the tail of `UnregisterForUpdate`. The real count is zero.

### Long blocking waits — 17 of them, the main target

| script | waits |
|---|---|
| `aaafortguardscript` | 1 s, 30 s, 5 s |
| `aaafortstationaryguardscript` | 5 s, 1 s, **120 s** |
| `aaafortraiderscript` | 5 s, **120 s** |
| `aaafortcitizenscript` | 5 s, 30 s |
| `aaafortscavengerscript` | 5 s, 30 s |
| `aaafortplayerquestscript` | **60 s** |
| `aaafortminerscript` | 30 s |
| `aaaforthousescript` | 1 s, 1 s |
| `aaaforttutorialscript` | 5 s |

`Utility.Wait` holds a script thread open for the whole duration. A 120-second wait keeps that
thread alive for two minutes, and the behaviour across a save and reload is not something to rely
on. Most of these look like they are standing in for a timer and should become
`RegisterForSingleUpdate`.

This is the clearest optimisation available and it does not change behaviour.

### Object creation and cleanup — needs checking case by case

| call | uses |
|---|---|
| `PlaceAtMe` | 50 |
| `Delete()` | 54 |

`PlaceAtMe` creates a persistent reference that stays in the save unless deleted. The counts being
roughly balanced is reassuring, but it proves nothing on its own — the question is whether every
created reference reaches a `Delete()` on every path, including the ones where the player does
something unexpected. Worth auditing per site, not in aggregate.

## Next

- Read `aaafortplayerquestscript` (46 KB compiled, the main controller) properly
- Check that the source rebuilds to matching bytecode before changing anything
- Audit the `PlaceAtMe` sites
- Work out what, if anything, is specifically wrong in VR
