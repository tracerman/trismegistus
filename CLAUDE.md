# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Trismegistus is a multi-oracle agentic orchestrator for AI-powered software development. It provides a unified PowerShell interface to route tasks to different AI providers (Claude, Gemini, Ollama, OpenAI) with persistent project context through a `.tris/` directory.

## Tech Stack

- **Language**: PowerShell 7+ (cross-platform)
- **Supported AI CLIs**: claude, gemini, ollama, openai, llm, aichat
- **Configuration**: JSON (`~/.trismegistus/config.json`)

## Architecture

### Core Modules (`core/`)

- **profile.ps1** - Main entry point, loads all modules and defines 35+ `ai-*` commands
- **router.ps1** - Routes commands to appropriate AI provider based on config
- **config.ps1** - Configuration management (setup wizard, get/set values)

### Provider Adapters (`core/adapters/`)

Each adapter (claude.ps1, gemini.ps1, ollama.ps1, openai.ps1) implements:
- `Test-<Provider>Available` - Check if CLI is installed
- `Invoke-<Provider>Oracle` - Execute prompts via that provider
- `Get-<Provider>Config` - Return provider capabilities and defaults

### Theme System (`themes/`)

- **hermetic.ps1** - Visual output functions (banners, spinners, progress bars, messages)
- Theme provides `Write-TrisMessage`, `Show-TrisProgress`, `Show-TrisDiff`, etc.

### Command Templates (`templates/`)

Markdown templates injected into prompts for consistent AI behavior:
- `commands/core/` - plan-feature.md, execute.md, prime.md
- `commands/validation/` - code-review.md, validate.md
- `commands/bugfix/` - rca.md, implement-fix.md

## Key Patterns

### Context Folder Detection

Projects use `.tris/` (new) or `.claude/` (legacy) for context storage:
```powershell
Get-ContextFolder  # Returns ".tris" or ".claude" based on what exists
Get-ContextPath "active/plan.md"  # Returns full path to context file
```

### Command Routing

Commands route to providers via config:
```powershell
$config.routing["ai-plan"] = "claude"  # Route planning to Claude
$config.routing["ai-commit"] = "ollama"  # Route commits to local Ollama
```

### Oracle Invocation

All AI calls go through `Invoke-Oracle`:
```powershell
Invoke-Oracle -Prompt $prompt -CommandName "ai-plan" -Provider $Provider -Interactive
```

### Context Assembly

Commands assemble context from multiple sources:
```powershell
$context = Get-CoreContext  # Loads rules, PRD, lessons, plan
$map = Get-ProjectMap       # Generates filtered file tree
$refs = Get-SmartReferences -Context $Task  # Keyword-matched docs
```

## Common Development Commands

```powershell
# Reload after changes to core modules
. $PROFILE

# Test installation
ai-help

# View current config
ai-config

# Test provider detection
ai-providers
```

## Project Context Structure

When `ai-init` runs in a project, it creates:
```
.tris/
  CLAUDE.md          # Project-specific rules
  active/
    prd.md           # Requirements document
    plan.md          # Current execution plan
    progress.txt     # Checkpoint tracking
  memory/
    lessons.md       # Accumulated lessons
  reference/         # Research and docs
  commands/          # Custom templates
```

## Adding New Providers

1. Create `core/adapters/<provider>.ps1` with required functions
2. Add provider to `$script:AvailableProviders` in router.ps1
3. Add default config in `Get-TrisConfig` defaults
4. Update `Invoke-TrisSetup` in config.ps1 for detection

## Adding New Commands

Commands are PowerShell functions in `profile.ps1` following pattern:
```powershell
function ai-newcmd {
    param([string]$Provider = $null)

    $ctx = Get-ContextFolder
    $context = Get-CoreContext

    $prompt = @"
    # Build prompt with context
"@

    Invoke-Oracle -Prompt $prompt -CommandName "ai-newcmd" -Provider $Provider -Interactive
}
```
