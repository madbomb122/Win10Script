##########
# Win10 Initial Setup Script Settings with Menu
# 
# Original Basic Script from
# Author: Disassembler
# Website: https://github.com/Disassembler0/Win10-Initial-Setup-Script/
# Version: 2.0, 2017-01-08 (Version Copied)
#
# Modded Script Info
# Author: Madbomb122
# Website: https://github.com/madbomb122/Win10Script
# Version: 1.0-Mod, 02-09-2017
#
# Release Type: Testing
##########

<#
    Copyright (c) 2017 Disassembler <disassembler@dasm.cz> -Original Version of Script
    Copyright (c) 2017 Madbomb122 -Modded Version of Script
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#>

<#
----------------------------------------------------------------------------
.DESCRIPTION
    Makes it easier to setup an existing or new install with moded setting

.BASIC USAGE
	Edit this file and change what settings you want changed
	
.ADVANCED USAGE
  To run the script with the Items in the script back to the Default 
  for windows run the script with one of the 2 switches bellow:
    -Set WD
    -Set WindowsDefault 

Example: Win10-Menu.ps1 -Set WD
Example: Win10-Menu.ps1 -Set WindowsDefault
------
  To run the script with imported Settings run the script with:	
	-Set Filename

Example: Win10-Menu.ps1 -Set File.txt
Example: Win10-Menu.ps1 -Set Example

Note: File has to be in the proper format or settings wont be imported
------
  To run the script with the settings i use:	
	-Set Set1

Example: Win10-Menu.ps1 -Set Set1
----------------------------------------------------------------------------
#>

## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## !!!!!!!!!                                                !!!!!!!!!
## !!!!!!!!!               SAFE TO EDIT ITEM                !!!!!!!!!
## !!!!!!!!!              AT BOTTOM OF SCRIPT               !!!!!!!!!
## !!!!!!!!!                                                !!!!!!!!!
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## !!!!!!!!!                     CAUTION                    !!!!!!!!!
## !!!!!!!!!          DO NOT EDIT PAST THIS POINT           !!!!!!!!!
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

Param([alias("Set")] [string] $SettingImp)

# Ask for elevated permissions if required
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
     Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $args" -Verb RunAs
     Exit
}

# This script it ment to
# 1. Make a file with your wanted settings
# 2. Edit Settings file (what you load)
# 3. Run script with setting inputed/loaded


## READ ME!! 

## To DO:
## Need to Move ALL stuff from other script to this when done
## Need to Set ALL variables with $Script:
## Need to turn Terms of Use to a Function
## Need to turn Win Default to function

## Might make script for JUST the Apps (with NO menu) with 
##     1. Ability to Run from this script   
##     2. Have in script but have to set apps setting in script or file

##########
# Version Info -Start
##########

$CurrVer = "1.0 (02-16-17) "
$RelType = "Testing"
#$RelType = "Stable "

##########
# Version Info -End
##########

##########
# Multi Use Functions -Start
##########

Function TOSDisplay {
    If ($Term_of_Use -eq 1){
	    If($RelType -eq "Testing"){
            Write-Host "WARNING!!" -ForegroundColor Red -BackgroundColor Black
            Write-Host "This version is currently being tested and May have problems." -ForegroundColor Yellow -BackgroundColor Black 
            Write-Host ""
		}
        Write-Host "This program comes with ABSOLUTELY NO WARRANTY." -ForegroundColor Black -BackgroundColor White
        Write-Host "This is free software, and you are welcome to" -ForegroundColor Black -BackgroundColor White
        Write-Host "redistribute it under certain conditions." -ForegroundColor Black -BackgroundColor White
        Write-Host ""
        Write-Host "Read License file for full Terms." -ForegroundColor Black -BackgroundColor White
        Write-Host ""
        Write-Host "Do you Accept the Term of Use? (y/n)" -ForegroundColor White -BackgroundColor Black	
    }
}

function TOS {
    $TOS = 'X'
    while($TOS -ne "Out"){
        Clear-Host
        TOSDisplay
        If($Invalid -eq 1){
            Write-host ""
            Write-host "Invalid Input" -ForegroundColor Red -BackgroundColor Black -NoNewline
            $Invalid = 0
        }
        $TOS = Read-Host "`nDo you Accept the Term of Use? (y/n)"
        switch ($TOS) {
		    N {Exit}
            Y {mainMenu}
            default {$Invalid = 1}
        }
    }
}

# Used to Help remove the Automatic variables
function cmpv {
    Compare-Object (Get-Variable) $AutomaticVariables -Property Name -PassThru | Where -Property Name -ne "AutomaticVariables"
}

function Pin-App([string]$appname) {      
    ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'Unpin from Start'} | %{$_.DoIt()}
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

# Function to Display or Not Display OUTPUT
Function DisplayOut([String]$TxtToDisplay,[int]$TxtColor,[int]$BGColor){
    If($Verbros -eq 1){
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
		    [0-4] {if($Number -ge $ChoicesMenu) {$ReturnV = $i; $ChoicesMenu = "Out"} Else {$Invalid = 1}}
            C {$ReturnV = $VariV; $ChoicesMenu = "Out"}
            default {$Invalid = 1}
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
			    B {$VariMenu = "Out"}
                default {$Invalid = 1}
            }
        }
    }
}

