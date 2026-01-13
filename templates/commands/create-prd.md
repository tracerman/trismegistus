---
description: Generate comprehensive Product Requirements Document from conversation
argument-hint: [output-filename]
---

# Create Product Requirements Document

## Output

Write PRD to: `$ARGUMENTS` 

Default: `.tris/active/prd.md`

---

## Process

### 1. Extract Requirements from Context

Review the entire conversation and extract:

- **Explicit requirements** - Things directly stated
- **Implicit needs** - Things implied but not stated
- **Technical constraints** - Platform, performance, security limits
- **User goals** - What success looks like
- **Non-goals** - What we're explicitly not building

### 2. Ask Clarifying Questions

If critical information is missing, ask about:

- Target users and their technical level
- MVP vs full scope boundaries
- Performance requirements
- Security requirements
- Integration requirements
- Timeline constraints

### 3. Generate PRD

Use this structure:

```markdown
# Product Requirements Document: [Project Name]

> [One-sentence elevator pitch]

---

## Executive Summary

[2-3 paragraphs covering:]
- What we're building
- Who it's for
- Core value proposition
- MVP goal

---

## Mission & Principles

**Mission:** [One sentence mission statement]

**Core Principles:**
1. [Principle 1] - [Why it matters]
2. [Principle 2] - [Why it matters]
3. [Principle 3] - [Why it matters]

---

## Target Users

### Primary User Persona

**Name:** [Persona name]
**Role:** [Who they are]
**Technical Level:** [Beginner/Intermediate/Advanced]
**Key Pain Points:**
- [Pain point 1]
- [Pain point 2]

**What They Need:**
- [Need 1]
- [Need 2]

### Secondary Users (if any)

[Same format]

---

## Scope

### MVP (Phase 1) - In Scope ✅

**Core Features:**
- [ ] [Feature 1] - [Brief description]
- [ ] [Feature 2] - [Brief description]
- [ ] [Feature 3] - [Brief description]

**Technical Requirements:**
- [ ] [Tech requirement 1]
- [ ] [Tech requirement 2]

**Integration:**
- [ ] [Integration 1]

**Deployment:**
- [ ] [Deployment requirement]

### Out of Scope ❌

**Deferred to Phase 2:**
- [ ] [Future feature 1]
- [ ] [Future feature 2]

**Not Planned:**
- [Thing explicitly not building]

---

## User Stories

### Epic 1: [Epic Name]

**Story 1.1: [Story Title]**
```
As a [user type]
I want to [action]
So that [benefit]

Acceptance Criteria:
- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]
```

**Story 1.2: [Story Title]**
```
As a [user type]
I want to [action]
So that [benefit]

Acceptance Criteria:
- [ ] [Criterion 1]
- [ ] [Criterion 2]
```

### Epic 2: [Epic Name]

[Same format]

---

## Architecture Overview

### High-Level Architecture

```
[ASCII diagram or description]

┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Client    │────▶│    API      │────▶│  Database   │
└─────────────┘     └─────────────┘     └─────────────┘
```

### Key Components

| Component | Purpose | Technology |
|-----------|---------|------------|
| [Component 1] | [Purpose] | [Tech choice] |
| [Component 2] | [Purpose] | [Tech choice] |

### Directory Structure

```
project/
├── src/
│   ├── api/           # [Purpose]
│   ├── core/          # [Purpose]
│   └── models/        # [Purpose]
├── tests/             # [Purpose]
└── docs/              # [Purpose]
```

---

## Technology Stack

### Backend
- **Language:** [Language] [version]
- **Framework:** [Framework] [version]
- **Database:** [Database]
- **ORM:** [ORM choice]

### Frontend (if applicable)
- **Framework:** [Framework] [version]
- **Styling:** [CSS approach]
- **State Management:** [Solution]

### Infrastructure
- **Hosting:** [Platform]
- **CI/CD:** [Solution]
- **Monitoring:** [Solution]

### Development Tools
- **Linting:** [Tool]
- **Testing:** [Framework]
- **Documentation:** [Tool]

---

## API Specification (if applicable)

### Endpoints Overview

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/resource | List resources |
| POST | /api/resource | Create resource |
| GET | /api/resource/{id} | Get single resource |
| PUT | /api/resource/{id} | Update resource |
| DELETE | /api/resource/{id} | Delete resource |

### Example Payloads

**Create Resource:**
```json
POST /api/resource
{
  "name": "string",
  "value": "number"
}
```

**Response:**
```json
{
  "id": 1,
  "name": "string",
  "value": 123,
  "created_at": "2025-01-15T10:00:00Z"
}
```

---

## Security & Configuration

### Authentication
- [Auth approach]

### Authorization
- [Permission model]

### Security Measures
- [ ] [Security measure 1]
- [ ] [Security measure 2]

### Environment Variables

| Variable | Purpose | Required |
|----------|---------|----------|
| DATABASE_URL | Database connection | Yes |
| SECRET_KEY | Application secret | Yes |
| DEBUG | Debug mode | No |

---

## Success Criteria

### MVP Definition of Done

- [ ] All P0 features implemented and tested
- [ ] All user stories have passing tests
- [ ] API documentation complete
- [ ] Deployment pipeline working
- [ ] Performance benchmarks met
- [ ] Security review passed

### Quality Requirements

- **Test Coverage:** ≥ 80%
- **Response Time:** < 200ms p95
- **Uptime:** 99.9%
- **Accessibility:** WCAG 2.1 AA

### User Experience Goals

- [UX goal 1]
- [UX goal 2]

---

## Implementation Phases

### Phase 1: Foundation (Week 1-2)

**Goal:** Basic infrastructure and core data models

**Deliverables:**
- [ ] Project scaffolding
- [ ] Database models
- [ ] Basic API structure
- [ ] Development environment

**Validation:** Can create and retrieve basic resources

### Phase 2: Core Features (Week 3-4)

**Goal:** Primary user workflows functional

**Deliverables:**
- [ ] [Core feature 1]
- [ ] [Core feature 2]
- [ ] [Core feature 3]

**Validation:** Primary user stories working end-to-end

### Phase 3: Polish & Launch (Week 5-6)

**Goal:** Production-ready release

**Deliverables:**
- [ ] Error handling complete
- [ ] Logging and monitoring
- [ ] Documentation
- [ ] Performance optimization

**Validation:** All acceptance criteria met

---

## Risks & Mitigations

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| [Risk 1] | Medium | High | [Mitigation strategy] |
| [Risk 2] | Low | High | [Mitigation strategy] |
| [Risk 3] | High | Medium | [Mitigation strategy] |

---

## Future Considerations

### Phase 2 Features
- [Feature 1]
- [Feature 2]

### Integration Opportunities
- [Integration 1]
- [Integration 2]

### Scale Considerations
- [Scaling approach]

---

## Open Questions

- [ ] [Question 1]
- [ ] [Question 2]

---

## Appendix

### Related Documents
- [Link to design docs]
- [Link to research]

### Key Dependencies
- [Dependency 1] - [Version] - [Purpose]
- [Dependency 2] - [Version] - [Purpose]

---

## Changelog

| Date | Change | Author |
|------|--------|--------|
| [date] | Initial PRD | [author] |
```

---

## After Creating PRD

1. **Confirm output location**
2. **Summarize key points:**
   - Core features
   - Tech stack
   - Timeline
3. **Flag any assumptions made**
4. **Suggest next steps:**
   - Review PRD
   - Run `ai-launch` or `ai-plan`
