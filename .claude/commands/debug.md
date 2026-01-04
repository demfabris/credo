---
description: Debug issues by investigating logs, state, and git history
model: opus
---

# Debug

Help debug issues during development. This is a read-only investigation tool.

## Initial Response

```
I'll help debug your current issue.

Please describe what's going wrong:
- What are you working on?
- What specific problem occurred?
- When did it last work?

I can investigate logs, state, and recent changes to help identify the issue.
```

## Process

### Step 1: Understand the Problem

1. **Read any provided context** (plan or ticket file)
2. **Quick state check**:
   - Current git branch and recent commits
   - Any uncommitted changes
   - When the issue started

### Step 2: Investigate (spawn parallel tasks)

**Task 1 - Check Logs:**

- Find and analyze recent logs for errors
- Look for stack traces or repeated errors
- Return: Key errors/warnings with timestamps

**Task 2 - Check State:**

- Verify expected files exist
- Check any database/config state
- Look for stuck states or anomalies

**Task 3 - Git and File State:**

- `git status` and current branch
- Recent commits: `git log --oneline -10`
- Uncommitted changes: `git diff`
- File permission issues

### Step 3: Present Findings

````markdown
## Debug Report

### What's Wrong

[Clear statement based on evidence]

### Evidence Found

**From Logs**:

- [Error/warning with timestamp]
- [Pattern or repeated issue]

**From Git/Files**:

- [Recent changes that might be related]
- [File state issues]

### Root Cause

[Most likely explanation based on evidence]

### Next Steps

1. **Try This First**:
   ```bash
   [Specific command or action]
   ```
````

2. **If That Doesn't Work**:
   - [Alternative approach]
   - [Debug flag to try]

Would you like me to investigate something specific further?

````

## Quick Reference

**Git State**:
```bash
git status
git log --oneline -10
git diff
````

**Rust Checks**:

```bash
cargo check 2>&1 | head -50
cargo test 2>&1 | tail -30
```

Remember: This command helps investigate without burning context. Pure investigation only.
