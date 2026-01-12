---
description: Generate project constitution (CLAUDE.md) for a new or existing project
---

# Generate CLAUDE.md: Project Constitution

## Purpose

Create the definitive rules document that governs all AI-assisted development in this project. This file is read at the start of every planning and execution session.

---

## Phase 1: Analyze Existing Project (If Brownfield)

If this is an existing codebase, analyze it first:

### Detect Tech Stack

```bash
# Check for configuration files
ls -la package.json pyproject.toml Cargo.toml go.mod pom.xml build.gradle 2>/dev/null

# Check for framework indicators
grep -r "fastapi\|flask\|django\|express\|react\|vue\|angular" . --include="*.json" --include="*.toml" 2>/dev/null | head -5

# Check existing structure
find . -type f -name "*.py" -o -name "*.ts" -o -name "*.js" -o -name "*.go" 2>/dev/null | head -20
```

### Identify Existing Patterns

```bash
# Naming conventions (check existing files)
ls -la src/ app/ lib/ 2>/dev/null

# Import patterns
head -20 $(find . -name "*.py" -o -name "*.ts" | head -3) 2>/dev/null

# Test patterns
ls -la tests/ test/ __tests__/ spec/ 2>/dev/null
```

### Check for Existing Config

```bash
# Linting
cat .eslintrc* eslint.config.* ruff.toml .ruff.toml pyproject.toml 2>/dev/null | head -50

# Formatting
cat .prettierrc* .editorconfig 2>/dev/null

# Types
cat tsconfig.json mypy.ini pyrightconfig.json 2>/dev/null | head -30
```

---

## Phase 2: Generate CLAUDE.md

**Output Path:** `.claude/CLAUDE.md`

### Template

```markdown
# Project Rules

> This is the constitution for AI-assisted development. Follow these rules in ALL work.

## Project Overview

**Name:** [Project name]
**Purpose:** [One sentence description]
**Type:** [Web app | API | CLI | Library | etc.]

---

## Tech Stack

### Core
- **Language:** [Language] [version]
- **Framework:** [Framework] [version]
- **Runtime:** [Node.js/Python/Go version]

### Database
- **Primary:** [Database] [version]
- **ORM/Driver:** [SQLAlchemy/Prisma/etc.]

### Frontend (if applicable)
- **Framework:** [React/Vue/etc.] [version]
- **Styling:** [Tailwind/CSS Modules/etc.]
- **State:** [TanStack Query/Zustand/Redux/etc.]

### Testing
- **Framework:** [pytest/vitest/jest/etc.]
- **Coverage Tool:** [coverage.py/c8/etc.]
- **Minimum Coverage:** [X%]

### Code Quality
- **Linter:** [ruff/eslint/etc.]
- **Formatter:** [black/prettier/etc.]
- **Type Checker:** [mypy/pyright/tsc/etc.]

---

## Architecture

### Directory Structure

```
project-root/
├── src/                    # [Purpose]
│   ├── api/                # [Purpose]
│   ├── core/               # [Purpose]
│   └── utils/              # [Purpose]
├── tests/                  # [Purpose]
│   ├── unit/               # [Purpose]
│   └── integration/        # [Purpose]
├── docs/                   # [Purpose]
└── scripts/                # [Purpose]
```

### Key Patterns

- **[Pattern Name]:** [Brief description of when/how to use]
- **[Pattern Name]:** [Brief description of when/how to use]

---

## Conventions

### Naming

| Type | Convention | Example |
|------|------------|---------|
| Files (code) | [snake_case/kebab-case/PascalCase] | `user_service.py` |
| Files (components) | [PascalCase/kebab-case] | `UserCard.tsx` |
| Functions | [snake_case/camelCase] | `get_user_by_id` |
| Classes | [PascalCase] | `UserService` |
| Constants | [SCREAMING_SNAKE_CASE] | `MAX_RETRY_COUNT` |
| Variables | [snake_case/camelCase] | `user_count` |

### Import Ordering

```python
# Example for Python:
# 1. Standard library
# 2. Third-party packages
# 3. Local imports (absolute)
# 4. Local imports (relative)

