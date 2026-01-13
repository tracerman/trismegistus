# ============================================================================
#  T R I S M E G I S T U S
#  "Thrice-Great" - Multi-Oracle Agentic Orchestrator
#  
#  Version: 1.0.0
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
- Orchestrator: Trismegistus v1.0
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
- Orchestrator: Trismegistus v1.0
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
        Write-TrisMessage "WARD" "You are on protected branch '$branch'!"
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
    
    Write-TrisMessage "COMPLETE" "The cycle is complete. Ready for the next Work."
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

  CORE COMMANDS
  ─────────────────────────────────────────────────────────
  ai-init                    Initialize project structure
  ai-plan  <task>            Create execution plan
  ai-exec  [-Resume]         Execute the plan
  ai-verify                  Hostile review of plan
  ai-commit [-DryRun] [-NoPush] [-Force]  Commit & push
  ai-finish                  Archive plan, extract lessons

  ADVANCED
  ─────────────────────────────────────────────────────────
  ai-architect <problem>     Tree of Thoughts design
  ai-hotfix <issue>          Emergency fix
  ai-rollback                Restore last checkpoint

  UTILITIES
  ─────────────────────────────────────────────────────────
  ai-ask <question>          Quick consultation
  ai-debug                   Analyze error from clipboard
  ai-evolve <lesson>         Add lesson to memory
  ai-status                  Show project status
  ai-compress                Compress lessons.md
  ai-wipe                    Clear active plan
  
  CONFIGURATION
  ─────────────────────────────────────────────────────────
  ai-setup                   First-time configuration
  ai-config                  Show/modify configuration
  ai-providers               List available AI providers

  PIPELINES
  ─────────────────────────────────────────────────────────
  ai-flow-feature <task>     Full: Architect → Plan → Verify
  ai-flow-bugfix <issue>     Full: Debug → Plan → Fix

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
    Write-Host "⚗️  Trismegistus ready. 'ai-help' for commands." -ForegroundColor DarkMagenta
}
