# Changelog

All notable changes to Trismegistus will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2025-01-13

### Added - New Commands (13 total)

**Progress & Continuation:**
- `ai-progress` - Visual phase/task completion status with progress bars
- `ai-continue` - Resume execution from last checkpoint or specific phase

**Validation & Review:**
- `ai-diff` - Human-readable summary of changes since last commit
- `ai-test` - Run tests, analyze failures, suggest fixes (auto-detects framework)
- `ai-review` - Hostile code review of actual changes (not just the plan)
- `ai-context` - Debug view of what gets injected into prompts
- `ai-explain <file>` - Explain what a file or function does

**Documentation & Research:**
- `ai-docs` - Generate/update documentation (readme, api, comments)
- `ai-research <topic>` - Deep research saved to reference folder

**Estimation & Planning:**
- `ai-estimate <task>` - Estimate complexity with recommendations
- `ai-split` - Break oversized plan into manageable phases

**Shipping:**
- `ai-changelog` - Generate changelog from git history
- `ai-ship` - Full quality gate pipeline: diff → review → test → commit

### Added - Visual Enhancements

- New ASCII animations for operations:
  - Oracle consulting animation
  - Alchemy transmutation progress bar
  - Phase completion celebration
  - Success/warning animations
- Enhanced `Write-TrisProgressBar` with color-coded progress
- `Show-TrisDiff` visual diff stats display
- Multiple new message types (PROGRESS, CONTINUE, TEST, REVIEW, etc.)

### Changed

- **ai-help**: Reorganized by workflow phase (Plan → Execute → Validate → Ship)
- **Command count**: Now 35 commands (was 22)
- **Context Folder**: New projects now use `.tris/` instead of `.claude/`
  - Existing `.claude/` folders auto-detected and used (backwards compatible)
  - Per-project override via `.trisconfig` file

### Fixed

- **ai-config**: 3-level nested keys now work (`providers.gemini.enabled`)
- **ai-config**: Boolean values properly converted (`"true"` → `$true`)
- **ai-config**: Parameter naming conflict with "set" keyword resolved
- **ai-finish**: Now cleans up `tmpclaude-*-cwd` temp files from Claude CLI

### Documentation

- **WORKFLOWS.md**: Complete rewrite with 5 workflow patterns
  - Added Workflow 4: Large Features (with phases)
  - Added Workflow 5: Ship with Confidence
  - Updated PIV loop diagram with new commands
  - Comprehensive command quick reference tables
- **CONFIGURATION.md**: Complete routing reference for all 35 commands
  - Added routing examples for all new commands
  - Cost-optimized and privacy-first setup guides
  - Complete config.json structure reference
- **TROUBLESHOOTING.md**: New sections for new commands
  - Progress & Continuation issues
  - Validation issues
  - Performance-based routing recommendations
- **TEMPLATES.md**: Updated command template reference
  - Listed all command templates by category
  - Added examples for new validation/shipping commands
- **README.md**: Updated with all 35 commands
  - Commands organized by workflow phase
  - Updated PIV loop diagram
  - New quick demo showing validation commands
- Comprehensive ai-help with workflow-based organization
- Updated all docs to reference `.tris/` as default
- Added Context Folder section to CONFIGURATION.md

---

## [1.0.0] - 2025-01-12

### Added

- **Multi-Oracle Router**: Support for Claude, Gemini, Ollama, and OpenAI CLIs
- **Configuration System**: JSON-based config with `ai-setup` wizard and `ai-config` commands
- **Core Commands**:
  - `ai-init` - Initialize project structure
  - `ai-plan` - Create execution plans with context injection
  - `ai-exec` - Execute plans with checkpointing
  - `ai-verify` - Hostile code review / reflexion loop
  - `ai-commit` - Safe commits with preview and branch protection
  - `ai-finish` - Archive completed work and extract lessons
- **Advanced Commands**:
  - `ai-architect` - Tree of Thoughts design sessions
  - `ai-hotfix` - Emergency fixes with minimal planning
  - `ai-rollback` - Restore to last checkpoint
- **Utility Commands**:
  - `ai-ask` - Quick consultations
  - `ai-debug` - Error analysis from clipboard
  - `ai-evolve` - Manual lesson recording
  - `ai-status` - Project dashboard
  - `ai-compress` - Consolidate lessons.md
- **Pipeline Commands**:
  - `ai-flow-feature` - Full feature workflow
  - `ai-flow-bugfix` - Full bugfix workflow
- **Themes**: Hermetic (alchemical) theme with symbolic messaging
- **Cross-Platform**: Windows (native) and Mac/Linux (via PowerShell 7) installers
- **Smart Reference Loading**: Only loads relevant documentation based on task keywords
- **Safety Features**: Commit preview, branch protection, checkpoints, dry-run mode

### Architecture

- Adapter pattern for CLI providers
- Modular theme system
- Persistent project memory via `.tris/` directory (or `.claude/` for legacy)
- Template-based prompt engineering

---

## Origin

Trismegistus evolved from "Claude God Mode", a PowerShell-based agentic system. The name honors Hermes Trismegistus, legendary author of the Hermetic Corpus, symbolizing the union of multiple sources of wisdom (AI oracles) through a single interface.

*"As above, so below; as within, so without."*
