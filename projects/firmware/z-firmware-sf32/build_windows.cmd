@echo off
setlocal
if not defined SIFLI_SDK (
  echo ERROR: SIFLI_SDK environment missing.
  echo Open the official SiFli SDK command environment by running set_env.bat
  echo then run this script from that same Command Prompt.
  exit /b 1
)
set "WORK=%~dp0vendor\T-Display-SF32\examples\menu_app\project"
if not exist "%WORK%\SConstruct" (
  echo ERROR: Missing firmware project. Run prepare_windows.ps1 first.
  exit /b 1
)
where scons >nul 2>&1
if errorlevel 1 (
  echo ERROR: scons is unavailable in this environment. Follow the official SDK setup.
  exit /b 1
)
pushd "%WORK%"
call scons --board=t-display-sf32_hcpu -j8
if errorlevel 1 (
  echo Build FAILED. Nothing has been flashed.
  popd
  exit /b 1
)
echo Build completed. Not flashing automatically.
echo Generated official flash script (after build):
echo   %WORK%\build_t-display-sf32_hcpu\uart_download.bat
popd
endlocal
