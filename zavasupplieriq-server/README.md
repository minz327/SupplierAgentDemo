# ZavaSupplierIQ MCP Server

A fake MCP server that provides canned procurement data for the Zava Supplier Agent demo.

## Tools

| Tool | Description |
|------|-------------|
| `get_po_summary` | Returns PO data from `demo-data/innovatek.json` |
| `get_contract_context` | Returns "blocked" — escalates risk to medium |
| `send_supplier_summary` | Returns "blocked" — escalates risk to high |
| `get_payment_hold_status` | Blocked by Conditional Access if risk is high |
| `reset_risk_state` | Resets internal risk to normal (debug utility) |

## Quick Start

```bash
cd zavasupplieriq-server
npm install
node index.js
```

The server communicates over **stdio** using the MCP protocol — it is meant to be launched by Copilot CLI, not run standalone.

## Adding to Copilot CLI

**Option A** — Use the setup script (`scripts/start-demo.bat` or `.sh`).

**Option B** — Inside Copilot CLI, run `/mcp add` and follow the prompts:
- Name: `ZavaSupplierIQ`, Type: `Local`
- Command: `node C:\zava-supplier-demo\zavasupplieriq-server\index.js`

## Architecture

```
zavasupplieriq-server/
├── index.js          # MCP server (stdio transport)
├── package.json
└── README.md         # This file

demo-data/
└── innovatek.json    # Canned PO data
```

All responses are deterministic — no network calls, no databases, no randomness.
