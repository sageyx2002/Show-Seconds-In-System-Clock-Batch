# Show-Seconds-In-System-Clock-Batch

The Main File (UI.bat) is the main executable.
The first execution of this script, will ask the User to define, whether or not seconds are currently visible in the clock, located in the Taskbar.
This choice will be saved in a file called "LastState.log". This file has the Hidden, Read-Only and System flag, as messing with this file could disturb or otherwise alter the functionality of this script. It is not advised, to resave, or edit this file in any way.

A general log file (Dump.log) is created as well. This usually has a Read-Only and Hidden flag, but if the script wasn't executed properly, it normally is visible, and provides extensive log information about what may have been the issue. Both files can be made visible with the "FlagEditor.bat" file, so they can be removed in case the user intends to delete the script and it's corresponding files. This can also be done manually, by executing the commands `attrib -r -s -h LastState.log` and `attrib -r -h Dump.log` in the script's directory.

This Script was Tested on Windows 10 21H1 19043.1889
This Script should execute, but will have no effect on Windows 11 as of now, as Microsoft removed the functionality of the Registry Key.

This Script works by adding key `ShowSecondsInSystemClock` in `HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced` in the Registry, adding REG_DWORD 1, or 0 respectively to either show or hide the seconds in the Taskbar's clock, and restarting the windows explorer (explorer.exe) afterwards to make changes visible.
The Script will prompt the user before restarting the explorer, whether or not they want to continue, as closing the explorer will close every explorer.exe related window. If the user decides to not restart the explorer and change the registry key yet, the previous settings will be saved, in case `LastState.log` was not found, to make executing the script again easier.
