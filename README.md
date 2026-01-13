# Trismegistus

```
  ___________      .__                                .__          __                
  \__    ___/______|__| ______ _____   ____   _____ |__|  ______/  |_ __ __  ______
    |    |  \_  __ \  |/  ___//     \_/ __ \ / ___\ |  | /  ___/\   __\  |  \/  ___/
    |    |   |  | \/  |\___ \|  Y Y  \  ___// /_/  >|  | \___ \  |  | |  |  /\___ \ 
    |____|   |__|  |__/____  >__|_|  /\___  >___  / |__|/____  > |__| |____//____  >
                           \/      \/     \/_____/           \/                  \/ 
```

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
| **Progress Tracking** | Track phases, checkpoint progress, resume cleanly |
| **Reflexion Loop** | AI critiques its own plans before execution |
| **Full Validation Pipeline** | Diff, test, review, ship with quality gates |
| **Safety Rails** | Commit preview, branch protection, rollback |
| **Hermetic Visual Theme** | Animated spinners, progress bars, celebrations |
| **Cross-Platform** | Windows, macOS, Linux via PowerShell 7 |

## Quick Demo

```powershell
# Initialize a project
ai-init

# Estimate complexity
ai-estimate "Add JWT authentication to the API"

# Plan a feature (uses your configured "planning" model)
ai-plan "Add JWT authentication to the API"

# Have the AI critique its own plan
ai-verify

# Execute the plan
ai-exec

# Check progress on large features
ai-progress

# Validate before shipping
ai-diff          # See what changed
ai-test          # Run tests
ai-review        # Code review

# Ship it (uses your "quick tasks" model)
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

## Commands (35 Total)

### Phase 1: Plan

| Command | Description |
|---------|-------------|
| `ai-init` | Bootstrap project with AI context |
| `ai-estimate <task>` | Analyze complexity before planning |
| `ai-research <topic>` | Deep research, save to reference/ |
| `ai-architect <problem>` | Tree of Thoughts design |
| `ai-plan <task>` | Create an execution plan |
| `ai-verify` | Hostile review of the plan |
| `ai-split` | Break large plan into phases |

### Phase 2: Execute

| Command | Description |
|---------|-------------|
| `ai-exec` | Execute the current plan |
| `ai-progress` | View phase completion status |
| `ai-continue` | Resume execution from checkpoint |
| `ai-debug` | Analyze error from clipboard |
| `ai-ask <question>` | Quick consultation |

### Phase 3: Validate

| Command | Description |
|---------|-------------|
| `ai-diff` | Show changes summary |
| `ai-test` | Run tests, analyze failures |
| `ai-review` | Hostile code review |
| `ai-explain <file>` | Explain code in detail |
| `ai-context` | Debug what AI sees |

### Phase 4: Ship

| Command | Description |
|---------|-------------|
| `ai-commit` | Safe commit with preview |
| `ai-docs <type>` | Generate documentation |
| `ai-changelog` | Generate changelog |
| `ai-finish` | Archive and extract lessons |
| `ai-ship` | Full quality gate pipeline |

### Utilities

| Command | Description |
|---------|-------------|
| `ai-status` | View current plan state |
| `ai-evolve <lesson>` | Add rule to memory |
| `ai-compress` | Consolidate lessons |
| `ai-wipe` | Clear current plan |
| `ai-rollback` | Restore from checkpoint |
| `ai-hotfix <issue>` | Emergency fix mode |

### Configuration

| Command | Description |
|---------|-------------|
| `ai-setup` | Interactive first-time setup |
| `ai-config` | View/modify settings |
| `ai-providers` | List available AI providers |
| `ai-help` | Full command reference |

### Pipelines

| Command | Description |
|---------|-------------|
| `ai-flow-feature <task>` | Full feature pipeline |
| `ai-flow-bugfix` | Full bugfix pipeline |

Run `ai-help` for the complete command list organized by workflow phase.

## Configuration

Route different commands to different providers:

```powershell
# Use Claude for complex planning
ai-config set routing.ai-plan claude
ai-config set routing.ai-review claude

