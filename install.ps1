<#
.SYNOPSIS
    Trismegistus Installation Script (Windows/PowerShell)
.DESCRIPTION
    Installs Trismegistus - the Multi-Oracle Agentic Orchestrator
.PARAMETER InstallPath
    Where to install Trismegistus (default: ~/.trismegistus)
.PARAMETER SkipProfile
    Don't modify PowerShell profile
.PARAMETER Force
    Overwrite existing installation
#>
param(
    [string]$InstallPath = "",
    [switch]$SkipProfile,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

# Banner
Write-Host @"

  ___________      .__                                .__          __                
  \__    ___/______|__| ______ _____   ____   _____ |__|  ______/  |_ __ __  ______
    |    |  \_  __ \  |/  ___//     \_/ __ \ / ___\ |  | /  ___/\   __\  |  \/  ___/
    |    |   |  | \/  |\___ \|  Y Y  \  ___// /_/  >|  | \___ \  |  | |  |  /\___ \ 
    |____|   |__|  |__/____  >__|_|  /\___  >___  / |__|/____  > |__| |____//____  >
                           \/      \/     \/_____/           \/                  \/ 

                              I N S T A L L E R   v1.0

"@ -ForegroundColor Magenta

# Determine install path
if (!$InstallPath) {
    if ($IsWindows -or $env:OS -match "Windows") {
        $InstallPath = Join-Path $env:USERPROFILE ".trismegistus"
    } else {
        $InstallPath = Join-Path $env:HOME ".trismegistus"
    }
}

Write-Host "[1/5] Checking prerequisites..." -ForegroundColor Cyan

# Check PowerShell version
$psVersion = $PSVersionTable.PSVersion
if ($psVersion.Major -lt 7) {
    Write-Host ""
    Write-Host "  ERROR: PowerShell 7+ required (current: $psVersion)" -ForegroundColor Red
    Write-Host ""
    Write-Host "  Install from: https://aka.ms/powershell" -ForegroundColor Yellow
    Write-Host "  Or run: winget install Microsoft.PowerShell" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}
Write-Host "  [OK] PowerShell $psVersion" -ForegroundColor Green

# Show profile path for debugging
$debugProfilePath = if ($PROFILE.CurrentUserAllHosts) { $PROFILE.CurrentUserAllHosts } elseif ($PROFILE) { $PROFILE } else { "(not set)" }
Write-Host "  [OK] Profile: $debugProfilePath" -ForegroundColor Green

# Check Git
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "  [X] Git not found" -ForegroundColor Red
    exit 1
}
Write-Host "  [OK] Git installed" -ForegroundColor Green

# Check for at least one AI CLI
$hasOracle = $false
$oracles = @("claude", "gemini", "ollama", "openai", "codex")
foreach ($oracle in $oracles) {
    if (Get-Command $oracle -ErrorAction SilentlyContinue) {
        Write-Host "  [OK] $oracle CLI found" -ForegroundColor Green
        $hasOracle = $true
    }
}

if (!$hasOracle) {
    Write-Host ""
    Write-Host "  WARNING: No AI CLIs detected!" -ForegroundColor Yellow
    Write-Host "  Install at least one:" -ForegroundColor Yellow
    Write-Host "    - claude:  npm install -g @anthropic-ai/claude-cli" -ForegroundColor Gray
    Write-Host "    - gemini:  npm install -g @google/gemini-cli" -ForegroundColor Gray
    Write-Host "    - ollama:  https://ollama.ai" -ForegroundColor Gray
    Write-Host ""
    $continue = Read-Host "Continue anyway? (y/n)"
    if ($continue -ne "y") { exit 0 }
}

Write-Host ""
Write-Host "[2/5] Installing to: $InstallPath" -ForegroundColor Cyan

# Check existing installation
if ((Test-Path $InstallPath) -and !$Force) {
    Write-Host "  Existing installation found." -ForegroundColor Yellow
    $overwrite = Read-Host "  Overwrite? (y/n)"
    if ($overwrite -ne "y") { exit 0 }
}

# Create install directory
if (Test-Path $InstallPath) {
    Remove-Item $InstallPath -Recurse -Force
}
New-Item -ItemType Directory -Path $InstallPath -Force | Out-Null

