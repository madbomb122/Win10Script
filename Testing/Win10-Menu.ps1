##########
# Win 10 Setup Script/Tweaks with Menu(GUI)
#
# Original Basic Script By
#  Author: Disassembler0
# Website: https://GitHub.com/Disassembler0/Win10-Initial-Setup-Script/
# Version: 2.0, 2017-01-08 (Version Copied)
#
# Modded Script + Menu(GUI) By
#  Author: Madbomb122
# Website: https://GitHub.com/madbomb122/Win10Script/
#
$Script_Version = "3.0"
$Minor_Version = "4"
$Script_Date = "Aug-25-2017"
#$Release_Type = "Stable "
$Release_Type = "Testing"
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

<#------------------------------------------------------------------------------
The MIT License (MIT)

Copyright (c) 2017 Disassembler -Original Basic Version of Script
Copyright (c) 2017 Madbomb122 -Modded + Menu Version of Script

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

--------------------------------------------------------------------------------

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
  3. Run the script with one of these arguments/switches (space between multiple)

-- Basic Switches --
 Switches       Description of Switch
  -atos          (Accepts ToS)
  -auto          (Implies -Atos...Closes on - User Errors, or End of Script)
  -crp           (Creates Restore Point)
  -dnr           (Do Not Restart when done)
  
-- Run Script Switches --
 Switches       Description of Switch
  -run           (Runs script with settings in script)
  -run FILENME   (Runs script with settings in the file FILENME)
  -run wd        (Runs script with win default settings)

-- Load Script Switches --
 Switches       Description of Switch
  -load FILENME  (Loads script with settings in the file FILENME)
  -load wd       (Loads script with win default settings)

--Update Switches--
 Switches       Description of Switch
  -usc           (Checks for Update to Script file before running)
  -sic           (Skips Internet Check)
------------------------------------------------------------------------------#>
##########
# Pre-Script -Start
##########

If([Environment]::OSVersion.Version.Major -ne 10) {
    Clear-Host
    Write-Host "Sorry, this Script supports Windows 10 ONLY." -ForegroundColor "cyan" -BackgroundColor "black"
    If($Automated -ne 1){ Read-Host -Prompt "`nPress Any key to Close..." } ;Exit
}

If($Release_Type -eq "Stable "){ $ErrorActionPreference = 'silentlycontinue' }

$Global:PassedArg = $args
$Global:filebase = $PSScriptRoot + "\"
$TempFolder = $Env:Temp

If(!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PassedArg" -Verb RunAs ;Exit
}

$URL_Base = "https://raw.GitHubusercontent.com/madbomb122/Win10Script/master/"
$Script:BuildVer = [Environment]::OSVersion.Version.build
If([System.Environment]::Is64BitProcess){ $Script:OSType = 64 }

##########
# Pre-Script -End
##########
# Needed Variable -Start
##########

[Array]$Script:APPS_AppsUnhide = @()
[Array]$Script:APPS_AppsHide = @()
[Array]$Script:APPS_AppsUninstall = @()

$AppsList = @(
'Microsoft.3DBuilder',
'Microsoft.Microsoft3DViewer',
'Microsoft.BingWeather',
'Microsoft.CommsPhone',
'Microsoft.windowscommunicationsapps',
'Microsoft.Getstarted',
'Microsoft.Messaging',
'Microsoft.MicrosoftOfficeHub',
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
'Microsoft.ZuneVideo')

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
"yellow")       #15

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
'Xbox',
'Groove Music',
'Maps',
"Movies & TV",
'Microsoft Solitaire Collection',
'Get Office',
'Onenote')

Function MenuBlankLine { DisplayOutMenu "|                                                   |" 14 0 1 }
Function MenuLine { DisplayOutMenu "|---------------------------------------------------|" 14 0 1 }
Function LeftLine { DisplayOutMenu "| " 14 0 0 }
Function RightLine { DisplayOutMenu " |" 14 0 1 }

##########
# Needed Variable -End
##########
# Update Check -Start
##########

Function UpdateCheck {
    If(InternetCheck) {
        $VersionFile = $TempFolder + "\Temp.csv"
        $VersionURL = "https://raw.GitHubusercontent.com/madbomb122/Win10Script/master/Version/Version.csv"
        (New-Object System.Net.WebClient).DownloadFile($VersionURL, $VersionFile)
        $CSV_Ver = Import-Csv $VersionFile
        If($Release_Type -ne "Stable") {
            $WebScriptVer = $($CSV_Ver[0].Version)
            $WebScriptMinorVer = $($CSV_Ver[0].MinorVersion)
        } Else {
            $WebScriptVer = $($CSV_Ver[1].Version)
            $WebScriptMinorVer = $($CSV_Ver[1].MinorVersion)
        }
        If(($WebScriptVer -gt $Script_Version) -or ($WebScriptVer -eq $Script_Version -And $WebScriptMinorVer -gt $Minor_Version)) { ScriptUpdateFun }
    } Else {
        Clear-Host
        MenuLine
        LeftLine ;DisplayOutMenu "                      Error                      " 13 0 0 ;RightLine
        MenuLine
        MenuBlankLine
        LeftLine ;DisplayOutMenu "No internet connection dectected.                " 2 0 0 ;RightLine
        LeftLine ;DisplayOutMenu "Tested by pinging GitHub.com                     " 2 0 0 ;RightLine
        MenuBlankLine
        MenuLine
        Write-Host "`nPress Any key to Close...                      " -ForegroundColor White -BackgroundColor Black
        $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown,AllowCtrlC")
    }
}

