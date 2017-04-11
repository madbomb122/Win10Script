@ECHO OFF

:: Instructions
:: Bat, Script & Setting File (if used) MUST be in same Folder
:: Change RunOption to = what you want to run (just the number)

Set Run_Option=0
:: Anything other than following does nothing
:: 0 = Run with Menu
:: 1 = Run with Settings in Script File
:: 2 = Run with Windows Default (Default Settings in script is to Skip, you have to change them)
:: 3 = Run with Setting file (Change file name bellow)
:: 4 = Exit (Dont Run script)

:: Change Mine.xml to your setting file (if you have one)
Set Setting_File=Mine.xml
Set Script_File=Win10-Menu.ps1

:: Do not change unless you know what you are doing
Set Script_Directory=%~dp0
Set Script_Path=%Script_Directory%%Script_File%

:: DO NOT CHANGE ANYTHING PAST THIS LINE
::----------------------------------------------------------------------
Set Use_Arg=yes

If /i %Run_Option%==0 Set Use_Arg=no
If /i %Run_Option%==1 Set Arg=Run
If /i %Run_Option%==2 Set Arg=WinDefault
If /i %Run_Option%==3 Set Arg=%Setting_File%
If /i %Run_Option%==4 Exit

SETLOCAL ENABLEDELAYEDEXPANSION
If /i %Use_Arg%==no (
    echo "Running !Script_File!, with Menu option"
    powershell.exe -noprofile -ExecutionPolicy Bypass -command "&{start-process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -file \"!Script_Path!\"' -verb RunAs}"
)
ENDLOCAL DISABLEDELAYEDEXPANSION

SETLOCAL ENABLEDELAYEDEXPANSION
If /i %Use_Arg%==yes (
    echo "Running !Script_File! -Set !Arg!"
    PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File \"!Script_Path!\" -Set \"!Arg!\"' -Verb RunAs}";
)
ENDLOCAL DISABLEDELAYEDEXPANSION
