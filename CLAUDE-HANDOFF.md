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
