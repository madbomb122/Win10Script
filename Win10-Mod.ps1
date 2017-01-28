##########
# Win10 Initial Setup Script
# 
# Original Script Info
# Author: Disassembler <disassembler@dasm.cz>
# Website: https://github.com/Disassembler0/Win10-Initial-Setup-Script/
# Version: 2.0, 2017-01-08
#
# Modded Script Info
# Author: Madbomb122
# Website: https://github.com/madbomb122/Win10Script
# Version: 3.0-Mod, 2017-01-28
##########
<#
    Win10 Initial Setup Script - Makes it easier to setup an existing or new install with moded setting
    
    Copyright (c) 2017 Disassembler <disassembler@dasm.cz> -Original Script
    Copyright (c) 2017 Madbomb122 -Modded Script
    
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

# You can run the script with a -Set WD or -Set WindowsDefault 
# To use the default setting for windows (Other than reinstalling onedrive or apps) 

# You can import settings from a file with -Set filename

## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## !!!!!!!!!            DO NOT TOUCH NEXT LINE          !!!!!!!!!
Param([alias("Set")] [string] $SettingImp)


## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## !!!!!!!!!          SAFE TO EDIT VALUES BELLOW        !!!!!!!!!
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# Edit values (Option) to your preferance
# Change to an Option not listed will Skip the Function

# Windows Default for ALL Settings 
# $OneDriveInstall, and $Bloatware Will be Skipped
$WinDefault = 2            #1-Yes*, 2-No  (IF 1 is set then all settings after this wont matter)

# Privacy Settings
# Function  = Option       #Choices (* Indicates Windows Default)
$Telemetry = 0             #0-Skip, 1-Enable*, 2-Disable
$WiFiSense = 0             #0-Skip, 1-Enable*, 2-Disable
$SmartScreen = 0           #0-Skip, 1-Enable*, 2-Disable
$StartMenuWebSearch = 0    #0-Skip, 1-Enable*, 2-Disable
$StartSuggestions = 0      #0-Skip, 1-Enable*, 2-Disable
$AppAutoDownload = 0       #0-Skip, 1-Enable*, 2-Disable
$LocationTracking = 0      #0-Skip, 1-Enable*, 2-Disable
$Feedback = 0              #0-Skip, 1-Enable*, 2-Disable
$AdvertisingID = 0         #0-Skip, 1-Enable*, 2-Disable     
$Cortana = 0               #0-Skip, 1-Enable*, 2-Disable
$ErrorReporting = 0        #0-Skip, 1-Enable*, 2-Disable
$WinUpdateDownload = 0     #0-Skip, 1-P2P*, 2-Local Only, 3-Disable
$AutoLoggerFile = 0        #0-Skip, 1-Enable*, 2-Disable
$DiagTrack = 0             #0-Skip, 1-Enable*, 2-Disable
$WAPPush = 0               #0-Skip, 1-Enable*, 2-Disable

# Service Tweaks
# Function  = Option       #Choices (* Indicates Windows Default)
$UAC = 0                   #0-Skip, 1-Lower, 2-Normal*, 3-Higher
$SharingMappedDrives = 0   #0-Skip, 1-Enable, 2-Disable*
$AdminShares = 0           #0-Skip, 1-Enable*, 2-Disable
$Firewall = 0              #0-Skip, 1-Enable*, 2-Disable
$WinDefender = 0           #0-Skip, 1-Enable*, 2-Disable
$HomeGroups = 0            #0-Skip, 1-Enable*, 2-Disable
$RemoteAssistance = 0      #0-Skip, 1-Enable*, 2-Disable
$RemoteDesktop = 0         #0-Skip, 1-Enable, 2-Disable* (Remote Desktop w/o Network Level Authentication)
$UpdateMSRT = 0            #0-Skip, 1-Enable*, 2-Disable (Malware Software Removal Tool)
$UpdateDriver = 0          #0-Skip, 1-Enable*, 2-Disable
$RestartOnUpdate = 0       #0-Skip, 1-Enable*, 2-Disable

#Context Menu Items
# Function  = Option       #Choices (* Indicates Windows Default)
$CastToDevice = 0          #0-Skip, 1-Enable*, 2-Disable
$PreviousVersions = 0      #0-Skip, 1-Enable*, 2-Disable
$IncludeinLibrary = 0      #0-Skip, 1-Enable*, 2-Disable
$PinTo = 0                 #0-Skip, 1-Enable*, 2-Disable
$ShareWith = 0             #0-Skip, 1-Enable*, 2-Disable
$SendTo = 0                #0-Skip, 1-Enable*, 2-Disable

#Task Bar Items
# Function  = Option       #Choices (* Indicates Windows Default)
$VolumeControlBar = 0      #0-Skip, 1-Horizontal*, 2-Vertical
$TaskbarSearchBox = 0      #0-Skip, 1-Show*, 2-Hide
$TaskViewButton = 0        #0-Skip, 1-Show*, 2-Hide
$TaskbarIconSize = 0       #0-Skip, 1-Normal*, 2-Smaller
$TaskbarGrouping = 0       #0-Skip, 1-Never, 2-Always*, 3-When Needed
$TrayIcons = 0             #0-Skip, 1-Auto*, 2-Always Show     
$SecondsInClock = 0        #0-Skip, 1-Show, 2-Hide*
$LastActiveClick = 0       #0-Skip, 1-Enable, 2-Disable*

#Explorer Items
# Function  = Option       #Choices (* Indicates Windows Default)
$PidInTitleBar = 0         #0-Skip, 1-Show, 2-Hide*
$AeroResize = 0            #0-Skip, 1-Enable*, 2-Disable
$AeroShake = 0             #0-Skip, 1-Enable*, 2-Disable
$KnownExtensions = 0       #0-Skip, 1-Show, 2-Hide*
$HiddenFiles = 0           #0-Skip, 1-Show, 2-Hide*
$SystemFiles = 0           #0-Skip, 1-Show, 2-Hide*
$ThisPCOnDesktop = 0       #0-Skip, 1-Show, 2-Hide*
$ExplorerOpenLoc = 0       #0-Skip, 1-Quick Access*, 2-ThisPC
     
#'This PC' items
# Function  = Option       #Choices (* Indicates Windows Default)
$DesktopIconInThisPC = 0   #0-Skip, 1-Show*, 2-Hide
$DocumentsIconInThisPC = 0 #0-Skip, 1-Show*, 2-Hide
$DownloadsIconInThisPC = 0 #0-Skip, 1-Show*, 2-Hide
$MusicIconInThisPC = 0     #0-Skip, 1-Show*, 2-Hide
$PicturesIconInThisPC = 0  #0-Skip, 1-Show*, 2-Hide
$VideosIconInThisPC = 0    #0-Skip, 1-Show*, 2-Hide

