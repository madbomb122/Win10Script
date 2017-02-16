##########
# Win10 Initial Setup Script Settings Menu
#
# Author: Madbomb122
# Website: https://github.com/madbomb122/Win10Script
# Version: 0.0, 02-15-2017
#
# Release Type: Work in Progress
##########

# At the moment the Script will ONLY display items
# The save/load works but nothing to load/save ATM

# This script it to make selection of settings easier

# This script it ment to
# 1. Make a file with your wanted settings
# 2. Edit Settings file (what you load)
# 3. Run script with setting inputed/loaded

## READ ME!! 
## Need to Set ALL variables with $Script:
## Need to Move ALL stuff from other script to this when done
## Need to Add description for ALL items (other than script options)
## Need to decide if ALL metro items will be done or just what i have set currently

## Remove the Bellow ITEM when done
$colors = @(
     "black",        #0
     "blue",         #1
     "cyan",         #2
     "darkblue",     #3
     "darkcyan",     #4
     "darkgray",     #5
     "darkgreen",    #6
     "darkmagenta",  #7
     "darkred",      #8
     "darkyellow",   #9
     "gray",         #10
     "green",        #11
     "magenta",      #12
     "red",          #13
     "white",        #14
     "yellow"        #15
)

If ($RanOnce -ne "Ran"){
$Script:CreateRestorePoint = 0
$Script:ShowColor = 1
$Script:RanOnce = "Ran"
}
## Remove the Above ITEM when done

##########
# Version Info -Start
##########

$CurrVer = "0.0 (02-11-17) "
$RelType = "Beta   "
#$RelType = "Testing"
#$RelType = "Stable "

##########
# Version Info -End
##########

##########
# Multi Use Functions -Start
##########

# Used to Help remove the Automatic variables
function cmpv {
    Compare-Object (Get-Variable) $AutomaticVariables -Property Name -PassThru | Where -Property Name -ne "AutomaticVariables"
}

# Function to Display in Color or NOT (for MENU ONLY)
Function DisplayOutMenu([String]$TxtToDisplay,[int]$TxtColor,[int]$BGColor,[int]$NewLine){
    If ($NewLine -eq 0){
        If($TxtColor -le 15 -and $ShowColor -eq 1){
             Write-Host -NoNewline $TxtToDisplay -ForegroundColor $colors[$TxtColor] -BackgroundColor $colors[$BGColor]
        } Else {
             Write-Host -NoNewline $TxtToDisplay
        }
    } Else {
        If($TxtColor -le 15 -and $ShowColor -eq 1){
             Write-Host $TxtToDisplay -ForegroundColor $colors[$TxtColor] -BackgroundColor $colors[$BGColor]
        } Else {
             Write-Host $TxtToDisplay
        }
    }
}

function ChoicesMenu([String]$Vari, [Int]$Number) {
    $VariJ = -join($Vari,"Items")
    $VariV = Get-Variable $Vari -valueOnly #Variable
    $VariA = Get-Variable $VariJ -valueOnly #Array
    $ChoicesMenu = 'X'
    while($ChoicesMenu -ne "Out"){
        Clear-Host
        ChoicesDisplay $VariA $VariV
        If($Invalid -eq 1){
            Write-host ""
            Write-host "Invalid Selection" -ForegroundColor Red -BackgroundColor Black -NoNewline
            $Invalid = 0
        }
        $ChoicesMenu = Read-Host "`nChoice"
        switch ($ChoicesMenu) {
            C {$ReturnV = $VariV; $ChoicesMenu = "Out"}
            default {if($Number -ge $ChoicesMenu) {$ReturnV = $ChoicesMenu; $ChoicesMenu = "Out"} Else {$Invalid = 1}}
        }
    }
    Set-Variable -Name $Vari -Value $ReturnV -Scope Script;
}

