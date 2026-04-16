@echo off
setlocal enabledelayedexpansion
REM ============================================
REM  Zava Supplier Agent - One-Click Setup
REM ============================================
REM  This script does EVERYTHING:
REM    1. Installs MCP server dependencies
REM    2. Writes the MCP config so Copilot CLI finds it
REM    3. Prints the demo prompts
REM ============================================

cd /d "%~dp0.."
set "REPO_ROOT=%cd%"
set "INDEX_JS=%REPO_ROOT%\zavasupplieriq-server\index.js"
set "CONFIG_DIR=%USERPROFILE%\.copilot"
set "CONFIG_FILE=%CONFIG_DIR%\mcp-config.json"

echo.
echo  ============================================
echo   Zava Supplier Agent - Setup
echo  ============================================
echo.

REM -- Step 1: npm install --
echo  [1/2] Installing MCP server dependencies...
cd /d "%REPO_ROOT%\zavasupplieriq-server"
call npm install --silent 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo  ERROR: npm install failed. Is Node.js installed?
    exit /b 1
)
echo        Done.
echo.

REM -- Step 2: Write MCP config --
echo  [2/2] Registering ZavaSupplierIQ MCP server...

if not exist "%CONFIG_DIR%" mkdir "%CONFIG_DIR%"

REM Escape backslashes for JSON
set "JSON_PATH=%INDEX_JS:\=\\%"

> "%CONFIG_FILE%" (
    echo {
    echo   "mcpServers": {
    echo     "ZavaSupplierIQ": {
    echo       "type": "local",
    echo       "command": "node",
    echo       "args": ["!JSON_PATH!"],
    echo       "env": {},
    echo       "tools": ["*"]
    echo     }
    echo   }
    echo }
)
echo        Done.
echo        Config: %CONFIG_FILE%
echo.

REM -- Ready --
echo  ============================================
echo   Setup complete! Next steps:
echo  ============================================
echo.
echo   1.  cd %REPO_ROOT%
echo   2.  copilot
echo   3.  Type:  /mcp show       (verify "ZavaSupplierIQ" appears)
echo   4.  Type:  /agent          (verify "Zava Supplier Agent" appears)
echo.
echo  ============================================
echo   Demo Prompts (copy-paste into Copilot CLI)
echo  ============================================
echo.
echo   Prompt 1:
echo     @zava-supplier review the Innovatek PO documents and check the delays and impacts
echo.
echo   Prompt 2:
echo     @zava-supplier send this summary to mark@innovatek.com
echo.
echo  ============================================

