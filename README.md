To Download go to -> [Win 10 Script -Release](https://github.com/madbomb122/Win10Script/releases)

**Current Version**
**Script:** `3.7.1` (April 02, 2021)


## Contents
 - [Description](#description)
 - [Requirements](#requirements)
 - [How to Use](#how-to-use)
 - [Usage](#usage)
 - [Advanced Usage](#advanced-usage)
 - [FAQ](#faq)


## Description
This is a PowerShell script for automation of routine tasks/setting on Windows 10. 
This is by no means a complete set of settings. (There is ALOT that can be changed/done)

The original basic script created by https://github.com/Disassembler0/Win10-Initial-Setup-Script/  
^ We have some of the same setting and a few different stuff too

This script is a Highly Modded version of the 2.0 script by Disaseembler0.
The script has added items with an easy way to change settings and options using a GUI.

PS. Don't forget to check out my other Repo https://github.com/madbomb122/BlackViperScript 


## Requirements
**OS:** `Windows 10`  
**Needed Files:** `Win10-Menu.ps1` (Script File)  
**Recommended Files:** `_Win10-Script-Run.bat` 


## How to Use
Download/Save the following files  
Script File: [Win10-Menu.ps1](https://github.com/madbomb122/Win10Script/raw/master/Win10-Menu.ps1) (Script) -Size about `201.0 KB` -Need  
Bat File: [_Win10-Script-Run.bat](https://github.com/madbomb122/Win10Script/raw/master/_Win10-Script-Run.bat) -Size about `2.29 KB` -Recommended  
  **Note 1: DO NOT RENAME THE FILES**  
  **Note 2: HAVE THE FILES IN THE SAME DIRECTORY**  
Next follow the **Basic Usage** or **Advanced Usage**  

**You can do a `save as` on the filenames above to save them to you computer, you cannot do a `save as` on github's file list**  


## Usage
Run the Script by bat file `_Win10-Script-Run.bat` (Recommended)  
or  
`powershell.exe -NoProfile -ExecutionPolicy Bypass -File c:/Win10-Menu.ps1`   
*For the above, Please note you need change the c:/ to the fullpath of your file*  
Use the Menu  
Set what you want  
Select option to run script  


### Advanced usage
Use one of the following Methods you can 
1. Run script with one (or more) of the switches below
2. Edit the script (bottom of file) to change the values
3. Edit the bat file (top of file) to change the values to add the switch

|   Switch  | Description                                                         | Notes                            |
| :-------- | :-------------------------------------------------------------------| :------------------------------- |
| -atos     | Accepts the ToS                                                     |                                  |
| -auto     | Runs the script to be Automated.. Closes on Errors, End of Script)  | Implies `-atos`                  |
| -run      | Runs script with setting in script                                  |                                  |
| -run Settingfile    | Runs script with Settingfile                              | May Imply `-atos` (If file was saved from script) |
| -run WinDefault     | Runs script with Win Default                              |                                  |
| -load Settingfile   | Loads Settingfile (Does not run)                          |                                  |
| -load WinDefault    | Loads Win Default (Does not run)                          |                                  |
| -sic      | Skips Internet Check (If checking for update)                       | Tests by pinging github.com      |
| -usc      | Checks for Update to Script file before running                     | Auto downloads and runs if found |
| -crp      | Creates a Restore Point                                             |                                  |
| -dnr      | Do not restart when done                                            |                                  |
| -help     | Lists of all the switches                                           | Alt `-h`                         |

Examples:  
`powershell.exe -NoProfile -ExecutionPolicy Bypass -File Win10-Menu.ps1 -auto -run mine.csv`  
`powershell.exe -NoProfile -ExecutionPolicy Bypass -File Win10-Menu.ps1 -atos -load WinDefault`

******
## FAQ
**Q:** The script file looks all messy in notepad, How do i view it?  
**A:** Try using wordpad or what I recommend, Notepad++ [https://notepad-plus-plus.org/](https://notepad-plus-plus.org/) 

**Q:** Do you accept any donations?  
**A:** If you would like to donate to me Please pick an item/giftcard from my amazon wishlist or Contact me about donating, Thanks. BTW The giftcard amount can be changed to a min of $1.  
**Wishlist:** [https://www.amazon.com/gp/registry/wishlist/YBAYWBJES5DE/](https://www.amazon.com/gp/registry/wishlist/YBAYWBJES5DE/)

**Q:** How can I contact you?  
**A:** You can also PM me on reddit or email me  
         1. reddit /u/madbomb122 [https://www.reddit.com/user/madbomb122](https://www.reddit.com/user/madbomb122)  
         2. You can email me @ madbomb122@gmail.com.  
**Note** Before contacting me, please make sure you have ALL the needed files and the size is right (Look above under requirements). 

**Q:** Can you add *BLAH* to the apps list?  
**A:** Mabye, post [here](https://github.com/madbomb122/Win10Script/issues/8) and follow the instructions, and I may add it. 


**Q:** The script window closes or gives an error saying script is blocked, what do I do?  
**A:** By default windows blocks ps1 scripts, you can use one of the following  
         1. Use the bat file to run the script (recommended)  
         2. On an admin powershell console `Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted`

**Q:** Can I run the script safely?  
**A:** Yes and No, it depends on what you do, some items may cause problems and some items will not cause any issues.

**Q:** Can I run the script repeatedly?  
**A:** Yes, with same or different settings.

**Q:** Did you test the script?  
**A:** Yes, but doesnt mean there isnt any bugs/errors.

**Q:** I've run the script and it did *BLAH*, can I undo it?  
**A:** There are 2 possible ways...  
         1. Yes, Most things can easily be undone by going in the script and run it again with the deisred change.  
         2. System Restore can undo some of the changes, if you created a restore point (can be done from script)

**Q:** The script messed up my computer.  
**A:** The script is 'as is', any problems you have/had is not my problem.

**Q:** Can I use the script or modify it for my/my company's needs?  
**A:** Sure. Just don't forget to include copyright notice as per the license requirements, and leave any Copyright in script too.

**Q:** Can I add an App to Install/Hide/Uninstall, if so how?  
**A:** Yes you can. You can add it in the script file under APPS_AppsInstall, APPS_AppsHide, APPS_AppsUninstall.
---------Please note you have to have the proper format and packagename for it to work.

**Q:** Can you add *BLAH* to the script?  
**A:** Mabye, Depends on what it is and how hard it would be to add. 

**Q:** How do I request adding *BLAH* to the script?  
**A:** Just post it as an Issue.

**Q:** Are you planning to add *BLAH* to the script?  
**A:** Check the todo list, anything i am planning to do or thinking of doing will be there.

**Q:** How long are you going to maintain the script?  
**A:** No Clue.
