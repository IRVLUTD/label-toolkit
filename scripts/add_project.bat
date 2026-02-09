@echo off
setlocal EnableDelayedExpansion

REM add_project.bat
REM Author: Jikai Wang
REM Batch version for Windows

REM Check if an argument was provided
if "%~1"=="" (
    echo [ERROR] Usage: %0 "Path\To\Scene"
    exit /b 1
)

REM -------------------------------------------------------
REM 1. Resolve Paths
REM -------------------------------------------------------

REM Get the directory of this script (equivalent to $ScriptDir)
set "SCRIPT_DIR=%~dp0"

REM Resolve Project Directory (Parent of Script Directory)
pushd "%SCRIPT_DIR%.."
set "PROJ_DIR=%CD%"
popd

REM Resolve Scene Directory (Input Argument)
REM Check if the folder exists first
if not exist "%~1" (
    echo [ERROR] Scene folder does not exist: %~1
    exit /b 1
)

REM Switch to the scene dir to get its absolute path
pushd "%~1"
set "SCENE_DIR_RESOLVED=%CD%"
popd

REM -------------------------------------------------------
REM 2. Setup Python Script Path
REM -------------------------------------------------------

REM Define path to Python script (tools\add_project.py)
set "ADD_PROJECT_SCRIPT=%PROJ_DIR%\tools\add_project.py"

if not exist "%ADD_PROJECT_SCRIPT%" (
    echo [ERROR] Add project script not found: %ADD_PROJECT_SCRIPT%
    exit /b 1
)

REM -------------------------------------------------------
REM 3. Execution
REM -------------------------------------------------------

echo [INFO] Creating Label Studio project for scene folder: %SCENE_DIR_RESOLVED%

REM Call Python
REM We use quotes around paths to safely handle spaces
python "%ADD_PROJECT_SCRIPT%" --scene_folder "%SCENE_DIR_RESOLVED%"

REM Check the exit code of the Python script
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to add project for %SCENE_DIR_RESOLVED%
    exit /b %ERRORLEVEL%
)

echo [INFO] Project created successfully.
endlocal
