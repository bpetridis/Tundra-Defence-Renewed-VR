param([string]$Bsa, [string]$Out)
$fs = [IO.File]::OpenRead($Bsa); $br = New-Object IO.BinaryReader($fs)
$null=$br.ReadBytes(8); $null=$br.ReadUInt32(); $aflags=$br.ReadUInt32()
$nFold=$br.ReadUInt32(); $nFile=$br.ReadUInt32()
$null=$br.ReadUInt32(); $null=$br.ReadUInt32(); $null=$br.ReadUInt32()
$folds=@()
for ($i=0;$i -lt $nFold;$i++){ $null=$br.ReadUInt64(); $c=$br.ReadUInt32(); $null=$br.ReadUInt32(); $null=$br.ReadUInt64(); $folds+=$c }
$all=@()
foreach ($c in $folds){
  $len=$br.ReadByte(); $name=[Text.Encoding]::ASCII.GetString($br.ReadBytes($len)).TrimEnd([char]0)
  for ($j=0;$j -lt $c;$j++){ $null=$br.ReadUInt64(); $sz=$br.ReadUInt32(); $of=$br.ReadUInt32()
    $all+=[pscustomobject]@{folder=$name;size=$sz;offset=$of;name=''} }
}
for ($i=0;$i -lt $all.Count;$i++){ $sb=New-Object Text.StringBuilder; while(($b=$br.ReadByte()) -ne 0){$null=$sb.Append([char]$b)}; $all[$i].name=$sb.ToString() }
$comp=0
foreach ($f in $all){
  $raw = $f.size
  $isComp = [bool]($raw -band 0x40000000)
  if ($aflags -band 0x4) { $isComp = -not $isComp }
  if ($isComp) { $comp++ ; continue }
  $sz = $raw -band 0x3FFFFFFF
  $dir = Join-Path $Out $f.folder
  New-Item -ItemType Directory -Force $dir | Out-Null
  $fs.Position = $f.offset
  $bytes = $br.ReadBytes($sz)
  [IO.File]::WriteAllBytes((Join-Path $dir $f.name), $bytes)
}
$fs.Close()
"extracted $($all.Count - $comp) of $($all.Count)  (skipped compressed: $comp)"
