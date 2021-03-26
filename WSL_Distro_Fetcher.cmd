:::: Windows Subsystem for Linux [WSL] Distro Fetcher ::::

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
SET $PROGRAM_NAME=WSL_DISTRO_FETCHER
SET $Version=0.1.0
SET $BUILD=2021-03-26 15:00
Title %$PROGRAM_NAME%
Prompt WSLDF$G
color 8F
mode con:cols=75 lines=40
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:::: Configuration - Basic ::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Declare Global variables
:: All User variables are set within here.
:: Defaults
::	uses user profile location for logs
SET "$LOGPATH=%APPDATA%\WSL"
SET "$LOG=WSL_Distro_Fetcher.log
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
SET $STATUS_WSL=1
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
	echo  ***********************************************************************
	echo		Windows Subsystem for Linux [WSL]
	echo			Distro Fetcher
	echo			Version: %$Version%
	IF %$DEGUB_MODE% EQU 1 echo			Build: %$BUILD%
	echo.
	echo		 	%DATE% %TIME%
	echo.
	echo  ***********************************************************************
echo.
GoTo:EOF
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::: HUD ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:HUD
echo --------------------------------------------------------------------
echo  WSL GNU/Linux Distro's
echo   [1] Alpine		[PASS]
echo   [2] Archlinux		[PASS]
echo   [3] Debian		[FAILS]
echo   [4] Kali		[PASS]
echo   [5] Fedora		[FAILS]
echo   [6] Opensuse		[PASS]
echo   [7] SUSE Enterprise	[PASS]
echo   [8] Ubuntu		[PASS]
echo --------------------------------------------------------------------	
echo.
GoTo:EOF
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::: WSL LIST :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:WSLL
cls
CALL :banner
wsl --list --verbose
timeout /t 120
GoTo menu
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



:::: Start ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:start
	CALL :banner
	echo.
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@powershell Write-Host "CHECKING DEPENDENCIES..." -ForegroundColor Yellow  
echo.

:::: Admin Privelage Check ::::::::::::::::::::::::::::::::::::::::::::::::::::
:admin
	echo Checking if running with Administrative privelage...
	echo (Running with Administrative privelage is required!)
	echo.
	IF %$ADMIN_STATUS% EQU 1 (
		echo Running with Administrative privelage!
		)
		
	IF %$ADMIN_STATUS% EQU 0 (
		color 4E
		echo NOT running with  Administrative privelage!
		echo Right-click script, "Run as administrator"!
		echo Aborting!
		echo.
		echo To install as a standard user, use Microsoft store:
		echo      https://www.microsoft.com/en-us/search?q=wsl
		echo.
		echo [ERROR]	NOT running with  Administrative privelage! >> "%$LogPath%\%$LOG%"
		pause
		GoTo end
		)
	echo.
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::: WSL Check ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

echo Checking if WSL is installed...
wsl --set-default-version 2 2> nul 1> nul
SET $STATUS_WSL=%ERRORLEVEL%
IF %$STATUS_WSL% NEQ 0 (
	color 4E
	echo WSL is not installed on this system!
	echo Install WSL first!
	echo Aborting!
	pause
	Goto end
	)
echo WSL is installed!
echo.
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:::: Chocolatey Package Manager Check :::::::::::::::::::::::::::::::::::::::::
choco info 2> nul > "%$LOGPATH%\var\Chocolatey_Version.txt"
SET $STATUS_CHOCO=%ERRORLEVEL%
IF %$STATUS_CHOCO% EQU 0 type "%$LOGPATH%\var\Chocolatey_Version.txt" >> "%$LogPath%\%$LOG%" 
IF %$STATUS_CHOCO% EQU 0 GoTo skipCC
:: Choco not installed
	color 4E
	echo Chocolatey package manager is not installed on this system!
	echo	Required for running this program!
	echo Info: https://chocolatey.org/
	echo.
	echo Install Chocolatey Package Manager?
	choice /C YN /M Select:
	IF %ERRORLEVEL% EQU 2 GoTo end
	IF %ERRORLEVEL% EQU 1 (
		echo Installing Chocolatey...
		@powershell -NoProfile -ExecutionPolicy unrestricted -Command "(iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))) >$null 2>&1" && SET PATH="%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
		)
