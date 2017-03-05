##########
# Win10 Initial Setup Script Settings with Menu
# 
# Original Basic Script from
# Author: Disassembler
# Website: https://github.com/Disassembler0/Win10-Initial-Setup-Script/
# Version: 2.0, 2017-01-08 (Version Copied)
#
# Modded Script + Menu By
# Author: Madbomb122
# Website: https://github.com/madbomb122/Win10Script/
# Version: 1.5-Menu, 03-05-2017
#
# Release Type: Testing
##########

<#
    Copyright (c) 2017 Disassembler -Original Basic Version of Script
    Copyright (c) 2017 Madbomb122 -Modded + Menu Version of Script
    
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
    Use the Menu and set what you want then select to run the script
    
.ADVANCED USAGE
    Use one of the following Methods

1. Change the variables you want (Bottom of Script) then run script with
      -Set Run

Example: Win10-Menu.ps1 -Set Run
Example: Win10-Menu.ps1 -Set run
------
2. To run the script with the Items in the script back to the Default 
    for windows run the script with one of the 2 switches bellow:
      -Set WD
      -Set WinDefault 

Example: Win10-Menu.ps1 -Set WD
Example: Win10-Menu.ps1 -Set WinDefault
------
3. To run the script with imported Settings run the script with:    
      -Set Filename

Example: Win10-Menu.ps1 -Set File.csv
Example: Win10-Menu.ps1 -Set Example.txt
Example: Win10-Menu.ps1 -Set whatever.sjdfh

Note: File has to be in the proper format or settings wont be imported
----------------------------------------------------------------------------
#>

## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## !!!!!!                                                !!!!!!
## !!!!!!               SAFE TO EDIT ITEM                !!!!!!
## !!!!!!              AT BOTTOM OF SCRIPT               !!!!!!
## !!!!!!                                                !!!!!!
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## !!!!!!                                                !!!!!!
## !!!!!!                    CAUTION                     !!!!!!
## !!!!!!          DO NOT EDIT PAST THIS POINT           !!!!!!
## !!!!!!                                                !!!!!!
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

Param([alias("Set")] [string] $SettingImp)

##########
# Version Info -Start
##########

$CurrVer = "1.4 (03-03-17) "
$RelType = "Testing"
#$RelType = "Beta   "
#$RelType = "Stable "

##########
# Version Info -End
##########

##########
# Pre-Script -Start
##########

$Global:filebase = $PSScriptRoot
$ErrorActionPreference= 'silentlycontinue'

# Ask for elevated permissions if required
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $args" -Verb RunAs
    Exit
}

##########
# Pre-Script -End
##########

##########
# Multi Use Functions -Start
##########

function TOSDisplay {
    Write-Host "                 Terms of Use                  " -ForegroundColor Green -BackgroundColor Black
    If($RelType -eq "Testing" -or $RelType -eq "Beta   "){
        Write-Host "                   WARNING!!                   " -ForegroundColor Red -BackgroundColor Black
        Write-Host "    This version is currently being Tested.    " -ForegroundColor Yellow -BackgroundColor Black 
    }
    Write-Host "                                               " -ForegroundColor Black -BackgroundColor White
    Write-Host "This program comes with ABSOLUTELY NO WARRANTY." -ForegroundColor Black -BackgroundColor White
    Write-Host "This is free software, and you are welcome to  " -ForegroundColor Black -BackgroundColor White
    Write-Host "redistribute it under certain conditions.      " -ForegroundColor Black -BackgroundColor White
    Write-Host "                                               " -ForegroundColor Black -BackgroundColor White
    Write-Host "Read License file for full Terms.              " -ForegroundColor Black -BackgroundColor White
    Write-Host "                                               " -ForegroundColor Black -BackgroundColor White
    Write-Host "Do you Accept the Terms of Use? (Y)es/(N)o     " -ForegroundColor White -BackgroundColor Black    
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
        $TOS = Read-Host "`nAccept? (Y)es/(N)o"
        switch ($TOS.ToLower()) {
            n {Exit}
            no {Exit}
            y {$Term_of_Use = "Accepted"; mainMenu}
            yes {$Term_of_Use = "Accepted"; mainMenu}
            default {$Invalid = 1}
        }
    }
    Return
}

# Used to Help remove the Automatic variables
function cmpv {
    Compare-Object (Get-Variable) $AutomaticVariables -Property Name -PassThru | Where -Property Name -ne "AutomaticVariables"
}

function Pin-App([string]$appname) {      
    ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'Unpin from Start'} | %{$_.DoIt()}
}

# Function to Display in Color or NOT (for MENU ONLY)
function DisplayOutMenu([String]$TxtToDisplay,[int]$TxtColor,[int]$BGColor,[int]$NewLine){
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
function DisplayOut([String]$TxtToDisplay,[int]$TxtColor,[int]$BGColor,){
    If($Verbros -eq 1){
        If($TxtColor -le 15 -and $ShowColor -eq 1){
             Write-Host $TxtToDisplay -ForegroundColor $colors[$TxtColor] -BackgroundColor $colors[$BGColor]
        } Else {
             Write-Host $TxtToDisplay
        }
    } 
}

function ChoicesMenu([String]$Vari, [Int]$NumberH, [Int]$NumberL) {
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
        switch -regex ($ChoicesMenu) {
            0 {if($NumberL -eq $ChoicesMenu) {$ReturnV = $ChoicesMenu; $ChoicesMenu = "Out"} Else {$Invalid = 1}}
            [1-4] {if($NumberH -ge $ChoicesMenu) {$ReturnV = $ChoicesMenu; $ChoicesMenu = "Out"} Else {$Invalid = 1}}
            C {$ReturnV = $VariV; $ChoicesMenu = "Out"}
            default {$Invalid = 1}
        }
    }
    Set-Variable -Name $Vari -Value $ReturnV -Scope Script
    Return
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
        If($ConInt -is [int] -and $VariMenu -ne $null){
            for ($i=0; $i -le $VariMenuItm.length; $i++) {
                If($VariMenuItm[$i][0] -eq $ConInt){
                    If(($VariMenuItm[$i][1]) -eq "Black_Viper_Input" -and $ConInt -eq 9){
                        Black_Viper_Input
                    } Else {
                        ChoicesMenu ($VariMenuItm[$i][1]) ($VariMenuItm[$i][2]) ($VariMenuItm[$i][3])
                        $i = $VariMenuItm.length +1
                    }
                }
            }

        } Else {
            switch ($VariMenu) {
                B {$VariMenu = "Out"}
                default {$Invalid = 1}
            }
        }
    }
    Return
}


function OpenWebsite ([String]$Website){
    $IE=new-object -com internetexplorer.application
    $IE.navigate2($Website)
    $IE.visible=$true
}

##########
# Multi Use Functions -End
##########

##########
# Confirm Menu -Start
##########

$ConfirmMenuItems1 = @(
'                 Confirm Dialog                  ',
'                                                 ',
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
        switch ($ConfirmMenu) {
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
    DisplayOutMenu "| " 14 0 0 ;DisplayOutMenu $ChToDisplay[1] 2 0 0 ;DisplayOutMenu " |" 14 0 1
    DisplayOutMenu "| " 14 0 0 ;DisplayOutMenu $ChToDisplay[2] 2 0 0 ;DisplayOutMenu " |" 14 0 1
    DisplayOutMenu "|                                                   |" 14 0 1
    DisplayOutMenu "|---------------------------------------------------|" 14 0 1
    DisplayOutMenu "|                                                   |" 14 0 1
    for ($i=3; $i -lt $ChToDisplay.length-1; $i++) {
        DisplayOutMenu "| " 14 0 0 ;DisplayOutMenu $ChToDisplay[$i] 2 0 0 ;DisplayOutMenu " |" 14 0 1
    }
    DisplayOutMenu "|                                                   |" 14 0 1
    DisplayOutMenu "| " 14 0 0 ;DisplayOutMenu "Current Value: " 13 0 0 ;DisplayOutMenu $ChToDisplayVal 13 0 0 ;DisplayOutMenu "                                  |" 14 0 1
    TitleBottom $ChToDisplay[$ChToDisplay.length-1] 13
    Website
}


# Displays items but NO Seperators
function VariableDisplay ([Array]$VarToDisplay) {
    TitleBottom $VarToDisplay[0] 11
    for ($i=1; $i -lt $VarToDisplay.length-1; $i++) {
        DisplayOutMenu "|  " 14 0 0 ;DisplayOutMenu $VarToDisplay[$i] 2 0 0 ;DisplayOutMenu "|" 14 0 1
    }
    TitleBottom $VarToDisplay[$VarToDisplay.length-1] 16
}

# Displays Title of Menu but with color choices
function TitleBottom ([String]$TitleA,[Int]$TitleB) {
    DisplayOutMenu "|---------------------------------------------------|" 14 0 1
    If($TitleB -eq 16) {
        DisplayOutMenu "| " 14 0 0 ;DisplayOutMenu "Current Version: " 15 0 0 ;DisplayOutMenu $CurrVer 15 0 0 ;DisplayOutMenu " |" 14 0 0
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
    DisplayOutMenu "|" 14 0 0 ;DisplayOutMenu "     https://github.com/madbomb122/Win10Script/    " 15 0 0 ;DisplayOutMenu "|" 14 0 1
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
'5. Script Options      ',"W. Madbomb's Github    ",
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
            1 {RunScript} #Run Script
            2 {ScriptSettingsMM} #Script Settings Main Menu
            3 {LoadSetting} #Load Settings
            4 {SaveSetting} #Save Settings
            5 {VariMenu $ScriptOptionMenuItems $ScriptOptionMenuItm} #Script Options
            H {HUACMenu "HelpItems"} #Help
            U {HUACMenu "UsageItems"} #How to Use
            A {HUACMenu "AboutItems"}  #About/Version
            C {HUACMenu "CopyrightItems"}  #Copyright
            W {OpenWebsite "https://github.com/madbomb122/Win10Script"}
            Q {Exit} #/Exit/Quit
            default {$Invalid = 1}
        }
    }
    Return
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
            11 {MetroMenu $MetroAppsMenuItems $MetroAppsMenuItm} #Metro Apps
            12 {VariMenu $MiscSetMenuItems $MiscSetMenuItm} #Misc/Photo Viewer
            B {$ScriptSettingsMM = "Out"}
            default {$Invalid = 1}
        }
    }
    Return
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
            0 {$LoadSetting ="Out"; $Switched = "True"; write-host "0"}
            $null {$LoadSetting ="Out"; $Switched = "True"; write-host "null"}
            WD {LoadWinDefault; $Switched = "True"; write-host "wd"}
            WinDefault {LoadWinDefault; $Switched = "True"; write-host "windef"}
            Default {$Switched = "False"; write-host "def"}
        }
        If ($Switched -ne "True"){
            If (Test-Path $LoadSetting -PathType Leaf){
                        write-host "If 2"
                $Conf = ConfirmMenu 1
                If($Conf -eq $true){
                    #Import-Clixml .\$LoadSetting | %{Set-Variable $_.Name $_.Value -Scope Script}
                    Import-Csv .\$LoadSetting | %{Set-Variable $_.Name $_.Value -Scope Script}
                    $LoadSetting ="Out"
                }
            } Else {
                $Invalid = 1
            }
        }
    }
    Return
}

function LoadSettingFile([String]$Filename) {
    #Import-Clixml .\$Filename | %{Set-Variable $_.Name $_.Value -Scope Script}
    Import-Csv .\$Filename | %{Set-Variable $_.Name $_.Value -Scope Script}
    RunScript
}

