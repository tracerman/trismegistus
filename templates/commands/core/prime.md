---
description: Prime agent with comprehensive codebase understanding
---

# Prime: Load Project Context

## Objective

Build comprehensive understanding of the codebase by analyzing structure, documentation, accumulated knowledge, and key files.

---

## Process

### 1. Analyze Project Structure

**List tracked files:**
```bash
git ls-files
```

**Show directory structure:**
```bash
# Linux/Mac
tree -L 3 -I 'node_modules|__pycache__|.git|dist|build|.venv|venv'

# Windows PowerShell
Get-ChildItem -Recurse -Depth 3 -Name | Where-Object { $_ -notmatch 'node_modules|__pycache__|\.git|dist|build|\.venv' }
```

### 2. Read Core Documentation (In Order)

**Project Constitution (CRITICAL):**
```
.tris/CLAUDE.md
```
This contains all project rules, conventions, and constraints.

**Accumulated Wisdom:**
```
.tris/memory/lessons.md
```
This contains lessons learned from past mistakes. **Do not repeat these errors.**

**Project Overview:**
```
README.md
```

**Recent Mission Log (last 20 entries):**
```
.tris/memory/completed_log.md
```

### 3. Identify Tech Stack

From configuration files, identify:

**Package Managers & Dependencies:**
- `package.json` / `package-lock.json` (Node.js)
- `pyproject.toml` / `requirements.txt` (Python)
- `go.mod` (Go)
- `Cargo.toml` (Rust)

**Build Configuration:**
- `vite.config.js` / `webpack.config.js` (Frontend)
- `tsconfig.json` (TypeScript)
- `setup.py` / `setup.cfg` (Python)

**Code Quality:**
- `ruff.toml` / `.ruff.toml` (Python linting)
- `.eslintrc` / `eslint.config.js` (JS linting)
- `.prettierrc` (Formatting)
- `mypy.ini` / `pyrightconfig.json` (Type checking)

### 4. Read Key Files

Based on the project type, read:

**Entry Points:**
- `main.py` / `app.py` / `__main__.py`
- `index.ts` / `main.ts` / `App.tsx`
- `main.go`
- `src/main.rs`

**Core Models/Types:**
- Database models / schemas
- Type definitions
- API schemas (Pydantic, Zod, etc.)

**Configuration:**
- Environment handling
- Settings/config modules

### 5. Check Current State

**Git Status:**
```bash
git status
git branch -a
```

**Recent Activity:**
```bash
git log -10 --oneline --decorate
```

**Current Branch:**
```bash
git branch --show-current
```

---

## Output Report

Provide a concise, scannable summary:

### Project Identity
```
Name: [Project name]
Type: [Web app | CLI tool | Library | API | etc.]
Purpose: [One sentence description]
```

### Tech Stack
```
Language: [Language + version]
Framework: [Framework + version]
Database: [If applicable]
Frontend: [If applicable]
Testing: [Test framework]
Linting: [Linter]
```

### Architecture
```
Pattern: [Monolith | Microservices | Serverless | etc.]
Structure: [Feature-based | Layer-based | etc.]
Key Directories:
  - src/        : [Purpose]
  - tests/      : [Purpose]
  - [other]     : [Purpose]
```

### Conventions (from CLAUDE.md)
```
Naming: [file/function/variable conventions]
Imports: [ordering rules]
Testing: [requirements]
Forbidden: [key things to avoid]
```

### Lessons Learned (from lessons.md)
```
Key Rules:
- [Most important lesson 1]
- [Most important lesson 2]
- [Most important lesson 3]
```

### Current State
```
Branch: [current branch]
Status: [clean | X uncommitted changes]
Recent Focus: [based on recent commits]
```

### Observations & Concerns
```
- [Any issues noticed]
- [Any inconsistencies]
- [Any suggestions]
```

---

## Ready State

After priming, you should be able to:

1. Navigate the codebase confidently
2. Know which patterns to follow
3. Avoid documented mistakes
4. Understand recent context
5. Make changes that fit the project style
