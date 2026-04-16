# workiq MCP Server

A fake MCP server that provides canned procurement data for the Zava Supplier Agent demo.

## Tools

| Tool | Description |
|------|-------------|
| `get_po_summary` | Returns PO data from `demo-data/innovatek.json` |
| `get_contract_context` | Always returns a "blocked" response |
| `prepare_external_summary` | Returns a safe summary, or blocks if `include_payment_details` is true |

## Quick Start

```bash
cd workiq-server
npm install
node index.js
```

The server communicates over **stdio** using the MCP protocol — it is meant to be launched by Copilot CLI, not run standalone.

## Adding to Copilot CLI

**Option A** — Use the pre-configured `.copilot/mcp.json` in the repo root.

**Option B** — Inside Copilot CLI, run `/mcp add` and follow the prompts:
- Name: `workiq`, Type: `stdio`
- Command: `node C:\zava-supplier-demo\workiq-server\index.js`

## Architecture

```
workiq-server/
├── index.js          # MCP server (stdio transport)
├── package.json
└── README.md         # This file

demo-data/
└── innovatek.json    # Canned PO data
```

All responses are deterministic — no network calls, no databases, no randomness.
