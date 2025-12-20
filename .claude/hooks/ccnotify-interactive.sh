#!/bin/bash
# Claude Code Interactive Hook - cc-notify notification (NON-BLOCKING)
# Sends AskUserQuestion content to cc-notify as a heads-up notification.
# User still answers in terminal - GUI is informational only.
#
# PreToolUse hook for AskUserQuestion tool
#
# Testing:
#   echo '{"tool_name":"AskUserQuestion","tool_input":{"questions":[{"question":"Test?"}]}}' | CCNOTIFY_DEBUG=1 ./ccnotify-interactive.sh

CC_NOTIFY_BIN="${CC_NOTIFY_BIN:-cc-notify}"
DEBUG="${CCNOTIFY_DEBUG:-0}"
LOG_FILE="$HOME/.claude/hooks/ccnotify-interactive.log"

log() {
    [ "$DEBUG" = "1" ] || return
    echo "[$(date +%H:%M:%S)] $1" >> "$LOG_FILE"
}

log "--- Interactive Hook Start ---"

# Read JSON from stdin
INPUT=$(cat)
log "Input: ${INPUT:0:500}..."

# Extract tool name
TOOL_NAME=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_name',''))" 2>/dev/null)
log "Tool: $TOOL_NAME"

# Only intercept AskUserQuestion
if [ "$TOOL_NAME" != "AskUserQuestion" ]; then
    log "Not AskUserQuestion, allowing"
    # Allow other tools to proceed normally
    echo '{"decision":"allow"}'
    exit 0
fi

# Extract the question(s) from tool input
QUESTION=$(echo "$INPUT" | python3 -c "
import sys, json

data = json.load(sys.stdin)
tool_input = data.get('tool_input', {})
questions = tool_input.get('questions', [])

# Build a readable question string
parts = []
for q in questions:
    question_text = q.get('question', '')
    options = q.get('options', [])

    if question_text:
        parts.append(question_text)

    if options:
        for i, opt in enumerate(options, 1):
            label = opt.get('label', '')
            desc = opt.get('description', '')
            if label:
                parts.append(f'  {i}. {label}' + (f' - {desc}' if desc else ''))

print('\n'.join(parts) if parts else 'Claude is asking a question')
" 2>/dev/null)

log "Question: $QUESTION"

# Check if cc-notify is available
if ! command -v "$CC_NOTIFY_BIN" &>/dev/null; then
    log "cc-notify not found, allowing default behavior"
    echo '{"decision":"allow"}'
    exit 0
fi

# Send notification to cc-notify (fire and forget) - just a heads-up
# User will still answer in terminal, GUI is informational only
log "Sending notification to cc-notify (non-blocking)..."
"$CC_NOTIFY_BIN" send -t question "$QUESTION" &>/dev/null &

# Allow the tool to proceed normally - user answers in terminal
log "Allowing tool to proceed"
echo '{"decision":"allow"}'

log "--- Interactive Hook End ---"
exit 0
