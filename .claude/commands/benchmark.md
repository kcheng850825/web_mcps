# /benchmark — Power Use Case Benchmark

You are running an automated benchmark to measure the /web skill on tasks that built-in tools CANNOT do well alone. These tests focus on multi-page, multi-source, and structured extraction tasks.

## Setup

1. Note the current context percentage (`/context` equivalent — check how full your context is)
2. You will run each test twice: baseline (built-in tools only) then skill (best tool for the job)

## Test Cases

Run each test **twice**:
- **Baseline**: Use ONLY built-in WebFetch and WebSearch. No Firecrawl, no Playwright.
- **Skill**: Use the best available tools (Firecrawl crawl/scrape, Playwright, etc.)

For each run, record:
- Tool(s) used
- Context % before and after (delta = cost)
- Completeness (0-3): 0=nothing, 1=partial, 2=most, 3=everything
- Accuracy (0-3): 0=wrong, 1=errors, 2=minor gaps, 3=correct
- Turns/attempts needed

### Test 1 — COMPARE: Cross-site pricing
**Task:** Compare pricing tiers across Vercel (vercel.com/pricing), Netlify (netlify.com/pricing), and Render (render.com/pricing). Build a comparison table.
**Category:** compare
**What to measure:** Can you get all 3 sites' pricing into one clean table?

### Test 2 — EXTRACT: Structured API data
**Task:** Extract all HTTP methods and endpoints from the GitHub REST API docs (docs.github.com/en/rest) for the Repositories section. Output as a table with: Method, Endpoint, Description.
**Category:** extract
**What to measure:** Did you get a complete, structured table?

### Test 3 — RESEARCH: Multi-source synthesis
**Task:** Research "best backend framework for a startup in 2025" — find at least 4 sources, compare recommendations, and note where sources agree or disagree.
**Category:** research
**What to measure:** How many sources cited? Is the synthesis useful?

### Test 4 — CRAWL: Full doc site ingestion
**Task:** Crawl the Claude API documentation (docs.anthropic.com) and provide a structured summary of all available API endpoints and features.
**Category:** crawl
**What to measure:** How many pages did you cover? How complete is the summary?

### Test 5 — EXTRACT: Complex page with dynamic content
**Task:** Get the complete feature comparison matrix from github.com/features (the Enterprise vs Team vs Free grid).
**Category:** extract
**What to measure:** Did you get the full matrix, not just a partial list?

### Test 6 — RESEARCH: Technical deep dive
**Task:** Research WebSocket vs Server-Sent Events vs WebTransport. Find at least 3 sources, compare performance, browser support, and use cases.
**Category:** research
**What to measure:** Quality of synthesis, number of sources, accuracy of technical details.

### Test 7 — COMPARE: Feature comparison
**Task:** Compare features of Supabase vs Firebase vs PlanetScale. Get actual feature lists from each site and build a comparison.
**Category:** compare
**What to measure:** Are features from all 3 sites accurately represented?

### Test 8 — CRAWL: API reference ingestion
**Task:** Crawl the Stripe API documentation for the Payments section (stripe.com/docs/api/charges) and list all available operations with their parameters.
**Category:** crawl
**What to measure:** Completeness of API operations listed.

### Test 9 — EXTRACT: Changelog parsing
**Task:** Get the last 5 release entries from the Node.js changelog (nodejs.org/en/blog) with dates, version numbers, and key changes.
**Category:** extract
**What to measure:** Did you get exact version numbers, dates, and meaningful change summaries?

### Test 10 — RESEARCH: Decision support
**Task:** Research "should I use TypeScript or JavaScript for a new project in 2025" — find arguments for both sides from at least 3 sources each.
**Category:** research
**What to measure:** Balance of arguments, source quality, actionable conclusion.

## Execution

1. Run all 10 baseline tests FIRST (only WebFetch + WebSearch)
2. Then run all 10 skill tests (use best available tools)
3. For baseline: even if you know WebFetch will struggle, use ONLY built-in tools
4. For skill: use Firecrawl crawl/scrape, Playwright, whatever gets the best result
5. Score honestly — if baseline got a partial answer, that's fine, score it fairly

## Output

Write results to `benchmarks/results/auto-YYYY-MM-DD.json`:

```json
{
  "meta": {
    "date": "YYYY-MM-DD",
    "runner": "auto-benchmark",
    "mode": "subscription OR api",
    "notes": "Power use case benchmark v2"
  },
  "runs": [
    {
      "test_id": 1,
      "test_name": "Cross-site pricing comparison",
      "category": "compare",
      "baseline": {
        "tool_used": "WebFetch x3",
        "completeness": 2,
        "accuracy": 2,
        "tokens_used": 8,
        "turns": 4,
        "notes": "context delta 8%, got 2 of 3 sites"
      },
      "skill": {
        "tool_used": "WebFetch x2 + Firecrawl x1",
        "completeness": 3,
        "accuracy": 3,
        "tokens_used": 6,
        "turns": 2,
        "notes": "context delta 6%, full comparison table"
      }
    }
  ]
}
```

After writing results, show a summary table and tell the user to open `dashboard/index.html` to visualize.
