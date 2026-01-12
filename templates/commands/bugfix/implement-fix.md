---
description: Implement fix from RCA document
argument-hint: [path-to-rca or issue-id]
---

# Implement Fix from Root Cause Analysis

## RCA Reference

Read RCA document: `$ARGUMENTS`

Or if issue ID provided, look for: `.claude/reference/rca/issue-$ARGUMENTS.md`

---

## Pre-Implementation Checklist

Before starting:

- [ ] RCA document exists and is complete
- [ ] Root cause is clearly identified
- [ ] Proposed fix is documented
- [ ] Affected files are listed
- [ ] Test requirements are specified

---

## Implementation Process

### 1. Verify RCA Understanding

Read the RCA completely. Confirm you understand:

- **What broke:** [Summarize]
- **Why it broke:** [Summarize]
- **How to fix:** [Summarize]

If anything is unclear, STOP and ask for clarification.

### 2. Verify Current State

```bash
# Check if the issue still exists
# [reproduction steps from RCA]

# Check current state of affected files
git status
git diff HEAD -- [affected files]
```

### 3. Create Fix Branch (If Not Already)

```bash
git checkout -b fix/[issue-id]-[brief-description]
```

### 4. Implement the Fix

Follow the "Proposed Fix" section exactly:

**For each file to modify:**

a) **Read the existing file** - Understand full context
b) **Make the specific changes** - As documented in RCA
c) **Verify syntax** - No typos or errors
d) **Check consistency** - Matches codebase patterns

**Key Principles:**
- **Minimal changes** - Fix only what's broken
- **No scope creep** - Don't refactor unrelated code
- **Match patterns** - Use existing conventions
- **Add comments** - If fix is non-obvious

### 5. Add Tests

**Required tests from RCA:**

a) **Regression Test** - Reproduces the original bug scenario
```python
def test_issue_[id]_regression():
    """Verify issue #[id] is fixed and doesn't regress."""
    # Arrange - set up the scenario that caused the bug
    # Act - execute the previously failing code
    # Assert - verify it now works correctly
```

b) **Edge Case Tests** - Cover related scenarios
```python
def test_[related_edge_case]():
    # Test edge cases discovered during RCA
```

c) **Integration Test** - If the fix spans components
```python
def test_[integration_scenario]():
    # Test the full workflow affected by the fix
```

### 6. Run Validation

Execute all validation commands from RCA:

```bash
# Linting
[rca-specified command]

# Type checking
[rca-specified command]

# Run specific tests
pytest tests/test_[affected].py -v

# Run full test suite
[rca-specified command]
```

**ALL must pass before proceeding.**

### 7. Verify the Fix

**Manual Verification:**

Follow the reproduction steps from RCA:
1. [Step 1]
2. [Step 2]
3. **Confirm issue no longer occurs**

**Automated Verification:**
- [ ] Regression test passes
- [ ] No new test failures
- [ ] Linting passes
- [ ] Type checking passes

### 8. Update Documentation

If needed:
- [ ] Update code comments
- [ ] Update API documentation
- [ ] Update README if user-facing
- [ ] Update CHANGELOG

### 9. Prepare Commit

Create `.claude/commit_msg.txt`:

```
fix(scope): [brief description of fix]

[Optional longer description]

Fixes #[issue-id]
```

The `Fixes #[id]` line will auto-close the GitHub issue when merged.

---

## Output Report

```markdown
## Fix Implementation Complete

**Issue:** #[id] - [title]
**RCA:** [path to RCA document]

### Changes Made

| File | Change |
|------|--------|
| `path/to/file.py` | [Description] |

### Tests Added

| Test | Purpose |
|------|---------|
| `test_issue_[id]_regression` | Prevents regression |
| `test_[edge_case]` | Covers edge case |

### Validation Results

- Linting: ✓
- Type Check: ✓
- Unit Tests: ✓ (X passed)
- Integration: ✓ (Y passed)
- Manual Test: ✓

### Verification

- [x] Reproduction steps no longer cause the issue
- [x] All tests pass
- [x] No new warnings or errors

### Ready for Commit

Commit message prepared in `.claude/commit_msg.txt`

Run: `ai-commit`
```

---

## Post-Fix Actions

After commit:

1. **Close GitHub issue** (if not auto-closed):
   ```bash
   gh issue close [issue-id] --comment "Fixed in [commit-hash]"
   ```

2. **Add lesson** if applicable:
   ```bash
   ai-evolve "When [scenario], always [prevention]"
   ```

3. **Update RCA status**:
   Add to RCA document:
   ```markdown
   ## Resolution
   - Fixed in commit: [hash]
   - Merged: [date]
   - Verified in production: [date]
   ```
