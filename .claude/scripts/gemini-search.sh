#!/bin/bash
# Gemini CLI Web Search with Caching
# Usage: gemini-search.sh search "query"
#        gemini-search.sh stats
#        gemini-search.sh clear

set -euo pipefail

CACHE_DIR="${HOME}/.cache/gemini-search"
CACHE_TTL=3600  # 1 hour in seconds

mkdir -p "$CACHE_DIR"

cache_key() {
    echo -n "$1" | tr '[:upper:]' '[:lower:]' | tr -s ' ' | md5
}

cache_valid() {
    local cache_file="$1"
    [[ -f "$cache_file" ]] || return 1
    local timestamp
    timestamp=$(jq -r '.timestamp' "$cache_file" 2>/dev/null || echo "0")
    local age=$(( $(date +%s) - timestamp ))
    [[ $age -lt $CACHE_TTL ]]
}

do_search() {
    local query="$1"
    local key=$(cache_key "$query")
    local cache_file="$CACHE_DIR/${key}.json"

    # Check cache
    if cache_valid "$cache_file"; then
        echo "[Cached result]" >&2
        jq -r '.response' "$cache_file"
        return 0
    fi

    # Run Gemini search - explicitly tell Gemini to use web search
    local result
    local search_prompt="Search the web for: $query. Provide a concise summary of the most relevant results."
    if ! result=$(gemini -y -o json "$search_prompt" 2>/dev/null); then
        echo "Gemini search failed" >&2
        return 1
    fi

    local response=$(echo "$result" | jq -r '.response // empty')
    [[ -z "$response" ]] && return 1

    # Cache result
    jq -n \
        --arg timestamp "$(date +%s)" \
        --arg query "$query" \
        --arg response "$response" \
        --argjson stats "$(echo "$result" | jq '.stats // {}')" \
        '{timestamp: ($timestamp | tonumber), query: $query, response: $response, stats: $stats}' \
        > "$cache_file"

    echo "$response"
}

do_stats() {
    local total=$(find "$CACHE_DIR" -name "*.json" 2>/dev/null | wc -l | tr -d ' ')
    local size=$(du -sh "$CACHE_DIR" 2>/dev/null | cut -f1 || echo "0B")
    local valid=0 expired=0 now=$(date +%s)

    shopt -s nullglob
    for f in "$CACHE_DIR"/*.json; do
        [[ -f "$f" ]] || continue
        local ts=$(jq -r '.timestamp' "$f" 2>/dev/null || echo "0")
        [[ $((now - ts)) -lt $CACHE_TTL ]] && ((valid++)) || ((expired++))
    done
    shopt -u nullglob

    cat <<EOF
## Gemini Search Cache Stats

- **Location**: $CACHE_DIR
- **Total Size**: $size
- **Total Entries**: $total
- **Valid (< 1hr)**: $valid
- **Expired**: $expired
- **TTL**: ${CACHE_TTL}s
EOF
}

do_clear() {
    local count=$(find "$CACHE_DIR" -name "*.json" 2>/dev/null | wc -l | tr -d ' ')
    rm -f "$CACHE_DIR"/*.json 2>/dev/null || true
    echo "Cleared $count cached search results."
}

case "${1:-}" in
    search) shift; do_search "$*" ;;
    stats)  do_stats ;;
    clear)  do_clear ;;
    *)      echo "Usage: gemini-search.sh {search|stats|clear}" ;;
esac
