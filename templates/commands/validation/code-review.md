---
description: Critical technical code review focused on bugs and quality
---

# Code Review: Technical Analysis

## Philosophy

**You are a skeptical senior engineer** who has seen every way code can fail in production. Your job is to find real bugs, not nitpick style preferences.

**Focus on:**
- Logic errors that will cause bugs
- Security vulnerabilities
- Performance problems
- Violations of project standards

**Ignore:**
- Minor style preferences (unless they violate CLAUDE.md)
- Subjective "I would do it differently"
- Theoretical issues that won't happen in practice

---

## Phase 1: Gather Context

### Read Project Standards First

```
.tris/CLAUDE.md          # Project rules and conventions
.tris/memory/lessons.md  # Past mistakes to watch for
README.md                  # Project overview
```

### Identify Changes to Review

```bash
# What files changed?
git status
git diff --stat HEAD

# What's the actual diff?
git diff HEAD

# Any new files?
git ls-files --others --exclude-standard
```

---

## Phase 2: Deep Review

### For Each Changed/New File

**Read the ENTIRE file**, not just the diff. Context matters.

Then analyze for:

### 2.1 Logic Errors (CRITICAL)

- [ ] Off-by-one errors in loops/slices
- [ ] Incorrect boolean logic (AND vs OR, negation errors)
- [ ] Wrong comparison operators (< vs <=, == vs ===)
- [ ] Null/undefined/None not handled
- [ ] Async/await mistakes (missing await, unhandled promises)
- [ ] Race conditions in concurrent code
- [ ] Resource leaks (unclosed files, connections, streams)
- [ ] State mutations where immutability expected

### 2.2 Security Issues (CRITICAL)

- [ ] SQL injection (string concatenation in queries)
- [ ] XSS vulnerabilities (unescaped user input in HTML)
- [ ] Command injection (user input in shell commands)
- [ ] Path traversal (user input in file paths)
- [ ] Exposed secrets (API keys, passwords in code)
- [ ] Insecure deserialization
- [ ] Missing authentication/authorization checks
- [ ] CORS misconfiguration
- [ ] Sensitive data in logs

### 2.3 Error Handling

- [ ] Exceptions swallowed silently (empty catch blocks)
- [ ] Generic catches that hide specific errors
- [ ] Missing error handling on I/O operations
- [ ] User-facing error messages that leak internals
- [ ] Missing validation on external input

### 2.4 Performance (If Relevant)

- [ ] N+1 queries (loop inside loop hitting database)
- [ ] Unbounded queries (no LIMIT on potentially large tables)
- [ ] Synchronous I/O blocking async code
- [ ] Unnecessary recomputation (missing memoization)
- [ ] Large objects in memory when streaming possible
- [ ] Missing database indexes for query patterns

### 2.5 Project Standards Violations

Cross-reference with CLAUDE.md:

- [ ] Naming conventions followed?
- [ ] File organization correct?
- [ ] Import ordering correct?
- [ ] Forbidden patterns avoided?
- [ ] Required patterns used (error handling, logging)?
- [ ] Test requirements met?

### 2.6 Past Mistakes (lessons.md)

Check if any patterns from lessons.md are repeated:

- [ ] [Review each lesson and check for violations]

---

## Phase 3: Verify Issues Are Real

Before reporting an issue:

1. **Confirm it's actually wrong** - Read surrounding code
2. **Check if it's intentional** - Look for comments explaining why
3. **Verify the fix is correct** - Don't report without a solution

---

## Phase 4: Generate Report

**Output Path**: `.tris/reviews/[descriptive-name].md`

### Report Format

```markdown
# Code Review: [Brief Description]

**Date**: [timestamp]
**Reviewer**: Claude
**Scope**: [files reviewed]

## Summary

- **Files Reviewed**: X
- **Issues Found**: Y (Z critical)
- **Overall Assessment**: [APPROVE / REQUEST CHANGES / BLOCK]

## Statistics

| Metric | Value |
|--------|-------|
| Files Modified | X |
| Files Added | Y |
| Lines Added | +N |
| Lines Removed | -M |

---

## Issues

### CRITICAL

#### [Issue Title]
- **File**: `path/to/file.py`
- **Line**: 42
- **Type**: [Security | Logic Error | Data Loss]
- **Issue**: [One-line description]
- **Detail**: [Explanation of why this is a problem]
- **Impact**: [What could go wrong]
- **Fix**:
```python
# Before
vulnerable_code()

# After
safe_code()
```

---

### HIGH

#### [Issue Title]
[Same format as above]

---

### MEDIUM

#### [Issue Title]
[Same format as above]

---

### LOW

#### [Issue Title]
[Same format as above]

---

## Positive Notes

[Optional: Call out things done well]

---

## Recommendations

[Optional: Suggestions beyond specific issues]

---

## Verdict

[ ] **APPROVE** - No critical issues, good to merge
[ ] **APPROVE WITH NOTES** - Minor issues, can merge after addressing
[ ] **REQUEST CHANGES** - Issues must be fixed before merge
[ ] **BLOCK** - Critical security/data issues, do not merge
```

---

## If No Issues Found

```markdown
# Code Review: [Brief Description]

**Date**: [timestamp]
**Files Reviewed**: [list]

## Result

✓ **Code review passed.** No technical issues detected.

### Notes
- [Any observations worth mentioning]
- [Suggestions for future improvement]
```

---

## Guidelines

### Be Specific
```
WRONG: "This function has issues"
RIGHT: "Line 42: Missing null check on user.email before calling .toLowerCase()"
```

### Provide Solutions
```
WRONG: "This is vulnerable to SQL injection"
RIGHT: "This is vulnerable to SQL injection. Use parameterized query:
        cursor.execute('SELECT * FROM users WHERE id = ?', (user_id,))"
```

### Prioritize Correctly
```
CRITICAL: Will cause data loss, security breach, or crash
HIGH: Will cause bugs users will hit
MEDIUM: Will cause bugs in edge cases
LOW: Code quality, maintainability
```

### Don't Pile On
If the same mistake is repeated 10 times, mention it once with "Found in X locations: [list]"
