@ECHO OFF
Echo "Running Win10 Initial Setup Script -Menu version"

::Do not change unless you know what you are doing
set Directory=%~dp0
set ScriptFile=Win10-Menu.ps1

::Change Mine.txt to your settingfile, 
::Only matters if you are going to run script with setting
set SettingFile=Mine.txt

::----------------------------------------------------------------------

:: Instructions
:: Remove the 2 Colons infront of "The Command" you want to run
:: Bat file MUST be in same directory as script
:: Setting file MUST be in same directory as script

:: Format of File
:: Description of "The Command"
:: "The Command"
:: Note (If any)

::----------------------------------------------------------------------

::Run script with going into the Menu
::PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File Directory%\%ScriptFile%' -Verb RunAs}"

::Run script with Settings that are in the Script
::PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File Directory%\%ScriptFile% -Set Run -Verb RunAs}"
::Note: Default Settings in script is to Skip, you have to change them

::Run script with Windows Default Settings
::PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File %Directory%\%ScriptFile% -Set WD' -Verb RunAs}"

::Run script with Import of setting file
::PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File %Directory%\%ScriptFile% -Set %SettingFile%' -Verb RunAs}"
