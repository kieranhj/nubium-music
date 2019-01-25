@echo off
rem| POP-BEEB audio compile script
rem| @simondotm

echo Processing >vgm_process.txt

rem|-------------------------------------------------------------------------
rem| all audio for POP is VGM SN76489 format transposed from NTSC to 4Mhz
rem| then converted to raw format 50Hz
rem| music is EXO compressed using a 256 byte dictionary
rem| sfx is just raw chip data
rem| After compilation we delete any intermediate files
rem|  and only keep the EXO or RAW file data.
rem|
rem| folders:
rem|  ip - original POP-BEEB music by @inversephase
rem|  music - Sega Master system music by Matt Furniss
rem|  sfx - original POP-BEEB sound effects by @inversephase
rem|
rem| the script will compile any VGM source files it finds in the "vgm" subfolders.
rem| the script uses a copied version of the "vgmconverter" python script from
rem|  https://github.com/simondotm/vgm-converter
rem|-------------------------------------------------------------------------

rem|---- compile the music ----

for %%x in (vgm\*.vgm) do vgmconverter.py "%%x" -n -t bbc -q 50 -r "%%~nx.raw" >>vgm_process.txt
for %%x in (*.raw) do exomizer.exe raw -c -m 256 "%%x" -o "exo\%%~nx.raw.exo" >>vgm_process.txt
del *.raw

rem pause