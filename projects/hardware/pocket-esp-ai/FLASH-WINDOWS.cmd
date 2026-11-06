@echo off
setlocal
cd /d "%~dp0"
where py >NUL 2>&1
if %ERRORLEVEL% EQU 0 (
  py -3 flash_pocket_ai.py %*
) else (
  where python >NUL 2>&1
  if %ERRORLEVEL% EQU 0 (
    python flash_pocket_ai.py %*
  ) else (
    echo Install Python 3 from python.org then rerun.
    exit /b 1
  )
)
set "CODE=%ERRORLEVEL%"
if not "%CODE%"=="0" echo Flash cancelled or failed. Review the error above.
pause
exit /b %CODE%