function VariMenu([Array]$VariDisplay,[Array]$VariMenuItm) {
    $VariMenu = 'X'
    while($VariMenu -ne "Out"){
        Clear-Host
        MenuDisplay $VariDisplay
        If($Invalid -eq 1){
            Write-host ""
            Write-host "Invalid Selection" -ForegroundColor Red -BackgroundColor Black -NoNewline
            $Invalid = 0
        }
        $VariMenu = Read-Host "`nSelection"
        $ConInt = $VariMenu -as [int]
        If($ConInt -is [int]){
            for ($i=0; $i -le $VariMenuItm.length; $i++) {
                If($VariMenuItm[$i][0] -eq $ConInt){
                    $LoopVar = $i
                    $i = $VariMenuItm.length+1
                }
            }
            If($LoopVar -is [int]){
                ChoicesMenu ($VariMenuItm[$LoopVar][1]) ($VariMenuItm[$LoopVar][2])
            } Else{
                $Invalid = 1        
            }
        } Else {
            switch ($VariMenu) {
                C {$VariMenu = "Out"}
                default {$Invalid = 1}
            }
        }
    }
}

##########
# Multi Use Functions -End
##########

##########
# Confirm Menu -Start
##########

$ConfirmMenuItems1 = @(
'                 Confirm Dialog                  ',

'              Are You sure? (Y/N)                ',
'0. Cancel/Back to Main Menu                      '
)

$ConfirmMenuItems2 = @(
'                 Confirm Dialog                  ',
'                                                 ',
'  File Exists do you want to overwrite? (Y/N)    ',
'0. Cancel/Back to Main Menu                      '
)

function ConfirmMenu([int]$Option) {
    $ConfirmMenu = 'X'
    while($ConfirmMenu -ne "Out"){
        Clear-Host
        If ($Option -eq 1){
            VariableDisplay $ConfirmMenuItems1
        } ElseIf ($Option -eq 2){
            VariableDisplay $ConfirmMenuItems2
        }
        $ConfirmMenu = Read-Host "`nSelection (Y/N)"
        switch (ConfirmMenu) {
            Y {Return $true}
            N {Return $false}
            default {Return $false}
        }
    }
}

##########
# Confirm Menu -End
##########

##########
# Menu Display Function -Start
##########

#DisplayOutMenu([String]$TxtToDisplay,[int]$TxtColor,[int]$BGColor,[int]$NewLine)

# Displays Menu items but has Seperators
function MenuDisplay ([Array]$ToDisplay) {
    TitleBottom $ToDisplay[0] 11
    DisplayOutMenu "|                         |                         |" 14 0 1
    for ($i=1; $i -lt $ToDisplay.length-1; $i++) {
        DisplayOutMenu "|  " 14 0 0 ;DisplayOutMenu $ToDisplay[$i] 2 0 0 ;DisplayOutMenu "|  " 14 0 0 ;DisplayOutMenu $ToDisplay[$i+1] 2 0 0 ;DisplayOutMenu "|" 14 0 1
        $i++
    }
    DisplayOutMenu "|                         |                         |" 14 0 1
    TitleBottom $ToDisplay[$ToDisplay.length-1] 13
    Website
}

# To display Settings Item with Choices for it
# 1-2 are for description
# For loop = Choices
# $ChToDisplayVal = Current Value
function ChoicesDisplay ([Array]$ChToDisplay, [Int]$ChToDisplayVal) {
    TitleBottom $ChToDisplay[0] 11
    DisplayOutMenu "|                                                   |" 14 0 1
    DisplayOutMenu "|  " 14 0 0 ;DisplayOutMenu $ChToDisplay[1] 2 0 0 ;DisplayOutMenu "|" 14 0 1
    DisplayOutMenu "|  " 14 0 0 ;DisplayOutMenu $ChToDisplay[2] 2 0 0 ;DisplayOutMenu "|" 14 0 1
    DisplayOutMenu "|                                                   |" 14 0 1
    DisplayOutMenu "|---------------------------------------------------|" 14 0 1
    DisplayOutMenu "|                                                   |" 14 0 1
    for ($i=3; $i -lt $ChToDisplay.length-1; $i++) {
        DisplayOutMenu "|  " 14 0 0 ;DisplayOutMenu $ChToDisplay[$i] 2 0 0 ;DisplayOutMenu "|" 14 0 1
    }
    DisplayOutMenu "|                                                   |" 14 0 1
    DisplayOutMenu "|  " 14 0 0 ;DisplayOutMenu "Current Value: " 13 0 0 ;DisplayOutMenu $ChToDisplayVal 13 0 0 ;DisplayOutMenu "                                 |" 14 0 1
    TitleBottom $ChToDisplay[$ChToDisplay.length-1] 13
    Website
}


