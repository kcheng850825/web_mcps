# CLAUDE.md — web_mcps

## What This Project Is

A Claude Code skill (`/web`) that adaptively routes web content requests to the best available tool, maximizing information quality while minimizing token waste.

## Project Structure

```
web_mcps/
├── CLAUDE.md                          # This file
├── claude_md.md                       # Original planning document
├── .claude/commands/web.md            # The /web skill (slash command)
├── benchmarks/
│   ├── test_cases.md                  # 10 benchmark test cases
│   ├── run_benchmark.sh               # Interactive benchmark runner
│   └── results/
│       └── sample.json                # Sample benchmark data
└── dashboard/
    └── index.html                     # Scoring dashboard (open in browser)
```

## How the /web Skill Works

The skill classifies web tasks and routes to the cheapest effective tool:

1. **Static content** (blogs, docs, wikis) → Built-in WebFetch (zero cost)
2. **JS-rendered sites** (SPAs, pricing pages) → Firecrawl MCP
3. **Interactive content** (login, forms, scrolling) → Playwright CLI
4. **Discovery** (topic search, no URL) → Firecrawl search or WebSearch

Fallback chain: WebFetch → Firecrawl → Playwright → report failure

## Efficiency Score Formula

`Score = (Completeness × Accuracy) / (Tokens ÷ 1000)`

- Completeness: 0-3 (nothing → everything)
- Accuracy: 0-3 (wrong → fully correct)
- Higher score = more info per token

## Development Commands

- Run benchmarks: `./benchmarks/run_benchmark.sh`
- View dashboard: open `dashboard/index.html` in a browser
- Use the skill: type `/web <your request>` in Claude Code

## Prerequisites for Full Functionality

- Claude Code CLI (with claude.ai auth)
- Firecrawl MCP (optional, for JS-heavy sites)
- Playwright (`npx playwright install`, optional, for interactive sites)
- Fetch MCP (optional, lightweight fallback)