# Photo Viewer
# Function  = Option       #Choices (* Indicates Windows Default)
$PVFileAssociation = 0     #0-Skip, 1-Enable, 2-Disable*
$PVOpenWithMenu = 0        #0-Skip, 1-Enable, 2-Disable*

#Misc items
# Function  = Option       #Choices (* Indicates Windows Default)
$CameraOnLock = 0          #0-Skip, 1-Enable*, 2-Disable
$LockScreen = 0            #0-Skip, 1-Enable*, 2-Disable (Pre-Anniversary Update)
$LockScreenAlt = 0         #0-Skip, 1-Enable*, 2-Disable (Anniversary Update workaround) 
$ActionCenter = 0          #0-Skip, 1-Enable*, 2-Disable
$Autoplay = 0              #0-Skip, 1-Enable*, 2-Disable
$Autorun = 0               #0-Skip, 1-Enable*, 2-Disable
$StickyKeyPrompt = 0       #0-Skip, 1-Enable*, 2-Disable
$NumblockOnStart = 0       #0-Skip, 1-Enable, 2-Disable*
$F8BootMenu = 0            #0-Skip, 1-Enable, 2-Disable*

# Remove unwanted applications
# Function  = Option       #Choices (* Indicates Windows Default)
$OneDrive = 0              #0-Skip, 1-Enable*, 2-Disable
$OneDriveInstall = 0       #0-Skip, 1-Installed*, 2-Uninstall
$XboxDVR = 0               #0-Skip, 1-Enable*, 2-Disable
$MediaPlayer = 0           #0-Skip, 1-Installed*, 2-Uninstall
$WorkFolders = 0           #0-Skip, 1-Installed*, 2-Uninstall
$LinuxSubsystem = 0        #0-Skip, 1-Installed, 2-Uninstall* (Anniversary Update)

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

# Apps
# By Default Most of these are installed
# Function  = Option       # 0-Skip, 1-Unhide, 2- Hide, 3-Uninstall (!!Read Note Above)
$APP_3DBuilder=0           # '3DBuilder' app
$APP_AdvertisingXaml=0     ## Removal may cause problem with some apps
$APP_Appconnector=0        ## Not sure about this one
$APP_Asphalt8Airborne=0    # 'Asphalt 8' game
$APP_BingFinance=0         # 'Money' app - Financial news
$APP_BingFoodAndDrink=0    # 'Food and Drink' app
$APP_BingHealthFitness=0   # 'Health and Fitness' app
$APP_BingNews=0            # 'Generic news' app
$APP_BingSports=0          # 'Sports' app - Sports news
$APP_BingTranslator=0      # 'Translator' app - Bing Translate
$APP_BingTravel=0          # 'Travel' app
$APP_BingWeather=0         # 'Weather' app
$APP_CandyCrushSoda=0      # 'Candy Crush' game 
$APP_CommsPhone=0          # 'Phone' app
$APP_Communications=0      # 'Calendar and Mail' app
$APP_ConnectivityStore=0       
$APP_Facebook=0            # 'Facebook' app
$APP_FarmVille=0           # 'Farm Ville' game
$APP_FreshPaint=0          # 'Canvas' app
$APP_Getstarted=0          # 'Get Started' link
$APP_Messaging=0           # 'Messaging' app
$APP_MicrosoftJackpot=0    # 'Jackpot' app
$APP_MicrosoftJigsaw=0     # 'Jigsaw' game       
$APP_MicrosoftMahjong=0    # 'Mahjong' game
$APP_MicrosoftOfficeHub=0       
$APP_MicrosoftSudoku=0     # 'Sudoku' game 
$APP_MinecraftUWP=0        # 'Minecraft' game    
$APP_MovieMoments=0          
$APP_Netflix=0             # 'Netflix' app
$APP_OfficeOneNote=0       # 'Onenote' app
$APP_OfficeSway=0          # 'Sway' app
$APP_OneConnect=0
$APP_People=0              # 'People' app
$APP_Photos=0              # Photos app
$APP_SkypeApp=0            # 'Get Skype' link
$APP_SkypeWiFi=0           
$APP_SolitaireCollection=0 # Solitaire collection
$APP_SoundRecorder=0       # 'Sound Recorder' app
$APP_StickyNotes=0         # 'Sticky Notes' app 
$APP_StudiosWordament=0    # 'Wordament' game
$APP_Taptiles=0            
$APP_Twitter=0             # 'Twitter' app
$APP_WindowsAlarms=0       # 'Alarms and Clock' app
$APP_WindowsCalculator=0   # 'Calculator' app
$APP_WindowsCamera=0       # 'Camera' app
$APP_WindowsFeedback=0     # 'Feedback' functionality
$APP_WindowsFeedbackHub=0  # 'Feedback' functionality
$APP_WindowsMaps=0         # 'Maps' app
$APP_WindowsPhone=0        # 'Phone Companion' app
$APP_WindowsStore=0        # Windows Store
$APP_XboxApp=0             # 'Xbox' app 
$APP_ZuneMusic=0           # 'Groove Music' app
$APP_ZuneVideo=0           # 'Groove Music' app

#Skips Term_of_Use
$Term_of_Use = 1           #1-See Term_of_Use, 2-Accept Term_of_Use, Anything else -Accept Term_of_Use

#Restart when done? (I recommend restarting when done)
$Restart = 1               #0-Dont Restart, 1-Restart

## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## !!!!!!!!!                   CAUTION                  !!!!!!!!!
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## Do not Edit past this point unless you know what you are doing


##########
# Needed Stuff
##########

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

# Ask for elevated permissions if required
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
     Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $args" -Verb RunAs
     Exit
}

If ($SettingImp -ne $null -and $SettingImp){
     If (Test-Path $SettingImp -PathType Leaf){
         # // File exists
         Get-Content $SettingImp | Foreach-Object{
             $var = $_.Split("=")
             Set-Variable -Name $var[0] -Value $var[1]
         }
	} ElseIf ($SettingImp -eq "WD" -or $SettingImp -eq "WindowsDefault"){
	     $WinDefault = 1
    }
} 

# Define HKCR
If (!(Test-Path "HKCR:")) {
     New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
}


##########
# Windows Default
##########

