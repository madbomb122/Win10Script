##########
# Win 10 Setup Script/Tweaks with Menu(GUI)
#
# Modded Script + Menu(GUI) By
#  Author: Madbomb122
# Website: https://GitHub.com/Madbomb122/Win10Script/
#
# Original Basic Script By
#  Author: Disassembler0
# Website: https://GitHub.com/Disassembler0/Win10-Initial-Setup-Script/
# Version: 2.0, 2017-01-08 (Version Copied)
#
$Script_Version = '3.7.2'
$Script_Date = 'Jul-31-2021'
#$Release_Type = 'Stable'
##########

## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## !!                                            !!
## !!             SAFE TO EDIT ITEM              !!
## !!            AT BOTTOM OF SCRIPT             !!
## !!                                            !!
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## !!                                            !!
## !!                  CAUTION                   !!
## !!        DO NOT EDIT PAST THIS POINT         !!
## !!                                            !!
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

<#------------------------------------------------------------------------------#>

$Copyright =' The MIT License (MIT)                                                  
                                                                        
 Copyright (c) 2017 Disassembler                                        
        -Original Basic Version of Script                               
                                                                        
 Copyright (c) 2017-2021 Madbomb122                                     
        -Modded + Menu Version of Script                                
                                                                        
 Permission is hereby granted, free of charge, to any person obtaining  
 a copy of this software and associated documentation files (the        
 "Software"), to deal in the Software without restriction, including    
 without limitation the rights to use, copy, modify, merge, publish,    
 distribute, sublicense, and/or sell copies of the Software, and to     
 permit persons to whom the Software is furnished to do so, subject to  
 the following conditions:                                              
                                                                        
 The above copyright notice(s), this permission notice shall be         
 included in all copies or substantial portions of the Software.        
                                                                        
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY  
 KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
 WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR    
 PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS 
 OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR   
 OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
 OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE  
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.     
                                                            '

<#--------------------------------------------------------------------------------

.Prerequisite to run script
  System: Windows 10
  Files: This script

.DESCRIPTION
  Makes it easier to setup an existing or new install with moded setting

.BASIC USAGE
  Use the Menu and set what you want then Click Run the Script

.ADVANCED USAGE
 One of the following Methods...
  1. Edit values at bottom of the script
  2. Edit bat file and run
  3. Run the script with one of these switches (space between multiple)

  Switch          Description of Switch
-- Basic Switches --
  -atos           Accepts ToS
  -auto           Implies -Atos...Closes on - User Errors, or End of Script
  -crp            Creates Restore Point
  -dnr            Do Not Restart when done

-- Run Script Switches --
  -run            Runs script with settings in script
  -run FILENME    Runs script with settings in the file FILENME
  -run wd         Runs script with win default settings

-- Load Script Switches --
  -load FILENME   Loads script with settings in the file FILENME
  -load wd        Loads script with win default settings

--Update Switches--
  -usc            Checks for Update to Script file before running
  -sic            Skips Internet Check

------------------------------------------------------------------------------#>
##########
# Pre-Script -Start
##########

If([Environment]::OSVersion.Version.Major -ne 10) {
	Write-Host 'Sorry, this Script supports Windows 10 ONLY.' -ForegroundColor 'cyan' -BackgroundColor 'black'
	If($Automated -ne 1){ Read-Host -Prompt "`nPress Any key to Close..." } ;Exit
}
If($Release_Type -eq 'Stable'){ $ErrorActionPreference = 'SilentlyContinue' } Else{ $Release_Type = 'Testing' }

$Script:PassedArg = $args

If(!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PassedArg" -Verb RunAs ;Exit
}

$MySite = 'https://GitHub.com/madbomb122/Win10Script'
$URL_Base = $MySite.Replace('GitHub','raw.GitHub')+'/master/'
$Version_Url = $URL_Base + 'Version/Version.csv'
$Donate_Url = 'https://www.amazon.com/gp/registry/wishlist/YBAYWBJES5DE/'
$FileBase = $(If($psISE -ne $Null){ Split-Path $psISE.CurrentFile.FullPath -Parent } Else{ $PSScriptRoot }) + '\'

$Script:Win10Ver = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name ReleaseID).ReleaseId
$Script:OSBit = If([System.Environment]::Is64BitProcess){ 64 } Else{ 32 }

##########
# Pre-Script -End
##########
# Needed Variable -Start
##########

$TasksList = @(
'Application Experience',
'Consolidator',
'Customer Experience Improvement Program',
'DmClient',
'KernelCeipTask',
'Microsoft Compatibility Appraiser',
'ProgramDataUpdater',
'Proxy',
'QueueReporting',
'SmartScreenSpecific',
'UsbCeip')
<#
'AgentFallBack2016',
'AitAgent',
'CreateObjectTask',
#'Diagnostics',
'DmClientOnScenarioDownload',
'FamilySafetyMonitor',
'FamilySafetyRefresh',
'FamilySafetyRefreshTask',
'FamilySafetyUpload',
#'File History (maintenance mode)',
'GatherNetworkInfo',
'MapsUpdateTask',
#'Microsoft-Windows-DiskDiagnosticDataCollector',
'MNO Metadata Parser',
'OfficeTelemetryAgentFallBack',
'OfficeTelemetryAgentLogOn',
'OfficeTelemetryAgentLogOn2016',
'Sqm-Tasks',
#'StartupAppTask',
'Uploader',
'XblGameSaveTask',
'XblGameSaveTaskLogon')
#>

$Xbox_Apps = @(Get-AppxPackage *xbox*).Name
$musnotification_files = @("$Env:windir\System32\musnotification.exe","$Env:windir\System32\musnotificationux.exe")

$AppxOptions=@('Skip','Unhide','Hide','Uninstall')

$colors = @(
'black',      #0
'blue',       #1
'cyan',       #2
'darkblue',   #3
'darkcyan',   #4
'darkgray',   #5
'darkgreen',  #6
'darkmagenta',#7
'darkred',    #8
'darkyellow', #9
'gray',       #10
'green',      #11
'magenta',    #12
'red',        #13
'white',      #14
'yellow')     #15

#Unicode Box Codes
$Tlc = [char]0x2554 # ╔
$Blc = [char]0x255A # ╚
$Trc = [char]0x2557 # ╗
$Brc = [char]0x255D # ╝
$Sid = [char]0x2551 # ║
$ToB = [char]0x2550 # ═

Function BoxItem([String]$TxtToDisplay) {
	$TLen = $TxtToDisplay.Length
	$LLen = $TLen+9
	$Ttop = "`n$Tlc".PadRight($LLen-1,$ToB) + $Trc
	$TBot = "$Blc".PadRight($LLen-2,$ToB) + $Brc
	DisplayOut $Ttop -C 14
	DisplayOut $Sid,"   $TxtToDisplay   ",$Sid -C 14,13,14
	DisplayOut $TBot -C 14
}

Function AnyKeyClose{ Read-Host -Prompt "`nPress Any key to Close..." }

##########
# Needed Variable -End
##########
# Update Functions -Start
##########

Function UpdateCheck {
	If(InternetCheck) {
		$CSV_Ver = Invoke-WebRequest $Version_Url | ConvertFrom-Csv
		$CSVLine,$RT = If($Release_Type -eq 'Stable'){ 0,'' } Else{ 1,'Testing/' }
		$WebScriptVer = $CSV_Ver[$CSVLine].Version + "." + $CSV_Ver[$CSVLine].MinorVersion
		If($WebScriptVer -gt $Script_Version){ ScriptUpdateFun $RT }
	} Else {
		Clear-Host
		DisplayMisc -Line
		DisplayOutLML (''.PadRight(22)+'Error') -C 13
		DisplayMisc -Line
		DisplayMisc
		DisplayOutLML 'No Internet connection detected or GitHub.com' -C 2
		DisplayOutLML 'is currently down.' -C 2
		DisplayOutLML 'Tested by pinging GitHub.com' -C 2
		DisplayMisc
		DisplayOutLML 'To skip use one of the following methods' -C 2
		DisplayOut '|',' 1. Change ','InternetCheck',' in bat file'.PadRight(28),'|' -C 14,2,15,2,14
		DisplayOut '|',' 2. Change ','InternetCheck',' in bat file'.PadRight(28),'|' -C 14,2,15,2,14
		DisplayOut '|',' 3. Run Script or Bat file with ','-sic',' switch         ','|' -C 14,2,15,2,14
		DisplayMisc
		DisplayMisc -Line
		AnyKeyClose
	}
}

Function ScriptUpdateFun([String]$RT) {
	$Script_Url = $URL_Base + $RT + 'Win10-Menu.ps1'
	$ScrpFilePath = $FileBase + 'Win10-Menu.ps1'
	$FullVer = "$WebScriptVer.$WebScriptMinorVer"
	$UpArg = ''

	If($Accept_ToS -ne 1){ $UpArg += '-atos ' }
	If($InternetCheck -eq 1){ $UpArg += '-sic ' }
	If($CreateRestorePoint -eq 1){ $UpArg += '-crp ' }
	If($Restart -eq 0){ $UpArg += '-dnr' }
	$UpArg += If($RunScr){ "-run $TempSetting " } Else{ "-load $TempSetting " }

	Clear-Host
	DisplayMisc -Line
	DisplayMisc
	DisplayOutLML (''.PadRight(18)+'Update Found!') -C 13 -L
	DisplayMisc
	DisplayOut '|',' Updating from version ',"$Script_Version".PadRight(30),'|' -C 14,15,11,14 -L
	DisplayMisc
	DisplayOut '|',' Downloading version ',"$FullVer".PadRight(31),'|' -C 14,15,11,14 -L
	DisplayOutLML 'Will run after download is complete.' -C 15 -L
	DisplayMisc
	DisplayMisc -Line

	(New-Object System.Net.WebClient).DownloadFile($Script_Url, $ScrpFilePath)
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$ScrpFilePath`" $UpArg" -Verb RunAs
	Exit
}

Function InternetCheck{ If($InternetCheck -eq 1 -or (Test-Connection www.GitHub.com -Count 1 -Quiet)){ Return $True } Return $False }

##########
# Update Functions -End
##########
# Multi Use Functions -Start
##########

Function ThanksDonate {
	DisplayOut "`nThanks for using my script." -C 11
	DisplayOut 'If you like this script please consider giving me a donation.' -C 11
	DisplayOut "`nLink to donation:" -C 15
	DisplayOut $Donate_Url -C 2
}

Function cmpv{ Compare-Object (Get-Variable -Scope Script) $AutomaticVariables -Property Name -PassThru | Where-Object -Property Name -ne 'AutomaticVariables' | Where-Object { $_ -NotIn $WPFList } }
Function Openwebsite([String]$Url){ Start-Process $Url }
Function ShowInvalid([Int]$InvalidA){ If($InvalidA -eq 1){ Write-Host "`nInvalid Input" -ForegroundColor Red -BackgroundColor Black -NoNewline } Return 0 }
Function CheckSetPath([String]$RPath){ While(!(Test-Path $RPath)){ New-Item -Path $RPath -Force | Out-Null } Return $RPath }
Function RemoveSetPath([String]$RPath){ If(Test-Path $RPath){ Remove-Item -Path $RPath -Recurse } }
Function StartOrGui{ SetAppxVar ;If($RunScr -eq $True){ RunScript } ElseIf($AcceptToS -ne 1){ GuiStart } }

Function DisplayOut {
	Param (	[Alias ("T")] [String[]]$Text, [Alias ("C")] [Int[]]$Color )
	For($i=0 ;$i -lt $Text.Length ;$i++){ Write-Host $Text[$i] -ForegroundColor $colors[$Color[$i]] -BackgroundColor 'Black' -NoNewLine } ;Write-Host
}

Function DisplayOutLML {
	Param (	[Alias('T')] [String]$Text, [Alias('C')] [Int[]]$Color )
	DisplayOut '| ',"$Text".PadRight(50),' |' -C 14,$Color,14
}

Function DisplayMisc {
	Param (	[Switch]$Line, [Int]$Misc = 14 )
	$txt = If($Line){ '|'.PadRight(53,'-') + '|' } Else{ '|'.PadRight(53) + '|' } #Line or Blank Spaces
	$Splat = @{ Text = $txt ;Color = $Misc }
	DisplayOut @Splat
}

Function ScriptPreStart {
	SetDefault
	If($PassedArg.Length -gt 0){ ArgCheck }
	If($AcceptToS -eq 1){ TOS } Else{ StartOrGui }
}

Function SetAppxVar {
	$Script:DataGridApps = [PSCustomObject] @{ AppxName = 'Microsoft.3DBuilder'; CName = '3DBuilder'; VarName = 'APP_3DBuilder'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_3DBuilder]},
	[PSCustomObject] @{ AppxName = 'Microsoft.Microsoft3DViewer'; CName = '3DViewer'; VarName = 'APP_3DViewer'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_3DViewer]},
	[PSCustomObject] @{ AppxName = 'Microsoft.BingWeather'; CName = 'Bing Weather'; VarName = 'APP_BingWeather'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_BingWeather]},
	[PSCustomObject] @{ AppxName = 'Microsoft.CommsPhone'; CName = 'Phone'; VarName = 'APP_CommsPhone'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_CommsPhone]},
	[PSCustomObject] @{ AppxName = 'Microsoft.windowscommunicationsapps'; CName = 'Calendar & Mail'; VarName = 'APP_Communications'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_Communications]},
	[PSCustomObject] @{ AppxName = 'Microsoft.GetHelp'; CName = "Microsoft's Self-Help"; VarName = 'APP_GetHelp'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_GetHelp]},
	[PSCustomObject] @{ AppxName = 'Microsoft.Getstarted'; CName = 'Get Started Link'; VarName = 'APP_Getstarted'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_Getstarted]},
	[PSCustomObject] @{ AppxName = 'Microsoft.Messaging'; CName = 'Messaging'; VarName = 'APP_Messaging'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_Messaging]},
	[PSCustomObject] @{ AppxName = 'Microsoft.MicrosoftOfficeHub'; CName = 'Get Office Link'; VarName = 'APP_MicrosoftOffHub'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_MicrosoftOffHub]},
	[PSCustomObject] @{ AppxName = 'Microsoft.MovieMoments'; CName = 'Movie Moments'; VarName = 'APP_MovieMoments'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_MovieMoments]},
	[PSCustomObject] @{ AppxName = '4DF9E0F8.Netflix'; CName = 'Netflix'; VarName = 'APP_Netflix'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_Netflix]},
	[PSCustomObject] @{ AppxName = 'Microsoft.Office.OneNote'; CName = 'Office OneNote'; VarName = 'APP_OfficeOneNote'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_OfficeOneNote]},
	[PSCustomObject] @{ AppxName = 'Microsoft.Office.Sway'; CName = 'Office Sway'; VarName = 'APP_OfficeSway'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_OfficeSway]},
	[PSCustomObject] @{ AppxName = 'Microsoft.OneConnect'; CName = 'One Connect'; VarName = 'APP_OneConnect'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_OneConnect]},
	[PSCustomObject] @{ AppxName = 'Microsoft.People'; CName = 'People'; VarName = 'APP_People'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_People]},
	[PSCustomObject] @{ AppxName = 'Microsoft.Windows.Photos'; CName = 'Photos'; VarName = 'APP_Photos'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_Photos]},
	[PSCustomObject] @{ AppxName = 'Microsoft.SkypeApp'; CName = 'Skype'; VarName = 'APP_SkypeApp1'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_SkypeApp1]},
	[PSCustomObject] @{ AppxName = 'Microsoft.MicrosoftSolitaireCollection'; CName = 'Microsoft Solitaire'; VarName = 'APP_SolitaireCollect'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_SolitaireCollect]},
	[PSCustomObject] @{ AppxName = 'Microsoft.MicrosoftStickyNotes'; CName = 'Sticky Notes'; VarName = 'APP_StickyNotes'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_StickyNotes]},
	[PSCustomObject] @{ AppxName = 'Microsoft.WindowsSoundRecorder'; CName = 'Voice Recorder'; VarName = 'APP_VoiceRecorder'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_VoiceRecorder]},
	[PSCustomObject] @{ AppxName = 'Microsoft.WindowsAlarms'; CName = 'Alarms and Clock'; VarName = 'APP_WindowsAlarms'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_WindowsAlarms]},
	[PSCustomObject] @{ AppxName = 'Microsoft.WindowsCalculator'; CName = 'Calculator'; VarName = 'APP_WindowsCalculator'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_WindowsCalculator]},
	[PSCustomObject] @{ AppxName = 'Microsoft.WindowsCamera'; CName = 'Camera'; VarName = 'APP_WindowsCamera'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_WindowsCamera]},
	[PSCustomObject] @{ AppxName = 'Microsoft.WindowsFeedback'; CName = 'Windows Feedback'; VarName = 'APP_WindowsFeedbak1'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_WindowsFeedbak1]},
	[PSCustomObject] @{ AppxName = 'Microsoft.WindowsFeedbackHub'; CName = 'Windows Feedback Hub'; VarName = 'APP_WindowsFeedbak2'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_WindowsFeedbak2]},
	[PSCustomObject] @{ AppxName = 'Microsoft.WindowsMaps'; CName = 'Maps'; VarName = 'APP_WindowsMaps'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_WindowsMaps]},
	[PSCustomObject] @{ AppxName = 'Microsoft.WindowsPhone'; CName = 'Phone Companion'; VarName = 'APP_WindowsPhone'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_WindowsPhone]},
	[PSCustomObject] @{ AppxName = 'Microsoft.WindowsStore'; CName = 'Microsoft Store'; VarName = 'APP_WindowsStore'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_WindowsStore]},
	[PSCustomObject] @{ AppxName = 'Microsoft.Wallet'; CName = 'Stores Credit and Debit Card Information'; VarName = 'APP_WindowsWallet'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_WindowsWallet]},
	[PSCustomObject] @{ AppxName = $Xbox_Apps; CName = 'Xbox Apps (All)'; VarName = 'APP_XboxApp'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_XboxApp]},
	[PSCustomObject] @{ AppxName = 'Microsoft.ZuneMusic'; CName = 'Groove Music'; VarName = 'APP_ZuneMusic'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_ZuneMusic]},
	[PSCustomObject] @{ AppxName = 'Microsoft.ZuneVideo'; CName = 'Groove Video'; VarName = 'APP_ZuneVideo'; AppOptions = $AppxOptions; AppSelected = $AppxOptions[$APP_ZuneVideo]}
	If($WPF_dataGrid){ $WPF_dataGrid.ItemsSource = $DataGridApps }
}

Function PassVal([String]$Pass){ Return $PassedArg[$PassedArg.IndexOf($Pass)+1] }
Function ArgCheck {
	If($PassedArg -In '-help','-h'){ ShowHelp }
	If($PassedArg -Contains '-copy'){ ShowCopyright ;Exit }
	If($PassedArg -Contains '-run') {
		$tmp = PassVal '-run'
		If(Test-Path -LiteralPath $tmp -PathType Leaf) {
			LoadSettingFile $tmp ;$Script:RunScr = $True
		} ElseIf($tmp -In 'wd','windefault') {
			LoadWinDefault ;$Script:RunScr = $True
		} ElseIf($tmp.StartsWith('-') -or $PassedArg.IndexOf('-run') -eq  $PassedArg.Length) {
			$Script:RunScr = $True
		}
	}
	If($PassedArg -Contains '-load') {
		$tmp = PassVal '-load'
		If(Test-Path -LiteralPath $tmp -PathType Leaf){ LoadSettingFile $tmp } ElseIf($tmp -In 'wd','windefault'){ LoadWinDefault }
	}
	If($PassedArg -Contains '-sic'){ $Script:InternetCheck = 1 }
	If($PassedArg -Contains '-usc'){ $Script:VersionCheck  = 1 }
	If($PassedArg -Contains '-atos'){ $Script:AcceptToS = 'Accepted' }
	If($PassedArg -Contains '-dnr'){ $Script:Restart = 0 }
	If($PassedArg -Contains '-auto'){ $Script:Automated = 1 ;$Script:AcceptToS = 'Accepted' }
	If($PassedArg -Contains '-crp') {
		$Script:CreateRestorePoint = 1
		$tmp = PassVal '-crp'
		If(!$tmp.StartsWith('-')){ $Script:RestorePointName = $tmp }
	}
}

Function ShowHelp {
	Clear-Host
	DisplayOut '             List of Switches' -C 13
	DisplayOut ''.PadRight(53,'-') -C 14
	DisplayOut ' Switch ',"Description of Switch`n".PadLeft(31) -C 14,15
	DisplayOut '-- Basic Switches --' -C 2
	DisplayOut '  -atos ','           Accepts ToS' -C 14,15
	DisplayOut '  -auto ','           Implies ','-atos','...Runs the script to be Automated.. Closes on - User Input, Errors, or End of Script' -C 14,15,14,15
	DisplayOut '  -crp  ','           Creates Restore Point' -C 14,15
	DisplayOut '  -dnr  ','           Do Not Restart when done' -C 14,15
	DisplayOut "`n-- Run Script Switches --" -C 2
	DisplayOut '  -run  ','           Runs script with settings in script' -C 14,15
	DisplayOut '  -run  ','FILENAME ','   Runs script with settings in the file',' FILENAME' -C 14,11,15,11
	DisplayOut '  -run wd ','         Runs script with win default settings' -C 14,15
	DisplayOut "`n-- Load Script Switches --" -C 2
	DisplayOut '  -run  ','FILENAME ','  Loads script with settings in the file',' FILENAME' -C 14,11,15,11
	DisplayOut '  -load wd ','        Loads script with win default settings' -C 14,15
	DisplayOut "`n--Update Switches--" -C 2
	DisplayOut '  -usc ','            Checks for Update to Script file before running' -C 14,15
	DisplayOut '  -sic ',"            Skips Internet Check, if you can't ping GitHub.com for some reason" -C 14,15
	DisplayOut "`n--Help--" -C 2
	DisplayOut '  -help ','           Shows list of switches, then exits script.. alt ','-h' -C 14,15,14
	DisplayOut '  -copy ','           Shows Copyright/License Information, then exits script' -C 14,15
	AnyKeyClose
	Exit
}

Function ShowCopyright { Clear-Host ;DisplayOut $Copyright -C 14 }

Function TOSDisplay([Switch]$C) {
	If(!$C){ Clear-Host }
	$BC = 14
	If($Release_Type -ne 'Stable') {
		$BC = 15
		DisplayMisc -Line -Misc 15
		DisplayOut '|'.PadRight(22),'Caution!!!'.PadRight(31),'|' -C 15,13,15
		DisplayMisc -Misc 15
		DisplayOut '|','         This script is still being tested.         ','|' -C 15,14,15
		DisplayOut '|'.PadRight(17),'USE AT YOUR OWN RISK.'.PadRight(36),'|' -C 15,14,15
		DisplayMisc -Misc 15
	}
	DisplayMisc -Line -Misc $BC
	DisplayOut '|'.PadRight(21),'Terms of Use'.PadRight(32),'|' -C $BC,11,$BC
	DisplayMisc -Line -Misc $BC
	DisplayMisc -Misc $BC
	DisplayOut '|',' This program comes with ABSOLUTELY NO WARRANTY.    ','|' -C $BC,2,$BC
	DisplayOut '|',' This is free software, and you are welcome to      ','|' -C $BC,2,$BC
	DisplayOut '|',' redistribute it under certain conditions.'.PadRight(52),'|' -C $BC,2,$BC
	DisplayMisc -Misc $BC
	DisplayOut '|',' Read License file for full Terms.'.PadRight(52),'|' -C $BC,2,$BC
	DisplayMisc -Misc $BC
	DisplayOut '|',' Use the switch ','-copy',' to see License Information or ','|' -C $BC,2,14,2,$BC
	DisplayOut '|',' enter ','L',' bellow.'.PadRight(44),'|' -C $BC,2,14,2,$BC
	DisplayMisc -Misc $BC
	DisplayMisc -Line -Misc $BC
}

Function TOS {
	$CopyR = $False
	While($TOS -ne 'Out') {
		TOSDisplay -c:$CopyR
		$CopyR = $False
		$Invalid = ShowInvalid $Invalid
		$TOS = Read-Host "`nDo you Accept? (Y)es/(N)o"
		If($TOS -In 'n','no'){
			Exit
		} ElseIf($TOS -In 'y','yes') {
			$Script:AcceptToS = 'Accepted-Script' ;$TOS = 'Out' ;StartOrGui
		} ElseIf($TOS -eq 'l') {
			$CopyR = $True ;ShowCopyright
		} Else {
			$Invalid = 1
		}
	} Return
}

Function LoadSettingFile([String]$Filename) {
	If($Filename) {
		(Import-Csv -LiteralPath $Filename -Delimiter ';').ForEach{ Set-Variable $_.Name $_.Value -Scope Script }
		#[System.Collections.ArrayList]$Script:APPS_AppsUnhide = $AppsUnhide.Split(',')
		#[System.Collections.ArrayList]$Script:APPS_AppsHide = $AppsHide.Split(',')
		#[System.Collections.ArrayList]$Script:APPS_AppsUninstall = $AppsUninstall.Split(',')
		SetAppxVar
	}
}

Function SaveSettingFiles([String]$Filename) {
	If($Filename) {
		#ForEach($temp In $APPS_AppsUnhide){$Script:AppsUnhide += $temp + ','}
		#ForEach($temp In $APPS_AppsHide){$Script:AppsHide += $temp + ','}
		#ForEach($temp In $APPS_Uninstall){$Script:AppsUninstall += $temp + ','}
		If(Test-Path -LiteralPath $Filename -PathType Leaf) {
			If($ShowConf -eq 1){ $Conf = ConfirmMenu 2 } Else{ $Conf = $True }
			If($Conf){ cmpv | Select-Object Name,Value | Export-Csv -LiteralPath $Filename -Encoding 'unicode' -Force -Delimiter ';' }
		} Else {
			cmpv | Select-Object Name,Value | Export-Csv -LiteralPath $Filename -Encoding 'unicode' -Force -Delimiter ';'
		}
	}
}

##########
# Multi Use Functions -End
##########
# GUI -Start
##########

Function SetCombo([String]$Name,[String]$Item) {
	$Items = $Item.Split(',')
	$combo =  $(Get-Variable -Name ('WPF_'+$Name+'_Combo') -ValueOnly)
	[Void] $combo.Items.Add('Skip')
	ForEach($CmbItm In $Items){ [void] $combo.Items.Add($CmbItm) }
	SelectComboBoxGen $Name $(Get-Variable -Name $Name -ValueOnly)
}