function SaveSetting {
    $SaveSetting = 'X'
    while($SaveSetting -ne "Out"){
        Clear-Host
        VariableDisplay $SaveSettingItems
        $SaveSetting = Read-Host "`nFilename"
        If ($SaveSetting -eq $null -or $SaveSetting -eq 0){
            $SaveSetting = "Out"
        } Else {
            $SavePath = $filebase+"\"+$SaveSetting
            If (Test-Path $SavePath -PathType Leaf){
                $Conf = ConfirmMenu 2
                If($Conf -eq $true){
                #cmpv | Export-Clixml -LiteralPath $SavePath -force
                cmpv | Export-Csv -LiteralPath $SavePath -encoding "unicode" -force
                }
            } Else {
                #cmpv | Export-Clixml -LiteralPath $SavePath -force
                cmpv | Export-Csv -LiteralPath $SavePath -encoding "unicode" -force
            }
            $SaveSetting = "Out"
        }
    }
    Return
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
'2. Agree Term of Use   ','5. Show Skipped Items  ',
'3. Verbros             ','6. Restart when Done   ',
'B. Back to Main Menu                             '
)

$ScriptOptionMenuItm = (
(1,"CreateRestorePoint",1,0),
(2,"Term_of_Use",1,0),
(3,"Verbros",1,0),
(4,"ShowColor",1,0),
(5,"ShowSkipped",1,0),
(6,"Restart",1,0)
)
ShowSkipped

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
" Shows output of the Script's progress.          ",
'                                                 ',
'0. Dont Show ANY Output                          ',
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

$ShowSkippedItems = @(
'               Show Skipped Items                ',
'                                                 ',
' Show output showing skipped items.              ',
'0. Dont Show Skipped Items                       ',
'1. Show Skipped Items                            ',
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
'        "-set WD" or "-set WinDefault"           ',
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
' If not, see <http://www.gnu.org/licenses/>.     ',
'                                                 ',
"Press 'Enter' to go back                         "
)

function HUACMenu([String]$VariJ) {
    $HUACMenu = 'X'
    $VariA = Get-Variable $VariJ -valueOnly #Array
    while($HUACMenu -ne "Out"){
        Clear-Host
        VariableDisplay $VariA
        $HUACMenu = Read-Host "`nPress 'Enter' to continue"
        switch ($HUACMenu) {
            default {$HUACMenu = "Out"}
        }
    }
    Return
}

##########
# Info Display Stuff -End
##########

##########
# Script Settings Sub Menu -Start
##########

  ##########
  # Black Viper -Start
  ##########
  

$BlackViperItems = @(
'               Black Viper Services              ',
' Will change the services based on your choice.  ',
" Settings based on Black Viper's Settings        ",
'0. Skip                                          ',
'1. Default                                       ',
'2. Safe                                          ',
'3. Tweaked                                       ',
"W. Go to Black Viper's Website                   ",
'C. Cancel (Keeps Current Setting)                '
)

$ServicesList = @(
#(Service Name, Def-Home, Def-Pro , Safe, Tweaked)
('AJRouter',2,2,2,1),
('ALG',2,2,2,1),
('BthHFSrv',2,2,2,1),
('bthserv',2,2,2,1),
('CDPUserSvc_',3,3,2,2),
('CertPropSvc',2,2,2,1),
('CscService',0,2,1,1),
('diagnosticshub.standardcollector.service',2,2,1,1),
('dmwappushsvc',2,2,1,1),
('DusmSvc',3,3,3,1),
#('EntAppSvc',2,2,1,1), -Cant change Setting
('Fax',2,2,1,1),
('FrameServer',2,2,1,1),
('hkmsvc',0,2,2,1),
('HvHost',2,2,1,1),
('icssvc',2,2,1,1),
('iphlpsvc',3,3,3,1),
('IpxlatCfgSvc',2,2,2,1),
('irmon',2,2,1,1),
('lfsvc',2,2,1,1),
('MapsBroker',4,4,1,1),
('MSiSCSI',2,2,1,1),
('NaturalAuthentication',2,2,2,1),
('NcbService',2,2,2,1),
('NcdAutoSetup',2,2,2,1),
('Netlogon',2,2,2,1),
('NetTcpPortSharing',2,2,1,1),
('PeerDistSvc',0,2,1,1),
('PhoneSvc',2,2,1,1),
('PimIndexMaintenanceSvc_',2,2,1,1),
('RetailDemo',2,2,1,1),
('RmSvc',2,2,1,1),
('RpcLocator',2,2,1,1),
('ScDeviceEnum',2,2,1,1),
('SCPolicySvc',2,2,1,1),
('SEMgrSvc',2,2,1,1),
('SensorDataService',2,2,1,1),
('SensorService',2,2,1,1),
('SensrSvc',2,2,1,1),
('SessionEnv',2,2,2,1),
('SharedAccess',2,2,1,1),
('SmsRouter',2,2,1,1),
('SNMPTRAP',2,2,1,1),
('spectrum',2,2,2,1),
('StorSvc',2,2,2,1),
('TabletInputService',2,2,1,1),
('TermService',2,2,2,1),
#('tiledatamodelsvc',3,3,3,1), -Cant change Setting
('TrkWks',3,3,3,1),
('UmRdpService',2,2,2,1),
('vmicguestinterface',2,2,1,1),
('vmicheartbeat',2,2,1,1),
('vmickvpexchange',2,2,1,1),
('vmicrdv',2,2,1,1),
('vmicshutdown',2,2,1,1),
('vmictimesync',2,2,1,1),
('vmicvmsession',2,2,1,1),
('vmicvss',2,2,1,1),
('WbioSrvc',2,2,2,1),
('wcncsvc',2,2,2,1),
('WebClient',2,2,2,1),
('WFDSConSvc',2,2,1,1),
('WinRM',2,2,1,1),
('wisvc',2,2,1,1),
('wlpasvc',2,2,2,1),
('WMPNetworkSvc',2,2,1,1),
('Wms',0,3,1,1),
('WmsRepair',0,3,1,1),
('workfolderssvc',2,2,1,1),
('WwanSvc',2,2,1,1),
('XblAuthManager',2,2,1,1),
('XblGameSave',2,2,1,1),
('XboxNetApiSvc',2,2,1,1)
)
$ServiceLen = $ServicesList.length

$ServicesTypeList = @(
    '',          #0 -None
    'disabled',  #1 -Disable
    'manual',    #2 -Manual
    'automatic', #3 -Auto Normal
    'automatic'  #4 -Atuo Delay
)

function Black_Viper_Input {
    $Black_Viper_Input = 'X'
    while($Black_Viper_Input -ne "Out"){
        Clear-Host
        ChoicesDisplay $BlackViperItems $Back_Viper
        If($Invalid -eq 1){
            Write-host ""
            Write-host "Invalid Input" -ForegroundColor Red -BackgroundColor Black -NoNewline
            $Invalid = 0
        }
        $Black_Viper_Input = Read-Host "`nChoice"
        switch -regex ($Black_Viper_Input) {
            [0-3] {$ReturnV = $Black_Viper_Input; $Black_Viper_Input = "Out"}
            W {OpenWebsite "http://www.blackviper.com/"}
            B {$Black_Viper_Input = "Out"}
            default {$Invalid = 1}
        }
    }
    Set-Variable -Name "Back_Viper" -Value $ReturnV -Scope Script
    Return
}

function GetServiceNameFull([String]$ServiceN){
    $ServiceR = $ServiceN
    If($ServiceN -eq 'CDPUserSvc_'){
        $ServiceR = Get-Service | Where-Object {$_.Name -like "CDPUserSvc_*"}
    } ElseIf($ServiceN -eq 'PimIndexMaintenanceSvc_'){
        $ServiceR = Get-Service | Where-Object {$_.Name -like "PimIndexMaintenanceSvc_*"}
    }
    Return $ServiceR
}

function ServiceCheck([string] $S_Name, [string]$S_Type, [string]$C_Type) {
    [bool] $ReturnV = $False
    If (Get-WmiObject -Class Win32_Service -Filter "Name='$S_Name'" ) {
        If($S_Type -ne $C_Type){
            $ReturnV = $True
            If($S_Name -eq 'lfsvc'){
                #Has to be removed or cant change service 
                # from disabled to anything else (Known Bug)
                Remove-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\TriggerInfo\3"  -recurse  -Force
            }
        }
    }
    Return $ReturnV
}

function Black_Viper_Set ([Int]$BV){
    If ($WinEdition -eq "Microsoft Windows 10 Home"){
        If ($BV -eq 1){
        } ElseIf ($BV -In 2..3){
            $BV++
        }
    } ElseIf($WinEdition -eq "Microsoft Windows 10 Pro"){
        If ($BV -eq 1){
            $BV++
        } ElseIf ($BV -In 2..3){
            $BV++
        }
    } Else {
        $BV = 9
    }
    Return $BV
}

  ##########
  # Black Viper -End
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
(1,"Telemetry",2,0),
(2,"SmartScreen",2,0),
(3,"LocationTracking",2,0),
(4,"DiagTrack",2,0),
(5,"Cortana",2,0),
(6,"ErrorReporting",2,0),
(7,"WiFiSense",2,0),
(8,"AutoLoggerFile",2,0),
(9,"Feedback",2,0),
(10,"AdvertisingID",2,0),
(11,"CortanaSearch",2,0),
(12,"WAPPush",2,0)
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
(1,"CheckForWinUpdate",2,0),
(2,"WinUpdateDownload",3,0),
(3,"UpdateDriver",2,0),
(4,"AppAutoDownload",2,0),
(5,"WinUpdateType",4,0),
(6,"UpdateMSRT",2,0),
(7,"RestartOnUpdate",2,0)
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
'1. User Agent Control  ','6. Firewall            ',
'2. Admin Shares        ','7. HomeGroups          ',
'3. Windows Defender    ','8. Remote Desktop      ',
'4. Remote Assistance   ','9. Black Viper Setting ',
'5. Sharing Mapped Drive','                       ',
'B. Back to Script Setting Main Menu              '
)

$ServiceTweaksSetMenuItm = (
(1,"UAC",3,0),
(2,"AdminShares",2,0),
(3,"WinDefender",2,0),
(4,"RemoteAssistance",2,0),
(5,"SharingMappedDrives",2,0),
(6,"Firewall",2,0),
(7,"HomeGroups",2,0),
(8,"RemoteDesktop",2,0),
(9,"Black_Viper_Input",3,0)
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
(1,"CastToDevice",2,0),
(2,"IncludeinLibrary",2,0),
(3,"ShareWith",2,0),
(4,"PreviousVersions",2,0),
(5,"PinTo",2,0),
(6,"SendTo",2,0)
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
(1,"StartMenuWebSearch",2,0),
(2,"StartSuggestions",2,0),
(3,"UnpinItems",1,0),
(4,"MostUsedAppStartMenu",2,0),
(5,"RecentItemsFrequent",2,0)
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
(1,"BatteryUIBar",2,0),
(2,"VolumeControlBar",2,0),
(3,"TaskViewButton",2,0),
(4,"TaskbarGrouping",3,0),
(5,"SecondsInClock",2,0),
(6,"TaskBarOnMultiDisplay",2,0),
(7,"ClockUIBar",2,0),
(8,"TaskbarSearchBox",2,0),
(9,"TaskbarIconSize",2,0),
(10,"TrayIcons",2,0),
(11,"LastActiveClick",2,0),
(12,"TaskbarButtOnDisplay",3,0)
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
(1,"FrequentFoldersQikAcc",2,0),
(2,"RecentFileQikAcc",3,0),
(3,"SystemFiles",2,0),
(4,"HiddenFiles",2,0),
(5,"AeroSnap",2,0),
(6,"AeroShake",2,0),
(7,"WinContentWhileDrag",2,0),
(8,"ExplorerOpenLoc",2,0),
(9,"KnownExtensions",2,0),
(10,"Autorun",2,0),
(11,"Autoplay",2,0),
(12,"PidInTitleBar",2,0)
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
(1,"ThisPCOnDesktop",2,0),
(2,"DocumentsIconInThisPC",2,0),
(3,"MusicIconInThisPC",2,0),
(4,"VideosIconInThisPC",2,0),
(5,"DesktopIconInThisPC",2,0),
(6,"DownloadsIconInThisPC",2,0),
(7,"PicturesIconInThisPC",2,0)
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
'1. Lock Screen         ','3. Camera              ',
'2. Power Menu          ','                       ',
'B. Back to Script Setting Main Menu              '
)