If($WinDefault -eq 1){
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
     $VolumeControlBar = 1
     $TaskbarSearchBox = 1
     $TaskViewButton = 1
     $TaskbarIconSize = 1
     $TaskbarGrouping = 2
     $TrayIcons = 1
     $SecondsInClock = 2
     $LastActiveClick = 2
     $PidInTitleBar = 2
     $AeroResize = 1
     $AeroShake = 1
     $KnownExtensions = 2
     $HiddenFiles = 2
     $SystemFiles = 2
     $ThisPCOnDesktop = 2
     $ExplorerOpenLoc = 1
     $DesktopIconInThisPC = 1
     $DocumentsIconInThisPC = 1
     $DownloadsIconInThisPC = 1
     $MusicIconInThisPC = 1
     $PicturesIconInThisPC = 1
     $VideosIconInThisPC = 1
     $PVFileAssociation = 2
     $PVOpenWithMenu = 2
     $CameraOnLock = 1
     $LockScreen = 1
     $LockScreenAlt = 1
     $ActionCenter = 1
     $Autoplay = 1
     $Autorun = 1
     $StickyKeyPrompt = 1
     $NumblockOnStart = 2
     $F8BootMenu = 1
     $OneDrive = 1
#    $OneDriveInstall = 1
     $XboxDVR = 1
     $MediaPlayer = 1
     $WorkFolders = 1
     $LinuxSubsystem = 2
}


##########
# Script Start?
##########

# Asks for input before continuing
# Doesnt work in PowerShell ISE
If ($Term_of_Use -eq 1){
     Write-Host "This program comes with ABSOLUTELY NO WARRANTY" -ForegroundColor Black -BackgroundColor White
     Write-Host "This is free software, and you are welcome to redistribute" -ForegroundColor Black -BackgroundColor White
     Write-Host "it under certain conditions. Read License file." -ForegroundColor Black -BackgroundColor White
     Write-Host ""
     Write-Host "Do you Accept the Term of Use? (y/n)"	 
     $KeyPress= $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
     $KeyPress=$KeyPress.Character
}

If($KeyPress -eq 'y' -or $Term_of_Use -ne 1) {
     Write-Host "Running Script"
} ElseIf($KeyPress -eq 'n'){
     Write-Host "Exiting Script, Goodbye"
     exit
} Else{
     Write-Host "Invalid Input, Goodbye"
     exit	 
}

$APPProcess = Get-Variable -Name "APP_*" -ValueOnly
$APPS_AppsInstall = @()
$APPS_AppsHide = @()
$APPS_AppsUninstall = @()

$i=0
ForEach ($AppV in $APPProcess) {
   If($AppV -eq 1){
       $APPS_AppsInstall+=$AppsList[$i]
   } Elseif($AppV -eq 2){
       $APPS_AppsHide+=$AppsList[$i]
   } Elseif($AppV -eq 3){
       $APPS_AppsUninstall+=$AppsList[$i]
   }
   $i++
}


##########
# Privacy Settings
##########

# Telemetry
If ($Telemetry -eq 1) {
     Write-Host "Enabling Telemetry..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 3
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 3
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 3
} ElseIf ($Telemetry -eq 2) {
     Write-Host "Disabling Telemetry..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
}

# Wi-Fi Sense
If ($WiFiSense -eq 1) {
     Write-Host "Enabling Wi-Fi Sense..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Name "Value" -Type DWord -Value 1
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" -Name "Value" -Type DWord -Value 1
} ElseIf ($WiFiSense -eq 2) {
     Write-Host "Disabling Wi-Fi Sense..."
     If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting")) {
          New-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Force | Out-Null
     }
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Name "Value" -Type DWord -Value 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" -Name "Value" -Type DWord -Value 0
}

# martScreen Filter
If ($SmartScreen -eq 1) {
     Write-Host "Enabling SmartScreen Filter..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Type String -Value "RequireAdmin"
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" -Name "EnableWebContentEvaluation" -ErrorAction SilentlyContinue
} ElseIf ($SmartScreen -eq 2) {
     Write-Host "Disabling SmartScreen Filter..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Type String -Value "Off"
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" -Name "EnableWebContentEvaluation" -Type DWord -Value 0
}

# Web Search in Start Menu
If ($StartMenuWebSearch -eq 1) {
     Write-Host "Enabling Bing Search in Start Menu..."
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -ErrorAction SilentlyContinue
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "DisableWebSearch" -ErrorAction SilentlyContinue
} ElseIf ($StartMenuWebSearch -eq 2) {
     Write-Host "Disabling Bing Search in Start Menu..."
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Type DWord -Value 0
     If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
          New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
     }
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "DisableWebSearch" -Type DWord -Value 1
}

# Start Menu suggestions
If ($StartSuggestions -eq 1) {
     Write-Host "Enabling Start Menu suggestions..."
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 1
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Type DWord -Value 1
} ElseIf ($StartSuggestions -eq 2) {
     Write-Host "Disabling Start Menu suggestions..."
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 0
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Type DWord -Value 0
}

# App Auto Download
If ($AppAutoDownload -eq 1) {
     Write-Host "Enable App Auto Download..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate" -Name "AutoDownload" -Type DWord -Value 0
     Remove-ItemProperty  -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures"  -ErrorAction SilentlyContinue
} ElseIf ($AppAutoDownload -eq 2) {
     Write-Host "Disable App Auto Download..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate" -Name "AutoDownload" -Type DWord -Value 2
     If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent")) {
          New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force | Out-Null
     }
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" -Type DWord -Value 1
}

# Location Tracking
If ($LocationTracking -eq 1) {
     Write-Host "Enabling Location Tracking..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value 1
     Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Type DWord -Value 1
} ElseIf ($LocationTracking -eq 2) {
     Write-Host "Disabling Location Tracking..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value 0
     Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Type DWord -Value 0
}

# Disable Feedback
If ($LocationTracking -eq 1) {
     Write-Host "Enabling Feedback..."
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -ErrorAction SilentlyContinue
} ElseIf ($LocationTracking -eq 2) {
     Write-Host "Disabling Feedback..."
     If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules")) {
          New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Force | Out-Null
     }
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Type DWord -Value 0
}

# Disable Advertising ID
If ($AdvertisingID -eq 1) {
     Write-Host "Enabling Advertising ID..."
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -ErrorAction SilentlyContinue
} ElseIf ($AdvertisingID -eq 2) {
     Write-Host "Disabling Advertising ID..."
     If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo")) {
          New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" | Out-Null
     }
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Type DWord -Value 0
}