Function SetComboM([String]$Name,[String]$Item) {
	$Items = $Item.Split(',')
	$combo =  $(Get-Variable -Name ('WPF_'+$Name+'_Combo') -ValueOnly)
	[Void] $combo.Items.Add('Skip')
	ForEach($CmbItm In $Items){ [Void] $combo.Items.Add($CmbItm) }
	If($Var -NotLike 'APP_*'){ SelectComboBoxGen $Name $(Get-Variable -Name $Name -ValueOnly) }
}

Function SelectComboBox([Array]$List) {
	ForEach($Var In $List) {
		If($Var -NotLike 'APP_*'){ SelectComboBoxGen $Var $(Get-Variable -Name $Var -ValueOnly) }
	}
}
Function SelectComboBoxGen([String]$Name,[Int]$Numb){ $(Get-Variable -Name ('WPF_'+$Name+'_Combo') -ValueOnly).SelectedIndex = $Numb }

Function RestorePointCBCheck {
	$WPF_CreateRestorePoint_CB.IsChecked,$WPF_RestorePointName_Txt = If($CreateRestorePoint -eq 1){ $True,$True } Else{ $False,$False }
}

Function ConfigGUIitms {
	$WPF_CreateRestorePoint_CB.IsChecked = If($CreateRestorePoint -eq 1){ $True } Else{ $False }
	$WPF_VersionCheck_CB.IsChecked = If($VersionCheck -eq 1){ $True } Else{ $False }
	$WPF_InternetCheck_CB.IsChecked = If($InternetCheck -eq 1){ $True } Else{ $False }
	$WPF_ShowSkipped_CB.IsChecked = If($ShowSkipped -eq 1){$True } Else{ $False }
	$WPF_Restart_CB.IsChecked = If($Restart -eq 1){ $True } Else{ $False }
	$WPF_RestorePointName_Txt.Text = $RestorePointName
	RestorePointCBCheck
}

Function OpenSaveDiaglog([Int]$SorO) {
	$SOFileDialog = If($SorO -eq 0){ New-Object System.Windows.Forms.OpenFileDialog } Else{ New-Object System.Windows.Forms.SaveFileDialog }
	$SOFileDialog.InitialDirectory = $FileBase
	$SOFileDialog.Filter = "CSV (*.csv)| *.csv"
	$SOFileDialog.ShowDialog() | Out-Null
	If($SorO -eq 0) {
		LoadSettingFile $SOFileDialog.Filename
		ConfigGUIitms
		SelectComboBox $VarList
		SetAppxVar
	} Else {
		GuiItmToVariable
		SaveSettingFiles $SOFileDialog.Filename
	}
}