$LockScreenSetMenuItm = (
(1,"LockScreen",2,0),
(2,"PowerMenuLockScreen",2,0),
(3,"CameraOnLockScreen",2,0)
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
(1,"ActionCenter",2,0),
(2,"StickyKeyPrompt",2,0),
(3,"NumblockOnStart",2,0),
(4,"F8BootMenu",2,0),
(5,"RemoteUACAcctToken",2,0),
(6,"HibernatePower",2,0),
(7,"SleepPower",2,0),
(8,"PVFileAssociation",2,0),
(9,"PVOpenWithMenu",2,0)
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
(1,"OneDrive",2,0),
(2,"OneDriveInstall",2,0),
(3,"XboxDVR",2,0),
(4,"MediaPlayer",2,0),
(5,"WorkFolders",2,0),
(6,"LinuxSubsystem",2,0)
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
$APList = @()

Get-Variable -scope script | ForEach-Object {
    If($_.name -Match "^APP_*") {
        $APList += $_.name
    }
}

function AllMetroSet([Int]$Number){
    ForEach ($ApL in $APList) {
        Set-Variable -Name $APList -Value $Number -Scope Script;
    }
}

function MetroMenu([Array]$VariDisplay, [Array]$MetroMenuItm) {
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
        If($ConInt -is [int] -and $MetroMenu -ne $null){
            for ($i=0; $i -le $MetroMenuItm.length; $i++) {
                If($MetroMenuItm[$i][0] -eq $ConInt){
                    ChoicesMenuMetro ($MetroMenuItm[$i][1]) ($MetroMenuItm[$i][2])
                    $i = $MetroMenuItm.length +1
                }
            }
        } Else {
            switch ($MetroMenu) {
                B {$MetroMenu = "Out"}
                default {$Invalid = 1}
            }
        }
    }
    Return
}

function ChoicesMenuMetro([String]$Vari, [Int]$MultiV) {
    If($MultiV -eq 0){
        $VariM = -join("APP_",$Vari)
        $VariV = Get-Variable $VariM -valueOnly #Variable
    } ElseIf($MultiV -eq 1){
        $VariM = -join("APP_",$Vari)
        $Vari1 = -join($VariM,"1")
        $Vari2 = -join($VariM,"2")
        $VariV = Get-Variable $Vari1 -valueOnly #Variable
    } ElseIf($MultiV -eq 2){
        $VariM = $Vari
        $VariV = "9"
    }
    $VariJ = -join($Vari,"Items")
    $VariA = Get-Variable $VariJ -valueOnly #Array
    $ChoicesMenuMetro = 'X'
    while($ChoicesMenuMetro -ne "Out"){
        Clear-Host
        ChoicesDisplayMetro $VariA $VariV
        If($Invalid -eq 1){
            Write-host ""
            Write-host "Invalid Selection" -ForegroundColor Red -BackgroundColor Black -NoNewline
            $Invalid = 0
        }
        $ChoicesMenuMetro = Read-Host "`nChoice"
        switch -regex ($ChoicesMenuMetro) {
            [0-3] {$ReturnV = $ChoicesMenuMetro}
            C {$ReturnV = $VariV; $ChoicesMenuMetro = "Out"}
            default {$Invalid = 1}
        }
    }
    If($MultiV -eq 0){
        Set-Variable -Name $VariM -Value $ReturnV -Scope Script
    } ElseIf($MultiV -eq 1){
        Set-Variable -Name $Vari1 -Value $ReturnV -Scope Script
        Set-Variable -Name $Vari2 -Value $ReturnV -Scope Script
    } ElseIf($MultiV -eq 2 -and $ReturnV -ne "9"){
        AllMetroSet $ReturnV
    }
    Return
}

function ChoicesDisplayMetro ([Array]$ChToDisplayMetro, [Int]$ChToDisplayValMetro) {
    TitleBottom $ChToDisplayMetro[0] 11
    DisplayOutMenu "|                                                   |" 14 0 1
    DisplayOutMenu "|  " 14 0 0 ;DisplayOutMenu $ChToDisplayMetro[1] 2 0 0 ;DisplayOutMenu "|" 14 0 1
    DisplayOutMenu "|  " 14 0 0 ;DisplayOutMenu $ChToDisplayMetro[2] 2 0 0 ;DisplayOutMenu "|" 14 0 1
    DisplayOutMenu "|                                                   |" 14 0 1
    DisplayOutMenu "|---------------------------------------------------|" 14 0 1
    DisplayOutMenu "|                                                   |" 14 0 1
    DisplayOutMenu "|  " 14 0 0 ;DisplayOutMenu "0. Skip                                          " 2 0 0 ;DisplayOutMenu "|" 14 0 1
    DisplayOutMenu "|  " 14 0 0 ;DisplayOutMenu "1. Install/Unhide                                " 2 0 0 ;DisplayOutMenu "|" 14 0 1
    DisplayOutMenu "|  " 14 0 0 ;DisplayOutMenu "2. Hide (Current User Only)                      " 2 0 0 ;DisplayOutMenu "|" 14 0 1
    DisplayOutMenu "|  " 14 0 0 ;DisplayOutMenu "3. Uninstall (All users) -Read Note Bellow       " 2 0 0 ;DisplayOutMenu "|" 14 0 1
    DisplayOutMenu "|                                                   |" 14 0 1
    If($ChToDisplayValMetro -ne "9"){
        DisplayOutMenu "|  " 14 0 0 ;DisplayOutMenu "Current Value: " 13 0 0 ;DisplayOutMenu $ChToDisplayValMetro 13 0 0 ;DisplayOutMenu "                                 |" 14 0 1
    }
    DisplayOutMenu "|---------------------------------------------------|" 14 0 1
    DisplayOutMenu "|  " 14 0 0 ;DisplayOutMenu "C. Cancel (Keeps Current Setting)                " 2 0 0 ;DisplayOutMenu "|" 14 0 1
    DisplayOutMenu "|---------------------------------------------------|" 14 0 1
    DisplayOutMenu "| " 14 0 0 ;DisplayOutMenu "Note: Some Uninstalled Apps can be Reinstalled by " 15 0 0 ;DisplayOutMenu "|" 14 0 1
    DisplayOutMenu "| " 14 0 0 ;DisplayOutMenu "      using the windows store. But some can only  " 15 0 0 ;DisplayOutMenu "|" 14 0 1
    DisplayOutMenu "| " 14 0 0 ;DisplayOutMenu "      be reinstalled using another method which   " 15 0 0 ;DisplayOutMenu "|" 14 0 1
    DisplayOutMenu "| " 14 0 0 ;DisplayOutMenu "      this script cannot do.                      " 15 0 0 ;DisplayOutMenu "|" 14 0 1
    DisplayOutMenu "|---------------------------------------------------|" 14 0 1

}

$MetroAppsMenuItems = @(
'              Metro Apps Items Menu              ',
'1. ALL Metro Apps      ','24. Mahjong game       ',
'2. 3DBuilder app       ','25. Maps app           ',
'3. Alarms & Clock app  ','26. Messaging app      ',
'4. Asphalt 8 game      ','27. Microsoft Solitaire',
'5. Bing Money app      ','28. Minecraft game     ',
'6. Bing News app       ','29. Movie Moments app  ',
'7. Bing Sports app     ','30. Netflix app        ',
'8. Bing Translator app ','31. Office OneNote app ',
'9. Bing Weather app    ','32. Office Sway app    ',
'10. Calculator app     ','33. One Connect        ',
'11. Calendar & Mail app','34. People app         ',
'12. Camera app         ','35. Phone app          ',
'13. Candy Crush game   ','36. Phone Companion app',
'14. Canvas app         ','37. Photos app         ',
'15. Facebook app       ','38. Skype App          ',
'16. Farm Ville game    ','39. Sticky Notes app   ',
'17. Feedback Hub       ','40. Sudoku game        ',
'18. Get Office Link    ','41. Taptiles game      ',
'19. Get Started link   ','42. Twitter app        ',
'20. Groove Music app   ','43. Voice Recorder app ',
'21. Houzz app          ','44. Windows Store      ',
'22. Jackpot game       ','45. Wordament game     ',
'23. Jigsaw game        ','46. Xbox app           ',
'B. Back to Script Setting Main Menu              '
)

$MetroAppsMenuItm = (
(1,'ALL_METRO_APPS',2),
(2,'3DBuilder',0),
(3,'WindowsAlarms',0),
(4,'Asphalt8Airborne',0),
(5,'BingFinance',0),
(6,'BingNews',0),
(7,'BingSports',0),
(8,'BingTranslator',0),
(9,'BingWeather',0),
(10,'WindowsCalculator',0),
(11,'Communications',0),
(12,'WindowsCamera',0),
(13,'CandyCrushSoda',0),
(14,'FreshPaint',0),
(15,'Facebook',0),
(16,'FarmVille',0),
(17,'WindowsFeedbak',1),
(18,'MicrosoftOffHub',0),
(19,'Getstarted',0),
(20,'ZuneMusic',1),
(21,'Houzz',0),
(22,'MicrosoftJackpot',0),
(23,'MicrosoftJigsaw',0),
(24,'MicrosoftMahjong',0),
(25,'WindowsMaps',0),
(26,'Messaging',0),
(27,'SolitaireCollect',0),
(28,'MinecraftUWP',0),
(29,'MovieMoments',0),
(30,'Netflix',0),
(31,'OfficeOneNote',0),
(32,'OfficeSway',0),
(33,'OneConnect',0),
(34,'People',0),
(35,'CommsPhone',0),
(36,'WindowsPhone',0),
(37,'Photos',0),
(38,'SkypeApp',1),
(39,'StickyNotes',0),
(40,'MicrosoftSudoku',0),
(41,'Taptiles',0),
(42,'Twitter',0),
(43,'VoiceRecorder',0),
(44,'WindowsStore',0),
(45,'StudiosWordament',0),
(46,'XboxApp',0)
)

$ALL_METRO_APPSItems = @(
'                 ALL Metro Apps                  ',
'                                                 ',
'All Metro Apps are set to your choice            ')

$3DBuilderItems = @(
'                 3DBuilder app                  ',
'View, capture, personalize, and print 3D models ',
'using 3D Builder.                               ')

$WindowsAlarmsItems = @(
'               Alarms & Clock app                ',
'Set alarms & reminders, check times around the   ',
'world, and time your activities, including laps  ')

$Asphalt8AirborneItems = @(
'                 Asphalt 8 game                  ',
'                                                 ',
'A multiplayer racecar game.                      ')

$BingFinanceItems = @(
'                 Bing Money app                  ',
"Know more about your money with the world's best ",
'financial news and data.                         ')

$BingNewsItems = @(
'                  Bing News app                  ',
'                                                 ',
'See the top stories of the day and breaking news.')

$BingSportsItems = @(
'                 Bing Sports app                 ',
'App is packed with live scores & in-depth game   ',
'experiences for more than 150 leagues.           ')

$BingTranslatorItems = @(
'               Bing Translator app               ',
'Translate text or speech, translate conversation,',
' and even download languages to use offline.     ')

$BingWeatherItems = @(
'                Bing Weather app                 ',
"Get the latest weather conditions, whether you're",
'hitting the slopes, or the beach.                ')

$WindowsCalculatorItems = @(
'                 Calculator app                  ',
'Calculator that includes standard, scientific, & ',
'programmer modes, as well as a unit converter.   ')

$CommunicationsItems = @(
'               Calendar & Mail app               ',
'                                                 ',
'                                                 ')

$WindowsCameraItems = @(
'                   Camera app                    ',
'                                                 ',
'                                                 ')

$CandyCrushSodaItems = @(
'                Candy Crush game                 ',
'                                                 ',
'                                                 ')

$FreshPaintItems = @(
'                   Canvas app                    ',
'                                                 ',
'                                                 ')

$FacebookItems = @(
'                  Facebook app                   ',
'                                                 ',
'                                                 ')

$FarmVilleItems = @(
'                 Farm Ville game                 ',
'                                                 ',
'                                                 ')

$WindowsFeedbakItems = @(
'                  Feedback Hub                   ',
'                                                 ',
'Ability to give Feedback to windows or for an APP')

