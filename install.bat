@echo off
setlocal EnableExtensions

set "PIPELINE_ROOT=%~dp0"
set "TARGET_ROOT=%~dp0.."
if not "%~1"=="" set "TARGET_ROOT=%~f1"

for %%I in ("%TARGET_ROOT%") do set "TARGET_ROOT=%%~fI"

call :copy_if_missing "%PIPELINE_ROOT%template\.clangd" "%TARGET_ROOT%\.clangd"
call :copy_if_missing "%PIPELINE_ROOT%template\reconfigure-clang.sh" "%TARGET_ROOT%\scripts\reconfigure-clang.sh"
call :copy_if_missing "%PIPELINE_ROOT%template\reconfigure-clang.bat" "%TARGET_ROOT%\scripts\reconfigure-clang.bat"
call :copy_if_missing "%PIPELINE_ROOT%template\tasks.json" "%TARGET_ROOT%\.vscode\tasks.json"
call :copy_if_missing "%PIPELINE_ROOT%template\c_cpp_properties.json" "%TARGET_ROOT%\.vscode\c_cpp_properties.json"

findstr /x /c:"build.clang/" "%TARGET_ROOT%\.gitignore" >nul 2>nul
if errorlevel 1 (
  >>"%TARGET_ROOT%\.gitignore" echo.
  >>"%TARGET_ROOT%\.gitignore" echo build.clang/
  echo Added build.clang/ to %TARGET_ROOT%\.gitignore
)

echo Run %TARGET_ROOT%\scripts\reconfigure-clang.bat to generate the clang database.
exit /b 0

:copy_if_missing
if exist "%~2" (
  fc /b "%~1" "%~2" >nul
  if errorlevel 1 echo Not overwritten; merge manually: %~2
  if not errorlevel 1 echo Unchanged: %~2
  exit /b 0
)

for %%I in ("%~dp2.") do if not exist "%%~fI" mkdir "%%~fI"
copy /y "%~1" "%~2" >nul
echo Installed: %~2
exit /b 0
