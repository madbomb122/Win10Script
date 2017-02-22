## Description

This is a PowerShell script for automation of routine tasks/setting on Windows 10. <br /> 
This is by no means a complete set of settings. (There is ALOT that can be changed/done)

The original basic script created by https://github.com/Disassembler0/Win10-Initial-Setup-Script/

This script is a Highly Modded version of the 2.0 script by Disaseembler0. <br />
The script has added items with an easier way to change preferences and a menu.

# [](#header-1)Basic Usage
Run the Script <br />
Use the Menu <br />
Set what you want <br />
Select option to run script <br />

## [](#header-2)Advanced Usage
Use one of the following Methods 
(Bat file provided can run script, look in bat file for insructions)

Change the variables you want (Bottom of Script) then run script with: <br />
   -Set Run

Examples: <br />
`powershell.exe -NoProfile -ExecutionPolicy Bypass -File Win10-Menu.ps1 -Set Run` <br />
`powershell.exe -NoProfile -ExecutionPolicy Bypass -File Win10-Menu.ps1 -Set RUN` <br />
******
To run the script with the Items in the script back to the Default
for windows run the script with one of the 2 switches bellow:  <br />
   -Set WD  <br />
   -Set WinDefault 

Examples: <br />
`powershell.exe -NoProfile -ExecutionPolicy Bypass -File Win10-Menu.ps1 -Set WD` <br />
or <br />
`powershell.exe -NoProfile -ExecutionPolicy Bypass -File Win10-Menu.ps1 -Set WinDefault` <br />
******
To run the script with imported Settings run the script with:   
   -Set Filename

Examples: <br />
`powershell.exe -NoProfile -ExecutionPolicy Bypass -File Win10-Menu.ps1 -Set File.csv` <br />
`powershell.exe -NoProfile -ExecutionPolicy Bypass -File Win10-Menu.ps1 -Set Whatever.txt` <br />
******
## FAQ
**Q:** The script file looks all messy in notepad, How do i view/change it? <br />
**A:** Try using wordpad or what I recommend, Notepad++ https://notepad-plus-plus.org/

**Q:** Can I run the script safely? <br />
**A:** The script itself is safe, however some setting it can change may compromise your computer.

**Q:** Can I run the script repeatedly? <br />
**A:** Yes, with same or different settings.

**Q:** Did you test the script? <br />
**A:** Yes, but doesnt mean there isnt any bugs/errors.

**Q:**: I've run the script and it did *BLAH*, can I undo it? <br />
**A1:** Yes, Most things can easily be undone by going in the script and run it again with the deisred change. <br />
**A2:** You also may beable to use system restore if you created a restore point (can be done from script)

**Q:** The script messed up my computer. <br />
**A:** The script is as is, any problems you have/had is not my problem.

**Q:** Can I use the script or modify it for my / my company's needs? <br />
**A:** Sure. Just don't forget to include copyright notice as per the license requirements, and leave any Copyright in script too.

**Q:** How long are you going to maintain the script? <br />
**A:** No Clue.

**Q:** Can you add *BLAH* to the script? <br />
**A:** Mabye, Depends on what it is and how hard it would be to add. 

**Q:** How do I request adding *BLAH* to the script? <br />
**A:** Just post it as an Issue.

**Q:** Are you planning to add *BLAH* to the script? <br />
**A:** Check the todo list, anything i am planning to do or thinking of doing will be there.