# Displays items but NO Seperators
function VariableDisplay ([Array]$VarToDisplay) {
    TitleBottom $VarToDisplay[0] 11
    for ($i=3; $i -lt $VarToDisplay.length-1; $i++) {
        DisplayOutMenu "|  " 14 0 0 ;DisplayOutMenu $VarToDisplay[$i] 2 0 0 ;DisplayOutMenu "|" 14 0 1
    }
    TitleBottom $VarToDisplay[$VarToDisplay.length-1] 16
}

# Displays Title of Menu but with color choices
function TitleBottom ([String]$TitleA,[Int]$TitleB) {
    DisplayOutMenu "|---------------------------------------------------|" 14 0 1
    If($TitleB -eq 16) {
        DisplayOutMenu "|  " 14 0 0 ;DisplayOutMenu "Current Version: " 15 0 0 ;DisplayOutMenu $CurrVer 15 0 0 ;DisplayOutMenu "|" 14 0 0
        If($RelType -eq "Stable "){
        DisplayOutMenu " Release:" 11 0 0 ;DisplayOutMenu $RelType 11 0 0 ;
        } Else {
        DisplayOutMenu " Release:" 15 0 0 ;DisplayOutMenu $RelType 15 0 0 ;
        }
        DisplayOutMenu "|" 14 0 1
    } Else {
        DisplayOutMenu "|  " 14 0 0 ;DisplayOutMenu $TitleA $TitleB 0 0 ;DisplayOutMenu "|" 14 0 1
    }
    DisplayOutMenu "|---------------------------------------------------|" 14 0 1
}

function Website {
    DisplayOutMenu "|" 14 0 0 ;DisplayOutMenu "     https://github.com/madbomb122/Win10Script     " 15 0 0 ;DisplayOutMenu "|" 14 0 1
    DisplayOutMenu "|---------------------------------------------------|" 14 0 1
}

##########
# Menu Display Function -End
##########

##########
# Main Menu -Start
##########

$MainMenuItems = @(
'                    Main Menu                    ',
'1. Run Script          ','U. How to Use Script   ',
'2. Script Settings     ','H. Help                ',
'3. Load Setting        ','C. Copyright           ',
'4. Save Setting        ','A. About/Version       ',
'5. Script Options      ','                       ',
'Q. Exit/Quit                                     '
)

function mainMenu {
    $mainMenu = 'X'
    while($mainMenu -ne "Out"){
        Clear-Host
        MenuDisplay $MainMenuItems 0
        If($Invalid -eq 1){
            Write-host ""
            Write-host "Invalid Selection" -ForegroundColor Red -BackgroundColor Black -NoNewline
            $Invalid = 0
        }
        $mainMenu = Read-Host "`nSelection"
        switch ($mainMenu) {
            1 {""} #Run Script
            2 {ScriptSettingsMM} #Script Settings Main Menu
            3 {LoadSetting} #Load Settings
            4 {SaveSetting} #Save Settings
            5 {VariMenu $ScriptOptionMenuItems $ScriptOptionMenuItm} #Script Options
            H {HUACMenu "HelpItems"} #Help
            U {HUACMenu "UsageItems"} #How to Use
            A {HUACMenu "AboutItems"}  #About/Version
            C {HUACMenu "CopyrightItems"}  #Copyright
            Q {$mainMenu = "Out"} 
            default {$Invalid = 1}
        }
    }
}

##########
# Main Menu -End
##########

##########
# Script Settings -Start
##########

$ScriptSettingsMainMenuItems = @(
'            Script Setting Main Menu             ',
'1. Privacy Settings    ','7. Windows Update      ',
'2. Service Tweaks      ','8. Context Menu        ',
'3. Start Menu          ','9. Task Bar            ',
'4. Lock Screen         ','10. Features           ',
"5. 'This PC'           ",'11. Metro Apps         ',
'6. Explorer            ','12. Misc/Photo Viewer  ',
'B. Back to Main Menu                             '
)

