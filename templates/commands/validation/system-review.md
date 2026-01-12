---
description: Meta-analysis of implementation vs plan for process improvement
---

# System Review: Process Improvement Analysis

## Purpose

**This is NOT a code review.** This is a *process* review.

You're analyzing how well the plan-execute cycle worked to identify improvements to the system itself (CLAUDE.md, templates, commands).

**Goal:** Every execution should make the system smarter for next time.

---

## Inputs Required

1. **Plan Document:** `.claude/active/plan.md` or archived plan
2. **Execution Report:** `.claude/reports/[feature]-report.md`
3. **Current Rules:** `.claude/CLAUDE.md`
4. **Current Lessons:** `.claude/memory/lessons.md`

---

## Analysis Process

### Step 1: Read All Artifacts

Read in order:
1. The original plan
2. The execution report
3. CLAUDE.md rules
4. lessons.md memory

### Step 2: Classify Every Divergence

For each divergence noted in the execution report:

| Classification | Meaning | Action |
|----------------|---------|--------|
| **Good Divergence ✓** | Plan was wrong, actual was better | Update planning templates |
| **Bad Divergence ✗** | Plan was right, execution deviated wrongly | Add lesson or rule |
| **Neutral** | Different but neither better nor worse | Note for reference |

**Good Divergence Examples:**
- Plan assumed a file existed that didn't
- Better pattern discovered during implementation
- Performance issue required different approach
- Security concern discovered

**Bad Divergence Examples:**
- Ignored explicit constraints
- Created new patterns instead of following existing
- Took shortcuts that add tech debt
- Misunderstood requirements

### Step 3: Trace Root Causes

For each **bad divergence**, identify why:

| Root Cause | Symptom | Fix |
|------------|---------|-----|
| Plan was unclear | Misinterpretation | Improve plan templates |
| Context was missing | Had to guess | Add mandatory reading |
| Validation was missing | Error caught late | Add validation step |
| Rule wasn't documented | Wrong pattern used | Update CLAUDE.md |
| Lesson wasn't applied | Repeated mistake | Strengthen lesson visibility |

### Step 4: Generate Improvements

Based on patterns, suggest:

1. **CLAUDE.md additions** - New rules to prevent issues
2. **Template updates** - Clearer instructions
3. **New commands** - Automate repeated manual work
4. **Lesson additions** - Capture new knowledge

---

## Output Report

**Path:** `.claude/reviews/system-review-[date].md`

### Template

```markdown
# System Review: [Feature Name]

**Date:** [timestamp]
**Plan Reviewed:** [path]
**Execution Report:** [path]

---

## Overall Alignment Score: X/10

| Score | Meaning |
|-------|---------|
| 9-10 | Perfect adherence, all divergences justified |
| 7-8 | Minor justified divergences |
| 5-6 | Mix of justified and problematic |
| 3-4 | Significant problematic divergences |
| 1-2 | Major failures in process |

---

## Divergence Analysis

### Divergence 1: [Title]

```yaml
planned: [What plan specified]
actual: [What was implemented]
classification: Good ✓ | Bad ✗ | Neutral
reason_given: [From execution report]
root_cause: [Your analysis]
justified: Yes | No
```

**Action Required:**
- [ ] [Specific action to take]

### Divergence 2: [Title]
[Same format]

---

## Pattern Compliance

| Pattern | Status | Notes |
|---------|--------|-------|
| Followed codebase architecture | ✓/✗ | |
| Used documented patterns | ✓/✗ | |
| Applied testing patterns | ✓/✗ | |
| Met validation requirements | ✓/✗ | |
| Followed CLAUDE.md rules | ✓/✗ | |
| Avoided lessons.md mistakes | ✓/✗ | |

---

## System Improvements

### Update CLAUDE.md

Add these rules:

```markdown
## [Section]
- [New rule based on this review]
```

**Rationale:** [Why this rule is needed]

### Update Plan Template

Add to `commands/core/plan-feature.md`:

```markdown
[New instruction or checklist item]
```

**Rationale:** [What problem this prevents]

### Update Execute Template

Add to `commands/core/execute.md`:

```markdown
[New instruction or validation step]
```

**Rationale:** [What problem this prevents]

### Add New Lesson

Add to `memory/lessons.md`:

```markdown
- [DATE] LESSON: [Specific lesson from this review]
```

### Create New Command (if applicable)

If a manual process was repeated, consider creating:

```markdown
Command: `/[command-name]`
Purpose: [What it automates]
Template: [Brief description of what it should do]
```

---

## Key Learnings

### What the System Did Well
- [Specific strength]
- [Specific strength]

### What the System Needs
- [Specific gap]
- [Specific gap]

### Recommendations for Next Implementation
1. [Specific recommendation]
2. [Specific recommendation]

---

## Action Items

Priority actions from this review:

- [ ] **HIGH:** [Action item]
- [ ] **MEDIUM:** [Action item]
- [ ] **LOW:** [Action item]

---

## Metrics (Optional)

If tracking over time:

| Metric | This Run | Average | Trend |
|--------|----------|---------|-------|
| Plan accuracy | X% | Y% | ↑/↓/→ |
| Divergence count | N | M | ↑/↓/→ |
| Good:Bad ratio | X:Y | A:B | ↑/↓/→ |
```

---

## After System Review

1. **Apply CLAUDE.md updates** immediately
2. **Update templates** if warranted
3. **Add lessons** to lessons.md
4. **Create new commands** if patterns emerged
5. **Run `ai-optimize`** periodically for deeper rule refinement
