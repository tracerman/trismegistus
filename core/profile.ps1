# ============================================================================
#  T R I S M E G I S T U S
#  "Thrice-Great" - Multi-Oracle Agentic Orchestrator
#  
#  Version: 1.2.1
#  Author: Transmuted from Claude God Mode
#  
#  "As above, so below; as within, so without." - The Emerald Tablet
# ============================================================================

# ============================================================================
# INITIALIZATION
# ============================================================================

# Determine Trismegistus root directory
# Priority: env var > script location > default
if ($env:TRIS_ROOT -and (Test-Path $env:TRIS_ROOT)) {
    $script:TrisRoot = $env:TRIS_ROOT
} elseif ($PSScriptRoot) {
    # Script is in /core, so go up one level
    $script:TrisRoot = Split-Path -Parent $PSScriptRoot
} else {
    $script:TrisRoot = Join-Path $HOME ".trismegistus"
}

# Set environment variables if not already set
if (!$env:TRIS_ROOT) { $env:TRIS_ROOT = $script:TrisRoot }
if (!$env:TRIS_TEMPLATES) { $env:TRIS_TEMPLATES = Join-Path $script:TrisRoot "templates" }

# Import core modules
$modulePaths = @(
    (Join-Path $script:TrisRoot "core" "router.ps1"),
    (Join-Path $script:TrisRoot "core" "config.ps1"),
    (Join-Path $script:TrisRoot "themes" "hermetic.ps1")
)

foreach ($module in $modulePaths) {
    if (Test-Path $module) {
        . $module
    }
}

# Import all adapters
$adapterPath = Join-Path $script:TrisRoot "core" "adapters"
if (Test-Path $adapterPath) {
    Get-ChildItem $adapterPath -Filter "*.ps1" | ForEach-Object {
        . $_.FullName
    }
}

# Initialize router
if (Get-Command Initialize-TrisRouter -ErrorAction SilentlyContinue) {
    Initialize-TrisRouter
}

# Configuration
$script:TemplatePath = $env:TRIS_TEMPLATES ?? (Join-Path $script:TrisRoot "templates")
$script:Config = if (Get-Command Get-TrisConfig -ErrorAction SilentlyContinue) { Get-TrisConfig } else { @{} }

# ============================================================================
# CONTEXT FOLDER MANAGEMENT
# ============================================================================

function Get-ContextFolder {
    <#
    .SYNOPSIS
        Get the context folder path for the current project
    .DESCRIPTION
        Priority: 
        1. Project-level .trisconfig (explicit override)
        2. Existing .tris/ folder
        3. Existing .claude/ folder (backwards compat)
        4. Default: .tris (new projects)
    #>
    
    # Check for project-level config override
    if (Test-Path ".trisconfig") {
        try {
            $projectConfig = Get-Content ".trisconfig" -Raw | ConvertFrom-Json
            if ($projectConfig.contextFolder) {
                return $projectConfig.contextFolder
            }
        } catch { }
    }
    
    # Check for existing folders (backwards compat)
    if (Test-Path ".tris") { return ".tris" }
    if (Test-Path ".claude") { return ".claude" }
    
    # Default for new projects
    return ".tris"
}

function Get-ContextPath {
    <#
    .SYNOPSIS
        Get full path to a context file/folder
    .PARAMETER SubPath
        Relative path within context folder (e.g., "active/plan.md")
    #>
    param([string]$SubPath = "")
    
    $folder = Get-ContextFolder
    if ($SubPath) {
        return Join-Path $folder $SubPath
    }
    return $folder
}

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

function Get-ProjectMap {
    <#
    .SYNOPSIS
        Generate a smart file tree of the project
    #>
    param([int]$MaxFiles = 3000)
    
    $tree = Get-ChildItem -Recurse -Name -ErrorAction SilentlyContinue | 
        Where-Object { $_ -notmatch 'node_modules|dist|build|\.git|\.vs|coverage|__pycache__|\.venv|venv' } | 
        Select-Object -First $MaxFiles
    
    return "PROJECT FILE STRUCTURE:`n" + ($tree -join "`n")
}

function Get-SmartReferences {
    <#
    .SYNOPSIS
        Load only relevant reference documents based on keywords
    #>
    param([string]$Context = "")
    
    $refPath = Join-Path (Get-ContextFolder) "reference"
    if (!(Test-Path $refPath)) { return "No reference documents available." }
    
    # Keyword mapping
    $keywords = @{
        "fastapi|api|endpoint|router|backend" = "fastapi"
        "react|component|frontend|jsx|tsx|hook" = "react"
        "sqlite|database|sql|query|model" = "sqlite"
        "test|pytest|jest|testing|coverage" = "testing"
        "deploy|docker|nginx|production|server" = "deployment"
    }
    
    $relevantDocs = @()
    $contextLower = $Context.ToLower()
    
    foreach ($pattern in $keywords.Keys) {
        if ($contextLower -match $pattern) {
            $keyword = $keywords[$pattern]
            $docs = Get-ChildItem $refPath -Filter "*$keyword*" -Recurse -ErrorAction SilentlyContinue
            $relevantDocs += $docs
        }
    }
    
    # If no matches, return nothing (don't load everything)
    if ($relevantDocs.Count -eq 0) {
        return ""
    }
    
    $output = ""
    foreach ($doc in $relevantDocs | Select-Object -Unique) {
        $content = Get-Content $doc.FullName -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
        if ($content) {
            $output += "--- REFERENCE: $($doc.Name) ---`n$content`n`n"
        }
    }
    
    return $output
}

function Get-RecentHistory {
    <#
    .SYNOPSIS
        Get recent CHANGELOG entries
    #>
    param([int]$Lines = 50)
    
    if (Test-Path "CHANGELOG.md") {
        return Get-Content "CHANGELOG.md" -Tail $Lines -Encoding UTF8 -ErrorAction SilentlyContinue | Out-String
    }
    return ""
}

function Get-CoreContext {
    <#
    .SYNOPSIS
        Load core context files (rules, PRD, lessons)
    #>
    $ctx = Get-ContextFolder
    $context = @{}
    
    $files = @{
        rules = "$ctx/CLAUDE.md"
        prd = "$ctx/active/prd.md"
        lessons = "$ctx/memory/lessons.md"
        plan = "$ctx/active/plan.md"
    }
    
    foreach ($key in $files.Keys) {
        $path = $files[$key]
        if (Test-Path $path) {
            $context[$key] = Get-Content $path -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
        } else {
            $context[$key] = ""
        }
    }
    
    return $context
}

function Test-LessonsSize {
    <#
    .SYNOPSIS
        Check if lessons.md is getting too large
    #>
    $ctx = Get-ContextFolder
    $lessonsPath = "$ctx/memory/lessons.md"
    $threshold = $script:Config.preferences.lessonsWarnThreshold ?? 100
    
    if (Test-Path $lessonsPath) {
        $lines = (Get-Content $lessonsPath).Count
        if ($lines -gt $threshold) {
            Write-TrisMessage "WARD" "lessons.md has $lines lines. Consider running 'ai-compress'."
        }
    }
}

# ============================================================================
# CORE COMMANDS
# ============================================================================

function ai-init {
    <#
    .SYNOPSIS
        Initialize Trismegistus in a project directory
    #>
    Write-TrisMessage "INIT" "Initializing the Sacred Geometry..."
    
    # Show the transmutation circle
    Show-TrisTransmutationCircle
    
    # Determine context folder (uses .tris for new, respects existing .claude)
    $ctx = Get-ContextFolder
    
    # Create directory structure
    $dirs = @(
        "$ctx/active",
        "$ctx/memory", 
        "$ctx/reference",
        "$ctx/commands",
        "$ctx/metrics",
        "$ctx/reviews"
    )
    
    foreach ($dir in $dirs) {
        if (!(Test-Path $dir)) {
            New-Item -ItemType Directory -Force -Path $dir | Out-Null
        }
    }
    
    # Copy templates if available
    if (Test-Path $script:TemplatePath) {
        # Commands
        $cmdSrc = Join-Path $script:TemplatePath "commands"
        if (Test-Path $cmdSrc) {
            Copy-Item -Recurse -Force "$cmdSrc\*" "$ctx\commands\" -ErrorAction SilentlyContinue
        }
        
        # Create default files if missing
        if (!(Test-Path "$ctx/active/prd.md")) {
            $prdTemplate = Join-Path $script:TemplatePath "active" "prd-template.md"
            if (Test-Path $prdTemplate) {
                Copy-Item $prdTemplate "$ctx/active/prd.md"
            } else {
                "# Project Requirements`n`n## Goal`n`n[Define your project goal here]" | 
                    Set-Content "$ctx/active/prd.md" -Encoding UTF8
            }
        }
        
        if (!(Test-Path "$ctx/memory/lessons.md")) {
            $lessonsTemplate = Join-Path $script:TemplatePath "memory" "lessons.md"
            if (Test-Path $lessonsTemplate) {
                Copy-Item $lessonsTemplate "$ctx/memory/lessons.md"
            } else {
                "# Lessons Learned`n`n## Format`n- [DATE] LESSON: Description | CONTEXT: Where it applies" | 
                    Set-Content "$ctx/memory/lessons.md" -Encoding UTF8
            }
        }
        
        if (!(Test-Path "$ctx/CLAUDE.md")) {
            "# Project Rules`n`n## Stack`n- [Define your tech stack]`n`n## Conventions`n- [Define coding conventions]" | 
                Set-Content "$ctx/CLAUDE.md" -Encoding UTF8
        }
    }
    
    # Update .gitignore
    ai-ignore
    
    Write-TrisMessage "COMPLETE" "Sacred space prepared. The Work may begin."
    Write-TrisMessage "INFO" "Next: Edit $ctx/CLAUDE.md and $ctx/active/prd.md"
}

