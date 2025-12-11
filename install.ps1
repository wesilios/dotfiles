# ============================================
# Neovim Configuration Installer for Windows
# ============================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Neovim Configuration Installer" -ForegroundColor Cyan
Write-Host "  Platform: Windows" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "Warning: Not running as Administrator." -ForegroundColor Yellow
    Write-Host "Some installations may fail." -ForegroundColor Yellow
    Write-Host ""
}

function Test-Command {
    param($Command)
    $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

# Check prerequisites
Write-Host "Checking prerequisites..." -ForegroundColor Yellow
$missingPrereqs = @()

if (-not (Test-Command nvim)) { $missingPrereqs += "Neovim"; Write-Host "[X] Neovim not found" -ForegroundColor Red }
else { Write-Host "[OK] Neovim found: $(nvim --version | Select-Object -First 1)" -ForegroundColor Green }

if (-not (Test-Command git)) { $missingPrereqs += "Git"; Write-Host "[X] Git not found" -ForegroundColor Red }
else { Write-Host "[OK] Git found" -ForegroundColor Green }

if (-not (Test-Command node)) {
    Write-Host "[!] Node.js not found (required for nvim.plug, optional for nvim.lazy)" -ForegroundColor Yellow
}
else { Write-Host "[OK] Node.js found: $(node --version)" -ForegroundColor Green }

if (-not (Test-Command python)) {
    Write-Host "[!] Python not found (optional)" -ForegroundColor Yellow
} else {
    Write-Host "[OK] Python found: $(python --version)" -ForegroundColor Green
}

# Check optional but important tools
if (-not (Test-Command rg)) {
    Write-Host "[!] Ripgrep not found (REQUIRED for nvim.lazy live grep)" -ForegroundColor Yellow
    Write-Host "    Install: choco install ripgrep" -ForegroundColor Cyan
} else {
    Write-Host "[OK] Ripgrep found: $(rg --version | Select-Object -First 1)" -ForegroundColor Green
}

if (-not (Test-Command fd)) {
    Write-Host "[!] fd not found (optional, improves file finding)" -ForegroundColor Yellow
    Write-Host "    Install: choco install fd" -ForegroundColor Cyan
} else {
    Write-Host "[OK] fd found" -ForegroundColor Green
}

# Check for C compiler (required for Treesitter)
if (-not (Test-Command gcc) -and -not (Test-Command clang)) {
    Write-Host "[!] C compiler not found (REQUIRED for nvim-treesitter)" -ForegroundColor Yellow
    Write-Host "    Install MinGW: choco install mingw" -ForegroundColor Cyan
    Write-Host "    Or TDM-GCC: https://jmeubank.github.io/tdm-gcc/" -ForegroundColor Cyan
} else {
    if (Test-Command gcc) {
        Write-Host "[OK] gcc found: $(gcc --version | Select-Object -First 1)" -ForegroundColor Green
    } else {
        Write-Host "[OK] clang found: $(clang --version | Select-Object -First 1)" -ForegroundColor Green
    }
}

if ($missingPrereqs.Count -gt 0) {
    Write-Host "`nMissing prerequisites: $($missingPrereqs -join ', ')" -ForegroundColor Red
    Write-Host "Please install them first." -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Choose configuration:" -ForegroundColor Cyan
Write-Host "  1. nvim.lazy (recommended) - Modern Lua config with lazy.nvim" -ForegroundColor Green
Write-Host "  2. nvim.plug (deprecated)  - Legacy VimScript with vim-plug" -ForegroundColor Yellow
Write-Host ""

$choice = Read-Host "Enter your choice (1/2, default 1)"
switch ($choice) {
    "2"  { $selectedConfig = "plug" }
    default { $selectedConfig = "lazy" }
}

Write-Host "`nSelected: nvim.$selectedConfig" -ForegroundColor Green

Write-Host "`nSetting up Neovim configuration..." -ForegroundColor Yellow

$nvimConfigPath = "$env:LOCALAPPDATA\nvim"
$nvimDataPath   = "$env:LOCALAPPDATA\nvim-data"

# Backup existing config
if (Test-Path $nvimConfigPath) {
    $backupPath = "$nvimConfigPath.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    Move-Item $nvimConfigPath $backupPath -Force
    Write-Host "Existing config backed up -> $backupPath" -ForegroundColor Yellow
}

# Copy correct config folder based on selection
$currentPath = $PSScriptRoot
if ($selectedConfig -eq "lazy") {
    $sourcePath = Join-Path $currentPath "nvim.lazy"
} else {
    $sourcePath = Join-Path $currentPath "nvim.plug"
}

Copy-Item -Path $sourcePath -Destination $nvimConfigPath -Recurse -Force
Write-Host "[OK] Configuration copied" -ForegroundColor Green

# ======================
# PLUGIN MANAGER SETUP
# ======================

if ($selectedConfig -eq "lazy") {
    Write-Host "`nlazy.nvim will bootstrap automatically on first launch" -ForegroundColor Yellow
    Write-Host "Syncing plugins..." -ForegroundColor Yellow

    try {
        nvim --headless "+Lazy! sync" +qa 2>$null
        Write-Host "[OK] Plugins synced successfully" -ForegroundColor Green
    } catch {
        Write-Host "[!] Plugins will sync on first launch" -ForegroundColor Yellow
    }
} else {
    Write-Host "`nInstalling vim-plug..." -ForegroundColor Yellow
    $plugPath = "$nvimDataPath\site\autoload\plug.vim"
    $plugDir = Split-Path $plugPath -Parent
    if (-not (Test-Path $plugDir)) { New-Item -ItemType Directory -Path $plugDir -Force | Out-Null }

    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" `
        -OutFile $plugPath -UseBasicParsing

    Write-Host "[OK] vim-plug installed" -ForegroundColor Green
    Write-Host "Installing plugins via vim-plug..." -ForegroundColor Yellow
    nvim --headless +PlugInstall +qall
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($selectedConfig -eq "lazy") {
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "  1. Run nvim"
    Write-Host "  2. Plugins will auto-install on first launch"
    Write-Host "  3. Run health check: :checkhealth"
    Write-Host ""

    # Check if ripgrep is missing and warn
    if (-not (Test-Command rg)) {
        Write-Host "IMPORTANT: Ripgrep is REQUIRED for live grep functionality!" -ForegroundColor Red
        Write-Host "  The following keymaps will NOT work without ripgrep:" -ForegroundColor Yellow
        Write-Host "    - <leader>fg (live grep)" -ForegroundColor Yellow
        Write-Host "    - <leader>ps (grep search)" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "  Install ripgrep:" -ForegroundColor Cyan
        Write-Host "    choco install ripgrep" -ForegroundColor White
        Write-Host "    OR scoop install ripgrep" -ForegroundColor White
        Write-Host "    OR winget install BurntSushi.ripgrep.MSVC" -ForegroundColor White
        Write-Host ""
    }

    Write-Host "Optional but recommended tools:" -ForegroundColor Yellow
    Write-Host "  - fd: choco install fd (faster file finding)" -ForegroundColor White
    Write-Host "  - stylua: choco install stylua (Lua formatter)" -ForegroundColor White
    Write-Host "  - prettier: npm install -g prettier (JS/TS formatter)" -ForegroundColor White
} else {
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "  1. Run nvim"
    Write-Host "  2. Check plugin status: :PlugStatus"
    Write-Host "  3. Run health check: :checkhealth"
    Write-Host "  4. Install CoC extensions: :CocInstall coc-snippets coc-pairs"
    Write-Host ""
    Write-Host "Optional language servers:" -ForegroundColor Yellow
    Write-Host "  - JavaScript/TypeScript: npm install -g typescript typescript-language-server"
    Write-Host "  - Python: pip3 install python-lsp-server"
}
Write-Host ""
