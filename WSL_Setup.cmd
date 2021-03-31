:::: Windows Subsystem for Linux [WSL] ::::

::#############################################################################
::							#DESCRIPTION#
::
::	SCRIPT STYLE: Interactive
::	Automated installation and setup for Windows Subsystem for Linux (WSL)
::	
::#############################################################################

:::: Developer ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Author:		David Geeraerts
:: Location:	Olympia, Washington USA
:: E-Mail:		dgeeraerts.evergreen@gmail.com
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::: GitHub :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::	https://github.com/cal-sc/WSL
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::: License ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Copyleft License(s)
:: GNU GPL v3 (General Public License)
:: https://www.gnu.org/licenses/gpl-3.0.en.html
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::: Versioning Schema ::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::		VERSIONING INFORMATION												 ::
::		Semantic Versioning used											 ::
::		http://semver.org/													 ::
::		Major.Minor.Revision												 ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:::: Command shell ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@Echo Off
@SETLOCAL enableextensions
SET $PROGRAM_NAME=WSL_Setup
SET $Version=1.3.0
SET $BUILD=2021-03-31 08:30
Title %$PROGRAM_NAME%
Prompt WSL$G
color 8F
mode con:cols=75 lines=40
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:::: Configuration - Basic ::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Declare Global variables
:: All User variables are set within here.
:: Defaults
::	uses user profile location for logs
SET "$LOGPATH=%APPDATA%\WSL"
SET "$LOG=WSL_Setup.log
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:::: Configuration - Advanced :::::::::::::::::::::::::::::::::::::::::::::::::
:: Advanced Settings

:: DEBUG
:: {0 [Off/No] , 1 [On/Yes]}
SET $DEGUB_MODE=0


::#############################################################################
::	!!!!	Everything below here is 'hard-coded' [DO NOT MODIFY]	!!!!
::#############################################################################


:::: Default Program Variables ::::::::::::::::::::::::::::::::::::::::::::::::
:: Program Variables
SET $STATUS_ADMIN=
SET $STATUS_VT=
SET $STATUS_MICROSOFT-WINDOWS-SUBSYSTEM-LINUX=
SET $STATUS_VIRTUALMACHINEPLATFORM=
SET $STATUS_REBOOT=
SET $STATUS_WSL_KERNEL_UPDATE=
SET $STATUS_WSL_DEFAULT_VERSION=

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::: Directory ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:CD
	:: Launched from directory
	SET "$PROGRAM_PATH=%~dp0"
	::	Setup logging
	IF NOT EXIST "%$LOGPATH%\var" MD "%$LOGPATH%\var"
	cd /D "%$PROGRAM_PATH%"
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:::: Session Log Header :::::::::::::::::::::::::::::::::::::::::::::::::::::::
:wLog
	:: Start session and write to log
	echo Start: %DATE% %TIME% >> "%$LogPath%\%$LOG%"
	echo Program Name: %$PROGRAM_NAME% >> "%$LogPath%\%$LOG%"
	echo Program Version: %$Version% >> "%$LogPath%\%$LOG%"	
	if %$DEGUB_MODE% EQU 1 echo Program Build: %$BUILD% >> "%$LogPath%\%$LOG%"
	echo Program Path: %$PROGRAM_PATH% >> "%$LogPath%\%$LOG%"
	echo PC: %COMPUTERNAME% >> "%$LogPath%\%$LOG%"
	echo User: %USERNAME% >> "%$LogPath%\%$LOG%"
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:::: Check if complete ::::::::::::::::::::::::::::::::::::::::::::::::::::::::
IF EXIST "%$LOGPATH%\WSL-Setup_Complete.txt" (
	CALL :banner
	call :GNU
	color 0A
	echo.
	echo WSL setup is done!
	echo Successfully installed on this system!
	echo WSL is successfully installed on this system! >> "%$LogPath%\%$LOG%"
	echo.
	GoTo jumpC
	)
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::: Administrator Privilege Check ::::::::::::::::::::::::::::::::::::::::::::
:subA
	SET $ADMIN_STATUS=0
	openfiles.exe 1> "%$LOGPATH%\var\var_$Admin_Status_M.txt" 2> "%$LOGPATH%\var\var_$Admin_Status_E.txt" && (SET $ADMIN_STATUS=1)
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Goto start