function ai-plan {
    <#
    .SYNOPSIS
        Create an execution plan for a task
    .PARAMETER Task
        Description of the task to plan
    .PARAMETER Provider
        Override the default provider
    #>
    param(
        [Parameter(Mandatory)][string]$Task,
        [string]$Provider = $null
    )
    
    Write-TrisMessage "DESIGN" "Consulting the Oracle..."
    
    # Get context folder
    $ctx = Get-ContextFolder
    
    # Auto-init if needed
    if (!(Test-Path "$ctx/active/prd.md")) { ai-init }
    
    # Check lessons size
    Test-LessonsSize
    
    # Gather context
    $context = Get-CoreContext
    $map = Get-ProjectMap
    $refs = Get-SmartReferences -Context $Task
    $history = Get-RecentHistory -Lines 50
    
    # Load planning template
    $templatePath = "$ctx/commands/core/plan-feature.md"
    if (!(Test-Path $templatePath)) {
        $templatePath = Join-Path $script:TemplatePath "commands" "core" "plan-feature.md"
    }
    $template = if (Test-Path $templatePath) { 
        Get-Content $templatePath -Raw -Encoding UTF8 
    } else { 
        "Create a detailed step-by-step plan." 
    }
    
    # Construct the prompt
    $prompt = @"
SYSTEM CONTEXT:
- Orchestrator: Trismegistus v1.2.1
- Provider: $($Provider ?? $script:Config.default ?? "claude")
- Capability: Deep Reasoning & Massive Context
- OS: $($IsWindows ? "Windows" : ($IsMacOS ? "macOS" : "Linux"))

FULL PROJECT MAP:
$map

KNOWLEDGE BASE:
1. RULES (CLAUDE.md):
$($context.rules)

2. REQUIREMENTS (PRD):
$($context.prd)

3. RECENT HISTORY:
$history

4. LESSONS LEARNED:
$($context.lessons)

5. REFERENCE DOCUMENTS:
$refs

PLANNING TEMPLATE:
$template

TASK:
$Task

INSTRUCTIONS:
1. PHASE 1: ANALYSIS - Map dependencies and required changes.
2. PHASE 2: DRAFT - Create mental draft of execution plan.
3. PHASE 3: HOSTILE CRITIQUE - Attack your own draft. Ask: "Where will this break?"
4. PHASE 4: OUTPUT - Generate the corrected plan to '$ctx/active/plan.md'.

STRICT CONSTRAINT: Do NOT implement code yet. ONLY create the plan.md file.
"@

    # Invoke the oracle
    Set-Clipboard -Value $prompt
    Write-TrisMessage "SCRIBE" "Invocation inscribed. Opening the portal..."
    
    Invoke-Oracle -Prompt $prompt -CommandName "ai-plan" -Provider $Provider -Interactive
    
    # Open plan for review
    if (Test-Path "$ctx/active/plan.md") {
        Write-TrisMessage "REVEAL" "The plan has been revealed."
        if (Get-Command code -ErrorAction SilentlyContinue) {
            code "$ctx/active/plan.md"
        }
    }
}

function ai-exec {
    <#
    .SYNOPSIS
        Execute the current plan
    .PARAMETER Resume
        Resume from last checkpoint
    .PARAMETER Provider
        Override the default provider
    #>
    param(
        [switch]$Resume,
        [string]$Provider = $null
    )
    
    Write-TrisMessage "FORGE" "Preparing to transmute code..."
    
    $ctx = Get-ContextFolder
    $planPath = "$ctx/active/plan.md"
    if (!(Test-Path $planPath)) {
        Write-TrisMessage "VOID" "No plan found. Run 'ai-plan' first."
        return
    }
    
    # Stash current work as checkpoint
    if (!$Resume) {
        Write-TrisMessage "WARD" "Creating safety checkpoint..."
        git stash push -m "trismegistus-checkpoint-$(Get-Date -Format 'yyyyMMdd-HHmmss')" 2>$null
    }
    
    # Load context
    $context = Get-CoreContext
    
    # Load execution template
    $templatePath = "$ctx/commands/core/execute.md"
    if (!(Test-Path $templatePath)) {
        $templatePath = Join-Path $script:TemplatePath "commands" "core" "execute.md"
    }
    
    # Check for resume
    $progressPath = "$ctx/active/progress.txt"
    $resumeContext = ""
    if ($Resume -and (Test-Path $progressPath)) {
        $resumeContext = "`nRESUME FROM CHECKPOINT:`n" + (Get-Content $progressPath -Raw)
        Write-TrisMessage "SYNC" "Resuming from checkpoint..."
    }
    
    $prompt = @"
SYSTEM CONTEXT:
- Orchestrator: Trismegistus v1.2.1
- Mode: EXECUTION
- Provider: $($Provider ?? $script:Config.default ?? "claude")

RULES: 
$($context.rules)

LESSONS (Do not repeat these mistakes):
$($context.lessons)

THE PLAN:
$($context.plan)
$resumeContext

EXECUTION PROTOCOL:
1. Read files BEFORE editing - verify content exists
2. Execute plan SEQUENTIALLY - one step at a time  
3. VALIDATE after each change
4. TRACK progress in '$ctx/active/progress.txt'
5. UPDATE CHANGELOG.md with changes

CRITICAL - COMMIT MESSAGE:
When finished, you MUST create a file at '$ctx/commit_msg.txt' containing
a single-line Conventional Commit message (e.g., 'feat: add user authentication').
This file is REQUIRED for the commit process.
"@

    Set-Clipboard -Value $prompt
    
    # Show alchemy transmutation animation
    Show-TrisAlchemy
    
    Write-TrisMessage "SCRIBE" "The Great Work begins. Opening portal..."
    
    Invoke-Oracle -Prompt $prompt -CommandName "ai-exec" -Provider $Provider -Interactive
}

function ai-verify {
    <#
    .SYNOPSIS
        Hostile review of the current plan
    #>
    Write-TrisMessage "JUDGE" "Summoning the Hostile Critic..."
    
    $ctx = Get-ContextFolder
    $planPath = "$ctx/active/plan.md"
    if (!(Test-Path $planPath)) {
        Write-TrisMessage "VOID" "No plan to verify."
        return
    }
    
    $plan = Get-Content $planPath -Raw
    $lessons = Get-Content "$ctx/memory/lessons.md" -Raw -ErrorAction SilentlyContinue
    
    $prompt = @"
TASK: HOSTILE CRITIQUE & REFLEXION

You are a Hostile Senior Staff Engineer. Your job is to DESTROY this plan.

PAST MISTAKES (Do not allow these to recur):
$lessons

THE PLAN TO ATTACK:
$plan

INSTRUCTIONS:
1. Find EVERY flaw: race conditions, missing error handling, security holes, hallucinated files
2. Check against LESSONS - are we repeating past mistakes?
3. DECISION:
   - If flawed: REWRITE the plan and save to '$ctx/active/plan.md'
   - If solid: Output "STATUS: APPROVED" and explain why it passes

Be ruthless. Better to catch issues now than in production.
"@

    Set-Clipboard -Value $prompt
    
    # Show thinking animation
    Show-TrisThinking -Duration 1 -Message "The Critic scrutinizes the plan..."
    
    Write-TrisMessage "SCRIBE" "The trial begins..."
    
    Invoke-Oracle -Prompt $prompt -CommandName "ai-verify" -Interactive
}

function ai-commit {
    <#
    .SYNOPSIS
        Commit and push changes safely
    .PARAMETER DryRun
        Show what would be committed without committing
    .PARAMETER NoPush
        Commit but don't push
    .PARAMETER Force
        Skip protected branch warning
    #>
    param(
        [switch]$DryRun,
        [switch]$NoPush,
        [switch]$Force
    )
    
    Write-TrisMessage "COMMIT" "Preparing to seal the changes..."
    
    $ctx = Get-ContextFolder
    
    # Stage files
    git add .
    
    # Check for changes
    $status = git status --porcelain
    if ([string]::IsNullOrWhiteSpace($status)) {
        Write-TrisMessage "VOID" "Nothing to commit. The slate is clean."
        return
    }
    
    # Show preview
    Write-TrisMessage "REVEAL" "Changes to be committed:"
    git diff --stat HEAD
    Write-Host ""
    
    if ($DryRun) {
        Write-TrisMessage "INFO" "DRY RUN - No changes committed."
        return
    }
    
    # Branch protection
    $branch = git branch --show-current
    $protected = $script:Config.preferences.protectedBranches ?? @("main", "master", "production")
    
    if ($branch -in $protected -and !$Force) {
        Show-TrisWarning -Message "You are on protected branch '$branch'!" -Blink
        $confirm = Read-Host "Type 'yes' to proceed"
        if ($confirm -ne "yes") {
            Write-TrisMessage "INFO" "Commit cancelled."
            return
        }
    }
    
    # Get commit message
    $msgFile = "$ctx/commit_msg.txt"
    
    if (Test-Path $msgFile) {
        $msg = (Get-Content $msgFile -Raw).Trim()
        Write-TrisMessage "SCRIBE" "Using generated message: '$msg'"
    } else {
        Write-TrisMessage "ORACLE" "No message found. Enter commit message:"
        $msg = Read-Host "> "
        if ([string]::IsNullOrWhiteSpace($msg)) {
            Write-TrisMessage "VOID" "No message provided. Aborting."
            return
        }
    }
    
    # Commit
    git commit -m $msg
    
    if ($LASTEXITCODE -eq 0) {
        # Clean up message file
        Remove-Item $msgFile -ErrorAction SilentlyContinue
        
        if (!$NoPush) {
            Write-TrisMessage "PUSH" "Ascending to the remote repository..."
            git push
            
            if ($LASTEXITCODE -eq 0) {
                Write-TrisMessage "TRIUMPH" "The changes have been sealed and ascended."
            }
        } else {
            Write-TrisMessage "COMPLETE" "Changes committed locally."
        }
        
        # Record metric
        $metricsPath = "$ctx/metrics/metrics.jsonl"
        if (Test-Path (Split-Path $metricsPath -Parent)) {
            @{
                timestamp = (Get-Date -Format "o")
                action = "commit"
                message = $msg
                branch = $branch
            } | ConvertTo-Json -Compress | Add-Content $metricsPath
        }
    }
}

