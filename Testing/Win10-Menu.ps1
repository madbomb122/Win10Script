##########
# Win10 Initial Setup Script Settings Menu
# 
# Author: Madbomb122
# Website: https://github.com/madbomb122/Win10Script
# Version: 0.0, 02-12-2017
# 
# Release Type: Work in Progress
##########

# This script it to make selection of settings easier

# This script it ment to
# 1. Make a file with your wanted settings
# 2. Edit Settings file (what you load)
# 3. Run script with setting inputed/loaded

# When done will be part of the main script with ability
# to bypass Menu for Automation

$CurrVer = "0.0 (02-11-17) "
$RelType = "Beta   "
#$RelType = "Stable "

$MainMenuItems = @(
'                    Main Menu                     ',
'1. Run Script          ',
'2. Script Settings     ',
'3. Load Setting        ',
'4. Save Setting        ',
'5. Script Option       ',
'                       ',
'H. Help                ',
'A. About/Version       ',
'C. Copyright           ',
'                       ',
'                       ',
'                       ',
'Q. Exit/Quit                                      '
)

$ScriptSettingsMainMenuItems = @(
'             Script Setting Main Menu             ',
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
'B. Back to Main Menu                              '
)

$SettingFileItems = @(
'                   Setting File                   ',
'                                                 ',
'            Please Input Filename.               ',
'0. Cancel/Back to Main Menu                       '
)

$ConfirmMenuItems1 = @(
'                  Confirm Dialog                  ',
'                                                 ',
'              Are You sure? (Y/N)                ',
'0. Cancel/Back to Main Menu                       '
)

$ConfirmMenuItems2 = @(
'                  Confirm Dialog                  ',
'                                                 ',
'  File Exists do you want to overwrite? (Y/N)    ',
'0. Cancel/Back to Main Menu                       '
)

$HelpItems = @(
'                       Help                       ',
'                                                 ',
' Basic Usage:                                    ',
' Use the menu & select what you want to change.  ',
'                                                 ',
' Advanced Usage Choices (Bypasses Menu):         ',
' 1. Edit the script & change values there then   ',
'        run script with "-set Run"               ',
' 2. Run Script with importing a file with        ',
'        "-set filename"                          ',
' 3. Run Script with Window Default Values with   ',
'        "-set WD" or "-set WindowsDefault"       ',
'                                                 ',
' Examples:                                       ',
'    Win10-Mod.ps1 -set Run                       ',
'    Win10-Mod.ps1 -set Settings.xml              ',
'    Win10-Mod.ps1 -set WD                        ',
'                                                 ',
'Press "Enter" to go back                          '
)

$AboutItems = @(
'                About this Script                 ',
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
"Press 'Enter' to go back                          "
)

$Invalid=0

$AutomaticVariables = Get-Variable

function cmpv {
    Compare-Object (Get-Variable) $AutomaticVariables -Property Name -PassThru | Where -Property Name -ne "AutomaticVariables"
}

function MenuDisplay ([Array]$ToDisplay, [Int]$MM) {
    TitleBottom $ToDisplay[0] 0
	Write-host "|                         |                         |" -Background Black 
    Write-host -NoNewline "|  " -Background Black ;Write-Host -ForegroundColor Cyan -Background Black -NoNewline $ToDisplay[1];Write-Host -NoNewline "|  " -Background Black ;Write-Host -ForegroundColor Cyan -Background Black -NoNewline $ToDisplay[7];Write-Host "|" -Background Black 
    Write-host -NoNewline "|  " -Background Black ;Write-Host -ForegroundColor Cyan -Background Black -NoNewline $ToDisplay[2];Write-Host -NoNewline "|  " -Background Black ;Write-Host -ForegroundColor Cyan -Background Black -NoNewline $ToDisplay[8];Write-Host "|" -Background Black 
    Write-host -NoNewline "|  " -Background Black ;Write-Host -ForegroundColor Cyan -Background Black -NoNewline $ToDisplay[3];Write-Host -NoNewline "|  " -Background Black ;Write-Host -ForegroundColor Cyan -Background Black -NoNewline $ToDisplay[9];Write-Host "|" -Background Black 
    Write-host -NoNewline "|  " -Background Black ;Write-Host -ForegroundColor Cyan -Background Black -NoNewline $ToDisplay[4];Write-Host -NoNewline "|  " -Background Black ;Write-Host -ForegroundColor Cyan -Background Black -NoNewline $ToDisplay[10];Write-Host "|" -Background Black 
    Write-host -NoNewline "|  " -Background Black ;Write-Host -ForegroundColor Cyan -Background Black -NoNewline $ToDisplay[5];Write-Host -NoNewline "|  " -Background Black ;Write-Host -ForegroundColor Cyan -Background Black -NoNewline $ToDisplay[11];Write-Host "|" -Background Black 
    Write-host -NoNewline "|  " -Background Black ;Write-Host -ForegroundColor Cyan -Background Black -NoNewline $ToDisplay[6];Write-Host -NoNewline "|  " -Background Black ;Write-Host -ForegroundColor Cyan -Background Black -NoNewline $ToDisplay[12];Write-Host "|" -Background Black 
	Write-host "|                         |                         |" -Background Black 
    TitleBottom $ToDisplay[13] 1
	Website
}

