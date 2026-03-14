# Windows Setup Guide — From Zero to /web Skill

This guide assumes you're starting fresh on Windows with no coding experience.
Every step tells you exactly what to open, type, and expect.

---

## Step 0: Open Your Terminal

1. Press **Windows key** on your keyboard
2. Type **cmd**
3. Right-click **Command Prompt** and choose **Run as administrator**
4. A black window opens — this is your terminal. All commands below go here.

> **Tip:** After you paste a command, press **Enter** to run it.
> To paste in Command Prompt: right-click inside the window.

---

## Step 1: Check if Node.js is Installed

Type this and press Enter:

```
node --version
```

**If you see a version number** (like `v20.11.0`) — skip to Step 2.

**If you see an error** ("not recognized") — install Node.js:

1. Open your browser and go to: https://nodejs.org
2. Click the big green **LTS** download button
3. Run the installer — click **Next** on everything, keep all defaults checked
4. **Important:** Make sure "Add to PATH" is checked (it is by default)
5. Close and reopen Command Prompt (so it picks up the new install)
6. Run `node --version` again to confirm it works

---

## Step 2: Install Claude Code

```
npm install -g @anthropic-ai/claude-code
```

This may take a minute. When it's done, verify:

```
claude --version
```

You should see a version number.

### Log In

```
claude auth login
```

This opens your browser. Log in with your claude.ai account (the same one for your Max plan). No API key needed.

---

## Step 3: Clone This Repository

First, check if Git is installed:

```
git --version
```

**If you see an error**, install Git:
1. Go to https://git-scm.com/download/win
2. Download and run the installer — keep all defaults
3. Close and reopen Command Prompt

Now clone the repo:

```
cd %USERPROFILE%\Documents
git clone https://github.com/kcheng850825/web_mcps.git
cd web_mcps
```

You now have all the files on your computer at `Documents\web_mcps`.

---

## Step 4: Install Firecrawl MCP

Firecrawl is the key tool — it turns messy web pages into clean markdown and saves ~70% of tokens.

### 4a: Get a Firecrawl API Key

1. Go to https://www.firecrawl.dev
2. Sign up for a free account
3. Go to your dashboard and copy your **API key** (starts with `fc-`)
4. Keep this key handy — you'll need it in the next step

### 4b: Add Firecrawl to Claude Code

Run this command (replace `fc-YOUR-KEY-HERE` with your actual key):

```
claude mcp add firecrawl -e FIRECRAWL_API_KEY=fc-YOUR-KEY-HERE -- npx -y firecrawl-mcp
```

Verify it was added:

```
claude mcp list
```

You should see `firecrawl` in the list.

---

## Step 5: Install Fetch MCP (Lightweight Fallback)

```
claude mcp add fetch -- npx -y @anthropic-ai/fetch-mcp
```

This is a simple fetcher that handles basic pages with minimal overhead.

---

## Step 6: Install Playwright (For Interactive Sites)

```
npx playwright install
```

This downloads browser engines (Chromium, Firefox, WebKit). It may take a few minutes and use ~500MB of disk space. This is normal.

> **Note:** We use Playwright as a CLI tool, NOT as an MCP server.
> This uses 4x fewer tokens than the Playwright MCP approach.

---

## Step 7: Install the /web Skill

The skill file needs to be in your project's `.claude/commands/` folder.
From inside the `web_mcps` directory, it's already there. But to use it in
**any** project, copy it:

```
mkdir %USERPROFILE%\.claude\commands 2>nul
copy .claude\commands\web.md %USERPROFILE%\.claude\commands\web.md
```

Now `/web` works in every Claude Code session, regardless of which folder you're in.

---

## Step 8: Verify Everything Works

Start Claude Code:

```
claude
```

Once inside the Claude session, test each piece:

### Test 1 — The /web skill exists
Type:
```
/web What is the latest Python version?
```
Claude should use WebSearch or WebFetch and give you an answer.

### Test 2 — Firecrawl works
Type:
```
/web Get the pricing tiers from vercel.com/pricing
```
Claude should route to Firecrawl and return clean pricing data.

### Test 3 — Check your token usage
Type:
```
/cost
```
Note the token count. This is your baseline for comparison.

---

## Step 9: Run Benchmarks

The benchmark runner helps you measure how much the /web skill improves things.

### 9a: Run the Benchmark Script

From the `web_mcps` folder, run:

```
benchmarks\run_benchmark.bat
```

The script walks you through 10 test cases. For each one:
1. It tells you what to test
2. You run the task in Claude Code **without** `/web` (baseline)
3. You run the same task **with** `/web` (skill)
4. You type in the scores (completeness, accuracy, tokens, turns)

Results are saved as a JSON file in `benchmarks\results\`.

### 9b: View the Dashboard

Open the dashboard in your browser:

```
start dashboard\index.html
```

1. Click **"Load Results JSON"**
2. Navigate to `benchmarks\results\` and pick your results file
3. Or click **"load sample data"** to see it with demo numbers first

The dashboard shows:
- **Efficiency scores** — higher means more info per token
- **Token savings** — percentage saved vs baseline
- **Bar charts** — visual comparison per test
- **Detail table** — every test broken down

---

## Step 10: Daily Usage

Once everything is set up, your daily workflow is just:

```
claude
```

Then inside Claude:
```
/web <what you want to find or fetch>
```

### Examples

```
/web summarize the blog post at https://example.com/article
/web get the API pricing from openai.com/pricing
/web find a comparison of React vs Vue in 2025
/web scrape the feature list from figma.com/features
```

### Token-Saving Tips

- Run `/clear` when starting a new task
- Check `/cost` to see how many tokens you've used
- Run `/compact` if `/context` shows you're over 80% full
- Be specific in your prompts — vague = more back-and-forth = more tokens

---

## Troubleshooting

### "node is not recognized"
Close and reopen Command Prompt after installing Node.js. If it still
doesn't work, reinstall Node.js and make sure "Add to PATH" is checked.

### "claude is not recognized"
Run `npm install -g @anthropic-ai/claude-code` again. Then close and
reopen Command Prompt.

### Firecrawl isn't working
Check your API key: `claude mcp list` should show firecrawl.
If the key is wrong, remove and re-add:
```
claude mcp remove firecrawl
claude mcp add firecrawl -e FIRECRAWL_API_KEY=fc-YOUR-CORRECT-KEY -- npx -y firecrawl-mcp
```

### Playwright times out
Some sites are slow. Try adding `--timeout 60000` if running playwright
commands manually. Or let the /web skill fall back to Firecrawl.

### Dashboard is blank
Make sure you loaded a JSON file. Click "load sample data" first to
verify the dashboard itself works.

---

## File Locations Reference

After setup, here's where everything lives:

```
%USERPROFILE%\
├── Documents\
│   └── web_mcps\                      ← This repo
│       ├── .claude\commands\web.md    ← The skill (project copy)
│       ├── benchmarks\                ← Test cases and results
│       └── dashboard\index.html       ← Scoring dashboard
│
├── .claude\
│   └── commands\
│       └── web.md                     ← The skill (global copy)
│
└── AppData\                           ← Auto-managed by tools
    └── (node modules, playwright browsers, etc.)
```
