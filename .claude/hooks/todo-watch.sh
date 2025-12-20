#!/bin/bash
# todo-watch.sh - Forward TodoWrite updates to cc-notify dashboard
# Hook type: PostToolUse (TodoWrite)

CC_NOTIFY_BIN="${HOME}/.config/cc-notify/cc-notify"

# Read input from stdin
INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')

# Only process TodoWrite tool
if [ "$TOOL_NAME" != "TodoWrite" ]; then
    exit 0
fi

# Extract todos array from tool_input
TODOS=$(echo "$INPUT" | jq -c '.tool_input.todos // []')

if [ -z "$TODOS" ] || [ "$TODOS" = "[]" ] || [ "$TODOS" = "null" ]; then
    exit 0
fi

# Build the payload matching EventPayload::TodoList
PAYLOAD=$(jq -n --argjson todos "$TODOS" '{
    "type": "todo_list",
    "todos": $todos
}')

# Count stats for message
TOTAL=$(echo "$TODOS" | jq 'length')
COMPLETED=$(echo "$TODOS" | jq '[.[] | select(.status == "completed")] | length')
IN_PROGRESS=$(echo "$TODOS" | jq '[.[] | select(.status == "in_progress")] | length')

MESSAGE="Tasks: $COMPLETED/$TOTAL complete"
if [ "$IN_PROGRESS" -gt 0 ]; then
    CURRENT=$(echo "$TODOS" | jq -r '[.[] | select(.status == "in_progress")][0].activeForm // empty')
    [ -n "$CURRENT" ] && MESSAGE="$MESSAGE - $CURRENT"
fi

# Send to cc-notify (fire and forget)
"$CC_NOTIFY_BIN" send -t todo_update --payload "$PAYLOAD" "$MESSAGE" &>/dev/null &