Function ScriptUpdateFun {
    $FullVer = "$WebScriptVer.$WebScriptMinorVer"
    $UpdateFile = $filebase + "Update.bat"
    If(Test-Path $UpdateFile -PathType Leaf){
        $DFilename = "Win10-Menu.ps1"
        $UpdateOptBat = $True
        $UpArg = "-u -w10 "
        If($Release_Type -ne "Stable"){ $UpArg += "-test " }
    } Else {
        $DFilename = "Win10-Menu-Ver."
        $UpdateOptBat = $False
        $UpArg = ""
    }
    Clear-Host
    MenuLine
    LeftLine ;DisplayOutMenu "                  Update Found!                  " 13 0 0 ;RightLine
    MenuLine
    MenuBlankLine
    LeftLine ;DisplayOutMenu "Downloading version " 15 0 0 1 ;DisplayOutMenu ("$FullVer" + (" "*(29-$FullVer.Length))) 11 0 0 ;RightLine
    LeftLine ;DisplayOutMenu "Will run " 15 0 0 ;DisplayOutMenu ("$DFilename" +(" "*(40-$DFilename.Lengthh))) 11 0 0 ;RightLine
    LeftLine ;DisplayOutMenu "after download is complete.                       " 2 0 0 ;RightLine
    MenuBlankLine
    MenuLine

    If($Accept_ToS -ne 1){ $UpArg = $UpArg + "-atos" }
    If($InternetCheck -eq 1){ $UpArg = $UpArg + "-sic" }
    If($CreateRestorePoint -eq 1){ $UpArg = $UpArg + "-crp" }
    If($Restart -eq 0){ $UpArg = $UpArg + "-dnr" }
    If($RunScr){ $UpArg = $UpArg + "-run $TempSetting" } Else{ $UpArg = $UpArg + "-load $TempSetting" }
    If($UpdateOptBat){
        cmd.exe /c "$UpdateFile $UpArg"
    } Else {
        If($Release_Type -ne "Stable") {
            $DFilename += $WebScriptVer + "-Testing"
            $Script_Url = $URL_Base + "Testing/"
        } Else {
            $DFilename += $FullVer
        }
        $DFilename += ".ps1"
        $Script_Url = $URL_Base + "Win10-Menu.ps1"
        $WebScriptFilePath = $filebase + $DFilename
        (New-Object System.Net.WebClient).DownloadFile($Script_Url, $WebScriptFilePath)
        $TempSetting = $TempFolder + "\TempSet.csv"
        SaveSettingFiles $TempSetting 0
        If($BatUpdateScriptFileName -eq 1) {
            $BatFile = $filebase + "_Win10-Script.bat"
            If(Test-Path $BatFile -PathType Leaf){ 
                (Get-Content -LiteralPath $BatFile) | Foreach-Object {$_ -replace "Set Script_File=.*?$" , "Set Script_File=$DFilename"} | Set-Content -LiteralPath $BatFile -Force
                MenuBlankLineLog
                LeftLineLog ;DisplayOutMenu " Updated bat file with new script file name.     " 13 0 0 1 ;RightLineLog
                MenuBlankLineLog
                MenuLineLog
            }
        }
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$WebScriptFilePath`" $UpArg" -Verb RunAs
    }
    Exit
}

Function InternetCheck { If($InternetCheck -eq 1 -or (Test-Connection -Computer GitHub.com -Count 1 -Quiet)){ Return $True } Return $False }

##########
# Update Check -End
##########
# Multi Use Functions -Start
##########

Function cmpv { Compare-Object (Get-Variable -Scope Script) $AutomaticVariables -Property Name -PassThru | Where -Property Name -ne "AutomaticVariables" | Where-Object { $_ -NotIn $WPFList } }
Function Openwebsite([String]$Url){ [System.Diagnostics.Process]::Start($Url) }
Function ShowInvalid([Int]$InvalidA){ If($InvalidA -eq 1){ Write-Host "`nInvalid Input" -ForegroundColor Red -BackgroundColor Black -NoNewline } Return 0 }
Function unPin-App([String]$appname){ ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.Replace('&','') -Match 'Unpin from Start'} | %{$_.DoIt()} }
Function Check-SetPath([String]$RPath){ While(!(Test-Path "$RPath")){ New-Item -Path "$RPath" -Force | Out-Null } Return $RPath }
Function Remove-SetPath([String]$RPath){ If(Test-Path $RPath){ Remove-Item -Path $RPath -Recurse } }
Function DisplayOut([String]$TxtToDisplay, [Int]$TxtColor, [Int]$BGColor){ If($TxtColor -le 15){ Write-Host $TxtToDisplay -ForegroundColor $colors[$TxtColor] -BackgroundColor $colors[$BGColor] } Else{ Write-Host $TxtToDisplay } }
Function DisplayOutMenu([String]$TxtToDisplay, [Int]$TxtColor, [Int]$BGColor, [Int]$NewLine){ If($NewLine -eq 0){ Write-Host -NoNewline $TxtToDisplay -ForegroundColor $colors[$TxtColor] -BackgroundColor $colors[$BGColor] } Else{ Write-Host $TxtToDisplay -ForegroundColor $colors[$TxtColor] -BackgroundColor $colors[$BGColor] } }

Function ScriptPreStart {
    If($PassedArg.Lengthh -gt 0){ ArgCheck }
    If($AcceptToS -eq 1) {
        TOS
    } Else {
        StartOrGui
    }
}

Function StartOrGui {
    If($RunScr -eq $True) {
        PreStartScript
    } ElseIf($AcceptToS -ne 1) {
        Gui-Start
    }
}

Function ArgCheck {
    For($i=0; $i -lt $PassedArg.Lengthh; $i++) {
        If($PassedArg[$i].StartsWith("-")) {
            $ArgVal = $PassedArg[$i].ToLower()
            $PasVal = $PassedArg[($i+1)]
            Switch($ArgVal) {
                "-run" { If(Test-Path $PasVal -PathType Leaf) {
                            LoadSettingFile $PasVal ;$Script:RunScr = $True
                       } ElseIf($PasVal -eq "wd" -or $PasVal -eq "windefault") {
                            LoadWinDefault ;$Script:RunScr = $True
                       } ElseIf($PasVal.StartsWith("-")){ $Script:RunScr = $True} Break
                }
                "-load" { If(Test-Path $PasVal -PathType Leaf){ LoadSettingFile $PasVal } ElseIf($PasVal -eq "wd" -or $PasVal -eq "windefault"){ LoadWinDefault } ;Break }
                "-sic" { $Script:InternetCheck = 1 ;Break }
                "-usc" { $Script:VersionCheck  = 1 ;Break }
                "-atos" { $Script:AcceptToS = "Accepted-Switch" ;Break }
                "-dnr" { $Script:Restart = 0 ;Break }
                "-auto" { $Script:Automated = 1 ;$Script:AcceptToS = "Accepted-Automated-Switch" ;Break }
                "-crp" { $Script:CreateRestorePoint = 1 ;If(!($PasVal.StartsWith("-"))){ $Script:RestorePointName = $PasVal } ;Break }
            }
        }
    }
}

Function TOSDisplay {
    Clear-Host
    $BorderColor = 14
    If($Release_Type -eq "Testing" -or $Release_Type -eq "Beta   ") {
        $BorderColor = 15
        DisplayOutMenu "|---------------------------------------------------|" $BorderColor 0 1
        DisplayOutMenu "| " $BorderColor 0 0 ;DisplayOutMenu "                    WARNING!!                    " 13 0 0 ;DisplayOutMenu " |" $BorderColor 0 1
        DisplayOutMenu "|                                                   |" $BorderColor 0 1
        DisplayOutMenu "| " $BorderColor 0 0 ;DisplayOutMenu "    This version is currently being Tested.      " 14 0 0 ;DisplayOutMenu " |" $BorderColor 0 1
        DisplayOutMenu "|                                                   |" $BorderColor 0 1
    }
    DisplayOutMenu "|---------------------------------------------------|" $BorderColor 0 1
    DisplayOutMenu "| " $BorderColor 0 0 ;DisplayOutMenu "                  Terms of Use                   " 11 0 0 ;DisplayOutMenu " |" $BorderColor 0 1
    DisplayOutMenu "|---------------------------------------------------|" $BorderColor 0 1
    DisplayOutMenu "|                                                   |" $BorderColor 0 1
    DisplayOutMenu "| " $BorderColor 0 0 ;DisplayOutMenu "This program comes with ABSOLUTELY NO WARRANTY.  " 2 0 0 ;DisplayOutMenu " |" $BorderColor 0 1
    DisplayOutMenu "| " $BorderColor 0 0 ;DisplayOutMenu "This is free software, and you are welcome to    " 2 0 0 ;DisplayOutMenu " |" $BorderColor 0 1
    DisplayOutMenu "| " $BorderColor 0 0 ;DisplayOutMenu "redistribute it under certain conditions.        " 2 0 0 ;DisplayOutMenu " |" $BorderColor 0 1
    DisplayOutMenu "|                                                   |" $BorderColor 0 1
    DisplayOutMenu "| " $BorderColor 0 0 ;DisplayOutMenu "Read License file for full Terms.                " 2 0 0 ;DisplayOutMenu " |" $BorderColor 0 1
    DisplayOutMenu "|                                                   |" $BorderColor 0 1
    DisplayOutMenu "|---------------------------------------------------|" $BorderColor 0 1
}

Function TOS {
    While($TOS -ne "Out") {
        TOSDisplay
        $Invalid = ShowInvalid $Invalid
        $TOS = Read-Host "`nDo you Accept? (Y)es/(N)o"
        Switch($TOS.ToLower()) {
            {$_ -eq "n" -or $_ -eq "no"} { Exit ;Break }
            {$_ -eq "y" -or $_ -eq "yes"} { $Script:AcceptToS = "Accepted-Script" ;$TOS = "Out" ;StartOrGui ;Break }
            default {$Invalid = 1}
        }
    } Return
}

Function LoadSettingFile([String]$Filename) {
    Import-Csv $Filename -Delimiter ";" | %{ Set-Variable $_.Name $_.Value -Scope Script }
    [System.Collections.ArrayList]$APPS_AppsUnhide = $AppsUnhide.Split(",")
    [System.Collections.ArrayList]$APPS_AppsHidel = $AppsHide.Split(",")
    [System.Collections.ArrayList]$APPS_AppsUninstall = $AppsUninstall.Split(",")
}

Function SaveSettingFiles([String]$Filename) {
    ForEach($temp In $APPS_AppsUnhide){$Script:AppsUnhide+=$temp+","}
    ForEach($temp In $APPS_AppsHide){$Script:AppsHide+=$temp+","}
    ForEach($temp In $APPS_Uninstall){$Script:AppsUninstall+=$temp+","}
    If(Test-Path $Filename -PathType Leaf) {
        If($ShowConf -eq 1){ $Conf = ConfirmMenu 2 } Else{ $Conf = $True }
        If($Conf){ cmpv | Select-Object Name,Value | Export-Csv -LiteralPath $Filename -Encoding "unicode" -Force -Delimiter ";" }
    } Else {
        cmpv | Select-Object Name,Value | Export-Csv -LiteralPath $Filename -Encoding "unicode" -Force -Delimiter ";"
    }
}

##########
# Multi Use Functions -End
##########
# GUI -Start
##########

Function Update-Window {
    [cmdletBinding()]
    Param($Control, $Property, $Value, [Switch]$AppendContent)
    If($Property -eq "Close"){ $syncHash.Window.Dispatcher.invoke([action]{$syncHash.Window.Close()},"Normal") ;Return }
    $form.Dispatcher.Invoke([Action]{ If($PSBoundParameters['AppendContent']){ $Control.AppendText($Value) } Else{ $Control.$Property = $Value } }, "Normal")
}

Function SetCombo([String]$Name, [String]$Item) {
    $Items = $Item.Split(',')
    $combo =  $(Get-Variable -Name ("WPF_"+$Name+"_Combo") -ValueOnly)
    [void] $combo.Items.Add("Skip")
    ForEach($CmbItm In $Items){ [void] $combo.Items.Add($CmbItm) }
    SelectComboBoxGen $Name $(Get-Variable -Name $Name -ValueOnly)
}

Function SetComboM([String]$Name, [String]$Item) {
    $Items = $Item.Split(',')
    $combo =  $(Get-Variable -Name ("WPF_"+$Name+"_Combo") -ValueOnly)
    [void] $combo.Items.Add("Skip")
    ForEach($CmbItm In $Items){ [void] $combo.Items.Add($CmbItm) }
    If($Name -eq "AllMetro") {
        $WPF_AllMetro_Combo.SelectedIndex = 0
    } ElseIf($Name -eq "APP_SkypeApp") {
        $WPF_APP_SkypeApp_Combo.SelectedIndex = $APP_SkypeApp1
    } ElseIf($Name -eq "APP_WindowsFeedbak") {
        $WPF_APP_WindowsFeedbak_Combo.SelectedIndex = $APP_WindowsFeedbak1
    } ElseIf($Name -eq "APP_Zune") {
        $WPF_APP_Zune_Combo.SelectedIndex = $APP_ZuneMusic
    } Else {
        SelectComboBoxGen $Name $(Get-Variable -Name $Name -ValueOnly)
    }
}

Function RestorePointCBCheck {
    If($CreateRestorePoint -eq 1) {
        $WPF_CreateRestorePoint_CB.IsChecked = $True
        $WPF_RestorePointName_Txt.IsEnabled = $True
    } Else {
        $WPF_CreateRestorePoint_CB.IsChecked = $False
        $WPF_RestorePointName_Txt.IsEnabled = $False
    }
}

Function ConfigGUIitms {
    If($CreateRestorePoint -eq 1){ $WPF_CreateRestorePoint_CB.IsChecked = $True } Else{ $WPF_CreateRestorePoint_CB.IsChecked = $False }
    If($VersionCheck -eq 1){ $WPF_VersionCheck_CB.IsChecked = $True } Else{ $WPF_VersionCheck_CB.IsChecked = $False }
    If($InternetCheck -eq 1){ $WPF_InternetCheck_CB.IsChecked = $True } Else{ $WPF_InternetCheck_CB.IsChecked = $False }
    If($ShowSkipped -eq 1){ $WPF_ShowSkipped_CB.IsChecked = $True } Else{ $WPF_ShowSkipped_CB.IsChecked = $False }
    If($Restart -eq 1){ $WPF_Restart_CB.IsChecked = $True } Else{ $WPF_Restart_CB.IsChecked = $False }
    $WPF_RestorePointName_Txt.Text = $RestorePointName
    RestorePointCBCheck
}

Function SelectComboBox([Array]$List, [Int]$Metro) { 
    If($Metro -eq 1) {
        ForEach($Var In $List) {
            If($Var -eq "APP_SkypeApp") {
                $WPF_APP_SkypeApp_Combo.SelectedIndex = $APP_SkypeApp1
            } ElseIf($Var -eq "APP_WindowsFeedbak") {
                $WPF_APP_WindowsFeedbak_Combo.SelectedIndex = $APP_WindowsFeedbak1
            } ElseIf($Var -eq "APP_Zune") {
                $WPF_APP_Zune_Combo.SelectedIndex = $APP_ZuneMusic
            } Else {
                SelectComboBoxGen $Var $(Get-Variable -Name $Var -ValueOnly)
            }
        }
    } Else {
        ForEach($Var In $List){ SelectComboBoxGen $Var $Var.Value }
    }
}
Function SelectComboBoxAllMetro([Int]$Numb){ ForEach($Var In $ListApp){ SelectComboBoxGen $Var $Numb } }
Function SelectComboBoxGen([String]$Name, [Int]$Numb){ $(Get-Variable -Name ("WPF_"+$Name+"_Combo") -ValueOnly).SelectedIndex = $Numb }

Function AppAraySet([String]$Get) {
    [System.Collections.ArrayList]$ListTMP = Get-Variable -Name $Get
    [System.Collections.ArrayList]$List = @()
    If($Get -eq "WPF_*_Combo"){
        ForEach($Var In $ListTMP){ If(!($Var.Name -like "WPF_APP_*")){ $List += $Var.Name.Split('_')[1] } }
        $List.Remove("AllMetro")
    } Else {
        ForEach($Var In $ListTMP){ $List += $Var.Name }
        $List.Remove("APP_SkypeApp1")
        $List.Remove("APP_SkypeApp2")
        $List.Remove("APP_WindowsFeedbak1")
        $List.Remove("APP_WindowsFeedbak2")
        $List.Remove("APP_ZuneMusic")
        $List.Remove("APP_ZuneVideo")
        $List.Add("APP_SkypeApp") | Out-Null
        $List.Add("APP_WindowsFeedbak") | Out-Null
        $List.Add("APP_Zune") | Out-Null
    } Return $List
}

Function OpenSaveDiaglog([Int]$SorO) {
    If($SorO -eq 0){ $SOFileDialog = New-Object System.Windows.Forms.OpenFileDialog } Else{ $SOFileDialog = New-Object System.Windows.Forms.SaveFileDialog }
    $SOFileDialog.InitialDirectory = $filebase
    $SOFileDialog.Filter = "CSV (*.csv)| *.csv"
    $SOFileDialog.ShowDialog() | Out-Null
    If($SorO -eq 0){ LoadSettingFile $SOFileDialog.Filename ;ConfigGUIitms ;SelectComboBox $VarList ;SelectComboBox $ListApp 1 } Else{ GuiItmToVariable ;SaveSettingFiles $SOFileDialog.Filename }
}

Function Gui-Start {
    Clear-Host
    DisplayOutMenu "Preparing GUI, Please wait..." 15 0 1 0

[xml]$XAML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
 Title="Windows 10 Settings/Tweaks Script By: Madbomb122" Height="384" Width="545" ResizeMode="NoResize" BorderBrush="Black" Background="White" WindowStyle="ThreeDBorderWindow">
<Window.Effect><DropShadowEffect/></Window.Effect><Grid>
 <Label Content="Script Version:" HorizontalAlignment="Left" Margin="1,317,0,0" VerticalAlignment="Top" Height="25"/>
 <Button Name="RunScriptButton" Content="Run Script" HorizontalAlignment="Left" Margin="0,300,0,0" VerticalAlignment="Top" Width="525" Height="20" FontWeight="Bold"/>
 <Button Name="CopyrightButton" Content="Copyright" HorizontalAlignment="Left" Margin="394,321,0,0" VerticalAlignment="Top" Width="131" FontStyle="Italic"/>
 <Button Name="Madbomb122WSButton" Content="Madbomb122's Website" HorizontalAlignment="Left" Margin="262,321,0,0" VerticalAlignment="Top" Width="132" FontStyle="Italic"/>
 <Button Name="DonateButton" Content="Donate to me" HorizontalAlignment="Left" Margin="0,321,0,0" VerticalAlignment="Top" Width="131" FontStyle="Italic"/>
 <Button Name="EMail" Content="e-mail Madbomb122" HorizontalAlignment="Left" Margin="131,321,0,0" VerticalAlignment="Top" Width="131" FontStyle="Italic"/>
 <TabControl Name="TabControl" Height="300" VerticalAlignment="Top">
  <TabItem Name="Services_Tab" Header="Script Options" Margin="-2,0,2,0"><Grid Background="#FFE5E5E5">
   <CheckBox Name="CreateRestorePoint_CB" Content="Create Restore Point:" HorizontalAlignment="Left" Margin="8,10,0,0" VerticalAlignment="Top"/>
   <TextBox Name="RestorePointName_Txt" HorizontalAlignment="Left" Height="20" Margin="139,9,0,0" TextWrapping="Wrap" Text="Win10 Initial Setup Script" VerticalAlignment="Top" Width="188"/>
   <CheckBox Name="ShowSkipped_CB" Content="Show Skipped Items" HorizontalAlignment="Left" Margin="8,29,0,0" VerticalAlignment="Top"/>
   <CheckBox Name="Restart_CB" Content="Restart When Done" HorizontalAlignment="Left" Margin="8,49,0,0" VerticalAlignment="Top"/>
   <CheckBox Name="VersionCheck_CB" Content="Check for Update (If update found, will run and use current settings)" HorizontalAlignment="Left" Margin="8,69,0,0" VerticalAlignment="Top"/>
   <CheckBox Name="BatUpdateScriptFileName_CB" Content="Update Bat file with new Script filename (If update.bat isnt avilable)" HorizontalAlignment="Left" Margin="8,89,0,0" VerticalAlignment="Top" Height="15" Width="380"/>
   <CheckBox Name="InternetCheck_CB" Content="Skip Internet Check" HorizontalAlignment="Left" Margin="8,109,0,0" VerticalAlignment="Top"/>
   <Button Name="Save_Setting_Button" Content="Save Settings" HorizontalAlignment="Left" Margin="100,133,0,0" VerticalAlignment="Top" Width="77"/>
   <Button Name="Load_Setting_Button" Content="Load Settings" HorizontalAlignment="Left" Margin="8,133,0,0" VerticalAlignment="Top" Width="77"/>
   <Button Name="WinDefault_Button" Content="Windows Default*" HorizontalAlignment="Left" Margin="192,133,0,0" VerticalAlignment="Top" Width="100"/>
   <Button Name="ResetDefault_Button" Content="Reset All Items" HorizontalAlignment="Left" Margin="306,133,0,0" VerticalAlignment="Top" Width="85"/>
   <Label Content="Notes:&#xD;&#xA;Options with items marked with * means &quot;Windows Default&quot;&#xA;Windows Default Button does not change Metro Apps or OneDrive Install" HorizontalAlignment="Left" Margin="8,160,0,0" VerticalAlignment="Top" FontStyle="Italic"/>
   <Label Content="Script Version:" HorizontalAlignment="Left" Margin="8,218,0,0" VerticalAlignment="Top" Height="25"/>
   <TextBox Name="Script_Ver_Txt" HorizontalAlignment="Left" Height="20" Margin="90,222,0,0" TextWrapping="Wrap" Text="2.8.0 (6-21-2017)" VerticalAlignment="Top" Width="124" IsEnabled="False"/>
   <TextBox Name="Release_Type_Txt" HorizontalAlignment="Left" Height="20" Margin="214,222,0,0" TextWrapping="Wrap" Text="Testing" VerticalAlignment="Top" Width="50" IsEnabled="False"/></Grid>
  </TabItem>
  <TabItem Name="Privacy_tab" Header="Privacy" Margin="-2,0,2,0"><Grid Background="#FFE5E5E5">
   <Label Content="Telemetry:" HorizontalAlignment="Left" Margin="67,10,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="Telemetry_Combo" HorizontalAlignment="Left" Margin="128,13,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Wi-Fi Sense:" HorizontalAlignment="Left" Margin="57,37,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="WiFiSense_Combo" HorizontalAlignment="Left" Margin="128,40,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="SmartScreen Filter:" HorizontalAlignment="Left" Margin="21,64,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="SmartScreen_Combo" HorizontalAlignment="Left" Margin="127,67,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Location Tracking:" HorizontalAlignment="Left" Margin="25,91,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="LocationTracking_Combo" HorizontalAlignment="Left" Margin="127,94,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Feedback:" HorizontalAlignment="Left" Margin="67,118,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="Feedback_Combo" HorizontalAlignment="Left" Margin="127,121,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Advertising ID:" HorizontalAlignment="Left" Margin="43,145,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="AdvertisingID_Combo" HorizontalAlignment="Left" Margin="127,148,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Cortana:" HorizontalAlignment="Left" Margin="341,10,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="Cortana_Combo" HorizontalAlignment="Left" Margin="392,13,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Cortana Search:" HorizontalAlignment="Left" Margin="302,37,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="CortanaSearch_Combo" HorizontalAlignment="Left" Margin="392,40,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Error Reporting:" HorizontalAlignment="Left" Margin="301,64,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="ErrorReporting_Combo" HorizontalAlignment="Left" Margin="392,67,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="AutoLogger:" HorizontalAlignment="Left" Margin="320,91,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="AutoLoggerFile_Combo" HorizontalAlignment="Left" Margin="392,94,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Diagnostics Tracking:" HorizontalAlignment="Left" Margin="274,118,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="DiagTrack_Combo" HorizontalAlignment="Left" Margin="392,121,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="WAP Push:" HorizontalAlignment="Left" Margin="329,145,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="WAPPush_Combo" HorizontalAlignment="Left" Margin="392,148,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="App Auto Download:" HorizontalAlignment="Left" Margin="274,172,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="AppAutoDownload_Combo" HorizontalAlignment="Left" Margin="392,175,0,0" VerticalAlignment="Top" Width="72"/></Grid>
  </TabItem>
  <TabItem Name="SrvTweak_Tab" Header="Service Tweaks" Margin="-2,0,2,0"><Grid Background="#FFE5E5E5">
   <Label Content="UAC Level:" HorizontalAlignment="Left" Margin="79,10,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="UAC_Combo" HorizontalAlignment="Left" Margin="142,13,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Sharing mapped drives:" HorizontalAlignment="Left" Margin="10,37,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="SharingMappedDrives_Combo" HorizontalAlignment="Left" Margin="142,40,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Administrative Shares:" HorizontalAlignment="Left" Margin="18,64,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="AdminShares_Combo" HorizontalAlignment="Left" Margin="142,67,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Firewall:" HorizontalAlignment="Left" Margin="93,91,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="Firewall_Combo" HorizontalAlignment="Left" Margin="142,94,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Windows Defender:" HorizontalAlignment="Left" Margin="31,118,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="WinDefender_Combo" HorizontalAlignment="Left" Margin="142,121,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="HomeGroups:" HorizontalAlignment="Left" Margin="62,145,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="HomeGroups_Combo" HorizontalAlignment="Left" Margin="142,148,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Remote Assistance:" HorizontalAlignment="Left" Margin="34,172,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="RemoteAssistance_Combo" HorizontalAlignment="Left" Margin="142,175,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Remote Desktop w/o &#xD;&#xA;Network Authentication:" HorizontalAlignment="Left" Margin="7,196,0,0" VerticalAlignment="Top" Width="138" Height="39"/>
   <ComboBox Name="RemoteDesktop_Combo" HorizontalAlignment="Left" Margin="142,205,0,0" VerticalAlignment="Top" Width="72"/></Grid>
  </TabItem>
  <TabItem Name="Context_Tab" Header="Context Menu/Start Menu" Margin="-2,0,2,0"><Grid Background="#FFE5E5E5">
   <Label Content="Cast to Device:" HorizontalAlignment="Left" Margin="43,31,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="CastToDevice_Combo" HorizontalAlignment="Left" Margin="128,34,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Previous Versions:" HorizontalAlignment="Left" Margin="26,58,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="PreviousVersions_Combo" HorizontalAlignment="Left" Margin="128,61,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Include in Library:" HorizontalAlignment="Left" Margin="28,84,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="IncludeinLibrary_Combo" HorizontalAlignment="Left" Margin="128,88,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Pin To Start:" HorizontalAlignment="Left" Margin="59,112,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="PinToStart_Combo" HorizontalAlignment="Left" Margin="128,115,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Pin To Quick Access:" HorizontalAlignment="Left" Margin="14,139,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="PinToQuickAccess_Combo" HorizontalAlignment="Left" Margin="128,142,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Share With:" HorizontalAlignment="Left" Margin="60,166,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="ShareWith_Combo" HorizontalAlignment="Left" Margin="128,169,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Send To:" HorizontalAlignment="Left" Margin="76,193,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="SendTo_Combo" HorizontalAlignment="Left" Margin="128,196,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Bing Search in Start Menu:" HorizontalAlignment="Left" Margin="293,31,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="StartMenuWebSearch_Combo" HorizontalAlignment="Left" Margin="439,34,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Start Suggestions:" HorizontalAlignment="Left" Margin="337,85,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="StartSuggestions_Combo" HorizontalAlignment="Left" Margin="439,88,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Most Used Apps:" HorizontalAlignment="Left" Margin="342,112,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="MostUsedAppStartMenu_Combo" HorizontalAlignment="Left" Margin="439,115,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Recent Items &amp; Frequent Places:" HorizontalAlignment="Left" Margin="262,58,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="RecentItemsFrequent_Combo" HorizontalAlignment="Left" Margin="439,61,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Unpin Items:" HorizontalAlignment="Left" Margin="365,139,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="UnpinItems_Combo" HorizontalAlignment="Left" Margin="439,142,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Unpin List:  Calendar, Candy Crush Soda Saga, &#xD;&#xA;Cortana, Get Office, Groove Music, Mail, Maps, &#xD;&#xA;Edge, Microsoft Solitaire, Movies &amp; TV, &#xD;&#xA;OneNote, Phone Companion, Photos, Skype, &#xD;&#xA;Store, Twitter, Weather, Xbox" HorizontalAlignment="Left" Margin="259,161,0,0" VerticalAlignment="Top"/>
   <Rectangle Fill="#FFFFFFFF" HorizontalAlignment="Left" Height="253" Margin="254,0,0,0" Stroke="Black" VerticalAlignment="Top" Width="1"/>
   <Label Content="Context Menu" HorizontalAlignment="Left" Margin="82,4,0,0" VerticalAlignment="Top" FontWeight="Bold"/>
   <Label Content="Start Menu" HorizontalAlignment="Left" Margin="352,4,0,0" VerticalAlignment="Top" FontWeight="Bold"/></Grid>
  </TabItem>
  <TabItem Name="TaskBar_Tab" Header="Task Bar" Margin="-3,0,2,0"><Grid Background="#FFE5E5E5">
   <Label Content="Battery UI Bar:" HorizontalAlignment="Left" Margin="61,10,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="BatteryUIBar_Combo" HorizontalAlignment="Left" Margin="143,13,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Clock UI Bar:" HorizontalAlignment="Left" Margin="69,37,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="ClockUIBar_Combo" HorizontalAlignment="Left" Margin="143,40,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Volume Control Bar:" HorizontalAlignment="Left" Margin="277,118,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="VolumeControlBar_Combo" HorizontalAlignment="Left" Margin="390,121,0,0" VerticalAlignment="Top" Width="120"/>
   <Label Content="Taskbar Search box:" HorizontalAlignment="Left" Margin="33,64,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="TaskbarSearchBox_Combo" HorizontalAlignment="Left" Margin="143,67,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Task View button:" HorizontalAlignment="Left" Margin="44,91,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="TaskViewButton_Combo" HorizontalAlignment="Left" Margin="143,94,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Taskbar Icon Size:" HorizontalAlignment="Left" Margin="291,37,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="TaskbarIconSize_Combo" HorizontalAlignment="Left" Margin="390,40,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Taskbar Item Grouping:" HorizontalAlignment="Left" Margin="260,64,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="TaskbarGrouping_Combo" HorizontalAlignment="Left" Margin="390,67,0,0" VerticalAlignment="Top" Width="90"/>
   <Label Content="Tray Icons:" HorizontalAlignment="Left" Margin="328,10,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="TrayIcons_Combo" HorizontalAlignment="Left" Margin="390,13,0,0" VerticalAlignment="Top" Width="97"/>
   <Label Content="Seconds In Clock:" HorizontalAlignment="Left" Margin="44,118,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="SecondsInClock_Combo" HorizontalAlignment="Left" Margin="143,121,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Last Active Click:" HorizontalAlignment="Left" Margin="49,145,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="LastActiveClick_Combo" HorizontalAlignment="Left" Margin="143,148,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Taskbar on Multi Display:" HorizontalAlignment="Left" Margin="252,91,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="TaskBarOnMultiDisplay_Combo" HorizontalAlignment="Left" Margin="390,94,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Taskbar Button on Multi Display:" HorizontalAlignment="Left" Margin="13,172,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="TaskbarButtOnDisplay_Combo" HorizontalAlignment="Left" Margin="190,175,0,0" VerticalAlignment="Top" Width="197"/></Grid>
  </TabItem>
  <TabItem Name="Explorer_Tab" Header="Explorer" Margin="-2,0,2,0"><Grid Background="#FFE5E5E5">
   <Label Content="Process ID on Title Bar:" HorizontalAlignment="Left" Margin="308,120,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="PidInTitleBar_Combo" HorizontalAlignment="Left" Margin="436,123,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Aero Snap:" HorizontalAlignment="Left" Margin="69,38,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="AeroSnap_Combo" HorizontalAlignment="Left" Margin="133,41,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Aero Shake:" HorizontalAlignment="Left" Margin="63,66,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="AeroShake_Combo" HorizontalAlignment="Left" Margin="133,69,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Known Extensions:" HorizontalAlignment="Left" Margin="331,147,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="KnownExtensions_Combo" HorizontalAlignment="Left" Margin="436,150,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Hidden Files:" HorizontalAlignment="Left" Margin="58,120,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="HiddenFiles_Combo" HorizontalAlignment="Left" Margin="133,123,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="System Files:" HorizontalAlignment="Left" Margin="59,147,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="SystemFiles_Combo" HorizontalAlignment="Left" Margin="133,150,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Default Explorer View:" HorizontalAlignment="Left" Margin="10,174,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="ExplorerOpenLoc_Combo" HorizontalAlignment="Left" Margin="133,177,0,0" VerticalAlignment="Top" Width="102"/>
   <Label Content="Recent Files in Quick Access:" HorizontalAlignment="Left" Margin="279,11,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="RecentFileQikAcc_Combo" HorizontalAlignment="Left" Margin="436,14,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Frequent folders in Quick_access:" HorizontalAlignment="Left" Margin="259,39,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="FrequentFoldersQikAcc_Combo" HorizontalAlignment="Left" Margin="436,41,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Window Content while Dragging:" HorizontalAlignment="Left" Margin="253,66,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="WinContentWhileDrag_Combo" HorizontalAlignment="Left" Margin="436,69,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Autoplay:" HorizontalAlignment="Left" Margin="76,11,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="Autoplay_Combo" HorizontalAlignment="Left" Margin="133,14,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Autorun:" HorizontalAlignment="Left" Margin="80,93,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="Autorun_Combo" HorizontalAlignment="Left" Margin="133,96,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Search Store for Unkn. Extensions:" HorizontalAlignment="Left" Margin="249,94,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="StoreOpenWith_Combo" HorizontalAlignment="Left" Margin="436,96,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Task Manager Details:" HorizontalAlignment="Left" Margin="315,175,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="TaskManagerDetails_Combo" HorizontalAlignment="Left" Margin="436,177,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Powershell to Cmd:" HorizontalAlignment="Left" Margin="24,203,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="WinXPowerShell_Combo" HorizontalAlignment="Left" Margin="133,206,0,0" VerticalAlignment="Top" Width="127"/></Grid>
  </TabItem>
  <TabItem Name="Desktop_Tab" Header="Desktop/This PC" Margin="-2,0,2,0"><Grid Background="#FFE5E5E5">
   <Label Content="This PC Icon:" HorizontalAlignment="Left" Margin="54,31,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="ThisPCOnDesktop_Combo" HorizontalAlignment="Left" Margin="128,34,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Network Icon:" HorizontalAlignment="Left" Margin="47,58,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="NetworkOnDesktop_Combo" HorizontalAlignment="Left" Margin="128,61,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Recycle Bin Icon:" HorizontalAlignment="Left" Margin="34,85,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="RecycleBinOnDesktop_Combo" HorizontalAlignment="Left" Margin="128,88,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Users File Icon:" HorizontalAlignment="Left" Margin="42,112,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="UsersFileOnDesktop_Combo" HorizontalAlignment="Left" Margin="128,115,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Control Panel Icon:" HorizontalAlignment="Left" Margin="21,139,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="ControlPanelOnDesktop_Combo" HorizontalAlignment="Left" Margin="128,142,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Desktop Folder:" HorizontalAlignment="Left" Margin="302,31,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="DesktopIconInThisPC_Combo" HorizontalAlignment="Left" Margin="392,34,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Documents Folder:" HorizontalAlignment="Left" Margin="285,58,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="DocumentsIconInThisPC_Combo" HorizontalAlignment="Left" Margin="392,61,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Downloads Folder:" HorizontalAlignment="Left" Margin="287,85,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="DownloadsIconInThisPC_Combo" HorizontalAlignment="Left" Margin="392,88,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Music Folder:" HorizontalAlignment="Left" Margin="315,112,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="MusicIconInThisPC_Combo" HorizontalAlignment="Left" Margin="392,115,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Pictures Folder:" HorizontalAlignment="Left" Margin="304,139,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="PicturesIconInThisPC_Combo" HorizontalAlignment="Left" Margin="392,142,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Videos Folder:" HorizontalAlignment="Left" Margin="310,166,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="VideosIconInThisPC_Combo" HorizontalAlignment="Left" Margin="392,169,0,0" VerticalAlignment="Top" Width="72"/>
   <Rectangle Fill="#FFFFFFFF" HorizontalAlignment="Left" Height="253" Margin="254,0,0,0" Stroke="Black" VerticalAlignment="Top" Width="1"/>
   <Label Content="Desktop" HorizontalAlignment="Left" Margin="99,4,0,0" VerticalAlignment="Top" FontWeight="Bold"/>
   <Label Content="This PC" HorizontalAlignment="Left" Margin="364,4,0,0" VerticalAlignment="Top" FontWeight="Bold"/></Grid>
  </TabItem>
  <TabItem Name="Misc_Tab" Header="Misc/Photo Viewer/LockScreen" Margin="-2,0,2,0"><Grid Background="#FFE5E5E5">
   <Label Content="Action Center:" HorizontalAlignment="Left" Margin="46,31,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="ActionCenter_Combo" HorizontalAlignment="Left" Margin="128,34,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Sticky Key Prompt:" HorizontalAlignment="Left" Margin="23,58,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="StickyKeyPrompt_Combo" HorizontalAlignment="Left" Margin="128,61,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Num Lock on Startup:" HorizontalAlignment="Left" Margin="6,85,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="NumblockOnStart_Combo" HorizontalAlignment="Left" Margin="128,88,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="F8 Boot Menu:" HorizontalAlignment="Left" Margin="44,112,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="F8BootMenu_Combo" HorizontalAlignment="Left" Margin="128,115,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Remote UAC Local &#xD;&#xA;Account Token Filter:" HorizontalAlignment="Left" Margin="11,187,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="RemoteUACAcctToken_Combo" HorizontalAlignment="Left" Margin="128,197,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Hibernate Option:" HorizontalAlignment="Left" Margin="26,139,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="HibernatePower_Combo" HorizontalAlignment="Left" Margin="128,142,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Sleep Option:" HorizontalAlignment="Left" Margin="49,166,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="SleepPower_Combo" HorizontalAlignment="Left" Margin="128,169,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="File Association:" HorizontalAlignment="Left" Margin="301,31,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="PVFileAssociation_Combo" HorizontalAlignment="Left" Margin="392,34,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Add &quot;Open with...&quot;:" HorizontalAlignment="Left" Margin="285,58,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="PVOpenWithMenu_Combo" HorizontalAlignment="Left" Margin="392,61,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Lockscreen:" HorizontalAlignment="Left" Margin="323,139,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="LockScreen_Combo" HorizontalAlignment="Left" Margin="392,142,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Power Menu:" HorizontalAlignment="Left" Margin="316,166,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="PowerMenuLockScreen_Combo" HorizontalAlignment="Left" Margin="392,169,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Camera:" HorizontalAlignment="Left" Margin="342,193,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="CameraOnLockscreen_Combo" HorizontalAlignment="Left" Margin="392,196,0,0" VerticalAlignment="Top" Width="72"/>
   <Rectangle Fill="#FFFFFFFF" HorizontalAlignment="Left" Height="1" Margin="254,106,0,0" Stroke="Black" VerticalAlignment="Top" Width="268"/>
   <Rectangle Fill="#FFFFFFFF" HorizontalAlignment="Left" Height="253" Margin="254,0,0,0" Stroke="Black" VerticalAlignment="Top" Width="1"/>
   <Label Content="Lockscreen" HorizontalAlignment="Left" Margin="352,111,0,0" VerticalAlignment="Top" FontWeight="Bold"/>
   <Label Content="Misc" HorizontalAlignment="Left" Margin="109,4,0,0" VerticalAlignment="Top" FontWeight="Bold"/>
   <Label Content="Photo Viewer" HorizontalAlignment="Left" Margin="346,4,0,0" VerticalAlignment="Top" FontWeight="Bold"/></Grid>
  </TabItem>
  <TabItem Name="MetroApp_Tab" Header="Metro App" Margin="-2,0,2,0"><Grid Background="#FFE5E5E5">
   <Label Content="Set All Metro Apps:" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="72,2,0,0"/>
   <Rectangle Fill="#FFFFFFFF" Height="1" Margin="0,29,0,0" Stroke="Black" VerticalAlignment="Top" HorizontalAlignment="Left" Width="347"/>
   <ComboBox Name="AllMetro_Combo" HorizontalAlignment="Left" Margin="181,4,0,0" VerticalAlignment="Top" Width="74"/>
   <Label Content="3DBuilder:" HorizontalAlignment="Left" Margin="32,32,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="APP_3DBuilder_Combo" HorizontalAlignment="Left" Margin="94,35,0,0" VerticalAlignment="Top" Width="74"/>
   <Label Content="3DViewer:" HorizontalAlignment="Left" Margin="34,56,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="APP_3DViewer_Combo" HorizontalAlignment="Left" Margin="94,59,0,0" VerticalAlignment="Top" Width="74"/>
   <Label Content="Bing Weather:" HorizontalAlignment="Left" Margin="12,80,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="APP_BingWeather_Combo" HorizontalAlignment="Left" Margin="94,83,0,0" VerticalAlignment="Top" Width="74"/>
   <Label Content="Phone App:" HorizontalAlignment="Left" Margin="26,104,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="APP_CommsPhone_Combo" HorizontalAlignment="Left" Margin="94,107,0,0" VerticalAlignment="Top" Width="74"/>
   <Label Content="Calendar &amp; Mail:" HorizontalAlignment="Left" Margin="-1,128,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="APP_Communications_Combo" HorizontalAlignment="Left" Margin="94,131,0,0" VerticalAlignment="Top" Width="74"/>
   <Label Content="Getting Started:" HorizontalAlignment="Left" Margin="4,152,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="APP_Getstarted_Combo" HorizontalAlignment="Left" Margin="94,155,0,0" VerticalAlignment="Top" Width="74"/>
   <Label Content="Messaging App:" HorizontalAlignment="Left" Margin="2,176,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="APP_Messaging_Combo" HorizontalAlignment="Left" Margin="94,179,0,0" VerticalAlignment="Top" Width="74"/>
   <Label Content="Get Office:" HorizontalAlignment="Left" Margin="31,203,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="APP_MicrosoftOffHub_Combo" HorizontalAlignment="Left" Margin="94,203,0,0" VerticalAlignment="Top" Width="74"/>
   <Label Content="Movie Moments:" HorizontalAlignment="Left" Margin="-2,224,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="APP_MovieMoments_Combo" HorizontalAlignment="Left" Margin="94,227,0,0" VerticalAlignment="Top" Width="74"/>
   <Label Content="Netflix:" HorizontalAlignment="Left" Margin="225,32,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="APP_Netflix_Combo" HorizontalAlignment="Left" Margin="269,35,0,0" VerticalAlignment="Top" Width="74"/>
   <Label Content="Office OneNote:" HorizontalAlignment="Left" Margin="173,56,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="APP_OfficeOneNote_Combo" HorizontalAlignment="Left" Margin="269,59,0,0" VerticalAlignment="Top" Width="74"/>
   <Label Content="Office Sway:" HorizontalAlignment="Left" Margin="198,80,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="APP_OfficeSway_Combo" HorizontalAlignment="Left" Margin="269,83,0,0" VerticalAlignment="Top" Width="74"/>
   <Label Content="One Connect:" HorizontalAlignment="Left" Margin="190,104,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="APP_OneConnect_Combo" HorizontalAlignment="Left" Margin="269,107,0,0" VerticalAlignment="Top" Width="74"/>
   <Label Content="People:" HorizontalAlignment="Left" Margin="224,128,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="APP_People_Combo" HorizontalAlignment="Left" Margin="269,131,0,0" VerticalAlignment="Top" Width="74"/>
   <Label Content="Photos App:" HorizontalAlignment="Left" Margin="198,152,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="APP_Photos_Combo" HorizontalAlignment="Left" Margin="269,155,0,0" VerticalAlignment="Top" Width="74"/>
   <Label Content="Skype:" HorizontalAlignment="Left" Margin="227,176,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="APP_SkypeApp_Combo" HorizontalAlignment="Left" Margin="269,179,0,0" VerticalAlignment="Top" Width="74"/>
   <Label Content="Solitaire Collect:" HorizontalAlignment="Left" Margin="177,200,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="APP_SolitaireCollect_Combo" HorizontalAlignment="Left" Margin="269,203,0,0" VerticalAlignment="Top" Width="74"/>
   <Label Content="Sticky Notes:" HorizontalAlignment="Left" Margin="194,224,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="APP_StickyNotes_Combo" HorizontalAlignment="Left" Margin="269,227,0,0" VerticalAlignment="Top" Width="74"/>
   <Label Content="Voice Recorder:" HorizontalAlignment="Left" Margin="353,32,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="APP_VoiceRecorder_Combo" HorizontalAlignment="Left" Margin="442,35,0,0" VerticalAlignment="Top" Width="74"/>
   <Label Content="Alarms &amp; Clock:" HorizontalAlignment="Left" Margin="354,56,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="APP_WindowsAlarms_Combo" HorizontalAlignment="Left" Margin="442,59,0,0" VerticalAlignment="Top" Width="74"/>
   <Label Content="Calculator:" HorizontalAlignment="Left" Margin="379,80,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="APP_WindowsCalculator_Combo" HorizontalAlignment="Left" Margin="442,83,0,0" VerticalAlignment="Top" Width="74"/>
   <Label Content="Camera:" HorizontalAlignment="Left" Margin="392,104,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="APP_WindowsCamera_Combo" HorizontalAlignment="Left" Margin="442,107,0,0" VerticalAlignment="Top" Width="74"/>
   <Label Content="Win. Feedback:" HorizontalAlignment="Left" Margin="355,128,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="APP_WindowsFeedbak_Combo" HorizontalAlignment="Left" Margin="442,131,0,0" VerticalAlignment="Top" Width="74"/>
   <Label Content="Windows Maps:" HorizontalAlignment="Left" Margin="351,152,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="APP_WindowsMaps_Combo" HorizontalAlignment="Left" Margin="442,155,0,0" VerticalAlignment="Top" Width="74"/>
   <Label Content="Phone Comp.:" HorizontalAlignment="Left" Margin="361,176,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="APP_WindowsPhone_Combo" HorizontalAlignment="Left" Margin="442,179,0,0" VerticalAlignment="Top" Width="74"/>
   <Label Content="Xbox App:" HorizontalAlignment="Left" Margin="381,200,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="APP_XboxApp_Combo" HorizontalAlignment="Left" Margin="442,203,0,0" VerticalAlignment="Top" Width="74"/>
   <Label Content="Groove:" HorizontalAlignment="Left" Margin="394,224,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="APP_Zune_Combo" HorizontalAlignment="Left" Margin="442,227,0,0" VerticalAlignment="Top" Width="74"/>
   <Label Content="Windows Store:" HorizontalAlignment="Left" Margin="353,8,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="APP_WindowsStore_Combo" HorizontalAlignment="Left" Margin="442,11,0,0" VerticalAlignment="Top" Width="74"/>
   <Rectangle Fill="#FFFFFFFF" HorizontalAlignment="Left" Height="224" Margin="171,29,0,-1" Stroke="Black" VerticalAlignment="Top" Width="1"/>
   <Rectangle Fill="#FFFFFFFF" HorizontalAlignment="Left" Height="253" Margin="346,0,0,-1" Stroke="Black" VerticalAlignment="Top" Width="1"/></Grid>
  </TabItem>
  <TabItem Name="Application_Tab" Header="Application/Windows Update" Margin="-2,0,2,0"><Grid Background="#FFE5E5E5">
   <Label Content="OneDrive:" HorizontalAlignment="Left" Margin="69,31,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="OneDrive_Combo" HorizontalAlignment="Left" Margin="128,34,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="OneDrive Install:" HorizontalAlignment="Left" Margin="34,58,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="OneDriveInstall_Combo" HorizontalAlignment="Left" Margin="128,61,0,0" VerticalAlignment="Top" Width="78"/>
   <Label Content="Xbox DVR:" HorizontalAlignment="Left" Margin="66,85,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="XboxDVR_Combo" HorizontalAlignment="Left" Margin="128,88,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="MediaPlayer:" HorizontalAlignment="Left" Margin="53,112,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="MediaPlayer_Combo" HorizontalAlignment="Left" Margin="128,115,0,0" VerticalAlignment="Top" Width="78"/>
   <Label Content="Work Folders:" HorizontalAlignment="Left" Margin="49,139,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="WorkFolders_Combo" HorizontalAlignment="Left" Margin="128,142,0,0" VerticalAlignment="Top" Width="78"/>
   <Label Name="LinuxSubsystemTxt" Content="Linux Subsystem:" HorizontalAlignment="Left" Margin="31,166,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="LinuxSubsystem_Combo" HorizontalAlignment="Left" Margin="128,169,0,0" VerticalAlignment="Top" Width="78"/>
   <Label Content="Check for Update:" HorizontalAlignment="Left" Margin="290,31,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="CheckForWinUpdate_Combo" HorizontalAlignment="Left" Margin="392,34,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Update Check Type:" HorizontalAlignment="Left" Margin="280,58,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="WinUpdateType_Combo" HorizontalAlignment="Left" Margin="392,61,0,0" VerticalAlignment="Top" Width="115"/>
   <Label Content="Update P2P:" HorizontalAlignment="Left" Margin="320,85,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="WinUpdateDownload_Combo" HorizontalAlignment="Left" Margin="392,88,0,0" VerticalAlignment="Top" Width="83"/>
   <Label Content="Update MSRT:" HorizontalAlignment="Left" Margin="310,112,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="UpdateMSRT_Combo" HorizontalAlignment="Left" Margin="392,115,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Update Driver:" HorizontalAlignment="Left" Margin="309,139,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="UpdateDriver_Combo" HorizontalAlignment="Left" Margin="392,142,0,0" VerticalAlignment="Top" Width="72"/>
   <Label Content="Restart on Update:" HorizontalAlignment="Left" Margin="287,166,0,0" VerticalAlignment="Top"/>
   <ComboBox Name="RestartOnUpdate_Combo" HorizontalAlignment="Left" Margin="392,169,0,0" VerticalAlignment="Top" Width="72"/>
   <Rectangle Fill="#FFFFFFFF" HorizontalAlignment="Left" Height="253" Margin="254,0,0,0" Stroke="Black" VerticalAlignment="Top" Width="1"/>
   <Label Content="Application" HorizontalAlignment="Left" Margin="89,4,0,0" VerticalAlignment="Top" FontWeight="Bold"/>
   <Label Content="Windows Update" HorizontalAlignment="Left" Margin="336,4,0,0" VerticalAlignment="Top" FontWeight="Bold"/></Grid>
  </TabItem>
 </TabControl>
 <Rectangle Fill="#FFFFFFFF" Height="1" Margin="0,299,0,0" Stroke="Black" VerticalAlignment="Top"/>
 <Rectangle Fill="#FFFFFFFF" Height="1" Margin="0,320,0,0" Stroke="Black" VerticalAlignment="Top"/>
 <Rectangle Fill="#FFB6B6B6" Stroke="Black" Margin="0,341,0,0" Height="14" VerticalAlignment="Top"/>
 <Rectangle Fill="#FFB6B6B6" Stroke="Black" HorizontalAlignment="Left" Width="14" Margin="525,0,0,0"/></Grid>
</Window>
"@

    [void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
    $reader = (New-Object System.Xml.XmlNodeReader $xaml)
    $Form = [Windows.Markup.XamlReader]::Load( $reader )
    $xaml.SelectNodes("//*[@Name]") | %{Set-Variable -Name "WPF_$($_.Name)" -Value $Form.FindName($_.Name) -Scope Script }
    $WPFList = Get-Variable -Name "WPF_*"

    [System.Collections.ArrayList]$VarList = AppAraySet "WPF_*_Combo"
    [System.Collections.ArrayList]$ListApp = AppAraySet "APP_*"
    
    $Runspace = [runspacefactory]::CreateRunspace()
    $PowerShell = [PowerShell]::Create()
    $PowerShell.RunSpace = $Runspace
    $Runspace.Open()
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null

    $WPF_EMail.Add_Click({ OpenWebsite "mailto:madbomb122@gmail.com" })
    $WPF_DonateButton.Add_Click({ OpenWebsite "https://www.amazon.com/gp/registry/wishlist/YBAYWBJES5DE/" })
    $WPF_CreateRestorePoint_CB.Add_Checked({ $WPF_CreateRestorePoint_CB.IsChecked = $True ;$WPF_RestorePointName_Txt.IsEnabled = $True })
    $WPF_CreateRestorePoint_CB.Add_UnChecked({ $WPF_CreateRestorePoint_CB.IsChecked = $False ;$WPF_RestorePointName_Txt.IsEnabled = $False })
    $WPF_AllMetro_Combo.add_SelectionChanged({ SelectComboBoxAllMetro ($WPF_AllMetro_Combo.SelectedIndex) })
    $WPF_RunScriptButton.Add_Click({ Gui-Done })
    $WPF_Madbomb122WSButton.Add_Click({ OpenWebsite "https://GitHub.com/madbomb122/" })
    $WPF_WinDefault_Button.Add_Click({ LoadWinDefault ;SelectComboBox $VarList })
    $WPF_ResetDefault_Button.Add_Click({ SetDefault ;SelectComboBox $VarList ;SelectComboBox $ListApp 1 })
    $WPF_Load_Setting_Button.Add_Click({ OpenSaveDiaglog 0 })
    $WPF_Save_Setting_Button.Add_Click({ OpenSaveDiaglog 1 })
    $WPF_CopyrightButton.Add_Click({ [Windows.Forms.MessageBox]::Show($CopyrightItems,"Copyright", 'OK') })

    $CopyrightItems = 'Copyright (c) 1999-2017 Charles "Black Viper" Sparks - Services Configuration

The MIT License (MIT)

Copyright (c) 2017 Madbomb122 - Black Viper Service Configuration Script

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.'

$Skip_EnableD_Disable = @(
"Telemetry",
"WiFiSense",
"SmartScreen",
"LocationTracking",
"Feedback",
"AdvertisingID",
"Cortana",
"CortanaSearch",
"ErrorReporting",
"AutoLoggerFile",
"DiagTrack",
"WAPPush",
"CheckForWinUpdate",
"UpdateMSRT",
"UpdateDriver",
"RestartOnUpdate",
"AppAutoDownload",
"AdminShares",
"Firewall",
"WinDefender",
"HomeGroups",
"RemoteAssistance",
"CastToDevice",
"PreviousVersions",
"IncludeinLibrary",
"PinToStart",
"PinToQuickAccess",
"ShareWith",
"SendTo",
"OneDrive",
"XboxDVR",
"TaskBarOnMultiDisplay",
"StartMenuWebSearch",
"StartSuggestions",
"RecentItemsFrequent",
"Autoplay",
"Autorun",
"AeroSnap",
"AeroShake",
"StoreOpenWith",
"LockScreen",
"CameraOnLockScreen",
"ActionCenter",
"StickyKeyPrompt",
"SleepPower")

$Skip_Enable_DisableD = @(
"SharingMappedDrives",
"RemoteDesktop",
"LastActiveClick",
"NumblockOnStart",
"F8BootMenu",
"RemoteUACAcctToken",
"PVFileAssociation",
"PVOpenWithMenu")

$Skip_ShowD_Hide = @(
"TaskbarSearchBox",
"TaskViewButton",
"MostUsedAppStartMenu",
"FrequentFoldersQikAcc",
"WinContentWhileDrag",
"DesktopIconInThisPC",
"DocumentsIconInThisPC",
"DownloadsIconInThisPC",
"MusicIconInThisPC",
"PicturesIconInThisPC",
"VideosIconInThisPC",
"RecycleBinOnDesktop",
"PowerMenuLockScreen")

$Skip_Show_HideD = @(
"SecondsInClock",
"PidInTitleBar",
"KnownExtensions",
"HiddenFiles",
"SystemFiles",
"TaskManagerDetails",
"ThisPCOnDesktop",
"NetworkOnDesktop",
"UsersFileOnDesktop",
"ControlPanelOnDesktop")

$Skip_InstalledD_Uninstall = @("OneDriveInstall","MediaPlayer","WorkFolders")

    If($Release_Type -eq "Testing"){ $Script:Restart = 0 ;$WPF_Restart_CB.IsEnabled = $False ;$WPF_Restart_CB.Content += " (Disabled in Testing Version)" }
    If($BuildVer -lt 14393){ $WPF_LinuxSubsystem_Combo.Visibility = 'Hidden' ;$WPF_LinuxSubsystemTxt.Visibility = 'Hidden' }
    ForEach($Var In $Skip_EnableD_Disable){ SetCombo $Var "Enable*,Disable" }
    ForEach($Var In $Skip_Enable_DisableD){ SetCombo $Var "Enable,Disable*" }
    ForEach($Var In $Skip_ShowD_Hide){ SetCombo $Var "Show*,Hide" }
    ForEach($Var In $Skip_Show_HideD){ SetCombo $Var "Show,Hide*" }
    ForEach($Var In $Skip_InstalledD_Uninstall){ SetCombo $Var "Installed*,Uninstall" }
    
    SetComboM "AllMetro" "Unhide,Hide,Uninstall"
    ForEach($MetroApp In $ListApp){ SetComboM $MetroApp "Unhide,Hide,Uninstall" }

    SetCombo "LinuxSubsystem" "Installed,Uninstall*"
    SetCombo "HibernatePower" "Enable,Disable"
    SetCombo "UAC" "Lower,Normal*,Higher"
    SetCombo "BatteryUIBar" "New*,Classic"
    SetCombo "ClockUIBar" "New*,Classic"
    SetCombo "VolumeControlBar" "New(Horizontal)*,Classic(Vertical)"
    SetCombo "TaskbarIconSize" "Normal*,Smaller"
    SetCombo "TaskbarGrouping" "Never,Always*,When Needed"
    SetCombo "TrayIcons" "Auto*,Always Show"
    SetCombo "TaskBarButtOnDisplay" "All,Where Window is Open,Main & Where Window is Open"
    SetCombo "UnpinItems" "Unpin"
    SetCombo "ExplorerOpenLoc" "Quick Access*,ThisPC"
    SetCombo "RecentFileQikAcc" "Show/Add*,Hide,Remove"
    SetCombo "WinXPowerShell" "Powershell,Command Prompt"
    SetCombo "WinUpdateType" "Notify,Auto DL,Auto DL+Install*,Admin Config"
    SetCombo "WinUpdateDownload" "P2P*,Local Only,Disable"

    $WPF_Script_Ver_Txt.Text = "$Script_Version.$Minor_Version ($Script_Date)"
    $WPF_Release_Type_Txt.Text = $Release_Type

    ConfigGUIitms
    Clear-Host
    DisplayOutMenu "Displaying GUI Now" 14 0 1 0
    $TmpTitle = " (v.$Script_Version.$Minor_Version -$Script_Date"
    If($Release_Type -ne "Stable"){ $TmpTitle += " -$Release_Type)" } Else{ $TmpTitle += ")" }
    $Form.Title += $TmpTitle
    $Form.ShowDialog() | Out-Null
}

Function Gui-Done {
    GuiItmToVariable
    $Form.Close()
    $Script:RunScr = $True
    PreStartScript
}

Function GuiItmToVariable {
    ForEach($Var In $ListApp) {
        $Value = ($(Get-Variable -Name ("WPF_"+$Var+"_Combo") -ValueOnly).SelectedIndex)
        If($Var -eq "APP_SkypeApp") {
            Set-Variable -Name "APP_SkypeApp1" -Value $Value -Scope Script
            Set-Variable -Name "APP_SkypeApp2" -Value $Value -Scope Script
        } ElseIf($Var -eq "APP_WindowsFeedbak") {
            Set-Variable -Name "APP_WindowsFeedbak1" -Value $Value -Scope Script
            Set-Variable -Name "APP_WindowsFeedbak2" -Value $Value -Scope Script
        } ElseIf($Var -eq "APP_Zune") {
            Set-Variable -Name "APP_ZuneMusic" -Value $Value -Scope Script
            Set-Variable -Name "APP_ZuneVideo" -Value $Value -Scope Script
        } Else {
            Set-Variable -Name $Var -Value $Value -Scope Script
        }
    }
    ForEach($Var In $VarList){ Set-Variable -Name $Var -Value ($(Get-Variable -Name ("WPF_"+$Var+"_Combo") -ValueOnly).SelectedIndex) -Scope Script }
    If($WPF_CreateRestorePoint_CB.IsChecked){ $CreateRestorePoint = 1 } Else{ $CreateRestorePoint = 0 }
    If($WPF_VersionCheck_CB.IsChecked){ $VersionCheck = 1 } Else{ $VersionCheck = 0 }
    If($WPF_InternetCheck_CB.IsChecked){ $InternetCheck = 1 } Else{ $InternetCheck = 0 }
    If($WPF_ShowSkipped_CB.IsChecked){ $ShowSkipped = 1 } Else{ $ShowSkipped = 0 }
    If($WPF_Restart_CB.IsChecked){ $Restart = 1 } Else { $Restart = 0 }
    $RestorePointName = $WPF_RestorePointName_Txt.Text 
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
    $Script:CheckForWinUpdate = 1    
    $Script:WinUpdateType = 3
    $Script:WinUpdateDownload = 1    
    $Script:UpdateMSRT = 1
    $Script:UpdateDriver = 1
    $Script:RestartOnUpdate = 1
    $Script:AppAutoDownload = 1

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
    If($BuildVer -ge 15063){ $Script:WinXPowerShell = 1 } Else{ $Script:WinXPowerShell = 2 }
    $Script:TaskManagerDetails = 2

    #'This PC' Items
    $Script:DesktopIconInThisPC = 1
    $Script:DocumentsIconInThisPC = 1
    $Script:DownloadsIconInThisPC = 1
    $Script:MusicIconInThisPC = 1
    $Script:PicturesIconInThisPC = 1
    $Script:VideosIconInThisPC = 1

    #Desktop Items
    $Script:ThisPCOnDesktop = 2
    $Script:NetworkOnDesktop = 2
    $Script:RecycleBinOnDesktop = 1
    $Script:UsersFileOnDesktop = 2
    $Script:ControlPanelOnDesktop = 2

    #Lock Screen
    $Script:LockScreen = 1
    $Script:PowerMenuLockScreen = 1
    $Script:CameraOnLockScreen = 1

    #Misc items
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
    $Script:LinuxSubsystem = 2
}

##########
# Pre-Made Settings -End
##########
# Script -Start
##########

Function PreStartScript {
    If($VersionCheck -eq 1){ UpdateCheck }
    Clear-Host
    DisplayOut "------------------`n-   Pre-Script   -`n------------------" 14 0
    If($CreateRestorePoint -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Creation of System Restore Point..." 15 0
    } ElseIf($CreateRestorePoint -eq 1) {
        DisplayOut "Creating System Restore Point Named '$RestorePointName'" 11 1
        DisplayOut "Please Wait..." 11 1
        Checkpoint-Computer -Description $RestorePointName | Out-Null
    }
    Invoke-Expression RunScript
}


Function RunScript {
    If(!(Test-Path "HKCR:")){ New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null }
    If(!(Test-Path "HKU:")){ New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS | Out-Null }

    DisplayOut "`n------------------------`n-   Privacy Settings   -`n------------------------" 14 0
    If($Telemetry -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Telemetry..." 15 0
    } ElseIf($Telemetry -eq 1) {
        DisplayOut "Enabling Telemetry..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 3
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 3
        If($OSType -eq 64){ Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 3 }
    } ElseIf($Telemetry -eq 2) {
        DisplayOut "Disabling Telemetry..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
        If($OSType -eq 64){ Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0 }
    }

    If($WiFiSense -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Wi-Fi Sense..." 15 0
    } ElseIf($WiFiSense -eq 1) {
        DisplayOut "Enabling Wi-Fi Sense..." 11 0
        $Path = "SOFTWARE\Microsoft\PolicyManager\default\WiFi"
        Set-ItemProperty -Path "HKLM:\$Path\AllowWiFiHotSpotReporting" -Name "Value" -Type DWord -Value 1
        Set-ItemProperty -Path "HKLM:\$Path\AllowAutoConnectToWiFiSenseHotspots" -Name "Value" -Type DWord -Value 1
    } ElseIf($WiFiSense -eq 2) {
        DisplayOut "Disabling Wi-Fi Sense..." 12 0
        $Path1 = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\"
        $Path = Check-SetPath "$Path1\AllowWiFiHotSpotReporting"
        Set-ItemProperty -Path $Path -Name "Value" -Type DWord -Value 0
        $Path = Check-SetPath "$Path1\AllowAutoConnectToWiFiSenseHotspots"
        Set-ItemProperty -Path $Path -Name "Value" -Type DWord -Value 0
    }

    If($SmartScreen -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping SmartScreen Filter..." 15 0
    } ElseIf($SmartScreen -eq 1) {
        DisplayOut "Enabling SmartScreen Filter..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Type String -Value "RequireAdmin"
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" -Name "EnableWebContentEvaluation"
        If($BuildVer -ge 15063) {
            $AddPath = (Get-AppxPackage -AllUsers "Microsoft.MicrosoftEdge").PackageFamilyName
            $Path = "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\$AddPath\MicrosoftEdge\PhishingFilter"
            Remove-ItemProperty -Path $Path -Name "EnabledV9"
            Remove-ItemProperty -Path $Path -Name "PreventOverride"
        }
    } ElseIf($SmartScreen -eq 2) {
        DisplayOut "Disabling SmartScreen Filter..." 12 0
        $Path = "SOFTWARE\Microsoft\Windows\CurrentVersion"
        Set-ItemProperty -Path "HKLM:\$Path\Explorer" -Name "SmartScreenEnabled" -Type String -Value "Off"
        Set-ItemProperty -Path "HKCU:\$Path\AppHost" -Name "EnableWebContentEvaluation" -Type DWord -Value 0
        If($BuildVer -ge 15063) {
            $AddPath = (Get-AppxPackage -AllUsers "Microsoft.MicrosoftEdge").PackageFamilyName
            $Path = Check-SetPath "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\$AddPath\MicrosoftEdge\PhishingFilter"
            Set-ItemProperty -Path $Path -Name "EnabledV9" -Type DWord -Value 0
            Set-ItemProperty -Path $Path -Name "PreventOverride" -Type DWord -Value 0
        }
    }    

    If($LocationTracking -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Location Tracking..." 15 0
    } ElseIf($LocationTracking -eq 1) {
        DisplayOut "Enabling Location Tracking..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value 1
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Type DWord -Value 1
    } ElseIf($LocationTracking -eq 2) {
        DisplayOut "Disabling Location Tracking..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value 0
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Type DWord -Value 0
    }

    If($Feedback -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Feedback..." 15 0
    } ElseIf($Feedback -eq 1) {
        DisplayOut "Enabling Feedback..." 11 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod"
    } ElseIf($Feedback -eq 2) {
        DisplayOut "Disabling Feedback..." 12 0
        $Path = Check-SetPath "HKCU:\SOFTWARE\Microsoft\Siuf\Rules"
        Set-ItemProperty -Path $Path -Name "NumberOfSIUFInPeriod" -Type DWord -Value 0
    }

    If($AdvertisingID -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Advertising ID..." 15 0
    } ElseIf($AdvertisingID -eq 1) {
        DisplayOut "Enabling Advertising ID..." 11 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled"
    } ElseIf($AdvertisingID -eq 2) {
        DisplayOut "Disabling Advertising ID..." 12 0
        $Path = Check-SetPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
        Set-ItemProperty -Path $Path -Name "Enabled" -Type DWord -Value 0
    }

    If($Cortana -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Cortana..." 15 0
    } ElseIf($Cortana -eq 1) {
        DisplayOut "Enabling Cortana..." 11 0
        $Path = "HKCU:\SOFTWARE\Microsoft\InputPersonalization"
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy"
        Remove-ItemProperty -Path "$Path\TrainedDataStore" -Name "HarvestContacts"
        Set-ItemProperty -Path $Path -Name "RestrictImplicitTextCollection" -Type DWord -Value 0
        Set-ItemProperty -Path $Path -Name "RestrictImplicitInkCollection" -Type DWord -Value 0
    } ElseIf($Cortana -eq 2) {
        DisplayOut "Disabling Cortana..." 12 0
        $Path = Check-SetPath "HKCU:\SOFTWARE\Microsoft\Personalization\Settings"
        Set-ItemProperty -Path $Path -Name "AcceptedPrivacyPolicy" -Type DWord -Value 0
        $Path = Check-SetPath "HKCU:\SOFTWARE\Microsoft\InputPersonalization"
        Set-ItemProperty -Path $Path -Name "RestrictImplicitTextCollection" -Type DWord -Value 1
        Set-ItemProperty -Path $Path -Name "RestrictImplicitInkCollection" -Type DWord -Value 1
        $Path = Check-SetPath "$Path\TrainedDataStore"
        Set-ItemProperty -Path $Path -Name "HarvestContacts" -Type DWord -Value 0
    }

    If($CortanaSearch -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Cortana Search..." 15 0
    } ElseIf($CortanaSearch -eq 1) {
        DisplayOut "Enabling Cortana Search..." 11 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana"
    } ElseIf($CortanaSearch -eq 2) {
        DisplayOut "Disabling Cortana Search..." 12 0
        $Path = Check-SetPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
        Set-ItemProperty -Path $Path -Name "AllowCortana" -Type DWord -Value 0
    }

    If($ErrorReporting -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Error Reporting..." 15 0
    } ElseIf($ErrorReporting -eq 1) {
        DisplayOut "Enabling Error Reporting..." 11 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled"
    } ElseIf($ErrorReporting -eq 2) {
        DisplayOut "Disabling Error Reporting..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Type DWord -Value 1
    }

    If($AutoLoggerFile -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping AutoLogger..." 15 0
    } ElseIf($AutoLoggerFile -eq 1) {
        DisplayOut "Unrestricting AutoLogger Directory..." 11 0
        $autoLoggerDir = "$Env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
        icacls $autoLoggerDir /grant:r SYSTEM:`(OI`)`(CI`)F | Out-Null
    } ElseIf($AutoLoggerFile -eq 2) {
        DisplayOut "Removing AutoLogger File and Festricting Directory..." 12 0
        $autoLoggerDir = "$Env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
        Remove-SetPath "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl"
        icacls $autoLoggerDir /deny SYSTEM:`(OI`)`(CI`)F | Out-Null
    }

    If($DiagTrack -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Diagnostics Tracking..." 15 0
    } ElseIf($DiagTrack -eq 1) {
        DisplayOut "Enabling and Starting Diagnostics Tracking Service..." 11 0
        Set-Service "DiagTrack" -StartupType Automatic
        Start-Service "DiagTrack"
    } ElseIf($DiagTrack -eq 2) {
        DisplayOut "Stopping and Disabling Diagnostics Tracking Service..." 12 0
        Stop-Service "DiagTrack"
        Set-Service "DiagTrack" -StartupType Disabled
    }

    If($WAPPush -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping WAP Push..." 15 0
    } ElseIf($WAPPush -eq 1) {
        DisplayOut "Enabling and Starting WAP Push Service..." 11 0
        Set-Service "dmwappushservice" -StartupType Automatic
        Start-Service "dmwappushservice"
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\dmwappushservice" -Name "DelayedAutoStart" -Type DWord -Value 1
    } ElseIf($WAPPush -eq 2) {
        DisplayOut "Disabling WAP Push Service..." 12 0
        Stop-Service "dmwappushservice"
        Set-Service "dmwappushservice" -StartupType Disabled
    }

    If($AppAutoDownload -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping App Auto Download..." 15 0
    } ElseIf($AppAutoDownload -eq 1) {
        DisplayOut "Enabling App Auto Download..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate" -Name "AutoDownload" -Type DWord -Value 0
        Remove-ItemProperty  -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" 
    } ElseIf($AppAutoDownload -eq 2) {
        DisplayOut "Disabling App Auto Download..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate" -Name "AutoDownload" -Type DWord -Value 2
        $Path = Check-SetPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
        Set-ItemProperty -Path $Path -Name "DisableWindowsConsumerFeatures" -Type DWord -Value 1
    }

    DisplayOut "`n-------------------------------`n-   Windows Update Settings   -`n-------------------------------" 14 0
    $Path = Check-SetPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
    If($CheckForWinUpdate -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Check for Windows Update..." 15 0
    } ElseIf($CheckForWinUpdate -eq 1) {
        DisplayOut "Enabling Check for Windows Update..." 11 0
        Set-ItemProperty -Path $Path -Name "SetDisableUXWUAccess" -Type DWord -Value 0
    } ElseIf($CheckForWinUpdate -eq 2) {
        DisplayOut "Disabling Check for Windows Update..." 12 0
        Set-ItemProperty -Path $Path -Name "SetDisableUXWUAccess" -Type DWord -Value 1
    }

    If($WinUpdateType -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Windows Update Check Type..." 15 0
    } ElseIf($WinUpdateType -In 1..4) {
        $Path = Check-SetPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
        If($WinUpdateType -eq 1) {
            DisplayOut "Notify for windows update download and notify for install..." 16 0
            Set-ItemProperty -Path $Path -Name "AUOptions" -Type DWord -Value 2
        } ElseIf($WinUpdateType -eq 2) {
            DisplayOut "Auto Download for windows update download and notify for install..." 16 0
            Set-ItemProperty -Path $Path -Name "AUOptions" -Type DWord -Value 3
        } ElseIf($WinUpdateType -eq 3) {
            DisplayOut "Auto Download for windows update download and schedule for install..." 16 0
            Set-ItemProperty -Path $Path -Name "AUOptions" -Type DWord -Value 4
        } ElseIf($WinUpdateType -eq 4) {
            DisplayOut "Windows update allow local admin to choose setting..." 16 0
            Set-ItemProperty -Path $Path -Name "AUOptions" -Type DWord -Value 5
        }
    }

    If($WinUpdateDownload -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Windows Update P2P..." 15 0
    } ElseIf($WinUpdateDownload -eq 1) {
        DisplayOut "Unrestricting Windows Update P2P to internet..." 16 0
        $Path = "SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization"
        Remove-ItemProperty -Path "HKLM:\$Path\Config" -Name "DODownloadMode"
        Remove-ItemProperty -Path "HKCU:\$Path" -Name "SystemSettingsDownloadMode"
    } ElseIf($WinUpdateDownload -eq 2) {
        DisplayOut "Restricting Windows Update P2P only to local network..." 16 0
        $Path1 = "SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization"
        $Path = Check-SetPath "HKCU:\$Path1"
        Set-ItemProperty -Path $Path -Name "SystemSettingsDownloadMode" -Type DWord -Value 3
        $Path = Check-SetPath "HKLM:\$Path1\Config"
        Set-ItemProperty -Path $Path -Name "DODownloadMode" -Type DWord -Value 1
    } ElseIf($WinUpdateDownload -eq 3) {
        DisplayOut "Disabling Windows Update P2P..." 12 0
        $Path1 = "SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization"
        $Path = Check-SetPath "HKCU:\$Path1"
        Set-ItemProperty -Path $Path -Name "SystemSettingsDownloadMode" -Type DWord -Value 3
        $Path = Check-SetPath "HKLM:\$Path1\Config"
        Set-ItemProperty -Path $Path -Name "DODownloadMode" -Type DWord -Value 0
    }

    DisplayOut "`n----------------------`n-   Service Tweaks   -`n----------------------" 14 0
    If($UAC -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping UAC Level..." 15 0
    } ElseIf($UAC -eq 1) {
        DisplayOut "Lowering UAC level..." 16 0
        $Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
        Set-ItemProperty -Path $Path -Name "ConsentPromptBehaviorAdmin" -Type DWord -Value 0
        Set-ItemProperty -Path $Path -Name "PromptOnSecureDesktop" -Type DWord -Value 0
    } ElseIf($UAC -eq 2) {
        DisplayOut "Default UAC level..." 16 0
        $Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
        Set-ItemProperty -Path $Path -Name "ConsentPromptBehaviorAdmin" -Type DWord -Value 5
        Set-ItemProperty -Path $Path -Name "PromptOnSecureDesktop" -Type DWord -Value 1
    } ElseIf($UAC -eq 3) {
        DisplayOut "Raising UAC level..." 16 0
        $Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
        Set-ItemProperty -Path $Path -Name "ConsentPromptBehaviorAdmin" -Type DWord -Value 2
        Set-ItemProperty -Path $Path -Name "PromptOnSecureDesktop" -Type DWord -Value 1
    }

    If($SharingMappedDrives -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Sharing Mapped Drives between Users..." 15 0
    } ElseIf($SharingMappedDrives -eq 1) {
        DisplayOut "Enabling Sharing Mapped Drives between Users..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLinkedConnections" -Type DWord -Value 1
    } ElseIf($SharingMappedDrives -eq 2) {
        DisplayOut "Disabling Sharing Mapped Drives between Users..." 12 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLinkedConnections"
    }

    If($AdminShares -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Hidden Administrative Shares..." 15 0
    } ElseIf($AdminShares -eq 1) {
        DisplayOut "Enabling Hidden Administrative Shares..." 11 0
        Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "AutoShareWks"
    } ElseIf($AdminShares -eq 2) {
        DisplayOut "Disabling Hidden Administrative Shares..." 12 0
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "AutoShareWks" -Type DWord -Value 0
    }

    If($Firewall -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Firewall..." 15 0
    } ElseIf($Firewall -eq 1) {
        DisplayOut "Enabling Firewall..." 11 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\StandardProfile" -Name "EnableFirewall"
    } ElseIf($Firewall -eq 2) {
        DisplayOut "Disabling Firewall..." 12 0
        $Path = Check-SetPath "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\StandardProfile"
        Set-ItemProperty -Path $Path -Name "EnableFirewall" -Type DWord -Value 0
    }

    If($WinDefender -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Windows Defender..." 15 0
    } ElseIf($WinDefender -eq 1) {
        DisplayOut "Enabling Windows Defender..." 11 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware"
        $Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
        If($BuildVer -lt 15063) { $RegName = "WindowsDefender" } Else { $RegName = "SecurityHealth" }
        Set-ItemProperty -Path $Path -Name "SecurityHealth" -Type ExpandString -Value "`"%ProgramFiles%\Windows Defender\MSASCuiL.exe`""
    } ElseIf($WinDefender -eq 2) {
        DisplayOut "Disabling Windows Defender..." 12 0
        $Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
        If($BuildVer -lt 15063) { $RegName = "WindowsDefender" } Else { $RegName = "SecurityHealth" }
        Remove-ItemProperty -Path $Path -Name $RegName
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Type DWord -Value 1
    }

    If($HomeGroups -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Home Groups Services..." 15 0
    } ElseIf($HomeGroups -eq 1) {
        DisplayOut "Enabling Home Groups Services..." 11 0
        Set-Service "HomeGroupListener" -StartupType Manual
        Set-Service "HomeGroupProvider" -StartupType Manual
        Start-Service "HomeGroupProvider"
    } ElseIf($HomeGroups -eq 2) {
        DisplayOut "Disabling Home Groups Services..." 12 0
        Stop-Service "HomeGroupListener"
        Set-Service "HomeGroupListener" -StartupType Disabled
        Stop-Service "HomeGroupProvider"
        Set-Service "HomeGroupProvider" -StartupType Disabled
    }

    If($RemoteAssistance -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Remote Assistance..." 15 0
    } ElseIf($RemoteAssistance -eq 1) {
        DisplayOut "Enabling Remote Assistance..." 11 0
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Type DWord -Value 1
    } ElseIf($RemoteAssistance -eq 2) {
        DisplayOut "Disabling Remote Assistance..." 12 0
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Type DWord -Value 0
    }

    If($RemoteDesktop -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Remote Desktop..." 15 0
    } ElseIf($RemoteDesktop -eq 1) {
        DisplayOut "Enabling Remote Desktop w/o Network Level Authentication..." 11 0
        $Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server"
        Set-ItemProperty -Path $Path -Name "fDenyTSConnections" -Type DWord -Value 0
        Set-ItemProperty -Path "$Path\WinStations\RDP-Tcp" -Name "UserAuthentication" -Type DWord -Value 0
    } ElseIf($RemoteDesktop -eq 2) {
        DisplayOut "Disabling Remote Desktop..." 12 0
        $Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server"
        Set-ItemProperty -Path $Path -Name "fDenyTSConnections" -Type DWord -Value 1
        Set-ItemProperty -Path "$Path\WinStations\RDP-Tcp" -Name "UserAuthentication" -Type DWord -Value 1
    }

    DisplayOut "`n--------------------------`n-   Context Menu Items   -`n--------------------------" 14 0
    If($CastToDevice -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Cast to Device Context item..." 15 0
    } ElseIf($CastToDevice -eq 1) {
        DisplayOut "Enabling Cast to Device Context item..." 11 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{7AD84985-87B4-4a16-BE58-8B72A5B390F7}"
    } ElseIf($CastToDevice -eq 2) {
        DisplayOut "Disabling Cast to Device Context item..." 12 0
        $Path = Check-SetPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked"
        Set-ItemProperty -Path $Path -Name "{7AD84985-87B4-4a16-BE58-8B72A5B390F7}" -Type String -Value ""
    }

    If($PreviousVersions -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Previous Versions Context item..." 15 0
    } ElseIf($PreviousVersions -eq 1) {
        DisplayOut "Enabling Previous Versions Context item..." 11 0
        Set-ItemProperty -Path "HKCR:\ApplicationsAllFilesystemObjects\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Force | Out-Null
        Set-ItemProperty -Path "HKCR:\ApplicationsCLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Force | Out-Null
        Set-ItemProperty -Path "HKCR:\ApplicationsDirectory\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Force | Out-Null
        Set-ItemProperty -Path "HKCR:\ApplicationsDrive\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Force | Out-Null
    } ElseIf($PreviousVersions -eq 2) {
        DisplayOut "Disabling Previous Versions Context item..." 12 0
        Remove-SetPath "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}"
        Remove-SetPath "HKCR:\CLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}"
        Remove-SetPath "HKCR:\Directory\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}"
        Remove-SetPath "HKCR:\Drive\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}"
    }

    If($IncludeinLibrary -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Include in Library Context item..." 15 0
    } ElseIf($IncludeinLibrary -eq 1) {
        DisplayOut "Enabling Include in Library Context item..." 11 0
        Set-ItemProperty -Path "HKCR:\Folder\ShellEx\ContextMenuHandlers\Library Location" -Name "(Default)" -Type String -Value "{3dad6c5d-2167-4cae-9914-f99e41c12cfa}"
    } ElseIf($IncludeinLibrary -eq 2) {
        DisplayOut "Disabling Include in Library..." 12 0
        Set-ItemProperty -Path "HKCR:\Folder\ShellEx\ContextMenuHandlers\Library Location" -Name "(Default)" -Type String -Value ""
    }

    If($PinToStart -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Pin To Start Context item..." 15 0
    } ElseIf($PinToStart -eq 1) {
        DisplayOut "Enabling Pin To Start Context item..." 11 0
        New-Item -Path "HKCR:\*\shellex\ContextMenuHandlers\{90AA3A4E-1CBA-4233-B8BB-535773D48449}" -Force | Out-Null
        Set-ItemProperty -LiteralPath "HKCR:\*\shellex\ContextMenuHandlers\{90AA3A4E-1CBA-4233-B8BB-535773D48449}" -Name "(Default)" -Type String -Value "Taskband Pin"
        New-Item -Path "HKCR:\*\shellex\ContextMenuHandlers\{a2a9545d-a0c2-42b4-9708-a0b2badd77c8}" -Force | Out-Null
        Set-ItemProperty -LiteralPath "HKCR:\*\shellex\ContextMenuHandlers\{a2a9545d-a0c2-42b4-9708-a0b2badd77c8}" -Name "(Default)" -Type String -Value "Start Menu Pin"
        Set-ItemProperty -Path "HKCR:\Folder\shellex\ContextMenuHandlers\PintoStartScreen" -Name "(Default)" -Type String -Value "{470C0EBD-5D73-4d58-9CED-E91E22E23282}"
        Set-ItemProperty -Path "HKCR:\exefile\shellex\ContextMenuHandlers\PintoStartScreen" -Name "(Default)" -Type String -Value "{470C0EBD-5D73-4d58-9CED-E91E22E23282}"
        Set-ItemProperty -Path "HKCR:\Microsoft.Website\shellex\ContextMenuHandlers\PintoStartScreen" -Name "(Default)" -Type String -Value "{470C0EBD-5D73-4d58-9CED-E91E22E23282}"
        Set-ItemProperty -Path "HKCR:\mscfile\shellex\ContextMenuHandlers\PintoStartScreen" -Name "(Default)" -Type String -Value "{470C0EBD-5D73-4d58-9CED-E91E22E23282}"
    } ElseIf($PinToStart -eq 2) {
        DisplayOut "Disabling Pin To Start Context item..." 12 0
        Remove-Item -LiteralPath "HKCR:\*\shellex\ContextMenuHandlers\{90AA3A4E-1CBA-4233-B8BB-535773D48449}" -Force
        Remove-Item -LiteralPath "HKCR:\*\shellex\ContextMenuHandlers\{a2a9545d-a0c2-42b4-9708-a0b2badd77c8}" -Force
        Set-ItemProperty -Path "HKCR:\Folder\shellex\ContextMenuHandlers\PintoStartScreen" -Name "(Default)" -Type String -Value ""
        Set-ItemProperty -Path "HKCR:\exefile\shellex\ContextMenuHandlers\PintoStartScreen" -Name "(Default)" -Type String -Value ""
        Set-ItemProperty -Path "HKCR:\Microsoft.Website\shellex\ContextMenuHandlers\PintoStartScreen" -Name "(Default)" -Type String -Value ""
        Set-ItemProperty -Path "HKCR:\mscfile\shellex\ContextMenuHandlers\PintoStartScreen" -Name "(Default)" -Type String -Value ""
    }

    If($PinToQuickAccess -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Pin To Quick Access Context item..." 15 0
    } ElseIf($PinToQuickAccess -eq 1) {
        DisplayOut "Enabling Pin To Quick Access Context item..." 11 0
        $Path = "HKCR:\Folder\shell\pintohome"
        Set-ItemProperty -Path $Path  -Name "MUIVerb" -Type String -Value "@shell32.dll,-51377"
        Set-ItemProperty -Path $Path  -Name "AppliesTo" -Type String -Value 'System.ParsingName:<>"::{679f85cb-0220-4080-b29b-5540cc05aab6}" AND System.ParsingName:<>"::{645FF040-5081-101B-9F08-00AA002F954E}" AND System.IsFolder:=System.StructuredQueryType.Boolean#True'
        Set-ItemProperty -Path "$Path\command"  -Name "DelegateExecute" -Type String -Value "{b455f46e-e4af-4035-b0a4-cf18d2f6f28e}"
        $Path = "HKLM:\SOFTWARE\Classes\Folder\shell\pintohome"
        Set-ItemProperty -Path $Path  -Name "MUIVerb" -Type String -Value "@shell32.dll,-51377"
        Set-ItemProperty -Path $Path  -Name "AppliesTo" -Type String -Value 'System.ParsingName:<>"::{679f85cb-0220-4080-b29b-5540cc05aab6}" AND System.ParsingName:<>"::{645FF040-5081-101B-9F08-00AA002F954E}" AND System.IsFolder:=System.StructuredQueryType.Boolean#True'
        Set-ItemProperty -Path "$Path\command"  -Name "DelegateExecute" -Type String -Value "{b455f46e-e4af-4035-b0a4-cf18d2f6f28e}"
    } ElseIf($PinToQuickAccess -eq 2) {
        DisplayOut "Disabling Pin To Quick Access Context item..." 12 0
        $Path = "HKCR:\Folder\shell\pintohome"
        Set-ItemProperty -Path $Path  -Name "MUIVerb" -Type String -Value ""
        Set-ItemProperty -Path $Path  -Name "AppliesTo" -Type String -Value ""
        Set-ItemProperty -Path "$Path\command"  -Name "DelegateExecute" -Type String -Value ""
        $Path = "HKLM:\SOFTWARE\Classes\Folder\shell\pintohome"
        Set-ItemProperty -Path $Path  -Name "MUIVerb" -Type String -Value ""
        Set-ItemProperty -Path $Path  -Name "AppliesTo" -Type String -Value ""
        Set-ItemProperty -Path "$Path\command"  -Name "DelegateExecute" -Type String -Value ""        
    }

    If($ShareWith -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Share With Context item..." 15 0
    } ElseIf($ShareWith -eq 1) {
        DisplayOut "Enabling Share With Context item..." 11 0
        Set-ItemProperty -LiteralPath "HKCR:\*\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}" 
        Set-ItemProperty -Path "HKCR:\Directory\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}"
        Set-ItemProperty -Path "HKCR:\Directory\shellex\CopyHookHandlers\Sharing" -Name "(Default)" -Type String -Value "{40dd6e20-7c17-11ce-a804-00aa003ca9f6}"
        Set-ItemProperty -Path "HKCR:\Directory\shellex\PropertySheetHandlers\Sharing" -Name "(Default)" -Type String -Value "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}"
        Set-ItemProperty -Path "HKCR:\Directory\Background\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}"
        Set-ItemProperty -Path "HKCR:\Drive\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}"
        Set-ItemProperty -Path "HKCR:\LibraryFolder\background\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}"
    }  ElseIf($ShareWith -eq 2) {
        DisplayOut "Disabling Share With..." 12 0
        Set-ItemProperty -LiteralPath "HKCR:\*\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value "" 
        Set-ItemProperty -Path "HKCR:\Directory\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value ""
        Set-ItemProperty -Path "HKCR:\Directory\shellex\CopyHookHandlers\Sharing" -Name "(Default)" -Type String -Value ""
        Set-ItemProperty -Path "HKCR:\Directory\shellex\PropertySheetHandlers\Sharing" -Name "(Default)" -Type String -Value ""
        Set-ItemProperty -Path "HKCR:\Directory\Background\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value ""
        Set-ItemProperty -Path "HKCR:\Drive\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value ""
        Set-ItemProperty -Path "HKCR:\LibraryFolder\background\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value ""
    }

    If($SendTo -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Send To Context item..." 15 0
    } ElseIf($SendTo -eq 1) {
        DisplayOut "Enabling Send To Context item..." 11 0
        $Path = Check-SetPath "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo"
        Set-ItemProperty -Path $Path -Name "(Default)" -Type String -Value "{7BA4C740-9E81-11CF-99D3-00AA004AE837}" | Out-Null
    } ElseIf($SendTo -eq 2) {
        DisplayOut "Disabling Send To Context item..." 12 0
        Remove-SetPath "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo"
    }

    DisplayOut "`n----------------------`n-   Task Bar Items   -`n----------------------" 14 0
    If($BatteryUIBar -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Battery UI Bar..." 15 0
    } ElseIf($BatteryUIBar -eq 1) {
        DisplayOut "Enabling New Battery UI Bar..." 11 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" -Name "UseWin32BatteryFlyout"
    } ElseIf($BatteryUIBar -eq 2) {
        DisplayOut "Enabling Old Battery UI Bar..." 12 0
        $Path = Check-SetPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell"
        Set-ItemProperty -Path $Path -Name "UseWin32BatteryFlyout" -Type DWord -Value 1
    }

    If($ClockUIBar -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Clock UI Bar..." 15 0
    } ElseIf($ClockUIBar -eq 1) {
        DisplayOut "Enabling New Clock UI Bar..." 11 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" -Name "UseWin32TrayClockExperience"
    } ElseIf($ClockUIBar -eq 2) {
        DisplayOut "Enabling Old Clock UI Bar..." 12 0
        $Path = Check-SetPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell"
        Set-ItemProperty -Path $Path -Name "UseWin32TrayClockExperience" -Type DWord -Value 1
    }

    If($VolumeControlBar -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Volume Control Bar..." 15 0
    } ElseIf($VolumeControlBar -eq 1) {
        DisplayOut "Enabling New Volume Control Bar (Horizontal)..." 11 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC" -Name "EnableMtcUvc"
    } ElseIf($VolumeControlBar -eq 2) {
        DisplayOut "Enabling Classic Volume Control Bar (Vertical)..." 12 0
        $Path = Check-SetPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC"
        Set-ItemProperty -Path $Path -Name "EnableMtcUvc" -Type DWord -Value 0
    }

    If($TaskbarSearchBox -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Taskbar Search box / button..." 15 0
    } ElseIf($TaskbarSearchBox -eq 1) {
        DisplayOut "Showing Taskbar Search box / button..." 11 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode"
    } ElseIf($TaskbarSearchBox -eq 2) {
        DisplayOut "Hiding Taskbar Search box / button..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 0
    }

    If($TaskViewButton -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Task View button..." 15 0
    } ElseIf($TaskViewButton -eq 1) {
        DisplayOut "Showing Task View button..." 11 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton"
    } ElseIf($TaskViewButton -eq 2) {
        DisplayOut "Hiding Task View button..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0
    }

    If($TaskbarIconSize -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Icon Size in Taskbar..." 15 0
    } ElseIf($TaskbarIconSize -eq 1) {
        DisplayOut "Showing Normal Icon Size in Taskbar..." 11 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSmallIcons"
    } ElseIf($TaskbarIconSize -eq 2) {
        DisplayOut "Showing Smaller Icons in Taskbar..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSmallIcons" -Type DWord -Value 1
    }

    If($TaskbarGrouping -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Taskbar Item Grouping..." 15 0
    } ElseIf($TaskbarGrouping -eq 1) {
        DisplayOut "Never Group Taskbar Items..." 16 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarGlomLevel" -Type DWord -Value 2
    } ElseIf($TaskbarGrouping -eq 2) {
        DisplayOut "Always Group Taskbar Items..." 16 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarGlomLevel" -Type DWord -Value 0
    } ElseIf($TaskbarGrouping -eq 3) {
        DisplayOut "When Needed Group Taskbar Items..." 16 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarGlomLevel" -Type DWord -Value 1
    }

    If($TrayIcons -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Tray icons..." 15 0
    } ElseIf($TrayIcons -eq 1) {
        DisplayOut "Showing All Tray Icons..." 11 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -Type DWord -Value 0
    } ElseIf($TrayIcons -eq 2) {
        DisplayOut "Hiding Tray Icons..." 12 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray"
    }

    If($SecondsInClock -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Seconds in Taskbar Clock..." 15 0
    } ElseIf($SecondsInClock -eq 1) {
        DisplayOut "Showing Seconds in Taskbar Clock..." 11 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSecondsInSystemClock" -Type DWord -Value 1
    } ElseIf($SecondsInClock -eq 2) {
        DisplayOut "Hiding Seconds in Taskbar Clock..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSecondsInSystemClock" -Type DWord -Value 0
    }

    If($LastActiveClick -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Last Active Click..." 15 0
    } ElseIf($LastActiveClick -eq 1) {
        DisplayOut "Enabling Last Active Click..." 11 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LastActiveClick" -Type DWord -Value 1
    } ElseIf($LastActiveClick -eq 2) {
        DisplayOut "Disabling Last Active Click..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LastActiveClick" -Type DWord -Value 0
    }

    If($TaskBarOnMultiDisplay -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Taskbar on Multiple Displays..." 15 0
    } ElseIf($TaskBarOnMultiDisplay -eq 1) {
        DisplayOut "Showing Taskbar on Multiple Displays..." 11 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "MMTaskbarEnabled" -Type DWord -Value 1
    } ElseIf($TaskBarOnMultiDisplay -eq 2) {
        DisplayOut "Hiding Taskbar on Multiple Displays..." 12 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "MMTaskbarEnabled" -Type DWord -Value 0
    }

    If($TaskbarButtOnDisplay -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Taskbar Buttons on Multiple Displays..." 15 0
    } ElseIf($TaskbarButtOnDisplay -eq 1) {
        DisplayOut "Showing Taskbar Buttons on All Taskbars..." 16 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "MMTaskbarMode" -Type DWord -Value 0
    } ElseIf($TaskbarButtOnDisplay -eq 2) {
        DisplayOut "Showing Taskbar Buttons on Taskbar where Window is open..." 16 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "MMTaskbarMode" -Type DWord -Value 2
    } ElseIf($TaskbarButtOnDisplay -eq 3) {
        DisplayOut "Showing Taskbar Buttons on Main Taskbar and where Window is open..." 16 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "MMTaskbarMode" -Type DWord -Value 1
    }

    DisplayOut "`n-----------------------`n-   Star Menu Items   -`n-----------------------" 14 0
    If($StartMenuWebSearch -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Bing Search in Start Menu..." 15 0
    } ElseIf($StartMenuWebSearch -eq 1) {
        DisplayOut "Enabling Bing Search in Start Menu..." 11 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled"
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "DisableWebSearch"
    } ElseIf($StartMenuWebSearch -eq 2) {
        DisplayOut "Disabling Bing Search in Start Menu..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Type DWord -Value 0
        $Path = Check-SetPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
        Set-ItemProperty -Path $Path -Name "DisableWebSearch" -Type DWord -Value 1
    }

    If($StartSuggestions -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Start Menu Suggestions..." 15 0
    } ElseIf($StartSuggestions -eq 1) {
        DisplayOut "Enabling Start Menu Suggestions..." 11 0
        $Path = Check-SetPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManage"
        Set-ItemProperty -Path $Path -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 1
        Set-ItemProperty -Path $Path -Name "SilentInstalledAppsEnabled" -Type DWord -Value 1
    } ElseIf($StartSuggestions -eq 2) {
        DisplayOut "Disabling Start Menu Suggestions..." 12 0
        $Path = Check-SetPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManage"
        Set-ItemProperty -Path $Path -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 0
        Set-ItemProperty -Path $Path -Name "SilentInstalledAppsEnabled" -Type DWord -Value 0
    }

    If($MostUsedAppStartMenu -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Most used Apps in Start Menu..." 15 0
    } ElseIf($MostUsedAppStartMenu -eq 1) {
        DisplayOut "Showing Most used Apps in Start Menu..." 11 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackProgs" -Type DWord -Value 1
    } ElseIf($MostUsedAppStartMenu -eq 2) {
        DisplayOut "Hiding Most used Apps in Start Menu..." 12 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackProgs" -Type DWord -Value 0
    }

    If($RecentItemsFrequent -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Recent Items and Frequent Places..." 15 0
    } ElseIf($RecentItemsFrequent -eq 1) {
        DisplayOut "Enabling Recent Items and Frequent Places..." 11 0
        $Path = Check-SetPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu"
        Set-ItemProperty -Path $Path -Name "Start_TrackDocs" -Type DWord -Value 1
    } ElseIf($RecentItemsFrequent -eq 2) {
        DisplayOut "Disabling Recent Items and Frequent Places..." 12 0
        $Path = Check-SetPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu"
        Set-ItemProperty -Path $Path -Name "Start_TrackDocs" -Type DWord -Value 0
    }

    DisplayOut "`n----------------------`n-   Explorer Items   -`n----------------------" 14 0
    If($PidInTitleBar -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Process ID on Title Bar..." 15 0
    } ElseIf($PidInTitleBar -eq 1) {
        DisplayOut "Showing Process ID on Title Bar..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowPidInTitle" -Type DWord -Value 1
    } ElseIf($PidInTitleBar -eq 2) {
        DisplayOut "Hiding Process ID on Title Bar..." 12 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowPidInTitle"
    }

    If($AeroSnap -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Aero Snap..." 15 0
    } ElseIf($AeroSnap -eq 1) {
        DisplayOut "Enabling Aero Snap..." 11 0
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WindowArrangementActive" -Type DWord -Value 1
    } ElseIf($AeroSnap -eq 2) {
        DisplayOut "Disabling Aero Snap..." 12 0
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WindowArrangementActive" -Type DWord -Value 0
    }

    If($AeroShake -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Aero Shake..." 15 0
    } ElseIf($AeroShake -eq 1) {
        DisplayOut "Enabling Aero Shake..." 11 0
        Remove-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Name "NoWindowMinimizingShortcuts"
    } ElseIf($AeroShake -eq 2) {
        DisplayOut "Disabling Aero Shake..." 12 0
        $Path = Check-SetPath "HKCU:\Software\Policies\Microsoft\Windows\Explorer"
        Set-ItemProperty -Path $Path -Name "NoWindowMinimizingShortcuts" -Type DWord -Value 1
    }

    If($KnownExtensions -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Known File Extensions..." 15 0
    } ElseIf($KnownExtensions -eq 1) {
        DisplayOut "Showing Known File Extensions..." 11 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 0
    } ElseIf($KnownExtensions -eq 2) {
        DisplayOut "Hiding Known File Extensions..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 1
    }

    If($HiddenFiles -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Hidden Files..." 15 0
    } ElseIf($HiddenFiles -eq 1) {
        DisplayOut "Showing Hidden Files..." 11 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Type DWord -Value 1
    } ElseIf($HiddenFiles -eq 2) {
        DisplayOut "Hiding Hidden Files..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Type DWord -Value 2
    }

    If($SystemFiles -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping System Files..." 15 0
    } ElseIf($SystemFiles -eq 1) {
        DisplayOut "Showing System Files..." 11 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSuperHidden" -Type DWord -Value 1
    } ElseIf($SystemFiles -eq 2) {
        DisplayOut "Hiding System fFiles..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSuperHidden" -Type DWord -Value 0
    }

    If($ExplorerOpenLoc -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Default Explorer view to Quick Access..." 15 0
    } ElseIf($ExplorerOpenLoc -eq 1) {
        DisplayOut "Changing Default Explorer view to Quick Access..." 16 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo"
    } ElseIf($ExplorerOpenLoc -eq 2) {
        DisplayOut "Changing Default Explorer view to This PC..." 16 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1
    }

    If($RecentFileQikAcc -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Recent Files in Quick Access..." 15 0
    } ElseIf($RecentFileQikAcc -eq 1) {
        DisplayOut "Showing Recent Files in Quick Access..." 11 0
        $Path = "Microsoft\Windows\CurrentVersion\Explorer"
        Set-ItemProperty -Path "HKCU:\SOFTWARE\$Path" -Name "ShowRecent" -Type DWord -Value 1
        Set-ItemProperty -Path "HKLM:\$Path\HomeFolderDesktop\NameSpace\DelegateFolders\{3134ef9c-6b18-4996-ad04-ed5912e00eb5}" -Name "(Default)" -Type String -Value "Recent Items Instance Folder"
        If($OSType -eq 64){ Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\$Path\HomeFolderDesktop\NameSpace\DelegateFolders\{3134ef9c-6b18-4996-ad04-ed5912e00eb5}" -Name "(Default)" -Type String -Value "Recent Items Instance Folder" }
    } ElseIf($RecentFileQikAcc -eq 2) {
        DisplayOut "Hiding Recent Files in Quick Access..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowRecent" -Type DWord -Value 0
    } ElseIf($RecentFileQikAcc -eq 3) {
        DisplayOut "Removeing Recent Files in Quick Access..." 15 0
        $Path = "Microsoft\Windows\CurrentVersion\Explorer"
        Set-ItemProperty -Path "HKCU:\SOFTWARE\$Path" -Name "ShowRecent" -Type DWord -Value 0
        Remove-SetPath "HKLM:\SOFTWARE\$Path\HomeFolderDesktop\NameSpace\DelegateFolders\{3134ef9c-6b18-4996-ad04-ed5912e00eb5}"
        Remove-SetPath "HKLM:\SOFTWARE\Wow6432Node\$Path\HomeFolderDesktop\NameSpace\DelegateFolders\{3134ef9c-6b18-4996-ad04-ed5912e00eb5}"
    }

    If($FrequentFoldersQikAcc -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Frequent Folders in Quick Access..." 15 0
    } ElseIf($FrequentFoldersQikAcc -eq 1) {
        DisplayOut "Showing Frequent Folders in Quick Access..." 11 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowFrequent" -Type DWord -Value 1
    } ElseIf($FrequentFoldersQikAcc -eq 2) {
        DisplayOut "Hiding Frequent Folders in Quick Access..." 12 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowFrequent" -Type DWord -Value 0
    }

    If($WinContentWhileDrag -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Window Content while Dragging..." 15 0
    } ElseIf($WinContentWhileDrag -eq 1) {
        DisplayOut "Showing Window Content while Dragging..." 11 0
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "DragFullWindows" -Type DWord -Value 1
    } ElseIf($WinContentWhileDrag -eq 2) {
        DisplayOut "Hiding Window Content while Dragging..." 12 0
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "DragFullWindows" -Type DWord -Value 0
    }

    If($Autoplay -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Autoplay..." 15 0
    } ElseIf($Autoplay -eq 1) {
        DisplayOut "Enabling Autoplay..." 11 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 0
    } ElseIf($Autoplay -eq 2) {
        DisplayOut "Disabling Autoplay..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 1
    }

    If($Autorun -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Autorun for all Drives..." 15 0
    } ElseIf($Autorun -eq 1) {
        DisplayOut "Enabling Autorun for all Drives..." 11 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun"
    } ElseIf($Autorun -eq 2) {
        DisplayOut "Disabling Autorun for all Drives..." 12 0
        $Path = Check-SetPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
        Set-ItemProperty -Path $Path -Name "NoDriveTypeAutoRun" -Type DWord -Value 255
    }
    
    If($StoreOpenWith -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Search Windows Store for Unknown Extensions..." 15 0
    } ElseIf($StoreOpenWith -eq 1) {
        DisplayOut "Enabling Search Windows Store for Unknown Extensions..." 11 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "NoUseStoreOpenWith"
    } ElseIf($StoreOpenWith -eq 2) {
        DisplayOut "Disabling Search Windows Store for Unknown Extensions..." 12 0
        $Path = Check-SetPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
        Set-ItemProperty -Path $Path -Name "NoUseStoreOpenWith" -Type DWord -Value 1
    }

    If($WinXPowerShell -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Win+X PowerShell to Command Prompt..." 15 0
    } ElseIf($WinXPowerShell -eq 1) {
        DisplayOut "Changing Win+X Command Prompt to PowerShell..." 11 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "DontUsePowerShellOnWinX" -Type DWord -Value 0
    } ElseIf($WinXPowerShell -eq 2) {
        DisplayOut "Changing Win+X PowerShell to Command Prompt..." 12 0
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "DontUsePowerShellOnWinX" -Type DWord -Value 1
    }

    If($TaskManagerDetails -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Task Manager Details..." 15 0
    } ElseIf($TaskManagerDetails -eq 1) {
        DisplayOut "Showing Task Manager Details..." 11 0
        $Path =  "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager"
        $TaskManKey = Get-ItemProperty -Path $Path -Name "Preferences" | Out-Null
        If(!($TaskManKey)) {
            $taskmgr = Start-Process -WindowStyle Hidden -FilePath taskmgr.exe -PassThru
            While(!($TaskManKey)) {
                Start-Sleep -m 250
                $TaskManKey = Get-ItemProperty -Path $Path -Name "Preferences" | Out-Null
            }
            Stop-Process $taskmgr | Out-Null
        }
        $TaskManKey.Preferences[28] = 0
        Set-ItemProperty -Path $Path -Name "Preferences" -Type Binary -Value $TaskManKey.Preferences
    } ElseIf($TaskManagerDetails -eq 2) {
        DisplayOut "Hiding Task Manager Details..." 12 0
        $Path = Check-SetPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager"
        $TaskManKey = Get-ItemProperty -Path $Path -Name "Preferences" | Out-Null
        If($TaskManKey) {
            $TaskManKey.Preferences[28] = 1
            Set-ItemProperty -Path $Path -Name "Preferences" -Type Binary -Value $TaskManKey.Preferences
        }
    }

    DisplayOut "`n-----------------------`n-   'This PC' Items   -`n-----------------------" 14 0
    If($DesktopIconInThisPC -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Desktop folder in This PC..." 15 0
    } ElseIf($DesktopIconInThisPC -eq 1) {
        DisplayOut "Showing Desktop folder in This PC..." 11 0
        $Path = "\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\$Path" -Name "ThisPCPolicy" -Type String -Value "Show"
        If($OSType -eq 64){ Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" -Name "ThisPCPolicy" -Type String -Value "Show" }
    } ElseIf($DesktopIconInThisPC -eq 2) {
        DisplayOut "Hiding Desktop folder in This PC..." 12 0
        $Path = "\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\$Path" -Name "ThisPCPolicy" -Type String -Value "Hide"
        If($OSType -eq 64){ Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" -Name "ThisPCPolicy" -Type String -Value "Hide" }
    }

    If($DocumentsIconInThisPC -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Documents folder in This PC..." 15 0
    } ElseIf($DocumentsIconInThisPC -eq 1) {
        DisplayOut "Showing Documents folder in This PC..." 11 0
        $Path = "\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\$Path" -Name "ThisPCPolicy" -Type String -Value "Show"
        If($OSType -eq 64){ Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" -Name "ThisPCPolicy" -Type String -Value "Show" }
    }ElseIf($DocumentsIconInThisPC -eq 2) {
        DisplayOut "Hiding Documents folder in This PC..." 12 0
        $Path = "\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\$Path" -Name "ThisPCPolicy" -Type String -Value "Hide"
        If($OSType -eq 64){ Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" -Name "ThisPCPolicy" -Type String -Value "Hide" }
    }

    If($DownloadsIconInThisPC -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Downloads folder in This PC..." 15 0
    } ElseIf($DownloadsIconInThisPC -eq 1) {
        DisplayOut "Showing Downloads folder in This PC..." 11 0
        $Path = "\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\$Path" -Name "ThisPCPolicy" -Type String -Value "Show"
        If($OSType -eq 64){ Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" -Name "ThisPCPolicy" -Type String -Value "Show" }
    } ElseIf($DownloadsIconInThisPC -eq 2) {
        DisplayOut "Hiding Downloads folder in This PC..." 12 0
        $Path = "\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\$Path" -Name "ThisPCPolicy" -Type String -Value "Hide"
        If($OSType -eq 64){ Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" -Name "ThisPCPolicy" -Type String -Value "Hide" }
    }

    If($MusicIconInThisPC -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Music folder in This PC..." 15 0
    } ElseIf($MusicIconInThisPC -eq 1) {
        DisplayOut "Showing Music folder in This PC..." 11 0
        $Path = "\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\$Path" -Name "ThisPCPolicy" -Type String -Value "Show"
        If($OSType -eq 64){ Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" -Name "ThisPCPolicy" -Type String -Value "Show" }
    } ElseIf($MusicIconInThisPC -eq 2) {
        DisplayOut "Hiding Music folder in This PC..." 12 0
        $Path = "\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\$Path" -Name "ThisPCPolicy" -Type String -Value "Hide"
        If($OSType -eq 64){ Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" -Name "ThisPCPolicy" -Type String -Value "Hide" }
    }

    If($PicturesIconInThisPC -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Pictures folder in This PC..." 15 0
    } ElseIf($PicturesIconInThisPC -eq 1) {
        DisplayOut "Showing Pictures folder in This PC..." 11 0
        $Path = "\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\$Path" -Name "ThisPCPolicy" -Type String -Value "Show"
        If($OSType -eq 64){ Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" -Name "ThisPCPolicy" -Type String -Value "Show" }
    } ElseIf($PicturesIconInThisPC -eq 2) {
        DisplayOut "Hiding Pictures folder in This PC..." 12 0
        $Path = "\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\$Path" -Name "ThisPCPolicy" -Type String -Value "Hide"
        If($OSType -eq 64){ Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" -Name "ThisPCPolicy" -Type String -Value "Hide" }
    }

    If($VideosIconInThisPC -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Videos folder in This PC..." 15 0
    } ElseIf($VideosIconInThisPC -eq 1) {
        DisplayOut "Showing Videos folder in This PC..." 11 0
        $Path = "\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\$Path" -Name "ThisPCPolicy" -Type String -Value "Show"
        If($OSType -eq 64){ Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" -Name "ThisPCPolicy" -Type String -Value "Show" }
    } ElseIf($VideosIconInThisPC -eq 2) {
        DisplayOut "Hiding Videos folder in This PC..." 12 0
        $Path = "\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\$Path" -Name "ThisPCPolicy" -Type String -Value "Hide"
        If($OSType -eq 64){ Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\$Path" -Name "ThisPCPolicy" -Type String -Value "Hide" }
    }

    DisplayOut "`n---------------------`n-   Desktop Items   -`n---------------------" 14 0
    $Path = Check-SetPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu"
    If($ThisPCOnDesktop -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping This PC Icon on Desktop..." 15 0
    } ElseIf($ThisPCOnDesktop -eq 1) {
        DisplayOut "Showing This PC Shortcut on Desktop..." 11 0
        $Path = Check-SetPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons"
        Set-ItemProperty -Path "$Path\ClassicStartMenu" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Type DWord -Value 0
        Set-ItemProperty -Path "$Path\NewStartPanel" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Type DWord -Value 0
    } ElseIf($ThisPCOnDesktop -eq 2) {
        DisplayOut "Hiding This PC Shortcut on Desktop..." 12 0
        $Path = Check-SetPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons"
        Set-ItemProperty -Path "$Path\ClassicStartMenu" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Type DWord -Value 1
        Set-ItemProperty -Path "$Path\NewStartPanel" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Type DWord -Value 1
    }

    If($NetworkOnDesktop -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Network Icon on Desktop..." 15 0
    } ElseIf($NetworkOnDesktop -eq 1) {
        DisplayOut "Showing Network Icon on Desktop..." 11 0
        $Path = Check-SetPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons"
        Set-ItemProperty -Path "$Path\ClassicStartMenu" -Name "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" -Type DWord -Value 0
        Set-ItemProperty -Path "$Path\NewStartPanel" -Name "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" -Type DWord -Value 0
    } ElseIf($NetworkOnDesktop -eq 2) {
        DisplayOut "Hiding Network Icon on Desktop..." 12 0
        $Path = Check-SetPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons"
        Set-ItemProperty -Path "$Path\ClassicStartMenu" -Name "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" -Type DWord -Value 1
        Set-ItemProperty -Path "$Path\NewStartPanel" -Name "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" -Type DWord -Value 1
    }

    If($RecycleBinOnDesktop -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Recycle Bin Icon on Desktop..." 15 0
    } ElseIf($RecycleBinOnDesktop -eq 1) {
        DisplayOut "Showing Recycle Bin Icon on Desktop..." 11 0
        $Path = Check-SetPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons"
        Set-ItemProperty -Path "$Path\ClassicStartMenu" -Name "{645FF040-5081-101B-9F08-00AA002F954E}" -Type DWord -Value 0
        Set-ItemProperty -Path "$Path\NewStartPanel" -Name "{645FF040-5081-101B-9F08-00AA002F954E}" -Type DWord -Value 0
    } ElseIf($RecycleBinOnDesktop -eq 2) {
        DisplayOut "Hiding Recycle Bin Icon on Desktop..." 12 0
        $Path = Check-SetPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons"
        Set-ItemProperty -Path "$Path\ClassicStartMenu" -Name "{645FF040-5081-101B-9F08-00AA002F954E}" -Type DWord -Value 1
        Set-ItemProperty -Path "$Path\NewStartPanel" -Name "{645FF040-5081-101B-9F08-00AA002F954E}" -Type DWord -Value 1
    }

    If($UsersFileOnDesktop -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Users File Icon on Desktop..." 15 0
    } ElseIf($UsersFileOnDesktop -eq 1) {
        DisplayOut "Showing Users File Icon on Desktop..." 11 0
        $Path = Check-SetPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons"
        Set-ItemProperty -Path "$Path\ClassicStartMenu" -Name "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" -Type DWord -Value 0
        Set-ItemProperty -Path "$Path\NewStartPanel" -Name "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" -Type DWord -Value 0
    } ElseIf($UsersFileOnDesktop -eq 2) {
        DisplayOut "Hiding Users File Icon on Desktop..." 12 0
        $Path = Check-SetPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons"
        Set-ItemProperty -Path "$Path\ClassicStartMenu" -Name "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" -Type DWord -Value 1
        Set-ItemProperty -Path "$Path\NewStartPanel" -Name "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" -Type DWord -Value 1
    }

    If($ControlPanelOnDesktop -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Control Panel Icon on Desktop..." 15 0
    } ElseIf($ControlPanelOnDesktop -eq 1) {
        DisplayOut "Showing Control Panel Icon on Desktop..." 11 0
        $Path = Check-SetPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons"
        Set-ItemProperty -Path "$Path\ClassicStartMenu" -Name "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" -Type DWord -Value 0
        Set-ItemProperty -Path "$Path\NewStartPanel" -Name "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" -Type DWord -Value 0
    } ElseIf($ControlPanelOnDesktop -eq 2) {
        DisplayOut "Hiding Control Panel Icon on Desktop..." 12 0
        $Path = Check-SetPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons"
        Set-ItemProperty -Path "$Path\ClassicStartMenu" -Name "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" -Type DWord -Value 1
        Set-ItemProperty -Path "$Path\NewStartPanel" -Name "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" -Type DWord -Value 1
    }

    DisplayOut "`n-----------------------------`n-   Photo Viewer Settings   -`n-----------------------------" 14 0
    If($PVFileAssociation -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Photo Viewer File Association..." 15 0
    } ElseIf($PVFileAssociation -eq 1) {
        DisplayOut "Setting Photo Viewer File Association for bmp, gif, jpg, png and tif..." 11 0
        ForEach($type In @("Paint.Picture", "giffile", "jpegfile", "pngfile")) {
            New-Item -Path $("HKCR:\$type\shell\open") -Force | Out-Null
            New-Item -Path $("HKCR:\$type\shell\open\command") | Out-Null
            Set-ItemProperty -Path $("HKCR:\$type\shell\open") -Name "MuiVerb" -Type ExpandString -Value "@%ProgramFiles%\Windows Photo Viewer\photoviewer.dll,-3043"
            Set-ItemProperty -Path $("HKCR:\$type\shell\open\command") -Name "(Default)" -Type ExpandString -Value "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1"
        }
    } ElseIf($PVFileAssociation -eq 2) {
        DisplayOut "Unsetting Photo Viewer File Association for bmp, gif, jpg, png and tif..." 12 0
        Remove-SetPath "HKCR:\Paint.Picture\shell\open"
        Remove-ItemProperty -Path "HKCR:\giffile\shell\open" -Name "MuiVerb"
        Set-ItemProperty -Path "HKCR:\giffile\shell\open" -Name "CommandId" -Type String -Value "IE.File"
        Set-ItemProperty -Path "HKCR:\giffile\shell\open\command" -Name "(Default)" -Type String -Value "`"$Env:SystemDrive\Program Files\Internet Explorer\iexplore.exe`" %1"
        Set-ItemProperty -Path "HKCR:\giffile\shell\open\command" -Name "DelegateExecute" -Type String -Value "{17FE9752-0B5A-4665-84CD-569794602F5C}"
        Remove-SetPath "HKCR:\jpegfile\shell\open"
        Remove-SetPath "HKCR:\jpegfile\shell\open"
    } 

    If($PVOpenWithMenu -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Photo Viewer Open with Menu..." 15 0
    } ElseIf($PVOpenWithMenu -eq 1) {
        DisplayOut "Adding Photo Viewer to Open with Menu..." 11 0
        New-Item -Path "HKCR:\Applications\photoviewer.dll\shell\open\command" -Force | Out-Null
        New-Item -Path "HKCR:\Applications\photoviewer.dll\shell\open\DropTarget" -Force | Out-Null
        Set-ItemProperty -Path "HKCR:\Applications\photoviewer.dll\shell\open" -Name "MuiVerb" -Type String -Value "@photoviewer.dll,-3043"
        Set-ItemProperty -Path "HKCR:\Applications\photoviewer.dll\shell\open\command" -Name "(Default)" -Type ExpandString -Value "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1"
        Set-ItemProperty -Path "HKCR:\Applications\photoviewer.dll\shell\open\DropTarget" -Name "Clsid" -Type String -Value "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"
    } ElseIf($PVOpenWithMenu -eq 2) {
        DisplayOut "Removing Photo Viewer from Open with Menu..." 12 0
        Remove-SetPath "HKCR:\Applications\photoviewer.dll\shell\open"
    }

    DisplayOut "`n------------------------`n-   Lockscreen Items   -`n------------------------" 14 0
    If($LockScreen -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Lock Screen..." 15 0
    } ElseIf($LockScreen -eq 1) {
        If($BuildVer -eq 10240 -or $BuildVer -eq 10586) {
            DisplayOut "Enabling Lock Screen..." 11 0
            Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "NoLockScreen"
        } ElseIf($BuildVer -ge 14393) {
            DisplayOut "Enabling Lock screen (removing scheduler workaround)..." 11 0
            Unregister-ScheduledTask -TaskName "Disable LockScreen" -Confirm:$False
        } Else {
            DisplayOut "Unable to Enable Lock screen..." 11 0
        }
    } ElseIf($LockScreen -eq 2) {
        If($BuildVer -eq 10240 -or $BuildVer -eq 10586) {
            DisplayOut "Disabling Lock Screen..." 12 0
            $Path = Check-SetPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
            Set-ItemProperty -Path $Path -Name "NoLockScreen" -Type DWord -Value 1
        } ElseIf($BuildVer -ge 14393) {
            DisplayOut "Disabling Lock screen using scheduler workaround..." 12 0
            $service = New-Object -com Schedule.Service
            $service.Connect()
            $task = $service.NewTask(0)
            $task.Settings.DisallowStartIfOnBatteries = $False
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

    If($PowerMenuLockScreen -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Power Menu on Lock Screen..." 15 0
    } ElseIf($PowerMenuLockScreen -eq 1) {
        DisplayOut "Showing Power Menu on Lock Screen..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "shutdownwithoutlogon" -Type DWord -Value 1
    } ElseIf($PowerMenuLockScreen -eq 2) {
        DisplayOut "Hiding Power Menu on Lock Screen..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "shutdownwithoutlogon" -Type DWord -Value 0
    }

    If($CameraOnLockscreen -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Camera at Lockscreen..." 15 0
    } ElseIf($CameraOnLockscreen -eq 1) {
        DisplayOut "Enabling Camera at Lockscreen..." 11 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "NoLockScreenCamera"
    } ElseIf($CameraOnLockscreen -eq 2) {
        DisplayOut "Disabling Camera at Lockscreen..." 12 0
        $Path = Check-SetPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
        Set-ItemProperty -Path $Path -Name "NoLockScreenCamera" -Type DWord -Value 1
    }

    DisplayOut "`n------------------`n-   Misc Items   -`n------------------" 14 0
    If($ActionCenter -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Action Center..." 15 0
    } ElseIf($ActionCenter -eq 1) {
        DisplayOut "Enabling Action Center..." 11 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "DisableNotificationCenter"
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled"
    } ElseIf($ActionCenter -eq 2) {
        DisplayOut "Disabling Action Center..." 12 0
        $Path = Check-SetPath "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
        Set-ItemProperty -Path $Path -Name "DisableNotificationCenter" -Type DWord -Value 1
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -Type DWord -Value 0
    }

    If($StickyKeyPrompt -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Sticky Key Prompt..." 15 0
    } ElseIf($StickyKeyPrompt -eq 1) {
        DisplayOut "Enabling Sticky Key Prompt..." 11 0
        Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "510"
    } ElseIf($StickyKeyPrompt -eq 2) {
        DisplayOut "Disabling Sticky Key Prompt..." 12 0
        Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "506"
    }

    If($NumblockOnStart -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Num Lock on Startup..." 15 0
    } ElseIf($NumblockOnStart -eq 1) {
        DisplayOut "Enabling Num Lock on Startup..." 11 0
        Set-ItemProperty -Path "HKU:\.DEFAULT\Control Panel\Keyboard" -Name "InitialKeyboardIndicators" -Type DWord -Value 2147483650
    } ElseIf($NumblockOnStart -eq 2) {
        DisplayOut "Disabling Num Lock on Startup..." 12 0
        Set-ItemProperty -Path "HKU:\.DEFAULT\Control Panel\Keyboard" -Name "InitialKeyboardIndicators" -Type DWord -Value 2147483648
    }

    If($F8BootMenu -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping F8 boot menu options..." 15 0
    } ElseIf($F8BootMenu -eq 1) {
        DisplayOut "Enabling F8 boot menu options..." 11 0
        bcdedit /set `{current`} bootmenupolicy Legacy | Out-Null
    } ElseIf($F8BootMenu -eq 2) {
        DisplayOut "Disabling F8 boot menu options..." 12 0
        bcdedit /set `{current`} bootmenupolicy Standard | Out-Null
    }

    If($RemoteUACAcctToken -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Remote UAC Local Account Token Filter..." 15 0
    } ElseIf($RemoteUACAcctToken -eq 1) {
        DisplayOut "Enabling Remote UAC Local Account Token Filter..." 11 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "LocalAccountTokenFilterPolicy" -Type DWord -Value 1
    } ElseIf($RemoteUACAcctToken -eq 2) {
        DisplayOut "Disabling  Remote UAC Local Account Token Filter..." 12 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "LocalAccountTokenFilterPolicy"
    }

    If($HibernatePower -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Hibernate Option..." 15 0
    } ElseIf($HibernatePower -eq 1) {
        DisplayOut "Enabling Hibernate Option..." 11 0
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power" -Name "HibernateEnabled" -Type DWord -Value 1
    } ElseIf($HibernatePower -eq 2) {
        DisplayOut "Disabling Hibernate Option..." 12 0
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power" -Name "HibernateEnabled" -Type DWord -Value 0
    }

    If($SleepPower -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Sleep Option..." 15 0
    } ElseIf($SleepPower -eq 1) {
        DisplayOut "Enabling Sleep Option..." 11 0
        $Path = Check-SetPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings"
        Set-ItemProperty -Path $Path -Name "ShowSleepOption" -Type DWord -Value 1
    } ElseIf($SleepPower -eq 2) {
        DisplayOut "Disabling Sleep Option..." 12 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Name "ShowSleepOption" -Type DWord -Value 0
    }

    If($UnpinItems -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Unpinning Items..." 15 0
    } ElseIf($UnpinItems -eq 1) {
        DisplayOut "`nUnpinning Items...`n------------------" 12 0
        ForEach($Pin In $Pined_App){ unPin-App $Pin }
    }

    DisplayOut "`n-------------------------`n-   Application Items   -`n-------------------------" 14 0
    If($OneDrive -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping OneDrive..." 15 0
    } ElseIf($OneDrive -eq 1) {
        DisplayOut "Enabling OneDrive..." 11 0
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC"
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSyncProviderNotifications" -Type DWord -Value 1
    } ElseIf($OneDrive -eq 2) {
        DisplayOut "Disabling OneDrive..." 12 0
        $Path = Check-SetPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive"
        Set-ItemProperty -Path $Path -Name "DisableFileSyncNGSC" -Type DWord -Value 1
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSyncProviderNotifications" -Type DWord -Value 0
    }

    If($OneDriveInstall -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping OneDrive Installing..." 15 0
    } ElseIf($OneDriveInstall -eq 1) {
        DisplayOut "Installing OneDrive..." 11 0
        $onedriveS = "$Env:SYSTEMROOT\"
        If($OSType -eq 64){ $onedriveS += "SysWOW64" } Else{ $onedriveS += "System32" }
        $onedriveS += "\OneDriveSetup.exe"
        If(Test-Path $onedriveS -PathType Leaf) { Start-Process $onedriveS -NoNewWindow }
    } ElseIf($OneDriveInstall -eq 2) {
        DisplayOut "Uninstalling OneDrive..." 15 0
        $onedriveS = "$Env:SYSTEMROOT\"
        If($OSType -eq 64){ $onedriveS += "SysWOW64" } Else{ $onedriveS += "System32" }
        $onedriveS += "\OneDriveSetup.exe"
        If(Test-Path $onedriveS -PathType Leaf) {
            Stop-Process -Name OneDrive
            Start-Sleep -s 3
            Start-Process $onedriveS "/uninstall" -NoNewWindow -Wait | Out-Null
            Start-Sleep -s 3
            Stop-Process -Name explorer
            Start-Sleep -s 3
            Remove-Item "$Env:USERPROFILE\OneDrive" -Force -Recurse
            Remove-Item "$Env:LOCALAPPDATA\Microsoft\OneDrive" -Force -Recurse
            Remove-Item "$Env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse
            Remove-Item "$Env:SYSTEMDRIVE\OneDriveTemp" -Force -Recurse
            Remove-Item -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Recurse
            Remove-Item -Path "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Force -Recurse
        }
    }

    If($XboxDVR -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Xbox DVR..." 15 0
    } ElseIf($XboxDVR -eq 1) {
        DisplayOut "Enabling Xbox DVR..." 11 0
        Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Type DWord -Value 1
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR"
    } ElseIf($XboxDVR -eq 2) {
        DisplayOut "Disabling Xbox DVR..." 12 0
        $Path = Check-SetPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR"
        Set-ItemProperty -Path $Path -Name "AllowGameDVR" -Type DWord -Value 0
        Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Type DWord -Value 0
    }

    If($MediaPlayer -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Windows Media Player..." 15 0
    } ElseIf($MediaPlayer -eq 1) {
        DisplayOut "Installing Windows Media Player..." 11 0
        If((Get-WindowsOptionalFeature -Online | Where featurename -Like "MediaPlayback").State){ Enable-WindowsOptionalFeature -Online -FeatureName "WindowsMediaPlayer" -NoRestart | Out-Null }
    } ElseIf($MediaPlayer -eq 2) {
        DisplayOut "Uninstalling Windows Media Player..." 14 0
        If(!((Get-WindowsOptionalFeature -Online | Where featurename -Like "MediaPlayback").State)){ Disable-WindowsOptionalFeature -Online -FeatureName "WindowsMediaPlayer" -NoRestart | Out-Null }
    }

    If($WorkFolders -eq 0 -And $ShowSkipped -eq 1) {
        DisplayOut "Skipping Work Folders Client..." 15 0
    } ElseIf($WorkFolders -eq 1) {
        DisplayOut "Installing Work Folders Client..." 11 0
        If((Get-WindowsOptionalFeature -Online | Where featurename -Like "WorkFolders-Client").State){ Enable-WindowsOptionalFeature -Online -FeatureName "WorkFolders-Client" -NoRestart | Out-Null }
    } ElseIf($WorkFolders -eq 2) {
        DisplayOut "Uninstalling Work Folders Client..." 14 0
        If(!((Get-WindowsOptionalFeature -Online | Where featurename -Like "WorkFolders-Client").State)){ Disable-WindowsOptionalFeature -Online -FeatureName "WorkFolders-Client" -NoRestart | Out-Null }
    }

    If($BuildVer -ge 14393) {
        If($LinuxSubsystem -eq 0 -And $ShowSkipped -eq 1) {
            DisplayOut "Skipping Linux Subsystem..." 15 0
        } ElseIf($LinuxSubsystem -eq 1) {
            DisplayOut "Installing Linux Subsystem..." 11 0
            If((Get-WindowsOptionalFeature -Online | Where featurename -Like "Microsoft-Windows-Subsystem-Linux").State){ 
                $Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
                Set-ItemProperty -Path $Path -Name "AllowDevelopmentWithoutDevLicense" -Type DWord -Value 1
                Set-ItemProperty -Path $Path -Name "AllowAllTrustedApps" -Type DWord -Value 1
                Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux" -NoRestart | Out-Null
            }
        } ElseIf($LinuxSubsystem -eq 2) {
            DisplayOut "Uninstalling Linux Subsystem..." 14 0
            If(!((Get-WindowsOptionalFeature -Online | Where featurename -Like "Microsoft-Windows-Subsystem-Linux").State)){ 
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -Type DWord -Value 0
                Disable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux" -NoRestart | Out-Null
            }
        }
    } ElseIf($LinuxSubsystem -ne 0) {
        DisplayOut "Windows 10 Build isn't new enough for Linux Subsystem..." 14 0
    }

    DisplayOut "`n-----------------------`n-   Metro App Items   -`n-----------------------" 14 0
    $APPProcess = Get-Variable -Name "APP_*" -ValueOnly -Scope Script
    $A = 0
    ForEach($AppV In $APPProcess) {
        If($AppV -eq 1) {
            $APPS_AppsUnhide.Add($AppsList[$A]) | Out-null
        } ElseIf($AppV -eq 2) {
            $APPS_AppsHide.Add($AppsList[$A]) | Out-null
        } ElseIf($AppV -eq 3) {
            $APPS_AppsUninstall.Add($AppsList[$A]) | Out-null
        } $A++
    }

    $APPS_AppsUnhide.Remove("") ;$Ai = $APPS_AppsUnhide.Lengthh
    $APPS_AppsHide.Remove("") ;$Ah = $APPS_AppsHide.Lengthh
    $APPS_AppsUninstall.Remove("");$Au = $APPS_AppsUninstall.Lengthh
    If($Ah -ne $null -or $Au -ne $null){ $AppxPackages = Get-AppxProvisionedPackage -online | select-object PackageName,Displayname }

    DisplayOut "Unhiding Apps...`n------------------" 11 0
    If($Ai -ne $null) {
        ForEach($AppI In $APPS_AppsUnhide) {
            $AppInst = Get-AppxPackage -AllUsers $AppI
            If($AppInst -ne $null) {
                DisplayOut $AppI 11 0
                ForEach($App In $AppInst) {Add-AppxPackage -DisableDevelopmentMode -Register "$($App.InstallLocation)\AppXManifest.xml"}
            } Else {
                DisplayOut "Unable to Unhide $AppI" 11 0
            }
        }
    } Else {
        DisplayOut "No Apps being Unhidden" 11 0
    }

    DisplayOut "`nHidding Apps...`n-----------------" 12 0

    If($Ah -ne $null) {
      ForEach($AppH In $APPS_AppsHide) {
        If($AppxPackages.DisplayName.Contains($AppH)) {
            DisplayOut $AppH 12 0
            Get-AppxPackage $AppH | Remove-AppxPackage | Out-null
        } ElseIf($Release_Type -ne "Stable ") {
            DisplayOut "$AppH Isn't Installed" 12 0
        }
      }
    } Else {
        DisplayOut "No Apps being Hidden" 12 0
    }

    DisplayOut "`nUninstalling Apps...`n--------------------" 14 0
    If($Au -ne $null) {
      ForEach($AppU In $APPS_AppsUninstall) {
        If($AppxPackages.DisplayName.Contains($AppU)) {
            DisplayOut $AppU 14 0
            $PackageFullName = (Get-AppxPackage $AppU).PackageFullName
            $ProPackageFullName = ($AppxPackages.Where{$_.Displayname -eq $AppU}).PackageName

            # Alt removal: DISM /Online /Remove-ProvisionedAppxPackage /PackageName:
            Remove-AppxPackage -Package $PackageFullName | Out-null
            Remove-AppxProvisionedPackage -Online -PackageName $ProPackageFullName | Out-null
        } ElseIf($Release_Type -ne "Stable ") {
            DisplayOut "$AppU Isn't Installed" 14 0
        }
      }
    } Else {
        DisplayOut "No Apps being Uninstalled" 14 0
    }

    If($Restart -eq 1 -And $Release_Type -eq "Stable ") {
        Clear-Host
        $Seconds = 10
        Write-Host "`nRestarting Computer in 10 Seconds..." -ForegroundColor Yellow -BackgroundColor Black
        $Message = "Restarting in"
        Start-Sleep -Seconds 1
        ForEach($Count In (1..$Seconds)){ If($Count -ne 0){ Write-Host "$Message $($Seconds - $Count)" -ForegroundColor Yellow -BackgroundColor Black ;Start-Sleep -Seconds 1 } }
        Write-Host "Restarting Computer..." -ForegroundColor Red -BackgroundColor Black
        Restart-Computer
    } ElseIf($Release_Type -eq "Stable ") {
        Write-Host "Goodbye..."
        If($Automated -eq 0){ Read-Host -Prompt "`nPress any key to exit" }
        Exit
    } ElseIf($Automated -eq 0) { 
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

# DO NOT TOUCH THESE
$Script:AppsUnhide = ""
$Script:AppsHide = ""
$Script:AppsUninstall = ""

Function SetDefault {
# --------------------------------------------------------------------------
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## !!                                            !!
## !!            SAFE TO EDIT VALUES             !!
## !!                                            !!
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# Edit values (Option) to your preferance
# Change to an Option not listed will Skip the Function/Setting

# Note: If you're not sure what something does dont change it or do a web search 

# Can ONLY create 1 per 24 hours with this script (Will give an error)
$Script:CreateRestorePoint = 0    #0-Skip, 1-Create --(Restore point before script runs)
$Script:RestorePointName = "Win10 Initial Setup Script"

#Skips Term of Use
$Script:AcceptToS = 1             #1-See ToS, Anything else = Accepts Term of Use
$Script:Automated = 0             #0-Pause at End/Error, Dont Pause at End/Error

$Script:ShowSkipped = 1           #0-Dont Show Skipped, 1-Show Skipped

#Update Related
$Script:VersionCheck = 0          #0-Dont Check for Update, 1-Check for Update (Will Auto Download and run newer version)
#File will be named 'Win10-Menu-Ver.(Version HERE).ps1 (For non Test version)

$Script:BatUpdateScriptFileName = 1 #0-Dont ->, 1-Update Bat file with new script filename (if update is found)

$Script:InternetCheck = 0         #0 = Checks if you have internet by doing a ping to GitHub.com
                                  #1 = Bypass check if your pings are blocked

#Restart when done? (I recommend restarting when done)
$Script:Restart = 1               #0-Dont Restart, 1-Restart

#Windows Default for ALL Settings 
$Script:WinDefault = 2            #1-Yes*, 2-No
# IF 1 is set then Everything Other than the following will use the Default Win Settings
# ALL Values Above this one, All Metro Apps and OneDriveInstall (Will use what you set)

#Privacy Settings
# Function = Option               #Choices (* Indicates Windows Default)
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
# Function = Option               #Choices (* Indicates Windows Default)
$Script:CheckForWinUpdate = 0     #0-Skip, 1-Enable*, 2-Disable
$Script:WinUpdateType = 0         #0-Skip, 1-Notify, 2-Auto DL, 3-Auto DL+Install*, 4-Local admin chose --(May not work with Home version)
$Script:WinUpdateDownload = 0     #0-Skip, 1-P2P*, 2-Local Only, 3-Disable
$Script:UpdateMSRT = 0            #0-Skip, 1-Enable*, 2-Disable --(Malware Software Removal Tool)
$Script:UpdateDriver = 0          #0-Skip, 1-Enable*, 2-Disable --(Offering of drivers through Windows Update)
$Script:RestartOnUpdate = 0       #0-Skip, 1-Enable*, 2-Disable
$Script:AppAutoDownload = 0       #0-Skip, 1-Enable*, 2-Disable

#Service Tweaks
# Function = Option               #Choices (* Indicates Windows Default)
$Script:UAC = 0                   #0-Skip, 1-Lower, 2-Normal*, 3-Higher
$Script:SharingMappedDrives = 0   #0-Skip, 1-Enable, 2-Disable* --(Sharing mapped drives between users)
$Script:AdminShares = 0           #0-Skip, 1-Enable*, 2-Disable --(Default admin shares for each drive)
$Script:Firewall = 0              #0-Skip, 1-Enable*, 2-Disable
$Script:WinDefender = 0           #0-Skip, 1-Enable*, 2-Disable
$Script:HomeGroups = 0            #0-Skip, 1-Enable*, 2-Disable
$Script:RemoteAssistance = 0      #0-Skip, 1-Enable*, 2-Disable
$Script:RemoteDesktop = 0         #0-Skip, 1-Enable, 2-Disable* --(Remote Desktop w/o Network Level Authentication)
 
#Context Menu Items
# Function = Option               #Choices (* Indicates Windows Default)
$Script:CastToDevice = 0          #0-Skip, 1-Enable*, 2-Disable
$Script:PreviousVersions = 0      #0-Skip, 1-Enable*, 2-Disable
$Script:IncludeinLibrary = 0      #0-Skip, 1-Enable*, 2-Disable
$Script:PinToStart = 0            #0-Skip, 1-Enable*, 2-Disable
$Script:PinToQuickAccess = 0      #0-Skip, 1-Enable*, 2-Disable
$Script:ShareWith = 0             #0-Skip, 1-Enable*, 2-Disable
$Script:SendTo = 0                #0-Skip, 1-Enable*, 2-Disable

#Task Bar Items
# Function = Option               #Choices (* Indicates Windows Default)
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
$Script:TaskBarButtOnDisplay = 0  #0-Skip, 1-All, 2-where window is open, 3-Main and where window is open

#Star Menu Items
# Function = Option               #Choices (* Indicates Windows Default)
$Script:StartMenuWebSearch = 0    #0-Skip, 1-Enable*, 2-Disable
$Script:StartSuggestions = 0      #0-Skip, 1-Enable*, 2-Disable --(The Suggested Apps in Start Menu)
$Script:MostUsedAppStartMenu = 0  #0-Skip, 1-Show*, 2-Hide
$Script:RecentItemsFrequent = 0   #0-Skip, 1-Enable*, 2-Disable --(In Start Menu)
$Script:UnpinItems = 0            #0-Skip, 1-Unpin

#Explorer Items
# Function = Option               #Choices (* Indicates Windows Default)
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
$Script:StoreOpenWith = 0         #0-Skip, 1-Enable*, 2-Disable
$Script:WinXPowerShell = 0        #0-Skip, 1-Powershell*, 2-Command Prompt
$Script:TaskManagerDetails = 0    #0-Skip, 1-Show, 2-Hide*

#'This PC' Items
# Function = Option               #Choices (* Indicates Windows Default)
$Script:DesktopIconInThisPC = 0   #0-Skip, 1-Show*, 2-Hide
$Script:DocumentsIconInThisPC = 0 #0-Skip, 1-Show*, 2-Hide
$Script:DownloadsIconInThisPC = 0 #0-Skip, 1-Show*, 2-Hide
$Script:MusicIconInThisPC = 0     #0-Skip, 1-Show*, 2-Hide
$Script:PicturesIconInThisPC = 0  #0-Skip, 1-Show*, 2-Hide
$Script:VideosIconInThisPC = 0    #0-Skip, 1-Show*, 2-Hide

#Desktop Items
# Function = Option               #Choices (* Indicates Windows Default)
$Script:ThisPCOnDesktop = 0       #0-Skip, 1-Show, 2-Hide*
$Script:NetworkOnDesktop = 0      #0-Skip, 1-Show, 2-Hide*
$Script:RecycleBinOnDesktop = 0   #0-Skip, 1-Show, 2-Hide*
$Script:UsersFileOnDesktop = 0    #0-Skip, 1-Show, 2-Hide*
$Script:ControlPanelOnDesktop = 0 #0-Skip, 1-Show, 2-Hide*

#Lock Screen
# Function = Option               #Choices (* Indicates Windows Default)
$Script:LockScreen = 0            #0-Skip, 1-Enable*, 2-Disable
$Script:PowerMenuLockScreen = 0   #0-Skip, 1-Show*, 2-Hide
$Script:CameraOnLockScreen = 0    #0-Skip, 1-Enable*, 2-Disable

#Misc items
# Function = Option               #Choices (* Indicates Windows Default)
$Script:ActionCenter = 0          #0-Skip, 1-Enable*, 2-Disable
$Script:StickyKeyPrompt = 0       #0-Skip, 1-Enable*, 2-Disable
$Script:NumblockOnStart = 0       #0-Skip, 1-Enable, 2-Disable*
$Script:F8BootMenu = 0            #0-Skip, 1-Enable, 2-Disable*
$Script:RemoteUACAcctToken = 0    #0-Skip, 1-Enable, 2-Disable*
$Script:HibernatePower = 0        #0-Skip, 1-Enable, 2-Disable --(Hibernate Power Option)
$Script:SleepPower = 0            #0-Skip, 1-Enable*, 2-Disable --(Sleep Power Option)

# Photo Viewer Settings
# Function = Option               #Choices (* Indicates Windows Default)
$Script:PVFileAssociation = 0     #0-Skip, 1-Enable, 2-Disable*
$Script:PVOpenWithMenu = 0        #0-Skip, 1-Enable, 2-Disable*

# Remove unwanted applications
# Function = Option               #Choices (* Indicates Windows Default)
$Script:OneDrive = 0              #0-Skip, 1-Enable*, 2-Disable
$Script:OneDriveInstall = 0       #0-Skip, 1-Installed*, 2-Uninstall
$Script:XboxDVR = 0               #0-Skip, 1-Enable*, 2-Disable
$Script:MediaPlayer = 0           #0-Skip, 1-Installed*, 2-Uninstall
$Script:WorkFolders = 0           #0-Skip, 1-Installed*, 2-Uninstall
$Script:LinuxSubsystem = 0        #0-Skip, 1-Installed, 2-Uninstall* (Anniversary Update or Higher)

# Custom List of App to Install, Hide or Uninstall
# I dunno if you can Install random apps with this script
[System.Collections.ArrayList]$Script:APPS_AppsUnhide = @()           # Apps to Install
[System.Collections.ArrayList]$Script:APPS_AppsHide = @()             # Apps to Hide
[System.Collections.ArrayList]$Script:APPS_AppsUninstall = @()        # Apps to Uninstall
#$Script:APPS_Example = @('Somecompany.Appname1','TerribleCompany.Appname2','AppS.Appname3')
# To get list of Packages Installed (in powershell)
# DISM /Online /Get-ProvisionedAppxPackages | Select-string Packagename

<#          -----> NOTE!!!! <-----
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
# Function  = Option  # 0-Skip, 1-Unhide, 2- Hide, 3-Uninstall (!!Read Note Above)
$Script:APP_3DBuilder = 0         # 3DBuilder app
$Script:APP_3DViewer = 0          # 3DViewer app
$Script:APP_BingWeather = 0       # Bing Weather app
$Script:APP_CommsPhone = 0        # Phone app
$Script:APP_Communications = 0    # Calendar & Mail app
$Script:APP_Getstarted = 0        # Get Started link
$Script:APP_Messaging = 0         # Messaging app
$Script:APP_MicrosoftOffHub = 0   # Get Office Link
$Script:APP_MovieMoments = 0      # Movie Moments app
$Script:APP_Netflix = 0           # Netflix app
$Script:APP_OfficeOneNote = 0     # Office OneNote app
$Script:APP_OfficeSway = 0        # Office Sway app
$Script:APP_OneConnect = 0        # One Connect
$Script:APP_People = 0            # People app
$Script:APP_Photos = 0            # Photos app
$Script:APP_SkypeApp1 = 0         # Microsoft.SkypeApp
$Script:APP_SkypeApp2 = 0         # Microsoft.SkypeWiFi
$Script:APP_SolitaireCollect = 0  # Microsoft Solitaire
$Script:APP_StickyNotes = 0       # Sticky Notes app
$Script:APP_VoiceRecorder = 0     # Voice Recorder app
$Script:APP_WindowsAlarms = 0     # Alarms and Clock app
$Script:APP_WindowsCalculator = 0 # Calculator app
$Script:APP_WindowsCamera = 0     # Camera app
$Script:APP_WindowsFeedbak1 = 0   # Microsoft.WindowsFeedback
$Script:APP_WindowsFeedbak2 = 0   # Microsoft.WindowsFeedbackHub
$Script:APP_WindowsMaps = 0       # Maps app
$Script:APP_WindowsPhone = 0      # Phone Companion app
$Script:APP_WindowsStore = 0      # Windows Store
$Script:APP_XboxApp = 0           # Xbox app
$Script:APP_ZuneMusic = 0         # Groove Music app
$Script:APP_ZuneVideo = 0         # Groove Video app
# --------------------------------------------------------------------------
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## !!                                            !!
## !!        DO NOT EDIT PAST THIS POINT         !!
## !!                                            !!
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
}
SetDefault
ScriptPreStart
