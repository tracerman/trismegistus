---
description: Generate proper conventional commit message
---

# Generate Commit Message

## Process

### 1. Analyze Changes

```bash
# See what files changed
git status --porcelain

# See the actual diff
git diff HEAD

# See diff stats
git diff --stat HEAD
```

### 2. Understand the Changes

Categorize what was done:

| Type | Description |
|------|-------------|
| `feat` | New feature for users |
| `fix` | Bug fix for users |
| `refactor` | Code restructure, no behavior change |
| `docs` | Documentation only |
| `test` | Adding or updating tests |
| `chore` | Maintenance, deps, config |
| `style` | Formatting, no code change |
| `perf` | Performance improvement |
| `ci` | CI/CD changes |

### 3. Identify Scope

Scope = the area of codebase affected:

- `api` - API endpoints
- `ui` - User interface
- `db` - Database
- `auth` - Authentication
- `core` - Core business logic
- `config` - Configuration
- `deps` - Dependencies
- Or specific feature name

### 4. Write Message

**Format:**
```
type(scope): short description

[optional body]

[optional footer]
```

**Rules:**
- Subject line: max 50 characters
- Use imperative mood: "add" not "added" or "adds"
- No period at end of subject
- Body: wrap at 72 characters
- Body: explain what and why, not how

**Examples:**

```
feat(api): add habit completion endpoint

Implements POST /api/habits/{id}/complete with:
- Streak calculation
- Duplicate completion prevention
- Response includes updated streak

Closes #123
```

```
fix(ui): resolve calendar not updating on completion

The calendar component wasn't re-rendering after habit
completion due to missing query invalidation.

Added invalidateQueries call after mutation success.
```

```
refactor(db): optimize streak calculation query

Replace N+1 query pattern with single JOIN query.
Reduces database calls from O(n) to O(1).

Performance: 50ms -> 5ms for user with 20 habits
```

```
docs: update API documentation for v2 endpoints
```

```
test(habits): add integration tests for CRUD operations
```

### 5. Stage and Output

```bash
# Stage all changes
git add -A

# Or stage specific files
git add [files]
```

**Output the commit message to:** `.claude/commit_msg.txt`

This file is read by `ai-commit` for automatic committing.

---

## Breaking Changes

If the change breaks backward compatibility:

```
feat(api)!: change habit response format

BREAKING CHANGE: habit.completions is now an array of objects
instead of array of dates. Update client code to use
completion.date instead of direct date access.

Migration guide in docs/migrations/v2.md
```

---

## Multi-Issue Commits

If fixing multiple issues:

```
fix(auth): resolve multiple authentication issues

- Fix token refresh race condition (#101)
- Fix session expiry not clearing storage (#102)
- Fix redirect loop on expired session (#103)

Closes #101, #102, #103
```

---

## Atomic Commits

Prefer small, focused commits over large ones:

**Good:**
```
feat(habits): add habit model
feat(habits): add habit repository
feat(habits): add habit API endpoints
test(habits): add habit integration tests
```

**Avoid:**
```
feat: implement entire habits feature with tests
```

---

## Validation

Before finalizing, verify:

- [ ] Type is correct for the changes
- [ ] Scope accurately reflects affected area
- [ ] Description is clear and concise
- [ ] Body explains context (if needed)
- [ ] Breaking changes are marked with `!`
- [ ] Issue numbers are referenced (if applicable)
