# Champollion

Papyrus `.pex` decompiler by Orvid, used to recover this mod's lost source.

- version: **v1.3.2**
- from: https://github.com/Orvid/Champollion/releases/tag/v1.3.2
- archive: `Champollion.v1.3.2.zip`, 583,399 bytes
- sha256: `ea53054276ac8006ccd3b323286bfbc6e34a454fa419d08da9bd440cbd31b383`

The executable itself is not version-controlled. Download it from the link above if it is missing.

## Regenerating the source

```powershell
.\tools\champollion\Champollion.exe -r -t -e -p .\Source\Scripts .\extracted\scripts
```

`-r` recursive, `-t` threaded, `-e` write the header block, `-p` output directory.