# To display Settings Item with Choices for it
function ChoicesDisplay ([Array]$ChToDisplay,[Int]$ChToDisplayVal) {
    TitleBottom $ChToDisplay[0] 0
	Write-host "|                                                   |" -Background Black 
    Write-host -NoNewline "|  " -Background Black ;Write-Host -ForegroundColor Cyan -NoNewline $ChToDisplay[1];Write-Host "|" -Background Black 
    Write-host -NoNewline "|  " -Background Black ;Write-Host -ForegroundColor Cyan -NoNewline $ChToDisplay[2];Write-Host "|" -Background Black 
	Write-host "|                                                   |" -Background Black 
    Write-host "|---------------------------------------------------|" -Background Black 
	Write-host "|                                                   |" -Background Black 
    for ($i=3; $i -lt $VarToDisplay.length-1; $i++) {
	    Write-host -NoNewline "|  " -Background Black ;Write-Host -ForegroundColor Cyan -Background Black -NoNewline $ChToDisplay[$i];Write-Host "|" -Background Black 
    }
	Write-host "|                                                   |" -Background Black 
    Write-host "|---------------------------------------------------|" -Background Black 
	Write-host -NoNewline "|  " -Background Black ;Write-Host -ForegroundColor Cyan -Background Black -NoNewline "Current Value: "$ChToDisplayVal;Write-Host "|" -Background Black 
    Write-host "|---------------------------------------------------|" -Background Black 
    TitleBottom $ChToDisplay[7] 1
	Website
}

function VariableDisplay ([Array]$VarToDisplay) {
    TitleBottom $VarToDisplay[0] 0
    for ($i=1; $i -lt $VarToDisplay.length-1; $i++) {
	    Write-host -NoNewline "|  " -Background Black ;Write-Host -ForegroundColor Cyan -Background Black -NoNewline $VarToDisplay[$i];Write-Host "|" -Background Black 
    }
    TitleBottom $VarToDisplay[$VarToDisplay.length-1] 2
}

function WarningDisplay ([Array]$WarnToDisplay) {
    TitleBottom $WarnToDisplay[0] 0
    Write-host -NoNewline "|  " -Background Black ;Write-Host -ForegroundColor Cyan -Background Black -NoNewline $WarnToDisplay[1];Write-Host "|" -Background Black 
    Write-host -NoNewline "|  " -Background Black ;Write-Host -ForegroundColor Cyan -Background Black -NoNewline $WarnToDisplay[2];Write-Host "|" -Background Black 
	Write-host "|                                                   |" -Background Black 
    TitleBottom $WarnToDisplay[3] 1
	Website
}

function TitleBottom ([String]$TitleA,[Int]$TitleB) {
    Write-host "|---------------------------------------------------|" -Background Black 
	If($TitleB -eq 0) {
        Write-host -NoNewline "| " -Background Black ;Write-Host -ForegroundColor Green -Background Black -NoNewline $TitleA;Write-Host "|" -Background Black 
	} ElseIf($TitleB -eq 1) {
        Write-host -NoNewline "| " -Background Black ;Write-Host -ForegroundColor Red -Background Black -NoNewline $TitleA;Write-Host "|"	 -Background Black 
	} ElseIf($TitleB -eq 2) {
	    Write-host -NoNewline "| " -Background Black ;Write-Host -ForegroundColor Yellow -BackgroundColor Black -NoNewline "Current Version:"$CurrVer;Write-Host "|" -Background Black -NoNewline;Write-Host -ForegroundColor Red -Background Black -NoNewline " Release:"$RelType;Write-Host "|" -Background Black 
    }
	Write-host "|---------------------------------------------------|" -Background Black 
}

