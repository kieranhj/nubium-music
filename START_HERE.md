# nubium-music: start here

A sideways-RAM VGM music player for Planet Nubium (a BBC Micro game by someone else), plus the converted tunes. 6502, beebasm. 2018-2019.

| | |
|---|---|
| GitHub | https://github.com/kieranhj/nubium-music (public) |
| Local path | D:\beeb\mine\nubium-music (moved from OneDrive\BEEB\Repos\nubium-music on 2026-11-22) |
| Branch | master (only branch) |
| Last commit | 2019-02-26: Stop player using NMI ZP workspace |

## What's in here
- `nubium-music.asm`: builds the player and adds it to a copy of the game disc.
- `vgmplayer.asm`, `exomiser.asm` (+ `.h.asm`): the VGM player and Exomizer decompressor.
- `music/`: the converted tunes.
- `Nubium 2018xxxx/2019xxxx a.ssd`: game discs received from the game's author (the build uses `Nubium 20190215 a.ssd` as the template).
- `notes.txt`: an email from the game's author about integrating the tunes (the looping bug).

## Build and run
- `make`: runs `make.bat`, which assembles `nubium-music.asm` with `..\..\Bin\beebasm.exe`, adding to `Nubium 20190215 a.ssd` -> `nubium-music.ssd` (tracked). `make help` lists targets.
- Tools: beebasm in D:\beeb\Bin.
- `run.bat` opens the disc in `..\..\bin\b-em\b-em.exe`.

## Local changes
- None (clean working tree, no snapshot branches).

## Status and next steps
- Last work: different looping behaviour (2019-02-13) and moving player ZP out of NMI workspace (2019-02-26). Presumably handed over to the game's author; no TODO found.

## See also
- `notes.txt`.
