# Windows Setup Guide — From Zero to /web Skill

No coding experience needed. Every step: what to type, what to expect.

---

## Step 0: Open Terminal

1. Press **Windows key**
2. Type **cmd**
3. Right-click **Command Prompt** → **Run as administrator**
4. Black window opens — all commands go here

> **Paste in Command Prompt:** right-click inside the window. Press **Enter** to run.

---

## Step 1: Check Node.js

```
node --version
```
**Expect:** `v20.11.0` or similar → go to Step 2.
**If "not recognized":**
1. Go to https://nodejs.org → click green **LTS** button → run installer (keep defaults)
2. Close and reopen Command Prompt
3. Run `node --version` again

---

## Step 2: Check Git

```
git --version
```
**Expect:** `git version 2.x.x` → go to Step 3.
**If "not recognized":** Go to https://git-scm.com/download/win → install (keep defaults) → reopen cmd.

---

## Step 3: Clone the Repo

```
cd %USERPROFILE%\Documents
git clone https://github.com/kcheng850825/web_mcps.git
cd web_mcps
```
**Expect:** `Cloning into 'web_mcps'...` then done.

---

## Step 4: Run the Setup Script

```
setup.bat
```

The script does everything automatically. It will:

### 4a: Check/install Claude Code
**Expect:** Either `Found Claude Code` or it installs and asks you to log in.
If it asks to log in → browser opens → sign in with your claude.ai account.

### 4b: Ask you to choose a tier

```
============================================
  Choose Your Setup Tier
============================================

  [1] FREE — No accounts needed ($0)
      Uses: WebFetch + WebSearch + Playwright

  [2] FIRECRAWL CLOUD — Free tier available ($0-$16/mo)
      Uses: Everything in #1 + Firecrawl API
      (500 free pages/month)

  [3] SELF-HOSTED FIRECRAWL — Unlimited ($0)
      Uses: Everything in #2 but self-hosted
      (requires Docker)

Enter 1, 2, or 3:
```

**Type `1`, `2`, or `3` and press Enter.**

| Tier | Cost | Best for | What you need |
|------|------|----------|---------------|
| **1** | $0 | Most people starting out | Nothing extra |
| **2** | $0 (free tier) | Better quality on JS sites | Firecrawl account (2 min signup) |
| **3** | $0 | Power users, unlimited | Docker installed |

### If you chose 2:
**Expect:** Script asks for your Firecrawl API key.
1. Go to https://www.firecrawl.dev → sign up → go to dashboard → copy API key
2. Paste it into the terminal and press Enter

### If you chose 3:
**Expect:** Script checks for Docker and starts a Firecrawl container.
If Docker isn't installed, it tells you and falls back to Tier 1.

### 4c: Installs Playwright
**Expect:** Downloads browser engines (~500MB). Takes 3-5 min. This is normal.

### 4d: Installs the /web skill
**Expect:** `Installed: [your tier] tier`

### 4e: Verifies everything
**Expect:**
```
[Step 6/6] Verifying setup...
  Claude Code — OK
  Node.js — OK
  Playwright — OK
  /web skill — INSTALLED

============================================
  Setup Complete! (Tier X)
============================================
```

---

## Step 5: Test It

Start Claude Code:
```
claude
```
**Expect:** Claude Code session opens in your terminal.

Type inside the session:
```
/web What is the latest Python version?
```
**Expect:** Claude fetches and answers the question.

Check tokens:
```
/cost
```
**Expect:** Shows token counts for this session.

---

## Step 6: Run Benchmarks (Optional)

Exit Claude first (type `/exit` or press `Ctrl+C`), then:

```
benchmarks\run_benchmark.bat
```

**Expect:** Asks your name, then walks you through 10 tests. For each test:
1. Tells you what to search/fetch
2. You run it in Claude **without** `/web` → type your scores
3. You run it **with** `/web` → type your scores

Takes ~30 min for all 10 tests.

---

## Step 7: View Dashboard

```
start dashboard\index.html
```

**Expect:** Browser opens with a dark dashboard. Click **"load sample data"** to preview, or **"Load Results JSON"** to load your benchmark results from `benchmarks\results\`.

---

## Daily Usage

```
claude
```
Then:
```
/web <what you want>
```

**Examples:**
```
/web summarize https://blog.rust-lang.org/
/web get pricing from vercel.com/pricing
/web find best Python web frameworks 2025
/web scrape the feature list from figma.com/features
```

**Useful commands inside Claude:**
| Command | What it does |
|---------|-------------|
| `/cost` | See token usage |
| `/clear` | Reset context (do this between tasks) |
| `/compact` | Compress context when getting full |
| `/context` | Check how full your context window is |

---

## Switching Tiers Later

Want to upgrade from Tier 1 to 2? Just run `setup.bat` again and pick a different number. It overwrites the old skill with the new one.

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `node is not recognized` | Reopen cmd after installing Node.js |
| `claude is not recognized` | Run `npm install -g @anthropic-ai/claude-code` again, reopen cmd |
| Firecrawl not working | Run `claude mcp list` — if missing, run `setup.bat` again with Tier 2 |
| Playwright timeout | Normal for slow sites — skill auto-falls back to other tools |
| Dashboard blank | Click "load sample data" first to verify it works |
| Setup script won't run | Make sure you're in the `web_mcps` folder: `cd %USERPROFILE%\Documents\web_mcps` |
