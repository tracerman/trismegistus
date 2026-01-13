---
description: Fix issues found in code review
argument-hint: [path-to-review]
---

# Fix Code Review Issues

## Review Reference

Read review document: `$ARGUMENTS`

---

## Process

### 1. Load Review Document

Read the code review output completely.

Categorize issues by severity:
- **CRITICAL** - Fix immediately, blocks merge
- **HIGH** - Must fix before merge
- **MEDIUM** - Should fix, minor issues
- **LOW** - Optional improvements

### 2. Fix Issues in Priority Order

#### For Each CRITICAL Issue

1. **Understand the issue** - Read the explanation
2. **Locate the code** - Go to specified file:line
3. **Apply the suggested fix** - Or equivalent solution
4. **Verify the fix** - Run relevant tests
5. **Mark as resolved**

#### For Each HIGH Issue

[Same process]

#### For Each MEDIUM Issue

[Same process]

#### For Each LOW Issue

Consider whether to fix now or defer:
- If quick fix (< 5 min): Fix it
- If larger change: Create a TODO or separate issue

### 3. Validation After Each Fix

```bash
# After each fix, run:
[linting command]
[type check command]
[relevant tests]
```

Don't accumulate fixes without validating - catch issues early.

### 4. Re-run Full Validation

After all fixes:

```bash
# Full validation suite
[lint]
[type check]
[all tests]
```

### 5. Document Fixes

Update the review document or create a summary:

```markdown
## Fixes Applied

### CRITICAL Issues: [X/X fixed]

| Issue | Status | Notes |
|-------|--------|-------|
| [Issue 1] | ✓ Fixed | [How it was fixed] |
| [Issue 2] | ✓ Fixed | [How it was fixed] |

### HIGH Issues: [X/X fixed]

| Issue | Status | Notes |
|-------|--------|-------|
| [Issue 3] | ✓ Fixed | [How it was fixed] |

### MEDIUM Issues: [X/X fixed]

| Issue | Status | Notes |
|-------|--------|-------|
| [Issue 4] | ✓ Fixed | |
| [Issue 5] | Deferred | Created issue #XX |

### LOW Issues: [X/X addressed]

| Issue | Status | Notes |
|-------|--------|-------|
| [Issue 6] | ✓ Fixed | |
| [Issue 7] | Won't fix | [Reason] |
```

### 6. Update Commit

If changes were already committed, amend or create new commit:

```bash
# If amending
git add .
git commit --amend

# If new commit
# Update .tris/commit_msg.txt
fix: address code review feedback

- Fix [issue 1]
- Fix [issue 2]
- [etc]
```

---

## Output

```markdown
## Code Review Fixes Complete

**Review:** [path to review]
**Date:** [timestamp]

### Summary

| Severity | Found | Fixed | Deferred |
|----------|-------|-------|----------|
| Critical | X | X | 0 |
| High | X | X | 0 |
| Medium | X | Y | Z |
| Low | X | Y | Z |

### Validation

- Linting: ✓
- Type Check: ✓
- Tests: ✓ (all passing)

### Ready for Re-Review or Merge

All critical and high issues resolved.
```

---

## If Disagreeing with Review

If you believe a review item is incorrect:

1. **Document your reasoning** - Why you disagree
2. **Don't silently ignore** - Explicit is better
3. **Propose alternative** - If not the suggested fix, what instead?
4. **Flag for discussion** - Note in output for human review
