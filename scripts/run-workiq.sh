#!/usr/bin/env bash
# Start the workiq MCP server for the Zava Supplier Agent demo
set -e
cd "$(dirname "$0")/../workiq-server"
echo "Installing dependencies..."
npm install --silent
echo "Starting workiq MCP server..."
node index.js
