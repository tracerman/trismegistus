# Troubleshooting Guide

> *"Every Cause has its Effect; every Effect has its Cause."*

Solutions to common issues with Trismegistus.

---

## Installation Issues

### "File cannot be loaded - not digitally signed"

**Windows blocks downloaded PowerShell scripts.**

```powershell
# Unblock all Trismegistus files
Get-ChildItem "$HOME\.trismegistus" -Recurse -Filter "*.ps1" | Unblock-File

# Reload
. $PROFILE
```

### "The term 'ai-plan' is not recognized"

**Profile not loaded.**

```powershell
# Check if sourcing line exists
Get-Content $PROFILE | Select-String "trismegistus"

# If missing, add it:
Add-Content $PROFILE '. "$HOME\.trismegistus\core\profile.ps1"  # Trismegistus'

# Reload
. $PROFILE
```

### "Export-ModuleMember can only be called from inside a module"

**Old version of files.** Re-run installer:

```powershell
cd path\to\trismegistus
.\install.ps1
. $PROFILE
```

### Profile created in wrong location

**PowerShell 5 vs 7 use different profile paths.**

- PowerShell 5: `Documents\WindowsPowerShell\profile.ps1`
- PowerShell 7: `Documents\PowerShell\Microsoft.PowerShell_profile.ps1`

Run the installer from the shell you primarily use:

```powershell
# From PowerShell 7 (pwsh)
pwsh
.\install.ps1

# OR from Windows PowerShell
powershell
.\install.ps1
```

---

## Runtime Issues

### "No AI oracles detected"

**No CLI tools installed.** Install at least one:

```powershell
# Claude
npm install -g @anthropic-ai/claude-cli
claude login

# Gemini
npm install -g @google/gemini-cli
gemini auth

# Ollama (local, free)
# Download from https://ollama.ai
ollama pull llama4

# OpenAI
npm install -g openai-cli
openai api auth
```

### AI keeps making the same mistake

**Add it to lessons:**

```powershell
ai-evolve "NEVER do X, always do Y because Z"
```

The rule will be injected into every future prompt.

### Plan looks wrong or outdated

**Stale context.** Clear and re-plan:

```powershell
ai-wipe                    # Clear current plan
ai-sync                    # Re-sync project context
ai-plan "Better description"
```

### "Prompt is too long" / Slow performance

**Too many files in context.**

1. Check your `.gitignore` excludes large folders:
   ```
   node_modules/
   dist/
   build/
   .git/
   *.log
   ```

2. Reduce context limit:
   ```powershell
   code ~/.trismegistus/config.json
   # Change "maxContextFiles": 1000
   ```

3. Run the ignore updater:
   ```powershell
   ai-ignore
   ```

### Config shows old models

**Config file caches your selections.** Reset and re-run setup:

```powershell
Remove-Item ~/.trismegistus/config.json
. $PROFILE
ai-setup
```

---

## Git Issues

### Commit message not auto-generated

**The AI forgot to write the commit file.** This triggers the manual fallback.

Next time, add a reminder to your plan:
```powershell
ai-plan "Fix the bug. REMINDER: Write commit_msg.txt when done."
```

Or just type the message manually when prompted.

### "Cannot push to protected branch"

**This is intentional.** Create a feature branch:

```powershell
git checkout -b feature/my-feature
ai-exec
ai-commit
```

Then merge via PR.

### Push rejected - remote has changes

**Someone else pushed, or you initialized with a README.**

```powershell
git pull --rebase origin main
git push
```

Or force push if it's your repo and you know it's safe:
```powershell
git push --force
```

---

## Provider-Specific Issues

### Claude: "Rate limited"

**Too many requests.** Wait a minute and retry, or switch to local:

```powershell
ai-config set routing.ai-ask ollama
```

### Ollama: "Connection refused"

**Ollama server not running.**

```powershell
# Start Ollama
ollama serve

# In another terminal, verify it's running
ollama list
```

### Ollama: "Model not found"

**Model not installed locally.**

```powershell
# Pull the model first
ollama pull llama4

# Or use a different model
ai-config set providers.ollama.model mistral
```

### Gemini: "Authentication failed"

**Token expired.** Re-authenticate:

```powershell
gemini auth
```

---

## Context Issues

### AI doesn't know about my existing code

**Run a discovery audit:**

```powershell
ai-plan "AUDIT: Analyze the existing file structure. Create a map in prd.md."
ai-exec
```

### AI hallucinates files that don't exist

**Add to lessons:**

```powershell
ai-evolve "Always run 'ls' or check file existence before importing or modifying files"
```

Also run `ai-verify` before `ai-exec` on complex tasks.

### AI ignores my project rules

**Check CLAUDE.md is properly formatted:**

```powershell
code .claude/CLAUDE.md
```

Make rules explicit and specific:
```markdown
## Forbidden
- NEVER use var, always use const or let
- NEVER commit console.log statements
```

---

## Performance Tips

### Speed up execution

1. **Use local models for quick tasks:**
   ```powershell
   ai-config set routing.ai-ask ollama
   ai-config set routing.ai-commit ollama
   ```

2. **Reduce context size:**
   ```powershell
   # Edit config.json, reduce maxContextFiles
   ```

3. **Keep lessons.md clean:**
   ```powershell
   ai-compress
   ```

### Reduce costs

1. **Route cheap tasks to Ollama (free):**
   ```powershell
   ai-config set routing.ai-ask ollama
   ai-config set routing.ai-commit ollama
   ai-config set routing.ai-debug ollama
   ```

2. **Only use premium models for planning:**
   ```powershell
   ai-config set routing.ai-plan claude
   ai-config set routing.ai-architect claude
   ```

---

## Reset Everything

Nuclear option - complete reset:

```powershell
# Remove installation
Remove-Item -Recurse -Force "$HOME\.trismegistus"

# Remove profile line (edit manually)
code $PROFILE
# Delete the Trismegistus line

# Reinstall fresh
cd path\to\trismegistus
.\install.ps1
. $PROFILE
ai-setup
```

---

## Getting Help

### Check current state

```powershell
ai-status     # View current plan/context
ai-config     # View configuration
ai-providers  # View available providers
ai-help       # Full command list
```

### Debug a command

Add `-Verbose` to see what's happening:

```powershell
ai-plan "Test" -Verbose
```

### Report issues

[Open an issue on GitHub](https://github.com/tracerman/trismegistus/issues) with:
1. PowerShell version (`$PSVersionTable`)
2. OS version
3. Error message
4. Steps to reproduce

---

*"Rhythm compensates."* — The Kybalion
