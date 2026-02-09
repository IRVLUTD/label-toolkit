@echo off
setlocal

REM add_user.bat
REM Author: Jikai Wang
REM Batch version for Windows

REM -------------------------------------------------------
REM 1. Argument Parsing
REM -------------------------------------------------------

REM Check if UserName (Arg 1) is provided
if "%~1"=="" (
    echo [ERROR] Usage: %0 UserName [Password]
    echo Example: %0 jikai MySecretPassword
    exit /b 1
)

set "USER_NAME=%~1"
set "USER_EMAIL=%USER_NAME%@gmail.com"

REM Check if Password (Arg 2) is provided
REM %~2 removes quotes from the argument if present
set "USER_PASSWORD=%~2"

if "%USER_PASSWORD%"=="" (
    echo [WARN] No password provided. Using default: label-studio
    set "USER_PASSWORD=label-studio"
)

REM -------------------------------------------------------
REM 2. Resolve Paths
REM -------------------------------------------------------

REM Get script directory (ends in backslash)
set "SCRIPT_DIR=%~dp0"

REM Resolve Project Directory (Parent of Script Directory)
pushd "%SCRIPT_DIR%.."
set "PROJ_DIR=%CD%"
popd

set "ADD_USER_SCRIPT=%PROJ_DIR%\tools\add_user.py"

if not exist "%ADD_USER_SCRIPT%" (
    echo [ERROR] Script not found: %ADD_USER_SCRIPT%
    exit /b 1
)

REM -------------------------------------------------------
REM 3. Execution
REM -------------------------------------------------------

echo [INFO] Adding user %USER_EMAIL% ...

REM Run Python script
REM Use quotes around script path and email to be safe
python "%ADD_USER_SCRIPT%" --email "%USER_EMAIL%" --overwrite

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to add user: %USER_EMAIL%
    exit /b %ERRORLEVEL%
)

echo [INFO] Resetting password for %USER_EMAIL% ...

REM Reset password inside Docker
REM We quote the password variable to handle spaces or special characters safely
docker exec label-studio label-studio reset_password --username "%USER_EMAIL%" --password "%USER_PASSWORD%"

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to reset password for %USER_EMAIL%
    exit /b %ERRORLEVEL%
)

echo [SUCCESS] User %USER_EMAIL% added and password reset successfully.
endlocal
