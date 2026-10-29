# VR plugin Papyrus APIs — reference copies

These are **not part of the mod** and are not compiled into it. They are here so the available
VR interfaces can be read without having the plugins installed, and so a future session does not
have to rediscover that these APIs exist.

| file | plugin | source |
|---|---|---|
| `HiggsVR.psc` | HIGGS (`higgs_vr.dll`) | decompiled from the shipped `HiggsVR.pex` |
| `PapyrusVR.psc` | SkyrimVRTools (`skyrimvrtools.dll`) | decompiled from the shipped `PapyrusVR.pex` |
| `planck.psc` | PLANCK (`activeragdoll.dll`) | decompiled from the shipped `planck.pex` |
| `VRIK.psc` | VRIK (`VRIK.dll`) | shipped as source by VRIK |

The three decompiled ones were recovered with Champollion from
`C:\Steam\steamapps\common\SkyrimVR\Data\Scripts`, which is where these plugins install their
`.pex`. Only VRIK ships its `.psc`.

Decompiled headers are an approximation of the original source. Trust the function signatures;
do not trust the bodies of the non-native functions beyond "roughly this".

To compile against any of these, add the plugin's script folder to the `-i=` import list in
`tools\Build-Scripts.ps1`. Doing so makes that plugin a **hard requirement** of the mod, so
anything built on these belongs behind a presence check. See `../07-vr-placement-options.md`.

Rights to these interfaces belong to their respective authors (FlyingParticle for HIGGS and
PLANCK, Shizof for SkyrimVRTools, prog for VRIK). They are reproduced here for reference only.
