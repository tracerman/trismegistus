# Trismegistus

> *"As above, so below; as within, so without."* — The Emerald Tablet

**A multi-oracle agentic orchestrator for AI-powered software development.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PowerShell 7+](https://img.shields.io/badge/PowerShell-7%2B-blue.svg)](https://github.com/PowerShell/PowerShell)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

---

## Why Trismegistus?

Most AI coding tools lock you into one provider. Trismegistus lets you **route different tasks to different AI models** through a unified interface:

- Use **Claude** for complex architecture decisions
- Use **Ollama** (local, free) for quick questions and commit messages  
- Use **Gemini** for its massive context window
- **Fall back automatically** if a provider is down

Plus, it solves the "goldfish memory" problem with **persistent project context** that survives between sessions.

## Key Features

| Feature | Description |
|---------|-------------|
| **Multi-Oracle Routing** | Claude, Gemini, Ollama, OpenAI through one interface |
| **Persistent Memory** | Project context, lessons learned, execution plans |
| **Reflexion Loop** | AI critiques its own plans before execution |
| **Safety Rails** | Commit preview, branch protection, rollback |
| **Cross-Platform** | Windows, macOS, Linux via PowerShell 7 |

## Quick Demo

```powershell
# Initialize a project
ai-init

# Plan a feature (uses your configured "planning" model)
ai-plan "Add JWT authentication to the API"

# Have the AI critique its own plan
ai-verify

# Execute the plan
ai-exec

# Review and commit (uses your "quick tasks" model)
ai-commit
```

## Installation

### Prerequisites

- [PowerShell 7+](https://github.com/PowerShell/PowerShell) (required on all platforms)
- Git
- At least one AI CLI: `claude`, `gemini`, `ollama`, or `openai`

### Windows

```powershell
# Open PowerShell 7 (not Windows PowerShell!)
pwsh

# Run installer
.\install.ps1

# Reload and setup
. $PROFILE
ai-setup
```

### macOS / Linux

```bash
# Install PowerShell if needed
brew install powershell  # macOS
# sudo apt install powershell  # Ubuntu/Debian

# Run installer
chmod +x install.sh
./install.sh

# Enter PowerShell and setup
pwsh
ai-setup
```

## Commands

### Core Workflow

| Command | Description |
|---------|-------------|
| `ai-plan <task>` | Create an execution plan |
| `ai-exec` | Execute the current plan |
| `ai-verify` | Hostile review of the plan |
| `ai-commit` | Safe commit with preview |
| `ai-finish` | Archive and extract lessons |

### Advanced

| Command | Description |
|---------|-------------|
| `ai-architect <problem>` | Tree of Thoughts design |
| `ai-hotfix <issue>` | Emergency fix mode |
| `ai-ask <question>` | Quick consultation |
| `ai-debug` | Analyze error from clipboard |

### Configuration

| Command | Description |
|---------|-------------|
| `ai-setup` | Interactive first-time setup |
| `ai-config` | View/modify settings |
| `ai-providers` | List available AI providers |

Run `ai-help` for the complete command list.

## Configuration

Route different commands to different providers:

```powershell
# Use Claude for complex planning
ai-config set routing.ai-plan claude

# Use local Ollama for quick tasks (free, fast, private)
ai-config set routing.ai-ask ollama
ai-config set routing.ai-commit ollama
```

Configuration is stored in `~/.trismegistus/config.json`.

## Project Structure

When you run `ai-init` in a project, Trismegistus creates:

```
.claude/
├── CLAUDE.md           # Project rules & conventions
├── active/
│   ├── prd.md          # Project requirements (your "north star")
│   └── plan.md         # Current execution plan
├── memory/
│   └── lessons.md      # Accumulated wisdom from past mistakes
├── reference/          # API docs, architecture decisions
└── commands/           # Custom command templates
```

The `lessons.md` pattern is particularly powerful: every time something goes wrong, you teach the AI not to repeat that mistake.

## Supported Providers

| Provider | CLI | Install |
|----------|-----|---------|
| Claude | `claude` | `npm i -g @anthropic-ai/claude-cli` |
| Gemini | `gemini` | `npm i -g @google/gemini-cli` |
| Ollama | `ollama` | [ollama.ai](https://ollama.ai) |
| OpenAI | `openai` | `npm i -g openai-cli` |

## Philosophy

Trismegistus is built on three principles:

1. **Stateful Memory** — Unlike chatbots that forget, the `.claude/` directory maintains project context indefinitely

2. **Reflexion Loop** — The `ai-verify` command forces the AI to critique its own plan, catching errors before code is written

3. **Multi-Oracle Wisdom** — Different models excel at different tasks. Use the right tool for the job.

## Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

Areas of interest:
- New CLI adapters
- Additional themes
- Command templates for specific frameworks
- Cross-platform improvements

## Origin

Named after [Hermes Trismegistus](https://en.wikipedia.org/wiki/Hermes_Trismegistus) ("Thrice-Great"), the legendary author of the Hermetic Corpus who unified Greek and Egyptian wisdom. This system similarly unifies multiple AI oracles through a single interface.

Evolved from "Claude God Mode", a PowerShell-based agentic system.

## License

[MIT](LICENSE)

---

*"The possession of Knowledge, unless accompanied by Action, is like hoarding gold."*
