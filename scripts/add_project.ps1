# add_project.ps1
# Author: Jikai Wang
# PowerShell version for Windows

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$SceneDir
)

# Resolve project dir (repo root assumed to be parent of scripts/)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjDir = Resolve-Path (Join-Path $ScriptDir "..")

function Log-Message($msg) { Write-Host "[INFO] $msg" }
function Log-Warning($msg) { Write-Warning $msg }
function Log-ErrorAndExit($msg, [int]$code = 1) { Write-Error $msg; exit $code }

# Normalize scene path
try {
    $SceneDirResolved = Resolve-Path $SceneDir -ErrorAction Stop
    $SceneDirResolved = $SceneDirResolved.Path
} catch {
    Log-ErrorAndExit "Scene folder does not exist: $SceneDir"
}

# NOTE: chmod/sudo has no direct Windows equivalent.
# On Windows, permissions are controlled by NTFS ACLs, and Docker Desktop typically handles volume permissions.
Log-Message "Windows detected: skipping chmod -R 777 (not applicable on NTFS)."

# If you REALLY need to grant write permission broadly, you can uncomment the icacls line below.
# WARNING: This grants full control to Everyone recursively.
# Log-Message "Granting full control to Everyone recursively (icacls)..."
# icacls $SceneDirResolved /grant "*S-1-1-0:(OI)(CI)F" /T | Out-Null

# Add project (call your python entrypoint)
# Your bash script called: python "${PROJ_DIR}/scripts/add_project.shy" --scene_folder "${SCENE_DIR}"
# Keeping the same behavior here.
$AddProjectScript = Join-Path $ProjDir "tools\add_project.py"

if (-not (Test-Path $AddProjectScript)) {
    Log-ErrorAndExit "Add project script not found: $AddProjectScript"
}

Log-Message "Creating Label Studio project for scene folder: $SceneDirResolved"
python $AddProjectScript --scene_folder $SceneDirResolved
if ($LASTEXITCODE -ne 0) {
    Log-ErrorAndExit "Failed to add project for $SceneDirResolved"
}

Log-Message "Project created successfully."
