@echo off
rem set local ENABLEDELAYEDEXPANSION

wmic /? >> nul|| echo "wmic not found." && echo 'quit'

for /f %%i in ( 'wmic os get LocalDateTime /value' ) do (
    echo "%%i" | findstr "LocalDateTime" > nul && set DT=%%i
)
set DT=%DT:~14,14%
rem echo "%DT%"