import os
import sys
from datetime import datetime

from fastapi import FastAPI
from pydantic import BaseModel

from app.core.config import settings
from app.models.user import User

from .utils import helper
```

### File Organization

- **One module per file** (generally)
- **Related code stays together** (feature-based, not type-based)
- **Tests mirror source structure**

---

## Required Patterns

### Error Handling

```python
# Always use structured error handling
try:
    result = operation()
except SpecificException as e:
    logger.error("Operation failed", error=str(e), context=context)
    raise AppError("User-friendly message") from e
```

### Logging

```python
# Use structured logging
logger.info(
    "Action completed",
    user_id=user.id,
    action="create",
    duration_ms=elapsed
)
```

### Database Operations

```python
# Always use context managers for sessions
with get_session() as session:
    result = session.query(Model).filter(...).first()
```

### API Responses

```python
# Consistent response format
return {"data": result, "meta": {"count": len(result)}}

# Error responses
return {"error": {"code": "NOT_FOUND", "message": "..."}}
```

---

## Forbidden Patterns

> These patterns are NEVER allowed. If you see them, refactor.

### Security
- ❌ **String formatting in SQL** - Use parameterized queries
- ❌ **Secrets in code** - Use environment variables
- ❌ **eval() or exec()** - Never execute dynamic code
- ❌ **Disabled CORS in production** - Configure properly

### Code Quality
- ❌ **Catch-all exception handlers** - Be specific
- ❌ **Magic numbers** - Use named constants
- ❌ **Copy-pasted code** - Extract to functions
- ❌ **God objects** - Split large classes
- ❌ **Nested callbacks > 2 levels** - Use async/await

### Project Specific
- ❌ [Project-specific forbidden pattern]
- ❌ [Project-specific forbidden pattern]

---

## Testing Requirements

### What Must Be Tested

- [ ] All public API endpoints
- [ ] All business logic functions
- [ ] All data transformations
- [ ] Error handling paths
- [ ] Edge cases documented in PRD

### Test Structure

```python
def test_[unit]_[scenario]_[expected_result]():
    # Arrange
    input_data = {...}
    
    # Act
    result = function_under_test(input_data)
    
    # Assert
    assert result == expected
```

### Coverage Requirements

- **Minimum:** [X%] overall
- **Critical paths:** 100%
- **New code:** Must include tests

---

## Documentation Requirements

### Code Comments

- **When:** Non-obvious logic, workarounds, TODOs
- **Not When:** Self-explanatory code

### Docstrings

```python
def function_name(param1: Type, param2: Type) -> ReturnType:
    """Brief description of what the function does.
    
    Args:
        param1: Description of param1
        param2: Description of param2
    
    Returns:
        Description of return value
    
    Raises:
        ExceptionType: When this happens
    """
```

### README Updates

Update README.md when:
- Adding new features
- Changing setup instructions
- Modifying API contracts

---

## Git Conventions

### Commit Messages

Format: `type(scope): description`

Types:
- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code restructuring
- `docs`: Documentation
- `test`: Test additions/changes
- `chore`: Maintenance

### Branch Naming

- `feature/[description]`
- `fix/[issue-id]-[description]`
- `refactor/[description]`

---

## Environment Setup

### Required Environment Variables

```bash
DATABASE_URL=       # Database connection string
SECRET_KEY=         # Application secret
DEBUG=              # true/false
```

### Development Commands

```bash
# Install dependencies
[command]

# Run development server
[command]

# Run tests
[command]

# Run linter
[command]
```

---

## Notes

[Any additional project-specific information]
```

---

## Phase 3: Validate Generated CLAUDE.md

After generation, verify:

- [ ] Tech stack is accurate
- [ ] Conventions match existing code
- [ ] Forbidden patterns are project-appropriate
- [ ] Testing requirements are realistic
- [ ] All examples use correct syntax

---

## Maintenance

CLAUDE.md should be updated when:

1. Tech stack changes
2. New conventions are established
3. New forbidden patterns are discovered
4. Through `ai-optimize` based on lessons learned
