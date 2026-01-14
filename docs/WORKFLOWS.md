# Trismegistus Workflows

> *"The lips of wisdom are closed, except to the ears of Understanding."*

This guide covers the day-to-day usage patterns that make Trismegistus effective.

---

## Table of Contents

1. [The PIV Loop](#the-piv-loop)
2. [Workflow 1: Speed Run](#workflow-1-speed-run-90-of-tasks)
3. [Workflow 2: Deep Architect](#workflow-2-deep-architect)
4. [Workflow 3: Crisis Response](#workflow-3-crisis-response)
5. [Workflow 4: Large Features](#workflow-4-large-features-with-phases)
6. [Workflow 5: Ship with Confidence](#workflow-5-ship-with-confidence)
7. [The Lessons Pattern](#the-lessons-pattern)
8. [Project Initialization](#project-initialization)
9. [Best Practices](#best-practices)
10. [Command Quick Reference](#command-quick-reference)

---

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
       │                                         │
       │            ┌──────────────┐             │
       └────────────│    SHIP      │◀────────────┘
                    │              │
                    │  ai-commit   │
                    │  ai-finish   │
                    └──────────────┘
```

**Why this matters:**
- Planning catches 80% of bugs before code is written
- Progress tracking prevents context window degradation
- Validation catches mistakes before they ship
- Lessons prevent the same mistakes from happening again

---

## Workflow 1: Speed Run (90% of Tasks)

**Use for:** UI tweaks, simple features, documentation, refactoring

This is your daily driver. Three commands, done.

### The Commands

```powershell
# 1. Plan the work
ai-plan "Add a dark mode toggle to the settings page"

# 2. Execute the plan
ai-exec

# 3. Commit the changes
ai-commit
```

### What Happens

1. **ai-plan** reads your project context (PRD, rules, lessons, file structure) and creates a step-by-step plan in `.tris/active/plan.md`

2. **ai-exec** reads the plan and implements it, modifying your actual source files

3. **ai-commit** stages changes, generates a commit message, and pushes

### Pro Tips

- **Combine doc updates with implementation:** 
  ```powershell
  ai-plan "UPDATE PRD & IMPLEMENT: Add dark mode toggle"
  ```
  This updates your PRD and creates the implementation plan in one shot.

- **Review the plan before executing:**
  ```powershell
  ai-plan "Add authentication"
  code .tris/active/plan.md  # Review it
  ai-exec                     # Then execute
  ```

- **For trivial changes, skip planning:**
  ```powershell
  ai-ask "Fix the typo in header.tsx - change 'Welcom' to 'Welcome'"
  ```

---

## Workflow 2: Deep Architect

**Use for:** New systems, database schemas, major refactors, complex integrations

When you don't know *how* to build something, use the full pipeline.

### The Commands

```powershell
# 1. Estimate complexity first
ai-estimate "Build a plugin system for multiple video platforms"

# 2. Research if needed
ai-research "Plugin architecture patterns"

# 3. Architecture design (Tree of Thoughts)
ai-architect "Design a plugin system that supports YouTube, Twitch, and future platforms"

# 4. Review the architecture decision
code .tris/reference/architecture_decision.md

# 5. Create implementation plan based on architecture
ai-plan "Implement plugin system based on architecture_decision.md"

# 6. Critical review of the plan
ai-verify

# 7. Execute
ai-exec

# 8. Validate before committing
ai-diff          # See what changed
ai-review        # Code review the changes
ai-test          # Run tests

# 9. Ship
ai-commit
```

### What Each Step Does

**ai-estimate** analyzes complexity and recommends whether to proceed or split first.

**ai-research** gathers information about unfamiliar tech and saves it to `.tris/reference/` for the AI to use during planning.

**ai-architect** simulates three senior engineers debating:
- Engineer 1: Minimalist approach
- Engineer 2: Scalability-focused approach  
- Engineer 3: Security-focused approach

They debate trade-offs and converge on the best solution, saved to `.tris/reference/architecture_decision.md`.

**ai-verify** acts as a critical code reviewer, looking for logic gaps, race conditions, and hallucinations.

**ai-review** reviews the *actual code changes* (not just the plan) for bugs and issues.

### When to Use This

- Starting a new service or major feature
- Designing database schemas
- Creating integration patterns
- Any task where "how" is unclear

---

## Workflow 3: Crisis Response

**Use for:** Production bugs, compilation errors, urgent fixes

Fast, focused, and leaves behind immunity.

### The Commands

```powershell
# 1. Copy the error to clipboard (Ctrl+C on the stack trace)

# 2. Analyze and create fix plan
ai-debug

# 3. Execute the fix
ai-exec

# 4. Run tests to verify
ai-test

# 5. Review and commit
ai-diff
ai-commit

# 6. CRITICAL: Teach the system to prevent this forever
ai-evolve "When using React Query, always check if data is undefined before accessing properties"
```

### The Key Insight

Step 6 is what separates good teams from great ones. After every bug fix, ask:

> "What rule would have prevented this?"

Then add it with `ai-evolve`. Your system gets smarter with every failure.

### Example Evolution Rules

```powershell
ai-evolve "Always use optional chaining (?.) when accessing nested API response properties"
ai-evolve "Run 'npm test' before every commit in React projects"
ai-evolve "Never use innerHTML - always use textContent to prevent XSS"
ai-evolve "Check for null/undefined before array methods like .map() and .filter()"
```

---

## Workflow 4: Large Features (with Phases)

**Use for:** Multi-day features, epics, anything that might overflow context

Large features need to be split into phases to prevent context window degradation.

### The Commands

```powershell
# 1. Estimate to understand scope
ai-estimate "Build user authentication with OAuth, JWT, and role-based access"

# 2. Plan the full feature
ai-plan "Implement user authentication system"

# 3. If the plan is too large, split it
ai-split -Phases 4

# 4. Execute phase by phase
ai-exec

# 5. Check progress
ai-progress

# 6. When context degrades or you take a break, continue cleanly
ai-continue

# 7. Repeat until all phases complete
ai-progress      # See what's left
ai-continue      # Execute next phase

# 8. Ship when done
ai-ship
```

### Understanding ai-progress

```powershell
ai-progress
```

Shows you:
- Overall completion percentage with progress bar
- Each phase with status (complete ✓, in progress ◐, pending ○)
- Task checkboxes within each phase
- Last checkpoint timestamp

### Understanding ai-continue

```powershell
# Auto-detect and continue next incomplete phase
ai-continue

# Or specify a specific phase
ai-continue -Phase 3
```

This command:
1. Analyzes what's already done
2. Starts a fresh context (avoiding degradation)
3. Focuses only on the next incomplete phase
4. Doesn't re-do completed work

### Why This Matters

After many messages, AI agents get overwhelmed and repeat mistakes. Fresh starts = sharp focus. The `ai-continue` command is designed for this reality.

---

## Workflow 5: Ship with Confidence

**Use for:** When you want a full quality gate before committing

The `ai-ship` command runs the entire validation pipeline.

### The Commands

```powershell
# One command does it all
ai-ship

# Or skip tests if you're confident
ai-ship -SkipTests

# Or skip all prompts
ai-ship -Force
```

### What ai-ship Does

```
╔═══════════════════════════════════════════════════════════════╗
║  SHIPPING PIPELINE                                            ║
╠═══════════════════════════════════════════════════════════════╣
║  Phase 1: ai-diff     → Show what changed                     ║
║  Phase 2: ai-review   → Critical code review                  ║
║  Phase 3: ai-test     → Run tests, analyze failures           ║
║  Phase 4: ai-commit   → Commit if all pass                    ║
╚═══════════════════════════════════════════════════════════════╝
```

Each phase is a gate. If something fails, the pipeline stops and you can fix it.

### Manual Pipeline (Same Steps)

If you prefer manual control:

```powershell
ai-diff              # What changed?
ai-review            # Any issues?
ai-test              # Tests pass?
ai-commit            # Ship it
```

---

## The Lessons Pattern

The `lessons.md` file is Trismegistus's long-term memory. It's injected into every prompt.

### How It Works

```
.tris/memory/lessons.md
```

Every rule here is seen by the AI on every command. It literally cannot forget these lessons.

### Building Good Lessons

**Bad lesson (too vague):**
```
- Be careful with async code
```

**Good lesson (specific and actionable):**
```
- [2025-01-12] When fetching data in useEffect, always include cleanup: 
  `const controller = new AbortController()` and return `() => controller.abort()`
```

### Automated Lesson Extraction

After completing a feature:

```powershell
ai-finish
```

This:
1. Archives the plan to `completed_log.md`
2. Runs a post-mortem analysis
3. Extracts lessons automatically
4. Clears the active plan

### Manual Lesson Addition

For immediate insights:

```powershell
ai-evolve "Twitch API changed their DOM selectors in Dec 2024 - use data-test-selector instead of class names"
```

### Lesson Maintenance

Over time, lessons accumulate. Run periodically:

```powershell
ai-compress
```

This consolidates duplicates and removes outdated rules.

---

## Project Initialization

### New Project (Greenfield)

```powershell
mkdir my-new-project
cd my-new-project
git init

# Bootstrap the AI brain
ai-init

# Define your stack in the rules file
code .tris/CLAUDE.md

# Launch with a description - AI researches and creates initial plan
ai-launch "A Chrome extension that replaces all images with cats"
```

### Existing Project (Brownfield)

```powershell
cd my-existing-project

# Inject the AI system (won't overwrite existing code)
ai-init

# CRITICAL: Teach it about your codebase
# Update .tris/CLAUDE.md with your actual stack

# Run a discovery audit
ai-plan "AUDIT: Analyze the existing file structure. Create a high-level map. Update prd.md with current state."
ai-exec
```

### The .tris/ Structure

```
.tris/                     # (or .claude/ for legacy projects)
├── CLAUDE.md              # Rules: tech stack, style guide, forbidden patterns
├── active/
│   ├── prd.md             # Your "north star" - what you're building
│   ├── plan.md            # Current mission (cleared after ai-finish)
│   └── progress.txt       # Execution checkpoint tracking
├── memory/
│   ├── lessons.md         # Accumulated wisdom
│   └── completed_log.md   # Archive of finished missions
├── reference/             # API docs, architecture decisions, research
└── commands/              # Custom command templates
```

> **Note:** Trismegistus automatically detects existing `.claude/` folders for backwards compatibility with Claude Code projects.

---

## Best Practices

### 1. Estimate Before Planning

For anything non-trivial:

```powershell
ai-estimate "Build the user dashboard"
# If it says "EPIC" or "SPLIT FIRST", break it down
```

### 2. Trust the Verify Loop

On complex tasks, always run `ai-verify`:

```powershell
ai-plan "Refactor the database layer to support PostgreSQL"
ai-verify  # Let it attack its own plan
ai-exec
```

It costs seconds but saves hours of debugging.

### 3. Use Progress Tracking for Large Tasks

```powershell
ai-plan "Build authentication system"
ai-split           # Break into phases
ai-exec            # Start phase 1
ai-progress        # Check status
ai-continue        # Continue to phase 2
```

### 4. Validate Before Shipping

```powershell
# After execution, before committing:
ai-diff            # What actually changed?
ai-test            # Do tests pass?
ai-review          # Any code issues?
ai-commit          # Now ship it
```

Or use the all-in-one: `ai-ship`

### 5. Debug Context Issues

When the AI seems confused about your project:

```powershell
ai-context         # See what the AI actually sees
ai-context -Full   # See complete content (not truncated)
```

### 6. Feed the Brain

When you learn something, teach the system:

```powershell
ai-evolve "Twitch EventSub requires webhook verification since API v2"
ai-evolve "Use Zod for runtime type validation at API boundaries"
```

### 7. Clean the Board

Always run `ai-finish` when a feature is complete. A cluttered `plan.md` leads to a confused AI.

### 8. Use the Right Model for the Job

Configure routing for efficiency:

```powershell
# Complex reasoning → best model
ai-config set routing.ai-plan claude
ai-config set routing.ai-architect claude

# Quick tasks → fast/cheap model
ai-config set routing.ai-ask ollama
ai-config set routing.ai-commit ollama
```

---

## Command Quick Reference

### Phase 1: Plan

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `ai-init` | Bootstrap project | New/existing projects |
| `ai-estimate <task>` | Complexity analysis | Before large tasks |
| `ai-research <topic>` | Deep research | Unfamiliar tech |
| `ai-architect <problem>` | Tree of Thoughts | When "how" is unclear |
| `ai-plan <task>` | Create execution plan | Starting any task |
| `ai-verify` | Critical review | Before complex executions |
| `ai-split` | Break into phases | When plan is too large |

### Phase 2: Execute

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `ai-exec` | Execute the plan | After planning/verification |
| `ai-progress` | View phase status | During large features |
| `ai-continue` | Resume execution | After breaks, context loss |
| `ai-debug` | Analyze error | Bug fixing |
| `ai-ask <question>` | Quick consultation | Simple questions |

### Phase 3: Validate

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `ai-diff` | Show changes | Before committing |
| `ai-test` | Run & analyze tests | After implementation |
| `ai-review` | Code review changes | Before committing |
| `ai-explain <file>` | Explain code | Understanding code |
| `ai-context` | Debug AI context | Troubleshooting |

### Phase 4: Ship

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `ai-commit` | Safe git commit | After validation |
| `ai-docs` | Generate docs | After features |
| `ai-changelog` | Generate changelog | Before releases |
| `ai-finish` | Archive & learn | When feature done |
| `ai-ship` | Full pipeline | Confident shipping |

### Utilities

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `ai-status` | View current state | Checking context |
| `ai-evolve <lesson>` | Add to memory | After learning |
| `ai-compress` | Consolidate lessons | Maintenance |
| `ai-wipe` | Clear plan | Starting over |
| `ai-rollback` | Restore checkpoint | Undo execution |
| `ai-hotfix <issue>` | Emergency fix | Urgent bugs |
| `ai-help` | Command reference | When lost |

---

## Troubleshooting

### "The AI keeps making the same mistake"

Add it to lessons:
```powershell
ai-evolve "NEVER do X, always do Y because Z"
```

### "The plan looks wrong"

Clear and retry:
```powershell
ai-wipe
ai-plan "More specific description of what I want"
```

### "Context seems stale"

Check what the AI sees:
```powershell
ai-context
```

### "The plan is too big"

Split it:
```powershell
ai-split -Phases 3
```

### "Lost track of progress"

Check status:
```powershell
ai-progress
ai-continue  # Resume where you left off
```

### "Tests are failing"

Let AI analyze:
```powershell
ai-test         # Analyze failures
ai-test -Fix    # Attempt to fix automatically
```

### "What did the AI actually change?"

```powershell
ai-diff              # Summary
ai-diff -Detailed    # Full diff
```

---

*"The All is Mind; the Universe is Mental."* — The Kybalion
