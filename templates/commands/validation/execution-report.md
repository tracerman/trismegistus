---
description: Generate implementation report after completing execution
---

# Execution Report

## Purpose

Document what was actually implemented vs what was planned, capture lessons learned, and provide data for system improvement.

---

## Context

**Plan File:** `.claude/active/plan.md`
**Progress File:** `.claude/active/progress.txt` (if exists)

---

## Generate Report

**Output Path:** `.claude/reports/[feature-name]-[date].md`

### Report Template

```markdown
# Execution Report: [Feature Name]

**Date:** [timestamp]
**Plan:** [path to plan file]
**Duration:** [estimated time spent]

---

## Summary

| Metric | Value |
|--------|-------|
| Steps Planned | X |
| Steps Completed | Y |
| Steps Skipped | Z |
| Files Created | N |
| Files Modified | M |
| Tests Added | T |
| Lines Changed | +A / -B |

**Overall Status:** [Complete | Partial | Failed]

---

## What Was Built

### Files Created
| File | Purpose |
|------|---------|
| `path/to/file1.py` | [Brief purpose] |
| `path/to/file2.py` | [Brief purpose] |

### Files Modified
| File | Changes |
|------|---------|
| `path/to/existing.py` | [What was changed] |

### Tests Added
| Test File | Coverage |
|-----------|----------|
| `tests/test_feature.py` | [What it tests] |

---

## Validation Results

| Check | Status | Notes |
|-------|--------|-------|
| Linting | ✓/✗ | [details] |
| Type Check | ✓/✗ | [details] |
| Unit Tests | ✓/✗ | X/Y passed |
| Integration | ✓/✗ | X/Y passed |
| Manual Test | ✓/✗ | [details] |

---

## Plan Adherence

### Followed As Planned
- [Step/aspect that went according to plan]
- [Step/aspect that went according to plan]

### Divergences

#### Divergence 1: [Title]
- **Planned:** [What the plan said]
- **Actual:** [What was actually done]
- **Reason:** [Why the change was made]
- **Classification:** [Good divergence ✓ | Bad divergence ✗]
- **Justified:** [Yes/No with explanation]

#### Divergence 2: [Title]
[Same format]

### Skipped Items
| Item | Reason |
|------|--------|
| [What was skipped] | [Why it was skipped] |

---

## Challenges Encountered

### Challenge 1: [Title]
- **What happened:** [Description]
- **Root cause:** [Why it happened]
- **Resolution:** [How it was fixed]
- **Time impact:** [How much time was lost]

### Challenge 2: [Title]
[Same format]

---

## Lessons Learned

### For lessons.md

These should be added to `.claude/memory/lessons.md`:

```
- [DATE] LESSON: [Specific, actionable lesson 1]
- [DATE] LESSON: [Specific, actionable lesson 2]
```

### For CLAUDE.md

Consider adding these rules:

```
- [New rule based on challenges]
```

### For Future Plans

- [Recommendation for how to improve planning]
- [Information that should be gathered earlier]

---

## Quality Assessment

### What Went Well
- [Specific positive aspect]
- [Specific positive aspect]

### What Could Improve
- [Specific improvement area]
- [Specific improvement area]

### Code Quality Self-Check
- [ ] Follows project conventions
- [ ] Proper error handling
- [ ] Appropriate logging
- [ ] Tests are meaningful
- [ ] No obvious tech debt introduced

---

## Handoff Notes

**For code reviewer:**
- [Key area to focus review]
- [Specific concern to validate]

**For future maintainer:**
- [Important context about implementation]
- [Known limitations]

---

## Next Steps

- [ ] Run `ai-commit` to commit changes
- [ ] Review code with `ai-verify` or manual review
- [ ] Run `ai-finish` to archive and extract lessons
- [ ] Update documentation if needed
```

---

## After Generating Report

1. **Review the report** for accuracy
2. **Add lessons** to lessons.md via `ai-evolve` or `ai-finish`
3. **Consider CLAUDE.md updates** if new patterns emerged
4. **Proceed to commit** when satisfied