:: Include variables for current session
if exist "%PROGRAMDATA%\chocolatey" SET "ChocolateyInstall=%PROGRAMDATA%\chocolatey"
if exist "%PROGRAMDATA%\chocolatey\bin" SET "PATH=%PATH%;%PROGRAMDATA%\chocolatey\bin"
choco info 2> nul > "%$LOGPATH%\var\Chocolatey_Version.txt"
type "%$LOGPATH%\var\Chocolatey_Version.txt" >> "%$LogPath%\%$LOG%" 
SET $STATUS_CHOCO=%ERRORLEVEL%
if %$STATUS_CHOCO% NEQ 0 (
	echo something went wrong with the installation or,
	echo something not correct for the current session.
	echo try running the program again!
	echo Aborting!
	echo.
	timeout /60
	goto end
	)
:skipCC
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:::: Main Menu ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:menu
color 8F
CALL :banner
echo Installed:
IF %$STATUS_WSL% EQU 0 wsl --list
echo.
echo.
echo    Main Menu
echo  ---------------
echo  [1] WSL list of installed GNU/Linux Distro's
echo  [2] Install WSL GNU/Linux Distro's
echo  [3] Upgrade WSL GNU/Linux Distro's
echo  [4] Advanced methods
echo  [5] Install/Upgrade Microsoft Windows Terminal
echo  [0] Exit
echo.
Choice /C 123450 /M Select:
IF %ERRORLEVEL% EQU 1 GoTo WSLL
IF %ERRORLEVEL% EQU 2 GoTo install
IF %ERRORLEVEL% EQU 3 GoTo upgrade
IF %ERRORLEVEL% EQU 4 GoTo AM
IF %ERRORLEVEL% EQU 5 GoTo MWT
IF %ERRORLEVEL% EQU 6 GoTo end
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:::: Install WSL GNU/Linux Distro's :::::::::::::::::::::::::::::::::::::::::::
:install
CALL :banner
CALL :HUD

echo Select WSL GNU/Linux Distro to install:
echo  [0] Main Menu
echo  [A] Install ALL!
echo.
Choice /C 12345678A0 /M Select:

:: Alpine
IF %ERRORLEVEL% EQU 1 choco install wsl-alpine /y
::IF EXIST "%ChocolateyInstall%\lib\wsl-alpine\tools\distro\launcher.exe" "%ChocolateyInstall%\lib\wsl-alpine\tools\distro\launcher.exe"
IF %ERRORLEVEL% EQU 2 choco install wsl-archlinux /y
IF %ERRORLEVEL% EQU 3 choco install wsl-debiangnulinux /y
IF %ERRORLEVEL% EQU 4 choco install wsl-kalilinux /y
IF %ERRORLEVEL% EQU 5 choco install wsl-fedoraremix /y
IF %ERRORLEVEL% EQU 6 choco install wsl-opensuse /y
::	SUSE Linux Enterprise Server
IF %ERRORLEVEL% EQU 7 choco install wsl-sles /y
IF %ERRORLEVEL% EQU 8 choco install wsl-ubuntu-2004 /y
::	All
IF %ERRORLEVEL% EQU 9 choco install wsl-alpine wsl-archlinux wsl-debiangnulinux wsl-kalilinux wsl-fedoraremix wsl-opensuse wsl-sles wsl-ubuntu-2004 /y
::	Exit
IF %ERRORLEVEL% EQU 10 GoTo menu

SET $CHOCO_ERR=%ERRORLEVEL%
timeout /t 20
GoTo install
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:upgrade
CALL :banner
CALL :HUD
@powershell Write-Host "Force upgrade is potentially destructive!" -ForegroundColor Yellow 
echo.
echo Select WSL GNU/Linux Distro to Upgrade:
echo  [0] Main menu
echo  [A] Upgrade ALL!
echo.
Choice /C 12345678A0 /M Select:

