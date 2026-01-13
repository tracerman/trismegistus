# ============================================================================
#  TRISMEGISTUS - Hermetic Theme (Enhanced Edition)
#  "As above, so below; as within, so without."
# ============================================================================

$script:TrisTheme = @{
    Name = "hermetic"
    
    # ASCII Art Banner - Animated on startup
    Banner = @"

  ████████╗██████╗ ██╗███████╗███╗   ███╗███████╗ ██████╗ ██╗███████╗████████╗██╗   ██╗███████╗
  ╚══██╔══╝██╔══██╗██║██╔════╝████╗ ████║██╔════╝██╔════╝ ██║██╔════╝╚══██╔══╝██║   ██║██╔════╝
     ██║   ██████╔╝██║███████╗██╔████╔██║█████╗  ██║  ███╗██║███████╗   ██║   ██║   ██║███████╗
     ██║   ██╔══██╗██║╚════██║██║╚██╔╝██║██╔══╝  ██║   ██║██║╚════██║   ██║   ██║   ██║╚════██║
     ██║   ██║  ██║██║███████║██║ ╚═╝ ██║███████╗╚██████╔╝██║███████║   ██║   ╚██████╔╝███████║
     ╚═╝   ╚═╝  ╚═╝╚═╝╚══════╝╚═╝     ╚═╝╚══════╝ ╚═════╝ ╚═╝╚══════╝   ╚═╝    ╚═════╝ ╚══════╝
                                                                                        v1.2.1
"@

    # Alchemical Sigil for operations
    Sigil = @"
            ╭─────────────╮
        ╭───┤  ☿ ☉ ☽ ♃ ♄  ├───╮
        │   ╰─────────────╯   │
        │    ◢◣ ORACLE ◢◣    │
        ╰─────────────────────╯
"@

    # Mini banner for regular operations
    MiniBanner = @"
╔══════════════════════════════════════════════════════════════════╗
║    ⚗️  T R I S M E G I S T U S  ·  Thrice-Great Orchestrator    ║
╚══════════════════════════════════════════════════════════════════╝
"@

    # Transmutation Circle ASCII Art
    TransmutationCircle = @"
                    ╭──────────────────╮
               ╭────┴────╮        ╭────┴────╮
              │  🜁 AIR   │        │  🜂 FIRE │
               ╰────┬────╯        ╰────┬────╯
          ╭─────────┼──────────────────┼─────────╮
          │         │     ☉ GOLD ☉     │         │
          │    ╭────┴────╮        ╭────┴────╮    │
          │   │ 🜃 EARTH │        │ 🜄 WATER│    │
          │    ╰────┬────╯        ╰────┬────╯    │
          ╰─────────┴──────────────────┴─────────╯
"@

    # Message prefixes with symbols
    Messages = @{
        # Core operations
        INVOKE    = @{ Symbol = "⚡"; Color = "Magenta"; Text = "INVOKE" }
        TRANSMUTE = @{ Symbol = "⚗️"; Color = "Cyan"; Text = "TRANSMUTE" }
        MANIFEST  = @{ Symbol = "✨"; Color = "Green"; Text = "MANIFEST" }
        SCRIBE    = @{ Symbol = "📜"; Color = "Yellow"; Text = "SCRIBE" }
        REVEAL    = @{ Symbol = "👁️"; Color = "White"; Text = "REVEAL" }
        
        # Planning & Architecture
        DESIGN    = @{ Symbol = "📐"; Color = "Blue"; Text = "DESIGN" }
        ORACLE    = @{ Symbol = "🔮"; Color = "Magenta"; Text = "ORACLE" }
        VISION    = @{ Symbol = "🌟"; Color = "Cyan"; Text = "VISION" }
        
        # Execution
        FORGE     = @{ Symbol = "🔥"; Color = "Red"; Text = "FORGE" }
        CREATE    = @{ Symbol = "⚒️"; Color = "Yellow"; Text = "CREATE" }
        BIND      = @{ Symbol = "🔗"; Color = "Gray"; Text = "BIND" }
        
        # Validation
        VERIFY    = @{ Symbol = "🔍"; Color = "Cyan"; Text = "VERIFY" }
        JUDGE     = @{ Symbol = "⚖️"; Color = "Yellow"; Text = "JUDGE" }
        SEAL      = @{ Symbol = "🔏"; Color = "Green"; Text = "SEAL" }
        
        # Git operations
        COMMIT    = @{ Symbol = "📦"; Color = "Green"; Text = "COMMIT" }
        PUSH      = @{ Symbol = "🚀"; Color = "Cyan"; Text = "PUSH" }
        BRANCH    = @{ Symbol = "🌿"; Color = "Green"; Text = "BRANCH" }
        
        # Status & Info
        STATUS    = @{ Symbol = "📊"; Color = "Blue"; Text = "STATUS" }
        INFO      = @{ Symbol = "ℹ️"; Color = "Gray"; Text = "INFO" }
        WISDOM    = @{ Symbol = "📚"; Color = "Yellow"; Text = "WISDOM" }
        MEMORY    = @{ Symbol = "🧠"; Color = "Magenta"; Text = "MEMORY" }
        
        # Warnings & Errors
        CHAOS     = @{ Symbol = "💥"; Color = "Red"; Text = "CHAOS" }
        VOID      = @{ Symbol = "🕳️"; Color = "DarkGray"; Text = "VOID" }
        WARD      = @{ Symbol = "⚠️"; Color = "Yellow"; Text = "WARD" }
        
        # Success
        COMPLETE  = @{ Symbol = "✅"; Color = "Green"; Text = "COMPLETE" }
        TRIUMPH   = @{ Symbol = "🏆"; Color = "Yellow"; Text = "TRIUMPH" }
        ASCEND    = @{ Symbol = "⬆️"; Color = "Cyan"; Text = "ASCEND" }
        
        # System
        INIT      = @{ Symbol = "🌱"; Color = "Cyan"; Text = "INIT" }
        CONFIG    = @{ Symbol = "⚙️"; Color = "Gray"; Text = "CONFIG" }
        SYNC      = @{ Symbol = "🔄"; Color = "Blue"; Text = "SYNC" }
        
        # New commands
        PROGRESS  = @{ Symbol = "📈"; Color = "Cyan"; Text = "PROGRESS" }
        CONTINUE  = @{ Symbol = "▶️"; Color = "Yellow"; Text = "CONTINUE" }
        TEST      = @{ Symbol = "🧪"; Color = "Blue"; Text = "TEST" }
        REVIEW    = @{ Symbol = "👀"; Color = "Magenta"; Text = "REVIEW" }
        DIFF      = @{ Symbol = "±"; Color = "Cyan"; Text = "DIFF" }
        CONTEXT   = @{ Symbol = "📋"; Color = "DarkGray"; Text = "CONTEXT" }
        EXPLAIN   = @{ Symbol = "💡"; Color = "Cyan"; Text = "EXPLAIN" }
        DOCS      = @{ Symbol = "📖"; Color = "Blue"; Text = "DOCS" }
        ESTIMATE  = @{ Symbol = "⏱️"; Color = "Yellow"; Text = "ESTIMATE" }
        RESEARCH  = @{ Symbol = "🔬"; Color = "Magenta"; Text = "RESEARCH" }
        SPLIT     = @{ Symbol = "✂️"; Color = "Cyan"; Text = "SPLIT" }
        CHANGELOG = @{ Symbol = "📝"; Color = "Green"; Text = "CHANGELOG" }
        SHIP      = @{ Symbol = "🚢"; Color = "Green"; Text = "SHIP" }
        CHECKPOINT = @{ Symbol = "💾"; Color = "Yellow"; Text = "CHECKPOINT" }
        THINKING  = @{ Symbol = "🤔"; Color = "Magenta"; Text = "THINKING" }
    }
    
    # Philosophical quotes for different contexts
    Quotes = @{
        Planning = @(
            "The beginning of wisdom is the definition of terms. - Socrates",
            "Give me six hours to chop down a tree and I will spend four sharpening the axe. - Lincoln",
            "Measure twice, cut once. - Ancient Wisdom",
            "The map is not the territory. - Korzybski"
        )
        Execution = @(
            "The Great Work advances one step at a time.",
            "That which is Below corresponds to that which is Above.",
            "In the forge of action, intention becomes reality.",
            "The philosopher's stone is found in the work itself."
        )
        Verification = @(
            "Trust, but verify. - Ancient Proverb",
            "The unexamined code is not worth deploying.",
            "Doubt is the beginning of wisdom. - Descartes",
            "To know that we know what we know... that is true knowledge. - Copernicus"
        )
        Success = @(
            "The Work is complete. The Gold is manifest.",
            "As above, so below - the transmutation is sealed.",
            "What was scattered has been gathered.",
            "The Great Work advances!"
        )
        Error = @(
            "Even in chaos, there is wisdom to be found.",
            "The prima materia must sometimes be returned to the vessel.",
            "Failure is but another step on the path to transmutation."
        )
    }
    
    # Alchemical symbols for progress indicators
    AlchemySymbols = @{
        Elements = @("🜁", "🜂", "🜃", "🜄")
        Planets = @("☉", "☽", "☿", "♀", "♂", "♃", "♄")
        Processes = @("△", "▽", "◇", "○", "●", "◐", "◑")
        Progress = @("░", "▒", "▓", "█")
    }
    
    # Color Gradients
    GradientColors = @{
        Fire = @("DarkRed", "Red", "DarkYellow", "Yellow")
        Water = @("DarkBlue", "Blue", "DarkCyan", "Cyan")
        Earth = @("DarkGray", "Gray", "DarkGreen", "Green")
        Air = @("DarkMagenta", "Magenta", "White", "Cyan")
        Gold = @("DarkYellow", "Yellow", "White", "Yellow")
    }
}