# Copy files
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$folders = @("core", "themes", "templates", "config")
foreach ($folder in $folders) {
    $src = Join-Path $scriptDir $folder
    if (Test-Path $src) {
        Copy-Item $src (Join-Path $InstallPath $folder) -Recurse -Force
        Write-Host "  [OK] Copied $folder/" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "[3/5] Setting environment variables..." -ForegroundColor Cyan

# Set environment variables
[Environment]::SetEnvironmentVariable("TRIS_ROOT", $InstallPath, "User")
[Environment]::SetEnvironmentVariable("TRIS_TEMPLATES", (Join-Path $InstallPath "templates"), "User")

$env:TRIS_ROOT = $InstallPath
$env:TRIS_TEMPLATES = Join-Path $InstallPath "templates"

Write-Host "  [OK] TRIS_ROOT = $InstallPath" -ForegroundColor Green
Write-Host "  [OK] TRIS_TEMPLATES = $env:TRIS_TEMPLATES" -ForegroundColor Green

Write-Host ""
Write-Host "[4/5] Configuring PowerShell profile..." -ForegroundColor Cyan

if (!$SkipProfile) {
    # Use $PROFILE directly - it's always correct for the current shell
    $profilePath = $PROFILE
    
    if (!$profilePath) {
        Write-Host "  [!] Could not determine profile path" -ForegroundColor Yellow
        Write-Host "  You'll need to add the sourcing line manually." -ForegroundColor Yellow
    } else {
        Write-Host "  Profile: $profilePath" -ForegroundColor Gray
        
        # Create profile directory if needed
        $profileDir = Split-Path -Parent $profilePath
        if (!(Test-Path $profileDir)) {
            Write-Host "  Creating directory: $profileDir" -ForegroundColor Gray
            New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
        }
        
        # The line we add to user's profile - just sources our file
        $trisProfilePath = Join-Path $InstallPath "core\profile.ps1"
        $sourceLine = ". `"$trisProfilePath`"  # Trismegistus"
        
        try {
            $existingContent = ""
            if (Test-Path $profilePath) {
                $existingContent = Get-Content $profilePath -Raw -ErrorAction SilentlyContinue
            }
            
            # Check if already installed
            if ($existingContent -and $existingContent -match "Trismegistus") {
                Write-Host "  Already configured in profile. Updating..." -ForegroundColor Yellow
                # Remove old Trismegistus lines (could be multi-line block or single line)
                $existingContent = $existingContent -replace "(?m)^.*Trismegistus.*\r?\n?", ""
                $existingContent = $existingContent -replace "(?s)# =+\r?\n# TRISMEGISTUS.*?# =+\r?\n?", ""
                $existingContent = $existingContent.TrimEnd()
            }
            
            # Append our single line
            if ($existingContent) {
                $newContent = $existingContent + "`n`n" + $sourceLine
            } else {
                $newContent = $sourceLine
            }
            
            Set-Content $profilePath $newContent -Encoding UTF8
            
            # Verify
            if ((Get-Content $profilePath -Raw) -match "Trismegistus") {
                Write-Host "  [OK] Added to: $profilePath" -ForegroundColor Green
            } else {
                throw "Verification failed"
            }
        } catch {
            Write-Host "  [X] Failed to update profile: $_" -ForegroundColor Red
            Write-Host ""
            Write-Host "  MANUAL SETUP - Add this line to your profile:" -ForegroundColor Yellow
            Write-Host "  $sourceLine" -ForegroundColor Cyan
            Write-Host ""
        }
    }
} else {
    Write-Host "  Skipped (--SkipProfile)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[5/5] Finalizing..." -ForegroundColor Cyan

# Create default config if it doesn't exist
$configPath = Join-Path $InstallPath "config.json"
if (!(Test-Path $configPath)) {
    @{
        default = "claude"
        theme = "hermetic"
        routing = @{}
        providers = @{
            claude = @{ enabled = $true; model = "claude-sonnet-4-20250514" }
            gemini = @{ enabled = $false; model = "gemini-2.5-pro" }
            ollama = @{ enabled = $false; model = "llama3.2" }
            openai = @{ enabled = $false; model = "gpt-4o" }
        }
        preferences = @{
            protectedBranches = @("main", "master", "production")
            maxContextFiles = 3000
            lessonsWarnThreshold = 100
        }
    } | ConvertTo-Json -Depth 10 | Set-Content $configPath -Encoding UTF8
    Write-Host "  [OK] Created default configuration" -ForegroundColor Green
}

Write-Host "  [OK] Installation complete!" -ForegroundColor Green

# Done
Write-Host @"

+========================================================================+
|                    INSTALLATION COMPLETE                               |
+========================================================================+

  Next steps:

  1. Reload your PowerShell session:
     . `$PROFILE

  2. Run first-time setup:
     ai-setup

  3. Or jump straight in:
     cd your-project
     ai-init
     ai-plan "Your first task"

  4. View all commands:
     ai-help

  "As above, so below; as within, so without."

"@ -ForegroundColor Cyan