# Cortana
If ($Cortana -eq 1) {
     Write-Host "Enabling Cortana..."
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -ErrorAction SilentlyContinue
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Type DWord -Value 0 -ErrorAction SilentlyContinue
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Type DWord -Value 0 -ErrorAction SilentlyContinue
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -Name "HarvestContacts" -ErrorAction SilentlyContinue
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -ErrorAction SilentlyContinue
} ElseIf ($Cortana -eq 2) {
     Write-Host "Disabling Cortana..."
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
     If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
          New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
     }
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Type DWord -Value 0
}

# Error Reporting
If ($ErrorReporting -eq 1) {
     Write-Host "Enabling Error reporting..."
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -ErrorAction SilentlyContinue
} ElseIf ($ErrorReporting -eq 2) {
     Write-Host "Disabling Error reporting..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Type DWord -Value 1
}

# Windows Update P2P
If ($WinUpdateDownload -eq 1) {
     Write-Host "Unrestricting Windows Update P2P to internet..."
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name "DODownloadMode" -ErrorAction SilentlyContinue
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" -Name "SystemSettingsDownloadMode" -ErrorAction SilentlyContinue
} ElseIf ($WinUpdateDownload -eq 2) {
     Write-Host "Restricting Windows Update P2P only to local network..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name "DODownloadMode" -Type DWord -Value 1
     If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization")) {
          New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" | Out-Null
     }
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" -Name "SystemSettingsDownloadMode" -Type DWord -Value 3
} ElseIf ($WinUpdateDownload -eq 3) {
     Write-Host "Disabling Windows Update P2P..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name "DODownloadMode" -Type DWord -Value 0
     If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization")) {
          New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" | Out-Null
     }
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" -Name "SystemSettingsDownloadMode" -Type DWord -Value 3
}

# AutoLogger file and restrict directory
If ($AutoLoggerFile -eq 1) {
     Write-Host "Unrestricting AutoLogger directory..."
     $autoLoggerDir = "$env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
     icacls $autoLoggerDir /grant:r SYSTEM:`(OI`)`(CI`)F | Out-Null
} ElseIf ($AutoLoggerFile -eq 2) {
     Write-Host "Removing AutoLogger file and restricting directory..."
     $autoLoggerDir = "$env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
     If (Test-Path "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl") {
          Remove-Item "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl"
     }
     icacls $autoLoggerDir /deny SYSTEM:`(OI`)`(CI`)F | Out-Null
}

# Diagnostics Tracking Service
If ($DiagTrack -eq 1) {
     Write-Host "Enabling and starting Diagnostics Tracking Service..."
     Set-Service "DiagTrack" -StartupType Automatic
     Start-Service "DiagTrack"
} ElseIf ($DiagTrack -eq 2) {
     Write-Host "Stopping and disabling Diagnostics Tracking Service..."
     Stop-Service "DiagTrack"
     Set-Service "DiagTrack" -StartupType Disabled
}

# WAP Push Service
If ($WAPPush -eq 1) {
     Write-Host "Enabling and starting WAP Push Service..."
     Set-Service "dmwappushservice" -StartupType Automatic
     Start-Service "dmwappushservice"
     Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\dmwappushservice" -Name "DelayedAutoStart" -Type DWord -Value 1
} ElseIf ($WAPPush -eq 1) {
     Write-Host "Stopping and disabling WAP Push Service..."
     Stop-Service "dmwappushservice"
     Set-Service "dmwappushservice" -StartupType Disabled
}


##########
# Service Tweaks
##########

# UAC level
If ($UAC -eq 1) {
     Write-Host "Lowering UAC level..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Type DWord -Value 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "PromptOnSecureDesktop" -Type DWord -Value 0
} ElseIf ($UAC -eq 2) {
     Write-Host "Normal UAC level..."
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -ErrorAction SilentlyContinue
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "PromptOnSecureDesktop" -ErrorAction SilentlyContinue
} ElseIf ($UAC -eq 3) {
     Write-Host "Raising UAC level..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Type DWord -Value 5
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "PromptOnSecureDesktop" -Type DWord -Value 1
}

# Sharing mapped drives between users
If ($SharingMappedDrives -eq 1) {
     Write-Host "Enabling sharing mapped drives between users..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLinkedConnections" -Type DWord -Value 1
} ElseIf ($SharingMappedDrives -eq 2) {
     Write-Host "Disabling sharing mapped drives between users..."
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLinkedConnections" -ErrorAction SilentlyContinue
}

# Administrative shares
If ($AdminShares -eq 1) {
     Write-Host "Enabling implicit administrative shares..."
     Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "AutoShareWks" -ErrorAction SilentlyContinue
} ElseIf ($AdminShares -eq 2) {
     Write-Host "Disabling implicit administrative shares..."
     Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "AutoShareWks" -Type DWord -Value 0
}

# Firewall
If ($Firewall -eq 1) {
     Write-Host "Enabling Firewall..."
     Set-NetFirewallProfile -Profile * -Enabled True
} ElseIf ($Firewall -eq 2) {
     Write-Host "Disabling Firewall..."
     Set-NetFirewallProfile -Profile * -Enabled False
}

