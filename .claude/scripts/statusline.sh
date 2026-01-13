#!/usr/bin/env bash
# Claude Code Status Line
set -euo pipefail

# Read JSON input from stdin
input=$(cat)

# Extract data from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')
output_style=$(echo "$input" | jq -r '.output_style.name')

# Get git info (skip optional locks for performance)
git_info=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(git -C "$cwd" branch --show-current 2>/dev/null || echo "detached")
    # Check for changes
    if ! git -C "$cwd" diff --quiet 2>/dev/null || ! git -C "$cwd" diff --cached --quiet 2>/dev/null; then
        git_info=" on $(printf '\033[33m')$branch$(printf '\033[0m')$(printf '\033[31m') ✗$(printf '\033[0m')"
    else
        git_info=" on $(printf '\033[32m')$branch$(printf '\033[0m')"
    fi
fi

git_untracked=""
git_modified=""
git_added=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
    git_modified="$(printf '\033[31m')$(git status --porcelain | grep -o M  | wc -l | sed 's/^[[:space:]]*//')M$(printf '\033[0m')"
    git_untracked="$(printf '\033[33m')$(git status --porcelain | grep -o ? | wc -l | sed 's/^[[:space:]]*//')U$(printf '\033[0m')"
    git_added="$(printf '\033[32m')$(git status --porcelain | grep -o A  | wc -l | sed 's/^[[:space:]]*//')A$(printf '\033[0m')"
fi


# Calculate context window usage (v2.1.6+ provides used_percentage directly)
context_info=""
pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$pct" ]; then
    # Truncate to integer
    pct=${pct%.*}

    # Color code based on usage
    if [ "$pct" -lt 50 ]; then
        color=$(printf '\033[32m')  # green
    elif [ "$pct" -lt 80 ]; then
        color=$(printf '\033[33m')  # yellow
    else
        color=$(printf '\033[31m')  # red
    fi
    context_info=" | ${color}${pct}%$(printf '\033[0m') ctx"
fi

# Build the status line
# Format: ~/path/to/dir on branch | model | style | 45% ctx
short_cwd="${cwd/#$HOME/~}"
printf "$(printf '\033[36m')%s$(printf '\033[0m')%s | %s | %s%s | %s %s %s\n" \
    "$short_cwd" \
    "$git_info" \
    "$model" \
    "$output_style" \
    "$context_info" \
    "$git_modified" \
    "$git_untracked" \
    "$git_added"
