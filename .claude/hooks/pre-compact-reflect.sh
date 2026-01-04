#!/bin/bash
# Pre-Compact Reflection Hook
# Analyzes conversation transcript before context compaction to detect patterns
# and propose improvements to CLAUDE.md or new skills

set -e

# Read hook input from stdin
INPUT=$(cat)

# Extract key fields
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id')
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path')
TRIGGER=$(echo "$INPUT" | jq -r '.trigger')
CWD=$(echo "$INPUT" | jq -r '.cwd')

# Directories
REFLECTIONS_DIR="$HOME/.claude/reflections"
SKILL_DRAFTS_DIR="$HOME/.claude/skill-drafts"
PENDING_FILE="$REFLECTIONS_DIR/pending.jsonl"
HISTORY_FILE="$REFLECTIONS_DIR/history.json"

# Ensure directories exist
mkdir -p "$REFLECTIONS_DIR" "$SKILL_DRAFTS_DIR"

# Skip if transcript doesn't exist or is too small
if [[ ! -f "$TRANSCRIPT_PATH" ]]; then
    exit 0
fi

TRANSCRIPT_SIZE=$(wc -l < "$TRANSCRIPT_PATH")
if [[ $TRANSCRIPT_SIZE -lt 10 ]]; then
    # Too short to analyze meaningfully
    exit 0
fi

# Extract analysis-worthy data from transcript
# Focus on: tool sequences, retries, failed searches, repeated patterns
ANALYSIS=$(cat "$TRANSCRIPT_PATH" | jq -s '
    # Filter to assistant messages with tool calls
    [.[] | select(.role == "assistant" and .content != null)] |

    # Extract tool usage
    [.[].content | if type == "array" then .[] else . end |
     select(type == "object" and .type == "tool_use")] |

    # Build tool sequence
    {
        session_id: $session_id,
        timestamp: (now | todate),
        cwd: $cwd,
        trigger: $trigger,
        tool_count: length,
        tool_sequence: [.[:50] | .[].name],
        tool_inputs_sample: [.[:10] | {name: .name, input_preview: (.input | tostring | .[0:200])}]
    }
' --arg session_id "$SESSION_ID" --arg cwd "$CWD" --arg trigger "$TRIGGER" 2>/dev/null)

# Check if we got valid analysis
if [[ -z "$ANALYSIS" || "$ANALYSIS" == "null" ]]; then
    exit 0
fi

TOOL_COUNT=$(echo "$ANALYSIS" | jq -r '.tool_count')

# Only save if there was meaningful activity
if [[ $TOOL_COUNT -gt 5 ]]; then
    # Append to pending observations
    echo "$ANALYSIS" >> "$PENDING_FILE"

    # Optionally run deeper analysis via Claude CLI (async, non-blocking)
    # This spawns analysis in background so hook doesn't block
    if command -v claude &> /dev/null; then
        (
            # Build a prompt for pattern analysis
            PROMPT="Analyze this session's tool usage for patterns. Look for:
1. Repeated tool sequences (same tools called multiple times in a row)
2. Search patterns (Grep/Glob followed by Read - could be a skill)
3. Failed attempts followed by retries
4. Workflow sequences that could be automated

Session data:
$ANALYSIS

Respond with a JSON object:
{
  \"patterns_detected\": [...],
  \"suggested_claude_md_additions\": [...],
  \"potential_skill_candidates\": [...]
}

Be concise. Only include meaningful patterns."

            # Run analysis async (timeout after 30s)
            RESULT=$(timeout 30 claude --print -p "$PROMPT" 2>/dev/null || echo '{}')

            # Save analysis result if non-empty
            if [[ "$RESULT" != "{}" && -n "$RESULT" ]]; then
                ENRICHED=$(echo "$ANALYSIS" | jq --argjson analysis "$(echo "$RESULT" | jq -c '.' 2>/dev/null || echo '{}')" '. + {analysis: $analysis}')
                echo "$ENRICHED" >> "$REFLECTIONS_DIR/analyzed.jsonl"
            fi
        ) &
    fi
fi

# Success - don't block compaction
exit 0
