# Configuration Guide

> *"To change your mood or mental state, change your vibration."*

Complete reference for Trismegistus configuration options.

---

## Configuration File

Location: `~/.trismegistus/config.json`

View current config:
```powershell
ai-config
```

---

## General Settings

### Default Provider

The AI provider used when no specific routing is defined.

```powershell
ai-config set default claude
ai-config set default ollama
ai-config set default gemini
```

### Theme

Visual theme for terminal output.

```powershell
ai-config set theme hermetic   # Alchemical (default)
ai-config set theme minimal    # Clean, simple
ai-config set theme matrix     # Hacker aesthetic
```

---

## Provider Configuration

### Enable/Disable Providers

```powershell
# Enable a provider
ai-config set providers.ollama.enabled true

# Disable a provider
ai-config set providers.gemini.enabled false
```

### Set Provider Models

```powershell
# Claude models
ai-config set providers.claude.model claude-opus-4-5-20251101
ai-config set providers.claude.model claude-sonnet-4-5-20250929
ai-config set providers.claude.model claude-haiku-4-5-20251001

# Gemini models
ai-config set providers.gemini.model gemini-3-pro
ai-config set providers.gemini.model gemini-3-flash

# OpenAI models
ai-config set providers.openai.model gpt-5.2-codex
ai-config set providers.openai.model gpt-5
ai-config set providers.openai.model o3

# Ollama models (local)
ai-config set providers.ollama.model llama4
ai-config set providers.ollama.model deepseek-coder-v3
ai-config set providers.ollama.model qwen3-coder
```

---

## Command Routing

Route specific commands to specific providers. This is powerful for cost optimization.

### View Current Routing

```powershell
ai-config
# Look for "Command Routing:" section
```

### Set Routing

```powershell
# Syntax
ai-config set routing.<command-name> <provider>
```

### All Routable Commands

| Command | Purpose | Recommended Provider |
|---------|---------|---------------------|
| **Planning Phase** | | |
| `ai-plan` | Create execution plan | claude (complex) |
| `ai-verify` | Hostile plan review | claude |
| `ai-architect` | Tree of Thoughts design | claude |
| `ai-estimate` | Complexity analysis | claude |
| `ai-research` | Deep research | claude |
| `ai-split` | Break plan into phases | ollama |
| **Execution Phase** | | |
| `ai-exec` | Execute the plan | claude |
| `ai-continue` | Resume execution | claude |
| `ai-progress` | View phase status | ollama (simple) |
| `ai-debug` | Analyze errors | claude |
| `ai-ask` | Quick consultation | ollama |
| **Validation Phase** | | |
| `ai-diff` | Show changes | ollama (simple) |
| `ai-test` | Run & analyze tests | ollama |
| `ai-review` | Code review | claude |
| `ai-explain` | Explain code | claude |
| `ai-context` | Debug AI context | ollama |
| **Shipping Phase** | | |
| `ai-commit` | Generate commit msg | ollama |
| `ai-docs` | Generate documentation | claude |
| `ai-changelog` | Generate changelog | ollama |
| `ai-finish` | Archive & learn | claude |
| `ai-ship` | Full pipeline | (uses other routes) |

### Example Routing Configuration

```powershell
# Heavy reasoning tasks → best model
ai-config set routing.ai-plan claude
ai-config set routing.ai-architect claude
ai-config set routing.ai-verify claude
ai-config set routing.ai-exec claude
ai-config set routing.ai-review claude
ai-config set routing.ai-continue claude
ai-config set routing.ai-explain claude
ai-config set routing.ai-docs claude
ai-config set routing.ai-estimate claude
ai-config set routing.ai-research claude

# Quick/cheap tasks → local or fast model
ai-config set routing.ai-ask ollama
ai-config set routing.ai-commit ollama
ai-config set routing.ai-debug ollama
ai-config set routing.ai-diff ollama
ai-config set routing.ai-test ollama
ai-config set routing.ai-progress ollama
ai-config set routing.ai-context ollama
ai-config set routing.ai-split ollama
ai-config set routing.ai-changelog ollama
```

### Auto Routing

Setting a route to `auto` uses the default provider, or falls back to the cheapest available:

```powershell
ai-config set routing.ai-ask auto
```

### Recommended Setups

**Cost-Optimized (Claude + Ollama):**
```powershell
# Complex tasks → Claude
ai-config set routing.ai-plan claude
ai-config set routing.ai-exec claude
ai-config set routing.ai-verify claude
ai-config set routing.ai-architect claude
ai-config set routing.ai-review claude
ai-config set routing.ai-continue claude

# Simple tasks → Ollama (free)
ai-config set routing.ai-ask ollama
ai-config set routing.ai-commit ollama
ai-config set routing.ai-diff ollama
ai-config set routing.ai-test ollama
ai-config set routing.ai-progress ollama
ai-config set routing.ai-context ollama
```

