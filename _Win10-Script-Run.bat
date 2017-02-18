@ECHO OFF
Echo "Running Win10 Initial Setup Script -Mod version"

::Add colons before the pause if you dont want a pause (or delete it)
Pause 

:: Remove the 2 Colons infrom of the command you want to run

::Run script with Import of setting file Mine.txt (Bat file in same directory as Win10-Menu.ps1 & Mine.txt)
::PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File %~dp0Win10-Menu.ps1 -Set %~dp0Mine.txt' -Verb RunAs}"

::Run script with Windows Default Settings  (Bat file in same directory as Win10-Menu.ps1)
::PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File %~dp0Win10-Menu.ps1 -Set WD' -Verb RunAs}"

::Run script with Settings in Script  (Bat file in same directory as Win10-Menu.ps1)
::PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File %~dp0Win10-Menu.ps1' -Set Run -Verb RunAs}"

::Run script with going into the menu, For you to do settings (Bat file in same directory as Win10-Menu.ps1)
::PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File %~dp0Win10-Menu.ps1' -Verb RunAs}"
