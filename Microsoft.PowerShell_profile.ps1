# PowerShell profile — mirrors ~/.zshrc (works on Windows, Linux, macOS; PS 7+ recommended)
# Install: symlink/copy to $PROFILE.CurrentUserAllHosts  (see install.ps1 hint at bottom)

$IsWin = $PSVersionTable.PSEdition -eq 'Desktop' -or $IsWindows
$sep = [IO.Path]::PathSeparator

# --- PLUGINS (zinit equivalent: PowerShell modules) ---
# zsh-completions / syntax-highlighting / autosuggestions -> PSReadLine + CompletionPredictor
# omz git plugin                                         -> functions below (posh-git for completion)
function Import-OrInstall($name) {
    if (-not (Get-Module -ListAvailable -Name $name)) {
        try { Install-Module $name -Scope CurrentUser -Force -AllowClobber -ErrorAction Stop }
        catch { Write-Warning "Could not install $name"; return }
    }
    Import-Module $name -ErrorAction SilentlyContinue
}
Import-OrInstall PSReadLine
Import-OrInstall posh-git          # git tab completion
Import-OrInstall Terminal-Icons    # icons for ls/ll
if ($PSVersionTable.PSVersion.Major -ge 7) { Import-OrInstall CompletionPredictor }

# --- KEYBINDINGS / HISTORY (bindkey -v, ^p ^n, setopt hist_*) ---
if (Get-Module PSReadLine) {
    Set-PSReadLineOption -EditMode Vi
    Set-PSReadLineOption -ViModeIndicator Cursor
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    Set-PSReadLineOption -MaximumHistoryCount 10000
    Set-PSReadLineOption -HistoryNoDuplicates
    Set-PSReadLineOption -HistorySaveStyle SaveIncrementally
    Set-PSReadLineOption -AddToHistoryHandler {   # hist_ignore_space
        param($line) return -not $line.StartsWith(' ')
    }
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin -ErrorAction SilentlyContinue
    Set-PSReadLineOption -PredictionViewStyle InlineView -ErrorAction SilentlyContinue
    Set-PSReadLineOption -BellStyle None
    Set-PSReadLineOption -ViModeChangeHandler $null -ErrorAction SilentlyContinue

    foreach ($mode in 'Insert', 'Command') {
        Set-PSReadLineKeyHandler -ViMode $mode -Chord Ctrl+p -Function HistorySearchBackward
        Set-PSReadLineKeyHandler -ViMode $mode -Chord Ctrl+n -Function HistorySearchForward
    }
    Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete
    Set-PSReadLineKeyHandler -Chord Ctrl+f -Function AcceptSuggestion   # accept autosuggestion
    # sudo plugin: double-Esc is not possible in PS; use Alt+s to prefix with sudo on *nix
    if (-not $IsWin) {
        Set-PSReadLineKeyHandler -Chord Alt+s -ScriptBlock {
            [Microsoft.PowerShell.PSConsoleReadLine]::BeginningOfLine()
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert('sudo ')
        }
    }
}

# --- PATH ---
$extra = @(
    "$HOME/.yarn/bin"
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/.dotnet/tools"
)
foreach ($p in $extra) {
    if ((Test-Path $p) -and ($env:PATH -split $sep) -notcontains $p) { $env:PATH = "$p$sep$env:PATH" }
}

# --- ALIASES ---
function ll { Get-ChildItem -Force @args | Format-Table -AutoSize }   # alias ll="ls -la"

# OMZ git plugin (most-used subset)
function Get-GitMainBranch { foreach ($b in 'main','master','trunk') { git show-ref -q --verify "refs/heads/$b" 2>$null; if ($?) { return $b } }; 'master' }
function g    { git @args }
function ga   { git add @args }
function gaa  { git add --all }
function gb   { git branch @args }
function gc   { git commit --verbose @args }
function gcmsg{ git commit --message @args }
function gco  { git checkout @args }
function gcb  { git checkout -b @args }
function gcm  { git checkout (Get-GitMainBranch) }
function gd   { git diff @args }
function gds  { git diff --staged @args }
function gf   { git fetch @args }
function gl   { git pull @args }
function gp   { git push @args }
function gpf  { git push --force-with-lease @args }
function gst  { git status @args }
function gsw  { git switch @args }
function glog { git log --oneline --decorate --graph @args }
function gm   { git merge @args }
function grb  { git rebase @args }
function gsta { git stash push @args }
function gstp { git stash pop }

# --- NVM equivalent: fnm (cross-platform) ---
if (Get-Command fnm -ErrorAction SilentlyContinue) {
    fnm env --use-on-cd --shell power-shell | Out-String | Invoke-Expression
}

# --- COMPLETIONS (aws, dotnet) ---
if (Get-Command dotnet -ErrorAction SilentlyContinue) {
    Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
        param($wordToComplete, $commandAst, $cursorPosition)
        dotnet complete --position $cursorPosition "$commandAst" | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
    }
}
if (Get-Command aws_completer -ErrorAction SilentlyContinue) {
    Register-ArgumentCompleter -Native -CommandName aws -ScriptBlock {
        param($wordToComplete, $commandAst, $cursorPosition)
        $env:COMP_LINE = $commandAst.ToString(); $env:COMP_POINT = $cursorPosition
        aws_completer | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
        Remove-Item Env:\COMP_LINE, Env:\COMP_POINT
    }
}

# --- PROMPT THEME (same oh-my-posh theme as zsh) ---
$ompTheme = Join-Path $HOME '.config/oh-my-posh/theme.toml'
if ((Get-Command oh-my-posh -ErrorAction SilentlyContinue) -and (Test-Path $ompTheme)) {
    oh-my-posh init pwsh --config $ompTheme | Invoke-Expression
}

# Install hint (PowerShell):
#   New-Item -ItemType SymbolicLink -Force -Path $PROFILE.CurrentUserAllHosts `
#     -Target "$HOME/dotfiles/Microsoft.PowerShell_profile.ps1"
#   New-Item -ItemType SymbolicLink -Force -Path "$HOME/.config/oh-my-posh/theme.toml" `
#     -Target "$HOME/dotfiles/config/oh-my-posh/theme.toml"
