# Changelog

All notable changes to Trismegistus will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2025-01-13

### Changed

- **Context Folder**: New projects now use `.tris/` instead of `.claude/`
  - Existing `.claude/` folders auto-detected and used (backwards compatible)
  - Per-project override via `.trisconfig` file
  - More provider-agnostic naming for a multi-oracle tool

### Fixed

- **ai-config**: 3-level nested keys now work (`providers.gemini.enabled`)
- **ai-config**: Boolean values properly converted (`"true"` → `$true`)
- **ai-config**: Parameter naming conflict with "set" keyword resolved
- **ai-finish**: Now cleans up `tmpclaude-*-cwd` temp files from Claude CLI

### Added

- `Get-ContextFolder` function for dynamic context folder detection
- `Get-ContextPath` helper for building context file paths
- `.trisconfig` support for per-project folder override
- Documentation section on context folder configuration

### Documentation

- Updated all docs to reference `.tris/` as default
- Added Context Folder section to CONFIGURATION.md
- Updated README project structure diagram
- Updated WORKFLOWS.md path references

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
