# Trismegistus Workflows

> *"The lips of wisdom are closed, except to the ears of Understanding."*

This guide covers the day-to-day usage patterns that make Trismegistus effective.

---

## Table of Contents

1. [The PIV Loop](#the-piv-loop)
2. [Workflow 1: Speed Run](#workflow-1-speed-run-90-of-tasks)
3. [Workflow 2: Deep Architect](#workflow-2-deep-architect)
4. [Workflow 3: Crisis Response](#workflow-3-crisis-response)
5. [The Lessons Pattern](#the-lessons-pattern)
6. [Project Initialization](#project-initialization)
7. [Best Practices](#best-practices)

---

## The PIV Loop

Every task follows the **Plan → Implement → Verify** loop:

```
┌─────────┐     ┌─────────────┐     ┌──────────┐
│  PLAN   │────▶│  IMPLEMENT  │────▶│  VERIFY  │
│         │     │             │     │          │
│ ai-plan │     │   ai-exec   │     │ ai-verify│
└─────────┘     └─────────────┘     └──────────┘
      │                                   │
      │         ┌─────────┐               │
      └─────────│ LESSONS │◀──────────────┘
                └─────────┘
```

**Why this matters:**
- Planning catches 80% of bugs before code is written
- Verification catches mistakes the AI made during implementation
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

1. **ai-plan** reads your project context (PRD, rules, lessons, file structure) and creates a step-by-step plan in `.claude/active/plan.md`

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
  code .claude/active/plan.md  # Review it
  ai-exec                       # Then execute
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
# 1. Architecture design (Tree of Thoughts)
ai-architect "Design a plugin system that supports YouTube, Twitch, and future platforms"

# 2. Review the architecture decision
code .claude/reference/architecture_decision.md

# 3. Create implementation plan based on architecture
ai-plan "Implement plugin system based on architecture_decision.md"

# 4. Hostile review of the plan
ai-verify

# 5. Execute
ai-exec

# 6. Commit
ai-commit
```

### What Each Step Does

**ai-architect** simulates three senior engineers debating:
- Engineer 1: Minimalist approach
- Engineer 2: Scalability-focused approach  
- Engineer 3: Security-focused approach

They debate trade-offs and converge on the best solution, saved to `.claude/reference/architecture_decision.md`.

**ai-verify** acts as a hostile code reviewer:
- Looks for logic gaps
- Identifies race conditions
- Catches hallucinated imports/files
- Rewrites the plan if flaws are found

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

# 4. Commit
ai-commit

# 5. CRITICAL: Teach the system to prevent this forever
ai-evolve "When using React Query, always check if data is undefined before accessing properties"
```

### The Key Insight

Step 5 is what separates good teams from great ones. After every bug fix, ask:

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

## The Lessons Pattern

The `lessons.md` file is Trismegistus's long-term memory. It's injected into every prompt.

### How It Works

```
.claude/memory/lessons.md
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
code .claude/CLAUDE.md

# Launch with a description - AI researches and creates initial plan
ai-launch "A Chrome extension that replaces all images with cats"
```

### Existing Project (Brownfield)

```powershell
cd my-existing-project

# Inject the AI system (won't overwrite existing code)
ai-init

# CRITICAL: Teach it about your codebase
# Update .claude/CLAUDE.md with your actual stack

# Run a discovery audit
ai-plan "AUDIT: Analyze the existing file structure. Create a high-level map. Update prd.md with current state."
ai-exec
```

### The .claude/ Structure

```
.claude/
├── CLAUDE.md              # Rules: tech stack, style guide, forbidden patterns
├── active/
│   ├── prd.md             # Your "north star" - what you're building
│   └── plan.md            # Current mission (cleared after ai-finish)
├── memory/
│   ├── lessons.md         # Accumulated wisdom
│   └── completed_log.md   # Archive of finished missions
├── reference/             # API docs, architecture decisions
└── commands/              # Custom command templates
```

---

## Best Practices

### 1. One Prompt to Rule Them All

Don't split "update docs" and "write code" into two commands:

```powershell
# Bad - two separate operations
ai-plan "Update the PRD with auth requirements"
ai-exec
ai-plan "Implement authentication"
ai-exec

# Good - combined
ai-plan "UPDATE PRD & IMPLEMENT: Add JWT authentication to the API"
ai-exec
```

### 2. Trust the Verify Loop

On complex tasks, always run `ai-verify`:

```powershell
ai-plan "Refactor the database layer to support PostgreSQL"
ai-verify  # Let it attack its own plan
ai-exec
```

It costs seconds but saves hours of debugging.

### 3. Feed the Brain

When you learn something, teach the system:

```powershell
# You discovered Twitch changed their API
ai-evolve "Twitch EventSub requires webhook verification since API v2"

# You found a better pattern
ai-evolve "Use Zod for runtime type validation at API boundaries"
```

### 4. Clean the Board

Always run `ai-finish` when a feature is complete:

```powershell
ai-finish
```

A cluttered `plan.md` leads to a confused AI. Clean state = clear thinking.

### 5. Use the Right Model for the Job

Configure routing for efficiency:

```powershell
# Complex reasoning → best model
ai-config set routing.ai-plan claude
ai-config set routing.ai-architect claude

# Quick tasks → fast/cheap model
ai-config set routing.ai-ask ollama
ai-config set routing.ai-commit ollama
```

### 6. Protect Your Branches

Trismegistus won't let you commit directly to protected branches:

```powershell
# View protected branches
ai-config

# These are protected by default: main, master, production, prod
```

---

## Command Quick Reference

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `ai-plan <task>` | Create execution plan | Starting any task |
| `ai-exec` | Execute the plan | After planning/verification |
| `ai-verify` | Hostile review | Before complex executions |
| `ai-commit` | Safe git commit | After implementation |
| `ai-finish` | Archive & extract lessons | When feature is done |
| `ai-architect <problem>` | Tree of Thoughts design | When "how" is unclear |
| `ai-ask <question>` | Quick consultation | Simple questions |
| `ai-debug` | Analyze clipboard error | Bug fixing |
| `ai-evolve <lesson>` | Add rule to memory | After learning something |
| `ai-init` | Bootstrap project | New/existing projects |
| `ai-status` | View current state | Checking context |
| `ai-help` | Full command list | When lost |

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

Force re-sync:
```powershell
ai-sync
```

### "Too many files in context"

Check your `.gitignore` and the context limit:
```powershell
ai-config  # See maxContextFiles setting
```

---

*"The All is Mind; the Universe is Mental."* — The Kybalion
