##########
# Win10 Initial Setup Script Settings Menu
# 
# Author: Madbomb122
# Website: https://github.com/madbomb122/Win10Script
# Version: 0.0, 02-11-2017
# 
# Release Type: Work in Progress
##########

# This script it to make selection of settings easier

# This script it ment to
# 1. Make a file with your wanted settings
# 2. Edit Settings file (what you load)
# 3. Run script with setting inputed/loaded

# May become part of main script with switch to bypass 
# these menu and run script for automation

$MainMenuItems = @(
'                   Main Menu                     ',
'1. Run Script          ',
'2. Script Settings     ',
'3. Load Setting        ',
'4. Save Setting        ',
'5. Script Option       ',
'                       ',
'H. Help                ',
'                       ',
'                       ',
'                       ',
'                       ',
'                       ',
'Q. Exit/Quit           ',
'A. About               '
)

$ScriptSettingsMainMenuItems = @(
'            Script Setting Main Menu             ',
'1. Privacy Settings    ',
'2. Windows Update      ',
'3. Service Tweaks      ',
'4. Context Menu        ',
'5. Task Bar            ',
'6. Star Menu           ',
'7. Explorer            ',
"8. 'This PC'           ",
'9. Photo Viewer        ',
'10. Lock Screen        ',
'11. Features/Apps      ',
'12. Misc               ',
'B. Back to Main Menu                             '
)

$Invalid=0

function MenuDisplay ([Array]$ToDisplay, [Int]$MM) {
    Write-host "|---------------------------------------------------|"
    Write-host -NoNewline "|  ";Write-Host -ForegroundColor Cyan -NoNewline $ToDisplay[0];Write-Host "|"
    Write-host "|---------------------------------------------------|"
	Write-host "|                         |                         |"
    Write-host -NoNewline "|  ";Write-Host -ForegroundColor Cyan -NoNewline $ToDisplay[1];Write-Host -NoNewline "|  ";Write-Host -ForegroundColor Cyan -NoNewline $ToDisplay[7];Write-Host "|"
    Write-host -NoNewline "|  ";Write-Host -ForegroundColor Cyan -NoNewline $ToDisplay[2];Write-Host -NoNewline "|  ";Write-Host -ForegroundColor Cyan -NoNewline $ToDisplay[8];Write-Host "|"
    Write-host -NoNewline "|  ";Write-Host -ForegroundColor Cyan -NoNewline $ToDisplay[3];Write-Host -NoNewline "|  ";Write-Host -ForegroundColor Cyan -NoNewline $ToDisplay[9];Write-Host "|"
    Write-host -NoNewline "|  ";Write-Host -ForegroundColor Cyan -NoNewline $ToDisplay[4];Write-Host -NoNewline "|  ";Write-Host -ForegroundColor Cyan -NoNewline $ToDisplay[10];Write-Host "|"
    Write-host -NoNewline "|  ";Write-Host -ForegroundColor Cyan -NoNewline $ToDisplay[5];Write-Host -NoNewline "|  ";Write-Host -ForegroundColor Cyan -NoNewline $ToDisplay[11];Write-Host "|"
    Write-host -NoNewline "|  ";Write-Host -ForegroundColor Cyan -NoNewline $ToDisplay[6];Write-Host -NoNewline "|  ";Write-Host -ForegroundColor Cyan -NoNewline $ToDisplay[12];Write-Host "|"
	Write-host "|                         |                         |"
    Write-host "|---------------------------------------------------|"
    if([Int]$MM -eq 1){
        Write-host -NoNewline "|  ";Write-Host -ForegroundColor Cyan -NoNewline $ToDisplay[13];Write-Host "|"
    } else {
        Write-host -NoNewline "|  ";Write-Host -ForegroundColor Cyan -NoNewline $ToDisplay[13];Write-Host -NoNewline "|  ";Write-Host -ForegroundColor Cyan -NoNewline $ToDisplay[14];Write-Host "|"
    }
    Write-host "|---------------------------------------------------|"
}