function ScriptSettingsMM {
    $ScriptSettingsMM = 'X'
    while($ScriptSettingsMM -ne "Out"){
        Clear-Host
        MenuDisplay $ScriptSettingsMainMenuItems
        If($Invalid -eq 1){
            Write-host ""
            Write-host "Invalid Selection" -ForegroundColor Red -BackgroundColor Black -NoNewline
            $Invalid = 0
        }
        $ScriptSettingsMM = Read-Host "`nSelection"
        switch ($ScriptSettingsMM) {
            1 {VariMenu $PrivacySetMenuItems $PrivacySetMenuItm} #Privacy Settings
            2 {VariMenu $ServiceTweaksSetMenuItems $ServiceTweaksSetMenuItm} #Service Tweaks
            3 {VariMenu $StartMenuSetMenuItems $StartMenuSetMenuItm} #Star Menu
            4 {VariMenu $LockScreenSetMenuItems $LockScreenSetMenuItm} #Lock Screen
            5 {VariMenu $ThisPCSetMenuItems $ThisPCSetMenuItm} #'This PC'
            6 {VariMenu $ExplorerSetMenuItems $ExplorerSetMenuItm} #Explorer
            7 {VariMenu $WindowsUpdateSetMenuItems $WindowsUpdateSetMenuItm} #Windows Update
            8 {VariMenu $ContextMenuSetMenuItems $ContextMenuSetMenuItm} #Context Menu
            9 {VariMenu $TaskbarSetMenuItems $TaskbarSetMenuItm} #Task Bar
            10 {VariMenu $FeaturesAppsMenuItems $FeaturesAppsMenuItm} #Features
            11 {VariMenu $MetroAppsMenuItems $MetroAppsMenuItm} #Metro Apps
            12 {VariMenu $MiscSetMenuItems $MiscSetMenuItm} #Misc/Photo Viewer
            B {$ScriptSettingsMM = "Out"}
            default {$Invalid = 1}
        }
    }
}

##########
# Script Settings -End
##########

##########
# Load/Save Settings -Start
##########

$SettingFileItems = @(
'                  Setting File                   ',
'                                                 ',
'            Please Input Filename.               ',
'  0. Cancel/Back to Main Menu                    '
)

function LoadSetting {
    $LoadSetting = 'X'
    while($LoadSetting -ne "Out"){
        Clear-Host
        VariableDisplay $SettingFileItems
        If($Invalid -eq 1){
            Write-host ""
            Write-host "No file with the name " $LoadSetting -ForegroundColor Red -BackgroundColor Black -NoNewline
            $Invalid = 0
        }
    # Add ability to load Win Default Values
        $LoadSetting = Read-Host "`nFilename"
        If ($LoadSetting -eq $null -or $LoadSetting -eq 0){
            $LoadSetting ="Out"
        } ElseIf (Test-Path $LoadSetting -PathType Leaf){
            $Conf = ConfrmMenu 1
            If($Conf -eq $true){
                Import-Clixml .\$LoadSetting | %{ Set-Variable $_.Name $_.Value }
                $LoadSetting = 0
            } Else {
                $LoadSetting = 0
            }
        } Else {
            $Invalid = 1
        }
    }
}

function SaveSetting {
    $SaveSetting = 'X'
    while($SaveSetting -ne "Out"){
        Clear-Host
        VariableDisplay $SettingFileItems
        $SaveSetting = Read-Host "`nFilename"
        If ($LoadSetting -eq $null -or $LoadSetting -eq 0){
            $SaveSetting = "Out"
        } Else {
            If (Test-Path $SaveSetting -PathType Leaf){
                $Conf = ConfirmMenu 2
                If($Conf -eq $true){
                    cmpv | Export-Clixml .\$SaveSetting
                }
            } Else {
                cmpv | Export-Clixml .\$SaveSetting
            }
            $SaveSetting = "Out"
        }
    }
}

##########
#  Load/Save Settings -End
##########

##########
# Script Options Sub Menu -Start
##########

$ScriptOptionMenuItems = @(
'              Metro Apps Items Menu              ',
'1. Create Restore Point','4. Show Color          ',
'2. Agree Term of Use   ','5. Restart when Done   ',
'3. Verbros             ','                       ',
'B. Back to Main Menu                             '
)

$ScriptOptionMenuItm = (
(1,"CreateRestorePoint",1),
(2,"Term_of_Use",1),
(3,"Verbros",1),
(4,"ShowColor",1),
(5,"Restart",1)
)

