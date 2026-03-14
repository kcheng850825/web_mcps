# CLAUDE.md — Project Context

## Who I Am
I am a beginner with no coding or command line experience. Assume I don't know where anything is or how to navigate my computer beyond basic use. Always give step-by-step instructions that include where to click, what to open, and what to type. Never assume I know terminal commands, file paths, or technical terms without explaining them.

---

## What We're Building
A GitHub repository that anyone (especially beginners) can install with **one command** that:
1. Automatically checks what's already installed (Node.js, Claude Code, etc.)
2. Skips steps that are already done
3. Walks through each setup step incrementally with clear explanations
4. Connects Claude Code to tools that fix its web search limitations
5. Acts as a **smart routing layer** — only activating the right tool for each situation to save tokens

The goal: someone who is exactly where I was before this conversation can go from zero to a fully working, optimized Claude Code setup in minutes.

---

## My Setup
- **Plan:** Claude Max (either $100/month 5x or $200/month 20x)
- **Claude Code:** CLI (terminal-based), not desktop app
- **Auth:** Logged in via claude.ai account (no separate API key needed)
- **Platforms to support:** Mac, Windows, Linux

---

## What We've Already Decided to Install

### MCP Tools (in priority order)
| Tool | Purpose | Token impact |
|------|----------|--------------|
| Firecrawl | Cleans messy web pages into readable markdown | ~70% fewer fetch tokens |
| Playwright CLI (not MCP) | Full browser control for JS-heavy/interactive sites | 4x fewer tokens than Playwright MCP |
| Fetch MCP | Lightweight fallback for simple pages | Minimal overhead |
| GitHub connector | Manage repos, PRs, issues from terminal | Via claude.ai/settings/connectors |

### Key Design Rule
**Tools should only activate when needed, not sit loaded all the time.** Having all MCP tools loaded simultaneously can burn 80,000+ tokens before you even type anything.

---

## How Claude Code Web Search Actually Works (The Failure Chain)
Claude's built-in web tools fail in these specific ways — our tool fixes each one:

1. **Domain safety check** → blocks legitimate sites silently (Firecrawl bypasses this)
2. **Empty pages** → modern JS sites load content after page opens, Claude gets empty shell (Playwright/Firecrawl fix this)
3. **Content filtered through small model** → details get lost before Opus sees them (Firecrawl sends clean markdown instead)
4. **Token flooding** → raw HTML dumps ads/menus/junk into context (Firecrawl strips all that)
5. **Iteration limit** → Claude times out on complex multi-step fetches (smart routing reduces steps needed)

---

## Smart Routing Logic (What the Tool Should Do)
```
Simple static page (blog, docs)     → Built-in WebFetch
JavaScript-heavy site               → Firecrawl
Need to click/log in/fill forms     → Playwright CLI
Don't know where the info is        → Firecrawl Agent (finds it automatically)
All tools idle                      → Nothing loaded (zero token overhead)
```

---

## CLI Power Features I Know About
These are CLI-only (not in desktop app):
- `dontAsk` / `--dangerously-skip-permissions` — Claude works without asking permission every step
- `!` bash shortcut — run shell commands inside Claude session, output becomes context
- `/btw` — ask a side question without interrupting Claude mid-task
- Loop mode — Claude works autonomously for hours unattended
- `/rewind` — undo just code changes, keep conversation history
- `Ctrl+T` — persistent task list that survives closing the app
- Hooks — automatic rules that run after every action (e.g. auto-format on save)
- Custom slash commands — personal shortcuts saved in `.claude/commands/`
- `/insights` — Claude analyzes your usage patterns and suggests improvements
- `/status` — check how much usage limit is left
- `/clear` — reset conversation but keep CLAUDE.md loaded
- `/compact` — compress context when it gets too full (use at ~80% full)
- `/cost` — see token usage for current session
- `/context` — see how full your context window is

---

## Token Saving Rules (Always Follow These)
- Use **Sonnet** for 80% of tasks, **Opus** only for complex architecture/refactoring
- Run `/clear` every time you start a new task
- Check `/context` before long sessions — run `/compact` if getting full
- Only load MCP tools when actually needed
- Be specific in prompts — vague prompts = more back and forth = more tokens
- Commit code to Git after every meaningful change (safety net + keeps context clean)

---

## Connectors Already Available
Via claude.ai/settings/connectors — connect once, works automatically in CLI:
- GitHub
- Slack
- Gmail
- Google Drive
- Notion
- Asana, Linear, Jira
- Figma, Canva
- And 40+ more

Once connected, just ask Claude in plain English:
> "Push my changes to GitHub"
> "Create a new branch called my-feature"
> "Open a pull request with a description"

---

## The GitHub Repo We're Planning to Build
**Purpose:** One-command setup script for beginners to get Claude Code fully configured

**What it should include:**
- Setup script (Mac/Windows/Linux) that checks before doing each step
- Auto-installs: Node.js check → Claude Code → Login → GitHub connector → Firecrawl → Playwright CLI → Fetch MCP
- Smart routing config that only activates tools when needed
- Pre-filled CLAUDE.md template (this file)
- Plain English README written for non-technical users
- Pre-configured settings.json with sensible defaults

**Key design principles:**
- Check if already installed → skip if done
- Show progress clearly at each step
- Explain what each step does in plain English
- Never assume technical knowledge
