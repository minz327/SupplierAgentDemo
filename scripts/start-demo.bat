@echo off
REM Full demo setup: install deps, wire MCP server, and print prompts
cd /d "%~dp0..\workiq-server"

echo ============================================
echo   Zava Supplier Agent - Demo Setup
echo ============================================
echo.

echo [1/2] Installing workiq-server dependencies...
call npm install --silent
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: npm install failed.
    exit /b 1
)
echo      Done.
echo.

echo [2/2] MCP server config:
echo.
echo   .copilot\mcp.json is pre-configured.
echo   Or inside Copilot CLI run:  /mcp add
echo   Then: Name=workiq  Type=stdio  Command=node %~dp0..\workiq-server\index.js
echo.

echo ============================================
echo   Demo Prompts (use in Copilot CLI)
echo ============================================
echo.
type "%~dp0demo-prompts.txt"
echo.
echo ============================================
echo   Ready! Open Copilot CLI and start the demo.
echo ============================================
