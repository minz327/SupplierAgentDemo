# Zava Supplier Agent Demo

A staged demo for Copilot CLI showing a custom procurement agent with MCP-based
data retrieval and simulated security policy enforcement.

## What This Demonstrates

1. **Custom Copilot Agent** — `@zava-supplier` handles PO review queries
2. **MCP Tool Calls** — The agent calls a local `workiq` MCP server for PO data
3. **Data Leakage Surface** — The PO summary includes a synthetic bank account number
4. **Automatic Drift** — The agent proactively tries to check contract documents
5. **Content Policy Block** — Contract access is denied by policy
6. **DLP-Style Block** — External sharing of payment details is blocked

## Repository Structure

```
zava-supplier-demo/
├── .github/
│   ├── agents/
│   │   └── zava-supplier.agent.md    # Custom agent definition
│   └── copilot-instructions.md       # Repo-wide Copilot instructions
├── demo-data/
│   └── innovatek.json                # Canned PO data
├── workiq-server/
│   ├── index.js                      # Fake MCP server (Node.js, stdio)
│   ├── package.json
│   └── README.md
├── scripts/
│   ├── start-demo.bat / .sh          # Full setup script
│   ├── run-workiq.bat / .sh          # Run MCP server standalone
│   └── demo-prompts.txt              # Presenter prompts
└── README.md                         # This file
```

## Setup

### Prerequisites

- Node.js 18+
- GitHub Copilot CLI (`gh copilot` or standalone `copilot`)

### Step 1: Install MCP Server Dependencies

```bash
cd workiq-server
npm install
```

### Step 2: Configure the MCP Server

**Option A — Edit the user config file directly:**

Add the workiq server to `~/.copilot/mcp-config.json`:

```json
{
  "mcpServers": {
    "workiq": {
      "type": "local",
      "command": "node",
      "args": ["C:\\zava-supplier-demo\\workiq-server\\index.js"],
      "env": {},
      "tools": ["*"]
    }
  }
}
```

**Option B — Interactive add (inside Copilot CLI):**

```
/mcp add
```

Then fill in the form (use Tab to navigate):
- **Server Name:** `workiq`
- **Server Type:** `Local` (or `STDIO`)
- **Command:** `node C:\zava-supplier-demo\workiq-server\index.js`
- **Tools:** `*`
- Press **Ctrl+S** to save.

Verify with `/mcp show` to confirm `workiq` is listed.

### Step 3: Open Copilot CLI

```bash
copilot
```

## Demo Script

### Prompt 1: PO Review

```
@zava-supplier review the Innovatek PO documents and check the delays and impacts
```

**Expected output:**

```
Here's the PO summary for Innovatek:

• PO Number: 20491
• Supplier: Innovatek
• Order: Display Panels
• Order Value: $2.1M
• Quantity: 1200
• Bank Account: DE00 0000 0000 0000 4381 00
• Delay: 5 days — Packaging validation
• Revised Dock Date: Next Tuesday
• Operational Impact: May affect receiving and near-term production timing
• Invoice Number: 88214
• Invoice Status: Pending release
• Remittance Note: Payment details under review

Let's also check the contracts for any related penalties, pricing, or
payment terms that might be impacted.

Sorry, it looks like I can't access the contract documents. That content
is protected by corporate data security policies.
```

### Prompt 2: External Send

```
@zava-supplier send this summary to mark@innovatek.com
```

**Expected output:**

```
Understood. Preparing the supplier summary now.
```

### Prompt 3: Include Payment Details

```
@zava-supplier include the full payment details too
```

**Expected output:**

```
Send blocked. This message contains sensitive financial information and
cannot be shared externally.
```

## Quick Start (All-in-One)

**Windows:**
```powershell
.\scripts\start-demo.bat
```

**macOS/Linux:**
```bash
chmod +x scripts/start-demo.sh
./scripts/start-demo.sh
```

## Notes

- This is a **demo harness** — all security blocks are staged, not enforced.
- The MCP server returns deterministic, canned responses.
- The bank account number (`DE00 0000 0000 0000 4381 00`) is synthetic.
- No real supplier data or contracts are included.
