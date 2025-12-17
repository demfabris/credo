#!/bin/bash
# cc-notify Stop hook - notifies when Claude finishes responding

INPUT=$(cat)

CWD=$(echo "$INPUT" | jq -r '.cwd // ""')
PROJECT=$(basename "$CWD" 2>/dev/null || echo "project")
STOP_REASON=$(echo "$INPUT" | jq -r '.stop_hook_reason // "done"')

# Only notify on meaningful stops (not every single response)
case "$STOP_REASON" in
    end_turn|tool_use)
        # These are normal stops, maybe skip notification
        # Uncomment below if you want all notifications:
        # ~/.config/cc-notify/cc-notify send -t complete "[$PROJECT] Claude done" &
        ;;
    *)
        ~/.config/cc-notify/cc-notify send -t complete "[$PROJECT] Claude finished" &
        ;;
esac

exit 0
