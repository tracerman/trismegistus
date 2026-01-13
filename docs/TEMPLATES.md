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
│   │   ├── continue.md        # ai-continue template
│   │   ├── prime.md           # Context priming
│   │   └── generate-rules.md  # CLAUDE.md generation
│   ├── validation/
│   │   ├── code-review.md     # ai-review template
│   │   ├── test.md            # ai-test template
│   │   ├── diff.md            # ai-diff template
│   │   ├── validate.md        # Validation checklist
│   │   └── ...
│   ├── research/
│   │   ├── estimate.md        # ai-estimate template
│   │   ├── research.md        # ai-research template
│   │   └── explain.md         # ai-explain template
│   ├── shipping/
│   │   ├── docs.md            # ai-docs template
│   │   ├── changelog.md       # ai-changelog template
│   │   └── ship.md            # ai-ship template
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

`.tris/commands/` (or `.claude/commands/` for legacy projects)

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

## Command Template Reference

### Planning Commands

| Command | Template | Purpose |
|---------|----------|---------|
| `ai-plan` | `core/plan-feature.md` | Execution planning |
| `ai-verify` | `validation/code-review.md` | Plan review |
| `ai-architect` | Built-in | Tree of Thoughts |
| `ai-estimate` | `research/estimate.md` | Complexity analysis |
| `ai-research` | `research/research.md` | Deep research |
| `ai-split` | Built-in | Phase splitting |

### Execution Commands

| Command | Template | Purpose |
|---------|----------|---------|
| `ai-exec` | `core/execute.md` | Plan execution |
| `ai-continue` | `core/continue.md` | Resume execution |
| `ai-debug` | Built-in | Error analysis |

### Validation Commands

| Command | Template | Purpose |
|---------|----------|---------|
| `ai-diff` | `validation/diff.md` | Change summary |
| `ai-test` | `validation/test.md` | Test analysis |
| `ai-review` | `validation/code-review.md` | Code review |
| `ai-explain` | `research/explain.md` | Code explanation |

### Shipping Commands

| Command | Template | Purpose |
|---------|----------|---------|
| `ai-commit` | `commit.md` | Commit message |
| `ai-docs` | `shipping/docs.md` | Documentation |
| `ai-changelog` | `shipping/changelog.md` | Changelog |
| `ai-finish` | Built-in | Post-mortem |

---

## Customizing Existing Templates

### Example: Modify plan-feature.md

1. Copy the global template:
   ```powershell
   Copy-Item "$HOME\.trismegistus\templates\commands\core\plan-feature.md" ".\.tris\commands\plan-feature.md"
   ```

2. Edit it:
   ```powershell
   code .tris\commands\plan-feature.md
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
New-Item ".\.tris\commands\my-command.md"
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
function ai-apidocs { ai-custom my-command $args }
```

---

## Template Examples

### Custom Test Template

```markdown
---
description: Generate comprehensive tests for a file
argument-hint: [file-path]
---

# Generate Tests

## Target
Create tests for: `$ARGUMENTS`

## Instructions
1. Analyze the target file
2. Identify all exported functions/classes
3. Generate test cases covering:
   - Happy path
   - Edge cases
   - Error conditions
   - Boundary values

## Test Structure
- Use describe/it blocks
- Group by function/method
- Include setup/teardown where needed

## Output
Create test file at `__tests__/[filename].test.ts`
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

`.tris/commands/component.md`:

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

`.tris/commands/endpoint.md`:

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
.tris/reference/coding-standards.md
```

Then reference it in templates:
```markdown
## Standards
Follow the guidelines in `reference/coding-standards.md`.
```

### Version Your Templates

For team projects, commit `.tris/commands/` to git so everyone uses the same templates.

### Test Templates

After creating a template, test it:
```powershell
ai-plan "Test the new template"
code .tris/active/plan.md  # Review output
```

### Template Best Practices

1. **Be specific** — Vague instructions lead to vague output
2. **Include examples** — Show the AI what good output looks like
3. **Add constraints** — Tell the AI what NOT to do
4. **Define output format** — Specify file names, structure, formatting

---

*"Nothing rests; everything moves; everything vibrates."*