$CreateRestorePointItems = @(
'              Create Restore Point               ',
' Creates a restore point before the script runs. ',
' This Only can be done once ever 24 Hours.       ',
'0. Skip                                          ',
'1. Create Restore Point                          ',
'C. Cancel (Keeps Current Setting)                '
)

$Term_of_UseItems = @(
'                   Term of Use                   ',
'                                                 ',
' DO you Agree to the Terms of Use?               ',
'0. Agree to Term of Use                          ',
'1. Disagree (Will See Terms when you run script) ',
'C. Cancel (Keeps Current Setting)                '
)

$VerbrosItems = @(
'                     Verbros                     ',
'                                                 ',
' Shows output of the Script.                     ',
'0. Dont Show Output                              ',
'1. Show Output                                   ',
'C. Cancel (Keeps Current Setting)                '
)

$ShowColorItems = @(
'                   Show Color                    ',
'                                                 ',
' Shows color for the output of the Script.       ',
'0. Dont Show Color                               ',
'1. Show Color                                    ',
'C. Cancel (Keeps Current Setting)                '
)

$RestartItems = @(
'                     Restart                     ',
' Restart computer when Script is done?           ',
' I recommend you restart computer.               ',
'0. Dont Restart Computer                         ',
'1. Restart Computer                              ',
'C. Cancel (Keeps Current Setting)                '
)

##########
# Script Options Sub Menu -End
##########

##########
# Info Display Stuff -Start
##########

$HelpItems = @(
'                      Help                       ',
'                                                 ',
'                                                 ',
'Press "Enter" to go back                         '
)

$UsageItems = @(
'                How to Use Script                ',
'                                                 ',
' Basic Usage:                                    ',
' Use the menu & select what you want to change.  ',
'                                                 ',
' Advanced Usage Choices (Bypasses Menu):         ',
' 1. Edit the script & change values there then   ',
'        run script with "-set Run"               ',
' 2. Run Script with an imported file with        ',
'        "-set filename"                          ',
' 3. Run Script with Window Default Values with   ',
'        "-set WD" or "-set WindowsDefault"       ',
'                                                 ',
' Examples:                                       ',
'    Win10-Mod.ps1 -set Run                       ',
'    Win10-Mod.ps1 -set Settings.xml              ',
'    Win10-Mod.ps1 -set WD                        ',
'                                                 ',
'Press "Enter" to go back                         '
)

$AboutItems = @(
'                About this Script                ',
'                                                 ',
' This script makes it easier to setup an         ',
' existing or new install with modded setting.    ',
'                                                 ',
' This script was made by Me (Madbomb122).        ',
'    https://github.com/madbomb122/Win10Script    ',
'                                                 ',
' Original basic script was made by Disassembler  ',
'    https://github.com/Disassembler0/            ',
'                                                 ',
"Press 'Enter' to go back                         "
)

$CopyrightItems = @(
'                    Copyright                    ',
'                                                 ',
' Copyright (c) 2017 Disassembler -Original       ',
' Copyright (c) 2017 Madbomb122 -This Script      ',
' This program is free software: you can          ',
' redistribute it and/or modify This program is   ',
' free software This program is free software:    ',
' you can redistribute it and/or modify it under  ',
' the terms of the GNU General Public License as  ',
' published by the Free Software Foundation,      ',
' version 3 of the License.                       ',
'                                                 ',
' This program is distributed in the hope that it ',
' will be useful, but WITHOUT ANY WARRANTY;       ',
' without even the implied warranty of            ',
' MERCHANTABILITY or FITNESS FOR A PARTICULAR     ',
' PURPOSE.  See the GNU General Public License    ',
' for more details.                               ',
'                                                 ',
' You should have received a copy of the GNU      ',
' General Public License along with this program. ',
' If not, see <http://www.gnu.org/licenses/>.     '
)

function HUACMenu([String]$VariJ) {
    $HUACMenu = 'X'
    $VariA = Get-Variable $VariJ -valueOnly #Array
    while($HUACMenu -ne "Out"){
        Clear-Host
        VariableDisplay $VariA 0
        $HUACMenu = Read-Host "`nPress 'Enter' to continue"
        switch ($HUACMenu) {
            default {$HUACMenu = "Out"}
        }
    }
}

