REM Header, changing current directory to current directory
@echo off
cd "%~dp0"
cls

REM Check if the latest log file exists, and creates it if it does not exist
if exist Dump.log (
    attrib -h -r Dump.log
    echo %date:~4,13%  %time:~0,8%  -  Log File existed>Dump.log
    if "%errorlevel%"=="1" cls && echo This Script can only be run in directories that are not Read-Only! && pause && exit
    echo %date:~4,13%  %time:~0,8%  -  Writing to the directory "%~dp0" was successful>>Dump.log
    goto CheckLastStateLog
) else (
    echo %date:~4,13%  %time:~0,8%  -  Log File created>Dump.log
    if "%errorlevel%"=="1" cls && echo This Script can only be run in directories that are not Read-Only! && pause && exit
    echo %date:~4,13%  %time:~0,8%  -  Writing to the directory "%~dp0" was successful>>Dump.log
    goto CheckLastStateLog
)

REM Check if the file storing the last State of the Registry Key exists, and creates it if it does not exist
:CheckLastStateLog
if exist LastState.log (
    echo %date:~4,13%  %time:~0,8%  -  LastState.log existed>>Dump.log
    goto CheckLastState
) else (
    echo %date:~4,13%  %time:~0,8%  -  LastState.log was corrupted>>Dump.log
    >LastState.log echo -1
    if "%errorlevel%"=="1" cls && echo This Script can only be run in directories that are not Read-Only! && pause && exit
    echo %date:~4,13%  %time:~0,8%  -  Successfully created LastState.log with value "-1">>Dump.log
    attrib +h +s +r LastState.log
    goto CheckLastState
)

REM Checking the file storing the last state of the Registry key, whether it was set to 1 or 0, otherwise if -1 will prompt the user to input the current state manually
:CheckLastState
set /p LastState=<LastState.log
if "%LastState%"=="-1" goto UndefinedLastState
if "%LastState%"=="0" goto LastStateInactive
if "%LastState%"=="1" goto LastStateActive

REM Prompts user to tell the Script whether or not Seconds are currently visible in the taskbar
:UndefinedLastState
>>Dump.log echo %date:~4,13%  %time:~0,8%  -  Last State of LastState.log was "%LastState%"
echo The log file was not found and manual user input is required.
echo.
echo Are Seconds currently visible in the Taskbar's Clock?  (Y/N)
set /p "cho=>"
if /I "%cho%"=="Y" goto LastState1
if /I "%cho%"=="N" goto LastState0
goto UndefinedLastState

REM Attempts to write "0" to LastState.log according to user input
:LastState0
set LastState=0
echo %date:~4,13%  %time:~0,8%  -  New variable state is: "%LastState%">>Dump.log
attrib -h -s -r LastState.log
>LastState.log echo 0
if "%errorlevel%"=="1" cls && echo This Script can only be run in directories that are not Read-Only! && pause && exit
echo %date:~4,13%  %time:~0,8%  -  Successfully wrote "0" to LastState.log>>Dump.log
attrib +h +s +r LastState.log
goto LastStateInactive

REM Attempts to write "1" to LastState.log according to user input
:LastState1
set LastState=1
echo %date:~4,13%  %time:~0,8%  -  New variable state is: "%LastState%">>Dump.log
attrib -h -s -r LastState.log
>LastState.log echo 1
if "%errorlevel%"=="1" cls && echo This Script can only be run in directories that are not Read-Only! && pause && exit
echo %date:~4,13%  %time:~0,8%  -  Successfully wrote "1" to LastState.log>>Dump.log
attrib +h +s +r LastState.log
goto LastStateActive

REM Asks the user whether they want to continue before Windows Explorer is restarted
:LastStateActive
cls
echo The next step will deactivate the Seconds shown in System Clock.
echo Doing this will restart the Windows Explorer.
echo Do you want to continue? (Y/N)
set /p "cho=>"
if /I "%cho%"=="Y" goto DeactivateSeconds
if /I "%cho%"=="N" goto ContinueWithoutChanging
exit

REM Asks the user whether they want to continue before Windows Explorer is restarted
:LastStateInactive
cls
echo The next step will activate the Seconds shown in System Clock.
echo Doing this will restart the Windows Explorer.
echo Do you want to continue? (Y/N)
set /p "cho=>"
if /I "%cho%"=="Y" goto ActivateSeconds
if /I "%cho%"=="N" goto ContinueWithoutChanging
exit

REM Changes Registry Key and restarts Windows Explorer
:DeactivateSeconds
set LastState=0
echo %date:~4,13%  %time:~0,8%  -  New variable state is: "%LastState%">>Dump.log
attrib -h -s -r LastState.log
>LastState.log echo 0
if "%errorlevel%"=="1" cls && echo This Script can only be run in directories that are not Read-Only! && pause && exit
echo %date:~4,13%  %time:~0,8%  -  Successfully wrote "0" to LastState.log>>Dump.log
attrib +h +s +r LastState.log
attrib +h +r Dump.log
cls
reg add HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowSecondsInSystemClock /t REG_DWORD /d 0 /f
if "%errorlevel%"=="1" (
    attrib -h -r Dump.log
    echo %date:~4,13%  %time:~0,8%  -  The Registry Key could not be changed "0x%errorlevel%">>Dump.log
) else if "%errorlevel%"=="0" (
    attrib -h -r Dump.log
    echo %date:~4,13%  %time:~0,8%  -  The Registry Key was successfully changed "0x%errorlevel%">>Dump.log
    echo %date:~4,13%  %time:~0,8%  -  Script ran successfully!>>Dump.log
    attrib +h +r Dump.log
)
taskkill /F /IM explorer.exe
start explorer
exit

REM Changes Registry Key and restarts Windows Explorer
:ActivateSeconds
set LastState=1
echo %date:~4,13%  %time:~0,8%  -  New variable state is: "%LastState%">>Dump.log
attrib -h -s -r LastState.log
>LastState.log echo 1
if "%errorlevel%"=="1" cls && echo This Script can only be run in directories that are not Read-Only! && pause && exit
echo %date:~4,13%  %time:~0,8%  -  Successfully wrote "1" to LastState.log>>Dump.log
attrib +h +s +r LastState.log
attrib +h +r Dump.log
cls
reg add HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowSecondsInSystemClock /t REG_DWORD /d 1 /f
if "%errorlevel%"=="1" (
    attrib -h -r Dump.log
    echo %date:~4,13%  %time:~0,8%  -  The Registry Key could not be changed "0x%errorlevel%">>Dump.log
) else if "%errorlevel%"=="0" (
    attrib -h -r Dump.log
    echo %date:~4,13%  %time:~0,8%  -  The Registry Key was successfully changed "0x%errorlevel%">>Dump.log
    echo %date:~4,13%  %time:~0,8%  -  Script ran successfully!>>Dump.log
    attrib +h +r Dump.log
)
taskkill /F /IM explorer.exe
start explorer
exit

REM Does not change Registry Key and exits the script without restarting Windows Explorer
:ContinueWithoutChanging
echo %date:~4,13%  %time:~0,8%  -  Last variable state was not changed: "%LastState%">>Dump.log
echo %date:~4,13%  %time:~0,8%  -  Script ran successfully!>>Dump.log
attrib +h +r Dump.log
cls
echo The Script was ended without taking changes to the System.
echo You can now safely close this Window by either pressing the X-Button at the top or pressing any key.
pause>nul
exit