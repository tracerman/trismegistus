---
description: Execute an implementation plan with progress tracking
argument-hint: [path-to-plan]
---

# Execute Implementation Plan

## Plan Location

Read and execute: `.tris/active/plan.md`

(Or if specified: `$ARGUMENTS`)

---

## Pre-Execution Checklist

Before starting, verify:

- [ ] Plan file exists and is readable
- [ ] Mandatory reading files from plan exist
- [ ] You understand all steps
- [ ] Development environment is ready

---

## Execution Protocol

### Rule 1: READ BEFORE WRITE

**ALWAYS** read existing files before modifying them.

```
WRONG: Assume file structure and edit blindly
RIGHT: Read file → Understand structure → Make targeted changes
```

This prevents:
- Overwriting unrelated code
- Missing existing patterns
- Breaking imports

### Rule 2: EXECUTE SEQUENTIALLY

Follow the plan steps in exact order. Each step depends on previous steps.

```
Step 1 → Validate → Step 2 → Validate → Step 3 → ...
```

**Do NOT skip ahead.** Do NOT parallelize unless explicitly safe.

### Rule 3: VALIDATE AS YOU GO

After each step, run its validation command immediately.

```
WRONG: Complete all steps, then run all validations
RIGHT: Step → Validate → Step → Validate → ...
```

Catching errors early prevents cascading failures.

### Rule 4: SELF-CORRECT INTELLIGENTLY

If something fails:

1. **STOP** - Do not retry blindly
2. **DIAGNOSE** - What actually went wrong?
3. **ROOT CAUSE** - Why did it fail? (Not just symptoms)
4. **FIX** - Address the actual problem
5. **RESUME** - Continue from the failed step

Document unexpected issues for post-mortem.

### Rule 5: TRACK PROGRESS

After completing each major step, append to `.tris/active/progress.txt`:

```
[2025-01-15 14:32] ✓ Completed: Step 1 - Created database model
[2025-01-15 14:45] ✓ Completed: Step 2 - Added API endpoint
[2025-01-15 14:50] ✗ Failed: Step 3 - Import error (fixed, retrying)
[2025-01-15 14:55] ✓ Completed: Step 3 - Service layer implemented
```

This enables:
- Resume after interruption
- Post-mortem analysis
- Progress visibility

---

## Execution Steps

### 1. Load the Plan

Read `.tris/active/plan.md` completely.

Identify:
- Total number of steps
- Dependencies between steps
- Validation commands for each step

### 2. Read Mandatory Files

Read every file listed in the "MANDATORY READING" section.

Extract:
- Patterns to follow
- Utilities to import (not recreate)
- Conventions to match

### 3. Execute Each Step

For each step in the plan:

#### a) Prepare
- Read target file(s) if modifying
- Confirm patterns from mandatory reading
- Check imports will resolve

#### b) Implement
- Follow the step specification exactly
- Match existing code style
- Include appropriate error handling
- Add logging where appropriate
- Include type hints (if applicable)

#### c) Validate
- Run the step's validation command
- If it fails: diagnose, fix, retry
- If it passes: log progress, continue

#### d) Document
- Add comments for non-obvious code
- Update relevant documentation

### 4. Implement Tests

After all implementation steps:

- Create test files specified in plan
- Implement all test cases listed
- Follow project's test patterns exactly
- Run tests and fix until green

### 5. Run Full Validation Suite

Execute ALL validation commands from the plan:

```bash
# Example sequence (replace with actual from plan)
ruff check .               # Linting
mypy .                     # Type checking
pytest tests/unit          # Unit tests
pytest tests/integration   # Integration tests
```

**ALL must pass before proceeding.**

### 6. Update Documentation

- Update CHANGELOG.md with changes
- Update README if user-facing changes
- Add/update API documentation if applicable

### 7. Prepare Commit (CRITICAL)

**This step is MANDATORY. Do NOT skip.**

Create file `.tris/commit_msg.txt` containing a single-line conventional commit message:

```
type(scope): concise description
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code change that neither fixes nor adds
- `docs`: Documentation only
- `test`: Adding or modifying tests
- `chore`: Maintenance tasks

**Examples:**
```
feat(api): add habit completion endpoint with streak tracking
fix(ui): resolve calendar not updating on habit completion
refactor(db): optimize streak calculation query
test(habits): add integration tests for CRUD operations
```

**Without this file, the auto-commit system will fail.**

---

## Error Recovery

### If Implementation Fails

1. Note the step that failed in progress.txt
2. Diagnose the root cause
3. Fix the issue
4. Re-run validation for that step
5. Continue execution

### If Validation Fails

1. Read the error message carefully
2. Check if it's a:
   - Syntax error → Fix the syntax
   - Type error → Fix types or add ignores with justification
   - Test failure → Fix implementation or update test expectation
   - Lint error → Fix style or add exception with comment
3. Re-run until passing

### If Stuck

1. Document where you're stuck in progress.txt
2. Note what you've tried
3. Stop execution gracefully
4. The user can review and provide guidance

---

## Output Report

After completing ALL steps, provide:

### Summary
```
EXECUTION COMPLETE

Steps Completed: X/Y
Files Created: [list]
Files Modified: [list]
Tests Added: [count]

Validation Results:
- Linting: ✓ PASS
- Type Check: ✓ PASS
- Unit Tests: ✓ PASS (X tests)
- Integration: ✓ PASS (Y tests)

Commit Message: [contents of commit_msg.txt]

Ready for: ai-commit
```

### If Issues Encountered
```
EXECUTION COMPLETE WITH NOTES

Issues Encountered:
1. [Issue description and how it was resolved]
2. [Issue description and how it was resolved]

Lessons for Future:
- [Pattern or insight worth remembering]

These should be added to lessons.md via ai-finish.
```

---

## Reminders

- **Match existing patterns exactly** - Don't introduce new conventions
- **Reuse existing utilities** - Don't recreate what exists
- **Error handling is not optional** - Every failure path needs handling
- **Tests are not optional** - If the plan includes tests, implement them
- **The commit message file is not optional** - Create it or commit will fail