##########
# Info Display Stuff -End
##########

##########
# Script Settings Sub Menu -Start
##########

$PrivacySetMenuItems = @(
'              Privacy Settings Menu              ',
'1. Telemetry           ','7. Wi-Fi Sense         ',
'2. Smart Screen        ','8. Auto Logger File    ',
'3. Location Tracking   ','9. Feedback            ',
'4. Diagnostic Track    ','10. Advertising ID     ',
'5. Cortana             ','11. Cortana Search     ',
'6. Error Reporting     ','12. WAP Push           ',
'B. Back to Script Setting Main Menu              '
)

$PrivacySetMenuItm = (
(1,"Telemetry",2),
(2,"SmartScreen",2),
(3,"LocationTracking",2),
(4,"DiagTrack",2),
(5,"Cortana",2),
(6,"ErrorReporting",2),
(7,"WiFiSense",2),
(8,"AutoLoggerFile",2),
(9,"Feedback",2),
(10,"AdvertisingID",2),
(11,"CortanaSearch",2),
(12,"WAPPush",2)
)

$WindowsUpdateSetMenuItems = @(
'           Window Update Settings Menu           ',
'1. Check for Update    ','5. Update Type         ',
'2. Update Download     ','6. Update MSRT         ',
'3. Update Driver       ','7. Restart on Update   ',
'4. App Auto Download   ','                       ',
'B. Back to Script Setting Main Menu              '
)

$WindowsUpdateSetMenuItm = (
(1,"CheckForWinUpdate",2),
(2,"WinUpdateDownload",3),
(3,"UpdateDriver",2),
(4,"AppAutoDownload",2),
(5,"WinUpdateType",4),
(6,"UpdateMSRT",2),
(7,"RestartOnUpdate",2)
)

$ServiceTweaksSetMenuItems = @(
'          Service Tweaks Settings Menu           ',
'1. User Agent Control  ','5. Sharing Mapped Drive',
'2. Admin Shares        ','6. Firewall            ',
'3. Windows Defender    ','7. HomeGroups          ',
'4. Remote Assistance   ','8. Remote Desktop      ',
'B. Back to Script Setting Main Menu              '
)

$ServiceTweaksSetMenuItm = (
(1,"UAC",3),
(2,"AdminShares",2),
(3,"WinDefender",2),
(4,"RemoteAssistance",2),
(5,"SharingMappedDrives",2),
(6,"Firewall",2),
(7,"HomeGroups",2),
(8,"RemoteDesktop",2)
)

$ContextMenuSetMenuItems = @(
'             Context Menu Items Menu             ',
'1. Cast to Device      ','4. Previous Versions   ',
'2. Include in Library  ','5. Pin To              ',
'3. Share With          ','6. Send To             ',
'B. Back to Script Setting Main Menu              '
)

$ContextMenuSetMenuItm = (
(1,"CastToDevice",2),
(2,"IncludeinLibrary",2),
(3,"ShareWith",2),
(4,"PreviousVersions",2),
(5,"PinTo",2),
(6,"SendTo",2)
)

$StartMenuSetMenuItems = @(
'              Start Menu Items Menu              ',
'1. Startmenu Web Search','4. Most Used Apps      ',
'2. Suggestions         ','5. Recent & Frequent   ',
'3. Unpin Items         ','                       ',
'B. Back to Script Setting Main Menu              '
)

$StartMenuSetMenuItm = (
(1,"StartMenuWebSearch",2),
(2,"StartSuggestions",2),
(3,"UnpinItems",2), #Need to Setup
(4,"MostUsedAppStartMenu",2),
(5,"RecentItemsFrequent",2)
)

$TaskbarSetMenuItems = @(
'               Taskbar Items Menu                ',
'1. Battery UI Bar      ','7. Clock UI Bar        ',
'2. Volume Control Bar  ','8. Taskbar Search Box  ',
'3. Task View Button    ','9. Taskbar Icon Size   ',
'4. Taskbar Grouping    ','10. Notifcation Icons  ',
'5. Seconds in Clock    ','11. Last Active Click  ',
'6. Multi Display       ','12. Buttons on Display ',
'B. Back to Script Setting Main Menu              '
)

