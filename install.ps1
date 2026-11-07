# ============================================
# Dotfiles Installer (Windows / PowerShell) — PowerShell profile, Neovim
# Counterpart of install.sh. Neovim setup is delegated to neovim.config\install.ps1
# ============================================

$ErrorActionPreference = 'Stop'
$DotfilesDir = $PSScriptRoot

Write-Host ""
Write-Host "  ========================================" -ForegroundColor Cyan
Write-Host "            dotfiles installer" -ForegroundColor Cyan
Write-Host "    PowerShell profile · Neovim" -ForegroundColor Cyan
Write-Host "  ========================================" -ForegroundColor Cyan
Write-Host "  Dotfiles: $DotfilesDir" -ForegroundColor Cyan
Write-Host ""

function Test-Command { param($Command) $null -ne (Get-Command $Command -ErrorAction SilentlyContinue) }

function Ask-YN {
    param([string]$Prompt)
    $answer = Read-Host "  $Prompt [Y/n]"
    return ($answer -eq '' -or $answer -match '^[Yy]')
}

# ─── Helper: create symlink, backing up anything already there ───────────────
function Link-Item {
    param([string]$Source, [string]$Destination)

    $dir = Split-Path $Destination -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }

    $existing = Get-Item $Destination -Force -ErrorAction SilentlyContinue
    if ($existing) {
        if ($existing.LinkType -eq 'SymbolicLink' -and ($existing.Target -contains $Source)) {
            Write-Host "  [ok] $Destination (already linked)" -ForegroundColor Green
            return
        }
        if ($existing.LinkType -eq 'SymbolicLink') {
            Write-Host "  Removing old symlink: $Destination" -ForegroundColor Yellow
            Remove-Item $Destination -Force
        } else {
            $backup = "$Destination.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
            Write-Host "  Backing up $Destination -> $backup" -ForegroundColor Yellow
            Move-Item $Destination $backup -Force
        }
    }

    try {
        New-Item -ItemType SymbolicLink -Path $Destination -Target $Source -ErrorAction Stop | Out-Null
        Write-Host "  [linked] $Destination" -ForegroundColor Green
        Write-Host "         -> $Source" -ForegroundColor Cyan
    } catch {
        Copy-Item $Source $Destination -Force
        Write-Host "  [copied] $Destination (symlinks need Admin or Developer Mode; edits to the repo will not propagate)" -ForegroundColor Yellow
    }
}

# ─── Component selection ─────────────────────────────────────────────────────
Write-Host "Which components do you want to install?" -ForegroundColor White
Write-Host ""

$InstallProfile = Ask-YN "PowerShell profile (+ oh-my-posh theme)"
$InstallNvim    = Ask-YN "Neovim (runs neovim.config\install.ps1)"
Write-Host ""

# ─── Prerequisite checks ─────────────────────────────────────────────────────
Write-Host "Checking prerequisites..." -ForegroundColor White
$missing = @()
function Check-Cmd($cmd, $label) {
    if (Test-Command $cmd) { Write-Host "  [ok] $label" -ForegroundColor Green }
    else { Write-Host "  [!!] $label not found" -ForegroundColor Red; $script:missing += $label }
}
if ($InstallProfile -or $InstallNvim) { Check-Cmd git "git" }
if ($InstallNvim)                     { Check-Cmd nvim "neovim" }

if ($missing.Count -gt 0) {
    Write-Host ""
    Write-Host "Missing: $($missing -join ', ')" -ForegroundColor Red
    Write-Host "  winget install Git.Git Neovim.Neovim" -ForegroundColor Cyan
    exit 1
}
Write-Host ""

# ─── PowerShell profile ──────────────────────────────────────────────────────
if ($InstallProfile) {
    Write-Host "Setting up PowerShell profile..." -ForegroundColor White
    Write-Host "  PSReadLine, posh-git, Terminal-Icons install themselves on first shell start." -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Linking:"

    Link-Item (Join-Path $DotfilesDir "Microsoft.PowerShell_profile.ps1") $PROFILE.CurrentUserAllHosts
    Link-Item (Join-Path $DotfilesDir "config\oh-my-posh\theme.toml") (Join-Path $HOME ".config\oh-my-posh\theme.toml")

    if (-not (Test-Command oh-my-posh)) {
        Write-Host "  [!] oh-my-posh not found: winget install JanDeDobbeleer.OhMyPosh" -ForegroundColor Yellow
    }
    if (-not (Test-Command fnm)) {
        Write-Host "  [!] fnm not found (nvm replacement): winget install Schniz.fnm" -ForegroundColor Yellow
    }
    Write-Host ""
}

# ─── Neovim ──────────────────────────────────────────────────────────────────
if ($InstallNvim) {
    Write-Host "Setting up Neovim..." -ForegroundColor White
    $nvimInstaller = Join-Path $DotfilesDir "neovim.config\install.ps1"
    if (Test-Path $nvimInstaller) {
        & $nvimInstaller
    } else {
        Write-Host "  [!!] $nvimInstaller not found" -ForegroundColor Red
    }
    Write-Host ""
}

# ─── Done ────────────────────────────────────────────────────────────────────
Write-Host "  ========================================" -ForegroundColor Cyan
Write-Host "    Done!" -ForegroundColor Green
Write-Host "  ========================================" -ForegroundColor Cyan
Write-Host ""
if ($InstallProfile) {
    Write-Host "  PowerShell:" -ForegroundColor White
    Write-Host "    Profile: $($PROFILE.CurrentUserAllHosts)"
    Write-Host "    Open a new pwsh session to load it (first start installs modules)" -ForegroundColor Cyan
    Write-Host "    Edit theme: ~\.config\oh-my-posh\theme.toml"
}
Write-Host ""
