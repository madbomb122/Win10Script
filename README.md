**Current Version** <br />
**Script:** `3.0` (August 16, 2017) <br />

## Description

This is a PowerShell script for automation of routine tasks/setting on Windows 10. <br /> 
This is by no means a complete set of settings. (There is ALOT that can be changed/done)

The original basic script created by https://github.com/Disassembler0/Win10-Initial-Setup-Script/

This script is a Highly Modded version of the 2.0 script by Disaseembler0. <br />
The script has added items with an easier way to change preferences and a menu.

PS. Don't forget to check out my other Repo https://github.com/madbomb122/BlackViperScript  <br />

# Usage Requirements
**OS:** `Windows 10` <br />
**Needed Files:** `Win10-Menu.ps1` (Script File) <br />
**Recommended Files:** `_Win10-Script-Run.bat` <br />

# How to Use/Run
Download/Save the following files <br />
Script File: `Win10-Menu.ps1` -Need <br />
Bat File: `_Win10-Script-Run.bat` -Recommended <br />
  **Note 1: DO NOT RENAME THE FILES**<br />
  **Note 2: HAVE THE FILES IN THE SAME DIRECTORY**<br />
Next follow the **Basic Usage** or **Advanced Usage**

# Basic Usage
Run the Script by bat file `_Win10-Script-Run.bat` (Recommended) <br />
or <br />
`powershell.exe -NoProfile -ExecutionPolicy Bypass -File Win10-Menu.ps1` <br />
Use the Menu <br />
Set what you want <br />
Select option to run script <br />

# Advanced_Usage
Use one of the following Methods you can 
1. Run script or bat file with one (or more) of the switches bellow
2. Edit the script (bottom of file) to change the values
3. Edit the bat file (top of file) to change the values to add the switch

|   Switch  | Description                                                                    | Notes                            |
| :-------- | :------------------------------------------------------------------------------| :------------------------------- |
| -atos     | Accepts the ToS                                                                |                                  |
| -auto     | Runs the script to be Automated.. Closes on Errors, End of Script)             | Implies `-atos`                    |
| -run      | Runs script with setting in script                                             |                     |
| -run Settingfile     | Runs script with Settingfile                                            |                     |
| -run WinDefault     | Runs script with Win Default                                            |                     |
| -load Settingfile     | Loads Settingfile (Does not run)                                            |                     |
| -load WinDefault     | Loads Win Default (Does not run)                                            |                     |
| -sic      | Skips Internet Check (If checking for update)                                  | Tests by pinging github.com      |
| -usc      | Checks for Update to Script file before running                                | Auto downloads and runs if found |
| -crp     | Creates a Restore Point                            |  |
| -dnr      | Do not restart when done                    |   |

Examples: <br />
`powershell.exe -NoProfile -ExecutionPolicy Bypass -File Win10-Menu.ps1 -auto -run mine.csv` <br />
`powershell.exe -NoProfile -ExecutionPolicy Bypass -File Win10-Menu.ps1 -atos -load WinDefault` <br />

******
## FAQ
**Q:** Do you accept any donations? <br />
**A:** If you would like to donate to me Please Contact me about donating or pick an item from my amazon wishlist. <br />
**Wishlist:** https://www.amazon.com/gp/registry/wishlist/YBAYWBJES5DE/

**Q:** How can I contact you? <br />
**A:** You can email me @ madbomb122@gmail.com

**Q:** The script file looks all messy in notepad, How do i view/change it? <br />
**A:** Try using wordpad or what I recommend, Notepad++ https://notepad-plus-plus.org/

**Q:** The script window closes or gives an error saying script is blocked, what do i do? <br />
**A:** By default windows blocks ps1 scripts, you can use one of the following <br />
         1. Use the bat file to run the script (recommended) <br />
         2. On an admin powershell console `Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted` <br />

**Q:** Can I run the script safely? <br />
**A:** The script itself is safe, however some setting it can change may compromise your computer.

**Q:** Can I run the script repeatedly? <br />
**A:** Yes, with same or different settings.

**Q:** Did you test the script? <br />
**A:** Yes, but doesnt mean there isnt any bugs/errors.

**Q:**: I've run the script and it did *BLAH*, can I undo it? <br />
**A1:** Yes, Most things can easily be undone by going in the script and run it again with the deisred change. <br />
**A2:** System Restore can undo some of the changes, if you created a restore point (can be done from script)

**Q:** The script messed up my computer. <br />
**A:** The script is 'as is', any problems you have/had is not my problem.

**Q:** Can I use the script or modify it for my/my company's needs? <br />
**A:** Sure. Just don't forget to include copyright notice as per the license requirements, and leave any Copyright in script too.

**Q:** Can I add an App to Install/Hide/Uninstall, if so how? <br />
**A:** Yes you can. You can add it in the script file under APPS_AppsInstall, APPS_AppsHide, APPS_AppsUninstall. <br />
---------Please note you have to have the proper format and packagename for it to work.

**Q:** Can you add *BLAH* to the script? <br />
**A:** Mabye, Depends on what it is and how hard it would be to add. 

**Q:** How do I request adding *BLAH* to the script? <br />
**A:** Just post it as an Issue.

**Q:** Are you planning to add *BLAH* to the script? <br />
**A:** Check the todo list, anything i am planning to do or thinking of doing will be there.

**Q:** How long are you going to maintain the script? <br />
**A:** No Clue.
