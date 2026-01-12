---
description: "Create comprehensive feature plan with deep codebase analysis"
---

# Plan Feature Implementation

## Feature: $ARGUMENTS

## Mission

Transform a feature request into a **comprehensive implementation plan** through systematic codebase analysis and strategic planning.

**Core Principle**: We do NOT write code in this phase. Our goal is to create a context-rich implementation plan that enables one-pass implementation success.

**Key Philosophy**: Context is King. The plan must contain ALL information needed for implementation—patterns, mandatory reading, documentation, validation commands—so the execution agent succeeds on the first attempt.

---

## Phase 1: Feature Understanding

### Deep Feature Analysis

Before anything else:

1. **Extract Core Problem**: What user problem does this solve?
2. **Identify Value**: Why does this matter?
3. **Classify Type**: New Capability | Enhancement | Refactor | Bug Fix
4. **Assess Complexity**: Low (< 3 files) | Medium (3-10 files) | High (10+ files)
5. **Map Blast Radius**: What systems/components are affected?

### Create User Story

```
As a [type of user]
I want to [action/goal]
So that [benefit/value]
```

### Clarify Ambiguities

**STOP HERE if requirements are unclear.**

Ask the user:
- What is the expected behavior in edge cases?
- Are there performance requirements?
- Are there specific UI/UX expectations?
- What's the priority vs other work?

---

## Phase 2: Codebase Intelligence Gathering

### 2.1 Project Structure Analysis

- Detect primary language(s), frameworks, runtime versions
- Map directory structure and architectural patterns
- Identify service/component boundaries
- Locate configuration files
- Understand build/dev processes

### 2.2 Pattern Recognition

**Critical: Read `.claude/CLAUDE.md` first for project-specific rules.**

Then identify:
- Naming conventions (files, functions, variables, components)
- File organization patterns
- Error handling approaches
- Logging patterns
- Import ordering conventions
- Test organization

**Document these patterns explicitly—the execution agent must match them exactly.**

### 2.3 Existing Code Analysis

Search the codebase for:
- Similar implementations to reference
- Related utilities that should be reused (NOT recreated)
- Anti-patterns to avoid (from `lessons.md`)
- Integration points (routers, registries, configs)

### 2.4 Dependency Analysis

- What external libraries are relevant?
- How are they configured/integrated?
- Are there version constraints?
- Check `ai_docs/`, `docs/`, or `.claude/reference/` for internal documentation

---

## Phase 3: External Research (If Needed)

Only if the feature involves unfamiliar technology:

1. Research latest best practices (2024-2025)
2. Find official documentation with specific section anchors
3. Identify common gotchas
4. Check for breaking changes in dependencies

**Compile research references with URLs and specific sections.**

---

## Phase 4: Strategic Design

### Think Deeply About

- How does this fit into existing architecture?
- What's the critical path? What must be built first?
- What could go wrong? (Edge cases, race conditions, errors)
- What are the security implications?
- How will this be tested?
- Is this maintainable? Extensible?

### Design Decisions

Document any choices made:
- Why approach A over approach B?
- What trade-offs are we accepting?
- What's deferred to future work?

---

## Phase 5: Plan Output

**Output Path**: `.claude/active/plan.md`

### Required Plan Structure

```markdown
# Feature: [Feature Name]

## Overview
[2-3 sentence summary of what we're building and why]

## User Story
As a [user], I want to [action], so that [benefit].

## Metadata
- **Type**: [New Capability | Enhancement | Refactor | Bug Fix]
- **Complexity**: [Low | Medium | High]
- **Affected Systems**: [List]
- **Dependencies**: [External libs or services]

---

## MANDATORY READING

**Read these files BEFORE implementing:**

- `path/to/file.py` (lines X-Y) — Why: [relevance]
- `path/to/pattern.ts` — Why: [shows pattern to follow]
- `path/to/test.py` — Why: [test pattern example]

**External Documentation:**
- [Link to docs](url#section) — Why: [relevance]

---

## PATTERNS TO FOLLOW

### Naming Conventions
[Specific patterns from this codebase]

### File Organization
[Where new files should go and why]

### Error Handling
[How errors are handled in this codebase]

### Logging
[Logging patterns to follow]

---

## IMPLEMENTATION STEPS

Execute in order. Each step is atomic.

### Step 1: [Action] `path/to/file`

**What**: [Specific implementation detail]
**Pattern**: Reference `path/to/similar:lines` for structure
**Imports**: [Required imports]
**Gotcha**: [Known issues to avoid]
**Validate**: `[executable command to verify]`

### Step 2: [Action] `path/to/file`
...

[Continue for all steps]

---

## TESTING REQUIREMENTS

### Unit Tests
- [ ] Test case 1: [description]
- [ ] Test case 2: [description]

### Integration Tests
- [ ] Test case 1: [description]

### Edge Cases
- [ ] [Edge case 1]
- [ ] [Edge case 2]

---

## VALIDATION COMMANDS

Run these in order after implementation:

```bash
# Linting
[project-specific lint command]

# Type checking (if applicable)
[project-specific type check command]

# Unit tests
[project-specific test command]

# Integration tests
[project-specific integration test command]

# Manual smoke test
[curl command or manual steps]
```

---

## ACCEPTANCE CRITERIA

- [ ] All implementation steps completed
- [ ] All validation commands pass
- [ ] Tests cover happy path and edge cases
- [ ] Code follows project conventions
- [ ] No regressions in existing functionality
- [ ] Documentation updated (if user-facing)

---

## RISKS & MITIGATIONS

| Risk | Mitigation |
|------|------------|
| [Risk 1] | [How to handle] |
| [Risk 2] | [How to handle] |

---

## NOTES

[Any additional context, decisions made, or future considerations]
```

---

## Quality Checklist

Before saving the plan, verify:

- [ ] All patterns explicitly documented (not assumed)
- [ ] Every step has a validation command
- [ ] Mandatory reading files actually exist
- [ ] Steps are in correct dependency order
- [ ] No hallucinated imports or functions
- [ ] Risks identified and addressed
- [ ] Someone unfamiliar with codebase could execute this

---

## Output Confirmation

After creating the plan:
1. Confirm file saved to `.claude/active/plan.md`
2. State confidence level (1-10) for one-pass execution success
3. Flag any areas of uncertainty for user review
