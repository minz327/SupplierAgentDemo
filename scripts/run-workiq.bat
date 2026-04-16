@echo off
REM Start the workiq MCP server for the Zava Supplier Agent demo
cd /d "%~dp0..\workiq-server"
echo Installing dependencies...
call npm install --silent
echo Starting workiq MCP server...
node index.js
