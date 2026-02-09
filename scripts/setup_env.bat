@echo off
setlocal EnableDelayedExpansion

REM scripts/setup_env.bat
REM Author: Jikai Wang
REM Windows Batch version

REM -------------------------------------------------------
REM 1. Resolve Paths
REM -------------------------------------------------------

REM Get script directory
set "SCRIPT_DIR=%~dp0"

REM Resolve Project Directory (Parent of script)
pushd "%SCRIPT_DIR%.."
set "PROJ_DIR=%CD%"
popd

REM Convert PROJ_DIR to forward slashes for .env compatibility
set "PROJ_DIR_ENV=%PROJ_DIR:\=/%"

set "CONFIG_FILE=%PROJ_DIR%\config\config.json"
set "ENV_FILE=%PROJ_DIR%\.env"

echo [INFO] Using project root: %PROJ_DIR%
echo [INFO] Using config file:  %CONFIG_FILE%

if not exist "%CONFIG_FILE%" (
    echo [ERROR] Config file not found at: %CONFIG_FILE%
    exit /b 1
)

REM -------------------------------------------------------
REM 2. Load Config (JSON -> Batch Variables)
REM -------------------------------------------------------

echo [INFO] Parsing JSON configuration...

REM We use a temporary helper to convert JSON keys to Batch variables (e.g., set label_studio_username=admin)
set "TEMP_VARS=%SCRIPT_DIR%_temp_config_vars.bat"

powershell -NoProfile -Command "$j=Get-Content '%CONFIG_FILE%'|ConvertFrom-Json; $j.PSObject.Properties | ForEach-Object { Write-Output ('set ' + $_.Name + '=' + $_.Value) }" > "%TEMP_VARS%"

REM Import the variables
if exist "%TEMP_VARS%" (
    call "%TEMP_VARS%"
    del "%TEMP_VARS%"
) else (
    echo [ERROR] Failed to parse configuration.
    exit /b 1
)

REM -------------------------------------------------------
REM 3. Create Directories
REM -------------------------------------------------------

echo [INFO] Creating directories if they do not exist...

REM Helper subroutine to handle path resolution and creation
call :EnsureDir "%label_studio_data_dir%" LABEL_STUDIO_DATA_DIR_ABS
call :EnsureDir "%label_studio_files_dir%" LABEL_STUDIO_FILES_DIR_ABS
call :EnsureDir "%ml_backend_model_server_dir%" ML_BACKEND_MODEL_SERVER_DIR_ABS

REM -------------------------------------------------------
REM 4. Write .env file
REM -------------------------------------------------------

echo [INFO] Creating .env file at %ENV_FILE%

(
    echo PROJ_DIR=!PROJ_DIR_ENV!
    echo LABEL_STUDIO_HOST=http://label-studio:!label_studio_bind_port!
    echo LABEL_STUDIO_USERNAME=!label_studio_username!
    echo LABEL_STUDIO_PASSWORD=!label_studio_password!
    echo LABEL_STUDIO_USER_TOKEN=!label_studio_user_token!
    echo LABEL_STUDIO_IMAGE=!label_studio_image!
    echo LABEL_STUDIO_DATA_DIR=!LABEL_STUDIO_DATA_DIR_ABS!
    echo LABEL_STUDIO_FILES_DIR=!LABEL_STUDIO_FILES_DIR_ABS!
    echo LABEL_STUDIO_BIND_PORT=!label_studio_bind_port!
    echo ML_BACKEND_SAM1_MODEL_PATH=!ml_backend_sam1_model_path!
    echo ML_BACKEND_SAM2_IMAGE_MODEL_PATH=!ml_backend_sam2_image_model_path!
    echo ML_BACKEND_MODEL_SERVER_DIR=!ML_BACKEND_MODEL_SERVER_DIR_ABS!
    echo ML_BACKEND_BIND_PORT=!ml_backend_model_bind_port!
    echo SAM_CHOICE=!sam_choice!
    echo LOG_LEVEL=!log_level!
) > "%ENV_FILE%"

echo [SUCCESS] Environment variables written to .env successfully!
endlocal
exit /b 0


REM -------------------------------------------------------
REM Subroutine: EnsureDir
REM   Arg 1: Relative or Absolute Path
REM   Arg 2: Variable Name to store the final Absolute Path (Forward Slashes)
REM -------------------------------------------------------
:EnsureDir
set "RAW_PATH=%~1"
set "OUT_VAR=%~2"

REM Check if path is empty
if "%RAW_PATH%"=="" exit /b

REM Check if path contains colon (Absolute check like C:\)
REM If not absolute, prepend PROJ_DIR
echo "%RAW_PATH%" | findstr /r "^\"[a-zA-Z]:" >nul
if %errorlevel% neq 0 (
    set "ABS_PATH=%PROJ_DIR%\%RAW_PATH%"
) else (
    set "ABS_PATH=%RAW_PATH%"
)

REM Create directory if missing
if not exist "%ABS_PATH%" (
    echo   + Creating: %ABS_PATH%
    mkdir "%ABS_PATH%" >nul
)

REM Convert backslashes to forward slashes for .env compatibility
set "ABS_PATH_FWD=%ABS_PATH:\=/%"

REM Set the result variable
set "%OUT_VAR%=%ABS_PATH_FWD%"
exit /b
