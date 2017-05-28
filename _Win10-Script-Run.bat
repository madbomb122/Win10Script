@ECHO OFF
:: Instructions
:: Bat, Script, and setting MUST be in same Folder
:: Change Option to = one of the listed options (mostly yes or no)

Set Run_Option=0
:: Anything other than following does nothing
:: 0 = Go to Script Menu
:: 1 = Run Script with Settings in Script File
:: 2 = Run Script with Windows Default
:: 3 = Run Script with Your Setting file (Change file name bellow)
:: 4 = Load Script with Windows Default (Does not run)
:: 5 = Load Script with Your Setting file (Does not run)

:: Name of Script File
Set Script_File=Win10-Menu.ps1

:: Name of Setting File (Change Mine.xml to your setting file, if you have one)
Set Setting_File=Mine.xml
:: DO NOT HAVE SPACES IN FILENAME

:: Change these to yes or no
Set Accept_ToS=no
:: no = See ToS
:: yes = Skip ToS (You accepted it)

Set Create_Restore_Point=no
Set Restore_Point_Name=Win10_Initial_Setup_Script
:: DO NOT HAVE SPACES IN NAME

Set Restart_when_Done=yes

:: Update Checks   
:: If update is found it will Auto-download and use that (with your settings)       
Set Script=no
Set Internet_Check=yes 
:: Internet_Check only matters If Script is yes and pings to github.com is blocked 

:: Diagnostic Output (Wont run script)
Set Diagnostic=no

::----------------------------------------------------------------------
:: Do not change unless you know what you are doing
Set Script_Directory=%~dp0
Set Script_Path=%Script_Directory%%Script_File%

:: DO NOT CHANGE ANYTHING PAST THIS LINE
::----------------------------------------------------------------------
SETLOCAL ENABLEDELAYEDEXPANSION

If /i %Run_Option%==1 Set Run_Option=!Run_Option! -run
If /i %Run_Option%==2 Set Run_Option=!Run_Option! -run wd
If /i %Run_Option%==3 Set Run_Option=!Run_Option! -run %Setting_File%
If /i %Run_Option%==4 Set Run_Option=!Run_Option! -load wd
If /i %Run_Option%==5 Set Run_Option=!Run_Option! -load %Setting_File%

If /i %Accept_ToS%==yes Set Run_Option=!Run_Option! -atos

If /i %Create_Restore_Point%==yes Set Run_Option=!Run_Option! -crp %Restore_Point_Name%

If /i %Internet_Check%==no Set Run_Option=!Run_Option! -sic

If /i %Script%==yes Set Run_Option=!Run_Option! -usc

If /i %Service%==yes Set Run_Option=!Run_Option! -use

If /i %Restart_when_Done%==no Set Run_Option=!Run_Option! -dnr

echo "Running !Script_File!"
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "!Script_Path! !Run_Option!"' -Verb RunAs}";
ENDLOCAL DISABLEDELAYEDEXPANSION
