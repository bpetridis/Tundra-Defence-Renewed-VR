# The recovered source compiles — project is viable

Date: 2026-10-29.

This was the question everything else depended on. If the decompiled source would not rebuild,
every optimisation would be a change we could not verify. It rebuilds.

## Result

```
Batch compile of 56 files finished. 56 succeeded, 0 failed.
```

**All 56 scripts, zero errors, zero warnings.**

## Round-trip fidelity

Recompiled bytecode compared against what originally shipped:

| measure | value |
|---|---|
| scripts compared | 56 |
| within ±2% of original size | **54** |
| total original | 185,223 bytes |
| total recompiled | 186,162 bytes (**+0.5%**) |

Largest differences:

| script | original | recompiled | delta |
|---|---|---|---|
| `aaafortlookoutscript` | 1,138 | 1,096 | −42 (−3.7%) |
| `aaafortguardarmoryscript` | 2,989 | 3,069 | +80 (+2.7%) |
| `aaafortwaterwellscript` | 6,578 | 6,658 | +80 (+1.2%) |
| `aaafortbarracksscript` | 7,597 | 7,685 | +88 (+1.2%) |
| `aaafortplayerquestscript` | 46,233 | 46,764 | +531 (+1.1%) |

A few bytes either way is expected and does not indicate anything lost:

- the `.pex` header stores the build machine, user and source path as strings, and ours are longer
  than `Danny` / `DANNY-PC`
- Champollion omits the compiler-generated `GetState`/`GotoState` pair, which the compiler then
  regenerates in its own way

Checked explicitly: **every one of the 56 scripts skips only that standard pair**, nothing more. No
script lost a real function in the round trip.

## Setting it up

The Creation Kit alone is not enough — Bethesda ships the base script sources zipped, and the
compiler cannot resolve `Actor`, `Form`, `Quest` and friends without them.

```powershell
Expand-Archive "$CK\Data\Scripts.zip" -DestinationPath "$CK\Data"
```

That produced 14,301 `.psc` files under `Data\Source\Scripts`.

## Two traps worth remembering

**The flags file path.** `-f=` is resolved relative to the import paths, not the working directory.
Passing a full path to `TESV_Papyrus_Flags.flg` fails with `Unable to find flags file`, and then
cascades into a flood of misleading `Unknown user flag Hidden` errors followed by
`AddItem is not a function or does not exist` — which looks like broken source and is not. Pass the
bare filename.

**Git Bash mangles the import list.** `-i=` takes semicolon-separated paths, and Git Bash rewrote
`/c/Code/...` into `C:\c\Code\...`. Run the compiler from PowerShell with Windows paths.

## Building from now on

```powershell
.\tools\Build-Scripts.ps1            # compile
.\tools\Build-Scripts.ps1 -Compare   # compile and diff against the shipped bytecode
```

Run the `-Compare` form before and after any change. A change meant to be behaviour-preserving that
moves a script's size significantly is worth a second look.