$MicrosoftOffHubItems = @(
'                 Get Office Link                 ',
'Get special offers for Office 365. Office 365    ',
'gives you the latest desktop versions of Office. ')

$GetstartedItems = @(
'                Get Started link                 ',
'                                                 ',
'                                                 ')

$ZuneMusicItems = @(
'                Groove Music app                 ',
'Enjoy all your music on Windows, iOS and Android ',
'devices with Groove.                             ')

$HouzzItems = @(
'                    Houzz app                    ',
'Whether you’re looking to renovate or redecorate,',
'Has everything you need to improve your home.    ')

$MicrosoftJackpotItems = @(
'                  Jackpot game                   ',
'                                                 ',
'Slot Machines.                                   ')

$MicrosoftJigsawItems = @(
'                   Jigsaw game                   ',
'                                                 ',
'                                                 ')

$MicrosoftMahjongItems = @(
'                  Mahjong game                   ',
'                                                 ',
'                                                 ')

$WindowsMapsItems = @(
'                    Maps app                     ',
'Voice navigation & turn-by-turn driving, transit,',
'and walking directions.                          ')

$MessagingItems = @(
'                  Messaging app                  ',
'Microsoft Messaging enables, quick, reliable SMS,',
'MMS and RCS messaging from your phone.           ')

$SolitaireCollectItems = @(
'               Microsoft Solitaire               ',
'                                                 ',
'Collection of different Solitaire like games     ')

$MinecraftUWPItems = @(
'                 Minecraft game                  ',
'                                                 ',
'                                                 ')

$MovieMomentsItems = @(
'                Movie Moments app                ',
'Trim videos to your favorite parts, highlight key',
'moments with captions & effects, and set music.  ')

$NetflixItems = @(
'                   Netflix app                   ',
'                                                 ',
'                                                 ')

$OfficeOneNoteItems = @(
'               Office OneNote app                ',
'                                                 ',
'                                                 ')

$OfficeSwayItems = @(
'                 Office Sway app                 ',
'                                                 ',
'                                                 ')

$OneConnectItems = @(
'                   One Connect                   ',
'                                                 ',
'                                                 ')

$PeopleItems = @(
'                   People app                    ',
'Check out what people are up to across services  ',
'they use &  how you to connect to with them.     ')

$CommsPhoneItems = @(
'                    Phone app                    ',
'                                                 ',
'                                                 ')

$WindowsPhoneItems = @(
'               Phone Companion app               ',
'                                                 ',
'                                                 ')

$PhotosItems = @(
'                   Photos app                    ',
'Enjoy, organize, edit, and share all your digital',
'memories.                                        ')

$SkypeAppItems = @(
'                    Skype App                    ',
'                                                 ',
'                                                 ')

$StickyNotesItems = @(
'                Sticky Notes app                 ',
'                                                 ',
'                                                 ')

$MicrosoftSudokuItems = @(
'                   Sudoku game                   ',
'                                                 ',
'                                                 ')

$TaptilesItems = @(
'                  Taptiles game                  ',
'                                                 ',
'                                                 ')

$TwitterItems = @(
'                   Twitter app                   ',
'                                                 ',
'                                                 ')

$VoiceRecorderItems = @(
'               Voice Recorder app                ',
'Record sounds, lectures, interviews, & events.   ',
'Mark key moments as you record.                  ')

$WindowsStoreItems = @(' Windows Store',
'                                                 ',
'                                                 ')

$StudiosWordamentItems = @(
'                  Wordament game                 ',
'Boggle like game that is a real-time continuous  ',
'word tournament.                                 ')

$XboxAppItems = @(
'                    Xbox app                     ',
'                                                 ',
'                                                 ')

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
    'GAMELOFTSA.Asphalt8Airborne',
    'Microsoft.BingFinance',
    'Microsoft.BingNews',
    'Microsoft.BingSports',
    'Microsoft.BingTranslator',
    'Microsoft.BingWeather',
    'king.com.CandyCrushSodaSaga',
    'Microsoft.CommsPhone',
    'Microsoft.windowscommunicationsapps',
    'Facebook.Facebook',
    'D52A8D61.FarmVille2CountryEscape',
    'Microsoft.FreshPaint',
    'Microsoft.Getstarted',
    '0D16BB98.Houzz',
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
    'Microsoft.MicrosoftStickyNotes',
    'Microsoft.Studios.Wordament',
    'Microsoft.Taptiles',
    '9E2F88E3.Twitter',
    'Microsoft.WindowsSoundRecorder',
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

$Pined_App = @(
    'Mail',
    'Store',
    'Calendar',
    'Microsoft Edge',
    'Photos',
    'Cortana',
    'Weather',
    'Phone Companion',
    'Twitter',
    'Skype Video',
    'Candy Crush Soda Saga',
    'xbox',
    'Groove music',
    'movies & tv',
    'microsoft solitaire collection',
    'money',
    'get office',
    'onenote',
    'news'
)

$CustomSet = 0

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
    $Back_Viper = 1
}

##########
# Pre-Made Settings -End
##########

##########
# Script -Start
##########

