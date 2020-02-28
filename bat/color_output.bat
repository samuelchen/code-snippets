@echo off

SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)

rem echo say the name of the colors, don't read
:start
rem cls

echo.
echo color table
call :ColorText 0a " 0a "
call :ColorText 0b " 0b "
call :ColorText 0C " 0c "
call :ColorText 0d " 0d "
call :ColorText 0e " 0e "
call :ColorText 0f " 0f "
call :ColorText 01 " 01 "
call :ColorText 02 " 02 "
call :ColorText 03 " 03 "
call :ColorText 04 " 04 "
call :ColorText 05 " 05 "
call :ColorText 06 " 06 "
call :ColorText 07 " 07 "
call :ColorText 08 " 08 "
call :ColorText 09 " 09 "
call :ColorText 00 " 00 "

echo.
echo.

echo fore-ground + background color
call :ColorText 19 " 19-yellow "
call :ColorText 2F " 2F-black "
call :ColorText 4e " 4E-white "

echo.
echo.

echo clear


call :Info "[info] this is information."
call :Error "[error] an error message."
call :Debug "[debug] trace log."

goto :eof


rem ---------- functions ----------

:Debug
call :ColorText 08 "%~1"
echo.
goto :eof

:Info
call :ColorText 0b "%~1"
echo.
goto :eof

:Error
call :ColorText 0c "%~1"
echo.
goto :eof


:ColorText
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
goto :eof