$TaskbarSetMenuItm = (
(1,"BatteryUIBar",2),
(2,"VolumeControlBar",2),
(3,"TaskViewButton",2),
(4,"TaskbarGrouping",3),
(5,"SecondsInClock",2),
(6,"TaskBarOnMultiDisplay",2),
(7,"ClockUIBar",2),
(8,"TaskbarSearchBox",2),
(9,"TaskbarIconSize",2),
(10,"TrayIcons",2),
(11,"LastActiveClick",2),
(12,"TaskbarButtOnDisplay",3)
)

$ExplorerSetMenuItems = @(
'               Explorer Items Menu               ',
'1. Frequent Quick Acess','7. Content While Drag  ',
'2. Recent Quick Acess  ','8. Explorer Open Locat ',
'3. System Files        ','9. Known Extensions    ',
'4. Hidden Files        ','10. Autorun            ',
'5. Aero Snape          ','11. Autoplay           ',
'6. Aero Shake          ','12. Pid in Title Bar   ',
'B. Back to Script Setting Main Menu              '
)

$ExplorerSetMenuItm = (
(1,"FrequentFoldersQikAcc",2),
(2,"RecentFileQikAcc",3),
(3,"SystemFiles",2),
(4,"HiddenFiles",2),
(5,"AeroSnap",2),
(6,"AeroShake",2),
(7,"WinContentWhileDrag",2),
(8,"ExplorerOpenLoc",2),
(9,"KnownExtensions",2),
(10,"Autorun",2),
(11,"Autoplay",2),
(12,"PidInTitleBar",2)
)

$ThisPCSetMenuItems = @(
"               'This PC' Items Menu              ",
"1. 'This PC' On Desktop",'5. Desktop Icon        ',
'2. Documents Icon      ','6. Downloads Icon      ',
'3. Music Icon          ','7. Pictures Icon       ',
'4. Videos Icon         ','                       ',
'B. Back to Script Setting Main Menu              '
)

$ThisPCSetMenuItm = (
(1,"ThisPCOnDesktop",2),
(2,"DocumentsIconInThisPC",2),
(3,"MusicIconInThisPC",2),
(4,"VideosIconInThisPC",2),
(5,"DesktopIconInThisPC",2),
(6,"DownloadsIconInThisPC",2),
(7,"PicturesIconInThisPC",2)
)

$LockScreenSetMenuItems = @(
'              Lock Screen Items Menu             ',
'1. Lock Screen         ','3. Power Menu          ',
'2. Lock Screen Alt'     ,'4. Camera              ',
'B. Back to Script Setting Main Menu              '
)

$LockScreenSetMenuItm = (
(1,"LockScreen",2),
(2,"LockScreenAlt",2),
(3,"PowerMenuLockScreen",2),
(4,"CameraOnLockScreen",2)
)

$MiscSetMenuItems = @(
'           Misc/Photo Viewer Items Menu          ',
'       Misc Item       ',' Photo Viewer Settings ',
'1. Action Center       ','8. File Association    ',
'2. Sticky Key Prompt   ','9. Open With Menu      ',
'3. Numblock On Start   ','                       ',
'4. F8 Boot Menu        ','                       ',
'5. Remote UAC Token    ','                       ',
'6. Hibernate           ','                       ',
'7. Sleep               ','                       ',
'B. Back to Script Setting Main Menu              '
)

$MiscSetMenuItm = (
(1,"ActionCenter",2),
(2,"StickyKeyPrompt",2),
(3,"NumblockOnStart",2),
(4,"F8BootMenu",2),
(5,"RemoteUACAcctToken",2),
(6,"HibernatePower",2),
(7,"SleepPower",2),
(8,"PVFileAssociation",2),
(9,"PVOpenWithMenu",2)
)

$FeaturesAppsMenuItems = @(
'               Features Items Menu               ',
'1. One Drive           ','4. Media Player        ',
'2. One Drive Install   ','5. Work Folders        ',
'3. Xbox DVR            ','6. Linux Subsystem     ',
'B. Back to Script Setting Main Menu              '
)

