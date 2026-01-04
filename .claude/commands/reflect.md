---
description: Review session patterns and propose improvements to CLAUDE.md or new skills
model: opus
---

# Reflect

Meta-agent for continuous improvement. Analyzes past session patterns and proposes enhancements to CLAUDE.md, new skills, hooks, etc.

## Initial Response

```
Initiating reflection mode...

I'll analyze recent session data to identify:
- Repetitive tool patterns that could be automated
- Inefficient workflows that could be improved
- Potential new skills or CLAUDE.md additions

Let me check what observations have been collected.
```

## Process

### Step 1: Load Observations

Read the pending observations and analyzed patterns:

```bash
# Check what's been collected
PENDING="$HOME/.claude/reflections/pending.jsonl"
ANALYZED="$HOME/.claude/reflections/analyzed.jsonl"

if [[ -f "$PENDING" ]]; then
    echo "=== Pending Observations ==="
    cat "$PENDING" | jq -s '.' | head -100
fi

if [[ -f "$ANALYZED" ]]; then
    echo "=== Analyzed Patterns ==="
    cat "$ANALYZED" | jq -s '.' | head -100
fi
```

### Step 2: Pattern Analysis

For each session observation, identify:

1. **Tool Sequence Patterns**
   - Repeated sequences (e.g., `Grep → Read → Edit` happening 3+ times)
   - Search-heavy sessions (lots of Glob/Grep before finding the right file)
   - Retry patterns (same tool called multiple times with slight variations)

2. **Workflow Candidates**
   - Multi-step sequences that could become a skill
   - Common file patterns that could be pre-indexed
   - Frequently used tool combinations

3. **CLAUDE.md Improvements**
   - Project-specific patterns worth documenting
   - Common mistakes to avoid, (DO's and DON'Ts)
   - Shortcuts or aliases that would help

4. **Considering Mistakes**
   - The user pointed a issue in the implementation, how can we avoid it in the future?
   - A implementation caused another part of code to fail, reflect.

**IMPORTANT**: Be a bit reluctant, think if this is really a worth addition, we should keep context lean.

### Step 3: Generate Proposals

For each identified pattern, create a proposal:

````markdown
## Reflection Report

### Patterns Detected

**Pattern 1: [Name]**

- Frequency: X sessions
- Sequence: [Tool1] → [Tool2] → [Tool3]
- Issue: [What's inefficient about this]

**Pattern 2: [Name]**
...

### Proposed Improvements

#### CLAUDE.md Additions

```markdown
## [Section Name]

[Proposed addition to CLAUDE.md]
```

#### Potential New Skills

**Skill: /[skill-name]**

- Purpose: [What it automates]
- Trigger: [When to use it]
- Draft location: `~/.claude/skill-drafts/[skill-name].md`

### Actions

1. [ ] Apply CLAUDE.md patch
2. [ ] Create skill draft
3. [ ] Dismiss (false positive)
4. [ ] Defer for later
````

### Step 4: Interactive Review

Present each proposal and ask:

```
For each proposal, I'll ask:
1. Should I apply this to CLAUDE.md?
2. Should I create a skill draft?
3. Should I dismiss this observation?

After review, I'll clear processed observations from pending.
```

### Step 5: Apply Changes

For approved changes:

**CLAUDE.md patches:**

```bash
# Read current CLAUDE.md
CLAUDE_MD="$CLAUDE_PROJECT_DIR/CLAUDE.md"
# Or fallback to home
[[ ! -f "$CLAUDE_MD" ]] && CLAUDE_MD="$HOME/CLAUDE.md"

# Apply the approved additions (via Edit tool)
```

**Skill drafts:**

```bash
# Write to skill-drafts directory
SKILL_FILE="$HOME/.claude/skill-drafts/[skill-name].md"
```

**Clear processed:**

```bash
# Archive processed observations
mv "$HOME/.claude/reflections/pending.jsonl" \
   "$HOME/.claude/reflections/archive/$(date +%Y%m%d-%H%M%S).jsonl"
```

## Pattern Detection Heuristics

### High-Signal Patterns

1. **Search Spiral**: `Grep` → `Grep` → `Grep` (different patterns, same intent)
   - Suggests: Need better search strategy in CLAUDE.md

2. **Read-Edit Loop**: `Read` → `Edit` (fail) → `Read` → `Edit` (fail) → ...
   - Suggests: File structure docs needed

3. **Tool Retry**: Same tool, same file, slight input variation
   - Suggests: Missing context about file format/structure

4. **Exploration Burst**: 5+ `Glob`/`Grep` calls before first `Edit`
   - Suggests: Could benefit from codebase-locator skill usage

5. **Multi-File Workflow**: Consistent sequence across 3+ files
   - Suggests: Skill candidate

### Low-Signal (Ignore)

- Single-use patterns
- Legitimate exploration (new codebase)
- User-directed search variations

## Example Output

````markdown
## Reflection Report - 2025-01-04

### Detected Pattern: Config File Hunt

**Frequency**: 4 sessions
**Sequence**: `Glob(**/*.json)` → `Read` → `Grep(config)` → `Read` (different file)

**Issue**: Repeatedly searching for config files in this project.

### Proposed CLAUDE.md Addition

```markdown
## Project Config Files

- Main config: `src/config/index.ts`
- Environment: `.env.local` (not committed)
- Build config: `next.config.js`
```
````

Remember: The goal is continuous improvement. Small, targeted additions compound over time.
