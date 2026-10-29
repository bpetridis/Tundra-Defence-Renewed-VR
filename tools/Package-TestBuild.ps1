<#
.SYNOPSIS
  Packages a Vortex-installable test build from the recompiled scripts.

.DESCRIPTION
  Two modes.

  Overlay (default) ships only the recompiled Scripts folder. Install it in Vortex AFTER the
  original Tundra Defence and let it win the conflict - loose scripts override the copies inside
  Tundra Defense SSE.bsa. This is the right thing for testing: it is small, it changes only what
  we changed, and it redistributes none of Aykan's assets.

  Full ships the original ESP and both BSAs alongside the scripts, as a self-contained mod. Use
  this only when there is no existing install to overlay.

  Always compiles first, so a package can never be stale.

.EXAMPLE
  .\tools\Package-TestBuild.ps1
  .\tools\Package-TestBuild.ps1 -Mode Full -Tag rc2
#>
param(
  [string]$CkPath = 'C:\Steam\steamapps\common\Skyrim Special Edition',
  [ValidateSet('Overlay','Full')]
  [string]$Mode = 'Overlay',
  [string]$Tag,
  [string]$OutDir = "$PSScriptRoot\..\dist",
  [switch]$SkipBuild
)

$ErrorActionPreference = 'Stop'
$repo = (Resolve-Path "$PSScriptRoot\..").Path

if (-not $SkipBuild) {
  "=== compiling ==="
  & "$PSScriptRoot\Build-Scripts.ps1" -CkPath $CkPath
  if ($LASTEXITCODE -ne 0) { throw 'Build failed - not packaging.' }
}

$pex = Get-ChildItem "$repo\build\scripts" -Filter *.pex -ErrorAction SilentlyContinue
if ($pex.Count -eq 0) { throw "No compiled scripts in $repo\build\scripts - run without -SkipBuild." }

# Name the package after the commit it was built from, so a build on the test machine can always
# be traced back to source. A dirty tree is marked, because then it cannot be.
$sha   = (& git -C $repo rev-parse --short HEAD).Trim()
$dirty = if ((& git -C $repo status --porcelain)) { '-dirty' } else { '' }
if (-not $Tag) { $Tag = "$sha$dirty" }

$name    = "TundraDefenceRenewedVR-$Mode-$Tag"
$staging = Join-Path ([IO.Path]::GetTempPath()) "tdrvr-pkg-$([guid]::NewGuid().ToString('N').Substring(0,8))"
New-Item -ItemType Directory -Force $staging | Out-Null
New-Item -ItemType Directory -Force "$staging\Scripts" | Out-Null
New-Item -ItemType Directory -Force $OutDir | Out-Null

# HiggsVR.pex and friends must never ship: our copies are decompiled stubs with empty bodies and
# would override the real plugin's scripts.
$forbidden = @('HiggsVR','PapyrusVR','planck','VRIK')
$skipped = @()
foreach ($f in $pex) {
  if ($forbidden -contains [IO.Path]::GetFileNameWithoutExtension($f.Name)) {
    $skipped += $f.Name
    continue
  }
  Copy-Item $f.FullName "$staging\Scripts\"
}
if ($skipped.Count) { "  excluded (plugin interface stubs): $($skipped -join ', ')" }

if ($Mode -eq 'Full') {
  foreach ($a in @('Tundra Defense SSE.esp','Tundra Defense SSE.bsa','Tundra Defense SSE - Textures.bsa')) {
    $p = Join-Path "$repo\original" $a
    if (-not (Test-Path $p)) { throw "Missing $p" }
    Copy-Item $p $staging
  }
}

$readme = @"
Tundra Defence Renewed VR - test build
======================================

Built from commit : $sha$dirty
Mode              : $Mode
Scripts           : $(($pex.Count - $skipped.Count)) recompiled .pex
Packaged          : $(Get-Date -Format 'yyyy-MM-dd HH:mm')

THIS IS A TEST BUILD. It has never been run in game. Branch your save first.

Install
-------
$(if ($Mode -eq 'Overlay') {
"Install in Vortex AFTER the original Tundra Defence and let this win the file conflict.
It contains only the recompiled scripts, which override the copies inside the mod's BSA.
The original ESP and BSAs are untouched and still required."
} else {
"Self-contained. Install as a normal mod. Do not install alongside the original Tundra
Defence - this replaces it."
})

What changed
------------
Five polling loops that ran for the whole game were stopped or gated (commit 3a1b4b9),
and the build preview loop was made frame-rate independent and roughly halved in cost
per tick (commit 06588fe). No behaviour was intentionally changed.

Full detail in docs/05-polling-pass.md and docs/06-placement-loop.md.

What to test, in order
----------------------
1. DOES ANYTHING WORK AT ALL. Load a save at the fort, place one object, confirm it.
   Raid should still start and end. If this fails, nothing else matters.

2. THE PITCH QUESTION. Start placing a piece and look up and down.
   Does the piece rise and fall with your head?
   The loop reads the PLAYER's pitch, which in VR usually does not follow the headset.
   The prediction is that it does NOT move vertically. Either answer is useful and it
   decides the whole VR plan - see docs/07-vr-placement-options.md.

3. CONTROL SPEED. Push and pull a piece and rotate it. It should now move at the same
   speed regardless of frame rate, tuned to match what 60 fps used to feel like. If it
   now feels too slow, that is expected on a 90 Hz headset - it used to run half again
   too fast. DistanceSpeed and RotationSpeed are adjustable in the mod's own settings
   menu in game.

4. The travelling merchant now packs up on a game-time timer rather than a real-time
   poll. Only shows up over a couple of in-game days.

Things known NOT to be fixed
----------------------------
Nothing about the placement interaction itself has changed - it is still five control
spells aiming a piece along your body facing. That is the subject of the VR work and
needs test 2 answered first.
"@
$readme | Out-File -FilePath "$staging\README-TESTBUILD.txt" -Encoding utf8

$zip = Join-Path $OutDir "$name.zip"
if (Test-Path $zip) { Remove-Item $zip }
Compress-Archive -Path "$staging\*" -DestinationPath $zip
Remove-Item $staging -Recurse -Force

$size = [math]::Round((Get-Item $zip).Length / 1KB, 1)
""
"=== packaged ==="
"  $zip"
"  $size KB, $(($pex.Count - $skipped.Count)) scripts, mode $Mode, from $sha$dirty"
if ($dirty) { "  WARNING: built from a dirty tree - this package cannot be traced to a commit." }
