@echo off
title All-in-One Windows Batch Toolkit
color 0A

:MENU
cls
echo ================================
echo       WINDOWS TOOLKIT MENU
echo ================================
echo 1. Clear Temp Files
echo 2. Run Disk Cleanup
echo 3. Backup Documents
echo 4. Show System Info
echo 5. List Installed Programs
echo 6. Generate Battery Report
echo 7. Open Websites
echo 8. Log Login Time
echo 9. Rename Files in Folder
echo 10. Check Internet Connection
echo 11. Lock Folder (Coming Soon)
echo 12. Delete Old Files
echo 13. Create Dated Folder
echo 14. Zip Folder (Requires PowerShell)
echo 15. Matrix Effect
echo 16. Simulate Typing
echo 17. Show System Uptime
echo 0. Exit
echo ================================
set /p choice=Enter your choice:

if "%choice%"=="1" goto CLEARTEMP
if "%choice%"=="2" start cleanmgr & goto MENU
if "%choice%"=="3" goto BACKUPDOCS
if "%choice%"=="4" systeminfo > %USERPROFILE%\Desktop\systeminfo.txt & echo Info saved to Desktop & pause & goto MENU
if "%choice%"=="5" wmic product get name > %USERPROFILE%\Desktop\installed_programs.txt & echo Saved to Desktop & pause & goto MENU
if "%choice%"=="6" powercfg /batteryreport /output "%USERPROFILE%\Desktop\battery_report.html" & echo Battery report saved & pause & goto MENU
if "%choice%"=="7" start https://www.google.com & start https://github.com & start https://www.youtube.com & goto MENU
if "%choice%"=="8" echo %USERNAME% logged in at %DATE% %TIME% >> %USERPROFILE%\login_log.txt & echo Logged & pause & goto MENU
if "%choice%"=="9" goto RENAMEFILES
if "%choice%"=="10" ping google.com > nul && echo Online || echo Offline & pause & goto MENU
if "%choice%"=="11" echo Coming Soon! & pause & goto MENU
if "%choice%"=="12" forfiles /p "%USERPROFILE%\Downloads" /s /m *.* /d -30 /c "cmd /c del @path" & echo Old files deleted. & pause & goto MENU
if "%choice%"=="13" set foldername=%DATE:~-4%-%DATE:~4,2%-%DATE:~7,2% & mkdir "%USERPROFILE%\Documents\%foldername%" & echo Folder created. & pause & goto MENU
if "%choice%"=="14" powershell Compress-Archive -Path "%USERPROFILE%\Documents" -DestinationPath "%USERPROFILE%\Desktop\Documents.zip" & echo Folder zipped. & pause & goto MENU
if "%choice%"=="15" goto MATRIX
if "%choice%"=="16" goto SIMULATETYPE
if "%choice%"=="17" net stats workstation | find "Statistics since" & pause & goto MENU
if "%choice%"=="0" exit
goto MENU

:CLEARTEMP
del /q /f /s %TEMP%\*
echo Temp files deleted.
pause
goto MENU

:BACKUPDOCS
xcopy "%USERPROFILE%\Documents" "%USERPROFILE%\Desktop\Documents_Backup" /s /e /y
echo Documents backed up to Desktop.
pause
goto MENU

:RENAMEFILES
setlocal enabledelayedexpansion
set i=1
cd /d "%USERPROFILE%\Documents"
for %%f in (*.*) do (
  ren "%%f" "File_!i!%%~xf"
  set /a i=!i!+1
)
echo Files renamed.
pause
goto MENU

:MATRIX
color 0A
:loop
echo %random%%random%%random%%random%%random%
goto loop

:SIMULATETYPE
cls
set message=Hello, this is being typed...
for /l %%i in (0,1,30) do (
    set /p="!message:~%%i,1!" <nul
    ping -n 1 localhost >nul
)
echo.
pause
goto MENU