# Need to Change to work better with metro apps
function MetroMenu([Array]$VariDisplay,[Array]$VariMenuItm) {
    $MetroMenu = 'X'
    while($MetroMenu -ne "Out"){
        Clear-Host
        MenuDisplay $VariDisplay
        If($Invalid -eq 1){
            Write-host ""
            Write-host "Invalid Selection" -ForegroundColor Red -BackgroundColor Black -NoNewline
            $Invalid = 0
        }
        $MetroMenu = Read-Host "`nSelection"
		$ConInt = $MetroMenu -as [int]
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
            switch ($MetroMenu) {
			    B {$MetroMenu = "Out"}
				N {""} #Next Page
				P {""} #Previous Page
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
"5. 'This PC'           ",'11. Misc/Photo Viewer  ',
'6. Explorer            ','                       ',
'B. Back to Main Menu                             '
)

<#
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
#>


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
            #11 {MetroMenu $MetroAppsMenuItems $MetroAppsMenuItm} #Metro Apps
            11 {VariMenu $MiscSetMenuItems $MiscSetMenuItm} #Misc/Photo Viewer
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

$LoadFileItems = @(
'                  Setting File                   ',
" Input of WD or  WinDefault will load the Windows",
' Default settings for each item in this script.  ',
'                                                 ',
'          Please Input Filename to Load.         ',
'  0. Cancel/Back to Main Menu                    '
)

$SaveSettingItems = @(
'                  Setting File                   ',
'          Please Input Filename to Save.         ',
'  0. Cancel/Back to Main Menu                    '
)

function LoadSetting {
    $LoadSetting = 'X'
    while($LoadSetting -ne "Out"){
        Clear-Host
        VariableDisplay $LoadFileItems
        If($Invalid -eq 1){
            Write-host ""
            Write-host "No file with the name " $LoadSetting -ForegroundColor Red -BackgroundColor Black -NoNewline
            $Invalid = 0
        }
        $LoadSetting = Read-Host "`nFilename"
		switch ($LoadSetting) {
		    0 {$LoadSetting ="Out"; $Switched = "True"}
			$null {$LoadSetting ="Out"; $Switched = "True"}
		    WD {LoadWinDefault; $Switched = "True"}
			WinDefault {LoadWinDefault; $Switched = "True"}
		}
		If ($Switched -ne "True"){
            If (Test-Path $LoadSetting -PathType Leaf){
                $Conf = ConfrmMenu 1
                If($Conf -eq $true){
                    Import-Clixml .\$LoadSetting | %{ Set-Variable $_.Name $_.Value }
                    $LoadSetting ="Out"
                }
            } Else {
                $Invalid = 1
            }
		}
    }
}

function LoadSettingFile([String]$Filename) {
	#Import-Clixml .\$Filename | %{ Set-Variable $_.Name $_.Value }
	Import-Clixml $Filename | %{ Set-Variable $_.Name $_.Value }
	RunScript
}

function SaveSetting {
    $SaveSetting = 'X'
    while($SaveSetting -ne "Out"){
        Clear-Host
        VariableDisplay $SaveSettingItems
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

  ##########
  # Privacy Menu -Start
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

$TelemetryItems = @(
'                    Telemetry                    ',
'                                                 ',
' Sends various data to Microsoft.                ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$SmartScreenItems = @(
'                  Smart Screen                   ',
' Identify reported phishing & malware websites.  ',
' Helps you make informed decisions for downloads.',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$LocationTrackingItems = @(
'                Location Tracking                ',
' Keeps track of your GPS (If avilable).          ',
" This is used for the 'Find My PC' option.       ",
'0. Skip                                          ',
'1. Enable                                        ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$DiagTrackItems = @(
'               Diagnostic Tracking               ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$CortanaItems = @(
'                     Cortana                     ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$ErrorReportingItems = @(
'                 Error Reporting                 ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$WiFiSenseItems = @(
'                   Wi-Fi Sense                   ',
' Automatically connects you to open hotspots,    ',
' it knows about through crowdsourcing            ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$AutoLoggerFileItems = @(
'                Auto Logger File                 ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$FeedbackItems = @(
'                    Feedback                     ',
'                                                 ',
' A Widnow popup asking for feedback.             ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$AdvertisingIDItems = @(
'                  Advertising ID                 ',
' Provides more relevant ads, by allows apps to   ',
' access a unique identifier for each user.       ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$CortanaSearchItems = @(
'                  Cortana Search                 ',
' Allows Search using Cortana, Can enable even    ',
' when cortana is disabled by this script.        ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$WAPPushItems = @(
'                    WAP Push                     ',
' WAP push is a type of txt message that contains ',
' a direct link to a particular Web page.         ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

  ##########
  # Privacy Menu -End
  ##########
  
  ##########
  # Windows Update Menu -Start
  ##########

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

$CheckForWinUpdateItems = @(
'            Check For Windows Update             ',
'                                                 ',
' Ability to check for Windows Updates.           ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$WinUpdateDownloadItems = @(
'             Windows Update Download             ',
' How Windows gets updates to you, other than     ',
' from Windows update servers.                    ',
'0. Skip                                          ',
'1. P2P* (Get update from other peers)            ',
'2. Local Only (If another computer has update)   ',
'3. Disable (Only get from Windows Offical Server)',
'C. Cancel (Keeps Current Setting)                '
)

$UpdateDriverItems = @(
'                  Update Driver                  ',
'                                                 ',
' If Windows updates installed Drivers.           ',
'0. Skip                                          ',
'1. Enable                                        ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$AppAutoDownloadItems = @(
'                App Auto Download                ',
'                                                 ',
' Apps that get Installed without your permission.',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$WinUpdateTypeItems = @(
'               Windows Update Type               ',
' How Windows checks for Updates.                 ',
' Note: May not work with Windows Home.           ',
'0. Skip                                          ',
'1. Notify Only                                   ',
'2. Auto Download (Manual Install)                ',
'3. Auto Download/Install*                        ',
'4. Local Admin Choses                            ',
'C. Cancel (Keeps Current Setting)                '
)

$UpdateMSRTItems = @(
'    Update of Malicious Software Removal Tool    ',
' Tool checks your for certin malicious software  ',
' and helps to removes them if found.             ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$RestartOnUpdateItems = @(
'          Restart After Windows Update           ',
' If the computer will restart on its own after   ',
' an update is installed and restart is needed.   ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

  ##########
  # Windows Update Menu -End
  ##########
 
  ##########
  # Service Tweaks Menu -Start
  ##########

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

$UACItems = @(
'               User Agent Control                ',
' Help prevent unauthorized changes to your system',
' by asking for comfirmation when using some apps.',
'0. Skip                                          ',
'1. Never Notify                                  ',
'2. Normal*                                       ',
'3. Always Notify                                 ',
'C. Cancel (Keeps Current Setting)                '
)

$AdminSharesItems = @(
'                  Admin Shares                   ',
'                                                 ',
' The default(Hidden) Shared folders              ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$WinDefenderItems = @(
'                Windows Defender                 ',
' Windows Defender protected against spyware, it  ',
' includs a number of real-time security agents   ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$RemoteAssistanceItems = @(
'                Remote Assistance                ',
' A temporarily view or control a remote Windows  ',
' computer over a network or the Internet.        ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$SharingMappedDrivesItems = @(
'              Sharing Mapped Drives              ',
' Allow mapped drives to be shared with other     ',
' users on the computer.                          ',
'0. Skip                                          ',
'1. Enable                                        ',
'2. Disable*                                      ',
'C. Cancel (Keeps Current Setting)                '
)

$FirewallItems = @(
'                    Firewall                     ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$HomeGroupsItems = @(
'                   Home Groups                   ',
' Homegroup is a group of PCs on a home network   ',
' that can share files and printers.              ',
'                                                 ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$RemoteDesktopItems = @(
'                 Remote Desktop                  ',
' System feature that allows a user to connect to ',
' a computer in another location.                 ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

  ##########
  # Service Tweaks Menu -End
  ##########
  
  ##########
  # Context Menu -Start
  ##########

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

$CastToDeviceItems = @(
'           Cast to Device Context Menu           ',
'                                                 ',
' Context Menu entry for Cast to Device.          ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$IncludeinLibraryItems = @(
'         Include in Library Context Menu         ',
'                                                 ',
' Context Menu entry for Include in Library.      ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$ShareWithItems = @(
'             Share With Context Menu             ',
'                                                 ',
' Context Menu entry for Share With.              ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$PreviousVersionsItems = @(
'          Previous Versions Context Menu         ',
'                                                 ',
' Context Menu entry for Previous Versions.       ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$PinToItems = @(
'               Pin To Context Menu               ',
'                                                 ',
' Context Menu entry for Pin To.                  ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$SendToItems = @(
'               Send To Context Menu              ',
'                                                 ',
' Context Menu entry for Send To.                 ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

  ##########
  # Context Menu -End
  ##########
  
  ##########
  # Start Menu -Start
  ##########

$StartMenuSetMenuItems = @(
'              Start Menu Items Menu              ',
'1. Startmenu Web Search','4. Most Used Apps      ',
'2. App Suggestions     ','5. Recent & Frequent   ',
'3. Unpin Items         ','                       ',
'B. Back to Script Setting Main Menu              '
)

$StartMenuSetMenuItm = (
(1,"StartMenuWebSearch",2),
(2,"StartSuggestions",2),
(3,"UnpinItems",1), #Need to Setup
(4,"MostUsedAppStartMenu",2),
(5,"RecentItemsFrequent",2)
)

$StartMenuWebSearchItems = @(
'              Start Menu Web Search              ',
'                                                 ',
' Using Start menu search to search the web.      ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$StartSuggestionsItems = @(
'                 App Suggestions                 ',
'                                                 ',
' Suggestions of Apps on the start menu.          ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$UnpinItemsItems = @(
'                Unpin Tile Items                 ',
' Unpins Mail, Store, Calendar, Cortana, Photos,  ',
' Edge, Weather, Twitter, Skype, and a few others.',
'0. Skip                                          ',
'1. Unpin                                         ',
'C. Cancel (Keeps Current Setting)                '
)

$MostUsedAppStartMenuItems = @(
'                  Most Used App                  ',
'                                                 ',
' List of Apps you use frequently.                ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$RecentItemsFrequentItems = @(
'         Recent & Frequent in Start Menu         ',
'                                                 ',
' Recent and Frequent items listed in Start Menu. ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

  ##########
  # Start Menu -End
  ##########
  
  ##########
  # Taskbar Menu -Start
  ##########

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
 
$BatteryUIBarItems = @(
'          Battery UI Flyout on Taskbar           ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. New Flyout*                                   ',
'2. Classic Flyout (like the on Win 7 uses)       ',
'C. Cancel (Keeps Current Setting)                '
)

$VolumeControlBarItems = @(
'       Volume Control UI Flyout on Taskbar       ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. New Flyout (Horizontal)*                      ',
'2. Classic Flyout (Vertical)                     ',
'C. Cancel (Keeps Current Setting)                '
)

$TaskViewButtonItems = @(
'           Task View Button on Taskbar           ',
'                                                 ',
' Button  with similar function to Alt+Tab        ',
'0. Skip                                          ',
'1. Show*                                         ',
'2. Hide                                          ',
'C. Cancel (Keeps Current Setting)                '
)

$TaskbarGroupingItems = @(
'           Grouping of Icons on Taskbar          ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Never Group                                   ',
'2. Always Group*                                 ',
'3. When Needed                                   ',
'C. Cancel (Keeps Current Setting)                '
)

$SecondsInClockItems = @(
'           Seconds in Clock on Taskbar           ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Show Seconds                                  ',
'2. Hide Seconds*                                 ',
'C. Cancel (Keeps Current Setting)                '
)

$TaskBarOnMultiDisplayItems = @(
'           Taskbar on Multiple Display           ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Show on all Display*                          ',
'2. Hide on other Display                         ',
'C. Cancel (Keeps Current Setting)                '
)

$ClockUIBarItems = @(
'           Clock UI Flyout on Taskbar            ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. New Flyout*                                   ',
'2. Classic Flyout (like the on Win 7 uses)       ',
'C. Cancel (Keeps Current Setting)                '
)

$TaskbarSearchBoxItems = @(
'              Search box on Taskbar              ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Show*                                         ',
'2. Hide                                          ',
'C. Cancel (Keeps Current Setting)                '
)

$TaskbarIconSizeItems = @(
'                Taskbar Icon Size                ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Normal*                                       ',
'2. Smaller                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$TaskbarIconSizeItems = @(
'                Notifcation Icons                ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Auto Hide*                                    ',
'2. Always Show                                   ',
'C. Cancel (Keeps Current Setting)                '
)

$LastActiveClickItems = @(
'                Last Active Click                ',
' Click/tap on a program taskbar button will make ',
' the last active window or tab active again.     ',
'0. Skip                                          ',
'1. Enable                                        ',
'2. Disable*                                      ',
'C. Cancel (Keeps Current Setting)                '
)

$TaskbarButtOnDisplayItems = @(
'             Taskbar Button Display              ',
'                                                 ',
' Wich Taskbar buttons are displayed.             ',
'0. Skip                                          ',
'1. All Taskbars                                  ',
'2. Where Window is Open                          ',
'3. Main + Where Window is Open                   ',
'C. Cancel (Keeps Current Setting)                '
)

  ##########
  # Taskbar Menu -End
  ##########
  
  ##########
  # Explorer Menu -Start
  ##########
  
$ExplorerSetMenuItems = @(
'               Explorer Items Menu               ',
'1. Frequent Quick Acces','7. Content While Drag  ',
'2. Recent Quick Access ','8. Explorer Open Locat ',
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

$FrequentFoldersQikAccItems = @(
'         Frequent Items in Quick Access          ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Show*                                         ',
'2. Hide                                          ',
'C. Cancel (Keeps Current Setting)                '
)

$RecentFileQikAccItems = @(
'          Recent Items in Quick Access           ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Show*                                         ',
'2. Hide                                          ',
'3. Remove                                        ',
'C. Cancel (Keeps Current Setting)                '
)

$SystemFilesItems = @(
'                  System Files                   ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Show System Files/Folders                     ',
'2. Hide System Files/Folders*                    ',
'C. Cancel (Keeps Current Setting)                '
)

$HiddenFilesItems = @(
'                  Hidden Files                   ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Show Hidden Files/Folders                     ',
'2. Hide Hidden Files/Folders*                    ',
'C. Cancel (Keeps Current Setting)                '
)

$AeroSnapItems = @(
'                    Aero Snap                    ',
' Lets you maximize windows or set them side by   ',
' side by dragging them to the screen edge        ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$AeroShakeItems = @(
'                   Aero Shake                    ',
' Ability to minimize all windows by clicking and ',
' holding down the button while shaking the mouse.',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$WinContentWhileDragItems = @(
'          Windows Content While Dragging         ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Enable                                        ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$ExplorerOpenLocItems = @(
'             Explorer Open Location              ',
' The default open location when you open an      ',
' explorer window.                                ',
'0. Skip                                          ',
'1. Quick Access*                                 ',
"2. 'This PC'                                     ",
'C. Cancel (Keeps Current Setting)                '
)

$KnownExtensionsItems = @(
'              Known File Extensions              ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Show                                          ',
'2. Hide*                                         ',
'C. Cancel (Keeps Current Setting)                '
)

$AutorunItems = @(
'                     Autorun                     ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Enable                                        ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$AutorunItems = @(
'                     Autoplay                    ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Enable                                        ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

  ##########
  # Explorer Menu -End
  ##########
  
  ##########
  # 'This PC' Menu -Start
  ##########

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

$ThisPCOnDesktopItems = @(
"               'This PC' On Desktop              ",
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Show                                          ',
'2. Hide*                                         ',
'C. Cancel (Keeps Current Setting)                '
)

$DocumentsIconInThisPCItems = @(
"           Documents Icon in 'This PC'           ",
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Show                                          ',
'2. Hide*                                         ',
'C. Cancel (Keeps Current Setting)                '
)

$MusicIconInThisPCItems = @(
"             Music Icon in 'This PC'             ",
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Show                                          ',
'2. Hide*                                         ',
'C. Cancel (Keeps Current Setting)                '
)

$VideosIconInThisPCItems = @(
"             Video Icon in 'This PC'             ",
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Show                                          ',
'2. Hide*                                         ',
'C. Cancel (Keeps Current Setting)                '
)

$DesktopIconInThisPCItems = @(
"            Desktop Icon in 'This PC'            ",
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Show                                          ',
'2. Hide*                                         ',
'C. Cancel (Keeps Current Setting)                '
)

$DownloadsIconInThisPCItems = @(
"           Download Icon in 'This PC'            ",
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Show                                          ',
'2. Hide*                                         ',
'C. Cancel (Keeps Current Setting)                '
)

$PicturesIconInThisPCItems = @(
"            Picture Icon in 'This PC'            ",
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Show                                          ',
'2. Hide*                                         ',
'C. Cancel (Keeps Current Setting)                '
)

  ##########
  # 'This PC' Menu -End
  ##########
  
  ##########
  # Lock Screen Menu -Start
  ##########

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

$LockScreenItems = @(
'                   Lock Screen                   ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$LockScreenAltItems = @(
'               Lock Screen Alternate             ',
' This is an Alternate version of disableing the  ',
' Lock Screen for the Anniversary update.         ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$PowerMenuLockScreenItems = @(
'             Power Menu on Lock Screen           ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$CameraOnLockScreenItems = @(
'               Camera on Lock Screen             ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

  ##########
  # Lock Screen Menu -End
  ##########
  
  ##########
  # Misc/Photo Viewer Menu -Start
  ##########

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

$ActionCenterItems = @(
'                  Action Center                  ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$StickyKeyPromptItems = @(
'                Sticky Key Prompt                ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$NumblockOnStartItems = @(
'               Numblock on Startup               ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Enable                                        ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$F8BootMenuItems = @(
'                  F8 Boot Menu                   ',
' Legacy, Advanced options menu (F8) is available ',
' Standard, Menu hows under certain conditions    ',
'0. Skip                                          ',
'1. Legacy                                        ',
'2. Standard*                                     ',
'C. Cancel (Keeps Current Setting)                '
)

$RemoteUACAcctTokenItems = @(
'            Remote UAC Acctount Token            ',
' Affects how credentials are applied to remote   ',
' computer.                                       ',
'0. Skip                                          ',
'1. Enable                                        ',
'2. Disable*                                      ',
'C. Cancel (Keeps Current Setting)                '
)

$HibernatePowerItems = @(
'             Hibernate Power Options             ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Enable                                        ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$SleepPowerItems = @(
'               Sleep Power Options               ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$PVFileAssociationItems = @(
'          Photo Viewer File Association          ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Enable                                        ',
'2. Disable*                                      ',
'C. Cancel (Keeps Current Setting)                '
)

$PVOpenWithMenuItems = @(
'          Photo Viewer Open With Entry           ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Enable                                        ',
'2. Disable*                                      ',
'C. Cancel (Keeps Current Setting)                '
)

  ##########
  # Misc/Photo Viewer Menu -End
  ##########
  
  ##########
  # Features Menu -Start
  ##########

$FeaturesAppsMenuItems = @(
'               Features Items Menu               ',
'1. One Drive           ','4. Media Player        ',
'2. One Drive Install   ','5. Work Folders        ',
'3. Xbox One DVR        ','6. Linux Subsystem     ',
'B. Back to Script Setting Main Menu              '
)

$FeaturesAppsMenuItm = (
(1,"OneDrive",2),
(2,"OneDriveInstall",2),
(3,"XboxDVR",2),
(4,"MediaPlayer",2),
(5,"WorkFolders",2),
(6,"LinuxSubsystem",2)
)

$OneDriveItems = @(
'                    One Drive                    ',
' Does Not remove, Only Enable/Disable.           ',
' Check One Drive Install to Remove.              ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$OneDriveInstallItems = @(
'                One Drive Install                ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Install*                                      ',
'2. Uninstall                                     ',
'C. Cancel (Keeps Current Setting)                '
)

$XboxDVRItems = @(
'                  Xbox One DVR                   ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Enable*                                       ',
'2. Disable                                       ',
'C. Cancel (Keeps Current Setting)                '
)

$MediaPlayerItems = @(
'              Windows Media Player               ',
'                                                 ',
'                                                 ',
'0. Skip                                          ',
'1. Install*                                      ',
'2. Uninstall                                     ',
'C. Cancel (Keeps Current Setting)                '
)

$WorkFoldersItems = @(
'                  Work Folders                   ',
' When using Work Folders to store files, you can ',
' get to them from all your devices—even offline  ',
'0. Skip                                          ',
'1. Install*                                      ',
'2. Uninstall                                     ',
'C. Cancel (Keeps Current Setting)                '
)

$LinuxSubsystemItems = @(
'                 Linux Subsystem                 ',
' A Linux bash you can run from within windows.   ',
' Only available with anniversary update.         ',
'0. Skip                                          ',
'1. Install                                       ',
'2. Uninstall*                                    ',
'C. Cancel (Keeps Current Setting)                '
)

  ##########
  # Features Menu -End
  ##########
  
  ##########
  # Metro Apss Menu -Start
  ##########

$MetroAppsMenuItems = @(
'              Metro Apps Items Menu              ',
'1. ALL METRO APPS      ','12. Microsoft Solitaire',
"2. '3DBuilder' app     ",'13. One Connect        ',
"3. 'Alarms' app        ","14. Office 'OneNote'   ",
"4. 'Calculator' app    ","15. 'People' app       ",
"5. 'Camera' app        ","16. 'Photos' app       ",
'6. Feedback Hub        ',"17. 'Skype' app        ",
"7. 'Get Office' App    ",'18. Sticky Notes       ',
'8. Get Started         ',"19. 'Store' app        ",
"9. 'Groove Music' app  ",'20. Voice Recorder     ',
"10. 'Maps' app         ","21. Bing 'Weather' app ",
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
"11. 'Asphalt 8' Game   ","22. Bing 'Food & Drink'",
"11. Bing 'Money' app   ","22. Bing 'Health & Fit'",
"11. Bing 'News' app    ","22. Bing 'Sports' app  ",
"11. Bing Translator app","22. 'Phone' app        ",
"11. Bing 'Travel' app  ","22. 'Calendar and Mail'",
"11. 'Candy Crush' game ","22. Bing 'Sports' app  ",
"11. 'Facebook' app     ","22. 'Netflix' app      ",
"11. 'Farm Ville' game  ","22. Office 'Sway' app  ",
"11. 'Twitter' app      ","22. 'Phone Companion'  ",
"11. 'Farm Ville' game  ","22. 'Canvas' app       ",
"11. 'Sudoku' game      ","22. 'Minecraft' game   ",

# Apps in list above listed
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
$APP_Facebook = 0          # 'Facebook' app
$APP_Netflix = 0           # 'Netflix' app
$APP_OfficeSway = 0        # 'Sway' app
$APP_Twitter = 0           # 'Twitter' app
$APP_WindowsPhone = 0      # 'Phone Companion' app
$APP_FarmVille = 0         # 'Farm Ville' game
$APP_FreshPaint = 0        # 'Canvas' app
$APP_MicrosoftSudoku = 0   # 'Sudoku' game 
$APP_MinecraftUWP = 0      # 'Minecraft' game 


# Apps not listed
$APP_AdvertisingXaml = 0   ## Removal may cause problem with some apps
$APP_Appconnector = 0      ## Not sure about this one
$APP_ConnectivityStore = 0  
$APP_MicrosoftJackpot = 0  # 'Jackpot' app
$APP_MicrosoftJigsaw = 0   # 'Jigsaw' game       
$APP_MicrosoftMahjong = 0  # 'Mahjong' game 
$APP_MovieMoments = 0        
$APP_StudiosWordament = 0  # 'Wordament' game
$APP_Taptiles = 0   
#> 

  ##########
  # Metro Apss Menu -End
  ##########

##########
# Script Settings Sub Menu -End
##########

##########
# Needed Variable -Start
##########

# Define HKCR
If (!(Test-Path "HKCR:")) {
     New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
}

# Define HKU
If (!(Test-Path "HKU:")) {
     New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS | Out-Null
}

$AppsList = @(
    'Microsoft.3DBuilder',
    'Microsoft.Advertising.Xaml',
    'Microsoft.Appconnector',
    'GAMELOFTSA.Asphalt8Airborne',
    'Microsoft.BingFinance',
    'Microsoft.BingFoodAndDrink',
    'Microsoft.BingHealthAndFitness',
    'Microsoft.BingNews',
    'Microsoft.BingSports',
    'Microsoft.BingTranslator',
    'Microsoft.BingTravel',
    'Microsoft.BingWeather',
    'king.com.CandyCrushSodaSaga',
    'Microsoft.CommsPhone',
    'Microsoft.windowscommunicationsapps',
    'Microsoft.ConnectivityStore',
    'Facebook.Facebook',
    'D52A8D61.FarmVille2CountryEscape',
    'Microsoft.FreshPaint',
    'Microsoft.Getstarted',
    'Microsoft.Messaging',
    'Microsoft.MicrosoftJackpot',
    'Microsoft.MicrosoftJigsaw',          
    'MicrosoftMahjong',
    'Microsoft.MicrosoftOfficeHub',
    'Microsoft.MicrosoftSudoku',
    'Microsoft.MinecraftUWP',   
    'Microsoft.MovieMoments',
    '4DF9E0F8.Netflix',
    'Microsoft.Office.OneNote',
    'Microsoft.Office.Sway',
    'Microsoft.OneConnect',
    'Microsoft.People',
    'Microsoft.Windows.Photos',
    'Microsoft.SkypeApp',
    'Microsoft.SkypeWiFi',
    'Microsoft.MicrosoftSolitaireCollection',
    'Microsoft.WindowsSoundRecorder',
    'Microsoft.MicrosoftStickyNotes',
    'Microsoft.Studios.Wordament',
    'Microsoft.Taptiles',
    '9E2F88E3.Twitter',
    'Microsoft.WindowsAlarms',
    'Microsoft.WindowsCalculator',
    'Microsoft.WindowsCamera',
    'Microsoft.WindowsFeedback',
    'Microsoft.WindowsFeedbackHub',
    'Microsoft.WindowsMaps',
    'Microsoft.WindowsPhone',
    'Microsoft.WindowsStore',
    'Microsoft.XboxApp',
    'Microsoft.ZuneMusic',
    'Microsoft.ZuneVideo'
)

# predefined Color Array
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

$CustomSet = 0

# Used to get all values BEFORE any defined so
# when exporting shows ALL defined after this point
$AutomaticVariables = Get-Variable

##########
# Needed Variable -End
##########

##########
# Pre-Made Settings -Start
##########

# Windows Default Setting
Function LoadWinDefault {
    $WinUpdateType = 3
    $RecentFileQikAcc = 1
    $FrequentFoldersQikAcc = 1
    $MostUsedAppStartMenu = 1
    $PowerMenuLockScreen = 1
    $WinContentWhileDrag = 1
    $CheckForWinUpdate = 1
    $TaskBarOnMultiDisplay = 1
    $TaskbarButtOnDisplay = 0
    $Telemetry = 1
    $WiFiSense = 1
    $SmartScreen = 1
    $StartMenuWebSearch = 1
    $StartSuggestions = 1
    $AppAutoDownload = 1
    $LocationTracking = 1
    $Feedback = 1
    $AdvertisingID = 1
    $Cortana = 1
    $CortanaSearch = 1
    $ErrorReporting = 1
    $WinUpdateDownload = 1
    $AutoLoggerFile = 1
    $DiagTrack = 1
    $WAPPush = 1
    $UAC = 2
    $SharingMappedDrives = 2
    $AdminShares = 1
    $Firewall = 1
    $WinDefender = 1
    $HomeGroups = 1
    $RemoteAssistance = 1
    $RemoteDesktop = 2
    $UpdateMSRT = 1
    $UpdateDriver = 1
    $RestartOnUpdate = 1
    $CastToDevice = 1 
    $PreviousVersions = 1
    $IncludeinLibrary = 1
    $PinTo = 1
    $ShareWith = 1
    $SendTo = 1
    $BatteryUIBar = 1
    $ClockUIBar = 1
    $VolumeControlBar = 1
    $TaskbarSearchBox = 1
    $TaskViewButton = 1
    $TaskbarIconSize = 1
    $TaskbarGrouping = 2
    $TrayIcons = 1
    $SecondsInClock = 2
    $LastActiveClick = 2
    $MoreColorsTitle = 2
    $PidInTitleBar = 2
    $AeroSnap = 1
    $AeroShake = 1
    $KnownExtensions = 2
    $HiddenFiles = 2
    $SystemFiles = 2
    $ThisPCOnDesktop = 2
    $ExplorerOpenLoc = 1
    $RecentItemsFrequent = 1
    $DesktopIconInThisPC = 1
    $DocumentsIconInThisPC = 1
    $DownloadsIconInThisPC = 1
    $MusicIconInThisPC = 1
    $PicturesIconInThisPC = 1
    $VideosIconInThisPC = 1
    $PVFileAssociation = 2
    $PVOpenWithMenu = 2
    $CameraOnLockScreen = 1
    $LockScreen = 1
    $LockScreenAlt = 1
    $ActionCenter = 1
    $Autoplay = 1
    $Autorun = 1
    $StickyKeyPrompt = 1
    $NumblockOnStart = 2
    $F8BootMenu = 1
    $OneDrive = 1
    $XboxDVR = 1
    $MediaPlayer = 1
    $WorkFolders = 1
    $LinuxSubsystem = 2
    $RemoteUACAcctToken = 2
}

##########
# Pre-Made Settings -End
##########

##########
# Script -Start
##########

Function RunScript {

    If ($CreateRestorePoint -eq 1) {
        DisplayOut "Creating System Restore Point Named -Win10 Initial Setup Script..." 15 1
        Checkpoint-Computer -Description "Win10 Initial Setup Script" | Out-Null
    }

    ##########
    # Privacy Settings -Start
    ##########
    
    DisplayOut ""
    DisplayOut "------------------------" 14 0
    DisplayOut "-   Privacy Settings   -" 14 0
    DisplayOut "------------------------" 14 0
    DisplayOut ""
    
    # Telemetry
    If ($Telemetry -eq 1) {
        DisplayOut "Enabling Telemetry..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 3
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 3
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 3
    } ElseIf ($Telemetry -eq 2) {
        DisplayOut "Disabling Telemetry..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
    
	    #check these paths for telemetry
    <#    
    "hkey_local_machine\software\microsoft\wcmsvc\wifinetworkmanager"
    "hkey_local_machine\software\microsoft\windows\currentversion\windowsupdate\auto update"
    "hkey_local_machine\software\microsoft\windows defender\spynet"
    "hkey_local_machine\software\policies\microsoft\windows\gwx"
    "hkey_local_machine\software\policies\microsoft\windows\skydrive"
    #>
    }

    # Wi-Fi Sense
    If ($WiFiSense -eq 1) {
        DisplayOut "Enabling Wi-Fi Sense..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Name "Value" -Type DWord -Value 1
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" -Name "Value" -Type DWord -Value 1
    } ElseIf ($WiFiSense -eq 2) {
        DisplayOut "Disabling Wi-Fi Sense..." 12 0
        If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting")) {
            New-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Force | Out-Null
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Name "Value" -Type DWord -Value 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" -Name "Value" -Type DWord -Value 0
    }
    
    # SmartScreen Filter
    If ($SmartScreen -eq 1) {
        DisplayOut "Enabling SmartScreen Filter..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Type String -Value "RequireAdmin"
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" -Name "EnableWebContentEvaluation" -ErrorAction SilentlyContinue
    } ElseIf ($SmartScreen -eq 2) {
        DisplayOut "Disabling SmartScreen Filter..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Type String -Value "Off"
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" -Name "EnableWebContentEvaluation" -Type DWord -Value 0
    }    
    
    # Location Tracking
    If ($LocationTracking -eq 1) {
        DisplayOut "Enabling Location Tracking..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value 1
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Type DWord -Value 1
    } ElseIf ($LocationTracking -eq 2) {
        DisplayOut "Disabling Location Tracking..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value 0
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Type DWord -Value 0
    }
    
    # Disable Feedback
    If ($LocationTracking -eq 1) {
        DisplayOut "Enabling Feedback..." 11 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -ErrorAction SilentlyContinue
    } ElseIf ($LocationTracking -eq 2) {
        DisplayOut "Disabling Feedback..." 12 0
        If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules")) {
            New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Force | Out-Null
        }
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Type DWord -Value 0
    }
    
    # Disable Advertising ID
    If ($AdvertisingID -eq 1) {
        DisplayOut "Enabling Advertising ID..." 11 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -ErrorAction SilentlyContinue
    } ElseIf ($AdvertisingID -eq 2) {
        DisplayOut "Disabling Advertising ID..." 12 0
        If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo")) {
            New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" | Out-Null
        }
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Type DWord -Value 0
    }
    
    # Cortana
    If ($Cortana -eq 1) {
        DisplayOut "Enabling Cortana..." 11 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Type DWord -Value 0 -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Type DWord -Value 0 -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -Name "HarvestContacts" -ErrorAction SilentlyContinue
    } ElseIf ($Cortana -eq 2) {
        DisplayOut "Disabling Cortana..." 12 0
        If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings")) {
            New-Item -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Force | Out-Null
        }
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Type DWord -Value 0
        If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization")) {
            New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Force | Out-Null
        }
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Type DWord -Value 1
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Type DWord -Value 1
        If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore")) {
            New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -Force | Out-Null
        }
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -Name "HarvestContacts" -Type DWord -Value 0
    }
    
    # Cortana Search
    If ($CortanaSearch -eq 1) {
        DisplayOut "Enabling Cortana Search..." 11 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -ErrorAction SilentlyContinue
    } ElseIf ($CortanaSearch -eq 2) {
        DisplayOut "Disabling Cortana Search..." 12 0
        If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Type DWord -Value 0
    }
    
    # Error Reporting
    If ($ErrorReporting -eq 1) {
        DisplayOut "Enabling Error reporting..." 11 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -ErrorAction SilentlyContinue
    } ElseIf ($ErrorReporting -eq 2) {
        DisplayOut "Disabling Error reporting..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Type DWord -Value 1
    }
    
    # AutoLogger file and restrict directory
    If ($AutoLoggerFile -eq 1) {
        DisplayOut "Unrestricting AutoLogger directory..." 11 0
        $autoLoggerDir = "$env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
        icacls $autoLoggerDir /grant:r SYSTEM:`(OI`)`(CI`)F | Out-Null
    } ElseIf ($AutoLoggerFile -eq 2) {
        DisplayOut "Removing AutoLogger file and restricting directory..." 12 0
        $autoLoggerDir = "$env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
        If (Test-Path "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl") {
            Remove-Item "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl"
        }
        icacls $autoLoggerDir /deny SYSTEM:`(OI`)`(CI`)F | Out-Null
    }
    
    # Diagnostics Tracking Service
    If ($DiagTrack -eq 1) {
        DisplayOut "Enabling and starting Diagnostics Tracking Service..." 11 0
        Set-Service "DiagTrack" -StartupType Automatic
        Start-Service "DiagTrack"
    } ElseIf ($DiagTrack -eq 2) {
        DisplayOut "Stopping and disabling Diagnostics Tracking Service..." 12 0
        Stop-Service "DiagTrack"
        Set-Service "DiagTrack" -StartupType Disabled
    }
    
    # WAP Push Service
    If ($WAPPush -eq 1) {
        DisplayOut "Enabling and starting WAP Push Service..." 11 0
        Set-Service "dmwappushservice" -StartupType Automatic
        Start-Service "dmwappushservice"
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\dmwappushservice" -Name "DelayedAutoStart" -Type DWord -Value 1
    } ElseIf ($WAPPush -eq 1) {
        DisplayOut "Disabling WAP Push Service..." 12 0
        Stop-Service "dmwappushservice"
        Set-Service "dmwappushservice" -StartupType Disabled
    }
    
    # App Auto Download
    If ($AppAutoDownload -eq 1) {
        DisplayOut "Enabling App Auto Download..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate" -Name "AutoDownload" -Type DWord -Value 0
        Remove-ItemProperty  -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures"  -ErrorAction SilentlyContinue
    } ElseIf ($AppAutoDownload -eq 2) {
        DisplayOut "Disabling App Auto Download..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate" -Name "AutoDownload" -Type DWord -Value 2
        If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force | Out-Null
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" -Type DWord -Value 1
    }
    
    ##########
    # Privacy Settings -End
    ##########
    
    ##########
    # Windows Update -Start
    ##########
    
    DisplayOut ""
    DisplayOut "-------------------------------" 14 0
    DisplayOut "-   Windows Update Settings   -" 14 0
    DisplayOut "-------------------------------" 14 0
    DisplayOut ""
    
    # Check for Windows Update
    If ($CheckForWinUpdate -eq 1) {
        DisplayOut "Enabling Check for Windows Update..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "SetDisableUXWUAccess" -Type DWord -Value 0
    } ElseIf ($CheckForWinUpdate -eq 2) {
        DisplayOut "Disabling Check for Windows Update..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "SetDisableUXWUAccess" -Type DWord -Value 1
    }
    
    # Windows Update Check Type
    If ($WinUpdateType -ge 1 -and $WinUpdateType -le 4) {
        If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" | Out-Null
        }
        If ($WinUpdateType -eq 1){
            DisplayOut "Notify for windows update download and notify for install..." 16 0
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUOptions" -Type DWord -Value 2
        } ElseIf ($WinUpdateType -eq 2){
            DisplayOut "Auto Download for windows update download and notify for install..." 16 0
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUOptions" -Type DWord -Value 3
        } ElseIf ($WinUpdateType -eq 3){
            DisplayOut "Auto Download for windows update download and schedule for install..." 16 0
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUOptions" -Type DWord -Value 4
        } ElseIf ($WinUpdateType -eq 4){
            DisplayOut "Windows update allow local admin to choose setting..." 16 0
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUOptions" -Type DWord -Value 5
        }
    }
    
    # Windows Update P2P
    If ($WinUpdateDownload -eq 1) {
        DisplayOut "Unrestricting Windows Update P2P to internet..." 16 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name "DODownloadMode" -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" -Name "SystemSettingsDownloadMode" -ErrorAction SilentlyContinue
    } ElseIf ($WinUpdateDownload -eq 2) {
        DisplayOut "Restricting Windows Update P2P only to local network..." 16 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name "DODownloadMode" -Type DWord -Value 1
        If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization")) {
            New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" | Out-Null
        }
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" -Name "SystemSettingsDownloadMode" -Type DWord -Value 3
    } ElseIf ($WinUpdateDownload -eq 3) {
        DisplayOut "Disabling Windows Update P2P..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name "DODownloadMode" -Type DWord -Value 0
        If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization")) {
            New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" | Out-Null
        }
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" -Name "SystemSettingsDownloadMode" -Type DWord -Value 3
    }
    
    ##########
    # Windows Update -End
    ##########
    
    ##########
    # Service Tweaks -Start
    ##########
    
    DisplayOut ""
    DisplayOut "----------------------" 14 0
    DisplayOut "-   Service Tweaks   -" 14 0
    DisplayOut "----------------------" 14 0
    DisplayOut ""
    
    
    # UAC level
    If ($UAC -eq 1) {
        DisplayOut "Lowering UAC level..." 16 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Type DWord -Value 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "PromptOnSecureDesktop" -Type DWord -Value 0
    } ElseIf ($UAC -eq 2) {
        DisplayOut "Default UAC level..." 16 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Type DWord -Value 5
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "PromptOnSecureDesktop" -Type DWord -Value 1
    } ElseIf ($UAC -eq 3) {
        DisplayOut "Raising UAC level..." 16 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Type DWord -Value 2
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "PromptOnSecureDesktop" -Type DWord -Value 1
    }
    
    # Sharing mapped drives between users
    If ($SharingMappedDrives -eq 1) {
        DisplayOut "Enabling sharing mapped drives between users..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLinkedConnections" -Type DWord -Value 1
    } ElseIf ($SharingMappedDrives -eq 2) {
        DisplayOut "Disabling sharing mapped drives between users..." 12 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLinkedConnections" -ErrorAction SilentlyContinue
    }
    
    # Administrative shares
    If ($AdminShares -eq 1) {
        DisplayOut "Enabling implicit administrative shares..." 11 0
        Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "AutoShareWks" -ErrorAction SilentlyContinue
    } ElseIf ($AdminShares -eq 2) {
        DisplayOut "Disabling implicit administrative shares..." 12 0
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "AutoShareWks" -Type DWord -Value 0
    }
    
    # Firewall
    If ($Firewall -eq 1) {
        DisplayOut "Enabling Firewall..." 11 0
        Set-NetFirewallProfile -Profile * -Enabled True
    } ElseIf ($Firewall -eq 2) {
        DisplayOut "Disabling Firewall..." 12 0
        Set-NetFirewallProfile -Profile * -Enabled False
    }
    
    # Windows Defender
    If ($WinDefender -eq 1) {
        DisplayOut "Enabling Windows Defender..." 11 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "WindowsDefender" -Type ExpandString -Value "`"%ProgramFiles%\Windows Defender\MSASCuiL.exe`""
    } ElseIf ($WinDefender -eq 2) {
        DisplayOut "Disabling Windows Defender..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Type DWord -Value 1
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "WindowsDefender" -ErrorAction SilentlyContinue
    }
    
    # Home Groups services
    If ($HomeGroups -eq 1) {
        DisplayOut "Enabling  Home Groups services..." 11 0
        Set-Service "HomeGroupListener" -StartupType Manual
        Set-Service "HomeGroupProvider" -StartupType Manual
        Start-Service "HomeGroupProvider"
    } ElseIf ($HomeGroups -eq 2) {
         DisplayOut "Disabling Home Groups services..." 12 0
        Stop-Service "HomeGroupListener"
        Set-Service "HomeGroupListener" -StartupType Disabled
        Stop-Service "HomeGroupProvider"
        Set-Service "HomeGroupProvider" -StartupType Disabled
    }
    
    # Remote Assistance
    If ($RemoteAssistance -eq 1) {
        DisplayOut "Enabling Remote Assistance..." 11 0
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Type DWord -Value 1
    } ElseIf ($RemoteAssistance -eq 2) {
        DisplayOut "Disabling Remote Assistance..." 12 0
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Type DWord -Value 0
    }
    
    # Enable Remote Desktop w/o Network Level Authentication
    If ($RemoteDesktop -eq 1) {
        DisplayOut "Enabling Remote Desktop w/o Network Level Authentication..." 11 0
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Type DWord -Value 0
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication" -Type DWord -Value 0
    } ElseIf ($RemoteDesktop -eq 2) {
        DisplayOut "Disabling Remote Desktop..." 12 0
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Type DWord -Value 1
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication" -Type DWord -Value 1
    }
    
    ##########
    # Service Tweaks -End
    ##########
    
    ##########
    # Context Menu Items -Start
    ##########
    
    DisplayOut ""
    DisplayOut "--------------------------" 14 0
    DisplayOut "-   Context Menu Items   -" 14 0
    DisplayOut "--------------------------" 14 0
    DisplayOut ""
    
    # Cast to Device Context
    If ($CastToDevice -eq 1) {
        DisplayOut "Enabling Cast to Device Context item..." 11 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{7AD84985-87B4-4a16-BE58-8B72A5B390F7}" -ErrorAction SilentlyContinue
    } ElseIf ($CastToDevice -eq 2) {
        DisplayOut "Disabling Cast to Device Context item..." 12 0
        If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked")) {
            New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" | Out-Null
        }
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{7AD84985-87B4-4a16-BE58-8B72A5B390F7}" -ErrorAction SilentlyContinue
    }
    
    # Previous Versions Context Menu
    If ($PreviousVersions -eq 1) {
        DisplayOut "Enabling Previous Versions Context item..." 11 0
        Set-ItemProperty -Path "HKCR:\ApplicationsAllFilesystemObjects\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Force | Out-Null
        Set-ItemProperty -Path "HKCR:\ApplicationsCLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Force | Out-Null
        Set-ItemProperty -Path "HKCR:\ApplicationsDirectory\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Force | Out-Null
        Set-ItemProperty -Path "HKCR:\ApplicationsDrive\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Force | Out-Null
    } ElseIf ($PreviousVersions -eq 2) {
        DisplayOut "Disabling Previous Versions Context item..." 12 0
        Remove-Item -Path "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Recurse -ErrorAction SilentlyContinue
        Remove-Item -Path "HKCR:\CLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Recurse -ErrorAction SilentlyContinue
        Remove-Item -Path "HKCR:\Directory\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Recurse -ErrorAction SilentlyContinue
        Remove-Item -Path "HKCR:\Drive\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Recurse -ErrorAction SilentlyContinue
    }
    
    # Include in Library Context Menu
    If ($IncludeinLibrary -eq 1) {
        DisplayOut "Enabling Include in Library Context item..." 11 0
        Set-ItemProperty -Path "HKCR:\Folder\ShellEx\ContextMenuHandlers\Library Location" -Name "(Default)" -Type String -Value "{3dad6c5d-2167-4cae-9914-f99e41c12cfa}"
    } ElseIf ($IncludeinLibrary -eq 2) {
        DisplayOut "Disabling Include in Library..." 12 0
        Set-ItemProperty -Path "HKCR:\Folder\ShellEx\ContextMenuHandlers\Library Location" -Name "(Default)" -Type String -Value ""
    }
    
    # Pin To Context Menu
    If ($PinTo -eq 1) {
        DisplayOut "Enabling Pin To Context item..." 11 0
        New-Item -Path "HKCR:\*\shellex\ContextMenuHandlers\{90AA3A4E-1CBA-4233-B8BB-535773D48449}" -Force | Out-Null
        Set-ItemProperty -LiteralPath "HKCR:\*\shellex\ContextMenuHandlers\{90AA3A4E-1CBA-4233-B8BB-535773D48449}" -Name "(Default)" -Type String -Value "Taskband Pin"
        New-Item -Path "HKCR:\*\shellex\ContextMenuHandlers\{a2a9545d-a0c2-42b4-9708-a0b2badd77c8}" -Force | Out-Null
        Set-ItemProperty -LiteralPath "HKCR:\*\shellex\ContextMenuHandlers\{a2a9545d-a0c2-42b4-9708-a0b2badd77c8}" -Name "(Default)" -Type String -Value "Start Menu Pin"
        Set-ItemProperty -Path "HKCR:\Folder\shellex\ContextMenuHandlers\PintoStartScreen" -Name "(Default)" -Type String -Value "{470C0EBD-5D73-4d58-9CED-E91E22E23282}"
        Set-ItemProperty -Path "HKCR:\exefile\shellex\ContextMenuHandlers\PintoStartScreen" -Name "(Default)" -Type String -Value "{470C0EBD-5D73-4d58-9CED-E91E22E23282}"
        Set-ItemProperty -Path "HKCR:\Microsoft.Website\shellex\ContextMenuHandlers\PintoStartScreen" -Name "(Default)" -Type String -Value "{470C0EBD-5D73-4d58-9CED-E91E22E23282}"
        Set-ItemProperty -Path "HKCR:\mscfile\shellex\ContextMenuHandlers\PintoStartScreen" -Name "(Default)" -Type String -Value "{470C0EBD-5D73-4d58-9CED-E91E22E23282}"
    } ElseIf ($PinTo -eq 2) {
        DisplayOut "Disabling Pin To Context item..." 12 0
        Remove-Item -LiteralPath "HKCR:\*\shellex\ContextMenuHandlers\{90AA3A4E-1CBA-4233-B8BB-535773D48449}" -ErrorAction SilentlyContinue -Force
        Remove-Item -LiteralPath "HKCR:\*\shellex\ContextMenuHandlers\{a2a9545d-a0c2-42b4-9708-a0b2badd77c8}" -ErrorAction SilentlyContinue -Force
        Set-ItemProperty -Path "HKCR:\Folder\shellex\ContextMenuHandlers\PintoStartScreen" -Name "(Default)" -Type String -Value ""
        Set-ItemProperty -Path "HKCR:\exefile\shellex\ContextMenuHandlers\PintoStartScreen" -Name "(Default)" -Type String -Value ""
        Set-ItemProperty -Path "HKCR:\Microsoft.Website\shellex\ContextMenuHandlers\PintoStartScreen" -Name "(Default)" -Type String -Value ""
        Set-ItemProperty -Path "HKCR:\mscfile\shellex\ContextMenuHandlers\PintoStartScreen" -Name "(Default)" -Type String -Value ""
    }
    
    # Share With Context Menu
    If ($ShareWith -eq 1) {
        DisplayOut "Enabling Share With Context item..." 11 0
        Set-ItemProperty -LiteralPath "HKCR:\*\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}" 
        Set-ItemProperty -Path "HKCR:\Directory\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}"
        Set-ItemProperty -Path "HKCR:\Directory\shellex\CopyHookHandlers\Sharing" -Name "(Default)" -Type String -Value "{40dd6e20-7c17-11ce-a804-00aa003ca9f6}"
        Set-ItemProperty -Path "HKCR:\Directory\shellex\PropertySheetHandlers\Sharing" -Name "(Default)" -Type String -Value "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}"
        Set-ItemProperty -Path "HKCR:\Directory\Background\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}"
        Set-ItemProperty -Path "HKCR:\Drive\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}"
        Set-ItemProperty -Path "HKCR:\LibraryFolder\background\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}"
    }  ElseIf ($ShareWith -eq 2) {
        DisplayOut "Disabling Share With..." 12 0
        Set-ItemProperty -LiteralPath "HKCR:\*\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value "" 
        Set-ItemProperty -Path "HKCR:\Directory\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value ""
        Set-ItemProperty -Path "HKCR:\Directory\shellex\CopyHookHandlers\Sharing" -Name "(Default)" -Type String -Value ""
        Set-ItemProperty -Path "HKCR:\Directory\shellex\PropertySheetHandlers\Sharing" -Name "(Default)" -Type String -Value ""
        Set-ItemProperty -Path "HKCR:\Directory\Background\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value ""
        Set-ItemProperty -Path "HKCR:\Drive\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value ""
        Set-ItemProperty -Path "HKCR:\LibraryFolder\background\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value ""
    }
    
    # Send To Context Menu
    If ($SendTo -eq 1) {
        DisplayOut "Enabling Send To Context item..." 11 0
        If (!(Test-Path "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo")) {
            New-Item -Path "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo"
        }
        Set-ItemProperty -Path "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo" -Name "(Default)" -Type String -Value "{7BA4C740-9E81-11CF-99D3-00AA004AE837}" -ErrorAction SilentlyContinue | Out-Null
    } ElseIf ($SendTo -eq 2) {
        DisplayOut "Disabling Send To Context item..." 12 0
        If (Test-Path "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo") {
            Remove-Item -Path "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo" -ErrorAction SilentlyContinue
        }
    }
    
    ##########
    # Context Menu Items -End
    ##########
    
    ##########
    # Task Bar Items -Start
    ##########
    
    DisplayOut ""
    DisplayOut "----------------------" 14 0
    DisplayOut "-   Task Bar Items   -" 14 0
    DisplayOut "----------------------" 14 0
    DisplayOut ""
    
    # Battery UI Bar
    If ($BatteryUIBar -eq 1) {
        DisplayOut "Enabling New Battery UI Bar..." 16 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" -Name "UseWin32BatteryFlyout" -ErrorAction SilentlyContinue
    } ElseIf ($BatteryUIBar -eq 2) {
        DisplayOut "Enabling Old Battery UI Bar..." 16 0
        If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell")) {
            New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" | Out-Null
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" -Name "UseWin32BatteryFlyout" -Type DWord -Value 1
    }
    
    # Clock UI Bar
    If ($ClockUIBar -eq 1) {
        DisplayOut "Enabling New Clock UI Bar..." 16 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" -Name "UseWin32TrayClockExperience" -ErrorAction SilentlyContinue
    } ElseIf ($ClockUIBar -eq 2) {
        DisplayOut "Enabling Old Clock UI Bar..." 16 0
        If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell")) {
            New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" | Out-Null
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" -Name "UseWin32TrayClockExperience" -Type DWord -Value 1
    }
    	 
    # Volume Control Bar
    If ($VolumeControlBar -eq 1) {
        DisplayOut "Enabling New Volume Bar (Horizontal)..." 16 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC" -Name "EnableMtcUvc" -ErrorAction SilentlyContinue
    } ElseIf ($VolumeControlBar -eq 2) {
        DisplayOut "Enabling Classic Volume Bar (Vertical)..." 16 0
        If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC")) {
            New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC" | Out-Null
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC" -Name "EnableMtcUvc" -Type DWord -Value 0
    }
    
    # Taskbar Search button / box
    If ($TaskbarSearchBox -eq 1) {
        DisplayOut "Showing Taskbar Search box / button..." 11 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -ErrorAction SilentlyContinue
    } ElseIf ($TaskbarSearchBox -eq 2) {
        DisplayOut "Hiding Taskbar Search box / button..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 0
    }
    
    # Task View button
    If ($TaskViewButton -eq 1) {
        DisplayOut "Showing Task View button..." 11 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -ErrorAction SilentlyContinue
    } ElseIf ($TaskViewButton -eq 2) {
        DisplayOut "Hiding Task View button..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0
    }
    
    # Taskbar Icon Size
    If ($TaskbarIconSize -eq 1) {
        DisplayOut "Showing Normal icon size in taskbar..." 11 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSmallIcons" -ErrorAction SilentlyContinue
    } ElseIf ($TaskbarIconSize -eq 2) {
        DisplayOut "Showing Smaller icons in taskbar..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSmallIcons" -Type DWord -Value 1
    }
    
    # Taskbar Item Grouping
    If ($TaskbarGrouping -eq 1) {
        DisplayOut "Never Group Taskbar Items..." 16 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarGlomLevel" -Type DWord -Value 2
    } ElseIf ($TaskbarGrouping -eq 2) {
        DisplayOut "Always Group Taskbar Items..." 16 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarGlomLevel" -Type DWord -Value 0
    } ElseIf ($TaskbarGrouping -eq 3) {
        DisplayOut "When Needed Group Taskbar Items..." 16 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarGlomLevel" -Type DWord -Value 1
    }
    
    # Tray icons
    If ($TrayIcons -eq 1) {
        DisplayOut "Showing all tray icons..." 11 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -Type DWord -Value 0
    } ElseIf ($TrayIcons -eq 2) {
        DisplayOut "Hiding tray icons..." 12 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -ErrorAction SilentlyContinue
    }
    
    # Seconds in Taskbar Clock
    If ($SecondsInClock -eq 1) {
        DisplayOut "Showing Seconds in Taskbar Clock..." 16 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSecondsInSystemClock" -Type DWord -Value 1
    } ElseIf ($SecondsInClock -eq 2) {
        DisplayOut "Hiding Seconds in Taskbar Clock..." 16 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSecondsInSystemClock" -Type DWord -Value 0
    }
    
    # Last Active Click
    If ($LastActiveClick -eq 1) {
        DisplayOut "Enabling Last Active Click..." 11 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LastActiveClick" -Type DWord -Value 1
    } ElseIf ($LastActiveClick -eq 2) {
        DisplayOut "Disabling Last Active Click..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LastActiveClick" -Type DWord -Value 0
    }
    
    # Taskbar on multiple displays
    If ($TaskBarOnMultiDisplay -eq 1) {
        DisplayOut "Showing Taskbar on multiple displays..." 11 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "MMTaskbarEnabled" -Type DWord -Value 1
    } ElseIf ($TaskBarOnMultiDisplay -eq 2) {
        DisplayOut "Hiding Taskbar on multiple displays.." 12 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "MMTaskbarEnabled" -Type DWord -Value 0
    }
    
    # Taskbar on multiple displays
    If ($TaskbarButtOnDisplay -eq 1) {
        DisplayOut "Showing Taskbar buttons on all taskbars..." 16 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "MMTaskbarMode" -Type DWord -Value 0
    } ElseIf ($TaskbarButtOnDisplay -eq 2) {
        DisplayOut "Showing Taskbar buttons on taskbar where window is open..." 16 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "MMTaskbarMode" -Type DWord -Value 2
    } ElseIf ($TaskbarButtOnDisplay -eq 3) {
        DisplayOut "Showing Taskbar buttons on main taskbar and where window is open..." 16 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "MMTaskbarMode" -Type DWord -Value 1
    }
    
    ##########
    # Task Bar Items -End
    ##########
    
    ##########
    # Star Menu Items -Start
    ##########
    
    DisplayOut ""
    DisplayOut "-----------------------" 14 0
    DisplayOut "-   Star Menu Items   -" 14 0
    DisplayOut "-----------------------" 14 0
    DisplayOut ""
    
    # Web Search in Start Menu
    If ($StartMenuWebSearch -eq 1) {
        DisplayOut "Enabling Bing Search in Start Menu..." 11 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "DisableWebSearch" -ErrorAction SilentlyContinue
    } ElseIf ($StartMenuWebSearch -eq 2) {
        DisplayOut "Disabling Bing Search in Start Menu..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Type DWord -Value 0
        If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "DisableWebSearch" -Type DWord -Value 1
    }
    
    # Start Menu suggestions
    If ($StartSuggestions -eq 1) {
        DisplayOut "Enabling Start Menu suggestions..." 11 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 1
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Type DWord -Value 1
    } ElseIf ($StartSuggestions -eq 2) {
        DisplayOut "Disabling Start Menu suggestions..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Type DWord -Value 0
    }
    
    # Most used apps in Start menu
    If ($MostUsedAppStartMenu -eq 1) {
        DisplayOut "Showing Most used apps in Start Menu..." 11 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackProgs" -Type DWord -Value 1
    } ElseIf ($MostUsedAppStartMenu -eq 2) {
        DisplayOut "Hiding Most used apps in Start Menu..." 12 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackProgs" -Type DWord -Value 0
    }
    
    # Recent Items and Frequent Places
    If ($RecentItemsFrequent -eq 1) {
        DisplayOut "Enabling Recent Items and Frequent Places..." 11 0
        If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu")) {
            New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" | Out-Null
        }
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Name "Start_TrackDocs" -Type DWord -Value 1
    } ElseIf ($RecentItemsFrequent -eq 2) {
        DisplayOut "Disabling Recent Items and Frequent Places..." 12 0
        If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu")) {
            New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" | Out-Null
        }
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Name "Start_TrackDocs" -Type DWord -Value 0
    }
    
    ##########
    # Star Menu Items -End
    ##########
    
    ##########
    # Explorer Items -Start
    ##########
    
    DisplayOut ""
    DisplayOut "----------------------" 14 0
    DisplayOut "-   Explorer Items   -" 14 0
    DisplayOut "----------------------" 14 0
    DisplayOut ""
    
    # Process ID on Title Bar
    If ($PidInTitleBar -eq 1) {
        DisplayOut "Showing Process ID on Title Bar..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowPidInTitle" -Type DWord -Value 1
    } ElseIf ($PidInTitleBar -eq 2) {
        DisplayOut "Hiding Process ID on Title Bar..." 12 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowPidInTitle" -ErrorAction SilentlyContinue
    }
    
    # Aero Snap
    If ($AeroSnap -eq 1) {
        DisplayOut "Enabling Aero Snap..." 11 0
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WindowArrangementActive" -Type DWord -Value 1
    } ElseIf ($AeroSnap -eq 2) {
        DisplayOut "Disabling Aero Snap..." 12 0
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WindowArrangementActive" -Type DWord -Value 0
    }
    
    # Aero Shake
    If ($AeroShake -eq 1) {
        DisplayOut "Enabling Aero Shake..." 11 0
        Remove-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Name "NoWindowMinimizingShortcuts" -ErrorAction SilentlyContinue
    } ElseIf ($AeroShake -eq 2) {
        DisplayOut "Disabling Aero Shake..." 12 0
        If (!(Test-Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer")) {
            New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" | Out-Null
        }
        Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Name "NoWindowMinimizingShortcuts" -Type DWord -Value 1
    }
    
    # File extensions
    If ($KnownExtensions -eq 1) {
        DisplayOut "Showing known file extensions..." 11 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 0
    } ElseIf ($KnownExtensions -eq 2) {
        DisplayOut "Hiding known file extensions..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 1
    }
    
    # Hidden files
    If ($HiddenFiles -eq 1) {
        DisplayOut "Showing hidden files..." 11 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Type DWord -Value 1
    } ElseIf ($HiddenFiles -eq 2) {
        DisplayOut "Hiding hidden files..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Type DWord -Value 2
    }
    
    # System files
    If ($SystemFiles -eq 1) {
        DisplayOut "Showing System files..." 11 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSuperHidden" -Type DWord -Value 1
    } ElseIf ($SystemFiles -eq 2) {
        DisplayOut "Hiding System files..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSuperHidden" -Type DWord -Value 0
    }
    
    # Show This PC shortcut on desktop
    If ($ThisPCOnDesktop -eq 1) {
        DisplayOut "Showing This PC shortcut on desktop..." 11 0
        If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu")) {
            New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" | Out-Null
        }
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Type DWord -Value 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Type DWord -Value 0
    } ElseIf ($ThisPCOnDesktop -eq 2) {
        DisplayOut "Hiding This PC shortcut from desktop..." 12 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -ErrorAction SilentlyContinue
    }
    
    # Change default Explorer view
    If ($ExplorerOpenLoc -eq 1) {
        DisplayOut "Changing default Explorer view to Quick Access..." 16 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -ErrorAction SilentlyContinue
    } ElseIf ($ExplorerOpenLoc -eq 2) {
        DisplayOut "Changing default Explorer view to This PC..." 16 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1
    }
    
    # Recent Files in Quick Access
    If ($RecentFileQikAcc -eq 1) {
        DisplayOut "Showing Recent Files in Quick Access..." 11 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowRecent" -Type DWord -Value 1
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HomeFolderDesktop\NameSpace\DelegateFolders\{3134ef9c-6b18-4996-ad04-ed5912e00eb5}" -Name "(Default)" -Type String -Value "Recent Items Instance Folder"
        If($OSType -eq 64) {
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\HomeFolderDesktop\NameSpace\DelegateFolders\{3134ef9c-6b18-4996-ad04-ed5912e00eb5}" -Name "(Default)" -Type String -Value "Recent Items Instance Folder"
        }
    } ElseIf ($RecentFileQikAcc -eq 2) {
        DisplayOut "Hiding Recent Files in Quick Access..." 12 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowRecent" -Type DWord -Value 0
    } ElseIf ($RecentFileQikAcc -eq 3) {
        DisplayOut "Removeing Recent Files in Quick Access..." 15 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowRecent" -Type DWord -Value 0
        Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HomeFolderDesktop\NameSpace\DelegateFolders\{3134ef9c-6b18-4996-ad04-ed5912e00eb5}" -Recurse -ErrorAction SilentlyContinue
        Remove-Item -Path "HKLM:SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\HomeFolderDesktop\NameSpace\DelegateFolders\{3134ef9c-6b18-4996-ad04-ed5912e00eb5}" -Recurse -ErrorAction SilentlyContinue
    }
    
    # Frequent folders in Quick_access
    If ($FrequentFoldersQikAcc -eq 1) {
        DisplayOut "Showing Frequent folders in Quick Access..." 11 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowFrequent" -Type DWord -Value 1
    } ElseIf ($FrequentFoldersQikAcc -eq 2) {
        DisplayOut "Hiding Frequent folders in Quick Access..." 12 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowFrequent" -Type DWord -Value 0
    }
    
    # Window Content while Dragging
    If ($WinContentWhileDrag -eq 1) {
        DisplayOut "Showing Window Content while Dragging..." 11 0
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "DragFullWindows" -Type DWord -Value 1
    } ElseIf ($WinContentWhileDrag -eq 2) {
        DisplayOut "Hiding Window Content while Dragging..." 12 0
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "DragFullWindows" -Type DWord -Value 0
    }
    
    # Autoplay
    If ($Autoplay -eq 1) {
        DisplayOut "Enabling Autoplay..." 11 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 0
    } ElseIf ($Autoplay -eq 2) {
        DisplayOut "Disabling Autoplay..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 1
    }
    
    # Autorun for all drives
    If ($Autorun -eq 1) {
        DisplayOut "Enabling Autorun for all drives..." 11 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -ErrorAction SilentlyContinue
    } ElseIf ($Autorun -eq 2) {
        DisplayOut "Disabling Autorun for all drives..." 12 0
        If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer")) {
            New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" | Out-Null
        }
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -Type DWord -Value 255
    }
    
    ##########
    # Explorer Items -End
    ##########
    
    ##########
    # 'This PC' items -Start
    ##########
    
    DisplayOut ""
    DisplayOut "-----------------------" 14 0
    DisplayOut "-   'This PC' items   -" 14 0
    DisplayOut "-----------------------" 14 0
    DisplayOut ""
    
    # Desktop icon in This PC
    If ($DesktopIconInThisPC -eq 1) {
        DisplayOut "Showing Desktop icon in This PC..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
    } ElseIf ($DesktopIconInThisPC -eq 2) {
        DisplayOut "Hiding Desktop icon from This PC..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
    }
    
    # Documents icon in This PC
    If ($DocumentsIconInThisPC -eq 1) {
        DisplayOut "Showing Documents icon in This PC..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
    }ElseIf ($DocumentsIconInThisPC -eq 2) {
        DisplayOut "Hiding Documents icon from This PC..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
    }
    
    # Downloads icon from This PC
    If ($DownloadsIconInThisPC -eq 1) {
        DisplayOut "Showing Downloads icon in This PC..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
    } ElseIf ($DownloadsIconInThisPC -eq 2) {
        DisplayOut "Hiding Downloads icon from This PC..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
    }
    
    # Music icon from This PC
    If ($MusicIconInThisPC -eq 1) {
        DisplayOut "Showing Music icon in This PC..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
    } ElseIf ($MusicIconInThisPC -eq 2) {
        DisplayOut "Hiding Music icon from This PC..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
    }
    
    # Pictures icon from This PC
    If ($PicturesIconInThisPC -eq 1) {
        DisplayOut "Showing Pictures icon in This PC..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
    } ElseIf ($PicturesIconInThisPC -eq 2) {
        DisplayOut "Hiding Pictures icon from This PC..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
    }
    
    # Hide Videos icon from This PC
    If ($VideosIconInThisPC -eq 1) {
        DisplayOut "Showing Videos icon in This PC..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
    } ElseIf ($VideosIconInThisPC -eq 2) {
        DisplayOut "Hiding Videos icon from This PC..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
    }
    
    ##########
    # 'This PC' items -End
    ##########
    
    ##########
    # Photo Viewer Settings -Start
    ##########
    
    DisplayOut ""
    DisplayOut "-----------------------------" 14 0
    DisplayOut "-   Photo Viewer Settings   -" 14 0
    DisplayOut "-----------------------------" 14 0
    DisplayOut ""
    
    # Photo Viewer association for bmp, gif, jpg, png and tif
    If ($PVFileAssociation -eq 1) {
        DisplayOut "Setting Photo Viewer association for bmp, gif, jpg, png and tif..." 11 0
        ForEach ($type in @("Paint.Picture", "giffile", "jpegfile", "pngfile")) {
            New-Item -Path $("HKCR:\$type\shell\open") -Force | Out-Null
            New-Item -Path $("HKCR:\$type\shell\open\command") | Out-Null
            Set-ItemProperty -Path $("HKCR:\$type\shell\open") -Name "MuiVerb" -Type ExpandString -Value "@%ProgramFiles%\Windows Photo Viewer\photoviewer.dll,-3043"
            Set-ItemProperty -Path $("HKCR:\$type\shell\open\command") -Name "(Default)" -Type ExpandString -Value "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1"
        }
    } ElseIf ($PVFileAssociation -eq 2) {
        DisplayOut "Unsetting Photo Viewer association for bmp, gif, jpg, png and tif..." 12 0
        If (Test-Path "HKCR:\Paint.Picture\shell\open") {
            Remove-Item -Path "HKCR:\Paint.Picture\shell\open" -Recurse
        }
        Remove-ItemProperty -Path "HKCR:\giffile\shell\open" -Name "MuiVerb" -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKCR:\giffile\shell\open" -Name "CommandId" -Type String -Value "IE.File"
        Set-ItemProperty -Path "HKCR:\giffile\shell\open\command" -Name "(Default)" -Type String -Value "`"$env:SystemDrive\Program Files\Internet Explorer\iexplore.exe`" %1"
        Set-ItemProperty -Path "HKCR:\giffile\shell\open\command" -Name "DelegateExecute" -Type String -Value "{17FE9752-0B5A-4665-84CD-569794602F5C}"
        If (Test-Path "HKCR:\jpegfile\shell\open") { 
            Remove-Item -Path "HKCR:\jpegfile\shell\open" -Recurse
        }
        If (Test-Path "HKCR:\jpegfile\shell\open") { 
            Remove-Item -Path "HKCR:\pngfile\shell\open" -Recurse
        }
    } 
    
    # Add Photo Viewer to "Open with..."
    If ($PVOpenWithMenu -eq 1) {
        DisplayOut "Adding Photo Viewer to Open with Menu..." 11 0
        New-Item -Path "HKCR:\Applications\photoviewer.dll\shell\open\command" -Force | Out-Null
        New-Item -Path "HKCR:\Applications\photoviewer.dll\shell\open\DropTarget" -Force | Out-Null
        Set-ItemProperty -Path "HKCR:\Applications\photoviewer.dll\shell\open" -Name "MuiVerb" -Type String -Value "@photoviewer.dll,-3043"
        Set-ItemProperty -Path "HKCR:\Applications\photoviewer.dll\shell\open\command" -Name "(Default)" -Type ExpandString -Value "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1"
        Set-ItemProperty -Path "HKCR:\Applications\photoviewer.dll\shell\open\DropTarget" -Name "Clsid" -Type String -Value "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"
    } ElseIf ($PVOpenWithMenu -eq 2) {
        DisplayOut "Removing Photo Viewer from Open with Menu..." 12 0
        If (Test-Path "HKCR:\Applications\photoviewer.dll\shell\open") {
            Remove-Item -Path "HKCR:\Applications\photoviewer.dll\shell\open" -Recurse
        }
    }
    
    ##########
    # Photo Viewer Settings -End
    ##########
    
    ##########
    # Lockscreen Items -Start
    ##########
    
    DisplayOut ""
    DisplayOut "------------------------" 14 0
    DisplayOut "-   Lockscreen Items   -" 14 0
    DisplayOut "------------------------" 14 0
    DisplayOut ""
    
    # Lock screen
    If ($LockScreen -eq 1) {
        DisplayOut "Enabling Lock screen..." 11 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "NoLockScreen" -ErrorAction SilentlyContinue
    } ElseIf ($LockScreen -eq 2) {
        DisplayOut "Disabling Lock screen..." 12 0
        If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" | Out-Null
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "NoLockScreen" -Type DWord -Value 1
    } 
    
    # Lock screen (Anniversary Update workaround) - Applicable to RS1 or newer
    If ($LockScreenAlt -eq 1) {
        DisplayOut "Enabling Lock screen (removing scheduler workaround)..." 11 0
        Unregister-ScheduledTask -TaskName "Disable LockScreen" -Confirm:$false -ErrorAction SilentlyContinue
    } ElseIf ($LockScreenAlt -eq 2) {
        DisplayOut "Disabling Lock screen using scheduler workaround..." 12 0
        $service = New-Object -com Schedule.Service
        $service.Connect()
        $task = $service.NewTask(0)
        $task.Settings.DisallowStartIfOnBatteries = $false
        $trigger = $task.Triggers.Create(9)
        $trigger = $task.Triggers.Create(11)
        $trigger.StateChange = 8
        $action = $task.Actions.Create(0)
        $action.Path = "reg.exe"
        $action.Arguments = "add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\SessionData /t REG_DWORD /v AllowLockScreen /d 0 /f"
        $service.GetFolder("\").RegisterTaskDefinition("Disable LockScreen", $task, 6, "NT AUTHORITY\SYSTEM", $null, 4) | Out-Null
    }
    
    # Power Menu on Lock Screen
    If ($PowerMenuLockScreen -eq 1) {
        DisplayOut "Showing Power Menu on Lock Screen..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "shutdownwithoutlogon" -Type DWord -Value 1
    } ElseIf ($PowerMenuLockScreen -eq 2) {
        DisplayOut "Hiding Power Menu on Lock Screen..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "shutdownwithoutlogon" -Type DWord -Value 0
    }
    
    # Camera at Lockscreen
    If ($CameraOnLockscreen -eq 1) {
        DisplayOut "Enabling Camera at Lockscreen..." 11 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "NoLockScreenCamera" -ErrorAction SilentlyContinue
    } ElseIf ($CameraOnLockscreen -eq 2) {
        DisplayOut "Disabling Camera at Lockscreen..." 12 0
        If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" | Out-Null
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "NoLockScreenCamera" -Type DWord -Value 1
    }
    
    ##########
    # Lockscreen Items -End
    ##########
    
    ##########
    # Misc Items -Start
    ##########
    
    DisplayOut ""
    DisplayOut "------------------" 14 0
    DisplayOut "-   Misc Items   -" 14 0
    DisplayOut "------------------" 14 0
    DisplayOut ""
    
    # Action Center
    If ($ActionCenter -eq 1) {
        DisplayOut "Enabling Action Center..." 11 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "DisableNotificationCenter" -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -ErrorAction SilentlyContinue
    } ElseIf ($ActionCenter -eq 2) {
        DisplayOut "Disabling Action Center..." 12 0
        If (!(Test-Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer")) {
            New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" | Out-Null
        }
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "DisableNotificationCenter" -Type DWord -Value 1
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -Type DWord -Value 0
    }
    
    # Sticky keys prompt
    If ($StickyKeyPrompt -eq 1) {
        DisplayOut "Enabling Sticky keys prompt..." 11 0
        Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "510"
    } ElseIf ($StickyKeyPrompt -eq 2) {
        DisplayOut "Disabling Sticky keys prompt..." 12 0
        Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "506"
    }
    
    # NumLock after startup
    If ($NumblockOnStart -eq 1) {
        DisplayOut "Enabling NumLock after startup..." 11 0
        Set-ItemProperty -Path "HKU:\.DEFAULT\Control Panel\Keyboard" -Name "InitialKeyboardIndicators" -Type DWord -Value 2147483650
    } ElseIf ($NumblockOnStart -eq 2) {
        DisplayOut "Disabling NumLock after startup..." 12 0
        Set-ItemProperty -Path "HKU:\.DEFAULT\Control Panel\Keyboard" -Name "InitialKeyboardIndicators" -Type DWord -Value 2147483648
    }
    
    # Enable F8 boot menu options
    If ($F8BootMenu -eq 1) {
        DisplayOut "Enabling F8 boot menu options..." 11 0
        bcdedit /set `{current`} bootmenupolicy Legacy | Out-Null
    } ElseIf ($F8BootMenu -eq 2) {
        DisplayOut "Disabling F8 boot menu options..." 12 0
        bcdedit /set `{current`} bootmenupolicy Standard | Out-Null
    }
    
    # Remote UAC Local Account Token Filter
    If ($RemoteUACAcctToken -eq 1) {
        DisplayOut "Enabling Remote UAC Local Account Token Filter..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "LocalAccountTokenFilterPolicy" -Type DWord -Value 1
    } ElseIf ($RemoteUACAcctToken -eq 2) {
        DisplayOut "Disabling  Remote UAC Local Account Token Filter..." 12 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "LocalAccountTokenFilterPolicy" -ErrorAction SilentlyContinue
    }
    
    # Hibernate Option
    If ($HibernatePower -eq 1) {
        DisplayOut "Enabling Hibernate Option..." 11 0
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power" -Name "HibernateEnabled" -Type DWord -Value 1
    } ElseIf ($HibernatePower -eq 2) {
        DisplayOut "Disabling Hibernate Option..." 12 0
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power" -Name "HibernateEnabled" -Type DWord -Value 0
    }
    
    # Sleep Option
    If ($SleepPower -eq 1) {
        DisplayOut "Enabling Sleep Option..." 11 0
        If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings")) {
            New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" | Out-Null
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Name "ShowSleepOption" -Type DWord -Value 1
    } ElseIf ($SleepPower -eq 2) {
        DisplayOut "Disabling Sleep Option..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Name "ShowSleepOption" -Type DWord -Value 0
    }
    
    ##########
    # Misc Items -End
    ##########
    
    ##########
    # Application Items -Start
    ##########
    
    DisplayOut ""
    DisplayOut "-------------------------" 14 0
    DisplayOut "-   Application Items   -" 14 0
    DisplayOut "-------------------------" 14 0
    DisplayOut ""
    
    # OneDrive
    If ($OneDrive -eq 1) {
        DisplayOut "Enabling OneDrive..." 11 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -ErrorAction SilentlyContinue
    } ElseIf ($OneDrive -eq 2) {
        DisplayOut "Disabling OneDrive..." 12 0
        If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" | Out-Null
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Type DWord -Value 1
    }
    
    # OneDrive Install
    If ($OneDriveInstall -eq 1) {
        DisplayOut "Installing OneDrive..." 11 0
        If($OSType -eq 64) {
            $onedriveS = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
        } Else {
            $onedriveS = "$env:SYSTEMROOT\System32\OneDriveSetup.exe"
        }
        Start-Process $onedriveS -NoNewWindow
    } ElseIf ($OneDriveInstall -eq 2) {
        DisplayOut "Uninstalling OneDrive..." 15 0
        Stop-Process -Name OneDrive -ErrorAction SilentlyContinue
        Start-Sleep -s 3
        If($OSType -eq 64) {
            $onedriveS = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
        } Else {
            $onedriveS = "$env:SYSTEMROOT\System32\OneDriveSetup.exe"
        }
        Start-Process $onedriveS "/uninstall" -NoNewWindow -Wait | Out-Null
        Start-Sleep -s 3
        Stop-Process -Name explorer -ErrorAction SilentlyContinue
        Start-Sleep -s 3
        Remove-Item "$env:USERPROFILE\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
        Remove-Item "$env:LOCALAPPDATA\Microsoft\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
        Remove-Item "$env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
        If (Test-Path "$env:SYSTEMDRIVE\OneDriveTemp") {
            Remove-Item "$env:SYSTEMDRIVE\OneDriveTemp" -Force -Recurse -ErrorAction SilentlyContinue
        }
        Remove-Item -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Recurse -ErrorAction SilentlyContinue
        Remove-Item -Path "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Recurse -ErrorAction SilentlyContinue
    }
    
    # Xbox DVR
    If ($XboxDVR -eq 1) {
        DisplayOut "Enabling Xbox DVR..." 11 0
        Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Type DWord -Value 1
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -ErrorAction SilentlyContinue
    } ElseIf ($XboxDVR -eq 2) {
        DisplayOut "Disabling Xbox DVR..." 12 0
        Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Type DWord -Value 0
        If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" | Out-Null
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Type DWord -Value 0
    }
    
    # Windows Media Player
    If ($MediaPlayer -eq 1) {
        DisplayOut "Installing Windows Media Player..." 11 0
        dism /online /Enable-Feature /FeatureName:MediaPlayback /Quiet /NoRestart
    } ElseIf ($MediaPlayer -eq 2) {
        DisplayOut "Uninstalling Windows Media Player..." 14 0
        dism /online /Disable-Feature /FeatureName:MediaPlayback /Quiet /NoRestart
    }
    
    # Work Folders Client
    If ($WorkFolders -eq 1) {
        DisplayOut "Installing Work Folders Client..." 11 0
        dism /online /Enable-Feature /FeatureName:WorkFolders-Client /Quiet /NoRestart
    } ElseIf ($WorkFolders -eq 2) {
        DisplayOut "Uninstalling Work Folders Client..." 14 0
        dism /online /Disable-Feature /FeatureName:WorkFolders-Client /Quiet /NoRestart
    }
    
    # Install Linux Subsystem - Applicable to RS1 or newer
    If ($LinuxSubsystem -eq 1) {
        DisplayOut "Installing Linux Subsystem..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -Type DWord -Value 1
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowAllTrustedApps" -Type DWord -Value 1
        dism /online /Enable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux /Quiet /NoRestart
    } ElseIf ($LinuxSubsystem -eq 2) {
        DisplayOut "Uninstalling Linux Subsystem..." 14 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -Type DWord -Value 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowAllTrustedApps" -Type DWord -Value 0
        dism /online /Disable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux /Quiet /NoRestart
    }
    
    ##########
    # Application Items -end
    ##########
    
    ##########
    # Metro App Items -Start
    ##########
	
	# Sorts the apps to Install, Hide or Uninstall
    $APPProcess = Get-Variable -Name "APP_*" -ValueOnly

    $A=0
    ForEach ($AppV in $APPProcess) {
        If($AppV -eq 1){
            $APPS_AppsInstall+=$AppsList[$A]
        } Elseif($AppV -eq 2){
            $APPS_AppsHide+=$AppsList[$A]
        } Elseif($AppV -eq 3){
        $APPS_AppsUninstall+=$AppsList[$A]
        }
        $A++
	}
    
    DisplayOut ""
    DisplayOut "-----------------------" 14 0
    DisplayOut "-   Metro App Items   -" 14 0
    DisplayOut "-----------------------" 14 0
    DisplayOut ""
    
    # Default Microsoft applications (Bloatware)
    DisplayOut "" 14 0
    DisplayOut "Installing Apps..." 11 0
    DisplayOut "------------------" 11 0
    DisplayOut "" 14 0
    ForEach ($AppI in $APPS_AppsInstall) {
        #$APPIDisplay = "Installing "+$AppI+"..."
        #DisplayOut $APPIDisplay 11 0
    	 DisplayOut $AppI 11 0
        Add-AppxPackage -DisableDevelopmentMode -Register "$($(Get-AppXPackage -AllUsers "$AppI").InstallLocation)\AppXManifest.xml"
    }
    DisplayOut "" 12 0
    DisplayOut "Hidinging Apps..." 12 0
    DisplayOut "-----------------" 12 0
    DisplayOut "" 14 0
    ForEach ($AppH in $APPS_AppsHide) {
        #$APPHDisplay = "Hidinging "$AppH"..."
        #DisplayOut $APPHDisplay 12 0
    	 DisplayOut $AppH 12 0
        Get-AppxPackage $AppH | Remove-AppxPackage
    }
    DisplayOut "" 14 0
    DisplayOut "Uninstalling Apps..." 14 0
    DisplayOut "--------------------" 14 0
    DisplayOut "" 14 0
    ForEach ($AppU in $APPS_AppsUninstall) {
        #$APPUDisplay = "Uninstalling "+$AppU+"..."
        #DisplayOut $APPUDisplay 14 0
        DisplayOut $AppU 14 0
        $PackageFullName = (Get-AppxPackage $AppU).PackageFullName
        $ProPackageFullName = (Get-AppxProvisionedPackage -online | where {$_.Displayname -eq $AppU}).PackageName
        
        # Alt removal
        # DISM /Online /Remove-ProvisionedAppxPackage /PackageName:          
        If ($PackageFullName) {
            Remove-AppxPackage -package $PackageFullName
        }
        If ($ProPackageFullName) {
            Remove-AppxProvisionedPackage -online -packagename $ProPackageFullName
        }
    }
	
	##########
    # Unpin App Items -Start
    ##########
	
	DisplayOut "" 12 0
    DisplayOut "Unpinning Items..." 12 0
    DisplayOut "------------------" 12 0
    DisplayOut "" 14 0

    If ($Unpin -eq 1){
        Pin-App "Mail"
        Pin-App "Store"
        Pin-App "Calendar"
        Pin-App "Microsoft Edge"
        Pin-App "Photos"
        Pin-App "Cortana"
        Pin-App "Weather"
        Pin-App "Phone Companion"
        Pin-App "Twitter"
        Pin-App "Skype Video"
        Pin-App "Candy Crush Soda Saga"
        Pin-App "xbox"
        Pin-App "Groove music"
        Pin-App "movies & tv"
        Pin-App "microsoft solitaire collection"
        Pin-App "money"
        Pin-App "get office"
        Pin-App "onenote"
        Pin-App "news"
    }

    ##########
    # Unpin App Items -End
    ##########
    
    ##########
    # Metro App Items -End
    ##########
	
	If ($Restart -eq 1) {
	    Clear-Host
	    $Seconds = 10
		Write-Host "Restarting Computer in 10 Seconds..." -ForegroundColor Yellow -BackgroundColor Black
        $Message = "Restarting in "
		Start-Sleep -Seconds 1
	    ForEach ($Count in (1..$Seconds)) {
		    If($Count -ne 0){
                Write-Host $Message" $($Seconds - $Count)" -ForegroundColor Yellow -BackgroundColor Black
                Start-Sleep -Seconds 1
			}
        }
		Write-Host "Restarting Computer..." -ForegroundColor Red -BackgroundColor Black
        Restart-Computer
    } Else {
        Write-Host "Goodbye..."
		Exit
    }
}

##########
# Script -End
##########


# --------------------------------------------------------------------------

## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## !!!!!!!!!               SAFE TO EDIT VALUES              !!!!!!!!!
## !!!!!!!!!                  -- START --                   !!!!!!!!!
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# Edit values (Option) to your preferance
# Change to an Option not listed will Skip the Function/Setting

# Note: If you're not sure what something does dont change it or do a web search 

# Can ONLY create 1 per 24 hours with this script (Will give error if it tries)
$Script:CreateRestorePoint = 0    #0-Skip, 1-Create --(Restore point before script runs)

# Skips Term of Use
$Script:Term_of_Use = 1           #1-See, Anything else = Accepts Term of Use

# Output Display
$Script:Verbros = 1               #0-Dont Show output, 1-Show output
$Script:ShowColor = 1             #0-Dont Show output Color, 1-Show output Colors

# Restart when done? (I recommend restarting when done)
$Script:Restart = 1               #0-Dont Restart, 1-Restart

# Windows Default for ALL Settings 
$Script:WinDefault = 2            #1-Yes*, 2-No 
# IF 1 is set then Everything Other than the following will use the Default Win Settings
# ALL Values Above this one, All Metro Apps and $Script:OneDriveInstall  (These will use what you set)

# Privacy Settings
# Function  = Option              #Choices (* Indicates Windows Default)
$Script:Telemetry = 0             #0-Skip, 1-Enable*, 2-Disable
$Script:WiFiSense = 0             #0-Skip, 1-Enable*, 2-Disable
$Script:SmartScreen = 0           #0-Skip, 1-Enable*, 2-Disable --(phishing and malware filter for soe MS Apps/Prog)
$Script:LocationTracking = 0      #0-Skip, 1-Enable*, 2-Disable
$Script:Feedback = 0              #0-Skip, 1-Enable*, 2-Disable
$Script:AdvertisingID = 0         #0-Skip, 1-Enable*, 2-Disable     
$Script:Cortana = 0               #0-Skip, 1-Enable*, 2-Disable
$Script:CortanaSearch = 0         #0-Skip, 1-Enable*, 2-Disable --(If you disable Cortana you can still search with this)
$Script:ErrorReporting = 0        #0-Skip, 1-Enable*, 2-Disable
$Script:AutoLoggerFile = 0        #0-Skip, 1-Enable*, 2-Disable
$Script:DiagTrack = 0             #0-Skip, 1-Enable*, 2-Disable
$Script:WAPPush = 0               #0-Skip, 1-Enable*, 2-Disable --(type of text message that contains a direct link to a particular Web page)

# Windows Update
# Function  = Option              #Choices (* Indicates Windows Default)
$Script:CheckForWinUpdate = 0     #0-Skip, 1-Enable*, 2-Disable
$Script:WinUpdateType = 0         #0-Skip, 1-Notify, 2-Auto DL, 3-Auto DL+Install*, 4-Local admin chose --(May not work with Home version)
$Script:WinUpdateDownload = 0     #0-Skip, 1-P2P*, 2-Local Only, 3-Disable
$Script:UpdateMSRT = 0            #0-Skip, 1-Enable*, 2-Disable --(Malware Software Removal Tool)
$Script:UpdateDriver = 0          #0-Skip, 1-Enable*, 2-Disable --(Offering of drivers through Windows Update)
$Script:RestartOnUpdate = 0       #0-Skip, 1-Enable*, 2-Disable
$Script:AppAutoDownload = 0       #0-Skip, 1-Enable*, 2-Disable

# Service Tweaks
# Function  = Option              #Choices (* Indicates Windows Default)
$Script:UAC = 0                   #0-Skip, 1-Lower, 2-Normal*, 3-Higher
$Script:SharingMappedDrives = 0   #0-Skip, 1-Enable, 2-Disable* --(Sharing mapped drives between users)
$Script:AdminShares = 0           #0-Skip, 1-Enable*, 2-Disable --(Default admin shares for each drive)
$Script:Firewall = 0              #0-Skip, 1-Enable*, 2-Disable
$Script:WinDefender = 0           #0-Skip, 1-Enable*, 2-Disable
$Script:HomeGroups = 0            #0-Skip, 1-Enable*, 2-Disable
$Script:RemoteAssistance = 0      #0-Skip, 1-Enable*, 2-Disable
$Script:RemoteDesktop = 0         #0-Skip, 1-Enable, 2-Disable* --(Remote Desktop w/o Network Level Authentication)
 
#Context Menu Items
# Function  = Option              #Choices (* Indicates Windows Default)
$Script:CastToDevice = 0          #0-Skip, 1-Enable*, 2-Disable
$Script:PreviousVersions = 0      #0-Skip, 1-Enable*, 2-Disable
$Script:IncludeinLibrary = 0      #0-Skip, 1-Enable*, 2-Disable
$Script:PinTo = 0                 #0-Skip, 1-Enable*, 2-Disable
$Script:ShareWith = 0             #0-Skip, 1-Enable*, 2-Disable
$Script:SendTo = 0                #0-Skip, 1-Enable*, 2-Disable

#Task Bar Items
# Function  = Option              #Choices (* Indicates Windows Default)
$Script:BatteryUIBar = 0          #0-Skip, 1-New*, 2-Classic --(Classic is Win 7 version)
$Script:ClockUIBar = 0            #0-Skip, 1-New*, 2-Classic --(Classic is Win 7 version)
$Script:VolumeControlBar = 0      #0-Skip, 1-New(Horizontal)*, 2-Classic(Vertical) --(Classic is Win 7 version)
$Script:TaskbarSearchBox = 0      #0-Skip, 1-Show*, 2-Hide
$Script:TaskViewButton = 0        #0-Skip, 1-Show*, 2-Hide
$Script:TaskbarIconSize = 0       #0-Skip, 1-Normal*, 2-Smaller
$Script:TaskbarGrouping = 0       #0-Skip, 1-Never, 2-Always*, 3-When Needed
$Script:TrayIcons = 0             #0-Skip, 1-Auto*, 2-Always Show     
$Script:SecondsInClock = 0        #0-Skip, 1-Show, 2-Hide*
$Script:LastActiveClick = 0       #0-Skip, 1-Enable, 2-Disable* --(Makes Taskbar Buttons Open the Last Active Window)
$Script:TaskBarOnMultiDisplay = 0 #0-Skip, 1-Enable*, 2-Disable
$Script:TaskbarButtOnDisplay = 0  #0-Skip, 1-All, 2-where window is open, 3-Main and where window is open

#Star Menu Items
# Function  = Option              #Choices (* Indicates Windows Default)
$Script:StartMenuWebSearch = 0    #0-Skip, 1-Enable*, 2-Disable
$Script:StartSuggestions = 0      #0-Skip, 1-Enable*, 2-Disable --(The Suggested Apps in Start Menu)
$Script:MostUsedAppStartMenu = 0  #0-Skip, 1-Show*, 2-Hide
$Script:RecentItemsFrequent = 0   #0-Skip, 1-Enable*, 2-Disable --(In Start Menu)

#Explorer Items
# Function  = Option              #Choices (* Indicates Windows Default)
$Script:Autoplay = 0              #0-Skip, 1-Enable*, 2-Disable
$Script:Autorun = 0               #0-Skip, 1-Enable*, 2-Disable
$Script:PidInTitleBar = 0         #0-Skip, 1-Show, 2-Hide* --(PID = Processor ID)
$Script:AeroSnap = 0              #0-Skip, 1-Enable*, 2-Disable --(Allows you to quickly resize the window you’re currently using)
$Script:AeroShake = 0             #0-Skip, 1-Enable*, 2-Disable
$Script:KnownExtensions = 0       #0-Skip, 1-Show, 2-Hide*
$Script:HiddenFiles = 0           #0-Skip, 1-Show, 2-Hide*
$Script:SystemFiles = 0           #0-Skip, 1-Show, 2-Hide*
$Script:ExplorerOpenLoc = 0       #0-Skip, 1-Quick Access*, 2-ThisPC --(What location it opened when you open an explorer window)
$Script:RecentFileQikAcc = 0      #0-Skip, 1-Show/Add*, 2-Hide, 3-Remove --(Recent Files in Quick Access)
$Script:FrequentFoldersQikAcc = 0 #0-Skip, 1-Show*, 2-Hide --(Frequent Folders in Quick Access)
$Script:WinContentWhileDrag = 0   #0-Skip, 1-Show*, 2-Hide

#'This PC' items
# Function  = Option              #Choices (* Indicates Windows Default)
$Script:ThisPCOnDesktop = 0       #0-Skip, 1-Show, 2-Hide*
$Script:DesktopIconInThisPC = 0   #0-Skip, 1-Show*, 2-Hide
$Script:DocumentsIconInThisPC = 0 #0-Skip, 1-Show*, 2-Hide
$Script:DownloadsIconInThisPC = 0 #0-Skip, 1-Show*, 2-Hide
$Script:MusicIconInThisPC = 0     #0-Skip, 1-Show*, 2-Hide
$Script:PicturesIconInThisPC = 0  #0-Skip, 1-Show*, 2-Hide
$Script:VideosIconInThisPC = 0    #0-Skip, 1-Show*, 2-Hide

#Lock Screen
# Function  = Option              #Choices (* Indicates Windows Default)
$Script:LockScreen = 0            #0-Skip, 1-Enable*, 2-Disable (Pre-Anniversary Update)
$Script:LockScreenAlt = 0         #0-Skip, 1-Enable*, 2-Disable (Anniversary Update workaround) 
$Script:PowerMenuLockScreen = 0   #0-Skip, 1-Show*, 2-Hide
$Script:CameraOnLockScreen = 0    #0-Skip, 1-Enable*, 2-Disable

#Misc items
# Function  = Option              #Choices (* Indicates Windows Default)
$Script:ActionCenter = 0          #0-Skip, 1-Enable*, 2-Disable
$Script:StickyKeyPrompt = 0       #0-Skip, 1-Enable*, 2-Disable
$Script:NumblockOnStart = 0       #0-Skip, 1-Enable, 2-Disable*
$Script:F8BootMenu = 0            #0-Skip, 1-Enable, 2-Disable*
$Script:RemoteUACAcctToken = 0    #0-Skip, 1-Enable, 2-Disable*
$Script:HibernatePower = 1        #0-Skip, 1-Enable, 2-Disable --(Hibernate Power Option)
$Script:SleepPower = 1            #0-Skip, 1-Enable*, 2-Disable --(Sleep Power Option)

# Photo Viewer Settings
# Function  = Option              #Choices (* Indicates Windows Default)
$Script:PVFileAssociation = 0     #0-Skip, 1-Enable, 2-Disable*
$Script:PVOpenWithMenu = 0        #0-Skip, 1-Enable, 2-Disable*

# Remove unwanted applications
# Function  = Option              #Choices (* Indicates Windows Default)
$Script:OneDrive = 0              #0-Skip, 1-Enable*, 2-Disable
$Script:OneDriveInstall = 0       #0-Skip, 1-Installed*, 2-Uninstall
$Script:XboxDVR = 0               #0-Skip, 1-Enable*, 2-Disable
$Script:MediaPlayer = 0           #0-Skip, 1-Installed*, 2-Uninstall
$Script:WorkFolders = 0           #0-Skip, 1-Installed*, 2-Uninstall
$Script:LinuxSubsystem = 0        #0-Skip, 1-Installed, 2-Uninstall* (Anniversary Update)

#Disabled Items (Till Fixed)
#$Script:MoreColorsTitle = 0       #0-Skip, 1-Enable, 2-Disable* --(Adds more Colors to pick from for the Title Colors)


# Custom List of App to Install, Hide or Uninstall
# I dunno if you can Install random apps with this script
# Cant Import these ATM
$Script:APPS_AppsInstall = @()    # Apps to Install
$Script:APPS_AppsHide = @()       # Apps to Hide
$Script:APPS_AppsUninstall = @()  # Apps to Uninstall
#$Script:APPS_Example = @('Somecompany.Appname1','TerribleCompany.Appname2','SomeCrap.Appname3')
# To get list of Packages Installed
# DISM /Online /Get-ProvisionedAppxPackages | Select-string Packagename
# 

<# 
App Uninstall will remove them to reinstall you can
1. Install some from Windows Store
2. Restore the files using installation medium as follows
New-Item C:\Mnt -Type Directory | Out-Null
dism /Mount-Image /ImageFile:D:\sources\install.wim /index:1 /ReadOnly /MountDir:C:\Mnt
robocopy /S /SEC /R:0 "C:\Mnt\Program Files\WindowsApps" "C:\Program Files\WindowsApps"
dism /Unmount-Image /Discard /MountDir:C:\Mnt
Remove-Item -Path C:\Mnt -Recurse
#>

# Metro Apps
# By Default Most of these are installed
# Function  = Option       # 0-Skip, 1-Unhide, 2- Hide, 3-Uninstall (!!Read Note Above)
$Script:APP_3DBuilder = 0         # '3DBuilder' app
$Script:APP_AdvertisingXaml = 0   ## Removal may cause problem with some apps
$Script:APP_Appconnector = 0      ## Not sure about this one
$Script:APP_Asphalt8Airborne = 0  # 'Asphalt 8' game
$Script:APP_BingFinance = 0       # 'Money' app - Financial news
$Script:APP_BingFoodAndDrink = 0  # 'Food and Drink' app
$Script:APP_BingHealthFitness = 0 # 'Health and Fitness' app
$Script:APP_BingNews = 0          # 'Generic news' app
$Script:APP_BingSports = 0        # 'Sports' app - Sports news
$Script:APP_BingTranslator = 0    # 'Translator' app - Bing Translate
$Script:APP_BingTravel = 0        # 'Travel' app
$Script:APP_BingWeather = 0       # 'Weather' app
$Script:APP_CandyCrushSoda = 0    # 'Candy Crush' game 
$Script:APP_CommsPhone = 0        # 'Phone' app
$Script:APP_Communications = 0    # 'Calendar and Mail' app
$Script:APP_ConnectivityStore = 0     
$Script:APP_Facebook = 0          # 'Facebook' app
$Script:APP_FarmVille = 0         # 'Farm Ville' game
$Script:APP_FreshPaint = 0        # 'Canvas' app
$Script:APP_Getstarted = 0        # 'Get Started' link
$Script:APP_Messaging = 0         # 'Messaging' app
$Script:APP_MicrosoftJackpot = 0  # 'Jackpot' app
$Script:APP_MicrosoftJigsaw = 0   # 'Jigsaw' game       
$Script:APP_MicrosoftMahjong = 0  # 'Mahjong' game
$Script:APP_MicrosoftOffHub = 0   # 'Office Hub' app 
$Script:APP_MicrosoftSudoku = 0   # 'Sudoku' game 
$Script:APP_MinecraftUWP = 0      # 'Minecraft' game    
$Script:APP_MovieMoments = 0        
$Script:APP_Netflix = 0           # 'Netflix' app
$Script:APP_OfficeOneNote = 0     # 'Onenote' app
$Script:APP_OfficeSway = 0        # 'Sway' app
$Script:APP_OneConnect=0
$Script:APP_People = 0            # 'People' app
$Script:APP_Photos = 0            # Photos app
$Script:APP_SkypeApp = 0          # 'Get Skype' link
$Script:APP_SkypeWiFi = 0         
$Script:APP_SolitaireCollect = 0  # Solitaire collection
$Script:APP_SoundRecorder = 0     # 'Sound Recorder' app
$Script:APP_StickyNotes = 0       # 'Sticky Notes' app 
$Script:APP_StudiosWordament = 0  # 'Wordament' game
$Script:APP_Taptiles = 0          
$Script:APP_Twitter = 0           # 'Twitter' app
$Script:APP_WindowsAlarms = 0     # 'Alarms and Clock' app
$Script:APP_WindowsCalculator = 0 # 'Calculator' app
$Script:APP_WindowsCamera = 0     # 'Camera' app
$Script:APP_WindowsFeedbak = 0    # 'Feedback' functionality
$Script:APP_WindowsFeedbakHub = 0 # 'Feedback' functionality
$Script:APP_WindowsMaps = 0       # 'Maps' app
$Script:APP_WindowsPhone = 0      # 'Phone Companion' app
$Script:APP_WindowsStore = 0      # Windows Store
$Script:APP_XboxApp = 0           # 'Xbox' app 
$Script:APP_ZuneMusic = 0         # 'Groove Music' app
$Script:APP_ZuneVideo = 0         # 'Groove Music' app


## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## !!!!!!!!!               SAFE TO EDIT VALUES              !!!!!!!!!
## !!!!!!!!!                   -- END --                    !!!!!!!!!
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# --------------------------------------------------------------------------

If ($SettingImp -ne $null -and $SettingImp){
     If (Test-Path $SettingImp -PathType Leaf){
        LoadSettingFile($SettingImp)
	} ElseIf ($SettingImp -eq "WD" -or $SettingImp -eq "WindowsDefault"){
	    LoadWinDefault
    }
} Else{
    TOS
}
