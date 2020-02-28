@echo off
rem set local ENABLEDELAYEDEXPANSION

cd /d %~dp0
set BASE_PATH=%cd%
echo "BASE_PATH is %BASE_PATH%."

wmic /? >> null || echo "wmic not found." && echo 'quit'

for /f %%i in ( 'wmic os get LocalDateTime /value' ) do (
    echo "%%i" | findstr "LocalDateTime" > null && set DT=%%i
)
set DT=%DT:~14,14%
rem echo "%DT%"
