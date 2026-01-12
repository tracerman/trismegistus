---
description: Run comprehensive project validation with auto-detection
---

# Validate: Comprehensive Project Check

## Objective

Run all validation checks for the project to ensure code quality, test coverage, and build integrity.

---

## Phase 1: Detect Project Type

First, identify the project configuration:

### Check for Configuration Files

```bash
# List configuration files
ls -la *.json *.toml *.yaml *.yml pyproject.toml package.json Cargo.toml go.mod 2>/dev/null
```

### Identify Stack

| File Found | Stack | Package Manager |
|------------|-------|-----------------|
| `package.json` | Node.js/JavaScript | npm/yarn/pnpm |
| `pyproject.toml` | Python (modern) | uv/pip/poetry |
| `requirements.txt` | Python (legacy) | pip |
| `go.mod` | Go | go mod |
| `Cargo.toml` | Rust | cargo |
| `pom.xml` | Java | maven |
| `build.gradle` | Java/Kotlin | gradle |

---

## Phase 2: Run Validation Commands

Based on detected stack, execute appropriate commands.

### For Python Projects

**1. Linting (Ruff or Flake8):**
```bash
# If using ruff (preferred)
ruff check .

# Or if using flake8
flake8 .

# Or via uv
uv run ruff check .
```

**2. Type Checking (if configured):**
```bash
# MyPy
mypy .

# Or Pyright
pyright

# Via uv
uv run mypy .
```

**3. Unit Tests:**
```bash
# Pytest
pytest -v

# With coverage
pytest --cov=src --cov-report=term-missing

# Via uv
uv run pytest -v
```

**4. Integration Tests (if separate):**
```bash
pytest tests/integration -v
```

### For Node.js/TypeScript Projects

**1. Linting:**
```bash
npm run lint
# or
npx eslint .
```

**2. Type Checking (TypeScript):**
```bash
npx tsc --noEmit
```

**3. Unit Tests:**
```bash
npm test
# or
npx vitest run
# or
npx jest
```

**4. Build:**
```bash
npm run build
```

### For Go Projects

**1. Formatting Check:**
```bash
gofmt -l .
```

**2. Linting:**
```bash
golangci-lint run
```

**3. Tests:**
```bash
go test ./...
```

**4. Build:**
```bash
go build ./...
```

### For Rust Projects

**1. Formatting Check:**
```bash
cargo fmt -- --check
```

**2. Linting:**
```bash
cargo clippy
```

**3. Tests:**
```bash
cargo test
```

**4. Build:**
```bash
cargo build
```

---

## Phase 3: Check Project-Specific Scripts

Read `package.json` or `pyproject.toml` for custom scripts:

```bash
# Node.js - check available scripts
cat package.json | grep -A 20 '"scripts"'

# Python - check available scripts
cat pyproject.toml | grep -A 20 '\[tool.poetry.scripts\]'
cat pyproject.toml | grep -A 20 '\[project.scripts\]'
```

Run relevant validation scripts:
- `npm run lint` / `npm run test` / `npm run build`
- `uv run ruff` / `uv run pytest` / etc.

---

## Phase 4: API/Server Validation (If Applicable)

### Check if Server is Running

```bash
# Common ports
curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/health
curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/health
curl -s -o /dev/null -w "%{http_code}" http://localhost:5000/health
```

### Test Key Endpoints

If API server is running:

```bash
# Health check
curl http://localhost:8000/health

# API docs (FastAPI/Swagger)
curl -s -o /dev/null -w "Docs: %{http_code}\n" http://localhost:8000/docs

# Basic endpoint test
curl http://localhost:8000/api/[resource]
```

---

## Phase 5: Generate Report

### Summary Format

```
=== VALIDATION REPORT ===

Project: [name from package.json/pyproject.toml]
Stack: [detected stack]
Date: [timestamp]

RESULTS:
-----------------------------------------
| Check              | Status | Details |
-----------------------------------------
| Linting            | ✓/✗    | [info]  |
| Type Checking      | ✓/✗/⊘  | [info]  |
| Unit Tests         | ✓/✗    | X pass  |
| Integration Tests  | ✓/✗/⊘  | Y pass  |
| Build              | ✓/✗    | [info]  |
| Server Health      | ✓/✗/⊘  | [info]  |
-----------------------------------------

Legend: ✓ Pass | ✗ Fail | ⊘ Not Applicable

COVERAGE (if available):
- Total: XX%
- [module]: XX%

ISSUES FOUND:
1. [Issue description and location]
2. [Issue description and location]

OVERALL STATUS: [PASS / FAIL]

NEXT STEPS:
- [If PASS]: Ready for commit
- [If FAIL]: Fix issues listed above
```

---

## Phase 6: Recommendations

Based on results:

### If All Checks Pass
```
✓ All validations passed
✓ Ready for commit: run 'ai-commit'
```

### If Checks Fail
```
✗ Validation failed

Fix Priority:
1. [Critical] Syntax/build errors - code won't run
2. [High] Test failures - functionality broken
3. [Medium] Type errors - potential runtime issues
4. [Low] Lint warnings - code quality

Recommended commands:
- [specific fix commands]
```

---

## Notes

- **Missing Tools**: If a tool isn't installed, note it and continue
- **CI Parity**: These checks should match what CI runs
- **Custom Scripts**: Always check for project-specific validation scripts
- **Coverage Thresholds**: Check pyproject.toml/package.json for required coverage
