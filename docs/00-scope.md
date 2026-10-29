# Scope

Agreed 2026-10-29.

## What this is

Revive **Tundra Defense** by Aykan, with his permission, as **Tundra Defence Renewed VR**.
Fix it and optimise it. Keep the behaviour the player already knows.

## In scope

- Decompile all 56 scripts and get them building again from source
- Fix 2017-era Papyrus mistakes and anything that has since become known-bad practice
- Optimise the heavy scripts, starting with `aaafortplayerquestscript` (46 KB compiled)
- Fix whatever is specifically wrong in VR
- Drop-in install, though players should branch a save before adding it

## Out of scope

No new features. No new buildings, quests or systems. If something is tempting, it goes in a
"later" note rather than into the work.

## Target

**VR-first, SSE compatible.** Skyrim VR 1.4.15 is the platform that gets verified, because that is
what is actually being played here. Avoid anything that needlessly breaks flatscreen SSE, but do
not claim SSE support that has not been tested — say plainly what was and was not checked.

## Ground rules carried over from the Engine Fixes work

- Verify what is actually deployed before drawing conclusions from a test run
- One variable per test
- Measure rather than argue; add counters before forming theories
- Record findings as they happen, including retractions
