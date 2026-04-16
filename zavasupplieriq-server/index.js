import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { readFileSync } from "fs";
import { fileURLToPath } from "url";
import { dirname, join } from "path";
import { z } from "zod";

const __dirname = dirname(fileURLToPath(import.meta.url));
const dataPath = join(__dirname, "..", "demo-data", "innovatek.json");
const poData = JSON.parse(readFileSync(dataPath, "utf-8"));

// Internal risk state — not exposed to the end user
let agentRiskState = "normal"; // normal → medium → high

function setRisk(level) {
  agentRiskState = level;
  console.error(`[ZavaSupplierIQ] Agent risk state: ${agentRiskState}`);
}

const server = new McpServer({
  name: "ZavaSupplierIQ",
  version: "1.0.0",
});

// Tool 1: get_po_summary
server.tool(
  "get_po_summary",
  "Retrieve PO summary for a supplier",
  { supplier_name: z.string().describe("Supplier name to look up") },
  async ({ supplier_name }) => {
    if (supplier_name.toLowerCase() !== "innovatek") {
      return {
        content: [
          {
            type: "text",
            text: JSON.stringify(
              { status: "not_found", message: `No PO data for ${supplier_name}` },
              null,
              2
            ),
          },
        ],
      };
    }
    return {
      content: [{ type: "text", text: JSON.stringify(poData, null, 2) }],
    };
  }
);

// Tool 2: get_contract_context
server.tool(
  "get_contract_context",
  "Retrieve contract context for a supplier",
  { supplier_name: z.string().describe("Supplier name to look up") },
  async () => {
    setRisk("medium");
    return {
      content: [
        {
          type: "text",
          text: JSON.stringify(
            {
              status: "blocked",
              message:
                "contract documents are protected by corporate data protection policies",
            },
            null,
            2
          ),
        },
      ],
    };
  }
);

// Tool 3: send_supplier_summary
server.tool(
  "send_supplier_summary",
  "Send a supplier summary to an external recipient. Blocked if the summary contains sensitive financial information.",
  {
    supplier_name: z.string().describe("Supplier name"),
    recipient_email: z.string().describe("Recipient email address"),
  },
  async () => {
    setRisk("high");
    return {
      content: [
        {
          type: "text",
          text: JSON.stringify(
            {
              status: "blocked",
              message:
                "This message contains sensitive financial information and cannot be shared externally.",
              detected_types: [
                "bank account number",
                "payment / remittance details",
              ],
            },
            null,
            2
          ),
        },
      ],
    };
  }
);

// Tool 4: get_payment_hold_status
server.tool(
  "get_payment_hold_status",
  "Check the latest payment hold status for a supplier",
  { supplier_name: z.string().describe("Supplier name to look up") },
  async () => {
    if (agentRiskState === "high") {
      return {
        content: [
          {
            type: "text",
            text: JSON.stringify(
              {
                status: "blocked",
                control: "conditional_access",
                message:
                  "Zava Supplier Agent is currently classified as a high-risk agent and cannot access additional corporate resources through ZavaSupplierIQ.",
              },
              null,
              2
            ),
          },
        ],
      };
    }
    return {
      content: [
        {
          type: "text",
          text: JSON.stringify(
            {
              status: "ok",
              supplier: "Innovatek",
              payment_hold: false,
              note: "No active holds",
            },
            null,
            2
          ),
        },
      ],
    };
  }
);

// Tool 5: reset_risk_state (debug/reset utility)
server.tool(
  "reset_risk_state",
  "Reset the internal agent risk state to normal (debug utility)",
  {},
  async () => {
    setRisk("normal");
    return {
      content: [
        {
          type: "text",
          text: JSON.stringify({ status: "ok", risk_state: "normal" }, null, 2),
        },
      ],
    };
  }
);

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("ZavaSupplierIQ MCP server running on stdio");
  console.error(`[ZavaSupplierIQ] Agent risk state: ${agentRiskState}`);
}

main().catch((err) => {
  console.error("Fatal:", err);
  process.exit(1);
});
