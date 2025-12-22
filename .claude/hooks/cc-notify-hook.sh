#!/bin/bash
# cc-notify hook for Claude Code
#
# Install:
#   mkdir -p ~/.claude/hooks
#   cp examples/cc-notify-hook.sh ~/.claude/hooks/
#   chmod +x ~/.claude/hooks/cc-notify-hook.sh
#
# Add to ~/.claude/settings.json:
#   {
#     "hooks": {
#       "SessionStart": [{ "command": "~/.claude/hooks/cc-notify-hook.sh" }],
#       "SessionEnd": [{ "command": "~/.claude/hooks/cc-notify-hook.sh" }]
#     }
#   }

# Debug mode - uncomment to enable
# set -x

HOOK_EVENT="${CLAUDE_HOOK_EVENT:-}"
SESSION_ID="${CLAUDE_SESSION_ID:-}"
PROJECT="${CLAUDE_CWD:-$(pwd)}"

# Path to cc-notify binary - use full path since hooks don't have user's PATH
CC_NOTIFY="${CC_NOTIFY_BIN:-$HOME/.cargo/bin/cc-notify}"

case "$HOOK_EVENT" in
    SessionStart)
        # Subscribe this session to the broker
        # The daemon will start watching the JSONL file for stats
        "$CC_NOTIFY" subscribe "$SESSION_ID" --project "$PROJECT" 2>/tmp/cc-notify-hook.log &
        ;;
    SessionEnd)
        # Unsubscribe this session (mark as ended)
        # Session stays visible for 5 minutes with "ended" status
        "$CC_NOTIFY" unsubscribe "$SESSION_ID" 2>/tmp/cc-notify-hook.log &
        ;;
esac

# Exit immediately - don't block Claude
exit 0