function ai-finish {
    <#
    .SYNOPSIS
        Archive completed plan and extract lessons
    #>
    Write-TrisMessage "SEAL" "Completing the Great Work..."
    
    $ctx = Get-ContextFolder
    $planPath = "$ctx/active/plan.md"
    if (!(Test-Path $planPath)) {
        Write-TrisMessage "VOID" "No active plan to finish."
        return
    }
    
    $plan = Get-Content $planPath -Raw
    $date = Get-Date -Format "yyyy-MM-dd"
    
    # Archive to completed log
    $logPath = "$ctx/memory/completed_log.md"
    if (!(Test-Path $logPath)) {
        "# Completed Missions Archive" | Set-Content $logPath -Encoding UTF8
    }
    
    "`n## [$date] Mission Complete`n$plan`n---" | Add-Content $logPath -Encoding UTF8
    
    # Extract lessons
    Write-TrisMessage "WISDOM" "Extracting lessons from this work..."
    
    $prompt = @"
TASK: POST-MORTEM ANALYSIS

INPUT (Completed Plan):
$plan

INSTRUCTIONS:
1. Analyze what was accomplished
2. Extract 1-2 key lessons learned
3. Format as: "- [DATE] LESSON: [Description] | CONTEXT: [Where it applies]"
4. APPEND these lessons to '$ctx/memory/lessons.md'

Be concise. Focus on reusable wisdom.
"@

    Set-Clipboard -Value $prompt
    Invoke-Oracle -Prompt $prompt -CommandName "ai-finish" -Interactive
    
    # Clear active plan
    Clear-Content $planPath
    Remove-Item "$ctx/active/progress.txt" -ErrorAction SilentlyContinue
    
    # Clean up Claude CLI temp files
    Get-ChildItem -Filter "tmpclaude-*-cwd" -ErrorAction SilentlyContinue | Remove-Item -Force
    
    # Show completion celebration
    Show-TrisPhaseComplete -Phase 0 -Message "Mission archived!"
    
    Write-TrisMessage "COMPLETE" "The cycle is complete. Ready for the next Work."
    Write-TrisQuote -Context "Success"
}

# ============================================================================
# ADVANCED COGNITION COMMANDS
# ============================================================================

function ai-architect {
    <#
    .SYNOPSIS
        Tree of Thoughts architectural design
    .PARAMETER Problem
        The architectural problem to solve
    #>
    param([Parameter(Mandatory)][string]$Problem)
    
    Write-TrisMessage "VISION" "Invoking the Council of Three..."
    
    # Show the mystical sigil
    Show-TrisSigil
    
    $ctx = Get-ContextFolder
    
    $prompt = @"
TASK: TREE OF THOUGHTS - ARCHITECTURAL COUNCIL

PROBLEM: $Problem

You are THREE distinct Principal Engineers debating this problem:
- ARCHITECT ALPHA: Prioritizes simplicity and maintainability
- ARCHITECT BETA: Prioritizes scalability and performance  
- ARCHITECT GAMMA: Prioritizes security and reliability

PROCESS:
1. Each architect proposes their approach (3 distinct solutions)
2. DEBATE: Cross-examine each approach for weaknesses
3. SYNTHESIS: Merge the best elements into a final design
4. OUTPUT: Save to '$ctx/reference/architecture_decision.md'

Include diagrams (ASCII or Mermaid) where helpful.
"@

    Set-Clipboard -Value $prompt
    Write-TrisMessage "ORACLE" "The Council convenes..."
    
    Invoke-Oracle -Prompt $prompt -CommandName "ai-architect" -Interactive
}

function ai-hotfix {
    <#
    .SYNOPSIS
        Emergency fix with minimal planning
    .PARAMETER Issue
        Description of the issue to fix
    #>
    param([Parameter(Mandatory)][string]$Issue)
    
    Write-TrisMessage "FORGE" "Emergency transmutation initiated!"
    
    $ctx = Get-ContextFolder
    $context = Get-CoreContext
    $map = Get-ProjectMap -MaxFiles 1000
    
    $prompt = @"
EMERGENCY HOTFIX MODE

ISSUE: $Issue

PROJECT MAP:
$map

RULES:
$($context.rules)

LESSONS (Avoid these mistakes):
$($context.lessons)

INSTRUCTIONS:
1. Identify the minimal change needed to fix this issue
2. Make the fix directly - no lengthy planning
3. Verify the fix works
4. Update CHANGELOG.md
5. Write commit message to '$ctx/commit_msg.txt'

This is an emergency. Be surgical and precise.
"@

    Set-Clipboard -Value $prompt
    Invoke-Oracle -Prompt $prompt -CommandName "ai-hotfix" -Interactive
}

function ai-rollback {
    <#
    .SYNOPSIS
        Rollback to last checkpoint
    #>
    Write-TrisMessage "SYNC" "Seeking the last checkpoint..."
    
    $stashes = git stash list | Where-Object { $_ -match "trismegistus-checkpoint" }
    
    if (!$stashes) {
        Write-TrisMessage "VOID" "No checkpoints found."
        return
    }
    
    Write-TrisMessage "REVEAL" "Available checkpoints:"
    git stash list | Where-Object { $_ -match "trismegistus-checkpoint" }
    
    $confirm = Read-Host "`nApply most recent checkpoint? (yes/no)"
    if ($confirm -eq "yes") {
        git stash pop
        Write-TrisMessage "COMPLETE" "Rolled back to checkpoint."
    }
}

# ============================================================================
# UTILITY COMMANDS  
# ============================================================================

function ai-ask {
    <#
    .SYNOPSIS
        Quick question without code modifications
    .PARAMETER Question
        Your question
    #>
    param([Parameter(Mandatory)][string]$Question)
    
    Write-TrisMessage "ORACLE" "Consulting the Oracle..."
    
    $map = Get-ProjectMap -MaxFiles 1000
    
    $prompt = @"
CONSULTATION MODE (Read-Only)

PROJECT CONTEXT:
$map

QUESTION: $Question

INSTRUCTIONS:
- Provide a thoughtful, detailed answer
- Reference specific files if relevant
- Do NOT modify any files
"@

    Set-Clipboard -Value $prompt
    Invoke-Oracle -Prompt $prompt -CommandName "ai-ask" -Interactive
}

