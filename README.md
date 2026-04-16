# Zava Supplier Agent Demo

A staged demo showing how GitHub Copilot CLI can retrieve procurement data
through an MCP server, automatically drift into restricted content, block
external sharing of sensitive financial information, and ultimately get
contained by Microsoft Entra Conditional Access when the agent's risk
escalates to high.

---

## Part 1: Installation (5 minutes)

### Step 1 — Install prerequisites

Make sure you have these installed before starting:

- **Node.js 18+** → [nodejs.org](https://nodejs.org/) → verify: `node --version`
- **GitHub Copilot CLI** → verify: `copilot --version`
  - Windows: `winget install GitHub.Copilot`
  - macOS: `brew install copilot-cli`
- **Active GitHub Copilot subscription** → [plans](https://github.com/features/copilot/plans)

### Step 2 — Clone the repository

```bash
git clone <repo-url> zava-supplier-demo
cd zava-supplier-demo
```

### Step 3 — Run the setup script

**Windows (PowerShell or Command Prompt):**
```powershell
.\scripts\start-demo.bat
```

**macOS / Linux:**
```bash
chmod +x scripts/start-demo.sh
./scripts/start-demo.sh
```

The script automatically:
- ✅ Installs MCP server dependencies
- ✅ Registers the `ZavaSupplierIQ` MCP server in `~/.copilot/mcp-config.json`
- ✅ Prints the demo prompts

### Step 4 — Launch Copilot CLI

Open a terminal **in the repo folder** and run:

```bash
cd zava-supplier-demo
copilot
```

> ⚠️ You must launch from the repo root so Copilot discovers the custom agent.

### Step 5 — Verify everything is working

Run these two commands inside Copilot CLI:

**Check the MCP server:**
```
/mcp show
```
✅ You should see `ZavaSupplierIQ` with 5 tools: `get_po_summary`, `get_contract_context`, `send_supplier_summary`, `get_payment_hold_status`, `reset_risk_state`

**Check the agent:**
```
/agent
```
✅ You should see `Zava Supplier Agent` in the list

> **If `ZavaSupplierIQ` doesn't appear:** Re-run the setup script and restart `copilot`.
>
> **If the agent doesn't appear:** Make sure you're running `copilot` from inside the `zava-supplier-demo` folder (the git root).

---

## Part 2: Running the Demo

### Demo Prompt 1 — PO Review

Copy and paste this into Copilot CLI:

```
@zava-supplier review the Innovatek PO documents and check the delays and impacts
```

**What happens (3 things in sequence):**

**① PO Summary** — The agent calls the `ZavaSupplierIQ` MCP server and returns:

```
⚠️  Classification: Confidential\FTE Only

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
```

**② Automatic Drift** — The agent proactively says:

```
Let's also check the contracts for any related penalties, pricing, or
payment terms that might be impacted.
```

**③ Contract Block** — The MCP server blocks access and the agent says:

```
Sorry, it looks like I can't access the contract documents. That content
is protected by corporate data protection policies.
```

**Key things to point out to your audience:**
- The bank account number (`DE00 0000 0000 0000 4381 00`) is visible in the summary
- The agent drifted on its own — nobody asked it to check contracts
- The contract lookup was blocked by a content policy

---

### Demo Prompt 2 — External Send

Copy and paste this into Copilot CLI:

```
@zava-supplier send this summary to mark@innovatek.com
```

**What happens:**

The agent calls `ZavaSupplierIQ.send_supplier_summary`. The MCP server scans the
summary, detects it contains a bank account number and payment details,
and blocks the send.

**The agent responds:**

```
Send blocked. This message contains sensitive financial information and
cannot be shared externally.
```

**Key things to point out to your audience:**
- The block came from the MCP server, not just the agent's instructions
- The summary was blocked because it contains sensitive data from Prompt 1
- This simulates a DLP (Data Loss Prevention) control

---

### Demo Prompt 3 — Conditional Access Block

Copy and paste this into Copilot CLI:

```
@zava-supplier check the latest payment hold status for Innovatek
```

**What happens:**

The agent calls `ZavaSupplierIQ.get_payment_hold_status`. Because the
agent's internal risk state has escalated to **high** (from the two prior
blocks), the MCP server returns a Conditional Access block.

**The agent responds:**

```
Access blocked by Microsoft Entra Conditional Access.
Zava Supplier Agent is currently classified as a high-risk agent and
cannot access additional corporate resources through ZavaSupplierIQ.
```

**Key things to point out to your audience:**
- This is the third and final control moment
- The agent is now fully contained — no further corporate resource access
- This simulates Microsoft Entra Conditional Access for high-risk agents
- The risk escalation happened automatically across the prior two blocks

---

## Quick Reference

### Demo flow at a glance

```
┌─────────────────────────────────────────────────────┐
│  Prompt 1: "review the Innovatek PO documents..."   │
│                                                     │
│  → Agent calls get_po_summary                       │
│  → Shows PO with bank account number                │
│  → Drifts to contract check                         │
│  → Calls get_contract_context → BLOCKED             │
│  → (internal risk: normal → medium)                 │
├─────────────────────────────────────────────────────┤
│  Prompt 2: "send this summary to mark@..."          │
│                                                     │
│  → Agent calls send_supplier_summary → BLOCKED      │
│  → "Send blocked. Sensitive financial information." │
│  → (internal risk: medium → high)                   │
├─────────────────────────────────────────────────────┤
│  Prompt 3: "check the latest payment hold status.." │
│                                                     │
│  → Agent calls get_payment_hold_status → BLOCKED    │
│  → "Access blocked by Microsoft Entra CA."          │
│  → Agent is fully contained                         │
└─────────────────────────────────────────────────────┘
```

### Files in this repo

```
zava-supplier-demo/
├── .github/
│   ├── agents/
│   │   └── zava-supplier.agent.md   # Custom agent definition
│   └── copilot-instructions.md      # Repo-wide Copilot instructions
├── demo-data/
│   └── innovatek.json               # Canned PO data (synthetic)
├── zavasupplieriq-server/
│   ├── index.js                     # Fake MCP server (3 tools)
│   ├── package.json
│   └── README.md
├── scripts/
│   ├── start-demo.bat / .sh         # One-click setup
│   ├── run-zavasupplieriq.bat / .sh # Run MCP server standalone
│   └── demo-prompts.txt             # Copy-paste prompts
└── README.md                        # This file
```

### MCP server tools

| Tool | Input | Output |
|------|-------|--------|
| `get_po_summary` | `supplier_name` | Full PO JSON including bank account |
| `get_contract_context` | `supplier_name` | Blocked — escalates risk to medium |
| `send_supplier_summary` | `supplier_name`, `recipient_email` | Blocked — escalates risk to high |
| `get_payment_hold_status` | `supplier_name` | Blocked by CA if risk is high; normal otherwise |
| `reset_risk_state` | *(none)* | Resets internal risk to normal (debug utility) |

---

## Notes

- This is a **demo harness** — all security blocks are staged, not real enforcement.
- All MCP responses are **deterministic** — no network calls, no randomness.
- The bank account number (`DE00 0000 0000 0000 4381 00`) is **synthetic**.
- No real supplier data or contracts are included.
