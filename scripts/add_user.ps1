# Author: Jikai Wang
# PowerShell version for Windows

param (
    [Parameter(Mandatory = $true)]
    [string]$UserName,

    [string]$Password
)

# Resolve project dir (same idea as bash script)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjDir = Resolve-Path "$ScriptDir\.."

# ==== CONFIG ====
# If you don't have config.json, hard-code here
$DEFAULT_PASSWORD = "label-studio"
# =================

# Email
$UserEmail = "$UserName@gmail.com"

# Password handling
if ([string]::IsNullOrEmpty($Password)) {
    Write-Warning "No password provided. Using default password."
    $UserPassword = $DEFAULT_PASSWORD
} else {
    $UserPassword = $Password
}

# Add user via Python
Write-Host "Adding user $UserEmail ..."
python "$ProjDir\tools\add_user.py" --email $UserEmail --overwrite
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to add user: $UserEmail"
    exit 1
}

# Reset password inside Docker container
Write-Host "Resetting password for $UserEmail ..."
docker exec label-studio `
    label-studio reset_password `
    --username $UserEmail `
    --password $UserPassword

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to reset password: [${UserEmail}:${UserPassword}]"
    exit 1
}

Write-Host "User $UserEmail added and password reset successfully."
