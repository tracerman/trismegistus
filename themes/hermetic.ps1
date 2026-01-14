# ============================================================================
#  TRISMEGISTUS - Theme
#  Clean, functional UI
# ============================================================================

# Version (used for update checking)
$script:TrisVersion = "1.2.3"

$script:TrisTheme = @{
    Name = "hermetic"

    Banner = @"
  ⚗ Trismegistus v$($script:TrisVersion)
"@

    # Message types - functional naming
    Messages = @{
        # Core operations
        RUN       = @{ Symbol = "▶"; Color = "Cyan" }
        DONE      = @{ Symbol = "✓"; Color = "Green" }
        ERROR     = @{ Symbol = "✗"; Color = "Red" }
        WARNING   = @{ Symbol = "!"; Color = "Yellow" }
        INFO      = @{ Symbol = "·"; Color = "Gray" }
        SKIP      = @{ Symbol = "-"; Color = "DarkGray" }
        
        # Specific actions
        PLAN      = @{ Symbol = "◇"; Color = "Cyan" }
        EXEC      = @{ Symbol = "▶"; Color = "Blue" }
        TEST      = @{ Symbol = "●"; Color = "Blue" }
        REVIEW    = @{ Symbol = "◎"; Color = "Magenta" }
        COMMIT    = @{ Symbol = "↑"; Color = "Green" }
        
        # Status
        PROGRESS  = @{ Symbol = "◐"; Color = "Cyan" }
        WAITING   = @{ Symbol = "…"; Color = "DarkGray" }
        CLIPBOARD = @{ Symbol = "□"; Color = "Gray" }

        # Professional replacements for mystical terms
        QUERY     = @{ Symbol = "?"; Color = "Cyan" }      # replaces ORACLE
        BUILD     = @{ Symbol = "▶"; Color = "Blue" }      # replaces FORGE
        SYNC      = @{ Symbol = "↔"; Color = "Blue" }      # for sync operations
        CHECKPOINT = @{ Symbol = "◆"; Color = "Yellow" }   # for checkpoints
    }
}

# ============================================================================
# TERMINAL DETECTION
# ============================================================================

function Test-UnicodeSupport {
    return ($env:WT_SESSION -or 
            $env:TERM_PROGRAM -eq "vscode" -or 
            $env:TERM_PROGRAM -eq "iTerm.app" -or
            $env:COLORTERM -eq "truecolor")
}

# ============================================================================
# CORE OUTPUT FUNCTIONS
# ============================================================================

function Write-TrisMessage {
    param(
        [string]$Type,
        [string]$Message
    )
    
    $msgConfig = $script:TrisTheme.Messages[$Type]
    if (!$msgConfig) {
        $msgConfig = @{ Symbol = "·"; Color = "White" }
    }
    
    $symbol = if (Test-UnicodeSupport) { $msgConfig.Symbol } else { ">" }
    
    Write-Host "  $symbol " -ForegroundColor $msgConfig.Color -NoNewline
    Write-Host $Message
}

function Write-TrisBanner {
    param([switch]$Mini)
    
    if ($Mini) {
        Write-Host "  ⚗ Trismegistus" -ForegroundColor DarkCyan
    } else {
        Write-Host ""
        Write-Host "  ⚗ Trismegistus v$script:TrisVersion" -ForegroundColor Cyan
        Write-Host "    Multi-oracle AI orchestrator" -ForegroundColor DarkGray
        Write-Host ""
    }
}

# ============================================================================
# PROGRESS & STATUS
# ============================================================================

