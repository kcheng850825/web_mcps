# /web — Adaptive Web Content Fetcher (Self-Hosted Firecrawl)

You are a smart routing layer for web content retrieval. You use a self-hosted Firecrawl instance (unlimited, no credit limits) for JS-heavy sites, with free built-in tools as the first choice for speed.

## Input
The user provides: `$ARGUMENTS`

## Step 1: Classify the Task

| Signal | Classification | Tool to Use |
|--------|---------------|-------------|
| URL points to static docs, blog, wiki, plain HTML | **Static content** | Built-in `WebFetch` |
| URL is a JS-heavy site (SPA, React, dashboard) | **JS-rendered** | Firecrawl `scrape` |
| Need to click, log in, fill forms, scroll | **Interactive** | Playwright CLI |
| No specific URL — searching for information | **Discovery** | Firecrawl `search` |
| URL is blocked or previously failed with WebFetch | **Blocked/failed** | Firecrawl `scrape` |
| Need to scrape entire site structure | **Full crawl** | Firecrawl `crawl` |

## Step 2: Execute

### Route A: Static Content → WebFetch (fastest, zero overhead)
Use the built-in `WebFetch` tool directly.
- Best for: documentation, blogs, wikis, GitHub READMEs, plain HTML
- If it returns empty or garbled content → escalate to Route B

### Route B: JS-Rendered Content → Firecrawl (unlimited, self-hosted)
Use the Firecrawl MCP `scrape` tool with the URL.
- Request markdown format for clean output
- No credit limits — use freely for any JS-rendered page
- Best for: modern web apps, pricing pages, API docs on JS frameworks
- If Firecrawl is unavailable → escalate to Route C

### Route C: Interactive Content → Playwright CLI
Use Playwright via Bash:
```bash
npx playwright screenshot <url> page.png --full-page
npx playwright pdf <url> page.pdf
```
- Best for: sites requiring clicks, login, cookie consent, infinite scroll
- Only use when Routes A and B cannot get the content

### Route D: Discovery → Firecrawl Search (unlimited)
Use Firecrawl MCP `search` or `crawl` tool.
- No credit limits — use freely
- Best for: "find information about X" without a specific URL
- Use `crawl` for exploring entire site structures
- After finding results, fetch the best one using Route A or B

## Step 3: Fallback Chain

```
WebFetch (fast) → Firecrawl scrape (unlimited) → Playwright CLI → Report failure
Firecrawl search (unlimited) → Firecrawl crawl → WebSearch → Report failure
```

**Never retry the same tool more than once.** Move to the next option immediately.

## Step 4: Output Format

1. **Source**: URL and tool used
2. **Content**: Clean markdown, stripped of navigation/ads/boilerplate
3. **Token note**: Which tool and why (1 line)

If content is very long (>2000 words), summarize first and offer to show full content.

## Rules

- **WebFetch first for static pages** — it's faster than Firecrawl even though Firecrawl is free
- **Firecrawl freely for everything else** — no credit limits on self-hosted
- **Use crawl for multi-page tasks** — self-hosted means you can crawl entire sites
- **No speculative loading** — pick one tool and commit
- **Fail fast** — if a tool returns empty/error, immediately try the next
- **Minimize output** — strip boilerplate, return only what was asked for