# Windows Defender
If ($WinDefender -eq 1) {
     Write-Host "Enabling Windows Defender..."
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -ErrorAction SilentlyContinue
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "WindowsDefender" -Type ExpandString -Value "`"%ProgramFiles%\Windows Defender\MSASCuiL.exe`""
} ElseIf ($WinDefender -eq 2) {
     Write-Host "Disabling Windows Defender..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Type DWord -Value 1
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "WindowsDefender" -ErrorAction SilentlyContinue
}

# Offering of Malicious Software Removal Tool through Windows Update
If ($UpdateMSRT -eq 1) {
     Write-Host "Enabling Malicious Software Removal Tool offering..."
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\MRT" -Name "DontOfferThroughWUAU" -ErrorAction SilentlyContinue
} ElseIf ($UpdateMSRT -eq 2) {
     Write-Host "Disabling Malicious Software Removal Tool offering..."
     If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\MRT")) {
          New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\MRT" | Out-Null
     }
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\MRT" -Name "DontOfferThroughWUAU" -Type DWord -Value 1
}

# Offering of drivers through Windows Update
If ($UpdateDriver -eq 1) {
     Write-Host "Enabling driver offering through Windows Update..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" -Name "SearchOrderConfig" -Type DWord -Value 1
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "ExcludeWUDriversInQualityUpdate" -ErrorAction SilentlyContinue
} ElseIf ($UpdateDriver -eq 2) {
     Write-Host "Disabling driver offering through Windows Update..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" -Name "SearchOrderConfig" -Type DWord -Value 0
     If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate")) {
          New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" | Out-Null
     }
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "ExcludeWUDriversInQualityUpdate" -Type DWord -Value 1
}

# Windows Update automatic restart
If ($RestartOnUpdate -eq 1) {
     Write-Host "Enabling Windows Update automatic restart..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "UxOption" -Type DWord -Value 0
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoRebootWithLoggedOnUsers" -ErrorAction SilentlyContinue
} ElseIf ($RestartOnUpdate -eq 2) {
     Write-Host "Disabling Windows Update automatic restart..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "UxOption" -Type DWord -Value 1
     If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU")) {
          New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Force | Out-Null
     }
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoRebootWithLoggedOnUsers" -Type DWord -Value 1
}

# Home Groups services
If ($HomeGroups -eq 1) {
     Write-Host "Starting and enabling Home Groups services..."
     Set-Service "HomeGroupListener" -StartupType Manual
     Set-Service "HomeGroupProvider" -StartupType Manual
     Start-Service "HomeGroupProvider"
} ElseIf ($HomeGroups -eq 2) {
     Write-Host "Stopping and disabling Home Groups services..."
     Stop-Service "HomeGroupListener"
     Set-Service "HomeGroupListener" -StartupType Disabled
     Stop-Service "HomeGroupProvider"
     Set-Service "HomeGroupProvider" -StartupType Disabled
}

# Remote Assistance
If ($RemoteAssistance -eq 1) {
     Write-Host "Enabling Remote Assistance..."
     Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Type DWord -Value 1
} ElseIf ($RemoteAssistance -eq 2) {
     Write-Host "Disabling Remote Assistance..."
     Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Type DWord -Value 0
}

# Enable Remote Desktop w/o Network Level Authentication
If ($RemoteDesktop -eq 1) {
     Write-Host "Enabling Remote Desktop w/o Network Level Authentication..."
     Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Type DWord -Value 0
     Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication" -Type DWord -Value 0
} ElseIf ($RemoteDesktop -eq 2) {
     Write-Host "Disabling Remote Desktop..."
     Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Type DWord -Value 1
     Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication" -Type DWord -Value 1
}


##########
# UI Tweaks
##########

# Process ID on Title Bar
If ($PidInTitleBar -eq 1) {
     Write-Host "Showing Process ID on Title Bar..."
     If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer")) {
          New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" | Out-Null
     }
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowPidInTitle" -Type DWord -Value 1
} ElseIf ($PidInTitleBar -eq 2) {
     Write-Host "Hiding Process ID on Title Bar..."
     If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer")) {
          New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" | Out-Null
     }
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowPidInTitle" -Type DWord -Value 0
}

# Camera at Lockscreen
If ($CameraOnLock -eq 1) {
     Write-Host "Enabling Camera at Lockscreen..."
     If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization")) {
          New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" | Out-Null
     }
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "NoLockScreenCamera" -Type DWord -Value 0
} ElseIf ($CameraOnLock -eq 2) {
     Write-Host "Disabling Camera at Lockscreen..."
     If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization")) {
          New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" | Out-Null
     }
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "NoLockScreenCamera" -Type DWord -Value 1
}

# Cast to Device Context
If ($CastToDevice -eq 1) {
     Write-Host "Enabling Cast to Device Context item..."
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{7AD84985-87B4-4a16-BE58-8B72A5B390F7}" -ErrorAction SilentlyContinue
} ElseIf ($CastToDevice -eq 2) {
     Write-Host "Disabling Cast to Device Context item..."
     If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked")) {
          New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" | Out-Null
     }
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{7AD84985-87B4-4a16-BE58-8B72A5B390F7}" -Type String -Value ""
}

# Previous Versions Context Menu
If ($PreviousVersions -eq 1) {
     Write-Host "Enabling Previous Versions Context item..."
     New-Item -Path "HKCR:\ApplicationsAllFilesystemObjects\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Force | Out-Null
     New-Item -Path "HKCR:\ApplicationsCLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Force | Out-Null
     New-Item -Path "HKCR:\ApplicationsDirectory\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Force | Out-Null
     New-Item -Path "HKCR:\ApplicationsDrive\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Force | Out-Null
} ElseIf ($PreviousVersions -eq 2) {
     Write-Host "Disabling Previous Versions Context item..."
     Remove-Item -Path "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Recurse -ErrorAction SilentlyContinue
     Remove-Item -Path "HKCR:\CLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Recurse -ErrorAction SilentlyContinue
     Remove-Item -Path "HKCR:\Directory\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Recurse -ErrorAction SilentlyContinue
     Remove-Item -Path "HKCR:\Drive\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Recurse -ErrorAction SilentlyContinue
}

# Include in Library Context Menu
If ($IncludeinLibrary -eq 1) {
     Write-Host "Enabling Include in Library Context item..."
     Set-ItemProperty -Path "HKCR:\Folder\ShellEx\ContextMenuHandlers\Library Location" -Name "(Default)" -Type String -Value "{3dad6c5d-2167-4cae-9914-f99e41c12cfa}"
} ElseIf ($IncludeinLibrary -eq 2) {
     Write-Host "Disabling Include in Library..."
     Set-ItemProperty -Path "HKCR:\Folder\ShellEx\ContextMenuHandlers\Library Location" -Name "(Default)" -Type String -Value ""
}

# Pin To Context Menu
If ($PinTo -eq 1) {
     Write-Host "Enabling Pin To Context item..."
     New-Item -Path "HKCR:\*\shellex\ContextMenuHandlers\{90AA3A4E-1CBA-4233-B8BB-535773D48449}" -Force | Out-Null
     Set-ItemProperty -LiteralPath "HKCR:\*\shellex\ContextMenuHandlers\{90AA3A4E-1CBA-4233-B8BB-535773D48449}" -Name "(Default)" -Type String -Value "Taskband Pin"
     New-Item -Path "HKCR:\*\shellex\ContextMenuHandlers\{a2a9545d-a0c2-42b4-9708-a0b2badd77c8}" -Force | Out-Null
     Set-ItemProperty -LiteralPath "HKCR:\*\shellex\ContextMenuHandlers\{a2a9545d-a0c2-42b4-9708-a0b2badd77c8}" -Name "(Default)" -Type String -Value "Start Menu Pin"
} ElseIf ($PinTo -eq 2) {
     Write-Host "Disabling Pin To Context item..."
     Remove-Item -LiteralPath "HKCR:\*\shellex\ContextMenuHandlers\{90AA3A4E-1CBA-4233-B8BB-535773D48449}"
     Remove-Item -LiteralPath "HKCR:\*\shellex\ContextMenuHandlers\{a2a9545d-a0c2-42b4-9708-a0b2badd77c8}" 
}

# Share With Context Menu
If ($ShareWith -eq 1) {
     Write-Host "Enabling Share With Context item..."
     Set-ItemProperty -LiteralPath "HKCR:\*\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}" 
     Set-ItemProperty -Path "HKCR:\Directory\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}"
     Set-ItemProperty -Path "HKCR:\Directory\shellex\CopyHookHandlers\Sharing" -Name "(Default)" -Type String -Value "{40dd6e20-7c17-11ce-a804-00aa003ca9f6}"
     Set-ItemProperty -Path "HKCR:\Directory\shellex\PropertySheetHandlers\Sharing" -Name "(Default)" -Type String -Value "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}"
     Set-ItemProperty -Path "HKCR:\Directory\Background\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}"
     Set-ItemProperty -Path "HKCR:\Drive\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}"
     Set-ItemProperty -Path "HKCR:\LibraryFolder\background\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}"
} ElseIf ($ShareWith -eq 2) {
     Write-Host "Disabling Share With..."
     Set-ItemProperty -LiteralPath "HKCR:\*\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value "" -Force | Out-Null
     Set-ItemProperty -Path "HKCR:\Directory\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value ""
     Set-ItemProperty -Path "HKCR:\Directory\shellex\CopyHookHandlers\Sharing" -Name "(Default)" -Type String -Value ""
     Set-ItemProperty -Path "HKCR:\Directory\shellex\PropertySheetHandlers\Sharing" -Name "(Default)" -Type String -Value ""
     Set-ItemProperty -Path "HKCR:\Directory\Background\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value ""
     Set-ItemProperty -Path "HKCR:\Drive\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value ""
     Set-ItemProperty -Path "HKCR:\LibraryFolder\background\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value ""
}

# Send To Context Menu
If ($SendTo -eq 1) {
     Write-Host "Enabling Send To Context item..."
     If (!(Test-Path "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo")) {
          New-Item -Path "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo"
     }
     Set-ItemProperty -Path "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo" -Name "(Default)" -Type String -Value "{7BA4C740-9E81-11CF-99D3-00AA004AE837}"
} ElseIf ($SendTo -eq 2) {
     Write-Host "Disabling Send To Context item..."
     Remove-Item -Path "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo" -ErrorAction SilentlyContinue
}

# Aero Resize
If ($AeroResize -eq 1) {
     Write-Host "Enabling Aero Resize..."
     Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WindowArrangementActive" -Type DWord -Value 1
} ElseIf ($AeroResize -eq 2) {
     Write-Host "Disabling Aero Resize..."
     Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WindowArrangementActive" -Type DWord -Value 0
}

# Aero Shake
If ($AeroShake -eq 1) {
     Write-Host "Enabling Aero Shake..."
     Remove-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Name "NoWindowMinimizingShortcuts" -ErrorAction SilentlyContinue
} ElseIf ($AeroShake -eq 2) {
     Write-Host "Disabling Aero Shake..."
     If (!(Test-Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer")) {
          New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" | Out-Null
     }
     Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Name "NoWindowMinimizingShortcuts" -Type DWord -Value 1
}

# Volume Control Bar
If ($VolumeControlBar -eq 1) {
     Write-Host "Enabling New Volume Bar (Horizontal)..."
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC" -Name "EnableMtcUvc" -ErrorAction SilentlyContinue
} ElseIf ($VolumeControlBar -eq 2) {
     Write-Host "Enabling Classic Volume Bar (Vertical)..."
     If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC")) {
          New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC" | Out-Null
     }
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC" -Name "EnableMtcUvc" -Type DWord -Value 0
}

# Action Center
If ($ActionCenter -eq 1) {
     Write-Host "Enabling Action Center..."
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "DisableNotificationCenter" -ErrorAction SilentlyContinue
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -ErrorAction SilentlyContinue
} ElseIf ($ActionCenter -eq 2) {
     Write-Host "Disabling Action Center..."
     If (!(Test-Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer")) {
          New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" | Out-Null
     }
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "DisableNotificationCenter" -Type DWord -Value 1
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -Type DWord -Value 0
}

# Lock screen
If ($LockScreen -eq 1) {
     Write-Host "Enabling Lock screen..."
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "NoLockScreen" -ErrorAction SilentlyContinue
} ElseIf ($LockScreen -eq 2) {
     Write-Host "Disabling Lock screen..."
     If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization")) {
          New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" | Out-Null
     }
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "NoLockScreen" -Type DWord -Value 1
} 

# Lock screen (Anniversary Update workaround) - Applicable to RS1 or newer
If ($LockScreenAlt -eq 1) {
     Write-Host "Enabling Lock screen (removing scheduler workaround)..."
     Unregister-ScheduledTask -TaskName "Disable LockScreen" -Confirm:$false -ErrorAction SilentlyContinue
} ElseIf ($LockScreenAlt -eq 2) {
     Write-Host "Disabling Lock screen using scheduler workaround..."
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

# Autoplay
If ($Autoplay -eq 1) {
     Write-Host "Enabling Autoplay..."
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 0
} ElseIf ($Autoplay -eq 2) {
     Write-Host "Disabling Autoplay..."
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 1
}

# Autorun for all drives
If ($Autorun -eq 1) {
     Write-Host "Enabling Autorun for all drives..."
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -ErrorAction SilentlyContinue
} ElseIf ($Autorun -eq 2) {
     Write-Host "Disabling Autorun for all drives..."
     If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer")) {
          New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" | Out-Null
     }
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -Type DWord -Value 255
}

# Sticky keys prompt
If ($StickyKeyPrompt -eq 1) {
     Write-Host "Enabling Sticky keys prompt..."
     Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "510"
} ElseIf ($StickyKeyPrompt -eq 2) {
     Write-Host "Disabling Sticky keys prompt..."
     Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "506"
}

# Taskbar Search button / box
If ($TaskbarSearchBox -eq 1) {
     Write-Host "Showing Taskbar Search box / button..."
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -ErrorAction SilentlyContinue
} ElseIf ($TaskbarSearchBox -eq 2) {
     Write-Host "Hiding Taskbar Search box / button..."
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 0
}

# Task View button
If ($TaskViewButton -eq 1) {
     Write-Host "Showing Task View button..."
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -ErrorAction SilentlyContinue
} ElseIf ($TaskViewButton -eq 2) {
     Write-Host "Hiding Task View button..."
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0
}

# Taskbar Icon Size
If ($TaskbarIconSize -eq 1) {
     Write-Host "Showing Normal icon size in taskbar..."
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSmallIcons" -ErrorAction SilentlyContinue
} ElseIf ($TaskbarIconSize -eq 2) {
     Write-Host "Showing Smaller icons in taskbar..."
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSmallIcons" -Type DWord -Value 1
}

# Taskbar Item Grouping
If ($TaskbarGrouping -eq 1) {
     Write-Host "Never Group Taskbar Items..."
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarGlomLevel" -Type DWord -Value 2
} ElseIf ($TaskbarGrouping -eq 2) {
     Write-Host "Always Group Taskbar Items..."
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarGlomLevel" -Type DWord -Value 0
} ElseIf ($TaskbarGrouping -eq 3) {
     Write-Host "When Needed Group Taskbar Items..."
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarGlomLevel" -Type DWord -Value 1
}

# Tray icons
If ($TrayIcons -eq 1) {
     Write-Host "Showing all tray icons..."
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -Type DWord -Value 0
} ElseIf ($TrayIcons -eq 2) {
     Write-Host "Hiding tray icons..."
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -ErrorAction SilentlyContinue
}

# Seconds in Taskbar Clock
If ($SecondsInClock -eq 1) {
     Write-Host "Showing Seconds in Taskbar Clock..."
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSecondsInSystemClock" -Type DWord -Value 1
} ElseIf ($SecondsInClock -eq 2) {
     Write-Host "Hiding Seconds in Taskbar Clock..."
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSecondsInSystemClock" -Type DWord -Value 0
}

# Last Active Click
If ($LastActiveClick -eq 1) {
     Write-Host "Last Active Click..."
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LastActiveClick" -Type DWord -Value 1
} ElseIf ($LastActiveClick -eq 2) {
     Write-Host "Last Active Click..."
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LastActiveClick" -Type DWord -Value 0
}

# File extensions
If ($KnownExtensions -eq 1) {
     Write-Host "Showing known file extensions..."
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 0
} ElseIf ($KnownExtensions -eq 2) {
     Write-Host "Hiding known file extensions..."
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 1
}

# Hidden files
If ($HiddenFiles -eq 1) {
     Write-Host "Showing hidden files..."
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Type DWord -Value 1
} ElseIf ($HiddenFiles -eq 2) {
     Write-Host "Hiding hidden files..."
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Type DWord -Value 2
}

# System files
If ($SystemFiles -eq 1) {
     Write-Host "Showing System files..."
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSuperHidden" -Type DWord -Value 1
} ElseIf ($SystemFiles -eq 2) {
     Write-Host "Hiding System files..."
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSuperHidden" -Type DWord -Value 0
}

# Change default Explorer view
If ($ExplorerOpenLoc -eq 1) {
     Write-Host "Changing default Explorer view to Quick Access..."
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -ErrorAction SilentlyContinue
} ElseIf ($ExplorerOpenLoc -eq 2) {
     Write-Host "Changing default Explorer view to This PC..."
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1
}

# Show This PC shortcut on desktop
If ($ThisPCOnDesktop -eq 1) {
     Write-Host "Showing This PC shortcut on desktop..."
     If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu")) {
          New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" | Out-Null
     }
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Type DWord -Value 0
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Type DWord -Value 0
} ElseIf ($ThisPCOnDesktop -eq 2) {
     Write-Host "Hiding This PC shortcut from desktop..."
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -ErrorAction SilentlyContinue
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -ErrorAction SilentlyContinue
}

# Desktop icon in This PC
If ($DesktopIconInThisPC -eq 1) {
     Write-Host "Showing Desktop icon in This PC..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
} ElseIf ($DesktopIconInThisPC -eq 2) {
     Write-Host "Hiding Desktop icon from This PC..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
}

# Documents icon in This PC
If ($DocumentsIconInThisPC -eq 1) {
     Write-Host "Showing Documents icon in This PC..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
}ElseIf ($DocumentsIconInThisPC -eq 2) {
     Write-Host "Hiding Documents icon from This PC..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
}

# Downloads icon from This PC
If ($DownloadsIconInThisPC -eq 1) {
     Write-Host "Showing Downloads icon in This PC..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
} ElseIf ($DownloadsIconInThisPC -eq 2) {
     Write-Host "Hiding Downloads icon from This PC..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
}

# Music icon from This PC
If ($MusicIconInThisPC -eq 1) {
     Write-Host "Showing Music icon in This PC..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
} ElseIf ($MusicIconInThisPC -eq 2) {
     Write-Host "Hiding Music icon from This PC..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
}

# Pictures icon from This PC
If ($PicturesIconInThisPC -eq 1) {
     Write-Host "Showing Pictures icon in This PC..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
} ElseIf ($PicturesIconInThisPC -eq 2) {
     Write-Host "Hiding Pictures icon from This PC..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
}

# Hide Videos icon from This PC
If ($VideosIconInThisPC -eq 1) {
     Write-Host "Showing Videos icon in This PC..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
} ElseIf ($VideosIconInThisPC -eq 2) {
     Write-Host "Hiding Videos icon from This PC..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
}

# NumLock after startup
If ($NumblockOnStart -eq 1) {
     Write-Host "Enabling NumLock after startup..."
     If (!(Test-Path "HKU:")) {
          New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS | Out-Null
     }
     Set-ItemProperty -Path "HKU:\.DEFAULT\Control Panel\Keyboard" -Name "InitialKeyboardIndicators" -Type DWord -Value 2147483650
} ElseIf ($NumblockOnStart -eq 2) {
     Write-Host "Disabling NumLock after startup..."
     If (!(Test-Path "HKU:")) {
          New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS | Out-Null
     }
     Set-ItemProperty -Path "HKU:\.DEFAULT\Control Panel\Keyboard" -Name "InitialKeyboardIndicators" -Type DWord -Value 2147483648
}


##########
# Remove unwanted applications
##########

# OneDrive
If ($OneDrive -eq 1) {
     Write-Host "Enabling OneDrive..."
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -ErrorAction SilentlyContinue
} ElseIf ($OneDrive -eq 2) {
     Write-Host "Disabling OneDrive..."
     If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive")) {
          New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" | Out-Null
     }
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Type DWord -Value 1
}

# OneDrive Install
If ($OneDriveInstall -eq 1) {
     Write-Host "Installing OneDrive..."
     $onedrive = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
     If (!(Test-Path $onedrive)) {
          $onedrive = "$env:SYSTEMROOT\System32\OneDriveSetup.exe"
     }
     Start-Process $onedrive -NoNewWindow
} ElseIf ($OneDriveInstall -eq 2) {
     Write-Host "Uninstalling OneDrive..."
     Stop-Process -Name OneDrive -ErrorAction SilentlyContinue
     Start-Sleep -s 3
     $onedrive = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
     If (!(Test-Path $onedrive)) {
          $onedrive = "$env:SYSTEMROOT\System32\OneDriveSetup.exe"
     }
     Start-Process $onedrive "/uninstall" -NoNewWindow -Wait
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

# Default Microsoft applications (Bloatware)
# Gets List of Packages
# DISM /Online /Get-ProvisionedAppxPackages | Select-string Packagename
ForEach ($AppI in $APPS_AppsInstall) {
     Write-Host "Installing "$AppI "..."
     Add-AppxPackage -DisableDevelopmentMode -Register "$($(Get-AppXPackage -AllUsers "$AppI").InstallLocation)\AppXManifest.xml"
}
ForEach ($AppH in $APPS_AppsHide) {
     Write-Host "Hiding "$AppH "..."
     Get-AppxPackage $AppH | Remove-AppxPackage
}
ForEach ($AppU in $APPS_AppsUninstall) {
     Write-Host "Uninstalling "$AppU "..."
     $PackageFullName = (Get-AppxPackage $AppU).PackageFullName
     $ProPackageFullName = (Get-AppxProvisionedPackage -online | where {$_.Displayname -eq $AppU}).PackageName
     
     # Alt removal
     # DISM /Online /Remove-ProvisionedAppxPackage /PackageName:            
     If ($PackageFullName) {
         Remove-AppxPackage -package $PackageFullName
     }
     if ($ProPackageFullName) {
         Remove-AppxProvisionedPackage -online -packagename $ProPackageFullName
     }
}

# Xbox DVR
If ($XboxDVR -eq 1) {
     Write-Host "Enabling Xbox DVR..."
     Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Type DWord -Value 1
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -ErrorAction SilentlyContinue
} ElseIf ($XboxDVR -eq 2) {
     Write-Host "Disabling Xbox DVR..."
     Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Type DWord -Value 0
     If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR")) {
          New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" | Out-Null
     }
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Type DWord -Value 0
}

# Windows Media Player
If ($MediaPlayer -eq 1) {
     Write-Host "Installing Windows Media Player..."
     dism /online /Enable-Feature /FeatureName:MediaPlayback /Quiet /NoRestart
} ElseIf ($MediaPlayer -eq 2) {
     Write-Host "Uninstalling Windows Media Player..."
     dism /online /Disable-Feature /FeatureName:MediaPlayback /Quiet /NoRestart
}

# Work Folders Client
If ($WorkFolders -eq 1) {
     Write-Host "Installing Work Folders Client..."
     dism /online /Enable-Feature /FeatureName:WorkFolders-Client /Quiet /NoRestart
} ElseIf ($WorkFolders -eq 2) {
     Write-Host "Uninstalling Work Folders Client..."
     dism /online /Disable-Feature /FeatureName:WorkFolders-Client /Quiet /NoRestart
}

# Install Linux Subsystem - Applicable to RS1 or newer
If ($LinuxSubsystem -eq 1) {
     Write-Host "Installing Linux Subsystem..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -Type DWord -Value 1
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowAllTrustedApps" -Type DWord -Value 1
     dism /online /Enable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux /Quiet /NoRestart
} ElseIf ($LinuxSubsystem -eq 2) {
     Write-Host "Uninstalling Linux Subsystem..."
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -Type DWord -Value 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowAllTrustedApps" -Type DWord -Value 0
     dism /online /Disable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux /Quiet /NoRestart
}

# Photo Viewer association for bmp, gif, jpg, png and tif
If ($PVFileAssociation -eq 1) {
     Write-Host "Unsetting Photo Viewer association for bmp, gif, jpg, png and tif..."
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
} ElseIf ($PVFileAssociation -eq 2) {
     Write-Host "Setting Photo Viewer association for bmp, gif, jpg, png and tif..."
     ForEach ($type in @("Paint.Picture", "giffile", "jpegfile", "pngfile")) {
          New-Item -Path $("HKCR:\$type\shell\open") -Force | Out-Null
          New-Item -Path $("HKCR:\$type\shell\open\command") | Out-Null
          Set-ItemProperty -Path $("HKCR:\$type\shell\open") -Name "MuiVerb" -Type ExpandString -Value "@%ProgramFiles%\Windows Photo Viewer\photoviewer.dll,-3043"
          Set-ItemProperty -Path $("HKCR:\$type\shell\open\command") -Name "(Default)" -Type ExpandString -Value "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1"
     }
}

# Add Photo Viewer to "Open with..."
If ($PVOpenWithMenu -eq 1) {
     Write-Host "Removing Photo Viewer from Open with Menu..."
     If (Test-Path "HKCR:\Applications\photoviewer.dll\shell\open") {
          Remove-Item -Path "HKCR:\Applications\photoviewer.dll\shell\open" -Recurse
     }
} ElseIf ($PVOpenWithMenu -eq 2) {
     Write-Host "Adding Photo Viewer to Open with Menu..."
     New-Item -Path "HKCR:\Applications\photoviewer.dll\shell\open\command" -Force | Out-Null
     New-Item -Path "HKCR:\Applications\photoviewer.dll\shell\open\DropTarget" -Force | Out-Null
     Set-ItemProperty -Path "HKCR:\Applications\photoviewer.dll\shell\open" -Name "MuiVerb" -Type String -Value "@photoviewer.dll,-3043"
     Set-ItemProperty -Path "HKCR:\Applications\photoviewer.dll\shell\open\command" -Name "(Default)" -Type ExpandString -Value "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1"
     Set-ItemProperty -Path "HKCR:\Applications\photoviewer.dll\shell\open\DropTarget" -Name "Clsid" -Type String -Value "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"
}

# Enable F8 boot menu options
If ($F8BootMenu -eq 1) {
     Write-Host "Enabling F8 boot menu options..."
     bcdedit /set `{current`} bootmenupolicy Legacy | Out-Null
} ElseIf ($F8BootMenu -eq 2) {
     Write-Host "Disabling F8 boot menu options..."
     bcdedit /set `{current`} bootmenupolicy Standard | Out-Null
}

##########
# Auxiliary
##########
If ($Restart -eq 1) {
     Write-Host "Restarting..."
     Restart-Computer
} Else {
     Write-Host "Goodbye..."
}
