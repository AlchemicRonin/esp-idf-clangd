@echo off
setlocal EnableExtensions

set "PROJECT_ROOT=%~dp0.."
pushd "%PROJECT_ROOT%" >nul || exit /b 1

where idf.py >nul 2>nul
if not errorlevel 1 goto :configure

set "IDF_EXPORT="
if defined IDF_PATH if exist "%IDF_PATH%\export.bat" set "IDF_EXPORT=%IDF_PATH%\export.bat"
if not defined IDF_EXPORT (
  for /d %%D in ("%USERPROFILE%\.espressif\v*") do (
    if exist "%%D\esp-idf\export.bat" set "IDF_EXPORT=%%D\esp-idf\export.bat"
  )
)
if defined IDF_EXPORT call "%IDF_EXPORT%" >nul

where idf.py >nul 2>nul
if errorlevel 1 (
  echo ESP-IDF was not found. Activate ESP-IDF first, then rerun this script.
  popd
  exit /b 1
)

:configure
idf.py -B build.clang -D IDF_TOOLCHAIN=clang reconfigure
set "STATUS=%ERRORLEVEL%"
popd
exit /b %STATUS%