function ChoicesDisplay ([Array]$ChToDisplay) {
    Write-host "|---------------------------------------------------|"
    Write-host -NoNewline "|  ";Write-Host -ForegroundColor Cyan -NoNewline $ChToDisplay[0];Write-Host "|"
    Write-host "|---------------------------------------------------|"
	Write-host "|                                                   |"
    Write-host -NoNewline "|  ";Write-Host -ForegroundColor Cyan -NoNewline $ChToDisplay[1];Write-Host "|"
    Write-host -NoNewline "|  ";Write-Host -ForegroundColor Cyan -NoNewline $ChToDisplay[2];Write-Host "|"
	Write-host "|                                                   |"
    Write-host "|---------------------------------------------------|"
	Write-host "|                                                   |"
    Write-host -NoNewline "|  ";Write-Host -ForegroundColor Cyan -NoNewline $ChToDisplay[3];Write-Host "|"
    Write-host -NoNewline "|  ";Write-Host -ForegroundColor Cyan -NoNewline $ChToDisplay[4];Write-Host "|"
    Write-host -NoNewline "|  ";Write-Host -ForegroundColor Cyan -NoNewline $ChToDisplay[5];Write-Host "|"
    Write-host -NoNewline "|  ";Write-Host -ForegroundColor Cyan -NoNewline $ChToDisplay[6];Write-Host "|"
	Write-host "|                                                   |"
    Write-host "|---------------------------------------------------|"
    Write-host -NoNewline "|  ";Write-Host -ForegroundColor Cyan -NoNewline $ChToDisplay[7];Write-Host "|"
    Write-host "|---------------------------------------------------|"
}

function mainMenu {
    $mainMenu = 'X'
    while($mainMenu -ne 0){
        Clear-Host
		MenuDisplay $MainMenuItems 0
		If($Invalid -eq 1){
			Write-host "Invalid Selection" -ForegroundColor Red -BackgroundColor Black 
            $mainMenu = Read-Host "`nSelection"
			$Invalid = 0
		} Else {
            $mainMenu = Read-Host "`nSelection"
		}
		switch ($mainMenu) {
            1 {"The color is red."} #Run Script
            2 {ScriptSettingsMM} #Script Settings Main Menu
            3 {"The color is green."} #Load Settings
            4 {"The color is yellow."} #Save Settings
            5 {"The color is orange."} #Script Options
            H {"The color is orange."} #Help
            Q {$mainMenu = 0} 
            A {"The color is About."}  #About
            default {$Invalid = 1}
        }
    }
}

function ScriptSettingsMM {
    $ScriptSettingsMM = 'X'
    while($ScriptSettingsMM -ne 0){
        Clear-Host
		MenuDisplay $ScriptSettingsMainMenuItems 1
		If($Invalid -eq 1){
			Write-host "Invalid Selection" -ForegroundColor Red -BackgroundColor Black 
            $ScriptSettingsMM = Read-Host "`nSelection"
			$Invalid = 0
		} Else {
            $ScriptSettingsMM = Read-Host "`nSelection"
		}
		switch ($ScriptSettingsMM) {
            1 {"The color is red."} #Privacy Settings
            2 {""} #Windows Update
            3 {"The color is green."} #Service Tweaks
            4 {"The color is yellow."} #Context Menu
            5 {"The color is orange."} #Task Bar 
            6 {"The color is green."} #Star Menu
            7 {"The color is yellow."} #Explorer
            8 {"The color is orange."} #'This PC' 
            9 {"The color is yellow."} #Photo Viewer
            10 {"The color is orange."} #Lock Screen
            11 {"The color is green."} #Features/Apps
            12 {"The color is yellow."} #Misc
            B {$ScriptSettingsMM = 0} 
            default {$Invalid = 1}
		}
    }
}


mainMenu
