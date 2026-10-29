# The placement loop, and what SKSE can and cannot take off it

This covers the one hot loop in the mod — the build preview in `aaafortmainquestscript` — and
answers the question of how much of this work could be moved into SKSE.

## What the loop actually does

Placing anything in this mod runs through `StartPositioning`. That function drops the object
1000 units above the player, sets `stage = 1`, and arms `RegisterForSingleUpdate(0.01)`. From
then until the player confirms or cancels, `OnUpdate` runs and re-arms itself, doing five things
per tick:

1. `UpdateInput()` — reads two booleans, `inputPlus` and `inputMinus`, and adds `DistanceSpeed`
   or `RotationSpeed` to the current distance or rotation.
2. `UpdateObjectPosition()` — works out a point `distance` units out along the player's facing
   and calls `TranslateTo` to send the object there.
3. Measures the object's distance from the fort marker and sets `canPlace`.
4. Plays the green or red glow shader on the object.
5. Re-arms for another tick.

The input booleans are not keys. They are set by two **spells**: `aaafortspellcontrols` is an
ActiveMagicEffect whose `OnEffectStart` sets a flag on the quest and whose `OnEffectFinish`
clears it. So the player casts and holds a spell, and the loop repeats the increment for as long
as the effect is running. That is why the loop has to exist at all: it is the repeat mechanism
for a hold-to-adjust control.

`aaafortplayerquestscript` still carries the fossils of a different plan — `BindKey(Int)`,
`RebindDialog()` and `iGetKeyPressed(Int)` are all empty or stubbed, and `keyMenu = 40` is left
as a property. The author started on real key bindings and gave up on them.

## Is it tied to the frame rate?

Yes, in the way that matters.

`RegisterForSingleUpdate(0.01)` asks for a hundred ticks a second. Papyrus cannot deliver that.
A pending update is only picked up on a game update pass, and the re-arm happens at the end of
the handler, so the next tick cannot arrive before the next pass. **One tick per frame is the
ceiling, and fewer when the VM is busy.** In practice the loop ticks at the frame rate.

That by itself would be harmless. The problem is that nothing in the loop was scaled by how long
a tick took:

```papyrus
distance += DistanceSpeed        ; 30 units, every tick
rotationx += RotationSpeed       ; 10 degrees, every tick
```

So the speed of the controls *is* the frame rate:

| frame rate | distance change | rotation |
|---|---|---|
| 30 fps | 900 units/sec | 300 deg/sec |
| 60 fps | 1,800 units/sec | 600 deg/sec |
| 90 fps | 2,700 units/sec | 900 deg/sec — two and a half turns a second |
| 120 fps | 3,600 units/sec | 1,200 deg/sec |

The author tuned 30 and 10 by feel on a 2017 machine. On a VR rig at 90 Hz the same numbers are
somewhere around half again to three times as fast as he intended, which is exactly the kind of
thing that makes a placement control feel uncontrollable.

Note that the *movement* of the object is not frame-rate dependent — `TranslateTo` interpolates
engine-side at 8000 units/sec and is smooth regardless. Only the rate at which the target is
recomputed, and the speed of the player's own adjustments, follow the frame rate.

## What changed

Four things, none of which change what the player sees at 60 fps:

**Movement is scaled by elapsed time.** `UpdateInput` now takes a `scale` argument, computed in
`OnUpdate` from `Utility.GetCurrentRealTime()`:

```papyrus
Float now = Utility.GetCurrentRealTime()
Float scale = (now - lastTickTime) * ReferenceRate
If scale <= 0.0 || scale > 4.0
  scale = 1.0
EndIf
```

`ReferenceRate` defaults to 60.0, so the behaviour at 60 fps is byte-for-byte what it always
was, and every other frame rate now matches it instead of scaling with the hardware. The clamp
stops a stall, a loading screen or the tutorial message box from producing one enormous tick.

Because the Int properties are written directly by other scripts (`aaafortobjectspawnerscript`
sets `distance` and `rotationz`) and read by the in-game settings menu, they stay Ints. Float
mirrors hold the fractional part so slow adjustments do not get rounded away to nothing, and
`SyncInputFromProperties()` re-reads them when positioning starts.

**The player reference is cached.** `UpdateObjectPosition` called `Game.GetPlayer()` five times
per tick and the `canPlace` block called it twice more. At 90 ticks a second that is roughly 630
calls a second to fetch a reference that never changes. It is now fetched once in
`StartPositioning`, with a None check as a fallback for a save that was mid-placement.