:::: banner :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:banner
:: CONSOLE MENU ::
cls
	echo  ********************************************************************
	echo		Windows Subsystem for Linux [WSL]
	echo			Version: %$Version%
	IF %$DEGUB_MODE% EQU 1 echo			Build: %$BUILD%
	echo.
	echo		 	%DATE% %TIME%
	echo.
	echo  ********************************************************************
echo.
GoTo:EOF
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::: HUD ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:HUD
echo --------------------------------------------------------------------
echo	Part I
echo		Administrative Privelage: %$STATUS_ADMIN%
echo 	Virtualization: %$STATUS_VT%
echo 	Feature Microsoft-Windows-Subsystem-Linux: %$STATUS_MICROSOFT-WINDOWS-SUBSYSTEM-LINUX%
echo		Feature VirtualMachinePlatform: %$STATUS_VIRTUALMACHINEPLATFORM%
echo		Reboot: %$STATUS_REBOOT%
echo --------------------------------------------------------------------
echo.
echo	Part II
echo		WSL Kernel update: %$STATUS_WSL_KERNEL_UPDATE%
echo		Set WSL Default version [2]: %$STATUS_WSL_DEFAULT_VERSION%
echo --------------------------------------------------------------------
GoTo:EOF
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::: GNU ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:GNU
echo.
echo     .          .
echo	   /            \
echo	  ((__-^^-,-^^-__))
echo	   `-_---' `---_-'
echo	    ^<__^|o` 'o^|__^>
echo	       \  `  /
echo	        ): :(
echo	        :o_o:
echo	         "-"
echo.
GoTo:EOF
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::: Start ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:start
	CALL :banner
	CALL :HUD
	echo.
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

echo CHECKING DEPENDENCIES...
echo.

:::: Admin Privelage Check ::::::::::::::::::::::::::::::::::::::::::::::::::::
:admin
	echo Checking if running with Administrative privelage...
	echo (Running with Administrative privelage is required!)
	echo.
	IF %$ADMIN_STATUS% EQU 1 (
		echo Running with Administrative privelage!
		SET $STATUS_ADMIN=Pass
		)
		
	IF %$ADMIN_STATUS% EQU 0 (
		color 4E
		echo NOT running with  Administrative privelage!
		echo Right-click script, "Run as administrator"!
		echo Script will now abort!
		echo.
		SET $STATUS_ADMIN=FAILED
		pause
		GoTo end
		)
	echo.
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:checkPI
IF EXIST "%$LOGPATH%\var\Part-I-Reboot.txt" (
	SET $STATUS_VT=Check
	SET $STATUS_MICROSOFT-WINDOWS-SUBSYSTEM-LINUX=Done
	SET $STATUS_VIRTUALMACHINEPLATFORM=Done
	SET $STATUS_REBOOT=Done
	GoTo PartII
	)
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::Virtualization Check ::::::::::::::::::::::::::::::::::::::::::::::::::::::
:VT
	CALL :banner
	CALL :HUD
SET $VT_CHECK=0

echo.
echo Checking to see if:
echo	[VT] Virtualization Enabled In Firmware (BIOS) is turned on...
echo.
wmic CPU GET VirtualizationFirmwareEnabled /VALUE > "%$LOGPATH%\var\$VirtualizationFirmwareEnabled.txt"
wmic CPU GET VMMonitorModeExtensions /VALUE > "%$LOGPATH%\var\$VMMonitorModeExtensions.txt"
wmic CPU GET SecondLevelAddressTranslationExtensions /VALUE > "%$LOGPATH%\var\$SecondLevelAddressTranslationExtensions.txt"
find /I "VirtualizationFirmwareEnabled=TRUE" "%$LOGPATH%\var\$VirtualizationFirmwareEnabled.txt" 1> nul 2> nul && (SET $VT_CHECK=1)
echo %$VT_CHECK% > "%$LOGPATH%\var\$VT_CHECK.txt"
IF %$VT_CHECK% EQU 1 ECHO Virtualization Enabled in the firmware, i.e. BIOS!
SET $STATUS_VT=Check
echo.
IF %$VT_CHECK% EQU 1 GoTo skipVT
	echo Hyper-V virtualization not detected!
	echo Searching for hypervisor...
	systeminfo | FIND /I "Hyper-V Requirements:" > "%$LOGPATH%\var\$HYPER-V_REQUIREMENTS.txt"
	SET $HYPERVISOR=0
	echo $HYPERVISOR: %$HYPERVISOR% > "%$LOGPATH%\var\$HYPERVISOR.txt"
	FIND /I "A hypervisor has been detected." "%$LOGPATH%\var\$HYPER-V_REQUIREMENTS.txt" 1> nul 2> nul && (SET $HYPERVISOR=1)
	IF %$HYPERVISOR% EQU 0 GoTo skipHypervisor
	echo A non-hyper-V hypervisor has been detected!
	echo This might be a virtual machine.
	echo Do you want to proceed anyway?
	Choice /C YN /T 60 /D Y /m "[Y]es or [N]o":
	IF %ERRORLEVEL% EQU 2 GoTo errHyper
	IF %ERRORLEVEL% EQU 1 GoTo skipVT	
	
:errHyper
	color 4E
	echo Virtualization disabled in the firmware ^(BIOS^)!
	echo ...or non-Hyper-V hypervisor detected! 
	echo.
	echo Virtualization is required for Hyper-V and WSL!
	echo Turn on [VT] Virtualization in the BIOS.
	echo Script will now abort!
	echo.
	SET $STATUS_VT=FAILED
	PAUSE
	GoTo end

:skipVT
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


CALL :banner
CALL :HUD
	
:::: DISM :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
Dism /online /Get-FeatureInfo /FeatureName:Microsoft-Windows-Subsystem-Linux > "%$LOGPATH%\var\$FEATURE_MICROSOFT-WINDOWS-SUBSYSTEM-LINUX.txt"
FIND /I "State : Enabled" "%$LOGPATH%\var\$FEATURE_MICROSOFT-WINDOWS-SUBSYSTEM-LINUX.txt" 1> nul 2> nul && (SET $STATUS_MICROSOFT-WINDOWS-SUBSYSTEM-LINUX=Check) && GoTo skipFMWSL
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
SET $STATUS_MICROSOFT-WINDOWS-SUBSYSTEM-LINUX=Done
:skipFMWSL

CALL :banner
CALL :HUD
Dism /online /Get-FeatureInfo /FeatureName:VirtualMachinePlatform > "%$LOGPATH%\var\$VIRTUALMACHINEPLATFORM.txt"
FIND /I "State : Enabled" "%$LOGPATH%\var\$VIRTUALMACHINEPLATFORM.txt" 1> nul 2> nul && (SET $STATUS_VIRTUALMACHINEPLATFORM=Check) && GoTo skipVMP
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
SET $STATUS_VIRTUALMACHINEPLATFORM=Done
:skipVMP
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

CALL :banner
CALL :HUD

IF EXIST "%$LOGPATH%\var\Part-I-Reboot.txt" (SET $STATUS_REBOOT=Check) && GoTo skipReboot
echo WSL Setup reboot: %DATE% %TIME% > "%$LOGPATH%\var\Part-I-Reboot.txt"
SET $STATUS_REBOOT=Rebooting
shutdown /r /t 10 /c "WSL Setup requires reboot..." /d p:2:4
echo rebooting: %date% %time% >> "%$LogPath%\%$LOG%"
echo. >> "%$LogPath%\%$LOG%"
echo.
CALL :banner
CALL :HUD
echo.
PAUSE
:skipReboot
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:::: Part II ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:PartII
CALL :banner
CALL :HUD
echo.
echo Checking on WSL kernel package update...
echo.
REM This method takes too long
:: wmic product GET name /VALUE | FIND /I "Name=Windows Subsystem for Linux Update"
::	Check registry, much quicker
reg query HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Products\997646D800BD0004EAA757A6504A1F8D\SourceList /V PackageName 2> nul > "%$LOGPATH%\var\WSL_Kernel_Package.txt"
SET $WSL_KERNEL_PACKAGE=%ERRORLEVEL%
echo $WSL_KERNEL_PACKAGE: %$WSL_KERNEL_PACKAGE% > "%$LOGPATH%\var\WSL_Kernel_Package.txt"
IF %$WSL_KERNEL_PACKAGE% NEQ 0 (GoTo WSL_Downl) ELSE (
		SET $STATUS_WSL_KERNEL_UPDATE=Done
		GoTo skipWSLKU
		)

:WSL_Downl
IF EXIST "%PUBLIC%\Downloads\wsl_update_x64.msi" GoTo skipWSL_Downl
:: Check WGET
IF EXIST "./tools/wget.exe" SET "PATH=%PATH%;%$PROGRAM_PATH%\tools"
wget.exe -V 2>nul > "%$LOGPATH%\var\WGET_VERSION.txt"
SET $WGET_STATUS=%ERRORLEVEL%
IF %$WGET_STATUS% EQU 0 GoTo subWGET
IF %$WGET_STATUS% NEQ 0 GoTo subCURL

:subWGET
echo.
CD /D "%PUBLIC%\Downloads"
wget.exe "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
IF %ERRORLEVEL% NEQ 0 GoTo subCURL
GoTo skipWSL_Downl


:subCURL
:: Backup in case WGET isn't available
echo.
curl -V 2> nul > "%$LOGPATH%\var\CURL_VERSION.txt"
curl https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi  > %PUBLIC%\Downloads\wsl_update_x64.msi

:skipWSL_Downl

:::: WSL Kernel Package Install :::::::::::::::::::::::::::::::::::::::::::::::
:install_WSLKP
CD /D "%PUBLIC%\Downloads"
echo Installing WSL 2 Kernel Update...
%PUBLIC%\Downloads\wsl_update_x64.msi /passive /q /norestart /log "%$LOGPATH%\wsl_update_x64.log"
IF EXIST "%$LOGPATH%\wsl_update_x64.log" FIND /I "Installation completed successfully." "%APPDATA%\WSL\wsl_update_x64.log" 2> nul
SET $ERROR_WSLKU=%ERRORLEVEL%
IF %$ERROR_WSLKU% NEQ 0 SET $STATUS_WSL_KERNEL_UPDATE=Failed
IF %$ERROR_WSLKU% EQU 0 (
	SET $STATUS_WSL_KERNEL_UPDATE=Done
	GoTo skipWSLKU
	)
:skipWSLKU
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:Conf
CALL :banner
CALL :HUD

wsl --set-default-version 2
SET $STATUS_WSL_DEFAULT_VERSION=Done
echo WSL Setup Part-II: %DATE% %TIME% > "%$LOGPATH%\var\Part-II-Complete.txt"
IF EXIST "%$LOGPATH%\var\Part-II-Complete.txt" echo WSL Setup completed: %DATE% %TIME% > "%$LOGPATH%\WSL-Setup_Complete.txt"
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: jump Error section
GoTo end
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::: End ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:End
IF EXIST "%$LOGPATH%\WSL-Setup_Complete.txt" IF %$DEGUB_MODE% EQU 0 RD /S /Q "%$LOGPATH%\var"
CALL :banner
CALL :HUD
CALL :GNU
echo.
IF EXIST "%$LOGPATH%\WSL-Setup_Complete.txt" (
	color 0A
	echo WSL Setup Completed!
	)
IF NOT EXIST "%$LOGPATH%\WSL-Setup_Complete.txt" echo WSL Setup is not complete!
:jumpC
echo.
echo End %DATE% %TIME% >> "%$LogPath%\%$LOG%"
timeout /t 60
exit