Function GuiStart {
	Clear-Host
	DisplayOut 'Preparing GUI, Please wait...' -C 15

[xml]$XAML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" x:Name="Win10_Script"
Title="Windows 10 Settings/Tweaks Script By: Madbomb122 (v.$Script_Version -$Script_Date" Height="420" Width="660" BorderBrush="Black" Background="White">
	<Window.Resources>
		<Style x:Key="SeparatorStyle1" TargetType="{x:Type Separator}">
			<Setter Property="SnapsToDevicePixels" Value="True"/>
			<Setter Property="Margin" Value="0,0,0,0"/>
			<Setter Property="Template">
				<Setter.Value>
					<ControlTemplate TargetType="{x:Type Separator}">
						<Border Height="24" SnapsToDevicePixels="True" Background="#FF4D4D4D" BorderBrush="#FF4D4D4D" BorderThickness="0,0,0,1"/>
					</ControlTemplate>
				</Setter.Value>
			</Setter>
		</Style>
		<Style TargetType="{x:Type ToolTip}"><Setter Property="Background" Value="#FFFFFFBF"/></Style>
	</Window.Resources>
	<Window.Effect><DropShadowEffect/></Window.Effect>
	<Grid>
		<Grid.RowDefinitions>
			<RowDefinition Height="20"/>
			<RowDefinition Height="*"/>
			<RowDefinition Height="24"/>
		</Grid.RowDefinitions>
		<Menu Grid.Row="0" VerticalAlignment="Top">
			<MenuItem Header="Help">
				<MenuItem Name="FeedbackButton" Header="Feedback/Bug Report"/>
				<MenuItem Name="FAQButton" Header="FAQ"/>
				<MenuItem Name="AboutButton" Header="About"/>
				<MenuItem Name="CopyrightButton" Header="Copyright"/>
				<MenuItem Name="ContactButton" Header="Contact Me"/>
			</MenuItem>
			<MenuItem Name="DonateButton" Background="#FFFFAD2F" FontWeight="Bold" Header="Donate to Me"/>
			<MenuItem Name="Madbomb122WSButton" Background="#FFFFDF4F" FontWeight="Bold" Header="Madbomb122's GitHub"/>
		</Menu>
		<TabControl Name="TabControl" Grid.Row="1" BorderBrush="Gainsboro" TabStripPlacement="Left">
			<TabControl.Resources>
				<Style TargetType="TabItem">
					<Setter Property="Template">
						<Setter.Value>
							<ControlTemplate TargetType="TabItem">
								<Border Name="Border" Margin="2,2" BorderBrush="Gainsboro" BorderThickness="1,1,1,0" CornerRadius="4,4,0,0">
									<ContentPresenter x:Name="ContentSite" HorizontalAlignment="Center" Margin="5,2" VerticalAlignment="Center" ContentSource="Header"/>
								</Border>
								<ControlTemplate.Triggers>
									<Trigger Property="IsSelected" Value="True"><Setter TargetName="Border" Property="Background" Value="LightSkyBlue" /></Trigger>
									<Trigger Property="IsSelected" Value="False"><Setter TargetName="Border" Property="Background" Value="GhostWhite" /></Trigger>
								</ControlTemplate.Triggers>
							</ControlTemplate>
						</Setter.Value>
					</Setter>
				</Style>
			</TabControl.Resources>
			<TabItem Name="Options_Tab" Header="Script Options">
				<Grid Background="#FFE5E5E5">
					<Grid.RowDefinitions>
						<RowDefinition Height="6*"/>
						<RowDefinition Height="2*"/>
						<RowDefinition Height="1.5*"/>
					</Grid.RowDefinitions>
					<GroupBox Header="Options" Grid.Row="0" Margin="2">
						<Grid>
							<Grid.RowDefinitions>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
							</Grid.RowDefinitions>
							<Grid.ColumnDefinitions>
								<ColumnDefinition Width="2.1*"/>
								<ColumnDefinition Width="5*"/>
							</Grid.ColumnDefinitions>
							<CheckBox Name="CreateRestorePoint_CB" Grid.Column="0" Grid.Row="0" HorizontalAlignment="Left" Margin="5" VerticalAlignment="Center" Content="Create Restore Point:"/>
							<TextBox Name="RestorePointName_Txt" Grid.Column="1" Grid.Row="0" HorizontalAlignment="Left" Margin="5" VerticalAlignment="Center" Text="Win10 Initial Setup Script" TextWrapping="Wrap"/>
							<CheckBox Name="ShowSkipped_CB" Grid.Column="0" Grid.Row="1" HorizontalAlignment="Left" Margin="5" VerticalAlignment="Center" Content="Show Skipped Items"/>
							<CheckBox Name="Restart_CB" Grid.Column="0" Grid.ColumnSpan="2" Grid.Row="2" HorizontalAlignment="Left" Margin="5" VerticalAlignment="Center" Content="Restart When Done (Restart is Recommended)"/>
							<CheckBox Name="VersionCheck_CB" Grid.Column="0" Grid.ColumnSpan="2" Grid.Row="3" HorizontalAlignment="Left" Margin="5" VerticalAlignment="Center" Content="Check for Update (If found, will run with current settings)"/>
							<CheckBox Name="InternetCheck_CB" Grid.Column="0" Grid.Row="4" HorizontalAlignment="Left" Margin="5" VerticalAlignment="Center" Content="Skip Internet Check"/>
						</Grid>
					</GroupBox>
					<GroupBox Header="Backup / Restore / Reset" Grid.Row="1" Margin="2">
						<Grid>
							<Grid.RowDefinitions>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
							</Grid.RowDefinitions>
							<Grid.ColumnDefinitions>
								<ColumnDefinition Width="*"/>
								<ColumnDefinition Width="*"/>
								<ColumnDefinition Width="*"/>
								<ColumnDefinition Width="*"/>
							</Grid.ColumnDefinitions>
							<Button Name="Save_Setting_Button" Content="Save Settings" Grid.Column="0" Grid.Row="0"/>
							<Button Name="Load_Setting_Button" Content="Load Settings" Grid.Column="1" Grid.Row="0"/>
							<Button Name="WinDefault_Button" Content="Windows Default*" Grid.Column="2" Grid.Row="0"/>
							<Button Name="ResetDefault_Button" Content="Reset All Items" Grid.Column="3" Grid.Row="0"/>
							<TextBlock Text="Windows Default * / Does not modify Windows Apps or OneDrive Installation" Grid.Column="0" Grid.ColumnSpan="4" Grid.Row="1" HorizontalAlignment="Left" FontStyle="Italic" TextWrapping="Wrap"/>
						</Grid>
					</GroupBox>
					<GroupBox Header="Version" Grid.Row="2" Margin="2">
						<Grid>
							<TextBlock Name="Script_Ver_Txt" Text="v.$Script_Version ($Script_Date) -$Release_Type" TextWrapping="Wrap" HorizontalAlignment="Left" VerticalAlignment="Top"/>
						</Grid>
					</GroupBox>
				</Grid>
			</TabItem>
			<TabItem Name="Privacy_tab" Header="Privacy">
				<Grid Background="#FFE5E5E5">
					<Grid.ColumnDefinitions>
						<ColumnDefinition Width="*"/>
						<ColumnDefinition Width="*"/>
					</Grid.ColumnDefinitions>
					<Grid Grid.Column="0">
						<Grid.RowDefinitions>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
						</Grid.RowDefinitions>
						<Grid.ColumnDefinitions>
							<ColumnDefinition Width="18*"/>
							<ColumnDefinition Width="20*"/>
						</Grid.ColumnDefinitions>
						<Label Content="Telemetry:" Grid.Column="0" Grid.Row="0" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="Telemetry_Combo" Grid.Column="1" Grid.Row="0" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="Wi-Fi Sense:" Grid.Column="0" Grid.Row="1" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="WiFiSense_Combo" Grid.Column="1" Grid.Row="1" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="SmartScreen Filter:" Grid.Column="0" Grid.Row="2" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="SmartScreen_Combo" Grid.Column="1" Grid.Row="2" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="Location Tracking:" Grid.Column="0" Grid.Row="3" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="LocationTracking_Combo" Grid.Column="1" Grid.Row="3" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="Feedback:" Grid.Column="0" Grid.Row="4" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="Feedback_Combo" Grid.Column="1" Grid.Row="4" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="Advertising ID:" Grid.Column="0" Grid.Row="5" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="AdvertisingID_Combo" Grid.Column="1" Grid.Row="5" HorizontalAlignment="Left" VerticalAlignment="Center"/>
					</Grid>
					<Grid Grid.Column="1">
						<Grid.RowDefinitions>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
						</Grid.RowDefinitions>
						<Grid.ColumnDefinitions>
							<ColumnDefinition Width="21*"/>
							<ColumnDefinition Width="20*"/>
						</Grid.ColumnDefinitions>
						<Label Content="Cortana:" Grid.Column="0" Grid.Row="0" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="Cortana_Combo" Grid.Column="1" Grid.Row="0" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="Cortana Search:" Grid.Column="0" Grid.Row="1" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="CortanaSearch_Combo" Grid.Column="1" Grid.Row="1" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="Error Reporting:" Grid.Column="0" Grid.Row="2" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="ErrorReporting_Combo" Grid.Column="2" Grid.Row="2" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="AutoLogger:" Grid.Column="0" Grid.Row="3" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="AutoLoggerFile_Combo" Grid.Column="2" Grid.Row="3" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="Diagnostics Tracking:" Grid.Column="0" Grid.Row="4" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="DiagTrack_Combo" Grid.Column="2" Grid.Row="4" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="WAP Push:" Grid.Column="0" Grid.Row="5" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="WAPPush_Combo" Grid.Column="2" Grid.Row="5" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="App Auto Download:" Grid.Column="0" Grid.Row="6" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="AppAutoDownload_Combo" Grid.Column="1" Grid.Row="6" HorizontalAlignment="Left" VerticalAlignment="Center"/>
					</Grid>
				</Grid>
			</TabItem>
			<TabItem Name="SrvTweak_Tab" Header="Service Tweaks">
				<Grid Background="#FFE5E5E5">
					<Grid.ColumnDefinitions>
						<ColumnDefinition Width="*"/>
						<ColumnDefinition Width="*"/>
					</Grid.ColumnDefinitions>
					<Grid Grid.Column="0">
						<Grid.RowDefinitions>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
						</Grid.RowDefinitions>
						<Grid.ColumnDefinitions>
							<ColumnDefinition Width="7*"/>
							<ColumnDefinition Width="5*"/>
						</Grid.ColumnDefinitions>
						<Label Content="UAC Level:" Grid.Column="0" Grid.Row="0" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="UAC_Combo" Grid.Column="1" Grid.Row="0" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="Sharing mapped drives:" Grid.Column="0" Grid.Row="1" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="SharingMappedDrives_Combo" Grid.Column="1" Grid.Row="1" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="Administrative Shares:" Grid.Column="0" Grid.Row="2" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="AdminShares_Combo" Grid.Column="1" Grid.Row="2" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="Firewall:" Grid.Column="0" Grid.Row="3" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="Firewall_Combo" Grid.Column="1" Grid.Row="3" HorizontalAlignment="Left" VerticalAlignment="Center"/>
					</Grid>
					<Grid Grid.Column="1">
						<Grid.RowDefinitions>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
						</Grid.RowDefinitions>
						<Grid.ColumnDefinitions>
							<ColumnDefinition Width="7*"/>
							<ColumnDefinition Width="5*"/>
						</Grid.ColumnDefinitions>
						<Label Content="Windows Defender:" Grid.Column="0" Grid.Row="0" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="WinDefender_Combo" Grid.Column="1" Grid.Row="0" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="HomeGroups:" Grid.Column="0" Grid.Row="1" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="HomeGroups_Combo" Grid.Column="1" Grid.Row="1" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="Remote Assistance:" Grid.Column="0" Grid.Row="2" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="RemoteAssistance_Combo" Grid.Column="1" Grid.Row="2" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="Remote Desktop w/o Network Authentication:" Grid.Column="0" Grid.Row="3" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="RemoteDesktop_Combo" Grid.Column="1" Grid.Row="3" HorizontalAlignment="Left" VerticalAlignment="Center"/>
					</Grid>
				</Grid>
			</TabItem>
			<TabItem Name="Context_Tab" Header="Context Menu, &#xD;&#xA;Start Menu">
				<Grid Background="#FFE5E5E5">
					<Grid.ColumnDefinitions>
						<ColumnDefinition Width="*"/>
						<ColumnDefinition Width="*"/>
					</Grid.ColumnDefinitions>
					<GroupBox Header="Context Menu" Grid.Column="0" Margin="5">
						<Grid>
							<Grid.RowDefinitions>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
							</Grid.RowDefinitions>
							<Grid.ColumnDefinitions>
								<ColumnDefinition Width="2*"/>
								<ColumnDefinition Width="*"/>
							</Grid.ColumnDefinitions>
							<Label Content="Cast to Device:" Grid.Column="0" Grid.Row="0" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="CastToDevice_Combo" Grid.Column="1" Grid.Row="0" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Previous Versions:" Grid.Column="0" Grid.Row="1" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="PreviousVersions_Combo" Grid.Column="1" Grid.Row="1" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Include in Library:" Grid.Column="0" Grid.Row="2" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="IncludeinLibrary_Combo" Grid.Column="1" Grid.Row="2" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Pin To Start:" Grid.Column="0" Grid.Row="3" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="PinToStart_Combo" Grid.Column="1" Grid.Row="3" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Pin To Quick Access:" Grid.Column="0" Grid.Row="4" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="PinToQuickAccess_Combo" Grid.Column="1" Grid.Row="4" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Share With/Share:" Grid.Column="0" Grid.Row="5" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="ShareWith_Combo" Grid.Column="1" Grid.Row="5" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Send To:" Grid.Column="0" Grid.Row="6" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="SendTo_Combo" Grid.Column="1" Grid.Row="6" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						</Grid>
					</GroupBox>
					<GroupBox Header="Start Menu" Grid.Column="1" Margin="5">
						<Grid>
							<Grid.RowDefinitions>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
							</Grid.RowDefinitions>
							<Grid.ColumnDefinitions>
								<ColumnDefinition Width="*"/>
								<ColumnDefinition Width="*"/>
							</Grid.ColumnDefinitions>
							<Label Content="Bing Search:" Grid.Column="0" Grid.Row="0" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="StartMenuWebSearch_Combo" Grid.Column="1" Grid.Row="0" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Start Suggestions:" Grid.Column="0" Grid.Row="1" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="StartSuggestions_Combo" Grid.Column="1" Grid.Row="1" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Most Used Apps:" Grid.Column="0" Grid.Row="2" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="MostUsedAppStartMenu_Combo" Grid.Column="1" Grid.Row="2" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Recent Items/Frequent Places:" Grid.Column="0" Grid.Row="3" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="RecentItemsFrequent_Combo" Grid.Column="1" Grid.Row="3" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Unpin All Items:" Grid.Column="0" Grid.Row="4" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="UnpinItems_Combo" Grid.Column="1" Grid.Row="4" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						</Grid>
					</GroupBox>
				</Grid>
			</TabItem>
			<TabItem Name="TaskBar_Tab" Header="Task Bar">
				<Grid Background="#FFE5E5E5">
					<Grid.ColumnDefinitions>
						<ColumnDefinition Width="2*"/>
						<ColumnDefinition Width="*"/>
						<ColumnDefinition Width="2*"/>
						<ColumnDefinition Width="*"/>
					</Grid.ColumnDefinitions>
					<Grid.RowDefinitions>
						<RowDefinition Height="*"/>
						<RowDefinition Height="*"/>
						<RowDefinition Height="*"/>
						<RowDefinition Height="*"/>
						<RowDefinition Height="*"/>
						<RowDefinition Height="*"/>
						<RowDefinition Height="*"/>
					</Grid.RowDefinitions>
					<Label Content="Battery UI Bar:" Grid.Column="0" Grid.Row="0" HorizontalAlignment="Right" VerticalAlignment="Center"/>
					<ComboBox Name="BatteryUIBar_Combo" Grid.Column="1" Grid.Row="0" HorizontalAlignment="Left" VerticalAlignment="Center"/>
					<Label Content="Clock UI Bar:" Grid.Column="0" Grid.Row="1" HorizontalAlignment="Right" VerticalAlignment="Center"/>
					<ComboBox Name="ClockUIBar_Combo" Grid.Column="1" Grid.Row="1" HorizontalAlignment="Left" VerticalAlignment="Center"/>
					<Label Content="Volume Control Bar:" Grid.Column="0" Grid.Row="2" HorizontalAlignment="Right" VerticalAlignment="Center"/>
					<ComboBox Name="VolumeControlBar_Combo" Grid.Column="1" Grid.Row="2" HorizontalAlignment="Left" VerticalAlignment="Center"/>
					<Label Content="Taskbar Search box:" Grid.Column="0" Grid.Row="3" HorizontalAlignment="Right" VerticalAlignment="Center"/>
					<ComboBox Name="TaskbarSearchBox_Combo" Grid.Column="1" Grid.Row="3" HorizontalAlignment="Left" VerticalAlignment="Center"/>
					<Label Content="Task View button:" Grid.Column="0" Grid.Row="4" HorizontalAlignment="Right" VerticalAlignment="Center"/>
					<ComboBox Name="TaskViewButton_Combo" Grid.Column="1" Grid.Row="4" HorizontalAlignment="Left" VerticalAlignment="Center"/>
					<Label Content="Taskbar Icon Size:" Grid.Column="0" Grid.Row="5" HorizontalAlignment="Right" VerticalAlignment="Center"/>
					<ComboBox Name="TaskbarIconSize_Combo" Grid.Column="1" Grid.Row="5" HorizontalAlignment="Left" VerticalAlignment="Center"/>
					<Label Content="Taskbar Item Grouping:" Grid.Column="2" Grid.Row="0" HorizontalAlignment="Right" VerticalAlignment="Center"/>
					<ComboBox Name="TaskbarGrouping_Combo" Grid.Column="3" Grid.Row="0" HorizontalAlignment="Left" VerticalAlignment="Center"/>
					<Label Content="Tray Icons:" Grid.Column="2" Grid.Row="1" HorizontalAlignment="Right" VerticalAlignment="Center"/>
					<ComboBox Name="TrayIcons_Combo" Grid.Column="3" Grid.Row="1" HorizontalAlignment="Left" VerticalAlignment="Center"/>
					<Label Content="Seconds In Clock:" Grid.Column="2" Grid.Row="2" HorizontalAlignment="Right" VerticalAlignment="Center"/>
					<ComboBox Name="SecondsInClock_Combo" Grid.Column="3" Grid.Row="2" HorizontalAlignment="Left" VerticalAlignment="Center"/>
					<Label Content="Last Active Click:" Grid.Column="2" Grid.Row="3" HorizontalAlignment="Right" VerticalAlignment="Center"/>
					<ComboBox Name="LastActiveClick_Combo" Grid.Column="3" Grid.Row="3" HorizontalAlignment="Left" VerticalAlignment="Center"/>
					<Label Content="Taskbar on Multi Display:" Grid.Column="2" Grid.Row="4" HorizontalAlignment="Right" VerticalAlignment="Center"/>
					<ComboBox Name="TaskBarOnMultiDisplay_Combo" Grid.Column="3" Grid.Row="4" HorizontalAlignment="Left" VerticalAlignment="Center"/>
					<Label Content="Taskbar Button on Multi Display:" Grid.Column="0" Grid.ColumnSpan="2" Grid.Row="6" HorizontalAlignment="Right" VerticalAlignment="Center"/>
					<ComboBox Name="TaskbarButtOnDisplay_Combo" Grid.Column="2" Grid.Row="6" HorizontalAlignment="Left" VerticalAlignment="Center"/>
				</Grid>
			</TabItem>
			<TabItem Name="Explorer_Tab" Header="Explorer">
				<Grid Background="#FFE5E5E5">
					<Grid.ColumnDefinitions>
						<ColumnDefinition Width="4*"/>
						<ColumnDefinition Width="3*"/>
					</Grid.ColumnDefinitions>
					<Grid Grid.Column="0">
						<Grid.RowDefinitions>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
							<RowDefinition Name="Timeline_Row" Height="*"/>
						</Grid.RowDefinitions>
						<Grid.ColumnDefinitions>
							<ColumnDefinition Width="2*"/>
							<ColumnDefinition Width="*"/>
						</Grid.ColumnDefinitions>
						<Label Content="Recent Files in Quick Access:" Grid.Column="0" Grid.Row="0" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="RecentFileQikAcc_Combo" Grid.Column="1" Grid.Row="0" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="Frequent folders in Quick_access:" Grid.Column="0" Grid.Row="1" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="FrequentFoldersQikAcc_Combo" Grid.Column="1" Grid.Row="1" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="Window Content while Dragging:" Grid.Column="0" Grid.Row="2" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="WinContentWhileDrag_Combo" Grid.Column="1" Grid.Row="2" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="Search Store for Unkn. Extensions:" Grid.Column="0" Grid.Row="3" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="StoreOpenWith_Combo" Grid.Column="1" Grid.Row="3" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="Long File Path:" Grid.Column="0" Grid.Row="4" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="LongFilePath_Combo" Grid.Column="1" Grid.Row="4" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="Default Explorer View:" Grid.Column="0" Grid.Row="5" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="ExplorerOpenLoc_Combo" Grid.Column="1" Grid.Row="5" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="Powershell to Cmd:" Grid.Column="0" Grid.Row="6" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="WinXPowerShell_Combo" Grid.Column="1" Grid.Row="6" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="App Hibernation File (Swapfile.sys):" Grid.Column="0" Grid.Row="7" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="AppHibernationFile_Combo" Grid.Column="1" Grid.Row="7" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="Process ID on Title Bar:" Grid.Column="0" Grid.Row="8" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="PidInTitleBar_Combo" Grid.Column="1" Grid.Row="8" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="Accessability Key Prompt:" Grid.Column="0" Grid.Row="9" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="AccessKeyPrmpt_Combo" Grid.Column="1" Grid.Row="9" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="Window Timeline:" Grid.Column="0" Grid.Row="10" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="Timeline_Combo" Grid.Column="1" Grid.Row="10" HorizontalAlignment="Left" VerticalAlignment="Center"/>
					</Grid>
					<Grid Grid.Column="1">
						<Grid.RowDefinitions>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
							<RowDefinition Height="*"/>
							<RowDefinition Name="ReopenAppsOnBoot_Row" Height="*"/>
						</Grid.RowDefinitions>
						<Grid.ColumnDefinitions>
							<ColumnDefinition Width="3*"/>
							<ColumnDefinition Width="2*"/>
						</Grid.ColumnDefinitions>
						<Label Content="Aero Snap:" Grid.Column="0" Grid.Row="0" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="AeroSnap_Combo" Grid.Column="1" Grid.Row="0" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="Aero Shake:" Grid.Column="0" Grid.Row="1" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="AeroShake_Combo" Grid.Column="1" Grid.Row="1" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="Known Extensions:" Grid.Column="0" Grid.Row="2" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="KnownExtensions_Combo" Grid.Column="1" Grid.Row="2" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="Hidden Files:" Grid.Column="0" Grid.Row="3" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="HiddenFiles_Combo" Grid.Column="1" Grid.Row="3" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="System Files:" Grid.Column="0" Grid.Row="4" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="SystemFiles_Combo" Grid.Column="1" Grid.Row="4" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="Autoplay:" Grid.Column="0" Grid.Row="5" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="Autoplay_Combo" Grid.Column="1" Grid.Row="5" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="Autorun:" Grid.Column="0" Grid.Row="6" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="Autorun_Combo" Grid.Column="1" Grid.Row="6" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="Task Manager Details:" Grid.Column="0" Grid.Row="7" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="TaskManagerDetails_Combo" Grid.Column="1" Grid.Row="7" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="F1 Help Key:" Grid.Column="0" Grid.Row="8" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="F1HelpKey_Combo" Grid.Column="1" Grid.Row="8" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						<Label Content="Reopen Apps On Boot:" Grid.Column="0" Grid.Row="9" HorizontalAlignment="Right" VerticalAlignment="Center"/>
						<ComboBox Name="ReopenAppsOnBoot_Combo" Grid.Column="1" Grid.Row="9" HorizontalAlignment="Left" VerticalAlignment="Center"/>
					</Grid>
				</Grid>
			</TabItem>
			<TabItem Name="Desktop_Tab" Header="Desktop, This PC">
				<Grid Background="#FFE5E5E5">
					<Grid.ColumnDefinitions>
						<ColumnDefinition Width="*"/>
						<ColumnDefinition Width="*"/>
					</Grid.ColumnDefinitions>
					<GroupBox Header="Desktop" Grid.Column="0" Margin="5">
						<Grid>
							<Grid.RowDefinitions>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
							</Grid.RowDefinitions>
							<Grid.ColumnDefinitions>
								<ColumnDefinition Width="*"/>
								<ColumnDefinition Width="*"/>
							</Grid.ColumnDefinitions>
							<Label Content="This PC Icon:" Grid.Column="0" Grid.Row="0" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="ThisPCOnDesktop_Combo" Grid.Column="1" Grid.Row="0" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Network Icon:" Grid.Column="0" Grid.Row="1" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="NetworkOnDesktop_Combo" Grid.Column="1" Grid.Row="1" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Recycle Bin Icon:" Grid.Column="0" Grid.Row="2" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="RecycleBinOnDesktop_Combo" Grid.Column="1" Grid.Row="2" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Users File Icon:" Grid.Column="0" Grid.Row="3" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="UsersFileOnDesktop_Combo" Grid.Column="1" Grid.Row="3" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Control Panel Icon:" Grid.Column="0" Grid.Row="4" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="ControlPanelOnDesktop_Combo" Grid.Column="1" Grid.Row="4" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						</Grid>
					</GroupBox>
					<GroupBox Header="This PC" Grid.Column="1" Margin="5">
						<Grid>
							<Grid.RowDefinitions>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Name="ThreeDobjectsIconInThisPC_Row" Height="*"/>
								<RowDefinition Height="*"/>
							</Grid.RowDefinitions>
							<Grid.ColumnDefinitions>
								<ColumnDefinition Width="*"/>
								<ColumnDefinition Width="*"/>
							</Grid.ColumnDefinitions>
							<Label Content="Desktop Folder:" Grid.Column="0" Grid.Row="0" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="DesktopIconInThisPC_Combo" Grid.Column="1" Grid.Row="0" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Documents Folder:" Grid.Column="0" Grid.Row="1" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="DocumentsIconInThisPC_Combo" Grid.Column="1" Grid.Row="1" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Downloads Folder:" Grid.Column="0" Grid.Row="2" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="DownloadsIconInThisPC_Combo" Grid.Column="1" Grid.Row="2" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Music Folder:" Grid.Column="0" Grid.Row="3" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="MusicIconInThisPC_Combo" Grid.Column="1" Grid.Row="3" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Pictures Folder:" Grid.Column="0" Grid.Row="4" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="PicturesIconInThisPC_Combo" Grid.Column="1" Grid.Row="4" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Videos Folder:" Grid.Column="0" Grid.Row="5" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="VideosIconInThisPC_Combo" Grid.Column="1" Grid.Row="5" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="3D Objects Folder:" Grid.Column="0" Grid.Row="6" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="ThreeDobjectsIconInThisPC_Combo" Grid.Column="1" Grid.Row="6" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="**Remove may cause problems" Grid.Column="0" Grid.ColumnSpan="2" Grid.Row="7" HorizontalAlignment="Center" VerticalAlignment="Center"/>
						</Grid>
					</GroupBox>
				</Grid>
			</TabItem>
			<TabItem Name="Misc_Tab" Header="Photo Viewer, &#xD;&#xA;LockScreen, Misc">
				<Grid Background="#FFE5E5E5">
					<Grid.ColumnDefinitions>
						<ColumnDefinition Width="2.5*"/>
						<ColumnDefinition Width="2*"/>
					</Grid.ColumnDefinitions>
					<Grid>
						<Grid Grid.Column="0">
							<Grid.RowDefinitions>
								<RowDefinition Height="2*"/>
								<RowDefinition Height="4*"/>
							</Grid.RowDefinitions>
							<GroupBox Header="Photo Viewer" Grid.Row="0" Margin="10">
								<Grid>
									<Grid.RowDefinitions>
										<RowDefinition Height="*"/>
										<RowDefinition Height="*"/>
									</Grid.RowDefinitions>
									<Grid.ColumnDefinitions>
										<ColumnDefinition Width="*"/>
										<ColumnDefinition Width="*"/>
									</Grid.ColumnDefinitions>
									<Label Content="File Association:" Grid.Column="0" Grid.Row="0" HorizontalAlignment="Right" VerticalAlignment="Center"/>
									<ComboBox Name="PVFileAssociation_Combo" Grid.Column="1" Grid.Row="0" HorizontalAlignment="Left" VerticalAlignment="Center"/>
									<Label Content="Add Open with...:" Grid.Column="0" Grid.Row="1" HorizontalAlignment="Right" VerticalAlignment="Center"/>
									<ComboBox Name="PVOpenWithMenu_Combo" Grid.Column="1" Grid.Row="1" HorizontalAlignment="Left" VerticalAlignment="Center"/>
								</Grid>
							</GroupBox>
							<GroupBox Header="Lockscreen" Grid.Row="1" Margin="5">
								<Grid>
									<Grid.RowDefinitions>
										<RowDefinition Height="*"/>
										<RowDefinition Height="*"/>
										<RowDefinition Height="*"/>
										<RowDefinition Height="*"/>
										<RowDefinition Height="*"/>
									</Grid.RowDefinitions>
									<Grid.ColumnDefinitions>
										<ColumnDefinition Width="5*"/>
										<ColumnDefinition Width="2*"/>
									</Grid.ColumnDefinitions>
									<Label Content="Lockscreen:" Grid.Column="0" Grid.Row="0" HorizontalAlignment="Right" VerticalAlignment="Center"/>
									<ComboBox Name="Lockscreen_Combo" Grid.Column="1" Grid.Row="0" HorizontalAlignment="Left" VerticalAlignment="Center"/>
									<Label Content="Lockscreen Prompt Password:" Grid.Column="0" Grid.Row="1" HorizontalAlignment="Right" VerticalAlignment="Center"/>
									<ComboBox Name="LockscreenPassword_Combo" Grid.Column="1" Grid.Row="1" HorizontalAlignment="Left" VerticalAlignment="Center"/>
									<Label Content="Power Menu:" Grid.Column="0" Grid.Row="2" HorizontalAlignment="Right" VerticalAlignment="Center"/>
									<ComboBox Name="PowerMenuLockScreen_Combo" Grid.Column="1" Grid.Row="2" HorizontalAlignment="Left" VerticalAlignment="Center"/>
									<Label Content="Camera:" Grid.Column="0" Grid.Row="3" HorizontalAlignment="Right" VerticalAlignment="Center"/>
									<ComboBox Name="CameraOnLockscreen_Combo" Grid.Column="1" Grid.Row="3" HorizontalAlignment="Left" VerticalAlignment="Center"/>
									<Label Content="Account Protection Warning:" Grid.Column="0" Grid.Row="4" HorizontalAlignment="Right" VerticalAlignment="Center"/>
									<ComboBox Name="AccountProtectionWarn_Combo" Grid.Column="1" Grid.Row="4" HorizontalAlignment="Left" VerticalAlignment="Center"/>
								</Grid>
							</GroupBox>
						</Grid>
					</Grid>
					<GroupBox Header="Misc" Grid.Column="1" Margin="5">
						<Grid>
							<Grid.RowDefinitions>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="1.5*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
							</Grid.RowDefinitions>
							<Grid.ColumnDefinitions>
								<ColumnDefinition Width="3*"/>
								<ColumnDefinition Width="2*"/>
							</Grid.ColumnDefinitions>
							<Label Content="ScreenSaver:" Grid.Column="0" Grid.Row="0" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="ScreenSaver_Combo" Grid.Column="1" Grid.Row="0" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Action Center:" Grid.Column="0" Grid.Row="1" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="ActionCenter_Combo" Grid.Column="1" Grid.Row="1" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Sticky Key Prompt:" Grid.Column="0" Grid.Row="2" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="StickyKeyPrompt_Combo" Grid.Column="1" Grid.Row="2" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Num Lock on Startup:" Grid.Column="0" Grid.Row="3" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="NumblockOnStart_Combo" Grid.Column="1" Grid.Row="3" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="F8 Boot Menu:" Grid.Column="0" Grid.Row="4" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="F8BootMenu_Combo" Grid.Column="1" Grid.Row="4" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Remote UAC Local &#xD;&#xA;Account Token Filter" Grid.Column="0" Grid.Row="5" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="RemoteUACAcctToken_Combo" Grid.Column="1" Grid.Row="5" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Hibernate Option:" Grid.Column="0" Grid.Row="6" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="HibernatePower_Combo" Grid.Column="1" Grid.Row="6" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Sleep Option:" Grid.Column="0" Grid.Row="7" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="SleepPower_Combo" Grid.Column="1" Grid.Row="7" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						</Grid>
					</GroupBox>
				</Grid>
			</TabItem>
			<TabItem Name="WinApp_Tab" Header="Window App">
				<DataGrid Name="dataGrid" AlternationCount="2" AutoGenerateColumns="False" CanUserAddRows="False" HeadersVisibility="Column" IsTabStop="True" SelectionMode="Extended">
					<DataGrid.RowStyle>
						<Style TargetType="{ x:Type DataGridRow }">
							<Style.Triggers>
								<Trigger Property="AlternationIndex" Value="0"><Setter Property="Background" Value="White"/></Trigger>
								<Trigger Property="AlternationIndex" Value="1"><Setter Property="Background" Value="#FFD8D8D8"/></Trigger>
							</Style.Triggers>
						</Style>
					</DataGrid.RowStyle>
					<DataGrid.Columns>
						<DataGridTextColumn Header="Display Name" Width="150" Binding="{Binding CName}" CanUserSort="True" IsReadOnly="True"/>
						<DataGridTemplateColumn Width="80" CanUserSort="True" Header="Option" SortMemberPath="AppSelected">
							<DataGridTemplateColumn.CellTemplate>
								<DataTemplate>
									<ComboBox ItemsSource="{Binding AppOptions}" Text="{Binding Path=AppSelected, Mode=TwoWay, UpdateSourceTrigger=PropertyChanged}"/>
								</DataTemplate>
							</DataGridTemplateColumn.CellTemplate>
						</DataGridTemplateColumn>
						<DataGridTextColumn Header="Appx Name" Width="180" Binding="{Binding AppxName}" IsReadOnly="True"/>
					</DataGrid.Columns>
				</DataGrid>
			</TabItem>
			<TabItem Name="Application_Tab" Header="Application, &#xD;&#xA;Windows Update">
				<Grid Background="#FFE5E5E5">
					<Grid.ColumnDefinitions>
						<ColumnDefinition Width="*"/>
						<ColumnDefinition Width="*"/>
					</Grid.ColumnDefinitions>
					<GroupBox Grid.Column="0" Margin="5" Header="Application/Feature">
						<Grid>
							<Grid.RowDefinitions>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Name="LinuxSubsystem_Row" Height="*"/>
							</Grid.RowDefinitions>
							<Grid.ColumnDefinitions>
								<ColumnDefinition Width="*"/>
								<ColumnDefinition Width="*"/>
							</Grid.ColumnDefinitions>
							<Label Content="OneDrive:" Grid.Column="0" Grid.Row="0" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="OneDrive_Combo" Grid.Column="1" Grid.Row="0" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="OneDrive Install:" Grid.Column="0" Grid.Row="1" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="OneDriveInstall_Combo" Grid.Column="1" Grid.Row="1" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Xbox DVR:" Grid.Column="0" Grid.Row="2" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="XboxDVR_Combo" Grid.Column="1" Grid.Row="2" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="MediaPlayer:" Grid.Column="0" Grid.Row="3" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="MediaPlayer_Combo" Grid.Column="1" Grid.Row="3" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Work Folders:" Grid.Column="0" Grid.Row="4" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="WorkFolders_Combo" Grid.Column="1" Grid.Row="4" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Fax And Scan:" Grid.Column="0" Grid.Row="5" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="FaxAndScan_Combo" Grid.Column="1" Grid.Row="5" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Linux Subsystem:" Grid.Column="0" Grid.Row="6" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="LinuxSubsystem_Combo" Grid.Column="1" Grid.Row="6" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						</Grid>
					</GroupBox>
					<GroupBox Header="Windows Update" Grid.Column="1" Margin="5">
						<Grid>
							<Grid.RowDefinitions>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
								<RowDefinition Height="*"/>
							</Grid.RowDefinitions>
							<Grid.ColumnDefinitions>
								<ColumnDefinition Width="9*"/>
								<ColumnDefinition Width="5*"/>
							</Grid.ColumnDefinitions>
							<Label Content="Check for Update:" Grid.Column="0" Grid.Row="0" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="CheckForWinUpdate_Combo" Grid.Column="1" Grid.Row="0" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Update Check Type:" Grid.Column="0" Grid.Row="1" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="WinUpdateType_Combo" Grid.Column="1" Grid.Row="1" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Update P2P:" Grid.Column="0" Grid.Row="2" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="WinUpdateDownload_Combo" Grid.Column="1" Grid.Row="2" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Update MSRT:" Grid.Column="0" Grid.Row="3" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="UpdateMSRT_Combo" Grid.Column="1" Grid.Row="3" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Update Driver:" Grid.Column="0" Grid.Row="4" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="UpdateDriver_Combo" Grid.Column="1" Grid.Row="4" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Restart on Update:" Grid.Column="0" Grid.Row="5" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="RestartOnUpdate_Combo" Grid.Column="1" Grid.Row="5" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Update Available Popup:" Grid.Column="0" Grid.Row="6" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="UpdateAvailablePopup_Combo" Grid.Column="1" Grid.Row="6" HorizontalAlignment="Left" VerticalAlignment="Center"/>
							<Label Content="Update MS Products:" Grid.Column="0" Grid.Row="7" HorizontalAlignment="Right" VerticalAlignment="Center"/>
							<ComboBox Name="UpdateMSProducts_Combo" Grid.Column="1" Grid.Row="7" HorizontalAlignment="Left" VerticalAlignment="Center"/>
						</Grid>
					</GroupBox>
				</Grid>
			</TabItem>
		</TabControl>
		<Button Name="RunScriptButton" Content="Run Script" Height="20" Grid.Row="2" VerticalAlignment="Bottom" FontWeight="Bold"/>
	</Grid>
</Window>
"@
	[Void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
	$Form = [Windows.Markup.XamlReader]::Load( (New-Object System.Xml.XmlNodeReader $xaml) )
	$xaml.SelectNodes('//*[@Name]').ForEach{Set-Variable -Name "WPF_$($_.Name)" -Value $Form.FindName($_.Name) -Scope Script}
	$Runspace = [RunSpaceFactory]::CreateRunspace()
	$PowerShell = [PowerShell]::Create()
	$PowerShell.RunSpace = $Runspace
	$Runspace.Open()
	[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null

	$Script:WPFList = Get-Variable -Name 'WPF_*'
	[System.Collections.ArrayList]$VarList = ForEach($Var In (Get-Variable -Name 'WPF_*_Combo')){ $Var.Name.Split('_')[1] }

	$WPF_Madbomb122WSButton.Add_Click{ OpenWebsite 'https://GitHub.com/madbomb122/' }
	$WPF_FeedbackButton.Add_Click{ OpenWebsite "$MySite/issues" }
	$WPF_FAQButton.Add_Click{ OpenWebsite "$MySite/blob/master/README.md" }
	$WPF_DonateButton.Add_Click{ OpenWebsite $Donate_Url }
	$WPF_CreateRestorePoint_CB.Add_Click{ $WPF_RestorePointName_Txt.IsEnabled = $WPF_CreateRestorePoint_CB.IsChecked }
	$WPF_RunScriptButton.Add_Click{ GuiDone }
	$WPF_WinDefault_Button.Add_Click{ LoadWinDefault ;SelectComboBox $VarList }
	$WPF_ResetDefault_Button.Add_Click{ SetDefault ;SelectComboBox $VarList ;SetAppxVar }
	$WPF_Load_Setting_Button.Add_Click{ OpenSaveDiaglog 0 }
	$WPF_Save_Setting_Button.Add_Click{ OpenSaveDiaglog 1 }
	$WPF_AboutButton.Add_Click{ [Windows.Forms.Messagebox]::Show('This script lets you do Various Settings and Tweaks for Windows 10. For manual or Automated use.','About', 'OK') | Out-Null }
	$WPF_CopyrightButton.Add_Click{ [Windows.Forms.Messagebox]::Show($Copyright,'Copyright', 'OK') | Out-Null }

$Skip_EnableD_Disable = @(
'F1HelpKey',
'AccessKeyPrmpt',
'Telemetry',
'WiFiSense',
'SmartScreen',
'LocationTracking',
'Feedback',
'AdvertisingID',
'Cortana',
'CortanaSearch',
'ErrorReporting',
'AutoLoggerFile',
'DiagTrack',
'WAPPush',
'CheckForWinUpdate',
'UpdateMSRT',
'UpdateDriver',
'RestartOnUpdate',
'AppAutoDownload',
'AdminShares',
'Firewall',
'WinDefender',
'HomeGroups',
'RemoteAssistance',
'CastToDevice',
'PreviousVersions',
'IncludeinLibrary',
'PinToStart',
'PinToQuickAccess',
'ShareWith',
'SendTo',
'OneDrive',
'XboxDVR',
'TaskBarOnMultiDisplay',
'StartMenuWebSearch',
'StartSuggestions',
'RecentItemsFrequent',
'Autoplay',
'Autorun',
'AeroSnap',
'AeroShake',
'StoreOpenWith',
'LockScreen',
'LockScreenPassword',
'ScreenSaver',
'CameraOnLockScreen',
'ActionCenter',
'AccountProtectionWarn',
'StickyKeyPrompt',
'SleepPower',
'ReopenAppsOnBoot',
'Timeline',
'UpdateAvailablePopup',
'AppHibernationFile')

$Skip_Enable_DisableD = @(
'UpdateMSProducts',
'SharingMappedDrives',
'RemoteDesktop',
'LastActiveClick',
'NumblockOnStart',
'F8BootMenu',
'RemoteUACAcctToken',
'PVFileAssociation',
'PVOpenWithMenu',
'LongFilePath')

$Skip_ShowD_Hide = @(
'TaskbarSearchBox',
'TaskViewButton',
'MostUsedAppStartMenu',
'FrequentFoldersQikAcc',
'WinContentWhileDrag',
'RecycleBinOnDesktop',
'PowerMenuLockScreen')

$Skip_ShowD_Hide_Remove = @(
'DesktopIconInThisPC',
'DocumentsIconInThisPC',
'DownloadsIconInThisPC',
'ThreeDobjectsIconInThisPC',
'MusicIconInThisPC',
'PicturesIconInThisPC',
'VideosIconInThisPC')


$Skip_Show_HideD = @(
'SecondsInClock',
'PidInTitleBar',
'KnownExtensions',
'HiddenFiles',
'SystemFiles',
'TaskManagerDetails',
'ThisPCOnDesktop',
'NetworkOnDesktop',
'UsersFileOnDesktop',
'ControlPanelOnDesktop')

$Skip_InstalledD_Uninstall = @('OneDriveInstall','MediaPlayer','WorkFolders','FaxAndScan')

	If($Release_Type -eq 'Testing'){
		$Script:Restart = 0
		$WPF_Restart_CB.IsEnabled = $False
		$WPF_Restart_CB.Content += ' (Disabled in Testing Version)'
	}
	If($Win10Ver -lt 1607){ $WPF_LinuxSubsystem_Row.Height = 0 }
	If($Win10Ver -lt 1709){
		$WPF_ThreeDobjectsIconInThisPC_Row, $WPF_ReopenAppsOnBoot_Row | Foreach-Object{ $_.Height = 0 }
	}
	If($Win10Ver -lt 1803){
		$WPF_AccountProtectionWarn_Row, $WPF_Timeline_Row | Foreach-Object{ $_.Height = 0 }
	}
	ForEach($Var In $Skip_EnableD_Disable){ SetCombo $Var 'Enable*,Disable' }
	ForEach($Var In $Skip_Enable_DisableD){ SetCombo $Var 'Enable,Disable*' }
	ForEach($Var In $Skip_ShowD_Hide_Remove){ SetCombo $Var 'Show/Add*,Hide,Remove**' }
	ForEach($Var In $Skip_ShowD_Hide){ SetCombo $Var 'Show*,Hide' }
	ForEach($Var In $Skip_Show_HideD){ SetCombo $Var 'Show,Hide*' }
	ForEach($Var In $Skip_InstalledD_Uninstall){ SetCombo $Var 'Installed*,Uninstall' }

	SetCombo 'LinuxSubsystem' 'Installed,Uninstall*'
	SetCombo 'HibernatePower' 'Enable,Disable'
	SetCombo 'UAC' 'Disable,Normal*,Higher'
	SetCombo 'BatteryUIBar' 'New*,Classic'
	SetCombo 'ClockUIBar' 'New*,Classic'
	SetCombo 'VolumeControlBar' 'New(Horizontal)*,Classic(Vertical)'
	SetCombo 'TaskbarIconSize' 'Normal*,Smaller'
	SetCombo 'TaskbarGrouping' 'Never,Always*,When Needed'
	SetCombo 'TrayIcons' 'Auto*,Always Show'
	SetCombo 'TaskBarButtOnDisplay' 'All,Where Window is Open,Main & Where Window is Open'
	SetCombo 'UnpinItems' 'Unpin'
	SetCombo 'ExplorerOpenLoc' 'Quick Access*,ThisPC'
	SetCombo 'RecentFileQikAcc' 'Show/Add*,Hide,Remove'
	SetCombo 'WinXPowerShell' 'PowerShell,Command Prompt'
	SetCombo 'WinUpdateType' 'Notify,Auto DL,Auto DL+Install*,Admin Config'
	SetCombo 'WinUpdateDownload' 'P2P*,Local Only,Disable'

	$WPF_dataGrid.ItemsSource = $DataGridApps

	ConfigGUIitms
	$Form.Title += If($Release_Type -ne 'Stable'){ " -$Release_Type)" } Else{ ')' }
	If($Release_Type -eq 'Stable'){ Clear-Host }
	DisplayOut 'Displaying GUI Now' -C 14
	DisplayOut "`nTo exit you can close the GUI or PowerShell Window." -C 14
	$Form.ShowDialog() | Out-Null
}

Function GuiDone {
	GuiItmToVariable
	$Form.Close()
	$Script:RunScr = $True
	RunScript
}

Function GuiItmToVariable {
	ForEach($Var In $VarList){ Set-Variable -Name $Var -Value ($(Get-Variable -Name ('WPF_'+$Var+'_Combo') -ValueOnly).SelectedIndex) -Scope Script }
	$Script:CreateRestorePoint = If($WPF_CreateRestorePoint_CB.IsChecked){ 1 } Else{ 0 }
	$Script:VersionCheck = If($WPF_VersionCheck_CB.IsChecked){ 1 } Else{ 0 }
	$Script:InternetCheck = If($WPF_InternetCheck_CB.IsChecked){ 1 } Else{ 0 }
	$Script:ShowSkipped = If($WPF_ShowSkipped_CB.IsChecked){ 1 } Else{ 0 }
	$Script:Restart = If($WPF_Restart_CB.IsChecked){ 1 } Else{ 0 }
	$Script:RestorePointName = $WPF_RestorePointName_Txt.Text
}

##########
# GUI -End
##########
# Pre-Made Settings -Start
##########

Function LoadWinDefault {
	#Privacy Settings
	$Script:Telemetry = 1
	$Script:WiFiSense = 1
	$Script:SmartScreen = 1
	$Script:LocationTracking = 1
	$Script:Feedback = 1
	$Script:AdvertisingID = 1
	$Script:Cortana = 1
	$Script:CortanaSearch = 1
	$Script:ErrorReporting = 1
	$Script:AutoLoggerFile = 1
	$Script:DiagTrack = 1
	$Script:WAPPush = 1

	#Windows Update
	$Script:UpdateMSProducts = 2
	$Script:CheckForWinUpdate = 1
	$Script:WinUpdateType = 3
	$Script:WinUpdateDownload = 1
	$Script:UpdateMSRT = 1
	$Script:UpdateDriver = 1
	$Script:RestartOnUpdate = 1
	$Script:AppAutoDownload = 1
	$Script:UpdateAvailablePopup = 1

	#Service Tweaks
	$Script:UAC = 2
	$Script:SharingMappedDrives = 2
	$Script:AdminShares = 1
	$Script:Firewall = 1
	$Script:WinDefender = 1
	$Script:HomeGroups = 1
	$Script:RemoteAssistance = 1
	$Script:RemoteDesktop = 2

	#Context Menu Items
	$Script:CastToDevice = 1
	$Script:PreviousVersions = 1
	$Script:IncludeinLibrary = 1
	$Script:PinToStart = 1
	$Script:PinToQuickAccess = 1
	$Script:ShareWith = 1
	$Script:SendTo = 1

	#Task Bar Items
	$Script:BatteryUIBar = 1
	$Script:ClockUIBar = 1
	$Script:VolumeControlBar = 1
	$Script:TaskbarSearchBox = 1
	$Script:TaskViewButton = 1
	$Script:TaskbarIconSize = 1
	$Script:TaskbarGrouping = 2
	$Script:TrayIcons = 1
	$Script:SecondsInClock = 2
	$Script:LastActiveClick = 2
	$Script:TaskBarOnMultiDisplay = 1

	#Star Menu Items
	$Script:StartMenuWebSearch = 1
	$Script:StartSuggestions = 1
	$Script:MostUsedAppStartMenu = 1
	$Script:RecentItemsFrequent = 1

	#Explorer Items
	$Script:AccessKeyPrmpt = 1
	$Script:F1HelpKey = 1
	$Script:Autoplay = 1
	$Script:Autorun = 1
	$Script:PidInTitleBar = 2
	$Script:AeroSnap = 1
	$Script:AeroShake = 1
	$Script:KnownExtensions = 2
	$Script:HiddenFiles = 2
	$Script:SystemFiles = 2
	$Script:ExplorerOpenLoc = 1
	$Script:RecentFileQikAcc = 1
	$Script:FrequentFoldersQikAcc = 1
	$Script:WinContentWhileDrag = 1
	$Script:StoreOpenWith = 1
	$Script:WinXPowerShell = If($Win10Ver -ge 1703){ 1 } Else{ 2 }
	$Script:TaskManagerDetails = 2
	$Script:ReopenAppsOnBoot = 1
	$Script:Timeline = 1
	$Script:LongFilePath = 2
	$Script:AppHibernationFile = 1

	#'This PC' Items
	$Script:DesktopIconInThisPC = 1
	$Script:DocumentsIconInThisPC = 1
	$Script:DownloadsIconInThisPC = 1
	$Script:MusicIconInThisPC = 1
	$Script:PicturesIconInThisPC = 1
	$Script:VideosIconInThisPC = 1
	$Script:ThreeDobjectsIconInThisPC = 1

	#Desktop Items
	$Script:ThisPCOnDesktop = 2
	$Script:NetworkOnDesktop = 2
	$Script:RecycleBinOnDesktop = 1
	$Script:UsersFileOnDesktop = 2
	$Script:ControlPanelOnDesktop = 2

	#Lock Screen
	$Script:LockScreen = 1
	$Script:ScreenSaver = 1
	$Script:PowerMenuLockScreen = 1
	$Script:CameraOnLockScreen = 1

	#Misc items
	$Script:LockscreenPassword = 1
	$Script:AccountProtectionWarn = 1
	$Script:ActionCenter = 1
	$Script:StickyKeyPrompt = 1
	$Script:NumblockOnStart = 2
	$Script:F8BootMenu = 1
	$Script:RemoteUACAcctToken = 2
	$Script:SleepPower = 1

	# Photo Viewer Settings
	$Script:PVFileAssociation = 2
	$Script:PVOpenWithMenu = 2

	# Remove unwanted applications
	$Script:OneDrive = 1
	$Script:OneDriveInstall = 1
	$Script:XboxDVR = 1
	$Script:MediaPlayer = 1
	$Script:WorkFolders = 1
	$Script:FaxAndScan = 1
	$Script:LinuxSubsystem = 2
}

##########
# Pre-Made Settings -End
##########
# Script -Start
##########

Function RunScript {
	If($VersionCheck -eq 1){ UpdateCheck }

	BoxItem 'Pre-Script'
	If($CreateRestorePoint -eq 0 -And $ShowSkipped -eq 1) {
		DisplayOut 'Skipping Creation of System Restore Point...' -C 15
	} ElseIf($CreateRestorePoint -eq 1) {
		DisplayOut "Creating System Restore Point Named '$RestorePointName'" -C 11
		DisplayOut 'Please Wait...' -C 11
		Checkpoint-Computer -Description $RestorePointName | Out-Null
	}

	If(!(Test-Path 'HKCR:')){ New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null }
	If(!(Test-Path 'HKU:')){ New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS | Out-Null }
	$AppxCount = 0

	BoxItem 'Windows App Items'
	$APPS_AppsUnhide += ($DataGridApps.Where{$_.AppSelected -eq 'Unhide'}).AppxName
	$APPS_AppsHide += ($DataGridApps.Where{$_.AppSelected -eq 'Hide'}).AppxName
	$APPS_AppsUninstall += ($DataGridApps.Where{$_.AppSelected -eq 'Uninstall'}).AppxName

	$Ah = $APPS_AppsHide.Length
	$Au = $APPS_AppsUninstall.Length
	If($Ah -gt 0 -or $Au  -gt 0){ $AppxPackages = Get-AppxProvisionedPackage -online | select-object PackageName,Displayname }

	DisplayOut "---List of Apps Being Unhidden---" -C 11
	If($APPS_AppsUnhide.Length -gt 0) {
		ForEach($AppI In $APPS_AppsUnhide) {
			$AppInst = Get-AppxPackage -AllUsers $AppI
			If($AppInst -ne $null) {
				DisplayOut $AppI -C 11
				ForEach($App In $AppInst){
					$AppxCount++
					$Job = "Win10Script$AppxCount"
					Start-Job -Name $Job -ScriptBlock {
						$AppIJob = $using:App
						$TempIJob = $($AppIJob.InstallLocation)
						Add-AppxPackage -DisableDevelopmentMode -Register "$TempIJob\AppXManifest.xml"
					}
				}
			} Else {
				DisplayOut "Unable to Unhide $AppI" -C 11
			}
		}
	} Else {
		DisplayOut 'No Apps being Unhidden' -C 11
	}
	DisplayOut "`n---List of Apps Being Hiddden---" -C 12
	If($Ah -gt 0) {
		ForEach($AppH In $APPS_AppsHide) {
			If($AppxPackages.DisplayName.Contains($AppH)) {
				DisplayOut $AppH -C 12
				$AppxCount++
				$Job = "Win10Script$AppxCount"
				Start-Job -Name $Job -ScriptBlock { Get-AppxPackage $using:AppH | Remove-AppxPackage | Out-null }
			} Else {
				DisplayOut "$AppH Isn't Installed" -C 12
			}
		}
	} Else {
		DisplayOut 'No Apps being Hidden' -C 12
	}
	DisplayOut "`n---List of Apps Being Uninstalled---" -C 14
	If($Au -gt 0) {
		ForEach($AppU In $APPS_AppsUninstall) {
			If($AppxPackages.DisplayName.Contains($AppU)) {
				DisplayOut $AppU -C 14
				$PackageFullName = (Get-AppxPackage $AppU).PackageFullName
				$ProPackageFullName = ($AppxPackages.Where{$_.Displayname -eq $AppU}).PackageName
				# Alt removal: DISM /Online /Remove-ProvisionedAppxPackage /PackageName:
				$AppxCount++
				$Job = "Win10Script$AppxCount"
				Start-Job -Name $Job -ScriptBlock {
					Remove-AppxPackage -Package $using:PackageFullName | Out-null
					Remove-AppxProvisionedPackage -Online -PackageName $using:ProPackageFullName | Out-null
				}
			} Else {
				DisplayOut "$AppU Isn't Installed" -C 14
			}
		}
	} Else {
		DisplayOut 'No Apps being Uninstalled' -C 14
	}

	BoxItem 'Privacy Settings'
	$TelemetryTask = @(
	'Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser',
	'Microsoft\Windows\Application Experience\ProgramDataUpdater',
	'Microsoft\Windows\Autochk\Proxy',
	'Microsoft\Windows\Customer Experience Improvement Program\Consolidator',
	'Microsoft\Windows\Customer Experience Improvement Program\UsbCeip',
	'Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector',
	'Microsoft\Office\Office ClickToRun Service Monitor',
	'Microsoft\Office\OfficeTelemetryAgentFallBack2016',
	'Microsoft\Office\OfficeTelemetryAgentLogOn2016')

	If($Telemetry -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Telemetry...' -C 15 }
	} ElseIf($Telemetry -eq 1) {
		DisplayOut 'Enabling Telemetry...' -C 11
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection' -Name 'AllowTelemetry' -Type DWord -Value 0
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection' -Name 'AllowTelemetry' -Type DWord -Value 0
		If($OSBit -eq 64){ Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection' -Name 'AllowTelemetry' -Type DWord -Value 0 }
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds' -Name 'AllowBuildPreview'
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform' -Name 'NoGenTicket'
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows' -Name 'CEIPEnable'
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat' -Name 'AITEnable'
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat' -Name 'DisableInventory'
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\AppV\CEIP' -Name 'CEIPEnable'
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\TabletPC' -Name 'PreventHandwritingDataSharing'
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\TextInput' -Name 'AllowLinguisticDataCollection'
		Foreach($task in $TelemetryTask){ Enable-ScheduledTask -TaskName $task | Out-Null }
	} ElseIf($Telemetry -eq 2) {
		DisplayOut 'Disabling Telemetry...' -C 12
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection' -Name 'AllowTelemetry' -Type DWord -Value 0
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection' -Name 'AllowTelemetry' -Type DWord -Value 0
		If($OSBit -eq 64){ Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection' -Name 'AllowTelemetry' -Type DWord -Value 0 }
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds'
		Set-ItemProperty -Path $Path -Name 'AllowBuildPreview' -Type DWord -Value 0
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform'
		Set-ItemProperty -Path $Path -Name 'NoGenTicket' -Type DWord -Value 1
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows'
		Set-ItemProperty -Path $Path -Name 'CEIPEnable' -Type DWord -Value 0
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat'
		Set-ItemProperty -Path $Path -Name 'AITEnable' -Type DWord -Value 0
		Set-ItemProperty -Path $Path -Name 'DisableInventory' -Type DWord -Value 1
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Policies\Microsoft\AppV\CEIP'
		Set-ItemProperty -Path $Path -Name 'CEIPEnable' -Type DWord -Value 0
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\TabletPC'
		Set-ItemProperty -Path $Path -Name 'PreventHandwritingDataSharing' -Type DWord -Value 1
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\TextInput'
		Set-ItemProperty -Path $Path -Name 'AllowLinguisticDataCollection' -Type DWord -Value 0
		Foreach($task in $TelemetryTask){ Disable-ScheduledTask -TaskName $task | Out-Null }
	}

	If($WiFiSense -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Wi-Fi Sense...' -C 15 }
	} ElseIf($WiFiSense -eq 1) {
		DisplayOut 'Enabling Wi-Fi Sense...' -C 11
		$Path1 = 'HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi'
		$Path = CheckSetPath "$Path1\AllowWiFiHotSpotReporting"
		Set-ItemProperty -Path $Path -Name 'Value' -Type DWord -Value 1
		$Path = CheckSetPath "$Path1\AllowAutoConnectToWiFiSenseHotspots"
		Set-ItemProperty -Path $Path -Name 'Value' -Type DWord -Value 1
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config'
		Set-ItemProperty -Path $Path -Name 'AutoConnectAllowedOEM' -Type Dword -Value 0
		Set-ItemProperty -Path $Path -Name 'WiFISenseAllowed' -Type Dword -Value 0
	} ElseIf($WiFiSense -eq 2) {
		DisplayOut 'Disabling Wi-Fi Sense...' -C 12
		$Path1 = 'HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi'
		$Path = CheckSetPath "$Path1\AllowWiFiHotSpotReporting"
		Set-ItemProperty -Path $Path -Name 'Value' -Type DWord -Value 0
		$Path = CheckSetPath "$Path1\AllowAutoConnectToWiFiSenseHotspots"
		Set-ItemProperty -Path $Path -Name 'Value' -Type DWord -Value 0
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config' -Name 'AutoConnectAllowedOEM'
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config' -Name 'WiFISenseAllowed'
	}

	If($SmartScreen -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping SmartScreen Filter...' -C 15 }
	} ElseIf($SmartScreen -eq 1) {
		DisplayOut 'Enabling SmartScreen Filter...' -C 11
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'SmartScreenEnabled' -Type String -Value 'RequireAdmin'
		Remove-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost' -Name 'EnableWebContentEvaluation'
		If($Win10Ver -ge 1703) {
			$AddPath = (Get-AppxPackage -AllUsers 'Microsoft.MicrosoftEdge').PackageFamilyName
			$Path = "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\$AddPath\MicrosoftEdge\PhishingFilter"
			Remove-ItemProperty -Path $Path -Name 'EnabledV9'
			Remove-ItemProperty -Path $Path -Name 'PreventOverride'
		}
	} ElseIf($SmartScreen -eq 2) {
		DisplayOut 'Disabling SmartScreen Filter...' -C 12
		$Path = 'SOFTWARE\Microsoft\Windows\CurrentVersion'
		Set-ItemProperty -Path "HKLM:\$Path\Explorer" -Name 'SmartScreenEnabled' -Type String -Value 'Off'
		Set-ItemProperty -Path "HKCU:\$Path\AppHost" -Name 'EnableWebContentEvaluation' -Type DWord -Value 0
		If($Win10Ver -ge 1703) {
			$AddPath = (Get-AppxPackage -AllUsers 'Microsoft.MicrosoftEdge').PackageFamilyName
			$Path = CheckSetPath "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\$AddPath\MicrosoftEdge\PhishingFilter"
			Set-ItemProperty -Path $Path -Name 'EnabledV9' -Type DWord -Value 0
			Set-ItemProperty -Path $Path -Name 'PreventOverride' -Type DWord -Value 0
		}
	}

	If($LocationTracking -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Location Tracking...' -C 15 }
	} ElseIf($LocationTracking -eq 1) {
		DisplayOut 'Enabling Location Tracking...' -C 11
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}' -Name 'SensorPermissionState' -Type DWord -Value 1
		Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration' -Name 'Status' -Type DWord -Value 1
	} ElseIf($LocationTracking -eq 2) {
		DisplayOut 'Disabling Location Tracking...' -C 12
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}' -Name 'SensorPermissionState' -Type DWord -Value 0
		Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration' -Name 'Status' -Type DWord -Value 0
	}

	If($Feedback -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Feedback...' -C 15 }
	} ElseIf($Feedback -eq 1) {
		DisplayOut 'Enabling Feedback...' -C 11
		Remove-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Siuf\Rules' -Name 'NumberOfSIUFInPeriod'
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection' -Name 'DoNotShowFeedbackNotifications'
		Enable-ScheduledTask -TaskName 'Microsoft\Windows\Feedback\Siuf\DmClient' | Out-Null
		Enable-ScheduledTask -TaskName 'Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload' | Out-Null
	} ElseIf($Feedback -eq 2) {
		DisplayOut 'Disabling Feedback...' -C 12
		$Path = CheckSetPath 'HKCU:\SOFTWARE\Microsoft\Siuf\Rules'
		Set-ItemProperty -Path $Path -Name 'NumberOfSIUFInPeriod' -Type DWord -Value 0
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection' -Name 'DoNotShowFeedbackNotifications' -Type DWord -Value 1
		Disable-ScheduledTask -TaskName 'Microsoft\Windows\Feedback\Siuf\DmClient' | Out-Null 
		Disable-ScheduledTask -TaskName 'Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload' | Out-Null 
	}

	If($AdvertisingID -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Advertising ID...' -C 15 }
	} ElseIf($AdvertisingID -eq 1) {
		DisplayOut 'Enabling Advertising ID...' -C 11
		Remove-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo' -Name 'Enabled'
		$Path = CheckSetPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy'
		Set-ItemProperty -Path $Path -Name 'TailoredExperiencesWithDiagnosticDataEnabled' -Type DWord -Value 2
	} ElseIf($AdvertisingID -eq 2) {
		DisplayOut 'Disabling Advertising ID...' -C 12
		$Path = CheckSetPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo'
		Set-ItemProperty -Path $Path -Name 'Enabled' -Type DWord -Value 0
		$Path = CheckSetPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy'
		Set-ItemProperty -Path $Path -Name 'TailoredExperiencesWithDiagnosticDataEnabled' -Type DWord -Value 0
	}

	If($Cortana -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Cortana...' -C 15 }
	} ElseIf($Cortana -eq 1) {
		DisplayOut 'Enabling Cortana...' -C 11
		$Path = 'HKCU:\SOFTWARE\Microsoft\InputPersonalization'
		Remove-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Personalization\Settings' -Name 'AcceptedPrivacyPolicy'
		Remove-ItemProperty -Path "$Path\TrainedDataStore" -Name 'HarvestContacts'
		Set-ItemProperty -Path $Path -Name 'RestrictImplicitTextCollection' -Type DWord -Value 0
		Set-ItemProperty -Path $Path -Name 'RestrictImplicitInkCollection' -Type DWord -Value 0
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search'
		Remove-ItemProperty -Path $Path -Name 'AllowCortanaAboveLock'
		Remove-ItemProperty -Path $Path -Name 'ConnectedSearchUseWeb'
		Remove-ItemProperty -Path $Path -Name 'ConnectedSearchPrivacy'
		Set-ItemProperty -Path $Path -Name 'DisableWebSearch' -Type DWord -Value 1
		$Path = CheckSetPath 'HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Preferences\'
		Set-ItemProperty -Path $Path -Name 'VoiceActivationEnableAboveLockscreen' -Type DWord -Value 1
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\InputPersonalization' -Name 'AllowInputPersonalization'
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Type DWord -Value 0
	} ElseIf($Cortana -eq 2) {
		DisplayOut 'Disabling Cortana...' -C 12
		$Path = CheckSetPath 'HKCU:\SOFTWARE\Microsoft\Personalization\Settings'
		Set-ItemProperty -Path $Path -Name 'AcceptedPrivacyPolicy' -Type DWord -Value 0
		$Path = CheckSetPath 'HKCU:\SOFTWARE\Microsoft\InputPersonalization'
		Set-ItemProperty -Path $Path -Name 'RestrictImplicitTextCollection' -Type DWord -Value 1
		Set-ItemProperty -Path $Path -Name 'RestrictImplicitInkCollection' -Type DWord -Value 1
		$Path = CheckSetPath "$Path\TrainedDataStore"
		Set-ItemProperty -Path $Path -Name 'HarvestContacts' -Type DWord -Value 0
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search'
		Set-ItemProperty -Path $Path -Name 'AllowCortanaAboveLock' -Type DWord -Value 0
		Set-ItemProperty -Path $Path -Name 'ConnectedSearchUseWeb' -Type DWord -Value 1
		Set-ItemProperty -Path $Path -Name 'ConnectedSearchPrivacy' -Type DWord -Value 3
		Remove-ItemProperty -Path $Path -Name 'DisableWebSearch'
		$Path = CheckSetPath 'HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Preferences\'
		Set-ItemProperty -Path $Path -Name 'VoiceActivationEnableAboveLockscreen' -Type DWord -Value 0
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Policies\Microsoft\InputPersonalization'
		Set-ItemProperty -Path $Path -Name 'AllowInputPersonalization' -Type DWord -Value 0
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Type DWord -Value 1
	}

	If($CortanaSearch -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Cortana Search...' -C 15 }
	} ElseIf($CortanaSearch -eq 1) {
		DisplayOut 'Enabling Cortana Search...' -C 11
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name 'AllowCortana'
	} ElseIf($CortanaSearch -eq 2) {
		DisplayOut 'Disabling Cortana Search...' -C 12
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search'
		Set-ItemProperty -Path $Path -Name 'AllowCortana' -Type DWord -Value 0
	}

	If($ErrorReporting -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Error Reporting...' -C 15 }
	} ElseIf($ErrorReporting -eq 1) {
		DisplayOut 'Enabling Error Reporting...' -C 11
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting' -Name 'Disabled'
	} ElseIf($ErrorReporting -eq 2) {
		DisplayOut 'Disabling Error Reporting...' -C 12
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting' -Name 'Disabled' -Type DWord -Value 1
	}

	If($AutoLoggerFile -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping AutoLogger...' -C 15 }
	} ElseIf($AutoLoggerFile -eq 1) {
		DisplayOut 'Unrestricting AutoLogger Directory...' -C 11
		$autoLoggerDir = "$Env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
		icacls $autoLoggerDir /grant:r SYSTEM:`(OI`)`(CI`)F | Out-Null
		$Path = CheckSetPath 'HKLM:\SYSTEM\ControlSet001\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener'
		Set-ItemProperty -Path $Path -Name 'Start' -Type DWord -Value 1
		$Path += '\{DD17FA14-CDA6-7191-9B61-37A28F7A10DA}'
		Set-ItemProperty -Path $Path -Name 'Start' -Type DWord -Value 1
	} ElseIf($AutoLoggerFile -eq 2) {
		DisplayOut 'Removing AutoLogger File and Restricting Directory...' -C 12
		$autoLoggerDir = "$Env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
		RemoveSetPath "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl"
		icacls $autoLoggerDir /deny SYSTEM:`(OI`)`(CI`)F | Out-Null
		$Path = CheckSetPath 'HKLM:\SYSTEM\ControlSet001\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener'
		Set-ItemProperty -Path $Path -Name 'Start' -Type DWord -Value 0
		$Path = CheckSetPath "$Path\{DD17FA14-CDA6-7191-9B61-37A28F7A10DA}"
		Set-ItemProperty -Path $Path -Name 'Start' -Type DWord -Value 0
	}

	If($DiagTrack -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Diagnostics Tracking...' -C 15 }
	} ElseIf($DiagTrack -eq 1) {
		DisplayOut 'Enabling and Starting Diagnostics Tracking Service...' -C 11
		Set-Service 'DiagTrack' -StartupType Automatic
		Start-Service 'DiagTrack'
	} ElseIf($DiagTrack -eq 2) {
		DisplayOut 'Stopping and Disabling Diagnostics Tracking Service...' -C 12
		Stop-Service 'DiagTrack'
		Set-Service 'DiagTrack' -StartupType Disabled
	}

	If($WAPPush -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping WAP Push...' -C 15 }
	} ElseIf($WAPPush -eq 1) {
		DisplayOut 'Enabling and Starting WAP Push Service...' -C 11
		Set-Service 'dmwappushservice' -StartupType Automatic
		Start-Service 'dmwappushservice'
		Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\dmwappushservice' -Name 'DelayedAutoStart' -Type DWord -Value 1
	} ElseIf($WAPPush -eq 2) {
		DisplayOut 'Disabling WAP Push Service...' -C 12
		Stop-Service 'dmwappushservice'
		Set-Service 'dmwappushservice' -StartupType Disabled
	}

	If($AppAutoDownload -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping App Auto Download...' -C 15 }
	} ElseIf($AppAutoDownload -eq 1) {
		DisplayOut 'Enabling App Auto Download...' -C 11
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate' -Name 'AutoDownload' -Type DWord -Value 0
		Remove-ItemProperty  -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableWindowsConsumerFeatures'
	} ElseIf($AppAutoDownload -eq 2) {
		DisplayOut 'Disabling App Auto Download...' -C 12
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate'
		Set-ItemProperty -Path $Path -Name 'AutoDownload' -Type DWord -Value 2
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent'
		Set-ItemProperty -Path $Path -Name 'DisableWindowsConsumerFeatures' -Type DWord -Value 1
		If($Win10Ver -le 1803) {
			$key = Get-ChildItem -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount" -Recurse | Where-Object { $_ -like "*windows.data.placeholdertilecollection\Current" }
			$data = (Get-ItemProperty -Path $key.PSPath -Name "Data").Data[0..15]
			Set-ItemProperty -Path $key.PSPath -Name "Data" -Type Binary -Value $data
			Stop-Process -Name "ShellExperienceHost" -Force
		}
	}

	BoxItem 'Windows Update Settings'
	If($UpdateMSProducts -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Updates for other Microsoft products...' -C 15 }
	} ElseIf($UpdateMSProducts -eq 1) {
		DisplayOut 'Enabling Updates for other Microsoft products...' -C 11
		(New-Object -ComObject Microsoft.Update.ServiceManager).AddService2("7971f918-a847-4430-9279-4a52d1efe18d", 7, "") | Out-Null
	} ElseIf($UpdateMSProducts -eq 2) {
		DisplayOut 'Disabling Updates for other Microsoft products...' -C 12
		(New-Object -ComObject Microsoft.Update.ServiceManager).RemoveService("7971f918-a847-4430-9279-4a52d1efe18d") | Out-Null
	}

	$Path = CheckSetPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
	If($CheckForWinUpdate -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Check for Windows Update...' -C 15 }
	} ElseIf($CheckForWinUpdate -eq 1) {
		DisplayOut 'Enabling Check for Windows Update...' -C 11
		Remove-ItemProperty -Path $Path -Name 'SetDisableUXWUAccess' -Type DWord -Value 0
	} ElseIf($CheckForWinUpdate -eq 2) {
		DisplayOut 'Disabling Check for Windows Update...' -C 12
		New-ItemProperty -Path $Path -Name 'SetDisableUXWUAccess' -Type DWord -Value 1
	}

	If($WinUpdateType -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Windows Update Check Type...' -C 15 }
	} ElseIf($WinUpdateType -In 1..4) {
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
		If($WinUpdateType -eq 1) {
			DisplayOut 'Notify for windows update download and notify for install...' -C 14
			Set-ItemProperty -Path $Path -Name 'AUOptions' -Type DWord -Value 2
		} ElseIf($WinUpdateType -eq 2) {
			DisplayOut 'Auto Download for windows update download and notify for install...' -C 14
			Set-ItemProperty -Path $Path -Name 'AUOptions' -Type DWord -Value 3
		} ElseIf($WinUpdateType -eq 3) {
			DisplayOut 'Auto Download for windows update download and schedule for install...' -C 14
			Set-ItemProperty -Path $Path -Name 'AUOptions' -Type DWord -Value 4
		} ElseIf($WinUpdateType -eq 4) {
			DisplayOut 'Windows update allow local admin to choose setting...' -C 14
			Set-ItemProperty -Path $Path -Name 'AUOptions' -Type DWord -Value 5
		}
	}

	If($WinUpdateDownload -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Windows Update P2P...' -C 15 }
	} ElseIf($WinUpdateDownload -eq 1) {
		DisplayOut 'Unrestricting Windows Update P2P to Internet...' -C 14
		$Path = 'SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization'
		Remove-ItemProperty -Path "HKLM:\$Path\Config" -Name 'DODownloadMode'
		Remove-ItemProperty -Path "HKCU:\$Path" -Name 'SystemSettingsDownloadMode'
	} ElseIf($WinUpdateDownload -eq 2) {
		DisplayOut 'Restricting Windows Update P2P only to local network...' -C 14
		$Path1 = 'SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization'
		$Path = CheckSetPath "HKCU:\$Path1"
		Set-ItemProperty -Path $Path -Name 'SystemSettingsDownloadMode' -Type DWord -Value 3
		If($Win10Ver -eq 1507) {
			$Path = CheckSetPath "HKLM:\$Path1\Config"
			Set-ItemProperty -Path $Path -Name 'DODownloadMode' -Type DWord -Value 1
		} ElseIf($Win10Ver -le 1607) {
			$Path = CheckSetPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization'
			Set-ItemProperty -Path $Path -Name 'DODownloadMode' -Type DWord -Value 1
		} Else {
			Remove-ItemProperty -Path "HKLM:\$Path1" -Name "DODownloadMode"
		}
	} ElseIf($WinUpdateDownload -eq 3) {
		DisplayOut 'Disabling Windows Update P2P...' -C 12
		$Path1 = 'SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization'
		$Path = CheckSetPath "HKCU:\$Path1"
		Set-ItemProperty -Path $Path -Name 'SystemSettingsDownloadMode' -Type DWord -Value 3
		If($Win10Ver -eq 1507){
			$Path = CheckSetPath "HKLM:\$Path1\Config"
			Set-ItemProperty -Path $Path -Name 'DODownloadMode' -Type DWord -Value 0
		} Else {
			$Path = CheckSetPath "HKLM:\$Path1"
			Set-ItemProperty -Path $Path -Name 'DODownloadMode' -Type DWord -Value 100
		}
	}

	If($RestartOnUpdate -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Windows Update Automatic Restart...' -C 15 }
	} ElseIf($RestartOnUpdate -eq 1) {
		DisplayOut 'Enabling Windows Update Automatic Restart...' -C 11
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'UxOption' -Type DWord -Value 0
		$Path = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
		Remove-ItemProperty -Path $Path -Name 'NoAutoRebootWithLoggedOnUsers'
		Remove-ItemProperty -Path $Path -Name 'AUPowerManagement'
	} ElseIf($RestartOnUpdate -eq 2) {
		DisplayOut 'Disabling Windows Update Automatic Restart...' -C 12
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'UxOption' -Type DWord -Value 1
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
		Set-ItemProperty -Path $Path -Name 'NoAutoRebootWithLoggedOnUsers' -Type DWord -Value 1
		Set-ItemProperty -Path $Path -Name 'AUPowerManagement' -Type DWord -Value 0
	}

	If($UpdateMSRT -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Malicious Software Removal Tool Update...' -C 15 }
	} ElseIf($UpdateMSRT -eq 1) {
		DisplayOut 'Enabling Malicious Software Removal Tool Update...' -C 11
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\MRT' -Name 'DontOfferThroughWUAU'
	} ElseIf($UpdateMSRT -eq 2) {
		DisplayOut 'Disabling Malicious Software Removal Tool Update...' -C 12
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Policies\Microsoft\MRT'
		Set-ItemProperty -Path $Path -Name 'DontOfferThroughWUAU' -Type DWord -Value 1
	}

	If($UpdateDriver -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Driver Update Through Windows Update...' -C 15 }
	} ElseIf($UpdateDriver -eq 1) {
		DisplayOut 'Enabling Driver Update Through Windows Update...' -C 11
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching' -Name 'SearchOrderConfig'
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -Name 'ExcludeWUDriversInQualityUpdate'
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata' -Name 'PreventDeviceMetadataFromNetwork'
	} ElseIf($UpdateDriver -eq 2) {
		DisplayOut 'Disabling Driver Update Through Windows Update...' -C 12
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching' -Name 'SearchOrderConfig' -Type DWord -Value 0
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
		Set-ItemProperty -Path $Path -Name 'ExcludeWUDriversInQualityUpdate' -Type DWord -Value 1
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata'
		Set-ItemProperty -Path $Path -Name 'PreventDeviceMetadataFromNetwork' -Type DWord -Value 1
	}

	If($UpdateAvailablePopup -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Update Available Popup...' -C 15 }
	} ElseIf($UpdateAvailablePopup -eq 1) {
		DisplayOut 'Enabling Update Available Popup...' -C 11
		ForEach($File In $musnotification_files){
			ICACLS $File /remove:d '"Everyone"' | out-null
			ICACLS $File /grant ('Everyone' + ':(OI)(CI)F') | out-null
			ICACLS $File /setowner 'NT SERVICE\TrustedInstaller'
			ICACLS $File /remove:g '"Everyone"' | out-null
		}
	} ElseIf($UpdateAvailablePopup -eq 2) {
		DisplayOut 'Disabling Update Available Popup...' -C 12
		ForEach($File In $musnotification_files){
			Takeown /f $File | out-null
			ICACLS $File /deny '"Everyone":(F)' | out-null
		}
	}

	BoxItem 'Service Tweaks'
	If($UAC -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping UAC Level...' -C 15 }
	} ElseIf($UAC -eq 1) {
		DisplayOut 'Lowering UAC level...' -C 14
		$Path = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
		Set-ItemProperty -Path $Path -Name 'ConsentPromptBehaviorAdmin' -Type DWord -Value 0
		Set-ItemProperty -Path $Path -Name 'PromptOnSecureDesktop' -Type DWord -Value 0
	} ElseIf($UAC -eq 2) {
		DisplayOut 'Default UAC level...' -C 14
		$Path = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
		Set-ItemProperty -Path $Path -Name 'ConsentPromptBehaviorAdmin' -Type DWord -Value 5
		Set-ItemProperty -Path $Path -Name 'PromptOnSecureDesktop' -Type DWord -Value 1
	} ElseIf($UAC -eq 3) {
		DisplayOut 'Raising UAC level...' -C 14
		$Path = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
		Set-ItemProperty -Path $Path -Name 'ConsentPromptBehaviorAdmin' -Type DWord -Value 2
		Set-ItemProperty -Path $Path -Name 'PromptOnSecureDesktop' -Type DWord -Value 1
	}

	If($SharingMappedDrives -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Sharing Mapped Drives between Users...' -C 15 }
	} ElseIf($SharingMappedDrives -eq 1) {
		DisplayOut 'Enabling Sharing Mapped Drives between Users...' -C 11
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'EnableLinkedConnections' -Type DWord -Value 1
	} ElseIf($SharingMappedDrives -eq 2) {
		DisplayOut 'Disabling Sharing Mapped Drives between Users...' -C 12
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'EnableLinkedConnections'
	}

	If($AdminShares -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Hidden Administrative Shares...' -C 15 }
	} ElseIf($AdminShares -eq 1) {
		DisplayOut 'Enabling Hidden Administrative Shares...' -C 11
		Remove-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters' -Name 'AutoShareWks'
	} ElseIf($AdminShares -eq 2) {
		DisplayOut 'Disabling Hidden Administrative Shares...' -C 12
		Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters' -Name 'AutoShareWks' -Type DWord -Value 0
	}

	If($Firewall -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Firewall...' -C 15 }
	} ElseIf($Firewall -eq 1) {
		DisplayOut 'Enabling Firewall...' -C 11
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\StandardProfile' -Name 'EnableFirewall'
	} ElseIf($Firewall -eq 2) {
		DisplayOut 'Disabling Firewall...' -C 12
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\StandardProfile'
		Set-ItemProperty -Path $Path -Name 'EnableFirewall' -Type DWord -Value 0
	}

	If($WinDefender -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Windows Defender...' -C 15 }
	} ElseIf($WinDefender -eq 1) {
		DisplayOut 'Enabling Windows Defender...' -C 11
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender' -Name 'DisableAntiSpyware'
		$Path = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
		If($Win10Ver -lt 1703){ $RegName = 'WindowsDefender' } Else{ $RegName = 'SecurityHealth' }
		Set-ItemProperty -Path $Path -Name $RegName -Type ExpandString -Value "`"%ProgramFiles%\Windows Defender\MSASCuiL.exe`""
		RemoveSetPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet'
	} ElseIf($WinDefender -eq 2) {
		DisplayOut 'Disabling Windows Defender...' -C 12
		$Path = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
		If($Win10Ver -lt 1703){ $RegName = 'WindowsDefender' } Else{ $RegName = 'SecurityHealth' }
		Remove-ItemProperty -Path $Path -Name $RegName
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\'
		Set-ItemProperty -Path $Path -Name 'DisableAntiSpyware' -Type DWord -Value 1
		$Path = CheckSetPath "$Path\Spynet"
		Set-ItemProperty -Path $Path -Name 'SpynetReporting' -Type DWord -Value 0
		Set-ItemProperty -Path $Path -Name 'SubmitSamplesConsent' -Type DWord -Value 2
	}

	If($HomeGroups -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Home Groups Services...' -C 15 }
	} ElseIf($HomeGroups -eq 1) {
		DisplayOut 'Enabling Home Groups Services...' -C 11
		Set-Service 'HomeGroupListener' -StartupType Manual
		Set-Service 'HomeGroupProvider' -StartupType Manual
		Start-Service 'HomeGroupProvider'
	} ElseIf($HomeGroups -eq 2) {
		DisplayOut 'Disabling Home Groups Services...' -C 12
		Stop-Service 'HomeGroupListener'
		Set-Service 'HomeGroupListener' -StartupType Disabled
		Stop-Service 'HomeGroupProvider'
		Set-Service 'HomeGroupProvider' -StartupType Disabled
	}

	If($RemoteAssistance -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Remote Assistance...' -C 15 }
	} ElseIf($RemoteAssistance -eq 1) {
		DisplayOut 'Enabling Remote Assistance...' -C 11
		Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance' -Name 'fAllowToGetHelp' -Type DWord -Value 1
	} ElseIf($RemoteAssistance -eq 2) {
		DisplayOut 'Disabling Remote Assistance...' -C 12
		Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance' -Name 'fAllowToGetHelp' -Type DWord -Value 0
	}

	If($RemoteDesktop -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Remote Desktop...' -C 15 }
	} ElseIf($RemoteDesktop -eq 1) {
		DisplayOut 'Enabling Remote Desktop w/o Network Level Authentication...' -C 11
		$Path = 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server'
		Set-ItemProperty -Path $Path -Name 'fDenyTSConnections' -Type DWord -Value 0
		Set-ItemProperty -Path "$Path\WinStations\RDP-Tcp" -Name 'UserAuthentication' -Type DWord -Value 0
	} ElseIf($RemoteDesktop -eq 2) {
		DisplayOut 'Disabling Remote Desktop...' -C 12
		$Path = 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server'
		Set-ItemProperty -Path $Path -Name 'fDenyTSConnections' -Type DWord -Value 1
		Set-ItemProperty -Path "$Path\WinStations\RDP-Tcp" -Name 'UserAuthentication' -Type DWord -Value 1
	}

	BoxItem 'Context Menu Items'
	If($CastToDevice -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Cast to Device Context item...' -C 15 }
	} ElseIf($CastToDevice -eq 1) {
		DisplayOut 'Enabling Cast to Device Context item...' -C 11
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked' -Name '{7AD84985-87B4-4a16-BE58-8B72A5B390F7}'
	} ElseIf($CastToDevice -eq 2) {
		DisplayOut 'Disabling Cast to Device Context item...' -C 12
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked'
		Set-ItemProperty -Path $Path -Name '{7AD84985-87B4-4a16-BE58-8B72A5B390F7}' -Type String -Value 'Play to Menu'
	}

	If($PreviousVersions -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Previous Versions Context item...' -C 15 }
	} ElseIf($PreviousVersions -eq 1) {
		DisplayOut 'Enabling Previous Versions Context item...' -C 11
		New-Item -Path 'HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}' | Out-Null
		New-Item -Path 'HKCR:\CLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}' | Out-Null
		New-Item -Path 'HKCR:\Directory\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}' | Out-Null
		New-Item -Path 'HKCR:\Drive\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}' | Out-Null
	} ElseIf($PreviousVersions -eq 2) {
		DisplayOut 'Disabling Previous Versions Context item...' -C 12
		RemoveSetPath 'HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}'
		RemoveSetPath 'HKCR:\CLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}'
		RemoveSetPath 'HKCR:\Directory\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}'
		RemoveSetPath 'HKCR:\Drive\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}'
	}

	If($IncludeinLibrary -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Include in Library Context item...' -C 15 }
	} ElseIf($IncludeinLibrary -eq 1) {
		DisplayOut 'Enabling Include in Library Context item...' -C 11
		Set-ItemProperty -Path 'HKCR:\Folder\ShellEx\ContextMenuHandlers\Library Location' -Name '(Default)' -Type String -Value '{3dad6c5d-2167-4cae-9914-f99e41c12cfa}'
	} ElseIf($IncludeinLibrary -eq 2) {
		DisplayOut 'Disabling Include in Library...' -C 12
		Set-ItemProperty -Path 'HKCR:\Folder\ShellEx\ContextMenuHandlers\Library Location' -Name '(Default)' -Type String -Value ''
	}

	If($PinToStart -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Pin To Start Context item...' -C 15 }
	} ElseIf($PinToStart -eq 1) {
		DisplayOut 'Enabling Pin To Start Context item...' -C 11
		New-Item -Path 'HKCR:\*\shellex\ContextMenuHandlers\{90AA3A4E-1CBA-4233-B8BB-535773D48449}' -Force | Out-Null
		New-Item -Path 'HKCR:\*\shellex\ContextMenuHandlers\{a2a9545d-a0c2-42b4-9708-a0b2badd77c8}' -Force | Out-Null
		Set-ItemProperty -LiteralPath 'HKCR:\*\shellex\ContextMenuHandlers\{90AA3A4E-1CBA-4233-B8BB-535773D48449}' -Name '(Default)' -Type String -Value 'Taskband Pin'
		Set-ItemProperty -LiteralPath 'HKCR:\*\shellex\ContextMenuHandlers\{a2a9545d-a0c2-42b4-9708-a0b2badd77c8}' -Name '(Default)' -Type String -Value 'Start Menu Pin'
		Set-ItemProperty -Path 'HKCR:\Folder\shellex\ContextMenuHandlers\PintoStartScreen' -Name '(Default)' -Type String -Value '{470C0EBD-5D73-4d58-9CED-E91E22E23282}'
		Set-ItemProperty -Path 'HKCR:\exefile\shellex\ContextMenuHandlers\PintoStartScreen' -Name '(Default)' -Type String -Value '{470C0EBD-5D73-4d58-9CED-E91E22E23282}'
		Set-ItemProperty -Path 'HKCR:\Microsoft.Website\shellex\ContextMenuHandlers\PintoStartScreen' -Name '(Default)' -Type String -Value '{470C0EBD-5D73-4d58-9CED-E91E22E23282}'
		Set-ItemProperty -Path 'HKCR:\mscfile\shellex\ContextMenuHandlers\PintoStartScreen' -Name '(Default)' -Type String -Value '{470C0EBD-5D73-4d58-9CED-E91E22E23282}'
	} ElseIf($PinToStart -eq 2) {
		DisplayOut 'Disabling Pin To Start Context item...' -C 12
		Remove-Item -LiteralPath 'HKCR:\*\shellex\ContextMenuHandlers\{90AA3A4E-1CBA-4233-B8BB-535773D48449}' -Force
		Remove-Item -LiteralPath 'HKCR:\*\shellex\ContextMenuHandlers\{a2a9545d-a0c2-42b4-9708-a0b2badd77c8}' -Force
		Set-ItemProperty -Path 'HKCR:\Folder\shellex\ContextMenuHandlers\PintoStartScreen' -Name '(Default)' -Type String -Value ''
		Set-ItemProperty -Path 'HKCR:\exefile\shellex\ContextMenuHandlers\PintoStartScreen' -Name '(Default)' -Type String -Value ''
		Set-ItemProperty -Path 'HKCR:\Microsoft.Website\shellex\ContextMenuHandlers\PintoStartScreen' -Name '(Default)' -Type String -Value ''
		Set-ItemProperty -Path 'HKCR:\mscfile\shellex\ContextMenuHandlers\PintoStartScreen' -Name '(Default)' -Type String -Value ''
	}

	If($PinToQuickAccess -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Pin To Quick Access Context item...' -C 15 }
	} ElseIf($PinToQuickAccess -eq 1) {
		DisplayOut 'Enabling Pin To Quick Access Context item...' -C 11
		$Path = CheckSetPath 'HKCR:\Folder\shell\pintohome'
		New-ItemProperty -Path $Path -Name 'MUIVerb' -Type String -Value '@shell32.dll,-51377'
		New-ItemProperty -Path $Path -Name 'AppliesTo' -Type String -Value 'System.ParsingName:<>"::{679f85cb-0220-4080-b29b-5540cc05aab6}" AND System.ParsingName:<>"::{645FF040-5081-101B-9F08-00AA002F954E}" AND System.IsFolder:=System.StructuredQueryType.Boolean#True'
		$Path = CheckSetPath  "$Path\command"
		New-ItemProperty -Path "$Path" -Name 'DelegateExecute' -Type String -Value '{b455f46e-e4af-4035-b0a4-cf18d2f6f28e}'
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Classes\Folder\shell\pintohome'
		New-ItemProperty -Path $Path -Name 'MUIVerb' -Type String -Value '@shell32.dll,-51377'
		New-ItemProperty -Path $Path -Name 'AppliesTo' -Type String -Value 'System.ParsingName:<>"::{679f85cb-0220-4080-b29b-5540cc05aab6}" AND System.ParsingName:<>"::{645FF040-5081-101B-9F08-00AA002F954E}" AND System.IsFolder:=System.StructuredQueryType.Boolean#True'
		$Path = CheckSetPath  "$Path\command"
		New-ItemProperty -Path "$Path" -Name 'DelegateExecute' -Type String -Value '{b455f46e-e4af-4035-b0a4-cf18d2f6f28e}'
	} ElseIf($PinToQuickAccess -eq 2) {
		DisplayOut 'Disabling Pin To Quick Access Context item...' -C 12
		RemoveSetPath 'HKCR:\Folder\shell\pintohome'
		RemoveSetPath 'HKLM:\SOFTWARE\Classes\Folder\shell\pintohome'
	}

	If($ShareWith -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Share With/Share Context item...' -C 15 }
	} ElseIf($ShareWith -eq 1) {
		DisplayOut 'Enabling Share With/Share Context item...' -C 11
		Set-ItemProperty -LiteralPath 'HKCR:\*\shellex\ContextMenuHandlers\Sharing' -Name '(Default)' -Type String -Value '{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}'
		Set-ItemProperty -Path 'HKCR:\Directory\shellex\ContextMenuHandlers\Sharing' -Name '(Default)' -Type String -Value '{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}'
		Set-ItemProperty -Path 'HKCR:\Directory\shellex\CopyHookHandlers\Sharing' -Name '(Default)' -Type String -Value '{40dd6e20-7c17-11ce-a804-00aa003ca9f6}'
		Set-ItemProperty -Path 'HKCR:\Drive\shellex\ContextMenuHandlers\Sharing' -Name '(Default)' -Type String -Value '{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}'
		Set-ItemProperty -Path 'HKCR:\Directory\shellex\PropertySheetHandlers\Sharing' -Name '(Default)' -Type String -Value '{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}'
		Set-ItemProperty -Path 'HKCR:\Directory\Background\shellex\ContextMenuHandlers\Sharing' -Name '(Default)' -Type String -Value '{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}'
		Set-ItemProperty -Path 'HKCR:\LibraryFolder\background\shellex\ContextMenuHandlers\Sharing' -Name '(Default)' -Type String -Value '{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}'
		Set-ItemProperty -LiteralPath 'HKCR:\*\shellex\ContextMenuHandlers\ModernSharing' -Name '(Default)' -Type String -Value '{e2bf9676-5f8f-435c-97eb-11607a5bedf7}'
	}  ElseIf($ShareWith -eq 2) {
		DisplayOut 'Disabling Share/Share With...' -C 12
		Set-ItemProperty -LiteralPath 'HKCR:\*\shellex\ContextMenuHandlers\Sharing' -Name '(Default)' -Type String -Value ''
		Set-ItemProperty -Path 'HKCR:\Directory\shellex\ContextMenuHandlers\Sharing' -Name '(Default)' -Type String -Value ''
		Set-ItemProperty -Path 'HKCR:\Directory\shellex\CopyHookHandlers\Sharing' -Name '(Default)' -Type String -Value ''
		Set-ItemProperty -Path 'HKCR:\Directory\shellex\PropertySheetHandlers\Sharing' -Name '(Default)' -Type String -Value ''
		Set-ItemProperty -Path 'HKCR:\Directory\Background\shellex\ContextMenuHandlers\Sharing' -Name '(Default)' -Type String -Value ''
		Set-ItemProperty -Path 'HKCR:\Drive\shellex\ContextMenuHandlers\Sharing' -Name '(Default)' -Type String -Value ''
		Set-ItemProperty -Path 'HKCR:\LibraryFolder\background\shellex\ContextMenuHandlers\Sharing' -Name '(Default)' -Type String -Value ''
		Set-ItemProperty -LiteralPath 'HKCR:\*\shellex\ContextMenuHandlers\ModernSharing' -Name '(Default)' -Type String -Value ''
	}

	If($SendTo -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Send To Context item...' -C 15 }
	} ElseIf($SendTo -eq 1) {
		DisplayOut 'Enabling Send To Context item...' -C 11
		$Path = CheckSetPath 'HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo'
		Set-ItemProperty -Path $Path -Name '(Default)' -Type String -Value '{7BA4C740-9E81-11CF-99D3-00AA004AE837}' | Out-Null
	} ElseIf($SendTo -eq 2) {
		DisplayOut 'Disabling Send To Context item...' -C 12
		RemoveSetPath 'HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo'
	}

	BoxItem 'Task Bar Items'
	If($BatteryUIBar -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Battery UI Bar...' -C 15 }
	} ElseIf($BatteryUIBar -eq 1) {
		DisplayOut 'Enabling New Battery UI Bar...' -C 11
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell' -Name 'UseWin32BatteryFlyout'
	} ElseIf($BatteryUIBar -eq 2) {
		DisplayOut 'Enabling Old Battery UI Bar...' -C 12
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell'
		Set-ItemProperty -Path $Path -Name 'UseWin32BatteryFlyout' -Type DWord -Value 1
	}

	If($ClockUIBar -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Clock UI Bar...' -C 15 }
	} ElseIf($ClockUIBar -eq 1) {
		DisplayOut 'Enabling New Clock UI Bar...' -C 11
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell' -Name 'UseWin32TrayClockExperience'
	} ElseIf($ClockUIBar -eq 2) {
		DisplayOut 'Enabling Old Clock UI Bar...' -C 12
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell'
		Set-ItemProperty -Path $Path -Name 'UseWin32TrayClockExperience' -Type DWord -Value 1
	}

	If($VolumeControlBar -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Volume Control Bar...' -C 15 }
	} ElseIf($VolumeControlBar -eq 1) {
		DisplayOut 'Enabling New Volume Control Bar (Horizontal)...' -C 11
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC' -Name 'EnableMtcUvc'
	} ElseIf($VolumeControlBar -eq 2) {
		DisplayOut 'Enabling Classic Volume Control Bar (Vertical)...' -C 12
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC'
		Set-ItemProperty -Path $Path -Name 'EnableMtcUvc' -Type DWord -Value 0
	}

	If($TaskbarSearchBox -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Taskbar Search box / button...' -C 15 }
	} ElseIf($TaskbarSearchBox -eq 1) {
		DisplayOut 'Showing Taskbar Search box / button...' -C 11
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search' -Name 'SearchboxTaskbarMode' -Type DWord -Value 1
	} ElseIf($TaskbarSearchBox -eq 2) {
		DisplayOut 'Hiding Taskbar Search box / button...' -C 12
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search' -Name 'SearchboxTaskbarMode' -Type DWord -Value 0
	}

	If($TaskViewButton -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Task View button...' -C 15 }
	} ElseIf($TaskViewButton -eq 1) {
		DisplayOut 'Showing Task View button...' -C 11
		Remove-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowTaskViewButton'
	} ElseIf($TaskViewButton -eq 2) {
		DisplayOut 'Hiding Task View button...' -C 12
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowTaskViewButton' -Type DWord -Value 0
	}

	If($TaskbarIconSize -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Icon Size in Taskbar...' -C 15 }
	} ElseIf($TaskbarIconSize -eq 1) {
		DisplayOut 'Showing Normal Icon Size in Taskbar...' -C 11
		Remove-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarSmallIcons'
	} ElseIf($TaskbarIconSize -eq 2) {
		DisplayOut 'Showing Smaller Icons in Taskbar...' -C 12
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarSmallIcons' -Type DWord -Value 1
	}

	If($TaskbarGrouping -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Taskbar Item Grouping...' -C 15 }
	} ElseIf($TaskbarGrouping -eq 1) {
		DisplayOut 'Never Group Taskbar Items...' -C 14
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarGlomLevel' -Type DWord -Value 2
	} ElseIf($TaskbarGrouping -eq 2) {
		DisplayOut 'Always Group Taskbar Items...' -C 14
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarGlomLevel' -Type DWord -Value 0
	} ElseIf($TaskbarGrouping -eq 3) {
		DisplayOut 'When Needed Group Taskbar Items...' -C 14
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarGlomLevel' -Type DWord -Value 1
	}

	If($TrayIcons -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Tray icons...' -C 15 }
	} ElseIf($TrayIcons -eq 1) {
		DisplayOut 'Hiding Tray Icons...' -C 12
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'EnableAutoTray' -Type DWord -Value 1
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'EnableAutoTray' -Type DWord -Value 1
	} ElseIf($TrayIcons -eq 2) {
		DisplayOut 'Showing All Tray Icons...' -C 11
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'EnableAutoTray' -Type DWord -Value 0
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'EnableAutoTray' -Type DWord -Value 0
	}

	If($SecondsInClock -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Seconds in Taskbar Clock...' -C 15 }
	} ElseIf($SecondsInClock -eq 1) {
		DisplayOut 'Showing Seconds in Taskbar Clock...' -C 11
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowSecondsInSystemClock' -Type DWord -Value 1
	} ElseIf($SecondsInClock -eq 2) {
		DisplayOut 'Hiding Seconds in Taskbar Clock...' -C 12
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowSecondsInSystemClock' -Type DWord -Value 0
	}

	If($LastActiveClick -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Last Active Click...' -C 15 }
	} ElseIf($LastActiveClick -eq 1) {
		DisplayOut 'Enabling Last Active Click...' -C 11
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'LastActiveClick' -Type DWord -Value 1
	} ElseIf($LastActiveClick -eq 2) {
		DisplayOut 'Disabling Last Active Click...' -C 12
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'LastActiveClick' -Type DWord -Value 0
	}

	If($TaskBarOnMultiDisplay -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Taskbar on Multiple Displays...' -C 15 }
	} ElseIf($TaskBarOnMultiDisplay -eq 1) {
		DisplayOut 'Showing Taskbar on Multiple Displays...' -C 11
		Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'MMTaskbarEnabled' -Type DWord -Value 1
	} ElseIf($TaskBarOnMultiDisplay -eq 2) {
		DisplayOut 'Hiding Taskbar on Multiple Displays...' -C 12
		Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'MMTaskbarEnabled' -Type DWord -Value 0
	}

	If($TaskbarButtOnDisplay -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Taskbar Buttons on Multiple Displays...' -C 15 }
	} ElseIf($TaskbarButtOnDisplay -eq 1) {
		DisplayOut 'Showing Taskbar Buttons on All Taskbars...' -C 14
		Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'MMTaskbarMode' -Type DWord -Value 0
	} ElseIf($TaskbarButtOnDisplay -eq 2) {
		DisplayOut 'Showing Taskbar Buttons on Taskbar where Window is open...' -C 14
		Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'MMTaskbarMode' -Type DWord -Value 2
	} ElseIf($TaskbarButtOnDisplay -eq 3) {
		DisplayOut 'Showing Taskbar Buttons on Main Taskbar and where Window is open...' -C 14
		Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'MMTaskbarMode' -Type DWord -Value 1
	}

	BoxItem 'Star Menu Items'
	If($StartMenuWebSearch -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Bing Search in Start Menu...' -C 15 }
	} ElseIf($StartMenuWebSearch -eq 1) {
		DisplayOut 'Enabling Bing Search in Start Menu...' -C 11
		Remove-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search' -Name 'BingSearchEnabled'
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name 'DisableWebSearch'
	} ElseIf($StartMenuWebSearch -eq 2) {
		DisplayOut 'Disabling Bing Search in Start Menu...' -C 12
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search' -Name 'BingSearchEnabled' -Type DWord -Value 0
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search'
		Set-ItemProperty -Path $Path -Name 'DisableWebSearch' -Type DWord -Value 1
	}

	If($StartSuggestions -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Start Menu Suggestions...' -C 15 }
	} ElseIf($StartSuggestions -eq 1) {
		DisplayOut 'Enabling Start Menu Suggestions...' -C 11
		$Path = CheckSetPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'
		Set-ItemProperty -Path $Path -Name 'ContentDeliveryAllowed' -Type DWord -Value 1
		Set-ItemProperty -Path $Path -Name 'OemPreInstalledAppsEnabled' -Type DWord -Value 1
		Set-ItemProperty -Path $Path -Name 'PreInstalledAppsEnabled' -Type DWord -Value 1
		Set-ItemProperty -Path $Path -Name 'PreInstalledAppsEverEnabled' -Type DWord -Value 1
	 	Set-ItemProperty -Path $Path -Name 'SilentInstalledAppsEnabled' -Type DWord -Value 1
		Set-ItemProperty -Path $Path -Name 'SystemPaneSuggestionsEnabled' -Type DWord -Value 1
		Set-ItemProperty -Path $Path -Name 'Start_TrackProgs' -Type DWord -Value 1
		Set-ItemProperty -Path $Path -Name 'SubscribedContent-314559Enabled' -Type DWord -Value 1
		Set-ItemProperty -Path $Path -Name 'SubscribedContent-310093Enabled' -Type DWord -Value 1
		Set-ItemProperty -Path $Path -Name 'SubscribedContent-338387Enabled' -Type DWord -Value 1
		Set-ItemProperty -Path $Path -Name 'SubscribedContent-338388Enabled' -Type DWord -Value 1
		Set-ItemProperty -Path $Path -Name 'SubscribedContent-338389Enabled' -Type DWord -Value 1
		Set-ItemProperty -Path $Path -Name 'SubscribedContent-338393Enabled' -Type DWord -Value 1
		Set-ItemProperty -Path $Path -Name 'SubscribedContent-353694Enabled' -Type DWord -Value 1
		Set-ItemProperty -Path $Path -Name 'SubscribedContent-353696Enabled' -Type DWord -Value 1
		Set-ItemProperty -Path $Path -Name 'SubscribedContent-358398Enabled' -Type DWord -Value 1
	} ElseIf($StartSuggestions -eq 2) {
		DisplayOut 'Disabling Start Menu Suggestions...' -C 12
		$Path = CheckSetPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'
		Set-ItemProperty -Path $Path -Name 'ContentDeliveryAllowed' -Type DWord -Value 0
		Set-ItemProperty -Path $Path -Name 'OemPreInstalledAppsEnabled' -Type DWord -Value 0
		Set-ItemProperty -Path $Path -Name 'PreInstalledAppsEnabled' -Type DWord -Value 0
		Set-ItemProperty -Path $Path -Name 'PreInstalledAppsEverEnabled' -Type DWord -Value 0
	 	Set-ItemProperty -Path $Path -Name 'SilentInstalledAppsEnabled' -Type DWord -Value 0
		Set-ItemProperty -Path $Path -Name 'SystemPaneSuggestionsEnabled' -Type DWord -Value 0
		Set-ItemProperty -Path $Path -Name 'Start_TrackProgs' -Type DWord -Value 0
		Set-ItemProperty -Path $Path -Name 'SubscribedContent-314559Enabled' -Type DWord -Value 0
		Set-ItemProperty -Path $Path -Name 'SubscribedContent-310093Enabled' -Type DWord -Value 0
		Set-ItemProperty -Path $Path -Name 'SubscribedContent-338387Enabled' -Type DWord -Value 0
		Set-ItemProperty -Path $Path -Name 'SubscribedContent-338388Enabled' -Type DWord -Value 0
		Set-ItemProperty -Path $Path -Name 'SubscribedContent-338389Enabled' -Type DWord -Value 0
		Set-ItemProperty -Path $Path -Name 'SubscribedContent-338393Enabled' -Type DWord -Value 0
		Set-ItemProperty -Path $Path -Name 'SubscribedContent-353694Enabled' -Type DWord -Value 0
		Set-ItemProperty -Path $Path -Name 'SubscribedContent-353696Enabled' -Type DWord -Value 0
		Set-ItemProperty -Path $Path -Name 'SubscribedContent-358398Enabled' -Type DWord -Value 0
		If($Win10Ver -ge 1803) {
			$key = Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\*windows.data.placeholdertilecollection\Current"
			Set-ItemProperty -Path $key.PSPath -Name "Data" -Type Binary -Value $key.Data[0..15]
			Stop-Process -Name "ShellExperienceHost" -Force
		}
	}

	If($MostUsedAppStartMenu -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Most used Apps in Start Menu...' -C 15 }
	} ElseIf($MostUsedAppStartMenu -eq 1) {
		DisplayOut 'Showing Most used Apps in Start Menu...' -C 11
		Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_TrackProgs' -Type DWord -Value 1
	} ElseIf($MostUsedAppStartMenu -eq 2) {
		DisplayOut 'Hiding Most used Apps in Start Menu...' -C 12
		Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_TrackProgs' -Type DWord -Value 0
	}

	If($RecentItemsFrequent -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Recent Items and Frequent Places...' -C 15 }
	} ElseIf($RecentItemsFrequent -eq 1) {
		DisplayOut 'Enabling Recent Items and Frequent Places...' -C 11
		$Path = CheckSetPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu'
		Set-ItemProperty -Path $Path -Name 'Start_TrackDocs' -Type DWord -Value 1
	} ElseIf($RecentItemsFrequent -eq 2) {
		DisplayOut 'Disabling Recent Items and Frequent Places...' -C 12
		$Path = CheckSetPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu'
		Set-ItemProperty -Path $Path -Name 'Start_TrackDocs' -Type DWord -Value 0
	}

	BoxItem 'Explorer Items'
	If($AccessKeyPrmpt -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Accessibility Keys Prompts...' -C 15 }
	} ElseIf($AccessKeyPrmpt -eq 1) {
		DisplayOut 'Enabling Accessibility Keys Prompts...' -C 11
		$Path = 'HKCU:\Control Panel\Accessibility\'
		Set-ItemProperty -Path "$Path\StickyKeys" -Name 'Flags' -Type String -Value '510'
		Set-ItemProperty -Path "$Path\ToggleKeys" -Name 'Flags' -Type String -Value '62'
		Set-ItemProperty -Path "$Path\Keyboard Response" -Name 'Flags' -Type String -Value '126'
	} ElseIf($AccessKeyPrmpt -eq 2) {
		DisplayOut 'Disabling Accessibility Keys Prompts...' -C 12
		$Path = 'HKCU:\Control Panel\Accessibility\'
		Set-ItemProperty -Path "$Path\StickyKeys" -Name 'Flags' -Type String -Value '506'
		Set-ItemProperty -Path "$Path\ToggleKeys" -Name 'Flags' -Type String -Value '58'
		Set-ItemProperty -Path "$Path\Keyboard Response" -Name 'Flags' -Type String -Value '122'
	}

	If($F1HelpKey -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping F1 Help key...' -C 15 }
	} ElseIf($F1HelpKey -eq 1) {
		DisplayOut 'Enabling F1 Help key...' -C 11
		RemoveSetPath 'HKCU:\Software\Classes\TypeLib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0'
	} ElseIf($F1HelpKey -eq 2) {
		DisplayOut 'Disabling F1 Help key...' -C 12
		$Path = CheckSetPath 'HKCU:\Software\Classes\TypeLib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win32'
		Set-ItemProperty -Path $Path -Name '(Default)' -Type 'String' -Value ''
		If($OSBit -eq 64) {
			$Path = CheckSetPath 'HKCU:\Software\Classes\TypeLib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64'
			Set-ItemProperty -Path $Path -Name '(Default)' -Type 'String' -Value ''
		}
	}

	If($PidInTitleBar -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Process ID on Title Bar...' -C 15 }
	} ElseIf($PidInTitleBar -eq 1) {
		DisplayOut 'Showing Process ID on Title Bar...' -C 11
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShowPidInTitle' -Type DWord -Value 1
	} ElseIf($PidInTitleBar -eq 2) {
		DisplayOut 'Hiding Process ID on Title Bar...' -C 12
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShowPidInTitle'
	}

	If($AeroSnap -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Aero Snap...' -C 15 }
	} ElseIf($AeroSnap -eq 1) {
		DisplayOut 'Enabling Aero Snap...' -C 11
		Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'WindowArrangementActive' -Type String -Value 1
	} ElseIf($AeroSnap -eq 2) {
		DisplayOut 'Disabling Aero Snap...' -C 12
		Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'WindowArrangementActive' -Type String -Value 0
	}

	If($AeroShake -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Aero Shake...' -C 15 }
	} ElseIf($AeroShake -eq 1) {
		DisplayOut 'Enabling Aero Shake...' -C 11
		Remove-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Windows\Explorer' -Name 'NoWindowMinimizingShortcuts'
	} ElseIf($AeroShake -eq 2) {
		DisplayOut 'Disabling Aero Shake...' -C 12
		$Path = CheckSetPath 'HKCU:\Software\Policies\Microsoft\Windows\Explorer'
		Set-ItemProperty -Path $Path -Name 'NoWindowMinimizingShortcuts' -Type DWord -Value 1
	}

	If($KnownExtensions -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Known File Extensions...' -C 15 }
	} ElseIf($KnownExtensions -eq 1) {
		DisplayOut 'Showing Known File Extensions...' -C 11
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'HideFileExt' -Type DWord -Value 0
	} ElseIf($KnownExtensions -eq 2) {
		DisplayOut 'Hiding Known File Extensions...' -C 12
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'HideFileExt' -Type DWord -Value 1
	}

	If($HiddenFiles -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Hidden Files...' -C 15 }
	} ElseIf($HiddenFiles -eq 1) {
		DisplayOut 'Showing Hidden Files...' -C 11
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Hidden' -Type DWord -Value 1
	} ElseIf($HiddenFiles -eq 2) {
		DisplayOut 'Hiding Hidden Files...' -C 12
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Hidden' -Type DWord -Value 2
	}

	If($SystemFiles -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping System Files...' -C 15 }
	} ElseIf($SystemFiles -eq 1) {
		DisplayOut 'Showing System Files...' -C 11
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowSuperHidden' -Type DWord -Value 1
	} ElseIf($SystemFiles -eq 2) {
		DisplayOut 'Hiding System fFiles...' -C 12
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowSuperHidden' -Type DWord -Value 0
	}

	If($ExplorerOpenLoc -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Default Explorer view to Quick Access...' -C 15 }
	} ElseIf($ExplorerOpenLoc -eq 1) {
		DisplayOut 'Changing Default Explorer view to Quick Access...' -C 14
		Remove-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'LaunchTo'
	} ElseIf($ExplorerOpenLoc -eq 2) {
		DisplayOut 'Changing Default Explorer view to This PC...' -C 14
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'LaunchTo' -Type DWord -Value 1
	}

	If($RecentFileQikAcc -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Recent Files in Quick Access...' -C 15 }
	} ElseIf($RecentFileQikAcc -eq 1) {
		DisplayOut 'Showing Recent Files in Quick Access...' -C 11
		$Path = 'Microsoft\Windows\CurrentVersion\Explorer'
		Set-ItemProperty -Path "HKCU:\SOFTWARE\$Path" -Name 'ShowRecent' -Type DWord -Value 1
		Set-ItemProperty -Path "HKLM:\$Path\HomeFolderDesktop\NameSpace\DelegateFolders\{3134ef9c-6b18-4996-ad04-ed5912e00eb5}" -Name '(Default)' -Type String -Value 'Recent Items Instance Folder'
		If($OSBit -eq 64){ Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\$Path\HomeFolderDesktop\NameSpace\DelegateFolders\{3134ef9c-6b18-4996-ad04-ed5912e00eb5}" -Name '(Default)' -Type String -Value 'Recent Items Instance Folder' }
	} ElseIf($RecentFileQikAcc -eq 2) {
		DisplayOut 'Hiding Recent Files in Quick Access...' -C 12
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShowRecent' -Type DWord -Value 0
	} ElseIf($RecentFileQikAcc -eq 3) {
		DisplayOut 'Removing Recent Files in Quick Access...' -C 15
		$Path = 'Microsoft\Windows\CurrentVersion\Explorer'
		Set-ItemProperty -Path "HKCU:\SOFTWARE\$Path" -Name 'ShowRecent' -Type DWord -Value 0
		RemoveSetPath "HKLM:\SOFTWARE\$Path\HomeFolderDesktop\NameSpace\DelegateFolders\{3134ef9c-6b18-4996-ad04-ed5912e00eb5}"
		RemoveSetPath "HKLM:\SOFTWARE\Wow6432Node\$Path\HomeFolderDesktop\NameSpace\DelegateFolders\{3134ef9c-6b18-4996-ad04-ed5912e00eb5}"
	}

	If($FrequentFoldersQikAcc -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Frequent Folders in Quick Access...' -C 15 }
	} ElseIf($FrequentFoldersQikAcc -eq 1) {
		DisplayOut 'Showing Frequent Folders in Quick Access...' -C 11
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShowFrequent' -Type DWord -Value 1
	} ElseIf($FrequentFoldersQikAcc -eq 2) {
		DisplayOut 'Hiding Frequent Folders in Quick Access...' -C 12
		Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShowFrequent' -Type DWord -Value 0
	}

	If($WinContentWhileDrag -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Window Content while Dragging...' -C 15 }
	} ElseIf($WinContentWhileDrag -eq 1) {
		DisplayOut 'Showing Window Content while Dragging...' -C 11
		Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'DragFullWindows' -Type DWord -Value 1
	} ElseIf($WinContentWhileDrag -eq 2) {
		DisplayOut 'Hiding Window Content while Dragging...' -C 12
		Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'DragFullWindows' -Type DWord -Value 0
	}

	If($Autoplay -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Autoplay...' -C 15 }
	} ElseIf($Autoplay -eq 1) {
		DisplayOut 'Enabling Autoplay...' -C 11
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers' -Name 'DisableAutoplay' -Type DWord -Value 0
	} ElseIf($Autoplay -eq 2) {
		DisplayOut 'Disabling Autoplay...' -C 12
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers' -Name 'DisableAutoplay' -Type DWord -Value 1
	}

	If($Autorun -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Autorun for all Drives...' -C 15 }
	} ElseIf($Autorun -eq 1) {
		DisplayOut 'Enabling Autorun for all Drives...' -C 11
		Remove-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoDriveTypeAutoRun'
	} ElseIf($Autorun -eq 2) {
		DisplayOut 'Disabling Autorun for all Drives...' -C 12
		$Path = CheckSetPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
		Set-ItemProperty -Path $Path -Name 'NoDriveTypeAutoRun' -Type DWord -Value 255
	}

	If($StoreOpenWith -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Search Windows Store for Unknown Extensions...' -C 15 }
	} ElseIf($StoreOpenWith -eq 1) {
		DisplayOut 'Enabling Search Windows Store for Unknown Extensions...' -C 11
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'NoUseStoreOpenWith'
	} ElseIf($StoreOpenWith -eq 2) {
		DisplayOut 'Disabling Search Windows Store for Unknown Extensions...' -C 12
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer'
		Set-ItemProperty -Path $Path -Name 'NoUseStoreOpenWith' -Type DWord -Value 1
	}

	If($WinXPowerShell -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Win+X PowerShell to Command Prompt...' -C 15 }
	} ElseIf($WinXPowerShell -eq 1) {
		DisplayOut 'Changing Win+X Command Prompt to PowerShell...' -C 11
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'DontUsePowerShellOnWinX' -Type DWord -Value 0
	} ElseIf($WinXPowerShell -eq 2) {
		DisplayOut 'Changing Win+X PowerShell to Command Prompt...' -C 12
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'DontUsePowerShellOnWinX' -Type DWord -Value 1
	}

	If($TaskManagerDetails -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Task Manager Details...' -C 15 }
	} ElseIf($TaskManagerDetails -eq 1) {
		DisplayOut 'Attempting to Show Task Manager Details...' -C 11
		$Path =  'HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager'
		$Taskmgr = Start-Process -WindowStyle Hidden -FilePath taskmgr.exe -PassThru
		$timeout = 30000
		$sleep = 100
		$Path =  'HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager'
		Do {
			Start-Sleep -Milliseconds $sleep
			$timeout -= $sleep
			$TaskManKey = Get-ItemProperty -Path $Path -Name 'Preferences'
		} Until ($TaskManKey -or $timeout -le 0)
		Stop-Process $Taskmgr
		If($TaskManKey) {
			DisplayOut '----Showing Task Manager Details...' -C 11
			$TaskManKey.Preferences[28] = 0
			Set-ItemProperty -Path $Path -Name 'Preferences' -Type Binary -Value $TaskManKey.Preferences
		} Else {
			DisplayOut '----Unable to Show Task Manager Details...' -C 13
		}
	} ElseIf($TaskManagerDetails -eq 2) {
		DisplayOut 'Hiding Task Manager Details...' -C 12
		$Path = CheckSetPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager'
		$TaskManKey = Get-ItemProperty -Path $Path -Name 'Preferences'
		If($TaskManKey) {
			$TaskManKey.Preferences[28] = 1
			Set-ItemProperty -Path $Path -Name 'Preferences' -Type Binary -Value $TaskManKey.Preferences
		}
	}

	If($Win10Ver -ge 1709) {
		If($ReopenAppsOnBoot -eq 0) {
			If($ShowSkipped -eq 1){ DisplayOut 'Skipping Re-Opening Apps on Boot...' -C 15 }
		} ElseIf($ReopenAppsOnBoot -eq 1) {
			DisplayOut 'Enableing Re-Opening Apps on Boot (Apps reopen on boot)...' -C 11
			Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'DisableAutomaticRestartSignOn' -Type DWord -Value 0
		} ElseIf($ReopenAppsOnBoot -eq 2) {
			DisplayOut "Disabling Re-Opening Apps on Boot (Apps won't reopen on boot)..." -C 12
			Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'DisableAutomaticRestartSignOn' -Type DWord -Value 1
		}
	}

	If($Win10Ver -ge 1803) {
		If($Timeline -eq 0) {
			If($ShowSkipped -eq 1){ DisplayOut 'Skipping Windows Timeline...' -C 15 }
		} ElseIf($Timeline -eq 1) {
			DisplayOut 'Enableing Windows Timeline...' -C 11
			Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' -Name 'EnableActivityFeed' -Type DWord -Value 1
		} ElseIf($Timeline -eq 2) {
			DisplayOut "Disabling Windows Timeline..." -C 12
			Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' -Name 'EnableActivityFeed' -Type DWord -Value 0
		}
	}

	If($LongFilePath -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Long File Path...' -C 15 }
	} ElseIf($LongFilePath -eq 1) {
		DisplayOut 'Enableing Long File Path...' -C 11
		Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -Type DWord -Value 1
		Set-ItemProperty -Path 'HKLM:\SYSTEM\ControlSet001\Control\FileSystem' -Name 'LongPathsEnabled' -Type DWord -Value 1
	} ElseIf($LongFilePath -eq 2) {
		DisplayOut "Disabling Long File Path..." -C 12
		Remove-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled'
		Remove-ItemProperty -Path 'HKLM:\SYSTEM\ControlSet001\Control\FileSystem' -Name 'LongPathsEnabled'
	}

	If($AppHibernationFile -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping App Hibernation File (Swapfile.sys)...' -C 15 }
	} ElseIf($AppHibernationFile -eq 1) {
		DisplayOut 'Enabling App Hibernation File (Swapfile.sys)...' -C 11
		Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "SwapfileControl"
	} ElseIf($AppHibernationFile -eq 2) {
		DisplayOut 'Disabling App Hibernation File (Swapfile.sys)...' -C 12
		Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "SwapfileControl" -Type Dword -Value 0
	}

	BoxItem "'This PC' Items"
	If($DesktopIconInThisPC -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Desktop folder in This PC...' -C 15 }
	} ElseIf($DesktopIconInThisPC -eq 1) {
		DisplayOut 'Showing Desktop folder in This PC...' -C 11
		$Path = '\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag'
		$Path1 = '\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}'
		New-Item -Path "HKLM:\SOFTWARE\$Path" | Out-Null
		New-Item -Path "HKLM:\SOFTWARE\$Path1" | Out-Null
		Set-ItemProperty -Path "HKLM:\SOFTWARE\$Path" -Name 'ThisPCPolicy' -Type String -Value 'Show'
		If($OSBit -eq 64){
			New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" | Out-Null
			New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\$Path1" | Out-Null
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" -Name 'ThisPCPolicy' -Type String -Value 'Show'
		}
	} ElseIf($DesktopIconInThisPC -eq 2) {
		DisplayOut 'Hiding Desktop folder in This PC...' -C 12
		$Path = '\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag'
		Set-ItemProperty -Path "HKLM:\SOFTWARE\$Path" -Name 'ThisPCPolicy' -Type String -Value 'Hide'
		If($OSBit -eq 64){ Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" -Name 'ThisPCPolicy' -Type String -Value 'Hide' }
	} ElseIf($DesktopIconInThisPC -eq 3) {
		DisplayOut 'Removing Desktop folder in This PC...' -C 13
		RemoveSetPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}'
		RemoveSetPath 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}'
	}

	If($DocumentsIconInThisPC -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Documents folder in This PC...' -C 15 }
	} ElseIf($DocumentsIconInThisPC -eq 1) {
		DisplayOut 'Showing Documents folder in This PC...' -C 11
		$Path = '\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag'
		$Path1 = '\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}'
		$Path2 = '\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}'
		New-Item -Path "HKLM:\SOFTWARE\$Path" | Out-Null
		New-Item -Path "HKLM:\SOFTWARE\$Path1" | Out-Null
		New-Item -Path "HKLM:\SOFTWARE\$Path2" | Out-Null
		Set-ItemProperty -Path "HKLM:\SOFTWARE\$Path" -Name 'ThisPCPolicy' -Type String -Value 'Show'
		Set-ItemProperty -Path "HKLM:\SOFTWARE\$Path" -Name 'BaseFolderId' -Type String -Value '{FDD39AD0-238F-46AF-ADB4-6C85480369C7}'
		If($OSBit -eq 64){
			New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" | Out-Null
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" -Name 'ThisPCPolicy' -Type String -Value 'Show'
			New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\$Path1" | Out-Null
			New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\$Path2" | Out-Null
		}
	}ElseIf($DocumentsIconInThisPC -eq 2) {
		DisplayOut 'Hiding Documents folder in This PC...' -C 12
		$Path = '\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag'
		Set-ItemProperty -Path "HKLM:\SOFTWARE\$Path" -Name 'ThisPCPolicy' -Type String -Value 'Hide'
		If($OSBit -eq 64){ Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" -Name "ThisPCPolicy" -Type String -Value "Hide" }
	} ElseIf($DocumentsIconInThisPC -eq 3) {
		DisplayOut 'Removing Documents folder in This PC...' -C 13
		RemoveSetPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}'
		RemoveSetPath 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}'
		RemoveSetPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}'
		RemoveSetPath 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}'
	}

	If($DownloadsIconInThisPC -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Downloads folder in This PC...' -C 15 }
	} ElseIf($DownloadsIconInThisPC -eq 1) {
		DisplayOut 'Showing Downloads folder in This PC...' -C 11
		$Path = '\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag'
		$Path1 = '\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}'
		$Path2 = '\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}'
		New-Item -Path "HKLM:\SOFTWARE\$Path" | Out-Null
		New-Item -Path "HKLM:\SOFTWARE\$Path1" | Out-Null
		New-Item -Path "HKLM:\SOFTWARE\$Path2" | Out-Null
		Set-ItemProperty -Path "HKLM:\SOFTWARE\$Path" -Name 'ThisPCPolicy' -Type String -Value 'Show'
		Set-ItemProperty -Path "HKLM:\SOFTWARE\$Path" -Name 'BaseFolderId' -Type String -Value '{374DE290-123F-4565-9164-39C4925E467B}'
		If($OSBit -eq 64){
			New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\$Path"
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" -Name 'ThisPCPolicy' -Type String -Value 'Show'
			New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\$Path1" | Out-Null
			New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\$Path2" | Out-Null
		}
	} ElseIf($DownloadsIconInThisPC -eq 2) {
		DisplayOut 'Hiding Downloads folder in This PC...' -C 12
		$Path = '\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag'
		Set-ItemProperty -Path "HKLM:\SOFTWARE\$Path" -Name 'ThisPCPolicy' -Type String -Value 'Hide'
		If($OSBit -eq 64){ Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" -Name "ThisPCPolicy" -Type String -Value "Hide" }
	} ElseIf($DownloadsIconInThisPC -eq 3) {
		DisplayOut 'Removing Downloads folder in This PC...' -C 13
		RemoveSetPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}'
		RemoveSetPath 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}'
		RemoveSetPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}'
		RemoveSetPath 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}'
	}

	If($MusicIconInThisPC -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Music folder in This PC...' -C 15 }
	} ElseIf($MusicIconInThisPC -eq 1) {
		DisplayOut 'Showing Music folder in This PC...' -C 11
		$Path = '\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag'
		$Path1 = '\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}'
		$Path2 = '\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}'
		New-Item -Path "HKLM:\SOFTWARE\$Path" | Out-Null
		New-Item -Path "HKLM:\SOFTWARE\$Path1" | Out-Null
		New-Item -Path "HKLM:\SOFTWARE\$Path2" | Out-Null
		Set-ItemProperty -Path "HKLM:\SOFTWARE\$Path" -Name 'ThisPCPolicy' -Type String -Value 'Show'
		Set-ItemProperty -Path "HKLM:\SOFTWARE\$Path" -Name 'BaseFolderId' -Type String -Value '{4BD8D571-6D19-48D3-BE97-422220080E43}'
		If($OSBit -eq 64){
			New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" | Out-Null
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" -Name 'ThisPCPolicy' -Type String -Value 'Show'
			New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\$Path1" | Out-Null
			New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\$Path2" | Out-Null
		}
	} ElseIf($MusicIconInThisPC -eq 2) {
		DisplayOut 'Hiding Music folder in This PC...' -C 12
		$Path = '\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag'
		Set-ItemProperty -Path "HKLM:\SOFTWARE\$Path" -Name 'ThisPCPolicy' -Type String -Value 'Hide'
		If($OSBit -eq 64){ Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" -Name 'ThisPCPolicy' -Type String -Value 'Hide' }
	} ElseIf($MusicIconInThisPC -eq 3) {
		DisplayOut 'Removing Music folder in This PC...' -C 13
		RemoveSetPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}'
		RemoveSetPath 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}'
		RemoveSetPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}'
		RemoveSetPath 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}'
	}

	If($PicturesIconInThisPC -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Pictures folder in This PC...' -C 15 }
	} ElseIf($PicturesIconInThisPC -eq 1) {
		DisplayOut 'Showing Pictures folder in This PC...' -C 11
		$Path = '\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag'
		$Path1 = '\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}'
		$Path2 = '\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}'
		New-Item -Path "HKLM:\SOFTWARE\$Path" | Out-Null
		New-Item -Path "HKLM:\SOFTWARE\$Path1" | Out-Null
		New-Item -Path "HKLM:\SOFTWARE\$Path2" | Out-Null
		Set-ItemProperty -Path "HKLM:\SOFTWARE\$Path" -Name 'ThisPCPolicy' -Type String -Value 'Show'
		Set-ItemProperty -Path "HKLM:\SOFTWARE\$Path" -Name 'BaseFolderId' -Type String -Value '{33E28130-4E1E-4676-835A-98395C3BC3BB}'
		If($OSBit -eq 64){
			New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" | Out-Null
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" -Name 'ThisPCPolicy' -Type String -Value 'Show'
			New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\$Path1" | Out-Null
			New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\$Path2" | Out-Null
		}
	} ElseIf($PicturesIconInThisPC -eq 2) {
		DisplayOut 'Hiding Pictures folder in This PC...' -C 12
		$Path = '\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag'
		Set-ItemProperty -Path "HKLM:\SOFTWARE\$Path" -Name 'ThisPCPolicy' -Type String -Value 'Hide'
		If($OSBit -eq 64){ Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" -Name 'ThisPCPolicy' -Type String -Value 'Hide' }
	} ElseIf($PicturesIconInThisPC -eq 3) {
		DisplayOut 'Removing Pictures folder in This PC...' -C 13
		RemoveSetPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}'
		RemoveSetPath 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}'
		RemoveSetPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}'
		RemoveSetPath 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}'
	}

	If($VideosIconInThisPC -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Videos folder in This PC...' -C 15 }
	} ElseIf($VideosIconInThisPC -eq 1) {
		DisplayOut 'Showing Videos folder in This PC...' -C 11
		$Path = '\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag'
		$Path1 = '\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}'
		$Path2 = '\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}'
		New-Item -Path "HKLM:\SOFTWARE\$Path" | Out-Null
		New-Item -Path "HKLM:\SOFTWARE\$Path1" | Out-Null
		New-Item -Path "HKLM:\SOFTWARE\$Path2" | Out-Null
		Set-ItemProperty -Path "HKLM:\SOFTWARE\$Path" -Name 'ThisPCPolicy' -Type String -Value 'Show'
		Set-ItemProperty -Path "HKLM:\SOFTWARE\$Path" -Name 'BaseFolderId' -Type String -Value '{18989B1D-99B5-455B-841C-AB7C74E4DDFC}"'
		If($OSBit -eq 64){
			New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" | Out-Null
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" -Name 'ThisPCPolicy' -Type String -Value 'Show'
			New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\$Path1" | Out-Null
			New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\$Path2" | Out-Null
		}
	} ElseIf($VideosIconInThisPC -eq 2) {
		DisplayOut 'Hiding Videos folder in This PC...' -C 12
		$Path = '\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag'
		Set-ItemProperty -Path "HKLM:\SOFTWARE\$Path" -Name "ThisPCPolicy" -Type String -Value "Hide"
		If($OSBit -eq 64){ Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" -Name 'ThisPCPolicy' -Type String -Value 'Hide' }
	} ElseIf($PicturesIconInThisPC -eq 3) {
		DisplayOut 'Removing Videos folder in This PC...' -C 13
		RemoveSetPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}'
		RemoveSetPath 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}'
		RemoveSetPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}'
		RemoveSetPath 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}'
	}

	If($Win10Ver -ge 1709){
		If($ThreeDobjectsIconInThisPC -eq 0) {
			If($ShowSkipped -eq 1){ DisplayOut 'Skipping 3D Object folder in This PC...' -C 15 }
		} ElseIf($ThreeDobjectsIconInThisPC -eq 1) {
			DisplayOut 'Showing 3D Object folder in This PC...' -C 11
			$Path = '\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag'
			$Path1 = '\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}'
			New-Item -Path "HKLM:\SOFTWARE\$Path" | Out-Null
			New-Item -Path "HKLM:\SOFTWARE\$Path1" | Out-Null
			Set-ItemProperty -Path "HKLM:\SOFTWARE\$Path" -Name 'ThisPCPolicy' -Type String -Value 'Show'
			If($OSBit -eq 64){
				New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" | Out-Null
				Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" -Name 'ThisPCPolicy' -Type String -Value 'Show'
				New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\$Path1" | Out-Null
			}
		} ElseIf($ThreeDobjectsIconInThisPC -eq 2) {
			DisplayOut 'Hiding 3D Object folder in This PC...' -C 12
			$Path = '\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag'
			Set-ItemProperty -Path "HKLM:\SOFTWARE\$Path" -Name 'ThisPCPolicy' -Type String -Value 'Hide'
			If($OSBit -eq 64){ Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" -Name 'ThisPCPolicy' -Type String -Value 'Hide' }
		} ElseIf($ThreeDobjectsIconInThisPC -eq 3) {
			DisplayOut 'Removing 3D Object folder in This PC...' -C 13
			RemoveSetPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}'
			RemoveSetPath 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}'
		}
	}

	BoxItem 'Desktop Items'
	$Path = CheckSetPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu'
	If($ThisPCOnDesktop -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping This PC Icon on Desktop...' -C 15 }
	} ElseIf($ThisPCOnDesktop -eq 1) {
		DisplayOut 'Showing This PC Shortcut on Desktop...' -C 11
		$Path = CheckSetPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons'
		Set-ItemProperty -Path "$Path\ClassicStartMenu" -Name '{20D04FE0-3AEA-1069-A2D8-08002B30309D}' -Type DWord -Value 0
		Set-ItemProperty -Path "$Path\NewStartPanel" -Name '{20D04FE0-3AEA-1069-A2D8-08002B30309D}' -Type DWord -Value 0
	} ElseIf($ThisPCOnDesktop -eq 2) {
		DisplayOut 'Hiding This PC Shortcut on Desktop...' -C 12
		$Path = CheckSetPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons'
		Set-ItemProperty -Path "$Path\ClassicStartMenu" -Name '{20D04FE0-3AEA-1069-A2D8-08002B30309D}' -Type DWord -Value 1
		Set-ItemProperty -Path "$Path\NewStartPanel" -Name '{20D04FE0-3AEA-1069-A2D8-08002B30309D}' -Type DWord -Value 1
	}

	If($NetworkOnDesktop -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Network Icon on Desktop...' -C 15 }
	} ElseIf($NetworkOnDesktop -eq 1) {
		DisplayOut 'Showing Network Icon on Desktop...' -C 11
		$Path = CheckSetPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons'
		Set-ItemProperty -Path "$Path\ClassicStartMenu" -Name '{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}' -Type DWord -Value 0
		Set-ItemProperty -Path "$Path\NewStartPanel" -Name '{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}' -Type DWord -Value 0
	} ElseIf($NetworkOnDesktop -eq 2) {
		DisplayOut 'Hiding Network Icon on Desktop...' -C 12
		$Path = CheckSetPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons'
		Set-ItemProperty -Path "$Path\ClassicStartMenu" -Name '{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}' -Type DWord -Value 1
		Set-ItemProperty -Path "$Path\NewStartPanel" -Name '{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}' -Type DWord -Value 1
	}

	If($RecycleBinOnDesktop -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Recycle Bin Icon on Desktop...' -C 15 }
	} ElseIf($RecycleBinOnDesktop -eq 1) {
		DisplayOut 'Showing Recycle Bin Icon on Desktop...' -C 11
		$Path = CheckSetPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons'
		Set-ItemProperty -Path "$Path\ClassicStartMenu" -Name '{645FF040-5081-101B-9F08-00AA002F954E}' -Type DWord -Value 0
		Set-ItemProperty -Path "$Path\NewStartPanel" -Name '{645FF040-5081-101B-9F08-00AA002F954E}' -Type DWord -Value 0
	} ElseIf($RecycleBinOnDesktop -eq 2) {
		DisplayOut 'Hiding Recycle Bin Icon on Desktop...' -C 12
		$Path = CheckSetPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons'
		Set-ItemProperty -Path "$Path\ClassicStartMenu" -Name '{645FF040-5081-101B-9F08-00AA002F954E}' -Type DWord -Value 1
		Set-ItemProperty -Path "$Path\NewStartPanel" -Name '{645FF040-5081-101B-9F08-00AA002F954E}' -Type DWord -Value 1
	}

	If($UsersFileOnDesktop -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Users File Icon on Desktop...' -C 15 }
	} ElseIf($UsersFileOnDesktop -eq 1) {
		DisplayOut 'Showing Users File Icon on Desktop...' -C 11
		$Path = CheckSetPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons'
		Set-ItemProperty -Path "$Path\ClassicStartMenu" -Name "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" -Type DWord -Value 0
		Set-ItemProperty -Path "$Path\NewStartPanel" -Name '{59031a47-3f72-44a7-89c5-5595fe6b30ee}' -Type DWord -Value 0
	} ElseIf($UsersFileOnDesktop -eq 2) {
		DisplayOut 'Hiding Users File Icon on Desktop...' -C 12
		$Path = CheckSetPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons'
		Set-ItemProperty -Path "$Path\ClassicStartMenu" -Name '{59031a47-3f72-44a7-89c5-5595fe6b30ee}' -Type DWord -Value 1
		Set-ItemProperty -Path "$Path\NewStartPanel" -Name '{59031a47-3f72-44a7-89c5-5595fe6b30ee}' -Type DWord -Value 1
	}

	If($ControlPanelOnDesktop -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Control Panel Icon on Desktop...' -C 15 }
	} ElseIf($ControlPanelOnDesktop -eq 1) {
		DisplayOut 'Showing Control Panel Icon on Desktop...' -C 11
		$Path = CheckSetPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons'
		Set-ItemProperty -Path "$Path\ClassicStartMenu" -Name '{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}' -Type DWord -Value 0
		Set-ItemProperty -Path "$Path\NewStartPanel" -Name '{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}' -Type DWord -Value 0
	} ElseIf($ControlPanelOnDesktop -eq 2) {
		DisplayOut 'Hiding Control Panel Icon on Desktop...' -C 12
		$Path = CheckSetPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons'
		Set-ItemProperty -Path "$Path\ClassicStartMenu" -Name '{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}' -Type DWord -Value 1
		Set-ItemProperty -Path "$Path\NewStartPanel" -Name '{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}' -Type DWord -Value 1
	}

	BoxItem 'Photo Viewer Settings'
	If($PVFileAssociation -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Photo Viewer File Association...' -C 15 }
	} ElseIf($PVFileAssociation -eq 1) {
		DisplayOut 'Setting Photo Viewer File Association for bmp, gif, jpg, png and tif...' -C 11
		ForEach($type In @('Paint.Picture', 'giffile', 'jpegfile', 'pngfile')) {
			New-Item -Path $("HKCR:\$type\shell\open") -Force | Out-Null
			New-Item -Path $("HKCR:\$type\shell\open\command") | Out-Null
			Set-ItemProperty -Path $("HKCR:\$type\shell\open") -Name 'MuiVerb' -Type ExpandString -Value "@%ProgramFiles%\Windows Photo Viewer\photoviewer.dll,-3043"
			Set-ItemProperty -Path $("HKCR:\$type\shell\open\command") -Name '(Default)' -Type ExpandString -Value "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1"
		}
	} ElseIf($PVFileAssociation -eq 2) {
		DisplayOut 'Unsetting Photo Viewer File Association for bmp, gif, jpg, png and tif...' -C 12
		RemoveSetPath 'HKCR:\Paint.Picture\shell\open'
		Remove-ItemProperty -Path 'HKCR:\giffile\shell\open' -Name 'MuiVerb'
		Set-ItemProperty -Path 'HKCR:\giffile\shell\open' -Name 'CommandId' -Type String -Value 'IE.File'
		Set-ItemProperty -Path 'HKCR:\giffile\shell\open\command' -Name '(Default)' -Type String -Value "`"$Env:SystemDrive\Program Files\Internet Explorer\iexplore.exe`" %1"
		Set-ItemProperty -Path 'HKCR:\giffile\shell\open\command' -Name 'DelegateExecute' -Type String -Value '{17FE9752-0B5A-4665-84CD-569794602F5C}'
		RemoveSetPath 'HKCR:\jpegfile\shell\open'
		RemoveSetPath 'HKCR:\jpegfile\shell\open'
	}

	If($PVOpenWithMenu -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Photo Viewer Open with Menu...' -C 15 }
	} ElseIf($PVOpenWithMenu -eq 1) {
		DisplayOut 'Adding Photo Viewer to Open with Menu...' -C 11
		New-Item -Path 'HKCR:\Applications\photoviewer.dll\shell\open\command' -Force | Out-Null
		New-Item -Path 'HKCR:\Applications\photoviewer.dll\shell\open\DropTarget' -Force | Out-Null
		Set-ItemProperty -Path 'HKCR:\Applications\photoviewer.dll\shell\open' -Name 'MuiVerb' -Type String -Value '@photoviewer.dll,-3043'
		Set-ItemProperty -Path 'HKCR:\Applications\photoviewer.dll\shell\open\command' -Name '(Default)' -Type ExpandString -Value "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1"
		Set-ItemProperty -Path 'HKCR:\Applications\photoviewer.dll\shell\open\DropTarget' -Name 'Clsid' -Type String -Value '{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}'
	} ElseIf($PVOpenWithMenu -eq 2) {
		DisplayOut 'Removing Photo Viewer from Open with Menu...' -C 12
		RemoveSetPath 'HKCR:\Applications\photoviewer.dll\shell\open'
	}

	BoxItem 'Lockscreen Items'
	If($LockScreen -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Lock Screen...' -C 15 }
	} ElseIf($LockScreen -eq 1) {
		If($Win10Ver -In 1507,1511) {
			DisplayOut 'Enabling Lock Screen...' -C 11
			Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization' -Name 'NoLockScreen'
		} ElseIf($Win10Ver -ge 1607) {
			DisplayOut 'Enabling Lock screen (removing scheduler workaround)...' -C 11
			Unregister-ScheduledTask -TaskName 'Disable LockScreen' -Confirm:$False
		} Else {
			DisplayOut 'Unable to Enable Lock screen...' -C 13
		}
	} ElseIf($LockScreen -eq 2) {
		If($Win10Ver -In 1507,1511) {
			DisplayOut 'Disabling Lock Screen...' -C 12
			$Path = CheckSetPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization'
			Set-ItemProperty -Path $Path -Name 'NoLockScreen' -Type DWord -Value 1
		} ElseIf($Win10Ver -ge 1607) {
			DisplayOut 'Disabling Lock screen using scheduler workaround...' -C 12
			$service = New-Object -com Schedule.Service
			$service.Connect()
			$task = $service.NewTask(0)
			$task.Settings.DisallowStartIfOnBatteries = $False
			$trigger = $task.Triggers.Create(9)
			$trigger = $task.Triggers.Create(11)
			$trigger.StateChange = 8
			$action = $task.Actions.Create(0)
			$action.Path = 'reg.exe'
			$action.Arguments = "add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\SessionData /t REG_DWORD /v AllowLockScreen /d 0 /f"
			$service.GetFolder('\').RegisterTaskDefinition('Disable LockScreen', $task, 6, 'NT AUTHORITY\SYSTEM', $null, 4) | Out-Null
		} Else {
			DisplayOut 'Unable to Disable Lock screen...' -C 13
		}
	}

	If($LockscreenPassword -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Lock Screen Password...' -C 15 }
	} ElseIf($LockscreenPassword -eq 1) {
		DisplayOut 'Enabling Lock Screen Password...' -C 11
		$Path = CheckSetPath 'HKLM:\Software\Policies\Microsoft\Windows\Control Panel\Desktop'
		Set-ItemProperty -Path  $Path -Name 'ScreenSaverIsSecure' -Type DWord -Value 1
		$Path = CheckSetPath 'HKCU:\Software\Policies\Microsoft\Windows\Control Panel\Desktop'
		Set-ItemProperty -Path  $Path -Name 'ScreenSaverIsSecure' -Type DWord -Value 1
	} ElseIf($LockscreenPassword -eq 2) {
		DisplayOut 'Disabling Lock Screen Password...' -C 12
		$Path = CheckSetPath 'HKLM:\Software\Policies\Microsoft\Windows\Control Panel\Desktop'
		Set-ItemProperty -Path  $Path -Name 'ScreenSaverIsSecure' -Type DWord -Value 0
		$Path = CheckSetPath 'HKCU:\Software\Policies\Microsoft\Windows\Control Panel\Desktop'
		Set-ItemProperty -Path  $Path -Name 'ScreenSaverIsSecure' -Type DWord -Value 0
	}
	
	If($PowerMenuLockScreen -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Power Menu on Lock Screen...' -C 15 }
	} ElseIf($PowerMenuLockScreen -eq 1) {
		DisplayOut 'Showing Power Menu on Lock Screen...' -C 11
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'shutdownwithoutlogon' -Type DWord -Value 1
	} ElseIf($PowerMenuLockScreen -eq 2) {
		DisplayOut 'Hiding Power Menu on Lock Screen...' -C 12
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'shutdownwithoutlogon' -Type DWord -Value 0
	}

	If($CameraOnLockscreen -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Camera at Lockscreen...' -C 15 }
	} ElseIf($CameraOnLockscreen -eq 1) {
		DisplayOut 'Enabling Camera at Lockscreen...' -C 11
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization' -Name 'NoLockScreenCamera'
	} ElseIf($CameraOnLockscreen -eq 2) {
		DisplayOut 'Disabling Camera at Lockscreen...' -C 12
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization'
		Set-ItemProperty -Path $Path -Name 'NoLockScreenCamera' -Type DWord -Value 1
	}

	BoxItem 'Misc Items'
	If($ScreenSaver -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping ScreenSaver...' -C 15 }
	} ElseIf($ScreenSaver -eq 1) {
		DisplayOut 'Enabling ScreenSaver...' -C 11
		$Path = CheckSetPath 'HKCU:\Control Panel\Desktop'
		Set-ItemProperty -Path  $Path -Name 'ScreenSaveActive' -Type DWord -Value 1
	} ElseIf($ScreenSaver -eq 2) {
		DisplayOut 'Disabling ScreenSaver...' -C 12
		$Path = CheckSetPath 'HKCU:\Control Panel\Desktop'
		Set-ItemProperty -Path  $Path -Name 'ScreenSaveActive' -Type DWord -Value 0
	}

	If($Win10Ver -ge 1803) {
		If($AccountProtectionWarn -eq 0) {
			If($ShowSkipped -eq 1){ DisplayOut 'Skipping Account Protection Warning...' -C 15 }
		} ElseIf($AccountProtectionWarn -eq 1) {
			DisplayOut 'Enabling Account Protection Warning...' -C 11
			Remove-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows Security Health\State' -Name 'AccountProtection_MicrosoftAccount_Disconnected'
		} ElseIf($AccountProtectionWarn -eq 2) {
			DisplayOut 'Disabling Account Protection Warning...' -C 12
			$Path = CheckSetPath 'HKCU:\SOFTWARE\Microsoft\Windows Security Health\State'
			Set-ItemProperty $Path -Name 'AccountProtection_MicrosoftAccount_Disconnected' -Type DWord -Value 1
		}
	}

	If($ActionCenter -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Action Center...' -C 15 }
	} ElseIf($ActionCenter -eq 1) {
		DisplayOut 'Enabling Action Center...' -C 11
		Remove-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'DisableNotificationCenter'
		Remove-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications' -Name 'ToastEnabled'
	} ElseIf($ActionCenter -eq 2) {
		DisplayOut 'Disabling Action Center...' -C 12
		$Path = CheckSetPath 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer'
		Set-ItemProperty -Path $Path -Name 'DisableNotificationCenter' -Type DWord -Value 1
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications' -Name 'ToastEnabled' -Type DWord -Value 0
	}

	If($StickyKeyPrompt -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Sticky Key Prompt...' -C 15 }
	} ElseIf($StickyKeyPrompt -eq 1) {
		DisplayOut 'Enabling Sticky Key Prompt...' -C 11
		Set-ItemProperty -Path 'HKCU:\Control Panel\Accessibility\StickyKeys' -Name 'Flags' -Type String -Value '510'
	} ElseIf($StickyKeyPrompt -eq 2) {
		DisplayOut 'Disabling Sticky Key Prompt...' -C 12
		Set-ItemProperty -Path 'HKCU:\Control Panel\Accessibility\StickyKeys' -Name 'Flags' -Type String -Value '506'
	}

	If($NumblockOnStart -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Num Lock on Startup...' -C 15 }
	} ElseIf($NumblockOnStart -eq 1) {
		DisplayOut 'Enabling Num Lock on Startup...' -C 11
		Set-ItemProperty -Path 'HKU:\.DEFAULT\Control Panel\Keyboard' -Name 'InitialKeyboardIndicators' -Type DWord -Value 2147483650
	} ElseIf($NumblockOnStart -eq 2) {
		DisplayOut 'Disabling Num Lock on Startup...' -C 12
		Set-ItemProperty -Path 'HKU:\.DEFAULT\Control Panel\Keyboard' -Name 'InitialKeyboardIndicators' -Type DWord -Value 2147483648
	}

	If($F8BootMenu -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping F8 boot menu options...' -C 15 }
	} ElseIf($F8BootMenu -eq 1) {
		DisplayOut 'Enabling F8 boot menu options...' -C 11
		bcdedit /set `{current`} bootmenupolicy Legacy | Out-Null
	} ElseIf($F8BootMenu -eq 2) {
		DisplayOut 'Disabling F8 boot menu options...' -C 12
		bcdedit /set `{current`} bootmenupolicy Standard | Out-Null
	}

	If($RemoteUACAcctToken -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Remote UAC Local Account Token Filter...' -C 15 }
	} ElseIf($RemoteUACAcctToken -eq 1) {
		DisplayOut 'Enabling Remote UAC Local Account Token Filter...' -C 11
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'LocalAccountTokenFilterPolicy' -Type DWord -Value 1
	} ElseIf($RemoteUACAcctToken -eq 2) {
		DisplayOut 'Disabling  Remote UAC Local Account Token Filter...' -C 12
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'LocalAccountTokenFilterPolicy'
	}

	If($HibernatePower -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Hibernate Option...' -C 15 }
	} ElseIf($HibernatePower -eq 1) {
		DisplayOut 'Enabling Hibernate Option...' -C 11
		Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Power' -Name 'HibernateEnabled' -Type DWord -Value 1
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings' -Name 'ShowHibernateOption' -Type DWord -Value 1
		powercfg /HIBERNATE ON
	} ElseIf($HibernatePower -eq 2) {
		DisplayOut 'Disabling Hibernate Option...' -C 12
		Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Power' -Name 'HibernateEnabled' -Type DWord -Value 0
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings' -Name 'ShowHibernateOption' -Type DWord -Value 0
		powercfg /HIBERNATE OFF
	}

	If($SleepPower -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Sleep Option...' -C 15 }
	} ElseIf($SleepPower -eq 1) {
		DisplayOut 'Enabling Sleep Option...' -C 11
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings'
		Set-ItemProperty -Path $Path -Name 'ShowSleepOption' -Type DWord -Value 1
		powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_BUTTONS SBUTTONACTION 1
		powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_BUTTONS SBUTTONACTION 1
	} ElseIf($SleepPower -eq 2) {
		DisplayOut 'Disabling Sleep Option...' -C 12
		Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings' -Name 'ShowSleepOption' -Type DWord -Value 0
		powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_BUTTONS SBUTTONACTION 0
		powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_BUTTONS SBUTTONACTION 0
	}

	If($UnpinItems -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Unpinning Items...' -C 15 }
	} ElseIf($UnpinItems -eq 1) {
		DisplayOut "`nUnpinning All Startmenu Items..." -C 12
		If($Win10Ver -le 1709) {
			Get-ChildItem -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount" -Include "*.group" -Recurse | ForEach-Object {
				$data = (Get-ItemProperty -Path "$($_.PsPath)\Current" -Name "Data").Data -Join ","
				$data = $data.Substring(0, $data.IndexOf(",0,202,30") + 9) + ",0,202,80,0,0"
				Set-ItemProperty -Path "$($_.PsPath)\Current" -Name "Data" -Type Binary -Value $data.Split(",")
			}
		} Else {
			$key = Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\*start.tilegrid`$windows.data.curatedtilecollection.tilecollection\Current"
			$data = $key.Data[0..25] + ([byte[]](202,50,0,226,44,1,1,0,0))
			Set-ItemProperty -Path $key.PSPath -Name "Data" -Type Binary -Value $data
			Stop-Process -Name "ShellExperienceHost" -Force
		}
	}

	If($DisableVariousTasks -eq 0) {
		#If($ShowSkipped -eq 1){ DisplayOut 'Skipping  Various Scheduled Tasks...' -C 15 }
	} ElseIf($DisableVariousTasks -eq 1) {
		DisplayOut "`nEnabling Various Scheduled Tasks...`n------------------" -C 12
		ForEach($TaskN in $TasksList){ Get-ScheduledTask -TaskName $TaskN | Enable-ScheduledTask }
	} ElseIf($DisableVariousTasks -eq 2) {
		DisplayOut "`nDisableing Various Scheduled Tasks...`n------------------" -C 12
		ForEach($TaskN in $TasksList){ Get-ScheduledTask -TaskName $TaskN | Disable-ScheduledTask }
	}

	If(($ScreenSaverWaitTime -as [double]) -ne $null -and ($ScreenSaverWaitTime % 2) -In 0,1) {
		DisplayOut 'Setting ScreenSaver Wait Time to ',"$ScreenSaverWaitTime Seconds" -C 11,14
		$Path = CheckSetPath 'HKLM:\Software\Policies\Microsoft\Windows'
		Set-ItemProperty -Path  $Path -Name 'ScreenSaveTimeout' -Type DWord -Value $ScreenSaverWaitTime
	}

	BoxItem 'Application/Feature Items'
	If($OneDrive -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping OneDrive...' -C 15 }
	} ElseIf($OneDrive -eq 1) {
		DisplayOut 'Enabling OneDrive...' -C 11
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive' -Name 'DisableFileSyncNGSC'
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowSyncProviderNotifications' -Type DWord -Value 1
	} ElseIf($OneDrive -eq 2) {
		DisplayOut 'Disabling OneDrive...' -C 12
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive'
		Set-ItemProperty -Path $Path -Name 'DisableFileSyncNGSC' -Type DWord -Value 1
		Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowSyncProviderNotifications' -Type DWord -Value 0
	}

	If($OneDriveInstall -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping OneDrive Installing...' -C 15 }
	} ElseIf($OneDriveInstall -eq 1) {
		DisplayOut 'Installing OneDrive...' -C 11
		$onedriveS = "$Env:WINDIR\"
		If($OSBit -eq 64){ $onedriveS += 'SysWOW64' } Else{ $onedriveS += 'System32' }
		$onedriveS += '\OneDriveSetup.exe'
		If(Test-Path $onedriveS -PathType Leaf) { Start-Process $onedriveS -NoNewWindow }
	} ElseIf($OneDriveInstall -eq 2) {
		DisplayOut 'Uninstalling OneDrive...' -C 15
		$onedriveS = "$Env:WINDIR\"
		If($OSBit -eq 64){ $onedriveS += 'SysWOW64' } Else{ $onedriveS += 'System32' }
		$onedriveS += '\OneDriveSetup.exe'
		If(Test-Path $onedriveS -PathType Leaf) {
			Stop-Process -Name OneDrive -Force
			Start-Sleep -s 3
			Start-Process $onedriveS '/uninstall' -NoNewWindow -Wait | Out-Null
			Start-Sleep -s 3
			Stop-Process -Name Explorer -Force
			Start-Sleep -s 3
			Remove-Item "$Env:USERPROFILE\OneDrive" -Force -Recurse
			Remove-Item "$Env:LOCALAPPDATA\Microsoft\OneDrive" -Force -Recurse
			Remove-Item "$Env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse
			Remove-Item "$Env:WINDIR\OneDriveTemp" -Force -Recurse
			Remove-Item "$Env:SYSTEMDRIVE\OneDriveTemp" -Force -Recurse
			Remove-Item -Path 'HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}' -Recurse
			Remove-Item -Path 'HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}' -Force -Recurse
		}
	}

	If($XboxDVR -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Xbox DVR...' -C 15 }
	} ElseIf($XboxDVR -eq 1) {
		DisplayOut 'Enabling Xbox DVR...' -C 11
		Set-ItemProperty -Path 'HKCU:\System\GameConfigStore' -Name 'GameDVR_Enabled' -Type DWord -Value 1
		Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR' -Name 'AllowGameDVR'
	} ElseIf($XboxDVR -eq 2) {
		DisplayOut 'Disabling Xbox DVR...' -C 12
		$Path = CheckSetPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR'
		Set-ItemProperty -Path $Path -Name 'AllowGameDVR' -Type DWord -Value 0
		Set-ItemProperty -Path 'HKCU:\System\GameConfigStore' -Name 'GameDVR_Enabled' -Type DWord -Value 0
	}

	If($MediaPlayer -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Windows Media Player...' -C 15 }
	} ElseIf($MediaPlayer -eq 1) {
		DisplayOut 'Installing Windows Media Player...' -C 11
		If((Get-WindowsOptionalFeature -Online | Where-Object featurename -Like 'MediaPlayback').State){ Enable-WindowsOptionalFeature -Online -FeatureName 'WindowsMediaPlayer' -NoRestart | Out-Null }
	} ElseIf($MediaPlayer -eq 2) {
		DisplayOut 'Uninstalling Windows Media Player...' -C 14
		If(!((Get-WindowsOptionalFeature -Online | Where-Object featurename -Like 'MediaPlayback').State)){ Disable-WindowsOptionalFeature -Online -FeatureName 'WindowsMediaPlayer' -NoRestart | Out-Null }
	}

	If($WorkFolders -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Work Folders Client...' -C 15 }
	} ElseIf($WorkFolders -eq 1) {
		DisplayOut 'Installing Work Folders Client...' -C 11
		If((Get-WindowsOptionalFeature -Online | Where-Object featurename -Like 'WorkFolders-Client').State){ Enable-WindowsOptionalFeature -Online -FeatureName 'WorkFolders-Client' -NoRestart | Out-Null }
	} ElseIf($WorkFolders -eq 2) {
		DisplayOut 'Uninstalling Work Folders Client...' -C 14
		If(!((Get-WindowsOptionalFeature -Online | Where-Object featurename -Like 'WorkFolders-Client').State)){ Disable-WindowsOptionalFeature -Online -FeatureName 'WorkFolders-Client' -NoRestart | Out-Null }
	}

	If($FaxAndScan -eq 0) {
		If($ShowSkipped -eq 1){ DisplayOut 'Skipping Fax And Scan...' -C 15 }
	} ElseIf($FaxAndScan -eq 1) {
		DisplayOut 'Installing Fax And Scan....' -C 11
		If((Get-WindowsOptionalFeature -Online | Where-Object featurename -Like 'FaxServicesClientPackage').State){ Enable-WindowsOptionalFeature -Online -FeatureName 'FaxServicesClientPackage' -NoRestart | Out-Null }
	} ElseIf($WFaxAndScan -eq 2) {
		DisplayOut 'Uninstalling Fax And Scan....' -C 14
		If(!((Get-WindowsOptionalFeature -Online | Where-Object featurename -Like 'FaxServicesClientPackage').State)){ Disable-WindowsOptionalFeature -Online -FeatureName 'FaxServicesClientPackage' -NoRestart | Out-Null }
	}

	If($Win10Ver -ge 1607) {
		If($LinuxSubsystem -eq 0) {
			If($ShowSkipped -eq 1){ DisplayOut 'Skipping Linux Subsystem...' -C 15 }
		} ElseIf($LinuxSubsystem -eq 1) {
			DisplayOut 'Installing Linux Subsystem...' -C 11
			If((Get-WindowsOptionalFeature -Online | Where-Object featurename -Like 'Microsoft-Windows-Subsystem-Linux').State){
				$Path = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock'
				Set-ItemProperty -Path $Path -Name 'AllowDevelopmentWithoutDevLicense' -Type DWord -Value 1
				Set-ItemProperty -Path $Path -Name 'AllowAllTrustedApps' -Type DWord -Value 1
				Enable-WindowsOptionalFeature -Online -FeatureName 'Microsoft-Windows-Subsystem-Linux' -NoRestart | Out-Null
			}
		} ElseIf($LinuxSubsystem -eq 2) {
			DisplayOut 'Uninstalling Linux Subsystem...' -C 14
			If(!((Get-WindowsOptionalFeature -Online | Where-Object featurename -Like 'Microsoft-Windows-Subsystem-Linux').State)){
				$Path = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock'
				Set-ItemProperty -Path $Path -Name 'AllowDevelopmentWithoutDevLicense' -Type DWord -Value 0
				Set-ItemProperty -Path $Path -Name 'AllowAllTrustedApps' -Type DWord -Value 0
				Disable-WindowsOptionalFeature -Online -FeatureName 'Microsoft-Windows-Subsystem-Linux' -NoRestart | Out-Null
			}
		}
	} ElseIf($LinuxSubsystem -ne 0) {
		DisplayOut "Windows 10 Build isn't new enough for Linux Subsystem..." -C 14
	}

	If($AppxCount -ne 0) {
		BoxItem 'Waiting for Appx Task to Finish'
		Wait-Job -Name "Win10Script*"
		Remove-Job -Name "Win10Script*"
	}

	If($Restart -eq 1 -And $Release_Type -eq 'Stable') {
		Clear-Host
		ThanksDonate
		$Seconds = 15
		DisplayOut "`nRestarting Computer in ",$Seconds,' Seconds...' -C 15,11,15
		$Message = 'Restarting in'
		Start-Sleep -Seconds 1
		ForEach($Count In (1..$Seconds)){ If($Count -ne 0){ DisplayOut $Message," $($Seconds - $Count)" -C 15,11 ;Start-Sleep -Seconds 1 } }
		DisplayOut 'Restarting Computer...' -C 13
		Restart-Computer
	} ElseIf($Release_Type -eq 'Stable') {
		DisplayOut 'Goodbye...' -C 13
		If($Automated -eq 0){ Read-Host -Prompt "`nPress any key to exit" }
		Exit
	} ElseIf($Automated -eq 0) {
		ThanksDonate
		Read-Host -Prompt "`nPress any key to Exit"
	}
}

