@echo off
setlocal EnableDelayedExpansion

if "%target_platform%"=="win-arm64" (
    rem GNU make's build_w32.bat defaults to MSVC when gcc is not requested.
    rem conda-forge already puts ARM64 cl.exe on PATH; do not pass gcc (MinGW).
    call build_w32.bat --without-guile
    if errorlevel 1 exit 1
    set "MAKE_EXE=.\WinRel\gnumake.exe"
) else (
    call build_w32.bat gcc
    if errorlevel 1 exit 1
    set "MAKE_EXE=.\GccRel\gnumake.exe"
)

copy %MAKE_EXE% %LIBRARY_BIN%\gnumake.exe
if errorlevel 1 exit 1

copy %MAKE_EXE% %LIBRARY_BIN%\make.exe
if errorlevel 1 exit 1

copy %MAKE_EXE% %LIBRARY_BIN%\mingw32-make.exe
if errorlevel 1 exit 1
