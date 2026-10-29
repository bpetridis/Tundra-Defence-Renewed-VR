<#
.SYNOPSIS
  Compiles the recovered Papyrus source, and optionally compares the result against the
  bytecode that originally shipped.

.DESCRIPTION
  Needs the Skyrim Special Edition Creation Kit. The base script sources must be unpacked:
  if Data\Source\Scripts is missing, extract Data\Scripts.zip into Data first.

.EXAMPLE
  .\tools\Build-Scripts.ps1
  .\tools\Build-Scripts.ps1 -Compare
#>
param(
  [string]$CkPath = 'C:\Steam\steamapps\common\Skyrim Special Edition',
  [string]$OutDir = "$PSScriptRoot\..\build\scripts",
  [switch]$Compare
)

$ErrorActionPreference = 'Stop'
$repo    = Resolve-Path "$PSScriptRoot\.."
$srcDir  = Join-Path $repo 'Source\Scripts'
$origDir = Join-Path $repo 'extracted\scripts'
$compiler = Join-Path $CkPath 'Papyrus Compiler\PapyrusCompiler.exe'
$baseSrc  = Join-Path $CkPath 'Data\Source\Scripts'

if (-not (Test-Path $compiler)) { throw "Papyrus compiler not found at $compiler" }
if (-not (Test-Path $baseSrc))  { throw "Base script sources not found at $baseSrc - extract $CkPath\Data\Scripts.zip into $CkPath\Data" }

New-Item -ItemType Directory -Force $OutDir | Out-Null

# -f is resolved relative to the import paths, so pass the bare filename, not a full path.
$out = & $compiler $srcDir "-f=TESV_Papyrus_Flags.flg" "-i=$srcDir;$baseSrc" "-o=$OutDir" -all 2>&1
$out | Select-String -Pattern '\(\d+,\d+\):|Batch compile'

if ($LASTEXITCODE -ne 0) { throw "Compilation failed." }

if ($Compare) {
  "`n=== recompiled vs originally shipped ==="
  $rows = Get-ChildItem $OutDir -Filter *.pex | ForEach-Object {
    $o = Join-Path $origDir ($_.Name.ToLower())
    if (Test-Path $o) {
      $ol = (Get-Item $o).Length
      [pscustomobject]@{ Name=$_.Name; Orig=$ol; New=$_.Length; Delta=$_.Length-$ol
                         Pct=[math]::Round(100*($_.Length-$ol)/$ol,1) }
    }
  }
  "compared     : {0}" -f $rows.Count
  "within +/-2% : {0}" -f ($rows | Where-Object { [math]::Abs($_.Pct) -le 2 }).Count
  "total orig   : {0} bytes" -f ($rows | Measure-Object Orig -Sum).Sum
  "total new    : {0} bytes" -f ($rows | Measure-Object New  -Sum).Sum
  "`nlargest differences:"
  $rows | Sort-Object { [math]::Abs($_.Pct) } -Descending | Select-Object -First 8 | Format-Table -AutoSize
  "A few bytes either way is expected: the header carries the build machine, user and source"
  "path, and the compiler regenerates the GetState/GotoState pair Champollion omits."
}