##########
# Script -End
##########

# Used to get all values BEFORE any defined so
# when exporting shows ALL defined after this point
[System.Collections.ArrayList]$Script:WPFList = @()
$AutomaticVariables = Get-Variable -Scope Script

Function SetDefault {
#--------------------------------------------------------------------------
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## !!                                            !!
## !!            SAFE TO EDIT VALUES             !!
## !!                                            !!
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# Edit values (Option) to your preference
# Change to an Option not listed will Skip the Function/Setting

# Note: If you're not sure what something does don't change it or do a web search

# Can ONLY create 1 per 24 hours with this script (Will give an error)
$Script:CreateRestorePoint = 0      #0-Skip, 1-Create --(Restore point before script runs)
$Script:RestorePointName = "Win10 Initial Setup Script"

#Skips Term of Use
$Script:AcceptToS = 1               #1-See ToS, Anything else = Accepts Term of Use
$Script:Automated = 0               #0-Pause at End/Error, Don't Pause at End/Error

$Script:ShowSkipped = 1             #0-Don't Show Skipped, 1-Show Skipped

#Update Related
$Script:VersionCheck = 0            #0-Don't Check for Update, 1-Check for Update (Will Auto Download and run newer version)
# Note: If found will Auto download and runs that, File name will be "Win10-Menu.ps1"

$Script:InternetCheck = 0           #0 = Checks if you have Internet by doing a ping to GitHub.com
                                    #1 = Bypass check if your pings are blocked

#Restart when done? (I recommend restarting when done)
$Script:Restart = 1                 #0-Don't Restart, 1-Restart

#Windows Default for ALL Settings
$Script:WinDefault = 2              #1-Yes*, 2-No
# IF 1 is set then Everything Other than the following will use the Default Win Settings
# ALL Values Above this one, All Windows Apps and OneDriveInstall (Will use what you set)

#Privacy Settings
# Function = Option                 #Choices (* Indicates Windows Default)
$Script:Telemetry = 0               #0-Skip, 1-Enable*, 2-Disable
$Script:WiFiSense = 0               #0-Skip, 1-Enable*, 2-Disable
$Script:SmartScreen = 0             #0-Skip, 1-Enable*, 2-Disable --(phishing and malware filter for some MS Apps/Prog)
$Script:LocationTracking = 0        #0-Skip, 1-Enable*, 2-Disable
$Script:Feedback = 0                #0-Skip, 1-Enable*, 2-Disable
$Script:AdvertisingID = 0           #0-Skip, 1-Enable*, 2-Disable
$Script:Cortana = 0                 #0-Skip, 1-Enable*, 2-Disable
$Script:CortanaSearch = 0           #0-Skip, 1-Enable*, 2-Disable --(If you disable Cortana you can still search with this)
$Script:ErrorReporting = 0          #0-Skip, 1-Enable*, 2-Disable
$Script:AutoLoggerFile = 0          #0-Skip, 1-Enable*, 2-Disable
$Script:DiagTrack = 0               #0-Skip, 1-Enable*, 2-Disable
$Script:WAPPush = 0                 #0-Skip, 1-Enable*, 2-Disable --(type of text message that contains a direct link to a particular Web page)

#Windows Update
# Function = Option                 #Choices (* Indicates Windows Default)
$Script:UpdateMSProducts = 0		#0-Skip, 1-Enable, 2-Disable*
$Script:CheckForWinUpdate = 0       #0-Skip, 1-Enable*, 2-Disable
$Script:WinUpdateType = 0           #0-Skip, 1-Notify, 2-Auto DL, 3-Auto DL+Install*, 4-Local admin chose --(May not work with Home version)
$Script:WinUpdateDownload = 0       #0-Skip, 1-P2P*, 2-Local Only, 3-Disable
$Script:UpdateMSRT = 0              #0-Skip, 1-Enable*, 2-Disable --(Malware Software Removal Tool)
$Script:UpdateDriver = 0            #0-Skip, 1-Enable*, 2-Disable --(Offering of drivers through Windows Update)
$Script:RestartOnUpdate = 0         #0-Skip, 1-Enable*, 2-Disable
$Script:AppAutoDownload = 0         #0-Skip, 1-Enable*, 2-Disable
$Script:UpdateAvailablePopup = 0    #0-Skip, 1-Enable*, 2-Disable

#Service Tweaks
# Function = Option                 #Choices (* Indicates Windows Default)
$Script:UAC = 0                     #0-Skip, 1-Lower, 2-Normal*, 3-Higher
$Script:SharingMappedDrives = 0     #0-Skip, 1-Enable, 2-Disable* --(Sharing mapped drives between users)
$Script:AdminShares = 0             #0-Skip, 1-Enable*, 2-Disable --(Default admin shares for each drive)
$Script:Firewall = 0                #0-Skip, 1-Enable*, 2-Disable
$Script:WinDefender = 0             #0-Skip, 1-Enable*, 2-Disable
$Script:HomeGroups = 0              #0-Skip, 1-Enable*, 2-Disable
$Script:RemoteAssistance = 0        #0-Skip, 1-Enable*, 2-Disable
$Script:RemoteDesktop = 0           #0-Skip, 1-Enable, 2-Disable* --(Remote Desktop w/o Network Level Authentication)

#Context Menu Items
# Function = Option                 #Choices (* Indicates Windows Default)
$Script:CastToDevice = 0            #0-Skip, 1-Enable*, 2-Disable
$Script:PreviousVersions = 0        #0-Skip, 1-Enable*, 2-Disable
$Script:IncludeinLibrary = 0        #0-Skip, 1-Enable*, 2-Disable
$Script:PinToStart = 0              #0-Skip, 1-Enable*, 2-Disable
$Script:PinToQuickAccess = 0        #0-Skip, 1-Enable*, 2-Disable
$Script:ShareWith = 0               #0-Skip, 1-Enable*, 2-Disable
$Script:SendTo = 0                  #0-Skip, 1-Enable*, 2-Disable

#Task Bar Items
# Function = Option                 #Choices (* Indicates Windows Default)
$Script:BatteryUIBar = 0            #0-Skip, 1-New*, 2-Classic --(Classic is Win 7 version)
$Script:ClockUIBar = 0              #0-Skip, 1-New*, 2-Classic --(Classic is Win 7 version)
$Script:VolumeControlBar = 0        #0-Skip, 1-New(Horizontal)*, 2-Classic(Vertical) --(Classic is Win 7 version)
$Script:TaskbarSearchBox = 0        #0-Skip, 1-Show*, 2-Hide
$Script:TaskViewButton = 0          #0-Skip, 1-Show*, 2-Hide
$Script:TaskbarIconSize = 0         #0-Skip, 1-Normal*, 2-Smaller
$Script:TaskbarGrouping = 0         #0-Skip, 1-Never, 2-Always*, 3-When Needed
$Script:TrayIcons = 0               #0-Skip, 1-Auto*, 2-Always Show
$Script:SecondsInClock = 0          #0-Skip, 1-Show, 2-Hide*
$Script:LastActiveClick = 0         #0-Skip, 1-Enable, 2-Disable* --(Makes Taskbar Buttons Open the Last Active Window)
$Script:TaskBarOnMultiDisplay = 0   #0-Skip, 1-Enable*, 2-Disable
$Script:TaskBarButtOnDisplay = 0    #0-Skip, 1-All, 2-where window is open, 3-Main and where window is open

#Star Menu Items
# Function = Option                 #Choices (* Indicates Windows Default)
$Script:StartMenuWebSearch = 0      #0-Skip, 1-Enable*, 2-Disable
$Script:StartSuggestions = 0        #0-Skip, 1-Enable*, 2-Disable --(The Suggested Apps in Start Menu)
$Script:MostUsedAppStartMenu = 0    #0-Skip, 1-Show*, 2-Hide
$Script:RecentItemsFrequent = 0     #0-Skip, 1-Enable*, 2-Disable --(In Start Menu)
$Script:UnpinItems = 0              #0-Skip, 1-Unpin

#Explorer Items
# Function = Option                 #Choices (* Indicates Windows Default)
$Script:AccessKeyPrmpt = 0          #0-Skip, 1-Enable*, 2-Disable
$Script:F1HelpKey = 0               #0-Skip, 1-Enable*, 2-Disable
$Script:Autoplay = 0                #0-Skip, 1-Enable*, 2-Disable
$Script:Autorun = 0                 #0-Skip, 1-Enable*, 2-Disable
$Script:PidInTitleBar = 0           #0-Skip, 1-Show, 2-Hide* --(PID = Processor ID)
$Script:AeroSnap = 0                #0-Skip, 1-Enable*, 2-Disable --(Allows you to quickly resize the window you’re currently using)
$Script:AeroShake = 0               #0-Skip, 1-Enable*, 2-Disable
$Script:KnownExtensions = 0         #0-Skip, 1-Show, 2-Hide*
$Script:HiddenFiles = 0             #0-Skip, 1-Show, 2-Hide*
$Script:SystemFiles = 0             #0-Skip, 1-Show, 2-Hide*
$Script:ExplorerOpenLoc = 0         #0-Skip, 1-Quick Access*, 2-ThisPC --(What location it opened when you open an explorer window)
$Script:RecentFileQikAcc = 0        #0-Skip, 1-Show/Add*, 2-Hide, 3-Remove --(Recent Files in Quick Access)
$Script:FrequentFoldersQikAcc = 0   #0-Skip, 1-Show*, 2-Hide --(Frequent Folders in Quick Access)
$Script:WinContentWhileDrag = 0     #0-Skip, 1-Show*, 2-Hide
$Script:StoreOpenWith = 0           #0-Skip, 1-Enable*, 2-Disable
$Script:WinXPowerShell = 0          #0-Skip, 1-PowerShell*, 2-Command Prompt
$Script:TaskManagerDetails = 0      #0-Skip, 1-Show, 2-Hide*
$Script:ReopenAppsOnBoot = 0        #0-Skip, 1-Enable*, 2-Disable
$Script:Timeline = 0                #0-Skip, 1-Enable*, 2-Disable
$Script:LongFilePath = 0            #0-Skip, 1-Enable, 2-Disable*
$Script:AppHibernationFile = 0      #0-Skip, 1-Enable*, 2-Disable

#'This PC' Items
# Function = Option                 #Choices (* Indicates Windows Default)
$Script:DesktopIconInThisPC = 0     #0-Skip, 1-Show/Add*, 2-Hide, 3- Remove
$Script:DocumentsIconInThisPC = 0   #0-Skip, 1-Show/Add*, 2-Hide, 3- Remove
$Script:DownloadsIconInThisPC = 0   #0-Skip, 1-Show/Add*, 2-Hide, 3- Remove
$Script:MusicIconInThisPC = 0       #0-Skip, 1-Show/Add*, 2-Hide, 3- Remove
$Script:PicturesIconInThisPC = 0    #0-Skip, 1-Show/Add*, 2-Hide, 3- Remove
$Script:VideosIconInThisPC = 0      #0-Skip, 1-Show/Add*, 2-Hide, 3- Remove
$Script:ThreeDobjectsIconInThisPC = 0   #0-Skip, 1-Show/Add*, 2-Hide, 3- Remove
# CAUTION: Removing them can cause problems

#Desktop Items
# Function = Option                 #Choices (* Indicates Windows Default)
$Script:ThisPCOnDesktop = 0         #0-Skip, 1-Show, 2-Hide*
$Script:NetworkOnDesktop = 0        #0-Skip, 1-Show, 2-Hide*
$Script:RecycleBinOnDesktop = 0     #0-Skip, 1-Show, 2-Hide*
$Script:UsersFileOnDesktop = 0      #0-Skip, 1-Show, 2-Hide*
$Script:ControlPanelOnDesktop = 0   #0-Skip, 1-Show, 2-Hide*

#Lock Screen
# Function = Option                 #Choices (* Indicates Windows Default)
$Script:LockScreen = 0              #0-Skip, 1-Enable*, 2-Disable
$Script:LockscreenPassword = 0      #0-Skip, 1-Enable*, 2-Disable
$Script:PowerMenuLockScreen = 0     #0-Skip, 1-Show*, 2-Hide
$Script:CameraOnLockScreen = 0      #0-Skip, 1-Enable*, 2-Disable

#Misc items
# Function = Option                 #Choices (* Indicates Windows Default)
$Script:ScreenSaver = 0             #0-Skip, 1-Enable*, 2-Disable
$Script:AccountProtectionWarn = 0   #0-Skip, 1-Enable*, 2-Disable
$Script:ActionCenter = 0            #0-Skip, 1-Enable*, 2-Disable
$Script:StickyKeyPrompt = 0         #0-Skip, 1-Enable*, 2-Disable
$Script:NumblockOnStart = 0         #0-Skip, 1-Enable, 2-Disable*
$Script:F8BootMenu = 0              #0-Skip, 1-Enable, 2-Disable*
$Script:RemoteUACAcctToken = 0      #0-Skip, 1-Enable, 2-Disable*
$Script:HibernatePower = 0          #0-Skip, 1-Enable, 2-Disable --(Hibernate Power Option)
$Script:SleepPower = 0              #0-Skip, 1-Enable*, 2-Disable --(Sleep Power Option)

# Photo Viewer Settings
# Function = Option                 #Choices (* Indicates Windows Default)
$Script:PVFileAssociation = 0       #0-Skip, 1-Enable, 2-Disable*
$Script:PVOpenWithMenu = 0          #0-Skip, 1-Enable, 2-Disable*

# Application/Feature
# Function = Option                 #Choices (* Indicates Windows Default)
$Script:OneDrive = 0                #0-Skip, 1-Enable*, 2-Disable
$Script:OneDriveInstall = 0         #0-Skip, 1-Installed*, 2-Uninstall
$Script:XboxDVR = 0                 #0-Skip, 1-Enable*, 2-Disable
$Script:MediaPlayer = 0             #0-Skip, 1-Installed*, 2-Uninstall
$Script:WorkFolders = 0             #0-Skip, 1-Installed*, 2-Uninstall
$Script:FaxAndScan = 0              #0-Skip, 1-Installed*, 2-Uninstall
$Script:LinuxSubsystem = 0          #0-Skip, 1-Installed, 2-Uninstall* (Anniversary Update or Higher)

# Custom List of App to Install, Hide or Uninstall
# I dunno if you can Install random apps with this script
[System.Collections.ArrayList]$Script:APPS_AppsUnhide = @()         # Apps to Install
[System.Collections.ArrayList]$Script:APPS_AppsHide = @()           # Apps to Hide
[System.Collections.ArrayList]$Script:APPS_AppsUninstall = @()      # Apps to Uninstall
#$Script:APPS_Example = @('Somecompany.Appname1','TerribleCompany.Appname2','AppS.Appname3')
# To get list of Packages Installed (in PowerShell)
# DISM /Online /Get-ProvisionedAppxPackages | Select-string Packagename


# Windows Apps
# By Default Most of these are installed
# Function  = Option  # 0-Skip, 1-Unhide, 2- Hide, 3-Uninstall (!!Read Note Above)
$Script:APP_3DBuilder = 0           # 3DBuilder app
$Script:APP_3DViewer = 0            # 3DViewer app
$Script:APP_BingWeather = 0         # Bing Weather app
$Script:APP_CommsPhone = 0          # Phone app
$Script:APP_Communications = 0      # Calendar & Mail app
$Script:APP_GetHelp = 0             # Microsoft's Self-Help App
$Script:APP_Getstarted = 0          # Get Started link
$Script:APP_Messaging = 0           # Messaging app
$Script:APP_MicrosoftOffHub = 0     # Get Office Link
$Script:APP_MovieMoments = 0        # Movie Moments app
$Script:APP_Netflix = 0             # Netflix app
$Script:APP_OfficeOneNote = 0       # Office OneNote app
$Script:APP_OfficeSway = 0          # Office Sway app
$Script:APP_OneConnect = 0          # One Connect
$Script:APP_People = 0              # People app
$Script:APP_Photos = 0              # Photos app
$Script:APP_SkypeApp1 = 0           # Microsoft.SkypeApp
$Script:APP_SolitaireCollect = 0    # Microsoft Solitaire
$Script:APP_StickyNotes = 0         # Sticky Notes app
$Script:APP_WindowsWallet = 0       # Stores Credit and Debit Card Information
$Script:APP_VoiceRecorder = 0       # Voice Recorder app
$Script:APP_WindowsAlarms = 0       # Alarms and Clock app
$Script:APP_WindowsCalculator = 0   # Calculator app
$Script:APP_WindowsCamera = 0       # Camera app
$Script:APP_WindowsFeedbak1 = 0     # Microsoft.WindowsFeedback
$Script:APP_WindowsFeedbak2 = 0     # Microsoft.WindowsFeedbackHub
$Script:APP_WindowsMaps = 0         # Maps app
$Script:APP_WindowsPhone = 0        # Phone Companion app
$Script:APP_WindowsStore = 0        # Windows Store
$Script:APP_XboxApp = 0             # All Xbox apps (There is a few)
$Script:APP_ZuneMusic = 0           # Groove Music app
$Script:APP_ZuneVideo = 0           # Groove Video app

#These Items are NOT shown in GUI
#These items must be set here or set in a loaded config file
$Script:ScreenSaverWaitTime = "NC"  #Change "NC" to a number in seconds for the time
$Script:DisableVariousTasks = 0     #0-Skip, 1-Enable, 2-Disable some scheduled tasks... This is Experimental
#to see the scheduled tasks search for $TasksList (near top of script)
# --------------------------------------------------------------------------
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## !!                                            !!
## !!        DO NOT EDIT PAST THIS POINT         !!
## !!                                            !!
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
}
ScriptPreStart
