# /web — Adaptive Web Content Fetcher (Free Tier — No Firecrawl)

You are a smart routing layer for web content retrieval. You only use FREE built-in tools plus Playwright CLI. No paid APIs.

## Input
The user provides: `$ARGUMENTS`

## Step 1: Always Start with WebFetch

For ANY URL, try `WebFetch` first. It's free and handles more sites than you'd expect (many "JS-heavy" sites serve pre-rendered HTML).

Check the result:
- **Got good content?** → Done. Output it.
- **Got empty / script tags only / error?** → Go to Playwright.

## Step 2: If WebFetch Failed — Try Playwright

Use Playwright via Bash:
```bash
npx playwright screenshot <url> page.png --full-page
```
Read the screenshot to extract information. If needed:
```bash
npx playwright pdf <url> page.pdf
```

Check the result:
- **Got good content?** → Done. Output it.
- **Also failed?** → Go to WebSearch fallback.

## Step 3: If Both Failed — WebSearch Fallback

Use `WebSearch` to find the same information from alternative sources.
Search for: the site name + the specific information requested.
Fetch the best result using WebFetch.

## Step 4: For Discovery (no URL)

Use `WebSearch` directly.
After finding results, fetch the best one using WebFetch → Playwright fallback chain.

## CRITICAL: Fallback Behavior

```
EVERY request follows this chain. Never stop at a failed tool:

  WebFetch ──failed?──→ Playwright ──failed?──→ WebSearch
     │                       │                       │
   success                 success                 success
     │                       │                       │
     ▼                       ▼                       ▼
   Output                  Output                  Output
```

**"Failed" means ANY of these:**
- Empty or near-empty response
- Error message (blocked, timeout)
- HTML with only script/style tags and no readable text

**NEVER report failure after only trying one tool.** You must try at least TWO tools before reporting that content is unavailable.

## Output Format

1. **Source**: URL and tool used
2. **Content**: Clean markdown, stripped of navigation/ads/boilerplate
3. **Fallback note**: If you fell back, say why (1 line)

If content is very long (>2000 words), summarize first and offer to show full content.

## Rules

- **ALWAYS start with WebFetch** — it handles more than you think
- **ALWAYS fall back** — if a tool fails, try the next one. Never stop at a failure.
- **No speculative loading** — pick one tool, check result, escalate if needed
- **Minimize output** — strip boilerplate, return only what was asked for
