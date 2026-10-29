# How building pieces are actually placed, and the VR options for changing it

## How it works today

Confirmed by tracing every script in the chain. The whole thing is driven by **spells and
potions** — there is nothing physical about it anywhere.

1. The player drinks a build "plan" (a `Potion`). That fires a spell whose effect script is
   `aaafortobjectspawnerscript`, `aaafortmultiobjectspawner` or `aaafortboundaryspawner`.
2. That script calls `Game.GetPlayer().PlaceAtMe(...)` on the piece's base object, then calls
   `StartPositioning` on the main quest.
3. `StartPositioning` teleports the new object 1000 units **above** the player, sets `stage = 1`,
   and arms the update loop.
4. Every tick the loop computes a point `distance` units out along the **player's body facing**
   and `TranslateTo`s the object there. So the piece hovers in front of your face at a fixed
   range, and you aim it by turning your body.
5. Adjusting it uses **five more control spells**:
   - `aaafortspellcontrols` — two spells setting `inputPlus` / `inputMinus`, held to push the
     piece further away or pull it closer, or to rotate it. Holding both switches mode.
   - `aaafortchangerotationmodescript` — cycles the rotation axis
   - `aaafortresetpositionscript` — resets distance and rotation
   - `aaafortspellcontrolsconfirmscript` — confirms or cancels
6. Confirm calls `ConfirmPlacement`, which stops the translation, kills the glow shader and
   leaves the object where it is.

The pieces themselves are `Activator`, `Door`, `Furniture` and `Container` base objects — not
statics. House-sized activators, mostly.

This is a 2012 mouse-and-keyboard design. In VR you are casting spells at a ghost house floating
in front of your nose and nudging it with held spell casts. It works, but nothing about it uses
the hardware.

## What is available, and it is more than expected

All of these are **installed on this machine and expose Papyrus APIs**. No new DLL is needed for
any of the options below — that is the headline. The `.pex` files live in
`C:\Steam\steamapps\common\SkyrimVR\Data\Scripts`; decompile them to read the API.

### HiggsVR (`higgs_vr.dll`, `HiggsVR.pex`)

```papyrus
Function GrabObject(ObjectReference object, Bool isLeft) Global Native
ObjectReference Function GetGrabbedObject(Bool isLeft) Global Native
Bool Function CanGrabObject(Bool isLeft) Global Native
Bool Function IsTwoHanding() Global Native
Function RegisterForGrabEvent(Form form) Global Native   ; -> OnObjectGrabbed(refr, isLeft)
Function RegisterForDropEvent(Form form) Global Native   ; -> OnObjectDropped(refr, isLeft)
Function RegisterForPullEvent(Form form) Global Native   ; -> OnObjectPulled(refr, isLeft)
Function RegisterForStartTwoHandingEvent(Form form) Global Native
Function DisableHand(Bool isLeft) Global Native
Float Function GetSetting(String settingName) Global Native
```

`GrabObject` is the interesting one: it forces HIGGS to put a specific reference in a specific
hand. `OnObjectDropped` is the natural confirm trigger. `IsTwoHanding` is a free rotation mode.

### PapyrusVR / SkyrimVRTools (`skyrimvrtools.dll`, `PapyrusVR.pex`)

```papyrus
Float[] Function GetSkyrimDevicePosition(Int DeviceType) Global   ; HMD, left or right controller
Float[] Function GetSkyrimDeviceRotation(Int DeviceType) Global   ; euler, Skyrim world space
Float[] Function GetSkyrimDeviceQRotation(Int DeviceType) Global  ; quaternion
Function RegisterForVRButtonEvents(Form form) Global Native  ; -> OnVRButtonEvent(type, button, device)
Function RegisterForVROverlapEvents(Form form) Global Native ; -> OnVROverlapEvent(type, handle, device)
Int Function RegisterLocalOverlapSphere(Float radius, Float[] position, Float[] rotation, Int DeviceType) Global Native
Function RegisterForPoseUpdates(Form form) Global Native
```

With constants for `k_EButton_Grip`, `k_EButton_SteamVR_Trigger`, `k_EButton_A`,
`k_EButton_ApplicationMenu`, and event types `Pressed`, `Released`, `Touched`, `Untouched`,
`Entered`, `Exited`.

**This is the one that matters most.** It gives Papyrus the real controller and headset poses in
Skyrim world space, which is exactly what the current loop lacks.

### VRIK (`VRIK.dll`, `VRIK.psc` — source shipped)

```papyrus
Function VrikAddGestureAction(String modEventName, String mcmEntryName) native global
```

VRIK gestures can fire a **mod event**. So "confirm placement" could be a hand gesture the player
configures in VRIK's own MCM, costing zero polling.

### PLANCK (`planck.pex`)

Mostly actor ragdoll and aggression control. `GetLastHitNodeName()` is the only thing of interest
and it is not relevant to placement.

## The three routes

### A. HIGGS grab — pick the piece up

`HiggsVR.GrabObject(previewRef, isRightHand)` at the end of `StartPositioning`, then
`RegisterForDropEvent(previewRef)` and treat `OnObjectDropped` as `ConfirmPlacement()`.