**The marker distance is measured once.** The `setBoundaries` branch called
`CurrentObject.GetDistance(marker)` up to three times in a single tick with nothing in between
that could change the answer. It is now one local float, and the interior check was restructured
into `If / Else` so the distance is not measured at all when `AdvancedMode` or an interior cell
makes the answer irrelevant.

**The glow shaders are only touched when the colour changes.** The original called `Stop` on one
shader and `Play` on the other every single tick — re-starting a shader that was already
running, 90 times a second, for as long as the player was positioning. A `glowState` variable
now tracks what is showing, and the shaders are only touched on a transition. It is reset to 0
in `StartPositioning`, in `CancelPlacement`, and in the `ConfirmPlacement` reuse path, because
that path carries on positioning a freshly placed object that has no shader on it yet.

**The interval is a property.** `UpdateInterval` defaults to 0.01, so nothing changes by
default. Now that movement is time-scaled, raising it no longer changes how fast the controls
move — only how closely the preview follows the player's view. That makes the tick rate safe to
test in the headset, which is the only place the answer can come from.

## What this does not fix, and needs the headset

`UpdateObjectPosition` reads `GetAngleZ()` and `GetAngleX()` from the player. In VR the player's
yaw generally does follow the headset, but the player's **pitch** is usually not the head's
pitch — the body stays level while the head looks up and down. If that holds here, looking up or
down will not raise or lower the preview object, and the vertical half of the placement control
is simply dead in VR.

This is a prediction, not a measurement. Test it before anything else is designed around it:
start placing an object, look up and down, and see whether it rises and falls.

Papyrus cannot read the headset pose. If the prediction is right, fixing it properly needs
native code.

## Can this be offloaded to SKSE?

The question splits in two, and the two halves are very different.

**SKSE's Papyrus functions do not move work off the Papyrus VM.** `Input.IsKeyPressed`,
`Form.RegisterForKey`, `UI.*`, mod events — these are extra *capabilities* for Papyrus scripts,
but a script calling them is still a script running on the VM with the same per-frame budget.
Swapping a vanilla call for an SKSE call does not make a loop cheaper. This is the heart of it:
there is no SKSE function that makes this loop stop costing VM time.

**Native C++ in an SKSE plugin does genuinely offload it.** A plugin can hook the per-frame
update, move the preview object with proper delta-time, read the real HMD pose, and cost the
Papyrus VM nothing at all. That is the only route that actually removes this loop.

So, concretely, what is on the table:

| option | moves work off the VM? | needs SKSE? | verdict |
|---|---|---|---|
| time-scaled movement, cached player, one distance read, glow on change | no, but cuts per-tick cost by roughly two thirds | no | **done** |
| raise `UpdateInterval` | yes, proportionally | no | tunable, needs headset testing |
| `RegisterForKey` instead of the control spells | no | yes | see below |
| native plugin owning the preview object | completely | yes, and a new DLL | the real answer for VR, decide after testing |

On `RegisterForKey`: SKSE VR's script sources are present on this machine
(`C:\Steam\steamapps\common\SkyrimVR\Data\Scripts\Source`, and `Form.psc` there does carry
`RegisterForKey`, `OnKeyDown` and `OnKeyUp`), so it would compile today. But it is the wrong
control surface for VR — in the headset the input comes from motion controllers, and the
spell-cast mechanism the author used is actually a reasonable fit for that, since holding a
trigger with the spell equipped is a natural hold-to-adjust. Keys would help flat-screen SSE
players and would let the dead `BindKey`/`RebindDialog` stubs be finished rather than deleted.
It would not make the loop cheaper, because a hold-to-repeat control needs something repeating
either way.

The honest recommendation: do not add a native dependency yet. This loop only runs while the
player is actively placing an object, it is now about a third of its former cost per tick, and
the question that decides whether native code is needed — whether the headset pose is readable
at all through Papyrus — is a five-minute test in the headset. Run that first.

## Cost per tick, before and after

Counting native calls in the common case (exterior, not boundaries, already glowing the right
colour):

| | before | after |
|---|---|---|
| `Game.GetPlayer()` | 7 | 0 |
| player getters | 5 | 5 |
| `GetDistance` | 1–3 | 1 |
| `TranslateTo` | 1 | 1 |
| shader `Play`/`Stop` | 2 | 0 |
| `GetCurrentRealTime` | 0 | 1 |
| **total** | **16–18** | **8** |

Roughly half the native calls per tick, and the two that were removed entirely — the repeated
`Game.GetPlayer()` and the redundant shader restarts — were the pure waste.
