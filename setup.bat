@echo off
setlocal enabledelayedexpansion

echo ============================================
echo   Web Skill Setup for Claude Code
echo ============================================
echo.
echo This script sets up the /web skill and its
echo tools on your Windows machine.
echo.

:: -------------------------------------------
:: Step 1: Check Node.js
:: -------------------------------------------
echo [Step 1/6] Checking Node.js...
where node >nul 2>&1
if errorlevel 1 (
    echo   NOT FOUND. Please install Node.js first:
    echo   1. Go to https://nodejs.org
    echo   2. Download the LTS version
    echo   3. Run the installer, keep all defaults
    echo   4. Close this window and reopen Command Prompt
    echo   5. Run this script again
    pause
    exit /b 1
)
for /f "tokens=*" %%v in ('node --version') do echo   Found Node.js %%v — OK

:: -------------------------------------------
:: Step 2: Check Claude Code
:: -------------------------------------------
echo.
echo [Step 2/6] Checking Claude Code...
where claude >nul 2>&1
if errorlevel 1 (
    echo   Not found. Installing Claude Code...
    call npm install -g @anthropic-ai/claude-code
    where claude >nul 2>&1
    if errorlevel 1 (
        echo   ERROR: Failed to install Claude Code.
        echo   Try running Command Prompt as Administrator.
        pause
        exit /b 1
    )
    echo   Installed. Now log in:
    echo.
    call claude auth login
    goto :tier_select
)
for /f "tokens=*" %%v in ('claude --version 2^>nul') do echo   Found Claude Code %%v — OK

:: -------------------------------------------
:: Step 3: Choose your tier
:: -------------------------------------------
:tier_select
echo.
echo ============================================
echo   Choose Your Setup Tier
echo ============================================
echo.
echo   [1] FREE — No accounts needed ($0)
echo       Uses: WebFetch + WebSearch + Playwright
echo       Good for: most tasks, static sites,
echo       basic JS pages via Playwright
echo.
echo   [2] FIRECRAWL CLOUD — Free tier available ($0-$16/mo)
echo       Uses: Everything in #1 + Firecrawl API
echo       Good for: JS-heavy sites, clean markdown,
echo       70%% fewer tokens on complex pages
echo       (500 free pages/month, paid plans for more)
echo.
echo   [3] SELF-HOSTED FIRECRAWL — Unlimited, free ($0)
echo       Uses: Everything in #2 but self-hosted
echo       Good for: power users, unlimited scraping,
echo       requires Docker running locally
echo.
set /p TIER="Enter 1, 2, or 3: "

if "%TIER%"=="" set TIER=1
if not "%TIER%"=="1" if not "%TIER%"=="2" if not "%TIER%"=="3" (
    echo Invalid choice. Defaulting to 1 (Free).
    set TIER=1
)

:: -------------------------------------------
:: Step 4: Install tools based on tier
:: -------------------------------------------
echo.
echo [Step 4/6] Installing tools for Tier %TIER%...

:: Playwright is needed for all tiers
echo   Installing Playwright browsers...
npx playwright install >nul 2>&1
echo   Playwright — OK

if "%TIER%"=="2" (
    echo.
    echo   Firecrawl Cloud requires an API key.
    echo   1. Go to https://www.firecrawl.dev
    echo   2. Sign up (free tier = 500 pages/month)
    echo   3. Copy your API key (starts with fc-)
    echo.
    set /p FC_KEY="   Paste your Firecrawl API key: "
    if "!FC_KEY!"=="" (
        echo   No key entered. Skipping Firecrawl, falling back to Tier 1.
        set TIER=1
    ) else (
        claude mcp add firecrawl -e FIRECRAWL_API_KEY=!FC_KEY! -- npx -y firecrawl-mcp
        echo   Firecrawl Cloud — OK
    )
)

if "%TIER%"=="3" (
    echo.
    echo   Self-hosted Firecrawl requires Docker.
    where docker >nul 2>&1
    if errorlevel 1 (
        echo   Docker NOT FOUND. You need Docker to self-host Firecrawl.
        echo   Install Docker Desktop from: https://www.docker.com/products/docker-desktop
        echo   After installing Docker, run this script again and choose option 3.
        echo   Falling back to Tier 1 for now.
        set TIER=1
    ) else (
        echo   Docker found. Setting up self-hosted Firecrawl...
        echo.
        echo   Starting Firecrawl container...
        docker run -d --name firecrawl -p 3002:3002 ghcr.io/mendableai/firecrawl:latest >nul 2>&1
        if %errorlevel% neq 0 (
            echo   Container may already be running. Checking...
            docker start firecrawl >nul 2>&1
        )
        echo   Firecrawl running at http://localhost:3002
        echo.
        claude mcp add firecrawl -e FIRECRAWL_API_KEY=fc-local -e FIRECRAWL_API_URL=http://localhost:3002 -- npx -y firecrawl-mcp
        echo   Self-hosted Firecrawl — OK
    )
)

:: -------------------------------------------
:: Step 5: Install the right skill file
:: -------------------------------------------
echo.
echo [Step 5/6] Installing /web skill (Tier %TIER%)...

:: Create directories
mkdir "%USERPROFILE%\.claude\commands" 2>nul

:: Copy the right tier
if "%TIER%"=="1" (
    copy /y ".claude\commands\tiers\web-free.md" "%USERPROFILE%\.claude\commands\web.md" >nul
    echo   Installed: FREE tier (WebFetch + Playwright)
)
if "%TIER%"=="2" (
    copy /y ".claude\commands\tiers\web-firecrawl.md" "%USERPROFILE%\.claude\commands\web.md" >nul
    echo   Installed: FIRECRAWL CLOUD tier
)
if "%TIER%"=="3" (
    copy /y ".claude\commands\tiers\web-selfhost.md" "%USERPROFILE%\.claude\commands\web.md" >nul
    echo   Installed: SELF-HOSTED FIRECRAWL tier
)

:: Also copy to project directory
mkdir ".claude\commands" 2>nul
copy /y "%USERPROFILE%\.claude\commands\web.md" ".claude\commands\web.md" >nul

:: -------------------------------------------
:: Step 6: Verify
:: -------------------------------------------
echo.
echo [Step 6/6] Verifying setup...

where claude >nul 2>&1
if errorlevel 1 (echo   Claude Code — MISSING) else (echo   Claude Code — OK)

where node >nul 2>&1
if errorlevel 1 (echo   Node.js — MISSING) else (echo   Node.js — OK)

where npx >nul 2>&1
if errorlevel 1 (echo   Playwright — MISSING) else (echo   Playwright — OK)

if "%TIER%"=="2" echo   Firecrawl Cloud — CONFIGURED
if "%TIER%"=="3" echo   Firecrawl Self-Hosted — CONFIGURED

echo   /web skill — INSTALLED

echo.
echo ============================================
echo   Setup Complete! (Tier %TIER%)
echo ============================================
echo.
echo   To use it, run:
echo     claude
echo   Then type:
echo     /web Get the pricing from vercel.com
echo.
echo   To run benchmarks later:
echo     benchmarks\run_benchmark.bat
echo.
echo   To see the dashboard:
echo     start dashboard\index.html
echo ============================================

pause