# Use local Ollama for quick tasks (free, fast, private)
ai-config set routing.ai-ask ollama
ai-config set routing.ai-commit ollama
ai-config set routing.ai-diff ollama
```

Configuration is stored in `~/.trismegistus/config.json`.

## Project Structure

When you run `ai-init` in a project, Trismegistus creates:

```
.tris/                  # (or .claude/ for legacy projects)
├── CLAUDE.md           # Project rules & conventions
├── active/
│   ├── prd.md          # Project requirements (your "north star")
│   ├── plan.md         # Current execution plan
│   └── progress.txt    # Checkpoint tracking
├── memory/
│   └── lessons.md      # Accumulated wisdom from past mistakes
├── reference/          # API docs, architecture decisions, research
└── commands/           # Custom command templates
```

The `lessons.md` pattern is particularly powerful: every time something goes wrong, you teach the AI not to repeat that mistake.

**Backwards Compatibility:** Trismegistus automatically detects and uses existing `.claude/` folders, so projects built with Claude Code continue working seamlessly.

## Supported Providers

| Provider | CLI | Install |
|----------|-----|---------|
| Claude | `claude` | `npm i -g @anthropic-ai/claude-cli` |
| Gemini | `gemini` | `npm i -g @google/gemini-cli` |
| Ollama | `ollama` | [ollama.ai](https://ollama.ai) |
| OpenAI | `openai` | `npm i -g openai-cli` |

## Philosophy

Trismegistus is built on three principles:

1. **Stateful Memory** — Unlike chatbots that forget, the `.tris/` directory maintains project context indefinitely

2. **Reflexion Loop** — The `ai-verify` command forces the AI to critique its own plan, catching errors before code is written

3. **Multi-Oracle Wisdom** — Different models excel at different tasks. Use the right tool for the job.

## The PIV Loop

Every task follows the **Plan → Implement → Verify** loop:

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│    PLAN      │────▶│   EXECUTE    │────▶│   VALIDATE   │
│              │     │              │     │              │
│ ai-estimate  │     │   ai-exec    │     │   ai-diff    │
│ ai-plan      │     │ ai-progress  │     │   ai-test    │
│ ai-verify    │     │ ai-continue  │     │  ai-review   │
└──────────────┘     └──────────────┘     └──────────────┘
                             │
                     ┌───────▼───────┐
                     │     SHIP      │
                     │   ai-commit   │
                     │   ai-finish   │
                     └───────────────┘
```

## Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

Areas of interest:
- New CLI adapters
- Additional themes
- Command templates for specific frameworks
- Cross-platform improvements

## Documentation

- **[Workflows Guide](docs/WORKFLOWS.md)** — Day-to-day usage patterns, the PIV loop, best practices
- **[Configuration Guide](docs/CONFIGURATION.md)** — All config options, routing, provider setup
- **[Templates Guide](docs/TEMPLATES.md)** — Customizing and creating command templates
- **[Troubleshooting](docs/TROUBLESHOOTING.md)** — Common issues and solutions

## Inspiration

This project was inspired by [Cole Medin](https://www.youtube.com/@ColeMedin)'s excellent video on agentic coding workflows:

📺 **[Watch the video that started it all](https://youtu.be/ttdWPDmBN_4)**

Cole's concepts around PRD-first development, the Plan-Implement-Verify loop, modular rules architecture, and the "lessons learned" pattern form the philosophical foundation of this system. Trismegistus takes those ideas and wraps them in a multi-provider orchestration layer.

If you find this tool useful, go subscribe to Cole's channel — he's doing fantastic work in the AI engineering space.

## Origin

Named after [Hermes Trismegistus](https://en.wikipedia.org/wiki/Hermes_Trismegistus) ("Thrice-Great"), the legendary author of the Hermetic Corpus who unified Greek and Egyptian wisdom. This system similarly unifies multiple AI oracles through a single interface.

Evolved from "Claude God Mode", a PowerShell-based agentic system.

## License

[MIT](LICENSE)

---

*"The possession of Knowledge, unless accompanied by Action, is like hoarding gold."*
