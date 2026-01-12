# Contributing to Trismegistus

Thank you for your interest in contributing to Trismegistus! This document provides guidelines for contributions.

## Ways to Contribute

### 1. New CLI Adapters

We welcome adapters for additional AI CLIs. To add a new adapter:

1. Create a new file in `core/adapters/` named `<provider>.ps1`
2. Implement these functions:
   - `Test-<Provider>Available` - Check if CLI is installed
   - `Get-<Provider>Version` - Return version string
   - `Invoke-<Provider>Oracle` - Main invocation function
   - `Get-<Provider>Config` - Return provider metadata

3. Follow the existing adapter patterns (see `claude.ps1` as reference)
4. Update `README.md` with the new provider

### 2. Command Templates

Better templates improve everyone's workflow:

- Templates live in `templates/commands/`
- Follow the existing structure with frontmatter
- Test with multiple providers if possible
- Document any provider-specific behaviors

### 3. Themes

Add new visual themes in `themes/`:

- Copy `hermetic.ps1` as a starting point
- Customize colors, symbols, and messages
- Test on both Windows Terminal and standard consoles
- Avoid emoji that render poorly on Windows

### 4. Bug Fixes & Improvements

- Check existing issues first
- For major changes, open an issue to discuss before implementing
- Include tests or test instructions where applicable

## Development Setup

```powershell
# Clone the repo
git clone https://github.com/YOUR_USERNAME/trismegistus.git
cd trismegistus

# For development, source directly instead of installing
$env:TRIS_ROOT = (Get-Location).Path
$env:TRIS_TEMPLATES = Join-Path $env:TRIS_ROOT "templates"
. .\core\profile.ps1

# Make changes and test
ai-help
```

## Code Style

### PowerShell

- Use PascalCase for function names: `Invoke-Oracle`, `Get-TrisConfig`
- Use `$script:` scope for module-level variables
- Include comment-based help for public functions
- Keep lines under 120 characters

### Markdown

- Use ATX-style headers (`#`, `##`, etc.)
- Include code blocks with language hints
- Keep lines under 100 characters for readability

## Pull Request Process

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-new-feature`
3. Make your changes
4. Test on your target platform(s)
5. Commit with conventional commit messages:
   - `feat: add mistral adapter`
   - `fix: handle missing config file`
   - `docs: improve installation instructions`
6. Push and create a Pull Request

## Testing

Currently, testing is manual. When submitting a PR, please include:

- What you tested
- On which platform(s)
- Any edge cases you verified

## Questions?

Open an issue with the `question` label for any clarifications.

---

*"The possession of Knowledge, unless accompanied by Action, is like hoarding gold."*
