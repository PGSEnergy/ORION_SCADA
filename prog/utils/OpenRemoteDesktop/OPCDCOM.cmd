cls
@echo off
echo ****************************************************************
echo File: OPCDCOM.cmd
echo.
echo Description: DCOM settings for server-workplace communication
echo.
echo Usage: "OPCDCOM.cmd" server/workplace [user or group]
echo.
echo Example 1 - DCOM settings for SYS 600 Server for ScOperators group
echo   * "OPCDCOM.cmd" server ScOperators
echo.
echo Example 2 - DCOM settings for SYS 600 Workplace for ScOperators group
echo   * "OPCDCOM.cmd" workplace ScOperators
echo ****************************************************************
rem **************************************************************************
rem Revision History
rem **************************************************************************
rem Rev A 20121015: Initial revision
rem Rev B 20130103: Better error handling + Local access forced for ANONYMOUS LOGON user
rem **************************************************************************
:: Variables to collect command-line parameters
set machine=%1
set userOrGroup=%2
set allArguments=%*

if "%machine%"=="server" goto :RESTART
if "%machine%"=="workplace" goto :RESTART
goto :ERRORNOTARGET

:RESTART
echo INFO: Check if user or group '%userOrGroup%' exists
if "%userOrGroup%"=="" goto :ERRORNOUSER
for /F "tokens=1" %%i in ('"wmic useraccount where name="%userOrGroup%" get sid | find "-""') do SET sidUser=%%i
for /F "tokens=1" %%i in ('"wmic group where name="%userOrGroup%" get sid | find "-""') do SET sidGroup=%%i
if "%sidUser%"=="" (
  if "%sidGroup%"=="" goto :ERRORNOUSER
)
echo INFO: '%userOrGroup%' found
echo.

SET /P KEY=This script configures DCOM settings. Do you want to continue? [Y/N] 
IF /I '%KEY%' EQU 'y' GOTO :RUNCOMMANDS
IF /I '%KEY%' EQU 'n' GOTO :ERRORUSERABORT
goto RESTART

:RUNCOMMANDS
:: backup folder and timestamp
mkdir backup
for /F "tokens=1" %%i in ('"wmic os get localdatetime | find ".""') do SET now=%%i
for /F "tokens=1 delims=." %%f in ("%now%") do SET now=%%f

:: ma = COM Security > Access > Edit Limits
:: da = COM Security > Access > Edit Default
:: ml = COM Security > Launch > Edit Limits
:: dl = COM Security > Launch > Edit Default

echo.
echo.
echo *** Reading current settings ***
echo Access Default
dcomperm.exe -da list
dcomperm.exe -da list >> backup\%now%_%computername%_opcdcom.txt 2>&1
echo.
echo Launch Default
dcomperm.exe -dl list
dcomperm.exe -dl list >> backup\%now%_%computername%_opcdcom.txt 2>&1
echo.
echo Access Limits
dcomperm.exe -ma list
dcomperm.exe -ma list >> backup\%now%_%computername%_opcdcom.txt 2>&1
echo.
echo Launch Limits
dcomperm.exe -ml list
dcomperm.exe -ml list >> backup\%now%_%computername%_opcdcom.txt 2>&1
echo.

if "%machine%"=="server" (
  rem ABB MicroSCADA OPC DA Server
  rem {CE0322A9-65A9-4268-84D5-DD7A17E94C56}
  echo ABB MicroSCADA OPC DA Server - Access
  dcomperm -aa {CE0322A9-65A9-4268-84D5-DD7A17E94C56} list
  dcomperm -aa {CE0322A9-65A9-4268-84D5-DD7A17E94C56} list >> backup\%now%_%computername%_opcdcom.txt 2>&1
  echo.

  echo ABB MicroSCADA OPC DA Server - Launch
  dcomperm -al {CE0322A9-65A9-4268-84D5-DD7A17E94C56} list
  dcomperm -al {CE0322A9-65A9-4268-84D5-DD7A17E94C56} list >> backup\%now%_%computername%_opcdcom.txt 2>&1
  echo.
)
echo *** End of reading ***
echo.
echo *** Configuring DCOM Machine Default and Limits ***
:: COM Security > Edit Limits for Access
:: Remote Access for ANONYMOUS LOGON
::
:: Note: This setting is necessary for OPCEnum.exe to function and for some OPC
:: Servers and Clients that set their DCOM 'Authentication Level' to 'None' in order
:: to allow anonymous connections. If you do not use OPCEnum you may not need
:: to enable remote access for anonymous users.
dcomperm.exe -ma set "ANONYMOUS LOGON" permit level:l,r
echo.

:: COM Security > Edit Limits for Launch
:: Remote Launch and Activation for Everyone
::
:: Note: Since Everyone includes all authenticated users, it is often desirable to
:: add these permissions to a smaller subset of users. One suggested way to
:: accomplish this is to create a group named "OPC Users" and add all user
:: accounts to this group that will execute any OPC Server or Client. Then
:: substitute "OPC Users" everywhere that Everyone appears in these
:: configuration dialogs.
dcomperm.exe -ml set %userOrGroup% permit level:l,r
echo.

:: COM Security > Edit Default for Access
:: Local Allow and Remote Allow for each user or group e.g. "OPC Users"
dcomperm.exe -da set %userOrGroup% permit level:l,r
echo.

:: COM Security > Edit Default for Launch
:: Local Allow and Remote Allow for each user or group e.g. "OPC Users"
dcomperm.exe -dl set %userOrGroup% permit level:l,r
echo.

if "%machine%"=="server" (
  echo *** Configuring DCOM for an individual OPC Server ***
  rem DCOM Config > ABB MicroSCADA OPC DA Server > Customize Access
  rem Local Allow and Remote Allow for each user or group e.g. "OPC Users"
  rem
  rem Note: This setting is necessary for OPCEnum.exe to function and for some OPC
  rem Servers and Clients that set their DCOM 'Authentication Level' to 'None' in order
  rem to allow anonymous connections. If you do not use OPCEnum you may not need
  rem to enable remote access for anonymous users.  
  dcomperm.exe -aa {CE0322A9-65A9-4268-84D5-DD7A17E94C56} set %userOrGroup% permit level:l,r
  echo.

  rem DCOM Config > ABB MicroSCADA OPC DA Server > Customize Launch
  rem Local Allow and Remote Allow for each user or group e.g. "OPC Users"
  dcomperm.exe -al {CE0322A9-65A9-4268-84D5-DD7A17E94C56} set %userOrGroup% permit level:l,r
  echo.
)
echo *** End of configuring ***
GOTO :Success

:ERRORNOTARGET
echo ****************************************************************
echo ERROR: Configuration aborted. See examples above.
echo ERROR: Missing or invalid parameters: %allArguments%
echo.
GOTO :end

:ERRORUSERABORT
echo ****************************************************************
echo INFO: Configuration aborted.
echo INFO: User aborted
echo.
GOTO :end

:ERRORNOUSER
echo ****************************************************************
echo ERROR: User or group missing. See examples above.
echo ERROR: Missing or invalid parameters: %allArguments%
echo.
GOTO :end

:Success
echo ****************************************************************
echo INFO: Configuration finished for %computername%.
:end