# ============================================================================
# TERMINAL CAPABILITY DETECTION
# ============================================================================

function Test-UnicodeSupport {
    return ($env:WT_SESSION -or 
            $env:TERM_PROGRAM -eq "vscode" -or 
            $env:TERM_PROGRAM -eq "iTerm.app" -or
            $env:COLORTERM -eq "truecolor")
}

function Test-EmojiSupport {
    return ($env:WT_SESSION -or $env:TERM_PROGRAM -eq "vscode")
}

# ============================================================================
# CORE MESSAGE FUNCTIONS
# ============================================================================

function Write-TrisMessage {
    param(
        [string]$Type,
        [string]$Message
    )
    
    $msgConfig = $script:TrisTheme.Messages[$Type]
    if (!$msgConfig) {
        $msgConfig = @{ Symbol = "·"; Color = "White"; Text = $Type }
    }
    
    $symbol = if (Test-EmojiSupport) { $msgConfig.Symbol } else { "[" + $msgConfig.Text.Substring(0,1) + "]" }
    $color = $msgConfig.Color
    
    Write-Host "  $symbol " -ForegroundColor $color -NoNewline
    Write-Host "[$($msgConfig.Text)]" -ForegroundColor DarkGray -NoNewline
    Write-Host " $Message" -ForegroundColor White
}