function Website {
    Write-host -NoNewline "|" -Background Black ;Write-Host -ForegroundColor Yellow -BackgroundColor Black -NoNewline "     https://github.com/madbomb122/Win10Script     ";Write-Host "|" -Background Black 
    Write-host "|---------------------------------------------------|" -Background Black 
}

function mainMenu {
    $mainMenu = 'X'
    while($mainMenu -ne 0){
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
            5 {""} #Script Options
            H {HelpMenu} #Help
            A {AboutMenu}  #About/Version
            C {""}  #Copyright
			Q {$mainMenu = 0} 
            default {$Invalid = 1}
        }
    }
}

function LoadSetting {
    $LoadSetting = 'X'
    while($LoadSetting -ne 0){
        Clear-Host
		WarningDisplay $SettingFileItems
		If($Invalid -eq 1){
		    Write-host ""
			Write-host "No file with the name " $LoadSetting -ForegroundColor Red -BackgroundColor Black -NoNewline
			$Invalid = 0
		}
        $LoadSetting = Read-Host "`nFilename"
		If (Test-Path $LoadSetting -PathType Leaf){
			$Conf = ConfrmMenu1
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
    while($SaveSetting -ne 0){
        Clear-Host
		WarningDisplay $SettingFileItems
		$SaveSetting = Read-Host "`nFilename"
		If ($SaveSetting -ne 0){
		    If (Test-Path $SaveSetting -PathType Leaf){
			    $Conf = ConfirmMenu2
			    If($Conf -eq $true){
			        cmpv | Export-Clixml .\$SaveSetting
			    }		    
		    } Else {
			    cmpv | Export-Clixml .\$SaveSetting
		    }
			$SaveSetting = 0	
		}
    }
}

function HelpMenu {
    $HelpMenu = 'X'
    while($HelpMenu -ne 0){
        Clear-Host
		VariableDisplay $HelpItems 0
        $HelpMenu = Read-Host "`nPress 'Enter' to continue"
		switch ($HelpMenu) {
            default {$HelpMenu = 0}
        }
    }
}

function AboutMenu {
    $AboutMenu = 'X'
    while($AboutMenu -ne 0){
        Clear-Host
		VariableDisplay $AboutItems 0
        $AboutMenu = Read-Host "`nPress 'Enter' to continue"
		switch ($AboutMenu) {
            default {$AboutMenu = 0}
        }
    }
}

function ConfirmMenu([int] $Option) {
    $ConfirmMenu = 'X'
    while($ConfirmMenu -ne 0){
        Clear-Host
		If ($Option -eq 1){
			MenuDisplay $ConfirmMenuItems1
		} ElseIf ($Option -eq 2){
			MenuDisplay $ConfirmMenuItems2 0
		}
		$ConfirmMenu = Read-Host "`nSelection (Y/N)"
        switch (ConfirmMenu) {
			Y {Return $true}
            N {Return $false} 
		    default {Return $false}
		}
    } 
}

function ScriptSettingsMM {
    $ScriptSettingsMM = 'X'
    while($ScriptSettingsMM -ne 0){
        Clear-Host
		MenuDisplay $ScriptSettingsMainMenuItems 1
		If($Invalid -eq 1){
			Write-host ""
			Write-host "Invalid Selection" -ForegroundColor Red -BackgroundColor Black -NoNewline
			$Invalid = 0
		}
        $ScriptSettingsMM = Read-Host "`nSelection"
		switch ($ScriptSettingsMM) {
            1 {"The color is red."} #Privacy Settings
            2 {"                  "} #Windows Update
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

function ChoicesMenu($Vari,$Number) {
    $VariJ = -join($Vari,"Items")
    $VariV = Get-Variable $Vari -valueOnly #Variable
    $VariA = Get-Variable $VariJ -valueOnly #Array
    $ChoicesMenu = 'X'
    while($ChoicesMenu -ne 'Q'){
        Clear-Host
		If($Invalid -eq 1){
		    Write-host ""
			Write-host "Invalid Selection" -ForegroundColor Red -BackgroundColor Black -NoNewline
			$Invalid = 0
		}
		ChoicesDisplay $VariA $VariV
        $ChoicesMenu = Read-Host "`nChoice"
    	switch ($ScriptSettingsMM) {
            0 {Return 0}
            1 {Return 1}
            2 {Return 2}
            3 {if($Number -ge 3) {Return 3} Else {$Invalid = 1}}
            4 {if($Number -eq 4) {Return 4} Else {$Invalid = 1}}
            C {Return $VariV} 
            default {$Invalid = 1}
		}
    } 
}

mainMenu
