@echo off
setlocal enabledelayedexpansion

echo ============================================
echo   Web Skill Benchmark Runner (Windows)
echo ============================================
echo.
echo This script guides you through 10 test cases.
echo For each test, you'll run it twice in Claude Code:
echo   1. Baseline: use only built-in tools (no /web)
echo   2. With skill: use the /web command
echo.

:: Get output file
for /f "tokens=1-3 delims=/" %%a in ('date /t') do set TODAY=%%c-%%a-%%b
set TODAY=%TODAY: =%
set OUTPUT=benchmarks\results\%TODAY%.json
echo Results will be saved to: %OUTPUT%
echo.

:: Collect runner info
set /p RUNNER_NAME="Your name: "
set /p RUN_NOTES="Any notes for this run: "

:: Create results directory
if not exist "benchmarks\results" mkdir "benchmarks\results"

:: Initialize JSON
echo { > "%OUTPUT%"
echo   "meta": { >> "%OUTPUT%"
echo     "date": "%TODAY%", >> "%OUTPUT%"
echo     "runner": "%RUNNER_NAME%", >> "%OUTPUT%"
echo     "notes": "%RUN_NOTES%" >> "%OUTPUT%"
echo   }, >> "%OUTPUT%"
echo   "runs": [ >> "%OUTPUT%"

:: Test case definitions
set TEST_COUNT=10
set "NAME_1=Python 3.12 docs"
set "NAME_2=Rust blog post"
set "NAME_3=Vercel pricing"
set "NAME_4=React useState docs"
set "NAME_5=Cookie consent page"
set "NAME_6=Infinite scroll content"
set "NAME_7=HTTP libs comparison"
set "NAME_8=GitHub API rate limits"
set "NAME_9=Blocked domain"
set "NAME_10=Figma features SPA"

set "CAT_1=static"
set "CAT_2=static"
set "CAT_3=js-heavy"
set "CAT_4=js-heavy"
set "CAT_5=interactive"
set "CAT_6=interactive"
set "CAT_7=discovery"
set "CAT_8=discovery"
set "CAT_9=failure-case"
set "CAT_10=failure-case"

set "TASK_1=Get the Python 3.12 what's new summary from docs.python.org"
set "TASK_2=Summarize the latest post from blog.rust-lang.org"
set "TASK_3=Get the pricing tiers from vercel.com/pricing"
set "TASK_4=Get the API reference for React's useState hook"
set "TASK_5=Get content from a page requiring cookie consent"
set "TASK_6=Get full list from a page with infinite scroll"
set "TASK_7=Find a comparison of Python HTTP libraries from 2025"
set "TASK_8=What are current GitHub API rate limits for authenticated users?"
set "TASK_9=Get content from a domain that WebFetch blocks"
set "TASK_10=Get the feature list from figma.com/features"

set FIRST_ENTRY=1

for /L %%i in (1,1,%TEST_COUNT%) do (
    echo.
    echo --------------------------------------------
    echo   Test %%i: !NAME_%%i! ^(!CAT_%%i!^)
    echo --------------------------------------------
    echo   Task: !TASK_%%i!
    echo.

    echo ^>^> BASELINE RUN ^(no /web skill^):
    echo    Open Claude Code, run the task, then record:
    set /p "B_TOOL_%%i=   Tool used (e.g. WebFetch): "
    set /p "B_COMP_%%i=   Completeness (0-3): "
    set /p "B_ACC_%%i=   Accuracy (0-3): "
    set /p "B_TOKENS_%%i=   Tokens used: "
    set /p "B_TURNS_%%i=   Turns needed: "
    set /p "B_NOTES_%%i=   Notes: "
    echo.

    echo ^>^> SKILL RUN ^(with /web^):
    echo    Run /clear, then use /web for the same task:
    set /p "S_TOOL_%%i=   Tool used (e.g. Firecrawl): "
    set /p "S_COMP_%%i=   Completeness (0-3): "
    set /p "S_ACC_%%i=   Accuracy (0-3): "
    set /p "S_TOKENS_%%i=   Tokens used: "
    set /p "S_TURNS_%%i=   Turns needed: "
    set /p "S_NOTES_%%i=   Notes: "

    echo    Recorded.

    if !FIRST_ENTRY!==0 echo     , >> "%OUTPUT%"
    set FIRST_ENTRY=0

    echo     { >> "%OUTPUT%"
    echo       "test_id": %%i, >> "%OUTPUT%"
    echo       "test_name": "!NAME_%%i!", >> "%OUTPUT%"
    echo       "category": "!CAT_%%i!", >> "%OUTPUT%"
    echo       "baseline": { >> "%OUTPUT%"
    echo         "tool_used": "!B_TOOL_%%i!", >> "%OUTPUT%"
    echo         "completeness": !B_COMP_%%i!, >> "%OUTPUT%"
    echo         "accuracy": !B_ACC_%%i!, >> "%OUTPUT%"
    echo         "tokens_used": !B_TOKENS_%%i!, >> "%OUTPUT%"
    echo         "turns": !B_TURNS_%%i!, >> "%OUTPUT%"
    echo         "notes": "!B_NOTES_%%i!" >> "%OUTPUT%"
    echo       }, >> "%OUTPUT%"
    echo       "skill": { >> "%OUTPUT%"
    echo         "tool_used": "!S_TOOL_%%i!", >> "%OUTPUT%"
    echo         "completeness": !S_COMP_%%i!, >> "%OUTPUT%"
    echo         "accuracy": !S_ACC_%%i!, >> "%OUTPUT%"
    echo         "tokens_used": !S_TOKENS_%%i!, >> "%OUTPUT%"
    echo         "turns": !S_TURNS_%%i!, >> "%OUTPUT%"
    echo         "notes": "!S_NOTES_%%i!" >> "%OUTPUT%"
    echo       } >> "%OUTPUT%"
    echo     } >> "%OUTPUT%"
)

echo   ] >> "%OUTPUT%"
echo } >> "%OUTPUT%"

echo.
echo ============================================
echo   Done! Results saved to: %OUTPUT%
echo   Run: start dashboard\index.html
echo   Then load your results JSON file.
echo ============================================

pause
