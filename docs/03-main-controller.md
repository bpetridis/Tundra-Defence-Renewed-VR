# The main controller, and the polling problem

`aaaFortPlayerQuestScript` — 1,389 lines decompiled, 46 KB compiled, the largest script in the mod.

## Correcting the previous note

[`02-script-analysis.md`](02-script-analysis.md) said the mod has no repeating timers because
`RegisterForUpdate` never appears. **That was true literally and wrong in substance.**

Fifteen scripts build a repeating timer out of `RegisterForSingleUpdate` by re-registering
themselves at the end of their own `OnUpdate`:

```papyrus
Event OnInit()
  RegisterForSingleUpdate(1.0)
EndEvent

Event OnUpdate()
  ; ... work ...
  RegisterForSingleUpdate(1.0)   ; re-arms itself
EndEvent
```

That is a permanent poll. Whether it matters depends entirely on whether the re-register is
guarded by a condition, so the fifteen split into two very different groups.

## Guarded — fine, leave alone

The re-register sits inside a conditional, so the loop stops when the work is done.

| script | interval | guard |
|---|---|---|
| `aaafortmainquestscript` | **0.01 s** | only while `stage == 1`, i.e. actively placing an object |
| `aaafortstationaryguardscript` | 60 s | conditional |
| `aaafortfarmplotscript` | 60 s | conditional |
| `aaafortguardscript` | 60 s | conditional |
| `aaaforttutorialscript` | 10 s | conditional |
| `aaafortcampfirescript` | 5 s | conditional |
| `aaafortmultiplaceonspawnscript` | 5 s | conditional |
| `aaafortvioletscript` | 5 s | conditional |

The 0.01 s one looks alarming and is not. It runs at 100 Hz only while the player is moving a
building around in placement mode, where it has to track the object smoothly. It stops the moment
placement ends. Worth revisiting for VR (see below) but it is not a background drain.

## Unguarded — these run forever, for the whole game

| script | interval | notes |
|---|---|---|
| **`aaafortplayerquestscript`** | **1 s** | the worst. Checks raid state every second even when no raid is running |
| `aaafortobjectcloningquestscript` | 5 s | |
| `aaafortobjectcloningresetterscript` | 5 s | |
| `aaafortrandomquestscript` | `randomFrequency` | player-configurable, so the floor is unknown |
| `aaafortidlemarkerscript` | 120 s | |
| `aaaforttravelingmerchantscript` | 120 s | |
| `aaafortcitizenscript` | 180 s | |

The 1 s and the two 5 s loops are the real cost. The 1 s one does this:

```papyrus
Event OnUpdate()
  If isRaid && Game.GetPlayer().IsInFaction(RaiderFaction) && (...).GuardCount <= 0
    EndRaid()
  EndIf
  If isRaid && CurrentRaiders <= 0
    EndRaid()
  EndIf
  RegisterForSingleUpdate(1.0)
EndEvent
```

Both branches require `isRaid`. With no raid running — which is almost all the time — it wakes up
every second, evaluates two conditions, does nothing, and re-arms. Forever, from the moment the mod
initialises until the save is abandoned.

**The fix is to arm the poll when a raid starts and stop it when the raid ends.** Behaviour is
identical; the cost disappears when nothing is happening. The same shape of fix applies to the
other six.

## The nine raid functions are copy-paste

`RandomRaid` dispatches to nine functions — Bandit, Draugr, Dragon, Nature, Giant, Necro, Vampire,
Werewolf, Falmer — each taking a difficulty and running about 125 lines. Together they are roughly
1,050 of the script's 1,389 lines.

Normalising actor names and numbers and diffing them against `BanditRaid`:

| function | lines differing from Bandit (of ~125) |
|---|---|
| `FalmerRaid` | **7** |
| `GiantRaid` | **8** |
| `DraugrRaid` | **9** |
| `NecroRaid` | 18 |
| `VampireRaid` | 18 |
| `WerewolfRaid` | 18 |
| `NatureRaid` | 39 |

They are the same function with different actors and counts. One parameterised routine plus a small
table of raid definitions would replace about 1,050 lines with perhaps 150, and make adding or
balancing a raid type a data change instead of another copy-paste.

This is the largest single cleanup available. It needs care — the differences, especially
`NatureRaid`'s 39 lines, are where the real behaviour variation hides and must be preserved exactly.

## Key binding is already dead code — good news for VR

```papyrus
Function BindKey(Int BindKey)
  ; Empty function
EndFunction

Function RebindDialog()
  ; Empty function
EndFunction

Int Function iGetKeyPressed(Int aiDXScanCode)
  Debug.Notification("Press and hold an unused key...")
  Return aiDXScanCode
EndFunction
```

All three are stubs. Whatever keyboard binding once existed was removed before the SSE release, and
the menu is opened some other way — `aaafortopenplayermenuscript` exists and is the likely route.

This matters because a DirectX scan-code hotkey is exactly the thing that does not work in VR
through OpenComposite, which never reaches Windows key state. The mod does not have that problem.
The stubs should be deleted rather than carried forward.

## For VR specifically

The placement system is the thing to look at. `aaafortmainquestscript` runs `UpdateInput` and
`UpdateObjectPosition` at 100 Hz while placing, positioning the object relative to the player and a
marker, with distance checks against `maxDistance` driving a red/green glow. In VR the camera is
the headset, so how the object tracks and where "in front of the player" lands are both worth
checking in the headset before changing anything.

Nothing here is broken-by-construction in VR. It needs testing, not redesign.

## Order of work suggested

1. Confirm the recovered source rebuilds to matching bytecode — before changing a line
2. Stop the seven unguarded polls, starting with the 1 s one
3. Convert the long `Utility.Wait` calls to timers
4. Collapse the nine raid functions, preserving behaviour exactly
5. Test placement in the headset and fix what VR actually breaks
6. Audit the `PlaceAtMe` sites for cleanup on every path