Function RunScript {
    If ($CreateRestorePoint -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Creation of System Restore Point..." 15 0
    } ElseIf ($CreateRestorePoint -eq 1) {
        DisplayOut "Creating System Restore Point Named 'Win10 Initial Setup Script'." 15 1
        DisplayOut "Please Wait..." 15 1
        Checkpoint-Computer -Description "Win10 Initial Setup Script" | Out-Null
    }

    $WinEdition = gwmi win32_operatingsystem | % caption
    #Pro = Microsoft Windows 10 Pro
    #Home = Microsoft Windows 10 Home 

    $BuildVer = [environment]::OSVersion.Version.build
    # 14393 = anniversary update
    # 10586 = first major update
    # 10240 = first release
    
    ##########
    # Privacy Settings -Start
    ##########
    
    DisplayOut "" 14 0
    DisplayOut "------------------------" 14 0
    DisplayOut "-   Privacy Settings   -" 14 0
    DisplayOut "------------------------" 14 0
    DisplayOut "" 14 0

    # Telemetry
    If ($Telemetry -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Telemetry..." 15 0
    } ElseIf ($Telemetry -eq 1) {
        DisplayOut "Enabling Telemetry..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 3
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 3
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 3
    } ElseIf ($Telemetry -eq 2) {
        DisplayOut "Disabling Telemetry..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
    }

    # Wi-Fi Sense
    If ($WiFiSense -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Wi-Fi Sense..." 15 0
    } ElseIf ($WiFiSense -eq 1) {
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
    If ($SmartScreen -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping SmartScreen Filter..." 15 0
    } ElseIf ($SmartScreen -eq 1) {
        DisplayOut "Enabling SmartScreen Filter..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Type String -Value "RequireAdmin"
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" -Name "EnableWebContentEvaluation"
    } ElseIf ($SmartScreen -eq 2) {
        DisplayOut "Disabling SmartScreen Filter..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Type String -Value "Off"
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" -Name "EnableWebContentEvaluation" -Type DWord -Value 0
    }    

    # Location Tracking
    If ($LocationTracking -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Location Tracking..." 15 0
    } ElseIf ($LocationTracking -eq 1) {
        DisplayOut "Enabling Location Tracking..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value 1
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Type DWord -Value 1
    } ElseIf ($LocationTracking -eq 2) {
        DisplayOut "Disabling Location Tracking..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value 0
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Type DWord -Value 0
    }

    # Disable Feedback
    If ($Feedback -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Feedback..." 15 0
    } ElseIf ($Feedback -eq 1) {
        DisplayOut "Enabling Feedback..." 11 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod"
    } ElseIf ($Feedback -eq 2) {
        DisplayOut "Disabling Feedback..." 12 0
        If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules")) {
            New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Force | Out-Null
        }
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Type DWord -Value 0
    }

    # Disable Advertising ID
    If ($AdvertisingID -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Advertising ID..." 15 0
    } ElseIf ($AdvertisingID -eq 1) {
        DisplayOut "Enabling Advertising ID..." 11 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled"
    } ElseIf ($AdvertisingID -eq 2) {
        DisplayOut "Disabling Advertising ID..." 12 0
        If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo")) {
            New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" | Out-Null
        }
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Type DWord -Value 0
    }
    
    # Cortana
    If ($Cortana -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Cortana..." 15 0
    } ElseIf ($Cortana -eq 1) {
        DisplayOut "Enabling Cortana..." 11 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy"
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Type DWord -Value 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Type DWord -Value 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -Name "HarvestContacts"
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
    If ($CortanaSearch -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Cortana Search..." 15 0
    } ElseIf ($CortanaSearch -eq 1) {
        DisplayOut "Enabling Cortana Search..." 11 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana"
    } ElseIf ($CortanaSearch -eq 2) {
        DisplayOut "Disabling Cortana Search..." 12 0
        If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Type DWord -Value 0
    }
    
    # Error Reporting
    If ($ErrorReporting -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Error Reporting..." 15 0
    } ElseIf ($ErrorReporting -eq 1) {
        DisplayOut "Enabling Error Reporting..." 11 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled"
    } ElseIf ($ErrorReporting -eq 2) {
        DisplayOut "Disabling Error Reporting..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Type DWord -Value 1
    }
    
    # AutoLogger file and restrict directory
    If ($AutoLoggerFile -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping AutoLogger..." 15 0
    } ElseIf ($AutoLoggerFile -eq 1) {
        DisplayOut "Unrestricting AutoLogger Directory..." 11 0
        $autoLoggerDir = "$env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
        icacls $autoLoggerDir /grant:r SYSTEM:`(OI`)`(CI`)F | Out-Null
    } ElseIf ($AutoLoggerFile -eq 2) {
        DisplayOut "Removing AutoLogger File and Festricting Directory..." 12 0
        $autoLoggerDir = "$env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
        If (Test-Path "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl") {
            Remove-Item "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl"
        }
        icacls $autoLoggerDir /deny SYSTEM:`(OI`)`(CI`)F | Out-Null
    }
    
    # Diagnostics Tracking Service
    If ($DiagTrack -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Diagnostics Tracking..." 15 0
    } ElseIf ($DiagTrack -eq 1) {
        DisplayOut "Enabling and Starting Diagnostics Tracking Service..." 11 0
        Set-Service "DiagTrack" -StartupType Automatic
        Start-Service "DiagTrack"
    } ElseIf ($DiagTrack -eq 2) {
        DisplayOut "Stopping and Disabling Diagnostics Tracking Service..." 12 0
        Stop-Service "DiagTrack"
        Set-Service "DiagTrack" -StartupType Disabled
    }
    
    # WAP Push Service
    If ($WAPPush -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping WAP Push..." 15 0
    } ElseIf ($WAPPush -eq 1) {
        DisplayOut "Enabling and Starting WAP Push Service..." 11 0
        Set-Service "dmwappushservice" -StartupType Automatic
        Start-Service "dmwappushservice"
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\dmwappushservice" -Name "DelayedAutoStart" -Type DWord -Value 1
    } ElseIf ($WAPPush -eq 1) {
        DisplayOut "Disabling WAP Push Service..." 12 0
        Stop-Service "dmwappushservice"
        Set-Service "dmwappushservice" -StartupType Disabled
    }
    
    # App Auto Download
    If ($AppAutoDownload -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping App Auto Download..." 15 0
    } ElseIf ($AppAutoDownload -eq 1) {
        DisplayOut "Enabling App Auto Download..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate" -Name "AutoDownload" -Type DWord -Value 0
        Remove-ItemProperty  -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" 
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
    
    DisplayOut "" 14 0
    DisplayOut "-------------------------------" 14 0
    DisplayOut "-   Windows Update Settings   -" 14 0
    DisplayOut "-------------------------------" 14 0
    DisplayOut "" 14 0
    
    # Check for Windows Update
    If ($CheckForWinUpdate -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Check for Windows Update..." 15 0
    } ElseIf ($CheckForWinUpdate -eq 1) {
        DisplayOut "Enabling Check for Windows Update..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "SetDisableUXWUAccess" -Type DWord -Value 0
    } ElseIf ($CheckForWinUpdate -eq 2) {
        DisplayOut "Disabling Check for Windows Update..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "SetDisableUXWUAccess" -Type DWord -Value 1
    }
    
    # Windows Update Check Type
    If ($WinUpdateType -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Windows Update Check Type..." 15 0
    } ElseIf ($WinUpdateType -In 1..4) {
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
    If ($WinUpdateDownload -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Windows Update P2P..." 15 0
    } ElseIf ($WinUpdateDownload -eq 1) {
        DisplayOut "Unrestricting Windows Update P2P to internet..." 16 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name "DODownloadMode"
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" -Name "SystemSettingsDownloadMode"
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
    
    DisplayOut "" 14 0
    DisplayOut "----------------------" 14 0
    DisplayOut "-   Service Tweaks   -" 14 0
    DisplayOut "----------------------" 14 0
    DisplayOut "" 14 0
    
    
    # UAC level
    If ($UAC -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping UAC Level..." 15 0
    } ElseIf ($UAC -eq 1) {
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
    If ($SharingMappedDrives -eq 0) {
        DisplayOut "Skipping Sharing Mapped Drives between Users..." 15 0
    } ElseIf ($SharingMappedDrives -eq 1) {
        DisplayOut "Enabling Sharing Mapped Drives between Users..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLinkedConnections" -Type DWord -Value 1
    } ElseIf ($SharingMappedDrives -eq 2) {
        DisplayOut "Disabling Sharing Mapped Drives between Users..." 12 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLinkedConnections"
    }
    
    # Administrative shares
    If ($AdminShares -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Hidden Administrative Shares..." 15 0
    } ElseIf ($AdminShares -eq 1) {
        DisplayOut "Enabling Hidden Administrative Shares..." 11 0
        Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "AutoShareWks"
    } ElseIf ($AdminShares -eq 2) {
        DisplayOut "Disabling Hidden Administrative Shares..." 12 0
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "AutoShareWks" -Type DWord -Value 0
    }
    
    # Firewall
    If ($Firewall -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Firewall..." 15 0
    } ElseIf ($Firewall -eq 1) {
        DisplayOut "Enabling Firewall..." 11 0
        Set-NetFirewallProfile -Profile * -Enabled True
    } ElseIf ($Firewall -eq 2) {
        DisplayOut "Disabling Firewall..." 12 0
        Set-NetFirewallProfile -Profile * -Enabled False
    }
    
    # Windows Defender
    If ($WinDefender -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Windows Defender..." 15 0
    } ElseIf ($WinDefender -eq 1) {
        DisplayOut "Enabling Windows Defender..." 11 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "WindowsDefender" -Type ExpandString -Value "`"%ProgramFiles%\Windows Defender\MSASCuiL.exe`""
    } ElseIf ($WinDefender -eq 2) {
        DisplayOut "Disabling Windows Defender..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Type DWord -Value 1
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "WindowsDefender"
    }
    
    # Home Groups services
    If ($HomeGroups -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Home Groups Services..." 15 0
    } ElseIf ($HomeGroups -eq 1) {
        DisplayOut "Enabling Home Groups Services..." 11 0
        Set-Service "HomeGroupListener" -StartupType Manual
        Set-Service "HomeGroupProvider" -StartupType Manual
        Start-Service "HomeGroupProvider"
    } ElseIf ($HomeGroups -eq 2) {
         DisplayOut "Disabling Home Groups Services..." 12 0
        Stop-Service "HomeGroupListener"
        Set-Service "HomeGroupListener" -StartupType Disabled
        Stop-Service "HomeGroupProvider"
        Set-Service "HomeGroupProvider" -StartupType Disabled
    }
    
    # Remote Assistance
    If ($RemoteAssistance -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Remote Assistance..." 15 0
    } ElseIf ($RemoteAssistance -eq 1) {
        DisplayOut "Enabling Remote Assistance..." 11 0
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Type DWord -Value 1
    } ElseIf ($RemoteAssistance -eq 2) {
        DisplayOut "Disabling Remote Assistance..." 12 0
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Type DWord -Value 0
    }
    
    # Enable Remote Desktop w/o Network Level Authentication
    If ($RemoteDesktop -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Remote Desktop..." 15 0
    } ElseIf ($RemoteDesktop -eq 1) {
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
    
    DisplayOut "" 14 0
    DisplayOut "--------------------------" 14 0
    DisplayOut "-   Context Menu Items   -" 14 0
    DisplayOut "--------------------------" 14 0
    DisplayOut "" 14 0
    
    # Cast to Device Context
    If ($CastToDevice -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Cast to Device Context item..." 15 0
    } ElseIf ($CastToDevice -eq 1) {
        DisplayOut "Enabling Cast to Device Context item..." 11 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{7AD84985-87B4-4a16-BE58-8B72A5B390F7}"
    } ElseIf ($CastToDevice -eq 2) {
        DisplayOut "Disabling Cast to Device Context item..." 12 0
        If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked")) {
            New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" | Out-Null
        }
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{7AD84985-87B4-4a16-BE58-8B72A5B390F7}"
    }
    
    # Previous Versions Context Menu
    If ($PreviousVersions -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Previous Versions Context item..." 15 0
    } ElseIf ($PreviousVersions -eq 1) {
        DisplayOut "Enabling Previous Versions Context item..." 11 0
        Set-ItemProperty -Path "HKCR:\ApplicationsAllFilesystemObjects\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Force | Out-Null
        Set-ItemProperty -Path "HKCR:\ApplicationsCLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Force | Out-Null
        Set-ItemProperty -Path "HKCR:\ApplicationsDirectory\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Force | Out-Null
        Set-ItemProperty -Path "HKCR:\ApplicationsDrive\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Force | Out-Null
    } ElseIf ($PreviousVersions -eq 2) {
        DisplayOut "Disabling Previous Versions Context item..." 12 0
        Remove-Item -Path "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Recurse
        Remove-Item -Path "HKCR:\CLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Recurse
        Remove-Item -Path "HKCR:\Directory\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Recurse
        Remove-Item -Path "HKCR:\Drive\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Recurse
    }
    
    # Include in Library Context Menu
    If ($IncludeinLibrary -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Include in Library Context item..." 15 0
    } ElseIf ($IncludeinLibrary -eq 1) {
        DisplayOut "Enabling Include in Library Context item..." 11 0
        Set-ItemProperty -Path "HKCR:\Folder\ShellEx\ContextMenuHandlers\Library Location" -Name "(Default)" -Type String -Value "{3dad6c5d-2167-4cae-9914-f99e41c12cfa}"
    } ElseIf ($IncludeinLibrary -eq 2) {
        DisplayOut "Disabling Include in Library..." 12 0
        Set-ItemProperty -Path "HKCR:\Folder\ShellEx\ContextMenuHandlers\Library Location" -Name "(Default)" -Type String -Value ""
    }
    
    # Pin To Context Menu
    If ($PinTo -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Pin To Context item..." 15 0
    } ElseIf ($PinTo -eq 1) {
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
        Remove-Item -LiteralPath "HKCR:\*\shellex\ContextMenuHandlers\{90AA3A4E-1CBA-4233-B8BB-535773D48449}" -Force
        Remove-Item -LiteralPath "HKCR:\*\shellex\ContextMenuHandlers\{a2a9545d-a0c2-42b4-9708-a0b2badd77c8}" -Force
        Set-ItemProperty -Path "HKCR:\Folder\shellex\ContextMenuHandlers\PintoStartScreen" -Name "(Default)" -Type String -Value ""
        Set-ItemProperty -Path "HKCR:\exefile\shellex\ContextMenuHandlers\PintoStartScreen" -Name "(Default)" -Type String -Value ""
        Set-ItemProperty -Path "HKCR:\Microsoft.Website\shellex\ContextMenuHandlers\PintoStartScreen" -Name "(Default)" -Type String -Value ""
        Set-ItemProperty -Path "HKCR:\mscfile\shellex\ContextMenuHandlers\PintoStartScreen" -Name "(Default)" -Type String -Value ""
    }
    
    # Share With Context Menu
    If ($ShareWith -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Share With Context item..." 15 0
    } ElseIf ($ShareWith -eq 1) {
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
    If ($SendTo -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Send To Context item..." 15 0
    } ElseIf ($SendTo -eq 1) {
        DisplayOut "Enabling Send To Context item..." 11 0
        If (!(Test-Path "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo")) {
            New-Item -Path "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo"
        }
        Set-ItemProperty -Path "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo" -Name "(Default)" -Type String -Value "{7BA4C740-9E81-11CF-99D3-00AA004AE837}" | Out-Null
    } ElseIf ($SendTo -eq 2) {
        DisplayOut "Disabling Send To Context item..." 12 0
        If (Test-Path "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo") {
            Remove-Item -Path "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo"
        }
    }
    
    ##########
    # Context Menu Items -End
    ##########
    
    ##########
    # Task Bar Items -Start
    ##########
    
    DisplayOut "" 14 0
    DisplayOut "----------------------" 14 0
    DisplayOut "-   Task Bar Items   -" 14 0
    DisplayOut "----------------------" 14 0
    DisplayOut "" 14 0
    
    # Battery UI Bar
    If ($BatteryUIBar -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Battery UI Bar..." 15 0
    } ElseIf ($BatteryUIBar -eq 1) {
        DisplayOut "Enabling New Battery UI Bar..." 16 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" -Name "UseWin32BatteryFlyout"
    } ElseIf ($BatteryUIBar -eq 2) {
        DisplayOut "Enabling Old Battery UI Bar..." 16 0
        If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell")) {
            New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" | Out-Null
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" -Name "UseWin32BatteryFlyout" -Type DWord -Value 1
    }
    
    # Clock UI Bar
    If ($ClockUIBar -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Clock UI Bar..." 15 0
    } ElseIf ($ClockUIBar -eq 1) {
        DisplayOut "Enabling New Clock UI Bar..." 16 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" -Name "UseWin32TrayClockExperience"
    } ElseIf ($ClockUIBar -eq 2) {
        DisplayOut "Enabling Old Clock UI Bar..." 16 0
        If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell")) {
            New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" | Out-Null
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" -Name "UseWin32TrayClockExperience" -Type DWord -Value 1
    }
         
    # Volume Control Bar
    If ($VolumeControlBar -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Volume Control Bar..." 15 0
    } ElseIf ($VolumeControlBar -eq 1) {
        DisplayOut "Enabling New Volume Control Bar (Horizontal)..." 16 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC" -Name "EnableMtcUvc"
    } ElseIf ($VolumeControlBar -eq 2) {
        DisplayOut "Enabling Classic Volume Control Bar (Vertical)..." 16 0
        If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC")) {
            New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC" | Out-Null
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC" -Name "EnableMtcUvc" -Type DWord -Value 0
    }
    
    # Taskbar Search button / box
    If ($TaskbarSearchBox -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Taskbar Search box / button..." 15 0
    } ElseIf ($TaskbarSearchBox -eq 1) {
        DisplayOut "Showing Taskbar Search box / button..." 11 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode"
    } ElseIf ($TaskbarSearchBox -eq 2) {
        DisplayOut "Hiding Taskbar Search box / button..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 0
    }
    
    # Task View button
    If ($TaskViewButton -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Task View button..." 15 0
    } ElseIf ($TaskViewButton -eq 1) {
        DisplayOut "Showing Task View button..." 11 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton"
    } ElseIf ($TaskViewButton -eq 2) {
        DisplayOut "Hiding Task View button..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0
    }
    
    # Taskbar Icon Size
    If ($TaskbarIconSize -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Icon Size in Taskbar..." 15 0
    } ElseIf ($TaskbarIconSize -eq 1) {
        DisplayOut "Showing Normal Icon Size in Taskbar..." 11 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSmallIcons"
    } ElseIf ($TaskbarIconSize -eq 2) {
        DisplayOut "Showing Smaller Icons in Taskbar..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSmallIcons" -Type DWord -Value 1
    }
    
    # Taskbar Item Grouping
    If ($TaskbarGrouping -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Taskbar Item Grouping..." 15 0
    } ElseIf ($TaskbarGrouping -eq 1) {
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
    If ($TrayIcons -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Tray icons..." 15 0
    } ElseIf ($TrayIcons -eq 1) {
        DisplayOut "Showing All Tray Icons..." 11 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -Type DWord -Value 0
    } ElseIf ($TrayIcons -eq 2) {
        DisplayOut "Hiding Tray Icons..." 12 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray"
    }
    
    # Seconds in Taskbar Clock
    If ($SecondsInClock -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Seconds in Taskbar Clock..." 15 0
    } ElseIf ($SecondsInClock -eq 1) {
        DisplayOut "Showing Seconds in Taskbar Clock..." 16 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSecondsInSystemClock" -Type DWord -Value 1
    } ElseIf ($SecondsInClock -eq 2) {
        DisplayOut "Hiding Seconds in Taskbar Clock..." 16 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSecondsInSystemClock" -Type DWord -Value 0
    }
    
    # Last Active Click
    If ($LastActiveClick -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Last Active Click..." 15 0
    } ElseIf ($LastActiveClick -eq 1) {
        DisplayOut "Enabling Last Active Click..." 11 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LastActiveClick" -Type DWord -Value 1
    } ElseIf ($LastActiveClick -eq 2) {
        DisplayOut "Disabling Last Active Click..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LastActiveClick" -Type DWord -Value 0
    }
    
    # Taskbar on multiple displays
    If ($TaskBarOnMultiDisplay -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Taskbar on Multiple Displays..." 15 0
    } ElseIf ($TaskBarOnMultiDisplay -eq 1) {
        DisplayOut "Showing Taskbar on Multiple Displays..." 11 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "MMTaskbarEnabled" -Type DWord -Value 1
    } ElseIf ($TaskBarOnMultiDisplay -eq 2) {
        DisplayOut "Hiding Taskbar on Multiple Displays..." 12 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "MMTaskbarEnabled" -Type DWord -Value 0
    }
    
    # Taskbar on multiple displays
    If ($TaskbarButtOnDisplay -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Taskbar Buttons on Multiple Displays..." 15 0
    } ElseIf ($TaskbarButtOnDisplay -eq 1) {
        DisplayOut "Showing Taskbar Buttons on All Taskbars..." 16 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "MMTaskbarMode" -Type DWord -Value 0
    } ElseIf ($TaskbarButtOnDisplay -eq 2) {
        DisplayOut "Showing Taskbar Buttons on Taskbar where Window is open..." 16 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "MMTaskbarMode" -Type DWord -Value 2
    } ElseIf ($TaskbarButtOnDisplay -eq 3) {
        DisplayOut "Showing Taskbar Buttons on Main Taskbar and where Window is open..." 16 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "MMTaskbarMode" -Type DWord -Value 1
    }
    
    ##########
    # Task Bar Items -End
    ##########
    
    ##########
    # Star Menu Items -Start
    ##########
    
    DisplayOut "" 14 0
    DisplayOut "-----------------------" 14 0
    DisplayOut "-   Star Menu Items   -" 14 0
    DisplayOut "-----------------------" 14 0
    DisplayOut "" 14 0
    
    # Web Search in Start Menu
    If ($StartMenuWebSearch -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Bing Search in Start Menu..." 15 0
    } ElseIf ($StartMenuWebSearch -eq 1) {
        DisplayOut "Enabling Bing Search in Start Menu..." 11 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled"
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "DisableWebSearch"
    } ElseIf ($StartMenuWebSearch -eq 2) {
        DisplayOut "Disabling Bing Search in Start Menu..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Type DWord -Value 0
        If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "DisableWebSearch" -Type DWord -Value 1
    }
    
    # Start Menu suggestions
    If ($StartSuggestions -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Start Menu Suggestions..." 15 0
    } ElseIf ($StartSuggestions -eq 1) {
        DisplayOut "Enabling Start Menu Suggestions..." 11 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 1
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Type DWord -Value 1
    } ElseIf ($StartSuggestions -eq 2) {
        DisplayOut "Disabling Start Menu Suggestions..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Type DWord -Value 0
    }
    
    # Most used apps in Start menu
    If ($MostUsedAppStartMenu -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Most used Apps in Start Menu..." 15 0
    } ElseIf ($MostUsedAppStartMenu -eq 1) {
        DisplayOut "Showing Most used Apps in Start Menu..." 11 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackProgs" -Type DWord -Value 1
    } ElseIf ($MostUsedAppStartMenu -eq 2) {
        DisplayOut "Hiding Most used Apps in Start Menu..." 12 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackProgs" -Type DWord -Value 0
    }
    
    # Recent Items and Frequent Places
    If ($RecentItemsFrequent -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Recent Items and Frequent Places..." 15 0
    } ElseIf ($RecentItemsFrequent -eq 1) {
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
    
    DisplayOut "" 14 0
    DisplayOut "----------------------" 14 0
    DisplayOut "-   Explorer Items   -" 14 0
    DisplayOut "----------------------" 14 0
    DisplayOut "" 14 0
    
    # Process ID on Title Bar
    If ($PidInTitleBar -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Process ID on Title Bar..." 15 0
    } ElseIf ($PidInTitleBar -eq 1) {
        DisplayOut "Showing Process ID on Title Bar..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowPidInTitle" -Type DWord -Value 1
    } ElseIf ($PidInTitleBar -eq 2) {
        DisplayOut "Hiding Process ID on Title Bar..." 12 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowPidInTitle"
    }
    
    # Aero Snap
    If ($AeroSnap -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Aero Snap..." 15 0
    } ElseIf ($AeroSnap -eq 1) {
        DisplayOut "Enabling Aero Snap..." 11 0
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WindowArrangementActive" -Type DWord -Value 1
    } ElseIf ($AeroSnap -eq 2) {
        DisplayOut "Disabling Aero Snap..." 12 0
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WindowArrangementActive" -Type DWord -Value 0
    }
    
    # Aero Shake
    If ($AeroShake -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Aero Shake..." 15 0
    } ElseIf ($AeroShake -eq 1) {
        DisplayOut "Enabling Aero Shake..." 11 0
        Remove-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Name "NoWindowMinimizingShortcuts"
    } ElseIf ($AeroShake -eq 2) {
        DisplayOut "Disabling Aero Shake..." 12 0
        If (!(Test-Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer")) {
            New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" | Out-Null
        }
        Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Name "NoWindowMinimizingShortcuts" -Type DWord -Value 1
    }
    
    # File extensions
    If ($KnownExtensions -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Known File Extensions..." 15 0
    } ElseIf ($KnownExtensions -eq 1) {
        DisplayOut "Showing Known File Extensions..." 11 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 0
    } ElseIf ($KnownExtensions -eq 2) {
        DisplayOut "Hiding Known File Extensions..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 1
    }
    
    # Hidden files
    If ($HiddenFiles -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Hidden Files..." 15 0
    } ElseIf ($HiddenFiles -eq 1) {
        DisplayOut "Showing Hidden Files..." 11 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Type DWord -Value 1
    } ElseIf ($HiddenFiles -eq 2) {
        DisplayOut "Hiding Hidden Files..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Type DWord -Value 2
    }
    
    # System files
    If ($SystemFiles -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping System Files..." 15 0
    } ElseIf ($SystemFiles -eq 1) {
        DisplayOut "Showing System Files..." 11 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSuperHidden" -Type DWord -Value 1
    } ElseIf ($SystemFiles -eq 2) {
        DisplayOut "Hiding System fFiles..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSuperHidden" -Type DWord -Value 0
    }
    
    # Change default Explorer view
    If ($ExplorerOpenLoc -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Default Explorer view to Quick Access..." 15 0
    } ElseIf ($ExplorerOpenLoc -eq 1) {
        DisplayOut "Changing Default Explorer view to Quick Access..." 16 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo"
    } ElseIf ($ExplorerOpenLoc -eq 2) {
        DisplayOut "Changing Default Explorer view to This PC..." 16 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1
    }
    
    # Recent Files in Quick Access
    If ($RecentFileQikAcc -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Recent Files in Quick Access..." 15 0
    } ElseIf ($RecentFileQikAcc -eq 1) {
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
        Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HomeFolderDesktop\NameSpace\DelegateFolders\{3134ef9c-6b18-4996-ad04-ed5912e00eb5}" -Recurse
        Remove-Item -Path "HKLM:SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\HomeFolderDesktop\NameSpace\DelegateFolders\{3134ef9c-6b18-4996-ad04-ed5912e00eb5}" -Recurse
    }
    
    # Frequent folders in Quick_access
    If ($FrequentFoldersQikAcc -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Frequent Folders in Quick Access..." 15 0
    } ElseIf ($FrequentFoldersQikAcc -eq 1) {
        DisplayOut "Showing Frequent Folders in Quick Access..." 11 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowFrequent" -Type DWord -Value 1
    } ElseIf ($FrequentFoldersQikAcc -eq 2) {
        DisplayOut "Hiding Frequent Folders in Quick Access..." 12 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowFrequent" -Type DWord -Value 0
    }
    
    # Window Content while Dragging
    If ($WinContentWhileDrag -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Window Content while Dragging..." 15 0
    } ElseIf ($WinContentWhileDrag -eq 1) {
        DisplayOut "Showing Window Content while Dragging..." 11 0
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "DragFullWindows" -Type DWord -Value 1
    } ElseIf ($WinContentWhileDrag -eq 2) {
        DisplayOut "Hiding Window Content while Dragging..." 12 0
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "DragFullWindows" -Type DWord -Value 0
    }
    
    # Autoplay
    If ($Autoplay -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Autoplay..." 15 0
    } ElseIf ($Autoplay -eq 1) {
        DisplayOut "Enabling Autoplay..." 11 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 0
    } ElseIf ($Autoplay -eq 2) {
        DisplayOut "Disabling Autoplay..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 1
    }
    
    # Autorun for all drives
    If ($Autorun -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Autorun for all Drives..." 15 0
    } ElseIf ($Autorun -eq 1) {
        DisplayOut "Enabling Autorun for all Drives..." 11 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun"
    } ElseIf ($Autorun -eq 2) {
        DisplayOut "Disabling Autorun for all Drives..." 12 0
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
    
    DisplayOut "" 14 0
    DisplayOut "-----------------------" 14 0
    DisplayOut "-   'This PC' items   -" 14 0
    DisplayOut "-----------------------" 14 0
    DisplayOut "" 14 0
    
    # Show This PC shortcut on desktop
    If ($ThisPCOnDesktop -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping This PC Shortcut on Desktop..." 15 0
    } ElseIf ($ThisPCOnDesktop -eq 1) {
        DisplayOut "Showing This PC Shortcut on Desktop..." 11 0
        If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu")) {
            New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" | Out-Null
        }
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Type DWord -Value 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Type DWord -Value 0
    } ElseIf ($ThisPCOnDesktop -eq 2) {
        DisplayOut "Hiding This PC Shortcut on Desktop..." 12 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
    }    
    
    # Desktop Icon in This PC
    If ($DesktopIconInThisPC -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Desktop Icon in This PC..." 15 0
    } ElseIf ($DesktopIconInThisPC -eq 1) {
        DisplayOut "Showing Desktop Icon in This PC..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
    } ElseIf ($DesktopIconInThisPC -eq 2) {
        DisplayOut "Hiding Desktop icon from This PC..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
    }
    
    # Documents Icon in This PC
    If ($DocumentsIconInThisPC -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Documents Icon in This PC..." 15 0
    } ElseIf ($DocumentsIconInThisPC -eq 1) {
        DisplayOut "Showing Documents Icon in This PC..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
    }ElseIf ($DocumentsIconInThisPC -eq 2) {
        DisplayOut "Hiding Documents icon from This PC..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
    }
    
    # Downloads icon from This PC
    If ($DownloadsIconInThisPC -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Downloads Icon in This PC..." 15 0
    } ElseIf ($DownloadsIconInThisPC -eq 1) {
        DisplayOut "Showing Downloads Icon in This PC..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
    } ElseIf ($DownloadsIconInThisPC -eq 2) {
        DisplayOut "Hiding Downloads icon from This PC..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
    }
    
    # Music icon from This PC
    If ($MusicIconInThisPC -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Music Icon in This PC..." 15 0
    } ElseIf ($MusicIconInThisPC -eq 1) {
        DisplayOut "Showing Music Icon in This PC..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
    } ElseIf ($MusicIconInThisPC -eq 2) {
        DisplayOut "Hiding Music icon from This PC..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
    }
    
    # Pictures icon from This PC
    If ($PicturesIconInThisPC -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Pictures Icon in This PC..." 15 0
    } ElseIf ($PicturesIconInThisPC -eq 1) {
        DisplayOut "Showing Pictures Icon in This PC..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
    } ElseIf ($PicturesIconInThisPC -eq 2) {
        DisplayOut "Hiding Pictures icon from This PC..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
    }
    
    # Hide Videos icon from This PC
    If ($VideosIconInThisPC -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Videos Icon in This PC..." 15 0
    } ElseIf ($VideosIconInThisPC -eq 1) {
        DisplayOut "Showing Videos Icon in This PC..." 11 0
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
 
    DisplayOut "" 14 0
    DisplayOut "-----------------------------" 14 0
    DisplayOut "-   Photo Viewer Settings   -" 14 0
    DisplayOut "-----------------------------" 14 0
    DisplayOut "" 14 0
    
    # Photo Viewer association for bmp, gif, jpg, png and tif
    If ($PVFileAssociation -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Photo Viewer File Association..." 15 0
    } ElseIf ($PVFileAssociation -eq 1) {
        DisplayOut "Setting Photo Viewer File Association for bmp, gif, jpg, png and tif..." 11 0
        ForEach ($type in @("Paint.Picture", "giffile", "jpegfile", "pngfile")) {
            New-Item -Path $("HKCR:\$type\shell\open") -Force | Out-Null
            New-Item -Path $("HKCR:\$type\shell\open\command") | Out-Null
            Set-ItemProperty -Path $("HKCR:\$type\shell\open") -Name "MuiVerb" -Type ExpandString -Value "@%ProgramFiles%\Windows Photo Viewer\photoviewer.dll,-3043"
            Set-ItemProperty -Path $("HKCR:\$type\shell\open\command") -Name "(Default)" -Type ExpandString -Value "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1"
        }
    } ElseIf ($PVFileAssociation -eq 2) {
        DisplayOut "Unsetting Photo Viewer File Association for bmp, gif, jpg, png and tif..." 12 0
        If (Test-Path "HKCR:\Paint.Picture\shell\open") {
            Remove-Item -Path "HKCR:\Paint.Picture\shell\open" -Recurse
        }
        Remove-ItemProperty -Path "HKCR:\giffile\shell\open" -Name "MuiVerb"
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
    If ($PVOpenWithMenu -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Photo Viewer Open with Menu..." 15 0
    } ElseIf ($PVOpenWithMenu -eq 1) {
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
    
    DisplayOut "" 14 0
    DisplayOut "------------------------" 14 0
    DisplayOut "-   Lockscreen Items   -" 14 0
    DisplayOut "------------------------" 14 0
    DisplayOut "" 14 0
    
    # Lock screen
    If ($LockScreen -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Lock Screen..." 15 0
    } ElseIf ($LockScreen -eq 1) {
        If ($BuildVer -eq 10240 -or $BuildVer -eq 10586){
            DisplayOut "Enabling Lock Screen..." 11 0
            Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "NoLockScreen"
        } ElseIf ($BuildVer -eq 14393){
            DisplayOut "Enabling Lock screen (removing scheduler workaround)..." 11 0
            Unregister-ScheduledTask -TaskName "Disable LockScreen" -Confirm:$false
        } Else {
            DisplayOut "Unable to Disable Lock screen..." 12 0
        }
    } ElseIf ($LockScreen -eq 2) {
        If ($BuildVer -eq 10240 -or $BuildVer -eq 10586){
            DisplayOut "Disabling Lock Screen..." 12 0
            If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization")) {
                New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" | Out-Null
            }
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "NoLockScreen" -Type DWord -Value 1
        } ElseIf ($BuildVer -eq 14393){
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
        } Else {
            DisplayOut "Unable to Disable Lock screen..." 12 0
        }
    }
    
    # Power Menu on Lock Screen
    If ($PowerMenuLockScreen -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Power Menu on Lock Screen..." 15 0
    } ElseIf ($PowerMenuLockScreen -eq 1) {
        DisplayOut "Showing Power Menu on Lock Screen..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "shutdownwithoutlogon" -Type DWord -Value 1
    } ElseIf ($PowerMenuLockScreen -eq 2) {
        DisplayOut "Hiding Power Menu on Lock Screen..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "shutdownwithoutlogon" -Type DWord -Value 0
    }
    
    # Camera at Lockscreen
    If ($CameraOnLockscreen -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Camera at Lockscreen..." 15 0
    } ElseIf ($CameraOnLockscreen -eq 1) {
        DisplayOut "Enabling Camera at Lockscreen..." 11 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "NoLockScreenCamera"
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
    
    DisplayOut "" 14 0
    DisplayOut "------------------" 14 0
    DisplayOut "-   Misc Items   -" 14 0
    DisplayOut "------------------" 14 0
    DisplayOut "" 14 0
    
    # Action Center
    If ($ActionCenter -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Action Center..." 15 0
    } ElseIf ($ActionCenter -eq 1) {
        DisplayOut "Enabling Action Center..." 11 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "DisableNotificationCenter"
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled"
    } ElseIf ($ActionCenter -eq 2) {
        DisplayOut "Disabling Action Center..." 12 0
        If (!(Test-Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer")) {
            New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" | Out-Null
        }
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "DisableNotificationCenter" -Type DWord -Value 1
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -Type DWord -Value 0
    }
    
    # Sticky keys prompt
    If ($StickyKeyPrompt -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Sticky Keys Prompt..." 15 0
    } ElseIf ($StickyKeyPrompt -eq 1) {
        DisplayOut "Enabling Sticky Keys Prompt..." 11 0
        Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "510"
    } ElseIf ($StickyKeyPrompt -eq 2) {
        DisplayOut "Disabling Sticky Keys Prompt..." 12 0
        Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "506"
    }
    
    # Num Lock after startup
    If ($NumblockOnStart -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Num Lock after startup..." 15 0
    } ElseIf ($NumblockOnStart -eq 1) {
        DisplayOut "Enabling Num Lock after startup..." 11 0
        Set-ItemProperty -Path "HKU:\.DEFAULT\Control Panel\Keyboard" -Name "InitialKeyboardIndicators" -Type DWord -Value 2147483650
    } ElseIf ($NumblockOnStart -eq 2) {
        DisplayOut "Disabling Num Lock after startup..." 12 0
        Set-ItemProperty -Path "HKU:\.DEFAULT\Control Panel\Keyboard" -Name "InitialKeyboardIndicators" -Type DWord -Value 2147483648
    }
    
    # Enable F8 boot menu options
    If ($F8BootMenu -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping F8 boot menu options..." 15 0
    } ElseIf ($F8BootMenu -eq 1) {
        DisplayOut "Enabling F8 boot menu options..." 11 0
        bcdedit /set `{current`} bootmenupolicy Legacy | Out-Null
    } ElseIf ($F8BootMenu -eq 2) {
        DisplayOut "Disabling F8 boot menu options..." 12 0
        bcdedit /set `{current`} bootmenupolicy Standard | Out-Null
    }
    
    # Remote UAC Local Account Token Filter
    If ($RemoteUACAcctToken -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Remote UAC Local Account Token Filter..." 15 0
    } ElseIf ($RemoteUACAcctToken -eq 1) {
        DisplayOut "Enabling Remote UAC Local Account Token Filter..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "LocalAccountTokenFilterPolicy" -Type DWord -Value 1
    } ElseIf ($RemoteUACAcctToken -eq 2) {
        DisplayOut "Disabling  Remote UAC Local Account Token Filter..." 12 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "LocalAccountTokenFilterPolicy"
    }
    
    # Hibernate Option
    If ($HibernatePower -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Hibernate Option..." 15 0
    } ElseIf ($HibernatePower -eq 1) {
        DisplayOut "Enabling Hibernate Option..." 11 0
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power" -Name "HibernateEnabled" -Type DWord -Value 1
    } ElseIf ($HibernatePower -eq 2) {
        DisplayOut "Disabling Hibernate Option..." 12 0
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power" -Name "HibernateEnabled" -Type DWord -Value 0
    }
    
    # Sleep Option
    If ($SleepPower -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Sleep Option..." 15 0
    } ElseIf ($SleepPower -eq 1) {
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
    
    DisplayOut "" 14 0
    DisplayOut "-------------------------" 14 0
    DisplayOut "-   Application Items   -" 14 0
    DisplayOut "-------------------------" 14 0
    DisplayOut "" 14 0
    
    # OneDrive
    If ($OneDrive -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping OneDrive..." 15 0
    } ElseIf ($OneDrive -eq 1) {
        DisplayOut "Enabling OneDrive..." 11 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC"
    } ElseIf ($OneDrive -eq 2) {
        DisplayOut "Disabling OneDrive..." 12 0
        If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" | Out-Null
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Type DWord -Value 1
    }
    
    # OneDrive Install
    If ($OneDriveInstall -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping OneDrive Installing..." 15 0
    } ElseIf ($OneDriveInstall -eq 1) {
        DisplayOut "Installing OneDrive..." 11 0
        If($OSType -eq 64) {
            $onedriveS = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
        } Else {
            $onedriveS = "$env:SYSTEMROOT\System32\OneDriveSetup.exe"
        }
        Start-Process $onedriveS -NoNewWindow
    } ElseIf ($OneDriveInstall -eq 2) {
        DisplayOut "Uninstalling OneDrive..." 15 0
        Stop-Process -Name OneDrive
        Start-Sleep -s 3
        If($OSType -eq 64) {
            $onedriveS = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
        } Else {
            $onedriveS = "$env:SYSTEMROOT\System32\OneDriveSetup.exe"
        }
        Start-Process $onedriveS "/uninstall" -NoNewWindow -Wait | Out-Null
        Start-Sleep -s 3
        Stop-Process -Name explorer
        Start-Sleep -s 3
        Remove-Item "$env:USERPROFILE\OneDrive" -Force -Recurse
        Remove-Item "$env:LOCALAPPDATA\Microsoft\OneDrive" -Force -Recurse
        Remove-Item "$env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse
        If (Test-Path "$env:SYSTEMDRIVE\OneDriveTemp") {
            Remove-Item "$env:SYSTEMDRIVE\OneDriveTemp" -Force -Recurse
        }
        Remove-Item -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Recurse
        Remove-Item -Path "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Recurse
    }
    
    # Xbox DVR
    If ($XboxDVR -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Xbox DVR..." 15 0
    } ElseIf ($XboxDVR -eq 1) {
        DisplayOut "Enabling Xbox DVR..." 11 0
        Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Type DWord -Value 1
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR"
    } ElseIf ($XboxDVR -eq 2) {
        DisplayOut "Disabling Xbox DVR..." 12 0
        Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Type DWord -Value 0
        If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" | Out-Null
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Type DWord -Value 0
    }
    
    # Windows Media Player
    If ($MediaPlayer -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Windows Media Player..." 15 0
    } ElseIf ($MediaPlayer -eq 1) {
        DisplayOut "Installing Windows Media Player..." 11 0
        dism /online /Enable-Feature /FeatureName:MediaPlayback /Quiet /NoRestart
    } ElseIf ($MediaPlayer -eq 2) {
        DisplayOut "Uninstalling Windows Media Player..." 14 0
        dism /online /Disable-Feature /FeatureName:MediaPlayback /Quiet /NoRestart
    }
    
    # Work Folders Client
    If ($WorkFolders -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Work Folders Client..." 15 0
    } ElseIf ($WorkFolders -eq 1) {
        DisplayOut "Installing Work Folders Client..." 11 0
        dism /online /Enable-Feature /FeatureName:WorkFolders-Client /Quiet /NoRestart
    } ElseIf ($WorkFolders -eq 2) {
        DisplayOut "Uninstalling Work Folders Client..." 14 0
        dism /online /Disable-Feature /FeatureName:WorkFolders-Client /Quiet /NoRestart
    }
    
    # Install Linux Subsystem - Applicable to RS1 or newer
    If ($BuildVer -ge 14393) {
        If ($LinuxSubsystem -eq 0 -and $ShowSkipped -eq 1) {
            DisplayOut "Skipping Linux Subsystem..." 15 0
        } ElseIf ($LinuxSubsystem -eq 1) {
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
    } ElseIf ($LinuxSubsystem -ne 0) {
        DisplayOut "Windows 10 Build isn't new enough for Linux Subsystem..." 14 0
    }
    
    ##########
    # Application Items -end
    ##########
    
    ##########
    # Metro App Items -Start
    ##########
    
    # Sorts the apps to Install, Hide or Uninstall
    $APPProcess = Get-Variable -Name "APP_*" -ValueOnly  -Scope Script

    $A = 0
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
    
    DisplayOut "" 14 0
    DisplayOut "-----------------------" 14 0
    DisplayOut "-   Metro App Items   -" 14 0
    DisplayOut "-----------------------" 14 0
    DisplayOut "" 14 0
    
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
    DisplayOut "" 14 0
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
    # Metro App Items -End
    ##########
    
    ##########
    # Unpin App Items -Start
    ##########
    
    If ($Unpin -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Unpinning Items..." 15 0
    } ElseIf ($Unpin -eq 1){
        DisplayOut "" 12 0
        DisplayOut "Unpinning Items..." 12 0
        DisplayOut "------------------" 12 0
        DisplayOut "" 14 0
        ForEach ($Pin in $Pined_App) {
            Pin-App $Pin
        }
    }

    ##########
    # Unpin App Items -End
    ##########
  
    ##########
    # Black Viper -Start
    ##########

    DisplayOut "" 14 0
    DisplayOut "----------------------------" 14 0
    DisplayOut "-   Black Viper Services   -" 14 0
    DisplayOut "----------------------------" 14 0
    DisplayOut "" 14 0
    
    $Back_Viper = Black_Viper_Set $Back_Viper
    write-host $Back_Viper
    
    If ($Back_Viper -eq 0 -and $ShowSkipped -eq 1) {
        DisplayOut "Skipping Black Viper Services..." 15 0
    } ElseIf($Back_Viper -In 1..4) {    
        DisplayOut "" 14 0
        DisplayOut "Changing Services..." 12 0
        DisplayOut "--------------------" 12 0
        DisplayOut "" 14 0

        for ($i=0; $i -ne $ServiceLen; $i++) {
            write-host "Test = $i"
            $ServiceT = $ServicesList[$i][$Back_Viper]
            $ServiceName = $ServicesList[$i][0]
            $ServiceNameFull = GetServiceNameFull $ServiceName
            $ServiceType = $ServicesTypeList[$ServiceT]
            $ServiceCurrType = (Get-Service $ServiceNameFull).StartType
            If ((ServiceCheck $ServiceNameFull $ServiceType $ServiceCurrType) -eq $True){
                $DispTemp = "$ServiceNameFull - $ServiceCurrType -> $ServiceType"
                If($ServiceT -In 1..3){
                    DisplayOut $DispTemp  11 0
                    Set-Service $ServiceNameFull -StartupType $ServiceType
                } ElseIf($ServiceT -eq 4){
                    $DispTemp = "$DispTemp (Delayed Start)"
                    DisplayOut $DispTemp  11 0
                    Set-Service $ServiceNameFull -StartupType $ServiceType
                    $RegPath = "HKLM\System\CurrentControlSet\Services\"+($ServiceNameFull)
                    Set-ItemProperty -Path $RegPath -Name "DelayedAutostart" -Type DWORD -Value 1
                }
            } Else {
                $DispTemp = "$ServiceNameFull is already $ServiceType"
                DisplayOut $DispTemp  15 0
            }
        }
    } ElseIf($Back_Viper -eq 9) {
        Write-Host ""
        Write-Host "Not a Valid OS for Black Viper's Service Settings."  -ForegroundColor Red -BackgroundColor Black
        Write-Host "Win 10 Home and Pro Only"
        Write-Host ""
    }
    
    ##########
    # Black Viper -End
    ##########
    
    Remove-Variable -Name filebase -scope global
    If ($Restart -eq 1) {
        #Clear-Host
        Write-Host ""
        $Seconds = 10
        Write-Host "Restarting Computer in 10 Seconds..." -ForegroundColor Yellow -BackgroundColor Black
        $Message = "Restarting in"
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

# Used to get all values BEFORE any defined so
# when exporting shows ALL defined after this point
$AutomaticVariables = Get-Variable

# --------------------------------------------------------------------------

## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## !!!!!!                                                !!!!!!
## !!!!!!              SAFE TO EDIT VALUES               !!!!!!
## !!!!!!                  -- START --                   !!!!!!
## !!!!!!                                                !!!!!!
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# Edit values (Option) to your preferance
# Change to an Option not listed will Skip the Function/Setting

# Note: If you're not sure what something does dont change it or do a web search 

# Can ONLY create 1 per 24 hours with this script (Will give an error)
$Script:CreateRestorePoint = 0    #0-Skip, 1-Create --(Restore point before script runs)

#Skips Term of Use
$Script:Term_of_Use = 1           #1-See ToS, Anything else = Accepts Term of Use

#Output Display
$Script:Verbros = 1               #0-Dont Show output, 1-Show output
$Script:ShowSkipped = 1           #0-Dont Show Skipped, 1-Show Skipped
$Script:ShowColor = 1             #0-Dont Show output Color, 1-Show output Colors

#Restart when done? (I recommend restarting when done)
$Script:Restart = 1               #0-Dont Restart, 1-Restart

#Windows Default for ALL Settings 
$Script:WinDefault = 2            #1-Yes*, 2-No 
# IF 1 is set then Everything Other than the following will use the Default Win Settings
# ALL Values Above this one, All Metro Apps and OneDriveInstall  (Will use what you set)

#Privacy Settings
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

#Windows Update
# Function  = Option              #Choices (* Indicates Windows Default)
$Script:CheckForWinUpdate = 0     #0-Skip, 1-Enable*, 2-Disable
$Script:WinUpdateType = 0         #0-Skip, 1-Notify, 2-Auto DL, 3-Auto DL+Install*, 4-Local admin chose --(May not work with Home version)
$Script:WinUpdateDownload = 0     #0-Skip, 1-P2P*, 2-Local Only, 3-Disable
$Script:UpdateMSRT = 0            #0-Skip, 1-Enable*, 2-Disable --(Malware Software Removal Tool)
$Script:UpdateDriver = 0          #0-Skip, 1-Enable*, 2-Disable --(Offering of drivers through Windows Update)
$Script:RestartOnUpdate = 0       #0-Skip, 1-Enable*, 2-Disable
$Script:AppAutoDownload = 0       #0-Skip, 1-Enable*, 2-Disable

#Service Tweaks
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
$Script:LockScreen = 0            #0-Skip, 1-Enable*, 2-Disable
$Script:PowerMenuLockScreen = 0   #0-Skip, 1-Show*, 2-Hide
$Script:CameraOnLockScreen = 0    #0-Skip, 1-Enable*, 2-Disable

#Misc items
# Function  = Option              #Choices (* Indicates Windows Default)
$Script:ActionCenter = 0          #0-Skip, 1-Enable*, 2-Disable
$Script:StickyKeyPrompt = 0       #0-Skip, 1-Enable*, 2-Disable
$Script:NumblockOnStart = 0       #0-Skip, 1-Enable, 2-Disable*
$Script:F8BootMenu = 0            #0-Skip, 1-Enable, 2-Disable*
$Script:RemoteUACAcctToken = 0    #0-Skip, 1-Enable, 2-Disable*
$Script:HibernatePower = 0        #0-Skip, 1-Enable, 2-Disable --(Hibernate Power Option)
$Script:SleepPower = 0            #0-Skip, 1-Enable*, 2-Disable --(Sleep Power Option)

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

# Black Viper's Services Setting
$Script:Back_Viper = 0            #0-Skip, 1-Default, 2-Safe, 3-Tweaked
# Black Viper's Website
# http://www.blackviper.com/service-configurations/black-vipers-windows-10-service-configurations/

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
$Script:APP_3DBuilder = 0         # 3DBuilder app
$Script:APP_Asphalt8Airborne = 0  # Asphalt 8 game
$Script:APP_BingFinance = 0       # Bing Money app
$Script:APP_BingNews = 0          # Bing News app
$Script:APP_BingSports = 0        # Bing Sports app
$Script:APP_BingTranslator = 0    # Bing Translator app
$Script:APP_BingWeather = 0       # Bing Weather app
$Script:APP_CandyCrushSoda = 0    # Candy Crush game
$Script:APP_CommsPhone = 0        # Phone app
$Script:APP_Communications = 0    # Calendar & Mail app
$Script:APP_Facebook = 0          # Facebook app
$Script:APP_FarmVille = 0         # Farm Ville game
$Script:APP_FreshPaint = 0        # Canvas app
$Script:APP_Getstarted = 0        # Get Started link
$Script:APP_Houzz = 0             # Houzz app
$Script:APP_Messaging = 0         # Messaging app
$Script:APP_MicrosoftJackpot = 0  # Jackpot app
$Script:APP_MicrosoftJigsaw = 0   # Jigsaw game
$Script:APP_MicrosoftMahjong = 0  # Mahjong game
$Script:APP_MicrosoftOffHub = 0   # Get Office Link
$Script:APP_MicrosoftSudoku = 0   # Sudoku game
$Script:APP_MinecraftUWP = 0      # Minecraft game
$Script:APP_MovieMoments = 0      # Movie Moments app
$Script:APP_Netflix = 0           # Netflix app
$Script:APP_OfficeOneNote = 0     # Office OneNote app
$Script:APP_OfficeSway = 0        # Office Sway app
$Script:APP_OneConnect = 0        # One Connect
$Script:APP_People = 0            # People app
$Script:APP_Photos = 0            # Photos app
$Script:APP_SkypeApp1 = 0         # Skype App
$Script:APP_SkypeApp2 = 0         # Skype App
$Script:APP_SolitaireCollect = 0  # Microsoft Solitaire
$Script:APP_StickyNotes = 0       # Sticky Notes app
$Script:APP_StudiosWordament = 0  # Wordament game
$Script:APP_Taptiles = 0          # Taptiles game
$Script:APP_Twitter = 0           # Twitter app
$Script:APP_VoiceRecorder = 0     # Voice Recorder app
$Script:APP_WindowsAlarms = 0     # Alarms and Clock app
$Script:APP_WindowsCalculator = 0 # Calculator app
$Script:APP_WindowsCamera = 0     # Camera app
$Script:APP_WindowsFeedbak1 = 0   # Feedback Hub
$Script:APP_WindowsFeedbak2 =     # Feedback Hub
$Script:APP_WindowsMaps = 0       # Maps app
$Script:APP_WindowsPhone = 0      # Phone Companion app
$Script:APP_WindowsStore = 0      # Windows Store
$Script:APP_XboxApp = 0           # Xbox app
$Script:APP_ZuneMusic = 0         # Groove Music app
$Script:APP_ZuneVideo = 0         # Groove Music app


## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## !!!!!!                                                !!!!!!
## !!!!!!              SAFE TO EDIT VALUES               !!!!!!
## !!!!!!                   -- END --                    !!!!!!
## !!!!!!                                                !!!!!!
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# --------------------------------------------------------------------------

##########
# Script -Start
##########

If ($SettingImp -ne $null -and $SettingImp){
    If (Test-Path $SettingImp -PathType Leaf){
        LoadSettingFile($SettingImp)
    } ElseIf ($SettingImp.ToLower() -eq "wd" -or $SettingImp.ToLower() -eq "windefault"){
        LoadWinDefault
        RunScript
    } ElseIf ($SettingImp.ToLower() -eq "run"){
        RunScript
    }
} ElseIf ($Term_of_Use -eq 1){
    TOS
} ElseIf ($Term_of_Use -ne 1){
    mainMenu
}

##########
# Script -End
##########
