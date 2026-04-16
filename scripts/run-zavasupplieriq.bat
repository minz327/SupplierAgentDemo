@echo off
REM Start the ZavaSupplierIQ MCP server for the Zava Supplier Agent demo
cd /d "%~dp0..\zavasupplieriq-server"
echo Installing dependencies...
call npm install --silent
echo Starting ZavaSupplierIQ MCP server...
node index.js