IF %ERRORLEVEL% EQU 1 choco upgrade wsl-alpine /y
IF %ERRORLEVEL% EQU 2 choco upgrade wsl-archlinux /y
IF %ERRORLEVEL% EQU 3 choco upgrade wsl-debiangnulinux /y
IF %ERRORLEVEL% EQU 4 choco upgrade wsl-kalilinux /y
IF %ERRORLEVEL% EQU 5 choco upgrade wsl-fedoraremix /y
IF %ERRORLEVEL% EQU 6 choco upgrade wsl-opensuse /y
::	SUSE Linux Enterprise Server
IF %ERRORLEVEL% EQU 7 choco upgrade wsl-sles /y
IF %ERRORLEVEL% EQU 8 choco upgrade wsl-ubuntu-2004 /y
::	All
IF %ERRORLEVEL% EQU 9 choco upgrade wsl-alpine wsl-archlinux wsl-debiangnulinux wsl-kalilinux wsl-fedoraremix wsl-opensuse wsl-sles wsl-ubuntu-2004 /y
::	Exit
IF %ERRORLEVEL% EQU 10 GoTo menu
SET $CHOCO_ERR=%ERRORLEVEL%
echo.
timeout /t 20
GoTo upgrade
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::: Adcanced Methods :::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:AM
CALL :banner
call :hud
color 0E
@powershell Write-Host "!UNDER DEVELOPMENT!" -ForegroundColor Yellow
timeout /t 60
GoTo menu


SET $ACTION=install

IF %ERRORLEVEL% EQU 1 choco %$ACTION% wsl-alpine --ignore-checksums /y
IF %ERRORLEVEL% EQU 2 choco %$ACTION% wsl-archlinux --ignore-checksums /y
IF %ERRORLEVEL% EQU 3 choco %$ACTION% wsl-debiangnulinux --ignore-checksums /y
IF %ERRORLEVEL% EQU 4 choco %$ACTION% wsl-kalilinux --ignore-checksums /y
IF %ERRORLEVEL% EQU 5 choco %$ACTION% wsl-fedoraremix --ignore-checksums /y
IF %ERRORLEVEL% EQU 6 choco %$ACTION% wsl-opensuse --ignore-checksums /y
::	SUSE Linux Enterprise Server
IF %ERRORLEVEL% EQU 7 choco %$ACTION% wsl-sles --ignore-checksums /y
IF %ERRORLEVEL% EQU 8 choco %$ACTION% wsl-ubuntu-2004 --ignore-checksums /y
::	All
IF %ERRORLEVEL% EQU 9 choco %$ACTION% wsl-alpine wsl-archlinux wsl-debiangnulinux wsl-kalilinux wsl-fedoraremix wsl-opensuse wsl-sles wsl-ubuntu-2004 --ignore-checksums /y
SET $CHOCO_ERR=%ERRORLEVEL%
timeout /t 20




:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::: Microsoft Windows Terminal::::::::::::::::::::::::::::::::::::::::::::::::
:MWT
CALL :banner
choco upgrade microsoft-windows-terminal /y
timeout /t 20
GoTo menu
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



:end
RD /S /Q "%$LOGPATH%\var"
CALL :banner
IF %$STATUS_WSL% EQU 0 echo. >> "%$LogPath%\%$LOG%"
IF %$STATUS_WSL% EQU 0 echo [WARN]	Convert encoding to UTF-8-BOM! >> "%$LogPath%\%$LOG%"
IF %$STATUS_WSL% EQU 0 echo. >> "%$LogPath%\%$LOG%"
IF %$STATUS_WSL% EQU 0 wsl --list
REM Output encoding needs to be UTF-8-BOM
IF %$STATUS_WSL% EQU 0 wsl --list >> "%$LogPath%\%$LOG%"
echo.
echo. >> "%$LogPath%\%$LOG%"
IF %$STATUS_WSL% EQU 0 wsl --list --verbose
REM Output encoding needs to be UTF-8-BOM
IF %$STATUS_WSL% EQU 0 wsl --list --verbose >> "%$LogPath%\%$LOG%"
echo.
echo. >> "%$LogPath%\%$LOG%"
IF %$ADMIN_STATUS% EQU 1 IF %$STATUS_WSL% EQU 0 timeout /t 60
echo End: %DATE% %TIME% >> "%$LogPath%\%$LOG%"
echo. >> "%$LogPath%\%$LOG%"
exit /B
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::