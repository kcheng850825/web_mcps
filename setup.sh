#!/usr/bin/env bash
set -e

echo "============================================"
echo "  Web Skill Setup for Claude Code"
echo "============================================"
echo ""

# -------------------------------------------
# Step 1: Check Node.js
# -------------------------------------------
echo "[Step 1/6] Checking Node.js..."
if command -v node &>/dev/null; then
    echo "  Found Node.js $(node --version) — OK"
else
    echo "  NOT FOUND. Please install Node.js first:"
    echo "    Mac:   brew install node"
    echo "    Linux: sudo apt install nodejs npm"
    echo "  Then run this script again."
    exit 1
fi

# -------------------------------------------
# Step 2: Check Claude Code
# -------------------------------------------
echo ""
echo "[Step 2/6] Checking Claude Code..."
if command -v claude &>/dev/null; then
    echo "  Found Claude Code $(claude --version 2>/dev/null | head -1) — OK"
else
    echo "  Not found. Installing Claude Code..."
    npm install -g @anthropic-ai/claude-code
    echo "  Installed. Now log in:"
    echo ""
    claude auth login
fi

# -------------------------------------------
# Step 3: Choose your tier
# -------------------------------------------
echo ""
echo "============================================"
echo "  Choose Your Setup Tier"
echo "============================================"
echo ""
echo "  [1] FREE — No accounts needed (\$0)"
echo "      Uses: WebFetch + WebSearch + Playwright"
echo ""
echo "  [2] FIRECRAWL CLOUD — Free tier available (\$0-\$16/mo)"
echo "      Uses: Everything in #1 + Firecrawl API"
echo "      (500 free pages/month)"
echo ""
echo "  [3] SELF-HOSTED FIRECRAWL — Unlimited (\$0)"
echo "      Uses: Everything in #2 but self-hosted"
echo "      (requires Docker)"
echo ""
read -rp "Enter 1, 2, or 3: " TIER
TIER="${TIER:-1}"

if [[ "$TIER" != "1" && "$TIER" != "2" && "$TIER" != "3" ]]; then
    echo "Invalid choice. Defaulting to 1 (Free)."
    TIER=1
fi

# -------------------------------------------
# Step 4: Install tools based on tier
# -------------------------------------------
echo ""
echo "[Step 4/6] Installing tools for Tier $TIER..."

echo "  Installing Playwright browsers..."
npx playwright install >/dev/null 2>&1
echo "  Playwright — OK"

if [ "$TIER" = "2" ]; then
    echo ""
    echo "  Firecrawl Cloud requires an API key."
    echo "  1. Go to https://www.firecrawl.dev"
    echo "  2. Sign up (free tier = 500 pages/month)"
    echo "  3. Copy your API key (starts with fc-)"
    echo ""
    read -rp "  Paste your Firecrawl API key: " FC_KEY
    if [ -z "$FC_KEY" ]; then
        echo "  No key entered. Falling back to Tier 1."
        TIER=1
    else
        claude mcp add firecrawl -e "FIRECRAWL_API_KEY=$FC_KEY" -- npx -y firecrawl-mcp
        echo "  Firecrawl Cloud — OK"
    fi
fi

if [ "$TIER" = "3" ]; then
    if ! command -v docker &>/dev/null; then
        echo "  Docker NOT FOUND. Install Docker first:"
        echo "    Mac:   brew install --cask docker"
        echo "    Linux: sudo apt install docker.io"
        echo "  Falling back to Tier 1."
        TIER=1
    else
        echo "  Docker found. Starting self-hosted Firecrawl..."
        docker run -d --name firecrawl -p 3002:3002 ghcr.io/mendableai/firecrawl:latest >/dev/null 2>&1 || docker start firecrawl >/dev/null 2>&1
        echo "  Firecrawl running at http://localhost:3002"
        claude mcp add firecrawl -e FIRECRAWL_API_KEY=fc-local -e FIRECRAWL_API_URL=http://localhost:3002 -- npx -y firecrawl-mcp
        echo "  Self-hosted Firecrawl — OK"
    fi
fi

# -------------------------------------------
# Step 5: Install the right skill file
# -------------------------------------------
echo ""
echo "[Step 5/6] Installing /web skill (Tier $TIER)..."

mkdir -p "$HOME/.claude/commands"

case "$TIER" in
    1)
        cp .claude/commands/tiers/web-free.md "$HOME/.claude/commands/web.md"
        echo "  Installed: FREE tier (WebFetch + Playwright)"
        ;;
    2)
        cp .claude/commands/tiers/web-firecrawl.md "$HOME/.claude/commands/web.md"
        echo "  Installed: FIRECRAWL CLOUD tier"
        ;;
    3)
        cp .claude/commands/tiers/web-selfhost.md "$HOME/.claude/commands/web.md"
        echo "  Installed: SELF-HOSTED FIRECRAWL tier"
        ;;
esac

# Also update project copy
mkdir -p .claude/commands
cp "$HOME/.claude/commands/web.md" .claude/commands/web.md

# -------------------------------------------
# Step 6: Verify
# -------------------------------------------
echo ""
echo "[Step 6/6] Verifying setup..."
command -v claude &>/dev/null && echo "  Claude Code — OK" || echo "  Claude Code — MISSING"
command -v node &>/dev/null && echo "  Node.js — OK" || echo "  Node.js — MISSING"
npx playwright --version &>/dev/null && echo "  Playwright — OK" || echo "  Playwright — MISSING"
[ "$TIER" = "2" ] && echo "  Firecrawl Cloud — CONFIGURED"
[ "$TIER" = "3" ] && echo "  Firecrawl Self-Hosted — CONFIGURED"
echo "  /web skill — INSTALLED"

echo ""
echo "============================================"
echo "  Setup Complete! (Tier $TIER)"
echo "============================================"
echo ""
echo "  To use it, run:"
echo "    claude"
echo "  Then type:"
echo "    /web Get the pricing from vercel.com"
echo ""
echo "  To run benchmarks:"
echo "    ./benchmarks/run_benchmark.sh"
echo "============================================"