$FeaturesAppsMenuItm = (
(1,"OneDrive",2),
(2,"OneDriveInstall",2),
(3,"XboxDVR",2),
(4,"MediaPlayer",2),
(5,"WorkFolders",2),
(6,"LinuxSubsystem",2),
(7,"SleepPower",2),
(8,"PVFileAssociation",2),
(9,"PVOpenWithMenu",2)
)

$MetroAppsMenuItems = @(
'              Metro Apps Items Menu              ',
'1. ALL METRO APPS      ','12. Microsoft Solitaire',
"2. '3DBuilder' app     ",'13. One Connect        ',
"3. 'Alarms' app        ",'14. Office OneNote     ',
"4. 'Calculator' app    ","15. 'People' app       ",
"5. 'Camera' app        ","16. 'Photos' app       ",
'6. Feedback Hub        ',"17. 'Skype' app        ",
"7. 'Get Office' App    ",'18. Sticky Notes       ',
'8. Get Started         ',"19. 'Store' app        ",
"9. 'Groove Music' app  ",'20. Voice Recorder     ',
"10. 'Maps' app         ","21. 'Weather' app      ",
"11. 'Messaging' App    ","22. 'Xbox' App         ",
'B. Back to Script Setting Main Menu              '
)

$MetroAppsMenuItm = (
(1,"ALL_METRO_APPS",3), #Need to create
(2,"APP_3DBuilder",3),
(3,"APP_WindowsAlarms",3),
(4,"APP_WindowsCalculator",3),
(5,"APP_WindowsCamera",3),
(6,"APP_WindowsFeed",3), #Need to make to combine both feedback
(7,"APP_MicrosoftOffHub",3),
(8,"APP_Getstarted",3),
(9,"APP_Zune",3), #Need to make to combine both Zune
(10,"APP_WindowsMaps",3),
(11,"APP_Messaging",3),
(12,"APP_SolitaireCollect",3),
(13,"APP_OneConnect",3),
(14,"APP_OfficeOneNote",3),
(15,"APP_People",3),
(16,"APP_Photos",3), #Need to make to combine both Skype
(17,"APP_Skype",3),
(18,"APP_StickyNotes",3),
(19,"APP_WindowsStore",3),
(20,"APP_SoundRecorder",3),
(22,"APP_BingWeather",3),
(21,"APP_XboxApp",3)
)

<#
# Apps not listed
$APP_AdvertisingXaml = 0   ## Removal may cause problem with some apps
$APP_Appconnector = 0      ## Not sure about this one
$APP_Asphalt8Airborne = 0  # 'Asphalt 8' game
$APP_BingFinance = 0       # 'Money' app - Financial news
$APP_BingFoodAndDrink = 0  # 'Food and Drink' app
$APP_BingHealthFitness = 0 # 'Health and Fitness' app
$APP_BingNews = 0          # 'Generic news' app
$APP_BingSports = 0        # 'Sports' app - Sports news
$APP_BingTranslator = 0    # 'Translator' app - Bing Translate
$APP_BingTravel = 0        # 'Travel' app
$APP_CandyCrushSoda = 0    # 'Candy Crush' game 
$APP_CommsPhone = 0        # 'Phone' app
$APP_Communications = 0    # 'Calendar and Mail' app
$APP_ConnectivityStore = 0     
$APP_Facebook = 0          # 'Facebook' app
$APP_FarmVille = 0         # 'Farm Ville' game
$APP_FreshPaint = 0        # 'Canvas' app
$APP_MicrosoftJackpot = 0  # 'Jackpot' app
$APP_MicrosoftJigsaw = 0   # 'Jigsaw' game       
$APP_MicrosoftMahjong = 0  # 'Mahjong' game
$APP_MicrosoftSudoku = 0   # 'Sudoku' game 
$APP_MinecraftUWP = 0      # 'Minecraft' game    
$APP_MovieMoments = 0        
$APP_Netflix = 0           # 'Netflix' app
$APP_OfficeSway = 0        # 'Sway' app
$APP_StudiosWordament = 0  # 'Wordament' game
$APP_Taptiles = 0          
$APP_Twitter = 0           # 'Twitter' app
$APP_WindowsPhone = 0      # 'Phone Companion' app
#> 

##########
# Script Settings Sub Menu -End
##########


# Used to get all values BEFORE any defined so
# when exporting shows ALL defined after this point
$AutomaticVariables = Get-Variable

mainMenu
