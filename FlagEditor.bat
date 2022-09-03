@echo off
:main
cls
title Flag Editor
echo Choose an action, by typing the corresponding number and pressing Enter
echo This Window will close, and you may need to refresh (F5) for changes to apply
echo It is recommended not to change or resave LastState.log, unless you want to delete it.
echo.
echo 1) Remove Flags
echo 2) Add Flags
set /p "in=>"
if "%in%"=="1" goto 1
if "%in%"=="2" goto 2
goto main

:1
attrib -h -r Dump.log
attrib -h -s -r LastState.log
exit

:2
attrib +h +r Dump.log
attrib +h +s +r LastState.log
exit
