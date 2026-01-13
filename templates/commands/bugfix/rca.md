---
description: Root Cause Analysis for bugs and issues
argument-hint: [issue-description or github-issue-id]
---

# Root Cause Analysis

## Issue

`$ARGUMENTS`

---

## Phase 0: Check Memory First

**Before investigating, search for similar past issues.**

Read `.tris/memory/lessons.md` and look for:
- Similar error patterns
- Related components
- Past fixes that might apply

If a matching lesson exists:
```
MATCH FOUND in lessons.md:
- Lesson: [lesson text]
- Relevance: [how it applies]
- Suggested approach: [based on past fix]
```

---

## Phase 1: Gather Information

### If GitHub Issue ID Provided

```bash
# Fetch issue details
gh issue view [issue-id]

# Get comments
gh issue view [issue-id] --comments
```

Extract:
- Issue title and description
- Error messages or stack traces
- Steps to reproduce
- Environment details
- Related issues mentioned

### If Error/Bug Description Provided

Document:
- What is the expected behavior?
- What is the actual behavior?
- When did this start happening?
- What changed recently?

### Check Recent Changes

```bash
# Recent commits
git log -20 --oneline

# Recent changes to affected areas
git log -10 --oneline -- [relevant-path]

# What changed in the last day/week
git log --since="1 week ago" --oneline
```

---

## Phase 2: Reproduce the Issue

### Attempt Reproduction

1. Follow reported steps exactly
2. Note: Does it reproduce consistently?
3. Note: What variations affect it?

### If Cannot Reproduce

- Document environment differences
- Request more information
- Check if issue is environment-specific

---

## Phase 3: Investigate Root Cause

### Trace the Error

Starting from the error/symptom:

1. **Entry Point**: Where does the error surface?
2. **Call Stack**: What called the failing code?
3. **Data Flow**: What data reached this point?
4. **State**: What was the application state?

### Search Codebase

```bash
# Find related code
grep -r "error_message" .
grep -r "function_name" .
grep -r "related_term" .
```

### Categories of Root Causes

**Logic Errors:**
- Incorrect conditional
- Wrong algorithm
- Edge case not handled
- Off-by-one error

**State Issues:**
- Race condition
- Stale cache
- Inconsistent state
- Missing initialization

**Data Issues:**
- Invalid input not validated
- Type mismatch
- Encoding problem
- Data corruption

**Environment Issues:**
- Configuration error
- Missing dependency
- Version mismatch
- Resource exhaustion

**Integration Issues:**
- API contract changed
- Network timeout
- External service failure
- Authentication expired

---

## Phase 4: Document Findings

### Output Path

Save to: `.tris/reference/rca/issue-[id-or-name].md`

### RCA Document Format

```markdown
# Root Cause Analysis: [Issue Title]

## Issue Summary

| Field | Value |
|-------|-------|
| Issue ID | [GitHub ID or internal ref] |
| Reported | [date] |
| Severity | [Critical/High/Medium/Low] |
| Status | [Investigating/Identified/Fixed] |
| Affected | [components/users] |

## Problem Description

**Expected Behavior:**
[What should happen]

**Actual Behavior:**
[What actually happens]

**Error Message:**
```
[exact error text]
```

## Reproduction

**Steps:**
1. [Step 1]
2. [Step 2]
3. [Observe issue]

**Consistency:** [Always/Sometimes/Rarely]

**Environment:** [where it occurs]

---

## Root Cause

### Summary
[One sentence: What is fundamentally wrong]

### Detailed Analysis

[Explain the chain of events leading to the issue]

### Affected Code

**File:** `path/to/file.py`
**Lines:** 42-50

```python
# The problematic code
def broken_function():
    # This fails because...
    pass
```

### Why This Happened

[Explain how this bug was introduced]
- Was it always there?
- Did a recent change cause it?
- Was it a misunderstanding of requirements?

### Related Issues

- [Links to related bugs/issues]
- [Similar past issues from lessons.md]

---

## Proposed Fix

### Strategy

[High-level approach to fixing]

### Specific Changes

**File:** `path/to/file.py`

```python
# Before
broken_code()

# After
fixed_code()
```

### Files to Modify

1. `path/to/file1.py` - [what to change]
2. `path/to/file2.py` - [what to change]

### Tests to Add

1. Test that reproduces the original bug
2. Test for edge cases discovered
3. Regression test for related scenarios

---

## Validation

**How to verify the fix:**

```bash
# Run specific test
pytest tests/test_affected.py -v

# Manual verification
curl [endpoint] | grep [expected]
```

**Acceptance Criteria:**
- [ ] Original issue no longer reproduces
- [ ] New tests pass
- [ ] No regression in related functionality
- [ ] Edge cases handled

---

## Prevention

### Immediate Actions
- [ ] Fix the code
- [ ] Add tests
- [ ] Update documentation

### Future Prevention
- [ ] Add validation at [location]
- [ ] Improve error messages
- [ ] Add monitoring/alerting
- [ ] Update lessons.md with this pattern

### Lesson Learned

**Add to lessons.md:**
```
- [DATE] LESSON: [Concise, actionable rule derived from this bug]
```

---

## Timeline

| Time | Event |
|------|-------|
| [date] | Issue reported |
| [date] | Investigation started |
| [date] | Root cause identified |
| [date] | Fix implemented |
| [date] | Fix verified |
| [date] | Deployed to production |
```

---

## Next Steps

After completing RCA:

1. Review the document
2. Run `ai-plan` with the fix strategy
3. Or use `ai-hotfix` if urgent
4. After fix, run `ai-evolve` to add the lesson
