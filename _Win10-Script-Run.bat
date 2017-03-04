@ECHO OFF
Echo "Running Win10 Initial Setup Script -Menu version"
::Add colons before the pause if you dont want a pause (or delete it)
Pause 

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
::PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File %~dp0Win10-Menu.ps1' -Verb RunAs}"

::Run script with Settings that are in the Script
::PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File %~dp0Win10-Menu.ps1' -Set Run -Verb RunAs}"

::Run script with Windows Default Settings
::PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File %~dp0Win10-Menu.ps1 -Set WD' -Verb RunAs}"

::Run script with Import of setting file Mine.txt
::PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File %~dp0Win10-Menu.ps1 -Set %~dp0Mine.txt' -Verb RunAs}"
::Note: If your setting file is a different name make sure to change it from "Mine.txt" to your filename
