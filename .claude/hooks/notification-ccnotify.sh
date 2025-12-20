#!/bin/bash
# Claude Code Notification Hook - cc-notify integration (ONE-WAY)
# Sends Claude's output messages to cc-notify daemon for display in GUI.
# This is FIRE-AND-FORGET - no response is sent back to Claude.
#
# For BIDIRECTIONAL communication (questions, approvals), use:
#   ccnotify-interactive.sh via PreToolUse hook
#
# Testing:
#   echo '{"transcript_path":"/path/to/transcript.jsonl","message":"fallback"}' | ./notification-ccnotify.sh
#   CCNOTIFY_DEBUG=1 echo '{"message":"test"}' | ./notification-ccnotify.sh
#   tail -f ~/.claude/hooks/ccnotify-debug.log

CC_NOTIFY_BIN="${CC_NOTIFY_BIN:-cc-notify}"
MAX_CHARS=1000
DEBUG="${CCNOTIFY_DEBUG:-0}"
LOG_FILE="$HOME/.claude/hooks/ccnotify-debug.log"

log() {
    [ "$DEBUG" = "1" ] || return
    echo "[$(date +%H:%M:%S)] $1" >> "$LOG_FILE"
}

log "--- cc-notify Hook Start ---"

# Read JSON from stdin
INPUT=$(cat)
log "Input: ${INPUT:0:200}..."

# Extract transcript path and fallback message
TRANSCRIPT_PATH=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('transcript_path',''))" 2>/dev/null)
FALLBACK_MSG=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('message',''))" 2>/dev/null)

log "Transcript: $TRANSCRIPT_PATH"
log "Fallback: $FALLBACK_MSG"

# Extract last assistant message from transcript
MESSAGE=""
if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
    MESSAGE=$(python3 -c "
import json, sys

def get_last_assistant_message(path):
    with open(path, 'r') as f:
        lines = f.readlines()

    for line in reversed(lines):
        try:
            entry = json.loads(line.strip())
            if entry.get('type') == 'assistant':
                content = entry.get('message', {}).get('content', [])
                # Only extract text blocks (skip tool_use, thinking, etc)
                texts = [block.get('text', '') for block in content if block.get('type') == 'text']
                result = ' '.join(texts).strip()
                if result:
                    print(result)
                    return
        except json.JSONDecodeError:
            continue

get_last_assistant_message('$TRANSCRIPT_PATH')
" 2>/dev/null)
    log "Extracted message: ${MESSAGE:0:100}..."
fi

# Fallback if no transcript message
if [ -z "$MESSAGE" ]; then
    log "No transcript message, using fallback"
    MESSAGE="$FALLBACK_MSG"
fi

# Exit if still no message
if [ -z "$MESSAGE" ]; then
    log "No message at all, exiting"
    exit 0
fi

# Truncate if too long
if [ ${#MESSAGE} -gt $MAX_CHARS ]; then
    log "Truncating from ${#MESSAGE} to $MAX_CHARS chars"
    MESSAGE="${MESSAGE:0:$MAX_CHARS}..."
fi

# Check if cc-notify is available
if ! command -v "$CC_NOTIFY_BIN" &>/dev/null; then
    log "cc-notify not found: $CC_NOTIFY_BIN"
    exit 0
fi

# Send to cc-notify (fire and forget)
log "Sending to cc-notify..."
"$CC_NOTIFY_BIN" send -t complete "$MESSAGE" &>/dev/null &

log "--- cc-notify Hook End ---"
exit 0
