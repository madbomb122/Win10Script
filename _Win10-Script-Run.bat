@ECHO OFF

:: Instructions
:: Bat, Script & Setting File (if used) MUST be in same Folder
:: Change RunOption to = what you want to run (just the number)

set Run_Option=0
:: Anything other than following does nothing
:: 0 = Run with Menu
:: 1 = Run with Settings in Script File
:: 2 = Run with Windows Default (Default Settings in script is to Skip, you have to change them)
:: 3 = Run with Setting file (Change file name bellow)
:: 4 = Exit (Dont Run script)

:: Change Mine.xml to your setting file (if you have one)
set Setting_File=Mine.xml
set Script_File=Win10-Menu.ps1

:: Do not change unless you know what you are doing
set Script_Directory=%~dp0
set Script_Path=%Script_Directory%%Script_File%


:: DO NOT CHANGE ANYTHING PAST THIS LINE
::----------------------------------------------------------------------
set Use_Arg=yes

if /i %Run_Option%==0 set Use_Arg=no
if /i %Run_Option%==1 set Arg=Run
if /i %Run_Option%==2 set Arg=WD
if /i %Run_Option%==3 set Arg=%Setting_File%
if /i %Run_Option%==4 Exit

SETLOCAL ENABLEDELAYEDEXPANSION
if /i %Use_Arg%==no (
    powershell.exe -noprofile -ExecutionPolicy Bypass -command "&{start-process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -file \"!Script_Path!\"' -verb RunAs}"
)
ENDLOCAL DISABLEDELAYEDEXPANSION

SETLOCAL ENABLEDELAYEDEXPANSION
if /i %Use_Arg%==yes (
    PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File \"!Script_Path!\" -Set \"!Arg!\"' -Verb RunAs}";
)
ENDLOCAL DISABLEDELAYEDEXPANSION
