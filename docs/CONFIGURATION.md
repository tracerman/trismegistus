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
# Heavy reasoning tasks → best model
ai-config set routing.ai-plan claude
ai-config set routing.ai-architect claude
ai-config set routing.ai-verify claude
ai-config set routing.ai-exec claude

# Quick/cheap tasks → local or fast model
ai-config set routing.ai-ask ollama
ai-config set routing.ai-commit ollama
ai-config set routing.ai-debug auto
```

### Auto Routing

Setting a route to `auto` uses the default provider, or falls back to the cheapest available:

```powershell
ai-config set routing.ai-ask auto
```

### Recommended Setup

**If you have Claude + Ollama:**
```powershell
ai-config set routing.ai-plan claude
ai-config set routing.ai-exec claude
ai-config set routing.ai-verify claude
ai-config set routing.ai-architect claude
ai-config set routing.ai-ask ollama      # Free & fast
ai-config set routing.ai-commit ollama   # Free & fast
ai-config set routing.ai-debug ollama    # Free & fast
```

**If you only have Claude:**
```powershell
# Leave everything at defaults - all routes to Claude
```

**If you prefer local-only (privacy):**
```powershell
ai-config set default ollama
# All commands will use Ollama
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
    "ai-commit": "ollama",
    "ai-ask": "ollama",
    "ai-debug": "auto"
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

Each project can have its own rules in `.claude/CLAUDE.md`:

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

Your project requirements document in `.claude/active/prd.md`:

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

## Reset Configuration

To start fresh:

```powershell
Remove-Item ~/.trismegistus/config.json
ai-setup
```

---

*"As above, so below; as below, so above."*