function Write-TrisHeader {
    param([string]$Title)
    
    $width = 60
    $padding = [math]::Max(0, ($width - $Title.Length - 4) / 2)
    $leftPad = " " * [math]::Floor($padding)
    $rightPad = " " * [math]::Ceiling($padding)
    
    Write-Host ""
    Write-Host "╔$("═" * $width)╗" -ForegroundColor DarkMagenta
    Write-Host "║$leftPad  $Title  $rightPad║" -ForegroundColor Magenta
    Write-Host "╚$("═" * $width)╝" -ForegroundColor DarkMagenta
    Write-Host ""
}

function Write-TrisBox {
    param(
        [string[]]$Content,
        [string]$BorderColor = "DarkCyan",
        [string]$ContentColor = "White"
    )
    
    $maxLen = ($Content | Measure-Object -Property Length -Maximum).Maximum
    $width = [math]::Max($maxLen + 4, 40)
    
    Write-Host "┌$("─" * $width)┐" -ForegroundColor $BorderColor
    foreach ($line in $Content) {
        $pad = $width - $line.Length - 2
        Write-Host "│ " -ForegroundColor $BorderColor -NoNewline
        Write-Host $line -ForegroundColor $ContentColor -NoNewline
        Write-Host "$(" " * $pad)│" -ForegroundColor $BorderColor
    }
    Write-Host "└$("─" * $width)┘" -ForegroundColor $BorderColor
}

function Write-TrisQuote {
    param([string]$Context = "Planning")
    
    $quotes = $script:TrisTheme.Quotes[$Context]
    if ($quotes -and $quotes.Count -gt 0) {
        $quote = $quotes | Get-Random
        Write-Host ""
        Write-Host "    ✧ " -ForegroundColor DarkYellow -NoNewline
        Write-Host $quote -ForegroundColor DarkGray
        Write-Host ""
    }
}

# ============================================================================
# ADVANCED ANIMATIONS & VISUAL EFFECTS
# ============================================================================

function Show-TrisBanner {
    param([switch]$Animated)
    
    $banner = $script:TrisTheme.Banner
    $lines = $banner -split "`n"
    
    if ($Animated -and (Test-UnicodeSupport)) {
        foreach ($line in $lines) {
            Write-Host $line -ForegroundColor Magenta
            Start-Sleep -Milliseconds 30
        }
    } else {
        Write-Host $banner -ForegroundColor Magenta
    }
}

