@echo off
rem set local ENABLEDELAYEDEXPANSION

wmic /? >> null || echo "wmic not found." && echo 'quit'

for /f %%i in ( 'wmic os get LocalDateTime /value' ) do (
    echo "%%i" | findstr "LocalDateTime" > null && set DT=%%i
)
set DT=%DT:~14,14%
rem echo "%DT%"
