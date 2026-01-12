# Custom Templates Guide

> *"The Universe is Mental — held in the Mind of THE ALL."*

How to customize and create command templates in Trismegistus.

---

## Overview

Trismegistus uses markdown templates to define what each command does. You can:

1. **Modify existing templates** to fit your workflow
2. **Create new templates** for project-specific tasks
3. **Override global templates** at the project level

---

## Template Locations

### Global Templates

`~/.trismegistus/templates/`

```
templates/
├── commands/
│   ├── core/
│   │   ├── plan-feature.md    # ai-plan template
│   │   ├── execute.md         # ai-exec template
│   │   ├── prime.md           # Context priming
│   │   └── generate-rules.md  # CLAUDE.md generation
│   ├── validation/
│   │   ├── code-review.md     # ai-verify template
│   │   ├── validate.md        # Validation checklist
│   │   └── ...
│   ├── bugfix/
│   │   ├── rca.md             # Root cause analysis
│   │   └── implement-fix.md   # Bug fix implementation
│   ├── commit.md              # ai-commit template
│   └── create-prd.md          # PRD generation
├── active/
│   └── prd-template.md        # Default PRD structure
├── memory/
│   └── lessons.md             # Default lessons file
└── reference/
    └── README.md              # Reference folder docs
```

### Project Templates (Override)

`.claude/commands/`

Templates here override global templates for this project only.

---

## Template Structure

### Basic Template

```markdown
---
description: Short description of what this command does
argument-hint: [optional-argument]
---

# Command Title

## Context
What context the AI needs to understand.

## Instructions
1. Step one
2. Step two
3. Step three

## Output
What the AI should produce.
```

### Template Variables

| Variable | Description |
|----------|-------------|
| `$ARGUMENTS` | Arguments passed to the command |
| Project files | Automatically injected based on context |

---

## Customizing Existing Templates

### Example: Modify plan-feature.md

1. Copy the global template:
   ```powershell
   Copy-Item "$HOME\.trismegistus\templates\commands\core\plan-feature.md" ".\.claude\commands\plan-feature.md"
   ```

2. Edit it:
   ```powershell
   code .claude\commands\plan-feature.md
   ```

3. Your project now uses the custom version.

### Common Customizations

**Add framework-specific instructions:**
```markdown
## Framework Requirements
- All React components must use TypeScript
- Use Tailwind CSS for styling
- Follow the existing pattern in src/components/
```

**Add testing requirements:**
```markdown
## Testing
- Every new function must have unit tests
- Use Jest + React Testing Library
- Minimum 80% coverage
```

**Add documentation requirements:**
```markdown
## Documentation
- Add JSDoc comments to all exports
- Update README if adding new features
- Include usage examples
```

---

## Creating New Templates

### Step 1: Create the file

```powershell
# Global (all projects)
New-Item "$HOME\.trismegistus\templates\commands\my-command.md"

# Project-specific
New-Item ".\.claude\commands\my-command.md"
```

### Step 2: Write the template

```markdown
---
description: Generate API documentation from code
argument-hint: [file-or-folder]
---

# Generate API Documentation

## Target
Analyze: `$ARGUMENTS`

## Instructions
1. Read all TypeScript/JavaScript files in the target
2. Extract all exported functions and classes
3. Document parameters, return types, and descriptions
4. Generate markdown documentation

## Output Format
Create `docs/API.md` with:

### Functions
- Function name
- Parameters (with types)
- Return type
- Description
- Example usage

### Classes
- Class name
- Constructor
- Methods
- Properties

## Quality Requirements
- Include code examples for complex functions
- Note any side effects
- Document thrown errors
```

### Step 3: Use it

```powershell
ai-custom my-command src/api/
```

Or create an alias in your profile:
```powershell
function ai-docs { ai-custom my-command $args }
```

---

## Template Examples

### Deploy Template

```markdown
---
description: Generate deployment checklist and scripts
---

# Deployment Preparation

## Pre-Deploy Checklist
1. Run all tests: `npm test`
2. Build production: `npm run build`
3. Check for console.logs
4. Verify environment variables
5. Update version in package.json

## Instructions
1. Analyze the current project
2. Generate a deployment checklist specific to this stack
3. Create any missing deployment scripts
4. Verify all checks pass

## Output
- `.github/workflows/deploy.yml` if missing
- `DEPLOY.md` with step-by-step instructions
- Report on deployment readiness
```

### Security Audit Template

```markdown
---
description: Security audit of the codebase
---

# Security Audit

## Scan For
1. Hardcoded secrets/API keys
2. SQL injection vulnerabilities
3. XSS vulnerabilities
4. Insecure dependencies
5. Authentication issues
6. CORS misconfigurations

## Instructions
1. Scan all source files for security issues
2. Check package.json for known vulnerable packages
3. Review authentication/authorization logic
4. Check for sensitive data exposure

## Output
Create `SECURITY_AUDIT.md` with:
- Critical issues (fix immediately)
- High priority issues
- Medium priority issues
- Recommendations
- Remediation steps for each issue
```

### Refactor Template

```markdown
---
description: Refactor code for better quality
argument-hint: [file-path]
---

# Code Refactoring

## Target
Refactor: `$ARGUMENTS`

## Principles
- Improve readability
- Reduce complexity
- Extract reusable functions
- Apply SOLID principles
- NO functionality changes

## Instructions
1. Analyze the target code
2. Identify code smells
3. Plan refactoring steps
4. Execute refactoring
5. Verify behavior unchanged

## Constraints
- Preserve all existing functionality
- Maintain API compatibility
- Keep same file structure unless explicitly needed
- Run tests after refactoring
```

---

## Project-Specific Templates

### For a React Project

`.claude/commands/component.md`:

```markdown
---
description: Generate a new React component
argument-hint: [ComponentName]
---

# Create React Component

## Component: $ARGUMENTS

## Structure
Create in `src/components/$ARGUMENTS/`:
- `index.tsx` - Component code
- `$ARGUMENTS.test.tsx` - Tests
- `$ARGUMENTS.stories.tsx` - Storybook (if exists)

## Component Template
- Functional component with TypeScript
- Props interface exported
- Use Tailwind CSS
- Include loading and error states if data-fetching

## Testing
- Render test
- Props test
- Interaction test (if interactive)
```

### For a Python API Project

`.claude/commands/endpoint.md`:

```markdown
---
description: Generate a new API endpoint
argument-hint: [endpoint-name]
---

# Create API Endpoint

## Endpoint: $ARGUMENTS

## Files to Create
- `app/routers/$ARGUMENTS.py` - Router
- `app/schemas/$ARGUMENTS.py` - Pydantic models
- `app/services/$ARGUMENTS.py` - Business logic
- `tests/test_$ARGUMENTS.py` - Tests

## Standards
- Follow existing router patterns
- Include request/response models
- Add OpenAPI documentation
- Handle errors with HTTPException
- Log important operations

## Registration
Add to `app/main.py`:
```python
from app.routers import $ARGUMENTS
app.include_router($ARGUMENTS.router, prefix="/api")
```
```

---

## Tips

### Keep Templates DRY

If multiple templates share instructions, extract to a reference file:

```
.claude/reference/coding-standards.md
```

Then reference it in templates:
```markdown
## Standards
Follow the guidelines in `reference/coding-standards.md`.
```

### Version Your Templates

For team projects, commit `.claude/commands/` to git so everyone uses the same templates.

### Test Templates

After creating a template, test it:
```powershell
ai-plan "Test the new template"
code .claude/active/plan.md  # Review output
```

---

*"Nothing rests; everything moves; everything vibrates."*