function Show-TrisSpinner {
    param(
        [string]$Message,
        [scriptblock]$ScriptBlock,
        [ValidateSet("alchemy", "orbit", "dots", "braille", "moon", "elements")]
        [string]$Style = "alchemy"
    )
    
    $spinnerFrames = switch ($Style) {
        "alchemy"  { @("☿", "☉", "☽", "♄", "♃", "♂", "♀", "⚗") }
        "orbit"    { @("◜", "◠", "◝", "◞", "◡", "◟") }
        "dots"     { @("⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏") }
        "braille"  { @("⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷") }
        "moon"     { @("🌑", "🌒", "🌓", "🌔", "🌕", "🌖", "🌗", "🌘") }
        "elements" { @("🜁", "🜂", "🜃", "🜄") }
        default    { @("|", "/", "-", "\") }
    }
    
    if (!(Test-UnicodeSupport)) {
        $spinnerFrames = @("|", "/", "-", "\")
    }
    
    $job = Start-Job -ScriptBlock $ScriptBlock
    $i = 0
    $colors = @("Magenta", "Cyan", "Blue", "Cyan")
    
    while ($job.State -eq 'Running') {
        $frame = $spinnerFrames[$i % $spinnerFrames.Count]
        $color = $colors[$i % $colors.Count]
        Write-Host "`r  $frame " -NoNewline -ForegroundColor $color
        Write-Host $Message -NoNewline -ForegroundColor White
        Write-Host "   " -NoNewline
        Start-Sleep -Milliseconds 100
        $i++
    }
    
    Write-Host "`r  ✓ " -NoNewline -ForegroundColor Green
    Write-Host $Message -ForegroundColor Green
    Write-Host ""
    
    $result = Receive-Job $job
    Remove-Job $job
    return $result
}

function Show-TrisOracle {
    param([string]$Provider = "Oracle")
    
    if (!(Test-UnicodeSupport)) {
        Write-Host "  Consulting $Provider..." -ForegroundColor Magenta
        return
    }
    
    $frames = @(
        @"
              ·  ✦  ·
           ✦    ◯    ✦
              ·  ✦  ·
"@,
        @"
            ·  ✦ · ✦  ·
           ✦    ◉    ✦
            ·  ✦ · ✦  ·
"@,
        @"
           · ✦ · ✦ · ✦ ·
          ✦     ◎     ✦
           · ✦ · ✦ · ✦ ·
"@,
        @"
          · ✦ · ✧ · ✦ ·
         ✦    ✺ ✺    ✦
          · ✦ · ✧ · ✦ ·
"@,
        @"
         ·✦·✧·☆·✧·✦·
        ✦    ★ ★    ✦
         ·✦·✧·☆·✧·✦·
"@
    )
    
    $colors = @("DarkMagenta", "Magenta", "Blue", "Cyan", "White")
    
    Write-Host ""
    [Console]::CursorVisible = $false
    $startY = [Console]::CursorTop
    
    for ($i = 0; $i -lt 10; $i++) {
        $frame = $frames[$i % $frames.Count]
        $color = $colors[$i % $colors.Count]
        
        [Console]::SetCursorPosition(0, $startY)
        Write-Host $frame -ForegroundColor $color
        Start-Sleep -Milliseconds 150
    }
    
    [Console]::CursorVisible = $true
    Write-Host "           Consulting the $Provider..." -ForegroundColor Magenta
    Write-Host ""
}

function Show-TrisAlchemy {
    param(
        [string]$Message = "Transmutation complete",
        [int]$Duration = 1500
    )
    
    if (!(Test-UnicodeSupport)) {
        Write-Host "  Processing..." -ForegroundColor Cyan
        return
    }
    
    $stages = @(
        @{ Name = "Calcination"; Symbol = "🜂"; Color = "Red" },
        @{ Name = "Dissolution"; Symbol = "🜄"; Color = "Blue" },
        @{ Name = "Separation"; Symbol = "🜁"; Color = "Cyan" },
        @{ Name = "Conjunction"; Symbol = "☿"; Color = "Magenta" },
        @{ Name = "Fermentation"; Symbol = "♃"; Color = "Yellow" },
        @{ Name = "Distillation"; Symbol = "☽"; Color = "White" },
        @{ Name = "Coagulation"; Symbol = "☉"; Color = "Yellow" }
    )
    
    $width = 30
    $sleepTime = [math]::Max(50, $Duration / ($width + $stages.Count))
    
    Write-Host ""
    [Console]::CursorVisible = $false
    
    foreach ($stage in $stages) {
        Write-Host "`r  $($stage.Symbol) " -NoNewline -ForegroundColor $stage.Color
        Write-Host "$($stage.Name)..." -NoNewline -ForegroundColor DarkGray
        Write-Host "          " -NoNewline
        Start-Sleep -Milliseconds ($sleepTime * 2)
    }
    
    Write-Host ""
    for ($i = 0; $i -le $width; $i++) {
        $filled = "█" * $i
        $empty = "░" * ($width - $i)
        $percent = [math]::Round(($i / $width) * 100)
        
        $color = if ($percent -lt 33) { "Red" } 
                 elseif ($percent -lt 66) { "Yellow" } 
                 else { "Green" }
        
        Write-Host "`r  ⚗️ [" -NoNewline -ForegroundColor DarkGray
        Write-Host $filled -NoNewline -ForegroundColor $color
        Write-Host $empty -NoNewline -ForegroundColor DarkGray
        Write-Host "] $percent%" -NoNewline -ForegroundColor $color
        
        Start-Sleep -Milliseconds $sleepTime
    }
    
    [Console]::CursorVisible = $true
    Write-Host ""
    Write-Host "  ✨ $Message" -ForegroundColor Green
    Write-Host ""
}

function Show-TrisPhaseComplete {
    param(
        [int]$Phase = 1,
        [string]$Message = "Phase complete!"
    )
    
    if (!(Test-UnicodeSupport)) {
        Write-Host "  [OK] Phase $Phase complete!" -ForegroundColor Green
        return
    }
    
    $sparkles = @("✦", "✧", "★", "☆", "✴", "✳", "❇", "✨")
    
    Write-Host ""
    [Console]::CursorVisible = $false
    
    for ($burst = 0; $burst -lt 3; $burst++) {
        $line = "  "
        for ($i = 0; $i -lt 20; $i++) {
            $sparkle = $sparkles | Get-Random
            $line += $sparkle
        }
        $colors = @("Yellow", "Cyan", "Magenta", "White")
        Write-Host "`r$line" -NoNewline -ForegroundColor ($colors | Get-Random)
        Start-Sleep -Milliseconds 100
    }
    
    [Console]::CursorVisible = $true
    Write-Host ""
    Write-Host "  🏆 " -NoNewline -ForegroundColor Yellow
    Write-Host "PHASE $Phase COMPLETE" -NoNewline -ForegroundColor Green
    Write-Host " - $Message" -ForegroundColor White
    Write-Host ""
    
    Write-TrisQuote -Context "Success"
}

function Show-TrisSuccess {
    param([string]$Message = "Operation successful!")
    
    if (!(Test-UnicodeSupport)) {
        Write-Host "  [OK] $Message" -ForegroundColor Green
        return
    }
    
    $sparkle = "✨ ★ ✦ ★ ✨"
    
    Write-Host ""
    Write-Host "  $sparkle" -ForegroundColor Yellow
    Write-Host "  ✅ $Message" -ForegroundColor Green
    Write-Host "  $sparkle" -ForegroundColor Yellow
    Write-Host ""
}

function Show-TrisWarning {
    param(
        [string]$Message,
        [switch]$Blink
    )
    
    if ($Blink -and (Test-UnicodeSupport)) {
        [Console]::CursorVisible = $false
        for ($i = 0; $i -lt 3; $i++) {
            Write-Host "`r  ⚠️  WARNING: $Message" -ForegroundColor Yellow
            Start-Sleep -Milliseconds 200
            Write-Host "`r  ⚠️  WARNING: $Message" -ForegroundColor DarkYellow
            Start-Sleep -Milliseconds 200
        }
        [Console]::CursorVisible = $true
        Write-Host ""
    } else {
        Write-Host ""
        Write-Host "  ╔══════════════════════════════════════════════════╗" -ForegroundColor Yellow
        Write-Host "  ║  ⚠️  WARNING                                      ║" -ForegroundColor Yellow
        Write-Host "  ╟──────────────────────────────────────────────────╢" -ForegroundColor Yellow
        Write-Host "  ║  $Message" -ForegroundColor White -NoNewline
        $pad = 50 - $Message.Length
        Write-Host "$(" " * [math]::Max(0,$pad))║" -ForegroundColor Yellow
        Write-Host "  ╚══════════════════════════════════════════════════╝" -ForegroundColor Yellow
        Write-Host ""
    }
}

function Show-TrisError {
    param([string]$Message)
    
    Write-Host ""
    Write-Host "  ╔══════════════════════════════════════════════════╗" -ForegroundColor Red
    Write-Host "  ║  💥 ERROR                                        ║" -ForegroundColor Red
    Write-Host "  ╟──────────────────────────────────────────────────╢" -ForegroundColor Red
    Write-Host "  ║  $Message" -ForegroundColor White -NoNewline
    $pad = 50 - $Message.Length
    Write-Host "$(" " * [math]::Max(0,$pad))║" -ForegroundColor Red
    Write-Host "  ╚══════════════════════════════════════════════════╝" -ForegroundColor Red
    Write-Host ""
    
    Write-TrisQuote -Context "Error"
}

function Show-TrisDiff {
    param(
        [int]$Added = 0,
        [int]$Removed = 0,
        [int]$Files = 0
    )
    
    $total = $Added + $Removed
    if ($total -eq 0) { $total = 1 }
    
    $maxBarWidth = 30
    $addBar = [math]::Min($maxBarWidth, [math]::Ceiling(($Added / $total) * $maxBarWidth))
    $remBar = [math]::Min($maxBarWidth, [math]::Ceiling(($Removed / $total) * $maxBarWidth))
    
    Write-Host ""
    Write-Host "  ╭────────────────────────────────────────────╮" -ForegroundColor DarkGray
    Write-Host "  │  📊 DIFF SUMMARY                           │" -ForegroundColor DarkGray
    Write-Host "  ├────────────────────────────────────────────┤" -ForegroundColor DarkGray
    Write-Host "  │  Files changed: " -NoNewline -ForegroundColor DarkGray
    Write-Host "$Files" -NoNewline -ForegroundColor Cyan
    Write-Host "                          │" -ForegroundColor DarkGray
    Write-Host "  │  +" -NoNewline -ForegroundColor DarkGray
    Write-Host "$Added" -NoNewline -ForegroundColor Green
    Write-Host " $("█" * $addBar)" -NoNewline -ForegroundColor Green
    Write-Host "$(" " * ($maxBarWidth - $addBar + 5))│" -ForegroundColor DarkGray
    Write-Host "  │  -" -NoNewline -ForegroundColor DarkGray
    Write-Host "$Removed" -NoNewline -ForegroundColor Red
    Write-Host " $("█" * $remBar)" -NoNewline -ForegroundColor Red
    Write-Host "$(" " * ($maxBarWidth - $remBar + 5))│" -ForegroundColor DarkGray
    Write-Host "  ╰────────────────────────────────────────────╯" -ForegroundColor DarkGray
    Write-Host ""
}

function Show-TrisProgress {
    param(
        [int]$Current,
        [int]$Total,
        [string]$Message = ""
    )
    
    $percent = if ($Total -gt 0) { [math]::Round(($Current / $Total) * 100) } else { 0 }
    $width = 25
    $filled = [math]::Floor(($percent / 100) * $width)
    
    $bar = "█" * $filled + "░" * ($width - $filled)
    
    $color = if ($percent -lt 33) { "Red" } 
             elseif ($percent -lt 66) { "Yellow" } 
             else { "Green" }
    
    Write-Host "`r  [" -NoNewline -ForegroundColor DarkGray
    Write-Host $bar -NoNewline -ForegroundColor $color
    Write-Host "] " -NoNewline -ForegroundColor DarkGray
    Write-Host "$percent%" -NoNewline -ForegroundColor $color
    Write-Host " ($Current/$Total) $Message" -NoNewline -ForegroundColor White
}

function Show-TrisThinking {
    param(
        [int]$Duration = 2,
        [string]$Message = "The Oracle contemplates..."
    )
    
    if (!(Test-UnicodeSupport)) {
        Write-Host "  Thinking..." -ForegroundColor Magenta
        Start-Sleep -Seconds $Duration
        return
    }
    
    $chars = @("0", "1", "ア", "イ", "ウ", "エ", "オ", "カ", "キ", "ク", "ケ", "コ", 
               "☿", "☉", "☽", "♃", "♄", "△", "▽", "◇", "○", "●")
    $width = 50
    $height = 5
    
    Write-Host ""
    Write-Host "  $Message" -ForegroundColor Magenta
    Write-Host ""
    
    [Console]::CursorVisible = $false
    $startY = [Console]::CursorTop
    
    $iterations = $Duration * 10
    for ($t = 0; $t -lt $iterations; $t++) {
        [Console]::SetCursorPosition(2, $startY)
        
        for ($y = 0; $y -lt $height; $y++) {
            $line = ""
            for ($x = 0; $x -lt $width; $x++) {
                if ((Get-Random -Maximum 10) -gt 7) {
                    $line += $chars | Get-Random
                } else {
                    $line += " "
                }
            }
            $colors = @("DarkGreen", "Green", "Cyan", "DarkCyan")
            Write-Host "  $line" -ForegroundColor ($colors | Get-Random)
        }
        
        Start-Sleep -Milliseconds 100
    }
    
    [Console]::SetCursorPosition(0, $startY)
    for ($y = 0; $y -lt $height; $y++) {
        Write-Host (" " * ($width + 4))
    }
    [Console]::SetCursorPosition(0, $startY)
    
    [Console]::CursorVisible = $true
}

# Note: Show-TrisConfig is defined in config.ps1 with full details
# This space intentionally left for the full implementation

function Show-TrisStats {
    param([hashtable]$Stats)
    
    Write-Host ""
    Write-Host "  ╭──────────────────────────────────────────────────╮" -ForegroundColor DarkCyan
    Write-Host "  │  📊 PROJECT STATISTICS                           │" -ForegroundColor Cyan
    Write-Host "  ├──────────────────────────────────────────────────┤" -ForegroundColor DarkCyan
    
    foreach ($key in $Stats.Keys) {
        $value = $Stats[$key]
        $padding = 30 - $key.Length - $value.ToString().Length
        Write-Host "  │  $key : " -NoNewline -ForegroundColor DarkCyan
        Write-Host "$value" -NoNewline -ForegroundColor Yellow
        Write-Host "$(" " * $padding)│" -ForegroundColor DarkCyan
    }
    
    Write-Host "  ╰──────────────────────────────────────────────────╯" -ForegroundColor DarkCyan
    Write-Host ""
}

function Show-TrisWelcome {
    if (!(Test-UnicodeSupport)) {
        Write-Host "  Trismegistus v1.2.1 - 'ai-help' for commands" -ForegroundColor Magenta
        return
    }
    
    [Console]::CursorVisible = $false
    Write-Host ""
    
    # Animated border reveal
    $borderChar = "═"
    $width = 56
    Write-Host "  ⚗️ " -NoNewline -ForegroundColor DarkMagenta
    for ($i = 0; $i -lt $width; $i++) {
        Write-Host $borderChar -NoNewline -ForegroundColor DarkMagenta
        Start-Sleep -Milliseconds 8
    }
    Write-Host " ⚗️" -ForegroundColor DarkMagenta
    
    # Typing effect for title
    $title = "     T R I S M E G I S T U S  v1.2.1"
    foreach ($char in $title.ToCharArray()) {
        Write-Host $char -NoNewline -ForegroundColor Magenta
        Start-Sleep -Milliseconds 15
    }
    Write-Host ""
    
    # Subtitle with slight delay
    Start-Sleep -Milliseconds 100
    Write-Host "     Thrice-Great AI Orchestrator" -ForegroundColor DarkMagenta
    
    # Bottom border (faster)
    Write-Host "  ⚗️ " -NoNewline -ForegroundColor DarkMagenta
    for ($i = 0; $i -lt $width; $i++) {
        Write-Host $borderChar -NoNewline -ForegroundColor DarkMagenta
        Start-Sleep -Milliseconds 5
    }
    Write-Host " ⚗️" -ForegroundColor DarkMagenta
    Write-Host ""
    
    # Shimmer effect on "ai-help" 
    $shimmerColors = @("DarkCyan", "Cyan", "White", "Cyan", "DarkCyan")
    foreach ($color in $shimmerColors) {
        Write-Host "`r     Type " -NoNewline -ForegroundColor DarkGray
        Write-Host "ai-help" -NoNewline -ForegroundColor $color
        Write-Host " to see all 35 commands   " -NoNewline -ForegroundColor DarkGray
        Start-Sleep -Milliseconds 80
    }
    Write-Host "`r     Type " -NoNewline -ForegroundColor DarkGray
    Write-Host "ai-help" -NoNewline -ForegroundColor Cyan
    Write-Host " to see all 35 commands" -ForegroundColor DarkGray
    Write-Host ""
    
    [Console]::CursorVisible = $true
    
    Write-TrisQuote -Context "Planning"
}

function Show-TrisSigil {
    if (!(Test-UnicodeSupport)) { return }
    
    $sigil = @"
            ╭─────────────────────────────────╮
        ╭───┤  ☿ MERCURY  ☉ SUN  ☽ MOON      ├───╮
        │   ├─────────────────────────────────┤   │
        │   │     ♃ JUPITER    ♄ SATURN      │   │
        │   ╰─────────────────────────────────╯   │
        │              ⚗️ ORACLE ⚗️              │
        ╰─────────────────────────────────────────╯
"@
    
    Write-Host $sigil -ForegroundColor Magenta
}

function Show-TrisTransmutationCircle {
    if (!(Test-UnicodeSupport)) { return }
    
    $circle = @"
                    ╭──────── ☉ GOLD ────────╮
               ╭────┴────╮              ╭────┴────╮
              │   🜁 AIR  │              │  🜂 FIRE │
               ╰────┬────╯              ╰────┬────╯
          ╭─────────┼────────────────────────┼─────────╮
          │         │     TRANSMUTATION      │         │
          │         │        CIRCLE          │         │
          │    ╭────┴────╮              ╭────┴────╮    │
          │   │  🜃 EARTH │              │ 🜄 WATER │    │
          │    ╰────┬────╯              ╰────┬────╯    │
          ╰─────────┴────────────────────────┴─────────╯
                         ☿ MERCURY ☿
"@
    
    Write-Host $circle -ForegroundColor Cyan
}

function Show-TrisShipAnimation {
    if (!(Test-UnicodeSupport)) {
        Write-Host "  Shipping..." -ForegroundColor Green
        return
    }
    
    $frames = @(
        "  🚀                                    ",
        "       🚀                               ",
        "            🚀                          ",
        "                 🚀                     ",
        "                      🚀                ",
        "                           🚀           ",
        "                                🚀      ",
        "                                     🚀 ",
        "                                   ✨ 🎉"
    )
    
    Write-Host ""
    [Console]::CursorVisible = $false
    
    foreach ($frame in $frames) {
        Write-Host "`r$frame" -NoNewline -ForegroundColor Yellow
        Start-Sleep -Milliseconds 100
    }
    
    [Console]::CursorVisible = $true
    Write-Host ""
    Write-Host "  🎉 Successfully shipped! 🎉" -ForegroundColor Green
    Write-Host ""
}

function Show-TrisTaskList {
    param([array]$Tasks)
    
    Write-Host ""
    Write-Host "  ╭────────────────────────────────────────────────────╮" -ForegroundColor DarkCyan
    Write-Host "  │  📋 TASK PROGRESS                                  │" -ForegroundColor Cyan
    Write-Host "  ├────────────────────────────────────────────────────┤" -ForegroundColor DarkCyan
    
    foreach ($task in $Tasks) {
        $checkbox = if ($task.Complete) { "✅" } else { "⬜" }
        $color = if ($task.Complete) { "Green" } else { "White" }
        $name = $task.Name
        if ($name.Length -gt 40) { $name = $name.Substring(0, 37) + "..." }
        $padding = 44 - $name.Length
        
        Write-Host "  │  $checkbox " -NoNewline -ForegroundColor DarkCyan
        Write-Host $name -NoNewline -ForegroundColor $color
        Write-Host "$(" " * $padding)│" -ForegroundColor DarkCyan
    }
    
    Write-Host "  ╰────────────────────────────────────────────────────╯" -ForegroundColor DarkCyan
    Write-Host ""
}

# ============================================================================
# TYPING EFFECTS
# ============================================================================

function Write-TrisTyping {
    param(
        [string]$Text,
        [int]$Speed = 50,
        [string]$Color = "White"
    )
    
    $delay = [math]::Max(10, 1000 / $Speed)
    
    foreach ($char in $Text.ToCharArray()) {
        Write-Host $char -NoNewline -ForegroundColor $Color
        Start-Sleep -Milliseconds $delay
    }
    Write-Host ""
}

function Write-TrisGradient {
    param(
        [string]$Text,
        [string[]]$Colors = @("DarkMagenta", "Magenta", "Blue", "Cyan", "White")
    )
    
    $chars = $Text.ToCharArray()
    $colorCount = $Colors.Count
    
    for ($i = 0; $i -lt $chars.Count; $i++) {
        $colorIndex = [math]::Floor(($i / $chars.Count) * $colorCount)
        Write-Host $chars[$i] -NoNewline -ForegroundColor $Colors[$colorIndex]
    }
    Write-Host ""
}

# ============================================================================
# END OF HERMETIC THEME
# ============================================================================
