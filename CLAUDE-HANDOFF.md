# Handoff — Tundra Defence Renewed VR

Append to this after every finding, every build, every retraction. Read the last
**RESUME HERE** first.

---

# 2026-10-29 — project started, source recovered, polling problem found

## What this is

Reviving **Tundra Defense** by Aykan ([Nexus 14310](https://www.nexusmods.com/skyrimspecialedition/mods/14310))
with his permission. He no longer has the source. Repo:
https://github.com/bpetridis/Tundra-Defence-Renewed-VR

**Agreed scope** (see `docs/00-scope.md`): fix and optimise, keep behaviour, **no new features**.
VR-first, SSE compatible — verify on Skyrim VR 1.4.15, do not gratuitously break flatscreen, and do
not claim SSE support that has not been tested.

## State of the repo

| path | holds |
|---|---|
| `original/` | shipped 1.04 ESP + both BSAs, untouched |
| `Source/Scripts/` | **56 recovered `.psc` files** |
| `extracted/scripts/` | the 56 `.pex` they came from |
| `tools/Extract-Bsa.ps1` | BSA extractor written for this job |
| `tools/champollion/` | how to fetch the decompiler (exe is gitignored) |
| `docs/00..03` | scope, survey, script analysis, main controller |

Meshes and sounds are gitignored — unchanged, regenerate from the BSAs.

Pushed to `main`. The user's own `Initial commit` (README + MIT LICENSE) is preserved at the base;
my work was rebased on top, not force-pushed.

## Recovering the source — done, and it went well

No `.psc` existed anywhere in the BSA, so the author's account was accurate. But the shipped `.pex`
files kept **debug info and original source filenames with original capitalisation**, so
Champollion v1.3.2 produced readable source, not salvage. All 56 decompiled, no failures.

```powershell
.\tools\champollion\Champollion.exe -r -t -e -p .\Source\Scripts .\extracted\scripts
```

**The code is from 2012, not 2017.** Every header carries `Modified: 2012-09-16` next to
`Compiled: 2017-12-29`. The SSE release was a recompile. Practices are 14 years old.

## The plugin is in good shape

Form version **1.7** (a real SSE conversion, not a renamed LE plugin), **`Skyrim.esm` is the only
master** (no DLC dependency), 2,368 records, not localized, not ESM-flagged. Author `Aykan`.

## THE MAIN FINDING: seven permanent poll loops

**I got this wrong twice before getting it right. Both corrections are recorded in the docs.**

1. First scan reported 15 `RegisterForUpdate` calls. Wrong — the search was matching the tail of
   `UnregisterForUpdate`. The real count is **zero**.
2. I then said the mod has no repeating timers. **True literally, wrong in substance.** Fifteen
   scripts build a permanent timer out of `RegisterForSingleUpdate` by re-arming themselves at the
   end of their own `OnUpdate`.

What matters is whether the re-register is guarded. Eight are and are fine. **Seven are not:**

| script | interval |
|---|---|
| **`aaafortplayerquestscript`** | **1 s** — the worst |
| `aaafortobjectcloningquestscript` | 5 s |
| `aaafortobjectcloningresetterscript` | 5 s |
| `aaafortrandomquestscript` | `randomFrequency`, player-set, floor unknown |
| `aaafortidlemarkerscript` | 120 s |
| `aaaforttravelingmerchantscript` | 120 s |
| `aaafortcitizenscript` | 180 s |

The 1 s one checks raid state every second for the entire game. Both its branches require `isRaid`,
so with no raid running it wakes, evaluates two conditions, does nothing, re-arms. Fix: arm on raid
start, stop on raid end. Behaviour identical.

**`aaafortmainquestscript` re-arms at 0.01 s (100 Hz) but is GUARDED** by `stage == 1` — object
placement mode only, where it tracks the object smoothly. Not a background drain. Do not "fix" it
without understanding placement first.

## Second finding: the nine raid functions are copy-paste

`RandomRaid` dispatches to nine ~125-line functions making up ~1,050 of the script's 1,389 lines.
Normalised and diffed against `BanditRaid`: Falmer differs by **7** lines, Giant **8**, Draugr
**9**, Necro/Vampire/Werewolf 18 each, Nature 39.

One parameterised routine plus a raid table replaces ~1,050 lines with ~150. Largest cleanup
available. **The differences are where real behaviour hides — especially `NatureRaid`'s 39 lines.
Preserve them exactly.**

## Third finding: 17 long blocking `Utility.Wait` calls

Including 120 s in `aaafortstationaryguardscript` and `aaafortraiderscript`, and 60 s in the main
controller. Each holds a script thread for its full duration and does not behave predictably across
a save and reload. Most are standing in for a timer.

## Good news for VR: no keyboard dependency

`BindKey`, `RebindDialog` and `iGetKeyPressed` are all **empty stubs** — key binding was stripped
before the SSE release. The menu opens some other way (`aaafortopenplayermenuscript` is the likely
route). A DirectX scan-code hotkey is exactly what fails in VR through OpenComposite, which never
reaches Windows key state — same class of problem as the NMLFF overlay hotkey. **This mod does not
have it.** Delete the stubs rather than carrying them forward.

## Licensing — raised, not resolved

The user's MIT `LICENSE` would otherwise cover `original/`, which holds Aykan's plugin, meshes,
sounds and textures. Permission to revive is not permission to relicense his assets to the world.
A scoping paragraph was added to the README. **Worth getting a sentence from Aykan on what he has
actually agreed to** — whether the original files may live in a public repo, and what happens on a
fork. Flagged to the user; his call, and it should not block the work.

## Environment notes

- No `gh` CLI on this machine. The user created the GitHub repo himself. Worth installing
  (`winget install GitHub.cli`, then **the user** runs `! gh auth login`) given how much GitHub
  work this project implies.
- No Python. BSA parsing and the byte-safe edits were done in PowerShell.
- Git Bash `awk` and `sed -i` **rewrite files to LF** — they mangled an ini during the SPS work.
  For byte-exact edits use PowerShell `[IO.File]::ReadAllText` / `WriteAllText` and verify with a
  byte count and a CRLF count. Same trap as `perl -0pi`, recorded in the Engine Fixes handoff.
- The textures BSA is LZ4-compressed; `Extract-Bsa.ps1` skips those 10 files. Not needed yet.

## RESUME HERE

1. **Before changing a single line: confirm the recovered source rebuilds to matching bytecode.**
   Needs the Papyrus compiler from the Creation Kit plus `Skyrim.esm` headers. Until this passes,
   every optimisation below is unverifiable. This is the real next task.
2. Stop the seven unguarded polls, starting with the 1 s one in `aaafortplayerquestscript`.
3. Convert the long `Utility.Wait` calls to timers.
4. Collapse the nine raid functions, preserving behaviour exactly.
5. Test object placement in the headset — `UpdateInput` / `UpdateObjectPosition` position relative
   to the player and a marker, and the VR camera is the headset. Test before redesigning anything.
6. Audit the 50 `PlaceAtMe` sites against the 54 `Delete()` calls — the counts being close proves
   nothing; what matters is cleanup on every path.
7. Get Aykan's wording on licensing.

---

# 2026-10-29 (later) — the recovered source compiles; build verified

**`RESUME HERE` item 1 from the section above is DONE.** The recovered source rebuilds:

```
Batch compile of 56 files finished. 56 succeeded, 0 failed.
```

Zero errors, zero warnings. Round trip against the shipped bytecode: **54 of 56 within ±2%**,
185,223 bytes original vs 186,162 recompiled (+0.5%). The small growth is header strings (our
machine/user/path are longer than `Danny` / `DANNY-PC`) plus the compiler regenerating the
`GetState`/`GotoState` pair Champollion omits. Verified that **every** script skips only that
standard pair — nothing real was lost. Detail in `docs/04-build-verified.md`.

**The project is viable. Optimisation work can now be verified rather than hoped at.**

## Build setup

Creation Kit is installed at `C:\Steam\steamapps\common\Skyrim Special Edition`. The CK alone is
not enough — the base script sources ship zipped and the compiler cannot resolve `Actor`, `Form`,
`Quest` without them:

```powershell
Expand-Archive "$CK\Data\Scripts.zip" -DestinationPath "$CK\Data"   # already done: 14,301 .psc
```

Build with `tools\Build-Scripts.ps1` (added this session). `-Compare` diffs the output against the
shipped bytecode — **run it before and after every change**.

## Two compiler traps, both cost time today

1. **`-f=` resolves relative to the import paths, not the working directory.** A full path to
   `TESV_Papyrus_Flags.flg` fails with `Unable to find flags file`, then cascades into dozens of
   `Unknown user flag Hidden` errors and `AddItem is not a function or does not exist`. That last
   one looks like broken source and is not. **Pass the bare filename.**
2. **Git Bash mangles the semicolon-separated `-i=` list**, rewriting `/c/Code/...` to
   `C:\c\Code\...`. Run the compiler from PowerShell with Windows paths.

## RESUME HERE (supersedes the list above)

1. **Stop the seven unguarded polls**, starting with the 1 s one in `aaafortplayerquestscript`:
   arm on raid start, stop on raid end. Build with `-Compare` before and after.
2. Convert the 17 long `Utility.Wait` calls to timers.
3. Collapse the nine copy-paste raid functions — preserve `NatureRaid`'s 39 differing lines exactly.
4. Test object placement in the headset before changing anything VR-related.
5. Audit the 50 `PlaceAtMe` sites for cleanup on every path.
6. Get Aykan's wording on licensing (`original/` is his, MIT covers only the revival work).
7. Delete the dead key-binding stubs (`BindKey`, `RebindDialog`, `iGetKeyPressed`).

**Nothing in the mod has been changed yet.** Everything so far is recovery, verification and notes.

---

# Session 2026-10-29, part 2: the placement loop and the SKSE question

Two commits since the notes above:

- `3a1b4b9` — stopped five polling loops that ran for the whole game. See `docs/05-polling-pass.md`.
- `06588fe` — made the build preview loop frame-rate independent and roughly halved its cost per
  tick. See `docs/06-placement-loop.md`.

Both build 56/56 with zero errors. 185,223 → 188,049 bytes, 49/56 within ±2%.

## The one thing to say out loud about SKSE

The user pushed back on an earlier claim that there was nothing to offload. He was right to.
The correction that matters:

**SKSE's Papyrus functions do not move work off the Papyrus VM.** `Input.IsKeyPressed`,
`Form.RegisterForKey`, `UI.*`, mod events — all of it still runs as Papyrus, on the same
per-frame budget. Replacing a vanilla call with an SKSE call never makes a loop cheaper. Only
native C++ in an SKSE plugin genuinely offloads anything.

So "offload to SKSE" is two separate projects, and they should never be discussed as one:
extra capability for Papyrus scripts (cheap, no performance gain) versus a native plugin
(real offload, new hard dependency, real work).

SKSE VR's script sources **are** on this machine at
`C:\Steam\steamapps\common\SkyrimVR\Data\Scripts\Source` — 1,481 `.psc`, and `Form.psc` there
carries `RegisterForKey` / `OnKeyDown` / `OnKeyUp`. So the SKSE route compiles today if wanted.
The CK's own `Data\Source\Scripts` (SSE, 14,301 files) is vanilla only, no SKSE.

## The placement loop, in one paragraph

`StartPositioning` arms `RegisterForSingleUpdate(0.01)` and `OnUpdate` re-arms itself until the
player confirms or cancels. Input comes from two **spells** (`aaafortspellcontrols`, an
ActiveMagicEffect) that set booleans on the quest; the loop is the repeat mechanism for a
hold-to-adjust control, which is why it cannot simply be deleted. Papyrus cannot serve 0.01 —
one tick per frame is the ceiling — and nothing was scaled by elapsed time, so the control
speed *was* the frame rate. Fixed with a `scale` argument from `Utility.GetCurrentRealTime()`
against a `ReferenceRate` property of 60.0, so 60 fps behaves exactly as before and every other
rate now matches it.

## Untested prediction, needs the headset

`UpdateObjectPosition` reads `GetAngleX()` from the player for the vertical placement. In VR the
player's pitch is usually not the head's pitch. **Prediction: looking up and down does not raise
or lower the preview object in VR, so half the placement control is dead.** Five-minute test:
start placing something, look up and down, watch whether it moves vertically.

This test gates the native-plugin decision — Papyrus cannot read the HMD pose, so if the
prediction holds, native code is the only proper fix. Do not add the dependency before testing.

## RESUME HERE (supersedes every list above)

1. ~~Stop the unguarded polls~~ **done, `3a1b4b9`** (5 fixed, 1 was a no-op and removed,
   `aaafortrandomquestscript` left alone deliberately — its poll is the mod working).
2. ~~The placement loop~~ **done, `06588fe`**.
3. **Headset test: does the preview object follow head pitch?** Gates everything VR.
   Also worth trying `UpdateInterval` at 0.01 vs 0.03 vs 0.05 for feel.
4. Convert the 17 long `Utility.Wait` calls to timers — targets listed in
   `docs/02-script-analysis.md`. The 120 s ones in `aaafortstationaryguardscript` and
   `aaafortraiderscript` are the worst.
5. Collapse the nine copy-paste raid functions — preserve `NatureRaid`'s 39 differing lines exactly.
6. Audit the 50 `PlaceAtMe` sites against the 54 `Delete()` for cleanup on every path.
7. Get Aykan's wording on licensing (`original/` is his, MIT covers only the revival work).
8. The dead key-binding stubs (`BindKey`, `RebindDialog`, `iGetKeyPressed`, `keyMenu = 40`):
   **do not delete them yet.** They are the author's abandoned attempt at real key bindings, and
   if SKSE keys get added for flat-screen SSE players they are the place to do it. Decide after
   item 3.

**Nothing has been tested in game.** Everything so far compiles and the reasoning is written
down, which is not the same as working.

---

# Session 2026-10-29, part 3: VR APIs found, cloning scaffolding removed, waits converted

Commits since part 2:

- `f784df6` — documented how placement actually works and the VR APIs available (`docs/07`)
- `b2dfdb1` — `tools/Package-TestBuild.ps1`, so there is finally an installable build
- `73864a5` — removed the object-cloning scaffolding: a perpetual poll and shipped debug spam
- `41e3851` — converted 15 of 17 held `Utility.Wait` calls to timers (`docs/08`)

All build 56/56, zero errors. **A test build was sent to the user and he is testing it now.**
Package: `dist/TundraDefenceRenewedVR-Overlay-41e3851.zip` — reproduce with
`.\tools\Package-TestBuild.ps1 -Mode Overlay`.

## Repo location gotcha

The mod repo is at `C:\Code\TundraDefenceRenewedVR`, but this session's working directory is
`C:\Code\EngineFixes-private`, so it is not visible in the workspace tree. A junction now exists
at `C:\Code\EngineFixes-private\TundraDefenceRenewedVR` (gitignored in the EngineFixes repo). The
user had to restart his workspace to see it; some editors do not follow junctions, in which case
open the real path directly.

## The SKSE answer, settled

The user pushed back twice on this and was right both times. The settled position:

1. **SKSE's Papyrus functions do not move work off the VM.** Still Papyrus, same per-frame
   budget. Never makes a loop cheaper.
2. **Native plugins that delete script work at load time** (SPID, BaseObjectSwapper, SkyPatcher,
   MCMHelper, po3_PapyrusExtender) — checked, and **none apply to this mod**. It distributes
   nothing to actors, swaps no base objects, and its settings are message boxes. Genuinely
   nothing to hand off.
3. **A custom DLL** — only the placement loop, which runs only while actively building.

So there is nothing left to offload. Everything remaining is "do not poll" or "do not hold a
stack", not "do it in C++". Do not re-litigate this without new information.

**The real lever for the user's symptom was held stacks, not timers** — see `docs/08`. His
complaint was ~200k script instances "jockeying for position" across his whole list; this mod is
a rounding error in that, except for the wait-stacks, which spiked at the worst moment.

## VR APIs — all four installed WITH Papyrus interfaces, no DLL needed

Reference copies in `docs/vr-api-reference/` (not compiled into the mod). The originals live in
`C:\Steam\steamapps\common\SkyrimVR\Data\Scripts`.

- **HiggsVR** — `GrabObject`, `GetGrabbedObject`, `CanGrabObject`, `IsTwoHanding`, plus grab,
  drop, pull and two-handing events. `GrabObject` + `OnObjectDropped` would **delete the hot
  placement loop entirely**, since Havok would move the piece natively.
- **PapyrusVR / SkyrimVRTools** — real HMD and controller poses in Skyrim world space, VR button
  events, controller-attached overlap spheres for hand proximity.
- **VRIK** — `VrikAddGestureAction` fires a mod event from a hand gesture, zero polling.
- **PLANCK** — actor ragdoll only, not useful here.

SKSE VR's own script sources are also present (`Form.psc` there has `RegisterForKey`).

## RESUME HERE (supersedes every list above)

1. ~~polling pass~~ **done**, `3a1b4b9` + `73864a5`
2. ~~placement loop~~ **done**, `06588fe`
3. ~~`Utility.Wait` conversion~~ **done**, `41e3851`
4. **WAITING ON THE USER'S TEST RESULTS.** He has `41e3851` installed. The order he was given:
   - does anything work at all (place an object, confirm, run a raid)
   - **does the preview piece follow head pitch?** Prediction: no, because the loop reads the
     player's body pitch which in VR does not follow the head. This one answer decides the whole
     VR plan. See `docs/07`.
   - control speed - now frame-rate independent, tuned to match what 60 fps used to feel like, so
     on a 90 Hz headset it will feel SLOWER than before. That is correct, not a regression.
   - **the dead-actor paths are the risk area in `41e3851`** - corpses should still vanish after
     their delay, and the scavenger crate should still collect from them
5. HIGGS grab probe — agreed for later, explicitly deferred ("yeah we can try higgs later let's
   not jump too far ahead"). Needs compiling against `HiggsVR.psc`, which makes HIGGS a hard
   requirement, so put it on a throwaway branch, never `main`. Test `CanGrabObject` then
   `GrabObject` on one small prop and one house-sized piece - the pieces are `Activator`, `Door`,
   `Furniture` and `Container` base objects and may have no movable rigid body.
6. Collapse the nine copy-paste raid functions — preserve `NatureRaid`'s 39 differing lines exactly.
7. Audit the 50 `PlaceAtMe` sites against the 54 `Delete()` for cleanup on every path.
8. Get Aykan's wording on licensing (`original/` is his, MIT covers only the revival work).
9. Dead key-binding stubs (`BindKey`, `RebindDialog`, `iGetKeyPressed`, `keyMenu = 40`) — **do
   not delete.** They are the author's abandoned attempt at real key bindings and are where SKSE
   keys would go for flat-screen SSE players. Decide after item 4.

## Open findings, noted but not fixed

- `aaafortvioletscript` — 5 s poll forever until `SpecialPlans.GetStage() == 10`. If the player
  never triggers that stage it polls for the entire game. Slowing it is safe and easy.
- `aaafortfarmplotscript` — **latent bug.** The `isActivated` branch of `OnUpdate` does not
  re-arm, so a farm plot produces crops exactly once and then stops. Almost certainly meant to
  repeat. Fixing it would ADD polling, so it needs the user's call.
- `aaafortcampfirescript` and `aaafortmultiplaceonspawnscript` — per-object 5 s polls that stop
  once `status == "placed"`. If the last placement was cancelled instead, they keep polling until
  the next successful one. Minor.

**Nothing has been tested in game yet.** Everything compiles and the reasoning is written down,
which is not the same as working.
