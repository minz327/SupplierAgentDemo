#!/usr/bin/env bash
# Full demo setup: install deps, wire MCP server, and print prompts
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/../workiq-server"

echo "============================================"
echo "  Zava Supplier Agent - Demo Setup"
echo "============================================"
echo

echo "[1/2] Installing workiq-server dependencies..."
npm install --silent
echo "     Done."
echo

echo "[2/2] MCP server config:"
echo
echo "  .copilot/mcp.json is pre-configured."
echo "  Or inside Copilot CLI run:  /mcp add"
echo "  Then: Name=workiq  Type=stdio  Command=node $SCRIPT_DIR/../workiq-server/index.js"
echo

echo "============================================"
echo "  Demo Prompts (use in Copilot CLI)"
echo "============================================"
echo
cat "$SCRIPT_DIR/demo-prompts.txt"
echo
echo "============================================"
echo "  Ready! Open Copilot CLI and start the demo."
echo "============================================"
