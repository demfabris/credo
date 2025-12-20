#!/bin/bash
# tool-activity.sh - Track tool lifecycle for activity indicator
# Hook type: PreToolUse and PostToolUse

CC_NOTIFY_BIN="${HOME}/.config/cc-notify/cc-notify"

# Read input from stdin
INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')

# Session identification - use working directory basename as human-readable name
SESSION_NAME=$(basename "$PWD")

# Only track specific tools
case "$TOOL_NAME" in
    Read|Edit|Write|Bash|Grep|Glob|WebFetch|WebSearch|Task)
        ;;
    *)
        exit 0  # Skip other tools
        ;;
esac

# Determine phase from hook type env var (set by Claude)
# PreToolUse = start, PostToolUse = end
HOOK_TYPE="${CLAUDE_HOOK_TYPE:-PostToolUse}"
if [ "$HOOK_TYPE" = "PreToolUse" ]; then
    PHASE="start"
else
    PHASE="end"
fi

# Extract detail based on tool type
case "$TOOL_NAME" in
    Read|Edit|Write)
        DETAIL=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
        # Shorten to just filename
        [ -n "$DETAIL" ] && DETAIL=$(basename "$DETAIL")
        ;;
    Bash)
        DETAIL=$(echo "$INPUT" | jq -r '.tool_input.command // empty' | head -c 40)
        ;;
    Grep)
        DETAIL=$(echo "$INPUT" | jq -r '.tool_input.pattern // empty' | head -c 30)
        ;;
    Glob)
        DETAIL=$(echo "$INPUT" | jq -r '.tool_input.pattern // empty')
        ;;
    Task)
        DETAIL=$(echo "$INPUT" | jq -r '.tool_input.description // empty' | head -c 40)
        ;;
    WebFetch|WebSearch)
        DETAIL=$(echo "$INPUT" | jq -r '.tool_input.query // .tool_input.url // empty' | head -c 40)
        ;;
    *)
        DETAIL=""
        ;;
esac

# Build payload with session info
PAYLOAD=$(jq -n \
    --arg tool "$TOOL_NAME" \
    --arg phase "$PHASE" \
    --arg detail "$DETAIL" \
    --arg session "$SESSION_NAME" \
    '{
        "type": "tool_activity",
        "tool_name": $tool,
        "phase": $phase,
        "detail": (if $detail == "" then null else $detail end),
        "session_name": $session
    }')

# Human-readable message
if [ -n "$DETAIL" ]; then
    MESSAGE="$TOOL_NAME: $DETAIL"
else
    MESSAGE="$TOOL_NAME"
fi

# Send to cc-notify (fire and forget, non-blocking)
"$CC_NOTIFY_BIN" send -t tool_activity -s "$SESSION_NAME" --payload "$PAYLOAD" "$MESSAGE" &>/dev/null &
