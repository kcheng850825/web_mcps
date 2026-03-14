#!/usr/bin/env bash
# run_benchmark.sh — Interactive benchmark runner for /web skill
# Usage: ./benchmarks/run_benchmark.sh [output_file]
#
# This script guides you through running each test case and recording results.
# It generates a JSON file you can load into the dashboard.

set -e

OUTPUT="${1:-benchmarks/results/$(date +%Y-%m-%d).json}"
TIMESTAMP=$(date +%Y-%m-%d)

echo "============================================"
echo "  Web Skill Benchmark Runner"
echo "============================================"
echo ""
echo "This script will guide you through 10 test cases."
echo "For each test, you'll run it twice in Claude Code:"
echo "  1. Baseline: use only built-in tools (no /web)"
echo "  2. With skill: use the /web command"
echo ""
echo "Results will be saved to: $OUTPUT"
echo ""

# Collect runner name
read -rp "Your name: " RUNNER_NAME
read -rp "Any notes for this run: " RUN_NOTES

# Test case definitions
declare -a TEST_IDS=(1 2 3 4 5 6 7 8 9 10)
declare -a TEST_NAMES=(
  "Python 3.12 docs"
  "Rust blog post"
  "Vercel pricing"
  "React useState docs"
  "Cookie consent page"
  "Infinite scroll content"
  "HTTP libs comparison"
  "GitHub API rate limits"
  "Blocked domain"
  "Figma features SPA"
)
declare -a TEST_CATEGORIES=(
  "static" "static"
  "js-heavy" "js-heavy"
  "interactive" "interactive"
  "discovery" "discovery"
  "failure-case" "failure-case"
)

# Start building JSON
RUNS_JSON=""

for i in "${!TEST_IDS[@]}"; do
  ID="${TEST_IDS[$i]}"
  NAME="${TEST_NAMES[$i]}"
  CAT="${TEST_CATEGORIES[$i]}"

  echo ""
  echo "--------------------------------------------"
  echo "  Test $ID: $NAME ($CAT)"
  echo "--------------------------------------------"
  echo ""

  # Baseline
  echo ">> BASELINE RUN (no /web skill):"
  echo "   Open Claude Code, run the task, then record:"
  read -rp "   Tool used (e.g. WebFetch): " B_TOOL
  read -rp "   Completeness (0-3): " B_COMP
  read -rp "   Accuracy (0-3): " B_ACC
  read -rp "   Tokens used: " B_TOKENS
  read -rp "   Turns needed: " B_TURNS
  read -rp "   Notes: " B_NOTES

  echo ""

  # Skill run
  echo ">> SKILL RUN (with /web):"
  echo "   Run /clear, then use /web for the same task:"
  read -rp "   Tool used (e.g. Firecrawl): " S_TOOL
  read -rp "   Completeness (0-3): " S_COMP
  read -rp "   Accuracy (0-3): " S_ACC
  read -rp "   Tokens used: " S_TOKENS
  read -rp "   Turns needed: " S_TURNS
  read -rp "   Notes: " S_NOTES

  # Build run JSON entry
  RUN_ENTRY=$(cat <<ENTRY
    {
      "test_id": $ID,
      "test_name": "$NAME",
      "category": "$CAT",
      "baseline": {
        "tool_used": "$B_TOOL",
        "completeness": $B_COMP,
        "accuracy": $B_ACC,
        "tokens_used": $B_TOKENS,
        "turns": $B_TURNS,
        "notes": "$B_NOTES"
      },
      "skill": {
        "tool_used": "$S_TOOL",
        "completeness": $S_COMP,
        "accuracy": $S_ACC,
        "tokens_used": $S_TOKENS,
        "turns": $S_TURNS,
        "notes": "$S_NOTES"
      }
    }
ENTRY
  )

  if [ -n "$RUNS_JSON" ]; then
    RUNS_JSON="$RUNS_JSON,
$RUN_ENTRY"
  else
    RUNS_JSON="$RUN_ENTRY"
  fi

  echo "   Recorded."
done

# Write output file
mkdir -p "$(dirname "$OUTPUT")"
cat > "$OUTPUT" <<EOF
{
  "meta": {
    "date": "$TIMESTAMP",
    "runner": "$RUNNER_NAME",
    "notes": "$RUN_NOTES"
  },
  "runs": [
$RUNS_JSON
  ]
}
EOF

echo ""
echo "============================================"
echo "  Done! Results saved to: $OUTPUT"
echo "  Open dashboard/index.html and load this file"
echo "  to see your benchmark scores."
echo "============================================"