function ai-debug {
    <#
    .SYNOPSIS
        Debug an error from clipboard
    #>
    Write-TrisMessage "TRANSMUTE" "Analyzing the disturbance..."
    
    $ctx = Get-ContextFolder
    $error = Get-Clipboard
    $map = Get-ProjectMap -MaxFiles 1000
    $context = Get-CoreContext
    
    $prompt = @"
DEBUG MODE

ERROR/STACK TRACE:
$error

PROJECT MAP:
$map

LESSONS (Don't repeat):
$($context.lessons)

INSTRUCTIONS:
1. Analyze the error deeply
2. Identify root cause
3. Create a fix plan in '$ctx/active/plan.md'
4. Include validation steps
"@

    Set-Clipboard -Value $prompt
    Invoke-Oracle -Prompt $prompt -CommandName "ai-debug" -Interactive
}

function ai-evolve {
    <#
    .SYNOPSIS
        Add a lesson to long-term memory
    .PARAMETER Lesson
        The lesson to record
    #>
    param([Parameter(Mandatory)][string]$Lesson)
    
    $ctx = Get-ContextFolder
    $date = Get-Date -Format "yyyy-MM-dd"
    $entry = "- [$date] LESSON: $Lesson"
    
    $lessonsPath = "$ctx/memory/lessons.md"
    if (!(Test-Path $lessonsPath)) {
        "# Lessons Learned`n" | Set-Content $lessonsPath -Encoding UTF8
    }
    
    $entry | Add-Content $lessonsPath -Encoding UTF8
    Write-TrisMessage "MEMORY" "Wisdom recorded: $Lesson"
}

function ai-status {
    <#
    .SYNOPSIS
        Show current project status
    #>
    Write-TrisBanner -Mini
    
    $ctx = Get-ContextFolder
    
    # Active plan
    $planPath = "$ctx/active/plan.md"
    if (Test-Path $planPath) {
        $planLines = (Get-Content $planPath).Count
        Write-TrisMessage "STATUS" "Active Plan: $planLines lines"
        Get-Content $planPath | Select-Object -First 5 | ForEach-Object { Write-Host "    $_" -ForegroundColor Gray }
    } else {
        Write-TrisMessage "VOID" "No active plan"
    }
    
    Write-Host ""
    
    # Progress
    $progressPath = "$ctx/active/progress.txt"
    if (Test-Path $progressPath) {
        Write-TrisMessage "STATUS" "Progress checkpoint exists"
    }
    
    # Lessons count
    $lessonsPath = "$ctx/memory/lessons.md"
    if (Test-Path $lessonsPath) {
        $lessonCount = (Get-Content $lessonsPath | Where-Object { $_ -match "^\s*-" }).Count
        Write-TrisMessage "MEMORY" "Lessons recorded: $lessonCount"
    }
    
    # Git status
    Write-Host ""
    Write-TrisMessage "BRANCH" "Git Status:"
    git status --short | ForEach-Object { Write-Host "    $_" -ForegroundColor Gray }
    
    # Pending commit message
    if (Test-Path "$ctx/commit_msg.txt") {
        $msg = Get-Content "$ctx/commit_msg.txt" -Raw
        Write-Host ""
        Write-TrisMessage "COMMIT" "Pending commit: $($msg.Trim())"
    }
}

function ai-help {
    <#
    .SYNOPSIS
        Display all available commands
    #>
    Write-TrisBanner -Mini
    
    $commands = @"

  ╔═══════════════════════════════════════════════════════════════╗
  ║  TRISMEGISTUS COMMAND REFERENCE  (35 commands)                ║
  ╚═══════════════════════════════════════════════════════════════╝

  PHASE 1: PLAN
  ─────────────────────────────────────────────────────────────────
  ai-init                     Initialize project structure
  ai-estimate <task>          Estimate complexity before planning
  ai-research <topic>         Deep research → saves to reference/
  ai-architect <problem>      Tree of Thoughts design session
  ai-plan <task>              Create detailed execution plan
  ai-verify                   Hostile review of plan
  ai-split [-Phases N]        Break oversized plan into phases

  PHASE 2: EXECUTE
  ─────────────────────────────────────────────────────────────────
  ai-exec [-Resume]           Execute the plan
  ai-progress                 Show phase/task completion status
  ai-continue [-Phase N]      Continue from last checkpoint
  ai-debug                    Analyze error from clipboard
  ai-ask <question>           Quick consultation

  PHASE 3: VALIDATE
  ─────────────────────────────────────────────────────────────────
  ai-diff [-Detailed]         Show changes since last commit
  ai-test [-Fix]              Run tests, analyze failures
  ai-review                   Code review actual changes
  ai-explain <file>           Explain what code does
  ai-context [-Full]          Debug: show what AI sees

  PHASE 4: SHIP
  ─────────────────────────────────────────────────────────────────
  ai-commit [-DryRun] [-NoPush]  Commit & push changes
  ai-docs [-Type X]           Generate/update documentation
  ai-changelog [-Since X]     Generate changelog entry
  ai-finish                   Archive plan, extract lessons
  ai-ship [-Force]            Full pipeline: diff→review→test→commit

  UTILITIES
  ─────────────────────────────────────────────────────────────────
  ai-status                   Show project status
  ai-evolve <lesson>          Add lesson to memory
  ai-compress                 Compress lessons.md
  ai-wipe                     Clear active plan
  ai-rollback                 Restore last checkpoint
  ai-hotfix <issue>           Emergency fix workflow

  CONFIGURATION
  ─────────────────────────────────────────────────────────────────
  ai-setup                    First-time configuration wizard
  ai-config                   Show/modify configuration
  ai-providers                List available AI providers
  ai-help                     Show this help

  PIPELINES (Automated Workflows)
  ─────────────────────────────────────────────────────────────────
  ai-flow-feature <task>      Architect → Plan → Verify
  ai-flow-bugfix <issue>      Debug → Plan → Fix

  ─────────────────────────────────────────────────────────────────
  Tip: Most commands support -Provider <n> to override default
  Workflow: estimate → plan → verify → exec → progress → ship
  
"@
    
    Write-Host $commands -ForegroundColor Gray
}

function ai-ignore {
    <#
    .SYNOPSIS
        Update .gitignore for Trismegistus
    #>
    $ctx = Get-ContextFolder
    $rules = @"

# --- TRISMEGISTUS ---
$ctx/active/
$ctx/metrics/
$ctx/commit_msg.txt
.tris/active/
.tris/metrics/
.tris/commit_msg.txt
.claude/active/
.claude/metrics/
.claude/commit_msg.txt
"@
    
    if (Test-Path .gitignore) {
        $current = Get-Content .gitignore -Raw
        if ($current -notmatch "TRISMEGISTUS") {
            Add-Content .gitignore $rules
            Write-TrisMessage "SEAL" "Updated .gitignore"
        }
    } else {
        Set-Content .gitignore $rules
        Write-TrisMessage "SEAL" "Created .gitignore"
    }
}

function ai-compress {
    <#
    .SYNOPSIS
        Compress lessons.md by consolidating
    #>
    Write-TrisMessage "TRANSMUTE" "Compressing the wisdom..."
    
    $ctx = Get-ContextFolder
    $lessons = Get-Content "$ctx/memory/lessons.md" -Raw -ErrorAction SilentlyContinue
    
    $prompt = @"
TASK: MEMORY COMPRESSION

CURRENT LESSONS:
$lessons

INSTRUCTIONS:
1. Identify duplicate or overlapping lessons
2. Consolidate similar lessons into more general rules
3. Remove outdated or superseded lessons
4. OVERWRITE '$ctx/memory/lessons.md' with compressed version
5. Preserve the most important, unique wisdom
"@

    Set-Clipboard -Value $prompt
    Invoke-Oracle -Prompt $prompt -CommandName "ai-compress" -Interactive
}

function ai-wipe {
    <#
    .SYNOPSIS
        Clear the active plan
    #>
    $ctx = Get-ContextFolder
    if (Test-Path "$ctx/active/plan.md") {
        Clear-Content "$ctx/active/plan.md"
        Write-TrisMessage "VOID" "Active plan cleared."
    }
    if (Test-Path "$ctx/active/progress.txt") {
        Remove-Item "$ctx/active/progress.txt"
        Write-TrisMessage "VOID" "Progress cleared."
    }
}

# ============================================================================
# PROGRESS & CONTINUATION COMMANDS
# ============================================================================

function ai-progress {
    <#
    .SYNOPSIS
        Show current plan progress with phase breakdown
    .DESCRIPTION
        Analyzes plan.md to show:
        - Phase completion status
        - Task checkboxes
        - Last checkpoint
    #>
    $ctx = Get-ContextFolder
    $planPath = "$ctx/active/plan.md"
    
    if (!(Test-Path $planPath)) {
        Write-TrisMessage "VOID" "No active plan. Run 'ai-plan' first."
        return
    }
    
    Write-TrisBanner -Mini
    Write-Host ""
    
    $plan = Get-Content $planPath -Raw -ErrorAction SilentlyContinue
    
    # Handle empty or null plan
    if ([string]::IsNullOrWhiteSpace($plan)) {
        Write-TrisMessage "VOID" "Plan file is empty. Run 'ai-plan' to create one."
        return
    }
    
    # Extract phases
    $phasePattern = '(?m)^#{2,3}\s*(Phase\s*\d+[:\s\-]*[^\n]*)'
    $phases = [regex]::Matches($plan, $phasePattern)
    
    # Count all tasks
    $allCompleted = ([regex]::Matches($plan, '\[x\]', 'IgnoreCase')).Count
    $allIncomplete = ([regex]::Matches($plan, '\[ \]')).Count
    $totalTasks = $allCompleted + $allIncomplete
    
    # Overall progress
    $overallPercent = if ($totalTasks -gt 0) { [math]::Round(($allCompleted / $totalTasks) * 100) } else { 0 }
    
    Write-TrisMessage "PROGRESS" "Plan Progress Overview"
    Write-Host ""
    Write-TrisProgressBar -Percent $overallPercent -Message "($allCompleted/$totalTasks tasks)"
    Write-Host ""
    Write-Host ""
    
    if ($phases.Count -eq 0) {
        Write-TrisMessage "INFO" "No phases detected. Showing task list:"
        Write-Host ""
        
        $taskNum = 1
        $plan -split "`n" | Where-Object { $_ -match '^\s*-\s*\[[ xX]\]' } | ForEach-Object {
            $isComplete = $_ -match '\[[xX]\]'
            $task = $_ -replace '^\s*-\s*\[[ xX]\]\s*', ''
            $status = if ($isComplete) { "✓" } else { "○" }
            $color = if ($isComplete) { "Green" } else { "Gray" }
            Write-Host "  $status $taskNum. $task" -ForegroundColor $color
            $taskNum++
        }
    } else {
        Write-TrisMessage "REVEAL" "Phase Breakdown:"
        Write-Host ""
        
        for ($i = 0; $i -lt $phases.Count; $i++) {
            $phase = $phases[$i]
            $phaseName = $phase.Groups[1].Value -replace '^Phase\s*\d+[:\s\-]*', ''
            
            # Find content between this phase and next
            $startIdx = $phase.Index + $phase.Length
            $endIdx = if ($i -lt $phases.Count - 1) { $phases[$i + 1].Index } else { $plan.Length }
            $phaseContent = $plan.Substring($startIdx, $endIdx - $startIdx)
            
            # Count tasks in phase
            $completed = ([regex]::Matches($phaseContent, '\[x\]', 'IgnoreCase')).Count
            $incomplete = ([regex]::Matches($phaseContent, '\[ \]')).Count
            $phaseTotal = $completed + $incomplete
            
            # Determine status
            if ($phaseTotal -eq 0) {
                $status = "◇"; $color = "DarkGray"; $statusText = "(no tasks)"
            } elseif ($completed -eq $phaseTotal) {
                $status = "✓"; $color = "Green"; $statusText = "COMPLETE"
            } elseif ($completed -gt 0) {
                $status = "◐"; $color = "Yellow"; $statusText = "$completed/$phaseTotal"
            } else {
                $status = "○"; $color = "Gray"; $statusText = "$phaseTotal pending"
            }
            
            $phaseNum = $i + 1
            $displayName = if ($phaseName) { $phaseName.Trim() } else { "Unnamed" }
            Write-Host "  $status Phase $phaseNum" -NoNewline -ForegroundColor $color
            Write-Host ": $displayName " -NoNewline -ForegroundColor White
            Write-Host "[$statusText]" -ForegroundColor $color
        }
    }
    
    Write-Host ""
    
    # Show checkpoint if exists
    $progressPath = "$ctx/active/progress.txt"
    if (Test-Path $progressPath) {
        Write-TrisMessage "CHECKPOINT" "Last execution checkpoint:"
        Get-Content $progressPath | Select-Object -Last 3 | ForEach-Object {
            Write-Host "    $_" -ForegroundColor DarkGray
        }
        Write-Host ""
    }
    
    # Next action suggestion
    if ($allIncomplete -gt 0) {
        Write-TrisMessage "INFO" "Run 'ai-continue' to execute next incomplete phase"
    } elseif ($allCompleted -gt 0) {
        Write-TrisMessage "COMPLETE" "All tasks complete! Run 'ai-finish' to archive"
    }
}

function ai-continue {
    <#
    .SYNOPSIS
        Continue execution from where it left off
    .DESCRIPTION
        Analyzes plan progress and continues from the first incomplete phase.
        Useful for resuming work after context window resets.
    .PARAMETER Phase
        Specific phase number to execute (optional)
    .PARAMETER Provider
        Override the default provider
    #>
    param(
        [int]$Phase = 0,
        [string]$Provider = $null
    )
    
    $ctx = Get-ContextFolder
    $planPath = "$ctx/active/plan.md"
    
    if (!(Test-Path $planPath)) {
        Write-TrisMessage "VOID" "No active plan. Run 'ai-plan' first."
        return
    }
    
    Write-TrisMessage "SYNC" "Analyzing plan progress..."
    
    $plan = Get-Content $planPath -Raw
    $context = Get-CoreContext
    
    # Find phases
    $phasePattern = '(?m)^#{2,3}\s*(Phase\s*\d+[:\s\-]*[^\n]*)'
    $phases = [regex]::Matches($plan, $phasePattern)
    
    # Determine which phase to execute
    $targetPhase = $Phase
    $targetPhaseName = ""
    
    if ($targetPhase -eq 0 -and $phases.Count -gt 0) {
        # Auto-detect: find first incomplete phase
        for ($i = 0; $i -lt $phases.Count; $i++) {
            $p = $phases[$i]
            $startIdx = $p.Index + $p.Length
            $endIdx = if ($i -lt $phases.Count - 1) { $phases[$i + 1].Index } else { $plan.Length }
            $phaseContent = $plan.Substring($startIdx, $endIdx - $startIdx)
            
            $incomplete = ([regex]::Matches($phaseContent, '\[ \]')).Count
            if ($incomplete -gt 0) {
                $targetPhase = $i + 1
                $targetPhaseName = $p.Groups[1].Value
                break
            }
        }
    } elseif ($targetPhase -gt 0 -and $phases.Count -ge $targetPhase) {
        $targetPhaseName = $phases[$targetPhase - 1].Groups[1].Value
    }
    
    # Check if all phases complete
    if ($targetPhase -eq 0) {
        $remaining = ([regex]::Matches($plan, '\[ \]')).Count
        if ($remaining -eq 0) {
            Show-TrisSuccess -Message "All phases done!"
            Write-TrisMessage "COMPLETE" "All phases appear complete! Run 'ai-finish' to archive."
            return
        }
        $targetPhase = 1  # Default to phase 1 if no phases detected
    }
    
    Write-TrisMessage "CONTINUE" "Continuing with Phase $targetPhase..."
    if ($targetPhaseName) {
        Write-Host "    $targetPhaseName" -ForegroundColor Cyan
    }
    Write-Host ""
    
    # Load execution template
    $templatePath = "$ctx/commands/core/execute.md"
    if (!(Test-Path $templatePath)) {
        $templatePath = Join-Path $script:TemplatePath "commands" "core" "execute.md"
    }
    $template = ""
    if (Test-Path $templatePath) {
        $template = Get-Content $templatePath -Raw -ErrorAction SilentlyContinue
    }
    
    # Build continuation prompt
    $prompt = @"
SYSTEM CONTEXT:
- Orchestrator: Trismegistus v1.2.1
- Mode: CONTINUATION (Resuming interrupted work)
- Target: Phase $targetPhase

RULES:
$($context.rules)

LESSONS LEARNED (Avoid these mistakes):
$($context.lessons)

FULL PLAN:
$($context.plan)

CONTINUATION INSTRUCTIONS:
═══════════════════════════════════════════════════════════════
You are CONTINUING work on an in-progress plan.

1. FOCUS ON PHASE $targetPhase
   - Earlier phases should already be complete (marked [x])
   - Do NOT redo completed work
   
2. EXECUTE remaining tasks in Phase $targetPhase
   - Look for tasks marked with [ ] (incomplete)
   - Mark each task [x] as you complete it
   
3. VERIFY before marking complete
   - Test your changes work
   - Check for regressions
   
4. TRACK PROGRESS
   - Write status updates to '$ctx/active/progress.txt'
   - Format: "[timestamp] Completed: <task description>"

CRITICAL - COMMIT MESSAGE:
When Phase $targetPhase is complete, create '$ctx/commit_msg.txt' containing:
'feat: complete phase $targetPhase - <brief description>'
═══════════════════════════════════════════════════════════════
"@

    Set-Clipboard -Value $prompt
    Write-TrisMessage "SCRIBE" "Continuation context prepared. Opening portal..."
    
    Invoke-Oracle -Prompt $prompt -CommandName "ai-continue" -Provider $Provider -Interactive
}

# ============================================================================
# VALIDATION & REVIEW COMMANDS
# ============================================================================

function ai-diff {
    <#
    .SYNOPSIS
        Show human-readable summary of changes since last commit
    .DESCRIPTION
        Displays what files changed, additions/deletions, and a summary.
        Essential for understanding what AI actually modified.
    .PARAMETER Detailed
        Show detailed file-by-file changes
    #>
    param([switch]$Detailed)
    
    Write-TrisMessage "DIFF" "Analyzing changes..."
    Write-Host ""
    
    # Check if we're in a git repo
    if (!(Test-Path ".git")) {
        Write-TrisMessage "VOID" "Not a git repository."
        return
    }
    
    # Get stats
    $stats = git diff --stat HEAD 2>$null
    $shortstat = git diff --shortstat HEAD 2>$null
    
    if ([string]::IsNullOrWhiteSpace($shortstat)) {
        Write-TrisMessage "INFO" "No uncommitted changes."
        return
    }
    
    # Parse shortstat
    $filesChanged = 0; $additions = 0; $deletions = 0
    if ($shortstat -match '(\d+) files? changed') { $filesChanged = [int]$Matches[1] }
    if ($shortstat -match '(\d+) insertions?') { $additions = [int]$Matches[1] }
    if ($shortstat -match '(\d+) deletions?') { $deletions = [int]$Matches[1] }
    
    # Show visual stats
    Show-TrisDiff -Added $additions -Removed $deletions -Files $filesChanged
    
    # List changed files
    Write-TrisMessage "REVEAL" "Changed files:"
    $changedFiles = git diff --name-status HEAD 2>$null
    $changedFiles -split "`n" | Where-Object { $_ } | ForEach-Object {
        $parts = $_ -split "`t"
        $status = $parts[0]
        $file = $parts[1]
        
        $statusIcon = switch ($status) {
            "M" { "~"; "Yellow" }
            "A" { "+"; "Green" }
            "D" { "-"; "Red" }
            "R" { ">"; "Cyan" }
            default { "?"; "Gray" }
        }
        $color = switch ($status) {
            "M" { "Yellow" }
            "A" { "Green" }
            "D" { "Red" }
            "R" { "Cyan" }
            default { "Gray" }
        }
        
        Write-Host "    $statusIcon $file" -ForegroundColor $color
    }
    
    Write-Host ""
    
    # Detailed view
    if ($Detailed) {
        Write-TrisMessage "INFO" "Detailed changes:"
        git diff --color HEAD | Out-Host
    } else {
        Write-TrisMessage "INFO" "Run 'ai-diff -Detailed' for full diff"
    }
}

function ai-test {
    <#
    .SYNOPSIS
        Run tests and analyze failures
    .DESCRIPTION
        Detects test framework, runs tests, and if failures occur,
        analyzes them and suggests fixes.
    .PARAMETER Fix
        Automatically attempt to fix failing tests
    .PARAMETER Provider
        Override the default provider
    #>
    param(
        [switch]$Fix,
        [string]$Provider = $null
    )
    
    Write-TrisMessage "TEST" "Detecting test framework..."
    
    # Detect test framework
    $testCmd = $null
    $framework = $null
    
    if (Test-Path "package.json") {
        $pkg = Get-Content "package.json" -Raw | ConvertFrom-Json -ErrorAction SilentlyContinue
        if ($pkg.scripts.test) {
            $testCmd = "npm test"
            $framework = "npm/node"
        }
    }
    if (!$testCmd -and (Test-Path "pyproject.toml" -or Test-Path "pytest.ini" -or Test-Path "setup.py")) {
        $testCmd = "pytest -v"
        $framework = "pytest"
    }
    if (!$testCmd -and (Test-Path "Cargo.toml")) {
        $testCmd = "cargo test"
        $framework = "cargo"
    }
    if (!$testCmd -and (Test-Path "go.mod")) {
        $testCmd = "go test ./..."
        $framework = "go"
    }
    if (!$testCmd -and (Test-Path "*.sln")) {
        $testCmd = "dotnet test"
        $framework = "dotnet"
    }
    
    if (!$testCmd) {
        Write-TrisMessage "VOID" "Could not detect test framework."
        Write-TrisMessage "INFO" "Supported: npm, pytest, cargo, go, dotnet"
        return
    }
    
    Write-TrisMessage "INFO" "Framework: $framework"
    Write-TrisMessage "FORGE" "Running: $testCmd"
    Write-Host ""
    
    # Run tests and capture output
    $output = Invoke-Expression "$testCmd 2>&1" | Out-String
    $exitCode = $LASTEXITCODE
    
    Write-Host $output
    
    if ($exitCode -eq 0) {
        Show-TrisSuccess -Message "Tests passed!"
        Write-TrisMessage "COMPLETE" "All tests passed!"
        return
    }
    
    # Tests failed - analyze
    Write-Host ""
    Write-TrisMessage "CHAOS" "Tests failed! Analyzing..."
    Write-Host ""
    
    $ctx = Get-ContextFolder
    $context = Get-CoreContext
    
    $prompt = @"
SYSTEM CONTEXT:
- Orchestrator: Trismegistus v1.2.1
- Mode: TEST ANALYSIS
- Framework: $framework

TEST OUTPUT:
$output

RULES:
$($context.rules)

LESSONS:
$($context.lessons)

TASK:
Analyze the failing tests and provide:

1. FAILURE SUMMARY
   - Which tests failed
   - Root cause for each failure
   
2. FIX RECOMMENDATIONS
   - Specific code changes needed
   - File paths and line numbers if possible
   
3. IMPLEMENTATION $(if ($Fix) { "(EXECUTE FIXES)" } else { "(EXPLAIN ONLY)" })
$(if ($Fix) { "   - Implement the fixes directly
   - Run tests again to verify" } else { "   - Explain what changes are needed
   - Do not modify files yet" })
"@

    Set-Clipboard -Value $prompt
    Write-TrisMessage "ORACLE" "Consulting oracle about failures..."
    
    Invoke-Oracle -Prompt $prompt -CommandName "ai-test" -Provider $Provider -Interactive
}

function ai-review {
    <#
    .SYNOPSIS
        Code review actual changes (not the plan)
    .DESCRIPTION
        Reviews the actual code changes made, looking for:
        - Bugs and logic errors
        - Security issues
        - Style violations
        - Missing error handling
    .PARAMETER Provider
        Override the default provider
    #>
    param([string]$Provider = $null)
    
    Write-TrisMessage "REVIEW" "Gathering changes for review..."
    
    # Get the diff
    $diff = git diff HEAD 2>$null
    
    if ([string]::IsNullOrWhiteSpace($diff)) {
        Write-TrisMessage "VOID" "No changes to review."
        return
    }
    
    $ctx = Get-ContextFolder
    $context = Get-CoreContext
    
    # Get changed files with context
    $changedFiles = git diff --name-only HEAD 2>$null
    $fileContents = @()
    
    foreach ($file in ($changedFiles -split "`n" | Where-Object { $_ })) {
        if (Test-Path $file) {
            $content = Get-Content $file -Raw -ErrorAction SilentlyContinue
            if ($content.Length -lt 10000) {  # Skip very large files
                $fileContents += "=== FILE: $file ===`n$content`n"
            }
        }
    }
    
    $prompt = @"
SYSTEM CONTEXT:
- Orchestrator: Trismegistus v1.2.1
- Mode: CODE REVIEW (Hostile Reviewer)

PROJECT RULES:
$($context.rules)

LESSONS LEARNED:
$($context.lessons)

DIFF (Changes to review):
$diff

FULL FILE CONTENTS (for context):
$($fileContents -join "`n")

CODE REVIEW INSTRUCTIONS:
═══════════════════════════════════════════════════════════════
You are a HOSTILE CODE REVIEWER. Your job is to find problems.

Review Categories:
1. 🔴 CRITICAL - Bugs, security issues, data loss risks
2. 🟠 IMPORTANT - Logic errors, missing validation, edge cases
3. 🟡 MODERATE - Style issues, unclear code, missing docs
4. 🟢 MINOR - Nitpicks, suggestions, improvements

For each issue found:
- Severity level
- File and line number
- Description of problem
- Suggested fix

Final Verdict:
- APPROVED - Safe to commit
- NEEDS CHANGES - List blockers
- REJECTED - Critical issues found

Be thorough but fair. Not every diff needs changes.
═══════════════════════════════════════════════════════════════
"@

    Set-Clipboard -Value $prompt
    Write-TrisMessage "JUDGE" "Submitting for hostile review..."
    
    Invoke-Oracle -Prompt $prompt -CommandName "ai-review" -Provider $Provider -Interactive
}

function ai-context {
    <#
    .SYNOPSIS
        Debug view of what gets injected into prompts
    .DESCRIPTION
        Shows exactly what context the AI receives, useful for
        troubleshooting when AI seems to be missing information.
    .PARAMETER Full
        Show complete content (not truncated)
    #>
    param([switch]$Full)
    
    Write-TrisBanner -Mini
    Write-Host ""
    Write-TrisMessage "CONTEXT" "Debug: What the AI sees"
    Write-Host ""
    
    $ctx = Get-ContextFolder
    $maxLen = if ($Full) { 999999 } else { 500 }
    
    # Helper to truncate
    function Show-Section {
        param($Title, $Path, $Color = "Cyan")
        Write-Host "┌─ $Title " -NoNewline -ForegroundColor $Color
        if (Test-Path $Path) {
            $content = Get-Content $Path -Raw
            $size = $content.Length
            Write-Host "[$size chars]" -ForegroundColor DarkGray
            Write-Host "│" -ForegroundColor $Color
            
            if ($size -gt $maxLen) {
                $content = $content.Substring(0, $maxLen) + "`n... (truncated, use -Full to see all)"
            }
            $content -split "`n" | ForEach-Object {
                Write-Host "│ " -NoNewline -ForegroundColor $Color
                Write-Host $_ -ForegroundColor Gray
            }
        } else {
            Write-Host "[NOT FOUND]" -ForegroundColor Red
        }
        Write-Host "└───────────────────────────────────────" -ForegroundColor $Color
        Write-Host ""
    }
    
    # Show context folder
    Write-TrisMessage "INFO" "Context folder: $ctx"
    Write-Host ""
    
    # Show each component
    Show-Section "CLAUDE.md (Rules)" "$ctx/CLAUDE.md" "Yellow"
    Show-Section "active/prd.md (Requirements)" "$ctx/active/prd.md" "Blue"
    Show-Section "active/plan.md (Current Plan)" "$ctx/active/plan.md" "Cyan"
    Show-Section "memory/lessons.md (Lessons)" "$ctx/memory/lessons.md" "Magenta"
    
    # Show references
    if (Test-Path "$ctx/reference") {
        $refs = Get-ChildItem "$ctx/reference/*.md" -ErrorAction SilentlyContinue
        Write-TrisMessage "INFO" "Reference docs: $($refs.Count) files"
        $refs | ForEach-Object {
            $size = (Get-Content $_.FullName -Raw).Length
            Write-Host "    - $($_.Name) [$size chars]" -ForegroundColor Gray
        }
        Write-Host ""
    }
    
    # Show file tree sample
    Write-TrisMessage "INFO" "Project tree (sample):"
    Get-ChildItem -Recurse -Name -ErrorAction SilentlyContinue | 
        Where-Object { $_ -notmatch 'node_modules|\.git|dist|build|\.tris|\.claude' } |
        Select-Object -First 20 |
        ForEach-Object { Write-Host "    $_" -ForegroundColor DarkGray }
    Write-Host "    ..." -ForegroundColor DarkGray
    Write-Host ""
    
    Write-TrisMessage "INFO" "This is approximately what gets injected into AI prompts."
}

# ============================================================================
# DOCUMENTATION & RESEARCH COMMANDS
# ============================================================================

function ai-explain {
    <#
    .SYNOPSIS
        Explain what a file or function does
    .DESCRIPTION
        Analyzes code and provides clear explanation of:
        - Purpose and functionality
        - Key components
        - How it fits in the project
    .PARAMETER Path
        File path to explain
    .PARAMETER Function
        Specific function/class to explain (optional)
    .PARAMETER Provider
        Override the default provider
    #>
    param(
        [Parameter(Mandatory)]
        [string]$Path,
        [string]$Function = "",
        [string]$Provider = $null
    )
    
    if (!(Test-Path $Path)) {
        Write-TrisMessage "VOID" "File not found: $Path"
        return
    }
    
    Write-TrisMessage "EXPLAIN" "Analyzing: $Path"
    
    $content = Get-Content $Path -Raw
    $ctx = Get-ContextFolder
    $context = Get-CoreContext
    
    $functionFilter = ""
    if ($Function) {
        $functionFilter = "`nFOCUS ON: The function/class/component named '$Function'"
    }
    
    $prompt = @"
SYSTEM CONTEXT:
- Orchestrator: Trismegistus v1.2.1
- Mode: CODE EXPLANATION

PROJECT CONTEXT:
$($context.rules)

FILE TO EXPLAIN: $Path
$functionFilter

FILE CONTENTS:
$content

EXPLANATION TASK:
═══════════════════════════════════════════════════════════════
Provide a clear, educational explanation of this code:

1. PURPOSE
   - What does this file/function do?
   - Why does it exist?

2. HOW IT WORKS
   - Key logic flow
   - Important algorithms or patterns
   - Dependencies and imports

3. INTEGRATION
   - How does it fit in the larger project?
   - What calls it? What does it call?

4. KEY DETAILS
   - Important variables/constants
   - Edge cases handled
   - Potential gotchas

Write as if explaining to a new team member.
═══════════════════════════════════════════════════════════════
"@

    Set-Clipboard -Value $prompt
    Invoke-Oracle -Prompt $prompt -CommandName "ai-explain" -Provider $Provider -Interactive
}

function ai-docs {
    <#
    .SYNOPSIS
        Generate or update documentation
    .DESCRIPTION
        Analyzes recent changes and generates appropriate documentation:
        - README updates
        - API documentation
        - Code comments
        - Usage examples
    .PARAMETER Type
        Documentation type: readme, api, comments, all
    .PARAMETER Provider
        Override the default provider
    #>
    param(
        [ValidateSet("readme", "api", "comments", "all")]
        [string]$Type = "all",
        [string]$Provider = $null
    )
    
    Write-TrisMessage "DOCS" "Analyzing project for documentation..."
    
    $ctx = Get-ContextFolder
    $context = Get-CoreContext
    
    # Get recent changes
    $recentChanges = git log --oneline -10 2>$null | Out-String
    $changedFiles = git diff --name-only HEAD~5 HEAD 2>$null | Out-String
    
    # Get existing README
    $readme = ""
    if (Test-Path "README.md") {
        $readme = Get-Content "README.md" -Raw
    }
    
    $prompt = @"
SYSTEM CONTEXT:
- Orchestrator: Trismegistus v1.2.1
- Mode: DOCUMENTATION GENERATION
- Type: $Type

PROJECT RULES:
$($context.rules)

RECENT COMMITS:
$recentChanges

RECENTLY CHANGED FILES:
$changedFiles

CURRENT README.md:
$readme

DOCUMENTATION TASK:
═══════════════════════════════════════════════════════════════
Generate/update documentation based on the documentation type:

$(switch ($Type) {
    "readme" { "Generate a comprehensive README.md with:
- Project description
- Installation instructions
- Usage examples
- Configuration options
- Contributing guidelines" }
    "api" { "Generate API documentation with:
- Endpoint descriptions
- Request/response formats
- Authentication details
- Example calls" }
    "comments" { "Add/update code comments:
- Function docstrings
- Complex logic explanations
- TODO/FIXME annotations" }
    "all" { "Generate all applicable documentation:
- README.md updates
- Inline code comments
- Any API docs if applicable" }
})

Write documentation that is:
- Clear and concise
- Up-to-date with recent changes
- Helpful for new users/developers
═══════════════════════════════════════════════════════════════
"@

    Set-Clipboard -Value $prompt
    Write-TrisMessage "SCRIBE" "Generating documentation..."
    
    Invoke-Oracle -Prompt $prompt -CommandName "ai-docs" -Provider $Provider -Interactive
}

function ai-research {
    <#
    .SYNOPSIS
        Deep research on a topic, saved to reference/
    .DESCRIPTION
        Researches unfamiliar technologies, APIs, or concepts
        and saves findings to the reference folder for future use.
    .PARAMETER Topic
        Topic to research
    .PARAMETER Provider
        Override the default provider
    #>
    param(
        [Parameter(Mandatory)]
        [string]$Topic,
        [string]$Provider = $null
    )
    
    Write-TrisMessage "RESEARCH" "Researching: $Topic"
    
    $ctx = Get-ContextFolder
    $safeTopic = $Topic -replace '[^a-zA-Z0-9\-_]', '-'
    $outputPath = "$ctx/reference/research-$safeTopic.md"
    
    # Ensure reference folder exists
    if (!(Test-Path "$ctx/reference")) {
        New-Item -ItemType Directory -Force -Path "$ctx/reference" | Out-Null
    }
    
    $context = Get-CoreContext
    
    $prompt = @"
SYSTEM CONTEXT:
- Orchestrator: Trismegistus v1.2.1  
- Mode: DEEP RESEARCH
- Topic: $Topic

PROJECT CONTEXT:
$($context.rules)

RESEARCH TASK:
═══════════════════════════════════════════════════════════════
Conduct thorough research on: $Topic

Create a reference document covering:

1. OVERVIEW
   - What is it?
   - Why is it relevant to this project?

2. KEY CONCEPTS
   - Core terminology
   - Important principles
   - Common patterns

3. IMPLEMENTATION GUIDE
   - How to use/integrate
   - Code examples
   - Configuration options

4. BEST PRACTICES
   - Do's and don'ts
   - Common pitfalls
   - Performance considerations

5. RESOURCES
   - Official documentation links
   - Useful tutorials
   - Community resources

OUTPUT:
Save this research to: $outputPath

Format as clean Markdown for future reference.
═══════════════════════════════════════════════════════════════
"@

    Set-Clipboard -Value $prompt
    Write-TrisMessage "ORACLE" "Consulting the oracle..."
    
    Invoke-Oracle -Prompt $prompt -CommandName "ai-research" -Provider $Provider -Interactive
    
    if (Test-Path $outputPath) {
        Write-TrisMessage "MANIFEST" "Research saved to: $outputPath"
    }
}

# ============================================================================
# ESTIMATION & PLANNING COMMANDS
# ============================================================================

function ai-estimate {
    <#
    .SYNOPSIS
        Estimate complexity before planning
    .DESCRIPTION
        Analyzes a task and provides:
        - Complexity rating (Low/Medium/High/Epic)
        - Time estimate
        - Risk factors
        - Recommendation (proceed or split)
    .PARAMETER Task
        Task to estimate
    .PARAMETER Provider
        Override the default provider
    #>
    param(
        [Parameter(Mandatory)]
        [string]$Task,
        [string]$Provider = $null
    )
    
    Write-TrisMessage "ESTIMATE" "Analyzing complexity..."
    
    $ctx = Get-ContextFolder
    $context = Get-CoreContext
    
    # Get project map
    $map = Get-ChildItem -Recurse -Name -ErrorAction SilentlyContinue | 
        Where-Object { $_ -notmatch 'node_modules|\.git|dist|build|\.tris|\.claude' } |
        Select-Object -First 500 | Out-String
    
    $prompt = @"
SYSTEM CONTEXT:
- Orchestrator: Trismegistus v1.2.1
- Mode: COMPLEXITY ESTIMATION

PROJECT STRUCTURE:
$map

PROJECT RULES:
$($context.rules)

TASK TO ESTIMATE:
$Task

ESTIMATION TASK:
═══════════════════════════════════════════════════════════════
Analyze this task and provide an estimate:

1. COMPLEXITY RATING
   🟢 LOW - Simple change, single file, <1 hour
   🟡 MEDIUM - Multiple files, some logic, 1-4 hours  
   🟠 HIGH - Significant changes, new features, 4-8 hours
   🔴 EPIC - Major feature, architectural changes, >8 hours

2. BREAKDOWN
   - Files likely to be modified
   - New files needed
   - Dependencies/integrations

3. RISK FACTORS
   - Technical risks
   - Unknown areas
   - Potential blockers

4. TIME ESTIMATE
   - Best case
   - Expected case
   - Worst case

5. RECOMMENDATION
   - ✅ PROCEED - Task is well-scoped
   - ⚠️ SPLIT FIRST - Task should be broken down
   - 🔬 RESEARCH FIRST - Need more information

If recommending SPLIT, suggest how to break it down.
═══════════════════════════════════════════════════════════════
"@

    Set-Clipboard -Value $prompt
    Invoke-Oracle -Prompt $prompt -CommandName "ai-estimate" -Provider $Provider -Interactive
}

function ai-split {
    <#
    .SYNOPSIS
        Break an oversized plan into phases
    .DESCRIPTION
        Takes the current plan and restructures it into
        manageable phases with clear boundaries.
    .PARAMETER Phases
        Number of phases to split into (default: auto)
    .PARAMETER Provider
        Override the default provider
    #>
    param(
        [int]$Phases = 0,
        [string]$Provider = $null
    )
    
    $ctx = Get-ContextFolder
    $planPath = "$ctx/active/plan.md"
    
    if (!(Test-Path $planPath)) {
        Write-TrisMessage "VOID" "No active plan to split."
        return
    }
    
    Write-TrisMessage "SPLIT" "Analyzing plan for restructuring..."
    
    $plan = Get-Content $planPath -Raw
    $context = Get-CoreContext
    
    $phaseHint = ""
    if ($Phases -gt 0) {
        $phaseHint = "Target: $Phases phases"
    }
    
    $prompt = @"
SYSTEM CONTEXT:
- Orchestrator: Trismegistus v1.2.1
- Mode: PLAN RESTRUCTURING
$phaseHint

PROJECT RULES:
$($context.rules)

CURRENT PLAN:
$plan

SPLIT TASK:
═══════════════════════════════════════════════════════════════
This plan needs to be restructured into clear phases.

Guidelines for splitting:
1. Each phase should be INDEPENDENTLY TESTABLE
2. Each phase should take 1-4 hours max
3. Phases should have clear dependencies
4. Each phase produces working (if incomplete) code

For each phase:
- Clear goal/deliverable
- Specific tasks (with checkboxes)
- Validation criteria
- Dependencies on previous phases

OVERWRITE the plan at '$planPath' with the restructured version.

Format:
## Phase 1: [Name]
Goal: [What this phase achieves]
Dependencies: [None / Phase X]

- [ ] Task 1
- [ ] Task 2

Validation: [How to verify phase is complete]

---

## Phase 2: [Name]
...
═══════════════════════════════════════════════════════════════
"@

    Set-Clipboard -Value $prompt
    Write-TrisMessage "ORACLE" "Consulting oracle for restructuring..."
    
    Invoke-Oracle -Prompt $prompt -CommandName "ai-split" -Provider $Provider -Interactive
}

# ============================================================================
# SHIPPING COMMANDS
# ============================================================================

function ai-changelog {
    <#
    .SYNOPSIS
        Generate changelog from recent work
    .DESCRIPTION
        Analyzes git history and generates a formatted
        changelog entry.
    .PARAMETER Since
        Generate changelog since this reference (tag, commit, date)
    .PARAMETER Provider
        Override the default provider
    #>
    param(
        [string]$Since = "HEAD~10",
        [string]$Provider = $null
    )
    
    Write-TrisMessage "CHANGELOG" "Analyzing git history..."
    
    # Get commit history
    $commits = git log "$Since..HEAD" --oneline 2>$null | Out-String
    $fullLog = git log "$Since..HEAD" --pretty=format:"%h %s%n%b" 2>$null | Out-String
    $diffStat = git diff --stat "$Since" HEAD 2>$null | Out-String
    
    if ([string]::IsNullOrWhiteSpace($commits)) {
        Write-TrisMessage "VOID" "No commits found since $Since"
        return
    }
    
    $ctx = Get-ContextFolder
    
    $prompt = @"
SYSTEM CONTEXT:
- Orchestrator: Trismegistus v1.2.1
- Mode: CHANGELOG GENERATION

COMMITS SINCE $Since`:
$fullLog

FILES CHANGED:
$diffStat

CHANGELOG TASK:
═══════════════════════════════════════════════════════════════
Generate a changelog entry following Keep a Changelog format.

Categories:
- Added: New features
- Changed: Changes to existing functionality
- Deprecated: Features to be removed
- Removed: Removed features
- Fixed: Bug fixes
- Security: Security fixes

Output format:
## [Version] - YYYY-MM-DD

### Added
- Description of new feature

### Changed
- Description of change

### Fixed
- Description of fix

Be concise but descriptive. Group related changes.
═══════════════════════════════════════════════════════════════
"@

    Set-Clipboard -Value $prompt
    Invoke-Oracle -Prompt $prompt -CommandName "ai-changelog" -Provider $Provider -Interactive
}

function ai-ship {
    <#
    .SYNOPSIS
        Complete shipping pipeline: diff → review → test → commit
    .DESCRIPTION
        Runs the full quality gate pipeline before committing:
        1. Show diff summary
        2. Run code review
        3. Run tests
        4. If all pass, commit
    .PARAMETER Force
        Skip confirmation prompts
    .PARAMETER SkipTests
        Skip the test phase
    .PARAMETER Provider
        Override the default provider
    #>
    param(
        [switch]$Force,
        [switch]$SkipTests,
        [string]$Provider = $null
    )
    
    Write-TrisBanner -Mini
    Write-Host ""
    Write-TrisMessage "SHIP" "Starting shipping pipeline..."
    Write-Host ""
    
    # Phase 1: Diff
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
    Write-Host " PHASE 1: CHANGE SUMMARY" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
    
    $diff = git diff --shortstat HEAD 2>$null
    if ([string]::IsNullOrWhiteSpace($diff)) {
        Write-TrisMessage "VOID" "No changes to ship."
        return
    }
    
    ai-diff
    
    if (!$Force) {
        $continue = Read-Host "`nContinue to review? (Y/n)"
        if ($continue -eq 'n') { return }
    }
    
    # Phase 2: Review
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
    Write-Host " PHASE 2: CODE REVIEW" -ForegroundColor Magenta
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
    
    ai-review -Provider $Provider
    
    if (!$Force) {
        $continue = Read-Host "`nReview complete. Continue to tests? (Y/n)"
        if ($continue -eq 'n') { return }
    }
    
    # Phase 3: Tests
    if (!$SkipTests) {
        Write-Host ""
        Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
        Write-Host " PHASE 3: TESTS" -ForegroundColor Blue
        Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
        
        ai-test -Provider $Provider
        
        if (!$Force) {
            $continue = Read-Host "`nTests complete. Continue to commit? (Y/n)"
            if ($continue -eq 'n') { return }
        }
    }
    
    # Phase 4: Commit
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
    Write-Host " PHASE 4: COMMIT" -ForegroundColor Green
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
    
    ai-commit
    
    # Celebration animation
    Show-TrisShipAnimation
    Show-TrisSuccess -Message "Shipped!"
}

# ============================================================================
# CONFIGURATION COMMANDS
# ============================================================================

function ai-setup {
    <#
    .SYNOPSIS
        Interactive first-time setup
    #>
    Invoke-TrisSetup
}

function ai-config {
    <#
    .SYNOPSIS
        View or modify configuration
    .DESCRIPTION
        Usage: ai-config                     - Show current config
               ai-config set <key> <value>   - Set a config value
    .EXAMPLE
        ai-config set default gemini
        ai-config set providers.gemini.enabled true
        ai-config set routing.ai-plan claude
    #>
    param(
        [Parameter(Position=0)]
        [string]$Action = "",
        [Parameter(Position=1)]
        [string]$Key = "",
        [Parameter(Position=2)]
        [string]$Value = ""
    )
    
    if ($Action -eq "set" -and $Key -and $Value) {
        Set-TrisConfigValue -Key $Key -Value $Value
    } elseif ($Action -eq "" -or $Action -eq "show") {
        Show-TrisConfig
    } else {
        Write-Host "Usage:" -ForegroundColor Yellow
        Write-Host "  ai-config                      - Show current config"
        Write-Host "  ai-config set <key> <value>    - Set a config value"
        Write-Host ""
        Write-Host "Examples:" -ForegroundColor Yellow
        Write-Host "  ai-config set default gemini"
        Write-Host "  ai-config set providers.gemini.enabled true"
        Write-Host "  ai-config set routing.ai-plan claude"
    }
}

function ai-providers {
    <#
    .SYNOPSIS
        List available AI providers
    #>
    Write-TrisMessage "REVEAL" "Available Oracles:"
    Write-Host ""
    
    $providers = Get-AvailableProviders
    
    foreach ($p in $providers) {
        $status = if ($p.Enabled) { "[ENABLED]" } else { "[disabled]" }
        $color = if ($p.Enabled) { "Green" } else { "DarkGray" }
        Write-Host "  $($p.Name.PadRight(10)) $status  Model: $($p.Model)" -ForegroundColor $color
    }
    
    Write-Host ""
    Write-TrisMessage "INFO" "Enable providers with: ai-config set providers.<name>.enabled true"
}

# ============================================================================
# PIPELINES
# ============================================================================

function ai-flow-feature {
    <#
    .SYNOPSIS
        Full feature pipeline: Architect → Plan → Verify
    .PARAMETER Task
        Feature description
    #>
    param([Parameter(Mandatory)][string]$Task)
    
    Write-TrisBanner -Mini
    Write-TrisMessage "INVOKE" "Initiating Feature Pipeline: $Task"
    
    Write-Host "`n[1/3] Architecture Phase" -ForegroundColor Magenta
    ai-architect $Task
    Read-Host "Press Enter after reviewing architecture..."
    
    Write-Host "`n[2/3] Planning Phase" -ForegroundColor Cyan
    ai-plan "Implement: $Task. Follow architecture_decision.md."
    Read-Host "Press Enter after reviewing plan..."
    
    Write-Host "`n[3/3] Verification Phase" -ForegroundColor Yellow
    ai-verify
    
    Write-Host ""
    Write-TrisMessage "COMPLETE" "Pipeline complete. Run 'ai-exec' to build."
}

function ai-flow-bugfix {
    <#
    .SYNOPSIS
        Full bugfix pipeline: Debug → Plan → Fix
    .PARAMETER Issue
        Issue description
    #>
    param([Parameter(Mandatory)][string]$Issue)
    
    Write-TrisBanner -Mini
    Write-TrisMessage "INVOKE" "Initiating Bugfix Pipeline: $Issue"
    
    Write-Host "`n[1/2] Analysis Phase" -ForegroundColor Cyan
    ai-debug
    Read-Host "Press Enter after reviewing analysis..."
    
    Write-Host "`n[2/2] Execution Phase" -ForegroundColor Yellow
    ai-exec
    
    Write-TrisMessage "COMPLETE" "Bugfix complete. Run 'ai-commit' when ready."
}

# ============================================================================
# STARTUP
# ============================================================================

# Display subtle initialization message
if ($script:Config.theme -eq "hermetic") {
    Show-TrisWelcome
}
