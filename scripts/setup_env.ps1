# scripts/setup_env.ps1
# Author: Jikai Wang
# Windows PowerShell version

[CmdletBinding()]
param (
    [string]$ConfigFile = "config.json"
)

$ErrorActionPreference = "Stop"

function Log-Message([string]$msg) {
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$ts] $msg"
}

# ------------------------------------------------------------------
# Resolve paths safely
# ------------------------------------------------------------------

# Directory of this script: <proj>/scripts
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Project root: <proj>
$ProjDir = (Resolve-Path (Join-Path $ScriptDir "..")).Path

# Resolve config file:
# - absolute path → use as-is
# - relative path → relative to project root
if (-not [System.IO.Path]::IsPathRooted($ConfigFile)) {
    $ConfigFile = Join-Path $ProjDir $ConfigFile
}

if (-not (Test-Path $ConfigFile)) {
    Write-Error "Config file not found: $ConfigFile"
    exit 1
}

# ------------------------------------------------------------------
# Load config.json
# ------------------------------------------------------------------

$config = Get-Content -Raw $ConfigFile | ConvertFrom-Json

# ------------------------------------------------------------------
# Create directories if they do not exist
# ------------------------------------------------------------------

Log-Message "Creating directories if they do not exist..."
New-Item -ItemType Directory -Force -Path @(
    $config.label_studio_data_dir,
    $config.label_studio_files_dir,
    $config.ml_backend_model_server_dir
) | Out-Null

# ------------------------------------------------------------------
# Write .env file
# ------------------------------------------------------------------

$EnvFile = Join-Path $ProjDir ".env"
Log-Message "Creating or overwriting .env file at $EnvFile"

$lines = @(
    "PROJ_DIR=$ProjDir",
    "LABEL_STUDIO_HOST=http://label-studio:$($config.label_studio_bind_port)",
    "LABEL_STUDIO_USERNAME=$($config.label_studio_username)",
    "LABEL_STUDIO_PASSWORD=$($config.label_studio_password)",
    "LABEL_STUDIO_USER_TOKEN=$($config.label_studio_user_token)",
    "LABEL_STUDIO_IMAGE=$($config.label_studio_image)",
    "LABEL_STUDIO_DATA_DIR=$($config.label_studio_data_dir)",
    "LABEL_STUDIO_FILES_DIR=$($config.label_studio_files_dir)",
    "LABEL_STUDIO_BIND_PORT=$($config.label_studio_bind_port)",
    "ML_BACKEND_SAM1_MODEL_PATH=$($config.ml_backend_sam1_model_path)",
    "ML_BACKEND_SAM2_IMAGE_MODEL_PATH=$($config.ml_backend_sam2_image_model_path)",
    "ML_BACKEND_MODEL_SERVER_DIR=$($config.ml_backend_model_server_dir)",
    "ML_BACKEND_BIND_PORT=$($config.ml_backend_model_bind_port)",
    "SAM_CHOICE=$($config.sam_choice)",
    "LOG_LEVEL=$($config.log_level)"
)

# Write UTF-8 without BOM (important for many tools)
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllLines($EnvFile, $lines, $utf8NoBom)

Log-Message "Environment variables written to .env successfully!"