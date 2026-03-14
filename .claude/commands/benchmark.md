# /benchmark — Automated Web Skill Benchmark

You are running an automated benchmark to measure the /web skill's effectiveness. Run all tests below sequentially and output a results JSON file at the end.

## Setup

1. First, detect the usage mode by checking what information is available:
   - Try running `/cost` mentally — if token counts are available, record exact tokens
   - Context window percentage is ALWAYS available — use it as the primary metric
   - Record BOTH if possible: exact tokens AND context percentage

2. Note the current context percentage before starting.

## Test Queries

Run each query below **twice**:
- **Baseline**: Fetch the content using ONLY built-in WebFetch or WebSearch. Do NOT use Firecrawl or Playwright. Just use the simplest built-in approach.
- **Skill**: Fetch the same content but now pick the BEST tool available (WebFetch, Firecrawl, Playwright) based on the /web routing logic.

For each run, record:
- Tool used
- Context % before and after (the delta is your cost metric)
- Completeness (0-3): 0=nothing, 1=partial, 2=most info, 3=everything asked for
- Accuracy (0-3): 0=wrong, 1=errors, 2=minor gaps, 3=fully correct
- Number of turns/attempts needed

### The 10 Tests

**Test 1 — Static docs**
Query: Get the Python 3.12 major new features from docs.python.org/3/whatsnew/3.12.html

**Test 2 — Blog post**
Query: Summarize the latest post from blog.rust-lang.org

**Test 3 — JS-heavy pricing page**
Query: Get all pricing tiers and prices from vercel.com/pricing

**Test 4 — React-based docs**
Query: Get the full API reference for React's useState hook from react.dev/reference/react/useState

**Test 5 — Cookie consent page**
Query: Get the main content from a news article on a site with a cookie consent overlay

**Test 6 — Dynamic content**
Query: Get the trending repositories from github.com/trending

**Test 7 — Topic research**
Query: Find a comparison of Python HTTP libraries (requests vs httpx vs aiohttp) with pros and cons

**Test 8 — Fact lookup**
Query: What are the current GitHub API rate limits for authenticated vs unauthenticated users?

**Test 9 — Potentially blocked domain**
Query: Get the front page headlines from reddit.com

**Test 10 — Heavy SPA**
Query: Get the feature list from figma.com/features

## Execution Rules

- Run all 10 baseline tests FIRST, then all 10 skill tests
- Between each individual test, note the context % change
- Do NOT summarize or skip any test — run all 20 fetches (10 baseline + 10 skill)
- For baseline: ONLY use WebFetch and WebSearch, even if they give poor results
- For skill: Use the best tool (follow the /web routing logic — WebFetch for static, Firecrawl for JS-heavy, Playwright for interactive)
- Score your own results honestly — if WebFetch returned empty HTML, that's a 0

## Output

After all 20 runs, write the results to `benchmarks/results/auto-YYYY-MM-DD.json` using this exact format:

```json
{
  "meta": {
    "date": "YYYY-MM-DD",
    "runner": "auto-benchmark",
    "mode": "subscription OR api",
    "notes": "Automated benchmark run"
  },
  "runs": [
    {
      "test_id": 1,
      "test_name": "Python 3.12 docs",
      "category": "static",
      "baseline": {
        "tool_used": "WebFetch",
        "completeness": 3,
        "accuracy": 3,
        "tokens_used": 5,
        "turns": 1,
        "notes": "context delta 5%"
      },
      "skill": {
        "tool_used": "WebFetch",
        "completeness": 3,
        "accuracy": 3,
        "tokens_used": 4,
        "turns": 1,
        "notes": "context delta 4%"
      }
    }
  ]
}
```

**Important:** The `tokens_used` field should contain:
- The context % delta (e.g., went from 12% to 17% = put `5`) — this works for ALL users
- If exact token counts are available, add them in the `notes` field

## After Writing Results

Tell the user:
1. Results saved to `benchmarks/results/auto-YYYY-MM-DD.json`
2. To view the dashboard: open `dashboard/index.html` in a browser and load the file
3. Show a quick summary table of all 10 tests with scores
