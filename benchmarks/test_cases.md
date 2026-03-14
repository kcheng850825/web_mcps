# Benchmark Test Cases

Run each test case **twice**: once with only built-in tools (baseline), once with the `/web` skill (test). Record results in `results/` as JSON.

---

## Scoring Guide

| Dimension | 0 | 1 | 2 | 3 |
|-----------|---|---|---|---|
| **Completeness** | Got nothing | Got partial/summary only | Got most of the info | Got everything asked for |
| **Accuracy** | Wrong info | Some errors | Minor gaps | Fully correct |

**Efficiency Score** = `(Completeness x Accuracy) / (Tokens / 1000)`

Higher is better. A perfect fetch (9) using 2K tokens = 4.5. A partial fetch (4) using 10K tokens = 0.4.

---

## Test Cases

### Category: Static Content (expect WebFetch)

**Test 1: Documentation page**
- Task: "Get the Python 3.12 what's new summary from docs.python.org"
- URL: https://docs.python.org/3/whatsnew/3.12.html
- Expected tool: WebFetch
- Verify: Lists major features (f-string improvements, type parameter syntax, etc.)

**Test 2: Blog post**
- Task: "Summarize the latest post from https://blog.rust-lang.org/"
- URL: https://blog.rust-lang.org/
- Expected tool: WebFetch
- Verify: Gets title, date, and key points of the latest post

---

### Category: JS-Heavy Sites (expect Firecrawl)

**Test 3: SaaS pricing page**
- Task: "Get the pricing tiers from vercel.com/pricing"
- URL: https://vercel.com/pricing
- Expected tool: Firecrawl scrape
- Verify: Gets all tier names, prices, and key features

**Test 4: React-based documentation**
- Task: "Get the API reference for React's useState hook"
- URL: https://react.dev/reference/react/useState
- Expected tool: Firecrawl scrape
- Verify: Gets function signature, parameters, return values, examples

---

### Category: Interactive Content (expect Playwright)

**Test 5: Content behind interaction**
- Task: "Get the content from a page that requires accepting cookies first"
- URL: (use a site known to require cookie consent)
- Expected tool: Playwright CLI
- Verify: Gets page content after dismissing the overlay

**Test 6: Dynamically loaded content**
- Task: "Get the full list of items from a page that uses infinite scroll"
- URL: (use a site with lazy-loaded content)
- Expected tool: Playwright CLI or Firecrawl
- Verify: Gets more content than a simple fetch would return

---

### Category: Discovery (expect Firecrawl search)

**Test 7: Topic research**
- Task: "Find a comparison of Python HTTP libraries (requests vs httpx vs aiohttp) from 2025"
- URL: none (discovery)
- Expected tool: Firecrawl search or WebSearch
- Verify: Returns multiple sources with pros/cons of each library

**Test 8: Fact lookup**
- Task: "What are the current GitHub API rate limits for authenticated users?"
- URL: none (discovery)
- Expected tool: Firecrawl search or WebSearch then fetch
- Verify: Gets correct rate limit numbers (5000 req/hr for authenticated)

---

### Category: Known Failure Cases

**Test 9: Blocked domain**
- Task: "Get the front page content from a domain that WebFetch blocks"
- URL: (test with a domain known to be blocked by Claude's safety check)
- Expected tool: Firecrawl scrape (after WebFetch fails)
- Verify: Actually retrieves the content via fallback

**Test 10: Heavy single-page app**
- Task: "Get the feature list from a heavy SPA (e.g., Figma's features page)"
- URL: https://www.figma.com/features
- Expected tool: Firecrawl scrape
- Verify: Gets feature names and descriptions, not empty divs

---

## How to Run

1. Start a Claude Code session
2. Run `/cost` to note starting tokens
3. Execute the task using only built-in tools (no `/web` skill) — record results
4. Run `/clear`
5. Execute the same task using `/web` skill — record results
6. Run `/cost` to note ending tokens
7. Fill in the JSON result file (see `results/sample.json` for format)
