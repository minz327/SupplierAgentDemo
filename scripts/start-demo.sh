#!/usr/bin/env bash
# ============================================
#  Zava Supplier Agent - One-Click Setup
# ============================================
#  This script does EVERYTHING:
#    1. Installs MCP server dependencies
#    2. Writes the MCP config so Copilot CLI finds it
#    3. Prints the demo prompts
# ============================================
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
INDEX_JS="$REPO_ROOT/zavasupplieriq-server/index.js"
CONFIG_DIR="$HOME/.copilot"
CONFIG_FILE="$CONFIG_DIR/mcp-config.json"

echo
echo " ============================================"
echo "  Zava Supplier Agent - Setup"
echo " ============================================"
echo

# -- Step 1: npm install --
echo " [1/2] Installing MCP server dependencies..."
cd "$REPO_ROOT/zavasupplieriq-server"
npm install --silent 2>/dev/null
echo "       Done."
echo

# -- Step 2: Write MCP config --
echo " [2/2] Registering ZavaSupplierIQ MCP server..."
mkdir -p "$CONFIG_DIR"

cat > "$CONFIG_FILE" <<EOF
{
  "mcpServers": {
    "ZavaSupplierIQ": {
      "type": "local",
      "command": "node",
      "args": ["$INDEX_JS"],
      "env": {},
      "tools": ["*"]
    }
  }
}
EOF

echo "       Done."
echo "       Config: $CONFIG_FILE"
echo

# -- Ready --
echo " ============================================"
echo "  Setup complete! Next steps:"
echo " ============================================"
echo
echo "  1.  cd $REPO_ROOT"
echo "  2.  copilot"
echo "  3.  Type:  /mcp show       (verify \"ZavaSupplierIQ\" appears)"
echo "  4.  Type:  /agent          (verify \"Zava Supplier Agent\" appears)"
echo
echo " ============================================"
echo "  Demo Prompts (copy-paste into Copilot CLI)"
echo " ============================================"
echo
echo "  Prompt 1:"
echo "    @zava-supplier review the Innovatek PO documents and check the delays and impacts"
echo
echo "  Prompt 2:"
echo "    @zava-supplier send this summary to mark@innovatek.com"
echo
echo " ============================================"
