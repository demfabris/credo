#!/bin/bash
# cc-notify hook for Claude Code
# Sends notifications via Telegram when Claude needs attention

INPUT=$(cat)

NOTIFICATION_TYPE=$(echo "$INPUT" | jq -r '.notification_type // ""')
TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript_path // ""')
CWD=$(echo "$INPUT" | jq -r '.cwd // ""')

# Extract project name from cwd
PROJECT=$(basename "$CWD" 2>/dev/null || echo "unknown")

# Get last assistant message from transcript for context
get_context() {
    if [[ -n "$TRANSCRIPT" && -f "$TRANSCRIPT" ]]; then
        # Get last assistant message (grep for assistant role, take last, extract text)
        tail -20 "$TRANSCRIPT" 2>/dev/null | \
            jq -r 'select(.type == "assistant") | .message.content[]? | select(.type == "text") | .text' 2>/dev/null | \
            tail -1 | \
            head -c 200  # Limit length
    fi
}

case "$NOTIFICATION_TYPE" in
    idle_prompt)
        CONTEXT=$(get_context)
        if [[ -n "$CONTEXT" ]]; then
            MSG="[$PROJECT] Claude waiting:\n${CONTEXT}..."
        else
            MSG="[$PROJECT] Claude is waiting for your input"
        fi
        ~/.config/cc-notify/cc-notify send -t question "$MSG" &
        ;;
    permission_prompt)
        # For permissions, include what tool is being requested
        TOOL_MSG=$(echo "$INPUT" | jq -r '.message // "permission needed"')
        MSG="[$PROJECT] $TOOL_MSG"
        ~/.config/cc-notify/cc-notify send -t approval "$MSG" &
        ;;
esac

exit 0
