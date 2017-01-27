## Description

This is a PowerShell script for automation of routine tasks/setting on Windows 10. <br /> 
This is by no means a complete set of settings. (There is ALOT that can be changed/done)

This script originally created by https://github.com/Disassembler0/Win10-Initial-Setup-Script/

This script is a Modded version of the 2.0 script by Disaseembler0. <br />
The script has added items with an easier way to change preferences.

## Basic Usage
edit the file<br />
change setting you want (# will give what settings can be for that function) <br />
**Note: If you're not sure what something does dont change it or do a web search** <br />
save the file <br />
choose *Run with PowerShell* <br />
confirm execution policy change. <br>
Make sure your account is a member of Administrators group as the script attempts to run with elevated privileges. <br />

### Advanced Usage
The Following will run the script with resetting everything the script can change back to windows default (Other than reinstalling onedrive or apps) <br />
`powershell.exe -NoProfile -ExecutionPolicy Bypass -File Win10-v2.2-Mod.ps1 -Set WD` <br />
or <br />
`powershell.exe -NoProfile -ExecutionPolicy Bypass -File Win10-v2.2-Mod.ps11 -Set WindowsDefault` <br />

To import a file for a setting or settings <br />
`powershell.exe -NoProfile -ExecutionPolicy Bypass -File Win10-v2.2-Mod.ps1 -Set example.txt` <br />
**Note 1: For an example of the setting files look at '*example.txt*', but it doesn't have what each item can be set to like the script does.** <br />
**Note 2: The apps to remove cant be imported ATM (dunno if it can with how i have things)**

## FAQ
**Q:** Can I run the script safely? <br />
**A:** The script is safe, some setting changes may compromise your computer

**Q:** Can I run the script repeatedly? <br />
**A:** Yes.

**Q:** Did you test the script? <br />
**A:** Yes, but nothing is 100% bug free.

**Q**: I've run the script and it did *BLAH*, can I undo it? <br />
**A:** Yes, Most things can easily be undone.. Just go in the script and run it again with the deisred change.

**Q:** The script messed up my computer. <br />
**A:** The script is as is, any problems is not my fault.

**Q:** Can I use the script or modify it for my / my company's needs? <br />
**A:** Sure. Just don't forget to include copyright notice as per MIT license requirements. 

**Q:** How long are you going to maintain the script? <br />
**A:** No Clue.

**Q:** Can you add *BLAH* to the script? <br />
**A:** Mabye, Depends on what it is and how hard it would be to add. 

**Q:** How do I request adding *BLAH* to the script? <br />
**A:** Just post it as an Issue.

**Q:** Are you planning to add *BLAH* to the script? <br />
**A:** Check the todo list, anything i am planning to do or thinking of doing will be there.