function Show-TrisSpinner {
    param(
        [string]$Message,
        [scriptblock]$ScriptBlock
    )
    
    $frames = @("⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏")
    if (!(Test-UnicodeSupport)) { $frames = @("|", "/", "-", "\") }
    
    $job = Start-Job -ScriptBlock $ScriptBlock
    $i = 0
    
    while ($job.State -eq 'Running') {
        $frame = $frames[$i % $frames.Count]
        Write-Host "`r  $frame $Message" -NoNewline -ForegroundColor Cyan
        Start-Sleep -Milliseconds 80
        $i++
    }
    
    Write-Host "`r  ✓ $Message" -ForegroundColor Green
    
    $result = Receive-Job $job
    Remove-Job $job
    return $result
}

function Show-TrisProgress {
    param(
        [int]$Current,
        [int]$Total,
        [string]$Message = ""
    )
    
    $percent = if ($Total -gt 0) { [math]::Round(($Current / $Total) * 100) } else { 0 }
    $width = 20
    $filled = [math]::Floor(($percent / 100) * $width)
    
    $bar = "█" * $filled + "░" * ($width - $filled)
    
    $color = if ($percent -lt 33) { "Red" } 
             elseif ($percent -lt 66) { "Yellow" } 
             else { "Green" }
    
    Write-Host "`r  [$bar] $percent% $Message" -NoNewline -ForegroundColor $color
}

function Write-TrisProgressBar {
    param(
        [int]$Percent,
        [string]$Message = ""
    )
    
    $width = 25
    $filled = [math]::Floor(($Percent / 100) * $width)
    $bar = "█" * $filled + "░" * ($width - $filled)
    
    $color = if ($Percent -lt 33) { "Red" } 
             elseif ($Percent -lt 66) { "Yellow" } 
             else { "Green" }
    
    Write-Host "  [$bar] " -NoNewline -ForegroundColor DarkGray
    Write-Host "$Percent%" -NoNewline -ForegroundColor $color
    if ($Message) { Write-Host " $Message" -NoNewline -ForegroundColor Gray }
    Write-Host ""
}

# ============================================================================
# DIFF & STATS
# ============================================================================

function Show-TrisDiff {
    param(
        [int]$Added = 0,
        [int]$Removed = 0,
        [int]$Files = 0
    )
    
    $total = $Added + $Removed
    if ($total -eq 0) { $total = 1 }
    
    $maxWidth = 25
    $addBar = [math]::Min($maxWidth, [math]::Ceiling(($Added / $total) * $maxWidth))
    $remBar = [math]::Min($maxWidth, [math]::Ceiling(($Removed / $total) * $maxWidth))
    
    Write-Host ""
    Write-Host "  $Files file(s) changed" -ForegroundColor Gray
    Write-Host "  +" -NoNewline -ForegroundColor Green
    Write-Host "$Added " -NoNewline -ForegroundColor Green
    Write-Host ("█" * $addBar) -ForegroundColor Green
    Write-Host "  -" -NoNewline -ForegroundColor Red
    Write-Host "$Removed " -NoNewline -ForegroundColor Red
    Write-Host ("█" * $remBar) -ForegroundColor Red
    Write-Host ""
}

# ============================================================================
# SIMPLE FEEDBACK
# ============================================================================

function Show-TrisSuccess {
    param([string]$Message = "Done")
    Write-Host "  ✓ $Message" -ForegroundColor Green
}

function Show-TrisWarning {
    param([string]$Message, [switch]$Blink)
    Write-Host ""
    Write-Host "  ! WARNING: $Message" -ForegroundColor Yellow
    Write-Host ""
}

function Show-TrisError {
    param([string]$Message)
    Write-Host ""
    Write-Host "  ✗ ERROR: $Message" -ForegroundColor Red
    Write-Host ""
}

# ============================================================================
# PHASE COMPLETION
# ============================================================================

function Show-TrisPhaseComplete {
    param(
        [int]$Phase = 1,
        [string]$Message = "Complete"
    )
    
    Write-Host ""
    Write-Host "  ✓ Phase $Phase complete" -NoNewline -ForegroundColor Green
    Write-Host " — $Message" -ForegroundColor Gray
    Write-Host ""
}

# ============================================================================
# STARTUP
# ============================================================================

function Show-TrisWelcome {
    Write-Host ""
    Write-Host "  ⚗ Trismegistus" -ForegroundColor Cyan
    Write-Host "    Type " -NoNewline -ForegroundColor DarkGray
    Write-Host "ai-help" -NoNewline -ForegroundColor White
    Write-Host " for commands" -ForegroundColor DarkGray
    Write-Host ""
}

# ============================================================================
# ORACLE INDICATOR
# ============================================================================

function Show-TrisOracle {
    param([string]$Provider = "oracle")
    Write-Host ""
    Write-TrisMessage "WAITING" "Querying $Provider..."
}

# ============================================================================
# DISPLAY HELPERS
# ============================================================================


function Show-TrisStats {
    param([hashtable]$Stats)
    
    Write-Host ""
    foreach ($key in $Stats.Keys) {
        Write-Host "  $key : " -NoNewline -ForegroundColor Gray
        Write-Host $Stats[$key] -ForegroundColor White
    }
    Write-Host ""
}

function Show-TrisTaskList {
    param([array]$Tasks)
    
    Write-Host ""
    foreach ($task in $Tasks) {
        $check = if ($task.Complete) { "✓" } else { "○" }
        $color = if ($task.Complete) { "Green" } else { "Gray" }
        Write-Host "  $check $($task.Name)" -ForegroundColor $color
    }
    Write-Host ""
}

# ============================================================================
# STUBS FOR BACKWARDS COMPATIBILITY
# ============================================================================

function Show-TrisProcessing {
    param([string]$Message = "Processing", [int]$Duration = 0)
    Write-TrisMessage "RUN" $Message
}

function Show-TrisWaiting {
    param([int]$Duration = 0, [string]$Message = "Processing...")
    Write-TrisMessage "WAITING" $Message
}

function Show-TrisShipped { Show-TrisSuccess "Shipped" }
function Write-TrisHeader { param([string]$Title); Write-Host ""; Write-Host "  $Title" -ForegroundColor Cyan; Write-Host "" }
function Write-TrisBox { param([string[]]$Content); $Content | ForEach-Object { Write-Host "  $_" } }

# Legacy aliases for backwards compatibility
Set-Alias -Name Show-TrisAlchemy -Value Show-TrisProcessing -Scope Script
Set-Alias -Name Show-TrisThinking -Value Show-TrisWaiting -Scope Script
Set-Alias -Name Show-TrisShipAnimation -Value Show-TrisShipped -Scope Script

# ============================================================================
# END
# ============================================================================
