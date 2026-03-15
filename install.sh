#!/bin/bash
# install.sh — Install /web skill globally for all Claude Code sessions
#
# Usage:
#   ./install.sh              # Install default (Firecrawl Cloud) tier
#   ./install.sh free         # Install free tier (WebFetch + Playwright only)
#   ./install.sh selfhost     # Install self-hosted Firecrawl tier
#   ./install.sh firecrawl    # Install Firecrawl Cloud tier (same as default)

set -e

TIER="${1:-firecrawl}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEST_DIR="$HOME/.claude/commands"

# Map tier to source file
case "$TIER" in
  free)
    SRC="$SCRIPT_DIR/.claude/commands/tiers/web-free.md"
    echo "Installing /web skill (Free tier — WebFetch + Playwright only)"
    ;;
  selfhost)
    SRC="$SCRIPT_DIR/.claude/commands/tiers/web-selfhost.md"
    echo "Installing /web skill (Self-hosted Firecrawl — unlimited)"
    ;;
  firecrawl|cloud)
    SRC="$SCRIPT_DIR/.claude/commands/web.md"
    echo "Installing /web skill (Firecrawl Cloud)"
    ;;
  *)
    echo "Unknown tier: $TIER"
    echo "Usage: ./install.sh [free|selfhost|firecrawl]"
    exit 1
    ;;
esac

# Check source exists
if [ ! -f "$SRC" ]; then
  echo "Error: Source file not found: $SRC"
  exit 1
fi

# Create destination directory
mkdir -p "$DEST_DIR"

# Copy skill
cp "$SRC" "$DEST_DIR/web.md"

# Also install benchmark if it exists
if [ -f "$SCRIPT_DIR/.claude/commands/benchmark.md" ]; then
  cp "$SCRIPT_DIR/.claude/commands/benchmark.md" "$DEST_DIR/benchmark.md"
  echo "Also installed /benchmark skill"
fi

echo ""
echo "Installed to: $DEST_DIR/web.md"
echo ""
echo "Now open any project in Claude Code and type:"
echo "  /web compare pricing of vercel vs netlify vs render"
echo ""
echo "To uninstall:"
echo "  rm $DEST_DIR/web.md"