**The big win: this deletes the hot loop.** HIGGS and Havok move the object natively, at full
frame rate, costing the Papyrus VM nothing. No `TranslateTo` every tick, no reading the player's
angles, no input polling. The only thing left to do periodically is the green/red range check,
and that can happen every 0.2 s instead of every frame — a twentyfold reduction.

**The risk, and it is a real one.** HIGGS grabs things with a Havok rigid body, and these pieces
are house-sized `Activator` objects. Three ways this can go wrong:

- `CanGrabObject` returns false, or `GrabObject` silently does nothing, because the piece has no
  movable rigid body
- it works, and a watchtower is now attached to your wrist at 1:1 scale, which is not usable
- placement range collapses to arm's reach, when the mod allows up to 6000 units from the fort
  marker

Likely verdict: **right for small props, wrong for architecture.** Worth testing on one small
piece and one large one before designing anything around it.

### B. Hand-aimed preview — aim with your hand instead of your body

Keep the floating preview, but drive it from the controller instead of the player:

```papyrus
Float[] handPos = PapyrusVR.GetSkyrimDevicePosition(PapyrusVR.EDeviceTypeRightController)
Float[] handRot = PapyrusVR.GetSkyrimDeviceRotation(PapyrusVR.EDeviceTypeRightController)
```

The piece then sits `distance` units out along the **controller's** forward vector — a laser
pointer with a building on the end. Rotation comes from your wrist.

This **directly fixes the dead-pitch problem** flagged in `docs/06-placement-loop.md`. The reason
looking up and down may not raise or lower the piece is that the loop reads the player's body
pitch, which in VR does not follow the head. A controller pose has real pitch, yaw and roll.

It also makes rotation far better. Today you hold a spell and the piece turns 10 degrees a tick
around one axis at a time, with a separate spell to cycle axes. With a wrist quaternion you just
turn your hand.

**But be clear about the cost: this does not reduce VM time.** The loop still runs, and the
`GetSkyrimDevicePosition` calls replace the `Game.GetPlayer()` calls one for one. It is a
large improvement in feel and correctness, and roughly neutral on performance. Only route A
actually removes the loop.

Lowest risk of the three — it works on any piece regardless of physics.

### C. Real buttons and gestures instead of five control spells

`RegisterForVRButtonEvents` gives `OnVRButtonEvent(Pressed/Released, k_EButton_Grip, deviceId)`.
That replaces the whole spell-casting apparatus with grip, trigger and face buttons. It is
event-driven, so the mode switches and confirm/cancel need no polling at all.

This is plainly what the author was reaching for with the dead `BindKey`, `RebindDialog` and
`iGetKeyPressed` stubs and the leftover `keyMenu = 40` property in `aaafortplayerquestscript`.
Those stubs are now worth finishing rather than deleting.

A hold-to-adjust control still needs something repeating, so this does not remove the loop
either — but it removes four of the five spells and makes the mod feel like a VR mod.

## Tactile touching specifically

`RegisterLocalOverlapSphere(radius, position, rotation, DeviceType)` attaches a sphere to a
controller and fires `OnVROverlapEvent` with `Entered` / `Exited` / `Touched` / `Untouched`.
That is genuine hand-proximity detection without HIGGS, and it would support the nicest version
of this:

reach out → your hand enters the ghost piece → haptic tick and it latches to your hand → move
and turn it with your hand → release the grip button to place it.

That gets the tactile feel of route A with none of the Havok risk, because the piece is still
being moved by `TranslateTo`, not by the physics engine.

**Caveat: the exact semantics of the overlap spheres are not confirmed.** It is not clear from
the API alone whether a sphere fires against world geometry and arbitrary references, or only
against other registered overlap objects. Spell Wheel VR and VR Climbing both depend on
SkyrimVRTools and are installed here — read how they use it before committing to this.

## Scope and dependencies — worth saying plainly

Two things this crosses that were previously settled:

1. **This is a new feature, not "fix and optimise, keep behaviour".** That was the scope chosen
   at the start. Changing the placement interaction is a deliberate widening of it.
2. **It adds a hard VR dependency** — HIGGS and/or SkyrimVRTools — and the project was scoped
   "VR-first, SSE compatible". A flat-screen SSE player has neither plugin.

Both are solvable the same way: build the VR interaction as an **additional layer that takes over
when the plugin is present**, leaving the spell controls as the fallback. The main quest script
already has a clean seam for this — `StartPositioning` arms the loop and `ConfirmPlacement`
ends it, so an alternative input path can sit behind one check without touching the rest.

## Recommendation

1. **Run the headset test first.** It is five minutes and it decides everything: start placing a
   piece, look up and down, and see whether it rises and falls. If it does not, route B is not
   an improvement, it is a bug fix.
2. **Then test whether HIGGS will grab a piece at all** — `CanGrabObject`, then `GrabObject` on
   one small item and one large building. That single answer decides whether route A is on the
   table, and route A is the only one that removes the loop.
3. Route B plus route C is the safe, high-value combination, and does not depend on either test
   going well.
4. Route A for small props only, if the grab test works.

The order matters because route A is worth far more than the other two put together — it is the
difference between making the loop cheaper and not having a loop.