**Privacy-First (Ollama Only):**
```powershell
ai-config set default ollama
# All commands will use Ollama (local, no data sent externally)
```

**Maximum Quality (Claude Only):**
```powershell
ai-config set default claude
# All commands use Claude (best quality, higher cost)
```

---

## Preferences

### Protected Branches

Branches where direct commits are blocked:

```powershell
# View current
ai-config
# Look for "Protected Branches:"

# Modify (edit config.json directly)
code ~/.trismegistus/config.json
```

Default: `main`, `master`, `production`, `prod`

### Max Context Files

Maximum number of files included in the project map:

```powershell
# Edit config.json
code ~/.trismegistus/config.json
# Change "maxContextFiles": 3000
```

Reduce this if you're hitting token limits or slow performance.

### Lessons Warning Threshold

When `lessons.md` exceeds this line count, you'll get a warning to run `ai-compress`:

```powershell
# Default is 100 lines
# Edit in config.json if needed
```

---

## Config File Structure

Full `config.json` structure:

```json
{
  "default": "claude",
  "theme": "hermetic",
  "providers": {
    "claude": {
      "enabled": true,
      "model": "claude-opus-4-5-20251101"
    },
    "gemini": {
      "enabled": false,
      "model": "gemini-3-pro"
    },
    "ollama": {
      "enabled": true,
      "model": "llama4"
    },
    "openai": {
      "enabled": false,
      "model": "gpt-5.2-codex"
    }
  },
  "routing": {
    "ai-plan": "claude",
    "ai-exec": "claude",
    "ai-verify": "claude",
    "ai-architect": "claude",
    "ai-review": "claude",
    "ai-continue": "claude",
    "ai-estimate": "claude",
    "ai-research": "claude",
    "ai-explain": "claude",
    "ai-docs": "claude",
    "ai-commit": "ollama",
    "ai-ask": "ollama",
    "ai-debug": "ollama",
    "ai-diff": "ollama",
    "ai-test": "ollama",
    "ai-progress": "ollama",
    "ai-context": "ollama",
    "ai-split": "ollama",
    "ai-changelog": "ollama"
  },
  "preferences": {
    "protectedBranches": ["main", "master", "production", "prod"],
    "maxContextFiles": 3000,
    "lessonsWarnThreshold": 100
  }
}
```

---

## Environment Variables

Optional environment variables:

| Variable | Purpose | Default |
|----------|---------|---------|
| `TRIS_ROOT` | Installation directory | `~/.trismegistus` |
| `TRIS_TEMPLATES` | Templates directory | `~/.trismegistus/templates` |

---

## Project-Level Configuration

### CLAUDE.md

Each project can have its own rules in `.tris/CLAUDE.md`:

```markdown
# Project Rules

## Stack
- React 18 + TypeScript
- Tailwind CSS
- Vite

## Style
- Use functional components only
- Prefer named exports
- Use absolute imports (@/)

## Forbidden
- No class components
- No inline styles
- No console.log in production code
```

This file is injected into every prompt for that project.

### PRD (prd.md)

Your project requirements document in `.tris/active/prd.md` (or `.claude/active/prd.md` for legacy projects):

```markdown
# Project: Chrome Extension

## Goal
Build a Chrome extension that replaces images with cats.

## MVP Features
- [ ] Replace <img> tags
- [ ] Toggle on/off
- [ ] Settings page

## Tech Stack
- Manifest V3
- TypeScript
- React for popup
```

---

## Context Folder

Trismegistus stores project-specific context (plans, lessons, rules) in a folder.

### Default Behavior

- **New projects**: Uses `.tris/` folder
- **Legacy projects**: Automatically detects and uses existing `.claude/` folder

### Priority Order

1. Project-level `.trisconfig` file (explicit override)
2. Existing `.tris/` folder
3. Existing `.claude/` folder (backwards compat)
4. Default: `.tris/` (new projects)

### Per-Project Override

For legacy projects or specific requirements, create a `.trisconfig` file in your project root:

```json
{
    "contextFolder": ".claude"
}
```

This is useful for:
- Projects already using `.claude/` that you don't want to migrate
- Teams with existing `.claude/` conventions
- Gradual migration strategies

### Context Folder Structure

```
.tris/                  # or .claude/
├── CLAUDE.md           # Project rules (tech stack, conventions)
├── active/
│   ├── plan.md         # Current execution plan
│   ├── prd.md          # Project Requirements Document
│   └── progress.txt    # Execution checkpoint
├── memory/
│   ├── lessons.md      # Learned wisdom
│   └── completed_log.md
├── reference/          # API docs, architecture decisions, research
├── commands/           # Custom prompt templates
└── metrics/            # Usage tracking
```

---

## Reset Configuration

To start fresh:

```powershell
Remove-Item ~/.trismegistus/config.json
ai-setup
```

---

*"As above, so below; as below, so above."*
