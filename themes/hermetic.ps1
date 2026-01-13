# ============================================================================
#  TRISMEGISTUS - Hermetic Theme
#  "As above, so below; as within, so without."
# ============================================================================

$script:TrisTheme = @{
    Name = "hermetic"
    
    # ASCII Art Banner (Windows-compatible)
    Banner = @"

  ___________      .__                                .__          __                
  \__    ___/______|__| ______ _____   ____   _____ |__|  ______/  |_ __ __  ______
    |    |  \_  __ \  |/  ___//     \_/ __ \ / ___\ |  | /  ___/\   __\  |  \/  ___/
    |    |   |  | \/  |\___ \|  Y Y  \  ___// /_/  >|  | \___ \  |  | |  |  /\___ \ 
    |____|   |__|  |__/____  >__|_|  /\___  >___  / |__|/____  > |__| |____//____  >
                           \/      \/     \/_____/           \/                  \/ 
                                                                                        
              "As above, so below; as within, so without." - The Emerald Tablet

"@

    # Mini banner for regular operations
    MiniBanner = @"
+==============================================================+
|      T R I S M E G I S T U S  - Thrice-Great Orchestrator    |
+==============================================================+
"@

    # Message prefixes with symbols
    # Using ASCII symbols that render well on all terminals
    Messages = @{
        # Core operations
        INVOKE    = @{ Symbol = ">>"; Color = "Magenta"; Text = "INVOKE" }
        TRANSMUTE = @{ Symbol = "~~"; Color = "Cyan"; Text = "TRANSMUTE" }
        MANIFEST  = @{ Symbol = "**"; Color = "Green"; Text = "MANIFEST" }
        SCRIBE    = @{ Symbol = "::"; Color = "Yellow"; Text = "SCRIBE" }
        REVEAL    = @{ Symbol = "()"; Color = "White"; Text = "REVEAL" }
        
        # Planning & Architecture
        DESIGN    = @{ Symbol = "[]"; Color = "Blue"; Text = "DESIGN" }
        ORACLE    = @{ Symbol = "@@"; Color = "Magenta"; Text = "ORACLE" }
        VISION    = @{ Symbol = "++"; Color = "Cyan"; Text = "VISION" }
        
        # Execution
        FORGE     = @{ Symbol = "##"; Color = "Red"; Text = "FORGE" }
        CREATE    = @{ Symbol = "++"; Color = "Yellow"; Text = "CREATE" }
        BIND      = @{ Symbol = "<>"; Color = "Gray"; Text = "BIND" }
        
        # Validation
        VERIFY    = @{ Symbol = "??"; Color = "Cyan"; Text = "VERIFY" }
        JUDGE     = @{ Symbol = "!!"; Color = "Yellow"; Text = "JUDGE" }
        SEAL      = @{ Symbol = "%%"; Color = "Green"; Text = "SEAL" }
        
        # Git operations
        COMMIT    = @{ Symbol = "->"; Color = "Green"; Text = "COMMIT" }
        PUSH      = @{ Symbol = "=>"; Color = "Cyan"; Text = "PUSH" }
        BRANCH    = @{ Symbol = "~/"; Color = "Green"; Text = "BRANCH" }
        
        # Status & Info
        STATUS    = @{ Symbol = "=="; Color = "Blue"; Text = "STATUS" }
        INFO      = @{ Symbol = "--"; Color = "Gray"; Text = "INFO" }
        WISDOM    = @{ Symbol = "$$"; Color = "Yellow"; Text = "WISDOM" }
        MEMORY    = @{ Symbol = "&&"; Color = "Magenta"; Text = "MEMORY" }
        
        # Warnings & Errors
        CHAOS     = @{ Symbol = "!!"; Color = "Red"; Text = "CHAOS" }
        VOID      = @{ Symbol = ".."; Color = "DarkGray"; Text = "VOID" }
        WARD      = @{ Symbol = "<!"; Color = "Yellow"; Text = "WARD" }
        
        # Success
        COMPLETE  = @{ Symbol = "OK"; Color = "Green"; Text = "COMPLETE" }
        TRIUMPH   = @{ Symbol = "^^"; Color = "Yellow"; Text = "TRIUMPH" }
        ASCEND    = @{ Symbol = "/\\"; Color = "Cyan"; Text = "ASCEND" }
        
        # System
        INIT      = @{ Symbol = "::"; Color = "Cyan"; Text = "INIT" }
        CONFIG    = @{ Symbol = "{}"; Color = "Gray"; Text = "CONFIG" }
        SYNC      = @{ Symbol = "<>"; Color = "Blue"; Text = "SYNC" }
        
        # New commands
        PROGRESS  = @{ Symbol = ">>"; Color = "Cyan"; Text = "PROGRESS" }
        CONTINUE  = @{ Symbol = "=>"; Color = "Yellow"; Text = "CONTINUE" }
        TEST      = @{ Symbol = "%%"; Color = "Blue"; Text = "TEST" }
        REVIEW    = @{ Symbol = "@@"; Color = "Magenta"; Text = "REVIEW" }
        DIFF      = @{ Symbol = "+-"; Color = "Cyan"; Text = "DIFF" }
        CONTEXT   = @{ Symbol = "{}"; Color = "DarkGray"; Text = "CONTEXT" }
        EXPLAIN   = @{ Symbol = "??"; Color = "Cyan"; Text = "EXPLAIN" }
        DOCS      = @{ Symbol = "##"; Color = "Blue"; Text = "DOCS" }
        ESTIMATE  = @{ Symbol = "~~"; Color = "Yellow"; Text = "ESTIMATE" }
        RESEARCH  = @{ Symbol = "()"; Color = "Magenta"; Text = "RESEARCH" }
        SPLIT     = @{ Symbol = "/\\"; Color = "Cyan"; Text = "SPLIT" }
        CHANGELOG = @{ Symbol = "->"; Color = "Green"; Text = "CHANGELOG" }
        SHIP      = @{ Symbol = "=>"; Color = "Green"; Text = "SHIP" }
        CHECKPOINT = @{ Symbol = "[]"; Color = "Yellow"; Text = "CHECKPOINT" }
    }
    
    # Philosophical quotes for different contexts
    Quotes = @{
        Planning = @(
            "The All is Mind; the Universe is Mental.",
            "Every cause has its effect; every effect has its cause.",
            "To change your mood or mental state, change your vibration."
        )
        Execution = @(
            "The lips of wisdom are closed, except to the ears of Understanding.",
            "Under, and behind, all outward appearances, there is always Substance.",
            "Everything flows, out and in; everything has its tides."
        )
        Completion = @(
            "The possession of Knowledge, unless accompanied by Action, is like hoarding gold.",
            "To destroy an undesirable rate of mental vibration, put into operation the Principle of Polarity.",
            "True mental transmutation is a Mental Art."
        )
        Error = @(
            "In Chaos, seek the Pattern.",
            "The unbalanced must be equilibrated.",
            "Every failure is a lesson in disguise."
        )
    }
    
    # Progress indicators
    Progress = @{
        Stages = @(".", "o", "O", "@", "#")
        Spinner = @("|", "/", "-", "\")
    }
}

function Write-TrisMessage {
    <#
    .SYNOPSIS
        Write a themed message to the console
    .PARAMETER Type
        Message type (INVOKE, TRANSMUTE, MANIFEST, CHAOS, etc.)
    .PARAMETER Message
        The message content
    .PARAMETER NoNewline
        Don't add newline at end
    #>
    param(
        [Parameter(Mandatory)]
        [string]$Type,
        [Parameter(Mandatory)]
        [string]$Message,
        [switch]$NoNewline
    )
    
    $theme = $script:TrisTheme
    $msgConfig = $theme.Messages[$Type]
    
    if (!$msgConfig) {
        # Fallback for unknown types
        $msgConfig = @{ Symbol = ".."; Color = "White"; Text = $Type }
    }
    
    $prefix = "$($msgConfig.Symbol) [$($msgConfig.Text)]"
    
    Write-Host $prefix -ForegroundColor $msgConfig.Color -NoNewline
    Write-Host " $Message" -NoNewline:$NoNewline
}

function Write-TrisBanner {
    <#
    .SYNOPSIS
        Display the Trismegistus banner
    .PARAMETER Mini
        Show the mini banner instead of full
    #>
    param([switch]$Mini)
    
    $theme = $script:TrisTheme
    
    if ($Mini) {
        Write-Host $theme.MiniBanner -ForegroundColor Cyan
    } else {
        Write-Host $theme.Banner -ForegroundColor Magenta
    }
}

function Get-TrisQuote {
    <#
    .SYNOPSIS
        Get a random philosophical quote for the context
    .PARAMETER Context
        The context (Planning, Execution, Completion, Error)
    #>
    param([string]$Context = "Planning")
    
    $quotes = $script:TrisTheme.Quotes[$Context]
    if ($quotes) {
        return $quotes | Get-Random
    }
    return "As above, so below."
}

function Write-TrisProgress {
    <#
    .SYNOPSIS
        Display a progress indicator
    .PARAMETER Current
        Current step number
    .PARAMETER Total
        Total steps
    .PARAMETER Message
        Progress message
    #>
    param(
        [int]$Current,
        [int]$Total,
        [string]$Message
    )
    
    $percent = [math]::Round(($Current / $Total) * 100)
    $stages = $script:TrisTheme.Progress.Stages
    $stageIndex = [math]::Floor(($Current / $Total) * ($stages.Count - 1))
    $symbol = $stages[$stageIndex]
    
    Write-Host "`r$symbol [$Current/$Total] $Message ($percent%)" -NoNewline -ForegroundColor Cyan
}

function Write-TrisBox {
    <#
    .SYNOPSIS
        Write content in a decorative box
    .PARAMETER Title
        Box title
    .PARAMETER Content
        Box content (string array)
    .PARAMETER Color
        Border color
    #>
    param(
        [string]$Title,
        [string[]]$Content,
        [string]$Color = "Cyan"
    )
    
    $width = 60
    $titlePadded = " $Title ".PadLeft(([math]::Floor(($width - $Title.Length) / 2)) + $Title.Length + 1).PadRight($width)
    
    Write-Host "+$("-" * $width)+" -ForegroundColor $Color
    Write-Host "|$titlePadded|" -ForegroundColor $Color
    Write-Host "+$("-" * $width)+" -ForegroundColor $Color
    
    foreach ($line in $Content) {
        $paddedLine = " $line".PadRight($width)
        if ($paddedLine.Length -gt $width) {
            $paddedLine = $paddedLine.Substring(0, $width)
        }
        Write-Host "|" -ForegroundColor $Color -NoNewline
        Write-Host $paddedLine -NoNewline
        Write-Host "|" -ForegroundColor $Color
    }
    
    Write-Host "+$("-" * $width)+" -ForegroundColor $Color
}

function Write-TrisTable {
    <#
    .SYNOPSIS
        Display data in a formatted table
    .PARAMETER Data
        Array of PSCustomObjects to display
    .PARAMETER Title
        Table title
    #>
    param(
        [array]$Data,
        [string]$Title = ""
    )
    
    if ($Title) {
        Write-Host "`n  $Title" -ForegroundColor Magenta
        Write-Host "  $("-" * ($Title.Length + 4))" -ForegroundColor DarkGray
    }
    
    $Data | Format-Table -AutoSize | Out-String | ForEach-Object { Write-Host $_ -ForegroundColor Gray }
}

# ============================================================================
# ANIMATIONS & VISUAL EFFECTS
# ============================================================================

function Show-TrisSpinner {
    <#
    .SYNOPSIS
        Show an animated spinner with message
    .PARAMETER Message
        Message to display
    .PARAMETER ScriptBlock
        Code to execute while spinner runs
    #>
    param(
        [string]$Message,
        [scriptblock]$ScriptBlock
    )
    
    $spinChars = @('◜', '◠', '◝', '◞', '◡', '◟')
    $alchemyChars = @('☿', '☉', '☽', '♄', '♃', '♂', '♀')
    
    # Fallback for terminals without Unicode
    if ($env:WT_SESSION -or $env:TERM_PROGRAM -eq "vscode") {
        $chars = $alchemyChars
    } else {
        $chars = @('|', '/', '-', '\')
    }
    
    $job = Start-Job -ScriptBlock $ScriptBlock
    $i = 0
    
    while ($job.State -eq 'Running') {
        $char = $chars[$i % $chars.Count]
        Write-Host "`r  $char $Message" -NoNewline -ForegroundColor Cyan
        Start-Sleep -Milliseconds 120
        $i++
    }
    
    Write-Host "`r  ✓ $Message" -ForegroundColor Green
    Receive-Job $job
    Remove-Job $job
}

function Show-TrisOracle {
    <#
    .SYNOPSIS
        Display an oracle consulting animation
    #>
    $frames = @(
        @"
         .  *  .
      *    ◯    *
         .  *  .
"@,
        @"
        . * . * .
      *    ◉    *
        . * . * .
"@,
        @"
       *  . * .  *
      .    ◎    .
       *  . * .  *
"@,
        @"
        . * . * .
      *    ◉    *
        . * . * .
"@
    )
    
    Write-Host ""
    for ($i = 0; $i -lt 8; $i++) {
        $frame = $frames[$i % $frames.Count]
        Write-Host "`r$frame" -ForegroundColor Magenta -NoNewline
        Start-Sleep -Milliseconds 200
    }
    Write-Host ""
}

function Show-TrisAlchemy {
    <#
    .SYNOPSIS
        Display an alchemy transmutation animation
    .PARAMETER Message
        Completion message
    #>
    param([string]$Message = "Transmutation complete")
    
    $stages = @(
        "   [ite  ite  ite  ]   Calcination...",
        "   [�ite  ite  ite  ]   Dissolution...",
        "   [▒ite  ite  ite ]   Separation...",
        "   [▒▒te  ite  ite ]   Conjunction...",
        "   [▒▒▒e  ite  ite ]   Fermentation...",
        "   [▒▒▒▒  ite  ite ]   Distillation...",
        "   [▒▒▒▒▒ ite  ite ]   Coagulation...",
        "   [▒▒▒▒▒▒ite  ite ]   Transmuting...",
        "   [▒▒▒▒▒▒▒te  ite ]   Transmuting...",
        "   [▒▒▒▒▒▒▒▒e  ite ]   Transmuting...",
        "   [▒▒▒▒▒▒▒▒▒  ite ]   Manifesting...",
        "   [▒▒▒▒▒▒▒▒▒▒ ite ]   Manifesting...",
        "   [▒▒▒▒▒▒▒▒▒▒▒ite ]   Manifesting...",
        "   [▒▒▒▒▒▒▒▒▒▒▒▒te ]   Sealing...",
        "   [▒▒▒▒▒▒▒▒▒▒▒▒▒e ]   Sealing...",
        "   [▒▒▒▒▒▒▒▒▒▒▒▒▒▒ ]   Complete!"
    )
    
    foreach ($stage in $stages) {
        Write-Host "`r$stage" -NoNewline -ForegroundColor Cyan
        Start-Sleep -Milliseconds 80
    }
    Write-Host "`r   [██████████████]   $Message" -ForegroundColor Green
}

function Show-TrisPhaseComplete {
    <#
    .SYNOPSIS
        Celebratory animation for phase completion
    .PARAMETER Phase
        Phase number completed
    #>
    param([int]$Phase)
    
    $art = @"

    ╔═══════════════════════════════════════╗
    ║                                       ║
    ║      ★  PHASE $Phase COMPLETE  ★         ║
    ║                                       ║
    ║          ∴ As above ∴                 ║
    ║          ∵ So below ∵                 ║
    ║                                       ║
    ╚═══════════════════════════════════════╝

"@
    Write-Host $art -ForegroundColor Yellow
}

function Show-TrisSuccess {
    <#
    .SYNOPSIS
        Display success animation
    .PARAMETER Message
        Success message
    #>
    param([string]$Message = "Operation Complete")
    
    $art = @"

      _______________
     /               \
    |    ★ SUCCESS ★  |
    |   ─────────────  |
    |   $($Message.PadRight(15).Substring(0,15)) |
     \_________________/
            ║
         ═══╩═══

"@
    Write-Host $art -ForegroundColor Green
}

function Show-TrisWarning {
    <#
    .SYNOPSIS
        Display warning with attention-getting animation
    .PARAMETER Message
        Warning message
    #>
    param([string]$Message)
    
    for ($i = 0; $i -lt 3; $i++) {
        Write-Host "`r  ⚠  " -NoNewline -ForegroundColor Yellow
        Start-Sleep -Milliseconds 150
        Write-Host "`r  !  " -NoNewline -ForegroundColor Red
        Start-Sleep -Milliseconds 150
    }
    Write-Host "`r  ⚠  $Message" -ForegroundColor Yellow
}

function Write-TrisProgressBar {
    <#
    .SYNOPSIS
        Display a progress bar with percentage
    .PARAMETER Percent
        Completion percentage (0-100)
    .PARAMETER Message
        Progress message
    .PARAMETER Width
        Bar width in characters
    #>
    param(
        [int]$Percent,
        [string]$Message = "",
        [int]$Width = 30
    )
    
    $filled = [math]::Floor($Width * $Percent / 100)
    $empty = $Width - $filled
    $bar = "█" * $filled + "░" * $empty
    
    # Color based on progress
    $color = switch ($Percent) {
        { $_ -lt 30 } { "Red" }
        { $_ -lt 70 } { "Yellow" }
        default { "Green" }
    }
    
    Write-Host "`r  [$bar] $Percent% $Message" -NoNewline -ForegroundColor $color
}

function Show-TrisDiff {
    <#
    .SYNOPSIS
        Display a styled diff header
    .PARAMETER Added
        Number of additions
    .PARAMETER Removed
        Number of deletions  
    .PARAMETER Files
        Number of files changed
    #>
    param(
        [int]$Added,
        [int]$Removed,
        [int]$Files
    )
    
    $addBar = "+" * [math]::Min($Added, 20)
    $remBar = "-" * [math]::Min($Removed, 20)
    
    Write-Host ""
    Write-Host "  ┌──────────────────────────────────────┐" -ForegroundColor DarkGray
    Write-Host "  │ " -NoNewline -ForegroundColor DarkGray
    Write-Host "$Files files changed" -NoNewline -ForegroundColor White
    Write-Host "                       │" -ForegroundColor DarkGray
    Write-Host "  │ " -NoNewline -ForegroundColor DarkGray
    Write-Host "+$Added" -NoNewline -ForegroundColor Green
    Write-Host " $addBar" -NoNewline -ForegroundColor Green
    $padding = 30 - $addBar.Length - "$Added".Length
    Write-Host "$(" " * [math]::Max(0, $padding))│" -ForegroundColor DarkGray
    Write-Host "  │ " -NoNewline -ForegroundColor DarkGray
    Write-Host "-$Removed" -NoNewline -ForegroundColor Red
    Write-Host " $remBar" -NoNewline -ForegroundColor Red
    $padding = 30 - $remBar.Length - "$Removed".Length
    Write-Host "$(" " * [math]::Max(0, $padding))│" -ForegroundColor DarkGray
    Write-Host "  └──────────────────────────────────────┘" -ForegroundColor DarkGray
    Write-Host ""
}
