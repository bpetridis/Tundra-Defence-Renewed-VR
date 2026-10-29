# Tundra Defence Renewed VR

Bring Tundra Defence SSE up to date and optimise it for Skyrim VR primarily — SSE supported also.

A revival of **Tundra Defense** by Aykan ([Nexus 14310](https://www.nexusmods.com/skyrimspecialedition/mods/14310)),
last updated 31 December 2017.

Revived with the original author's permission. The author no longer has the source code, so this
project starts from the shipped 1.04 release and works backwards. The Papyrus source in
`Source/Scripts/` was recovered by decompiling the shipped `.pex` files.

## Status

Early. Nothing has been changed yet — the repository holds the original release, the recovered
source, and the survey notes.

## What this project is trying to do

- Bring a 14-year-old codebase up to date with fixes and practices that have appeared since
- Tidy and optimise the Papyrus scripts
- Fix what is specifically wrong in VR
- Drop-in install, though players should branch a save before adding it

No new features. See [`docs/00-scope.md`](docs/00-scope.md).

## Layout

| path | what it holds |
|---|---|
| `original/` | the shipped 1.04 files, untouched — the only authoritative copy of the mod |
| `original/SOURCE-ARCHIVE.md5` | md5 and sha256 of the Nexus archive these came from |
| `Source/Scripts/` | the recovered Papyrus source, decompiled from the shipped scripts |
| `extracted/scripts/` | the 56 compiled `.pex` files the source was recovered from |
| `tools/Extract-Bsa.ps1` | unpacks an uncompressed SSE BSA; regenerates everything under `extracted/` |
| `tools/champollion/` | how to obtain the decompiler and regenerate the source |
| `docs/` | scope, survey and findings |

Meshes and sounds are deliberately not version-controlled — they are unchanged and can be
regenerated from `original/` with the extractor.

## Rebuilding from the originals

```powershell
.\tools\Extract-Bsa.ps1 -Bsa ".\original\Tundra Defense SSE.bsa" -Out ".\extracted"
.\tools\champollion\Champollion.exe -r -t -e -p .\Source\Scripts .\extracted\scripts
```

The textures BSA is LZ4-compressed and needs a different tool; those 10 files are untouched anyway.

## Credits and licensing

Original mod by **Aykan**. Revived by Bill P with permission.

The MIT licence in this repository covers the revival work. It does **not** cover the original
mod's assets in `original/` — the plugin, meshes, sounds and textures remain Aykan's, used here
with his permission. See [`docs/00-scope.md`](docs/00-scope.md).
