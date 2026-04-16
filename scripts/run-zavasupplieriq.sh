#!/usr/bin/env bash
# Start the ZavaSupplierIQ MCP server for the Zava Supplier Agent demo
set -e
cd "$(dirname "$0")/../zavasupplieriq-server"
echo "Installing dependencies..."
npm install --silent
echo "Starting ZavaSupplierIQ MCP server..."
node index.js
