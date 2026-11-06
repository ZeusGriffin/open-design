@echo off
setlocal
where py >NUL 2>&1
if %ERRORLEVEL% EQU 0 (
  py -3 -m pip install --user esptool
) else (
  python -m pip install --user esptool
)
pause
