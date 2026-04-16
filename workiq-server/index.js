import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { readFileSync } from "fs";
import { fileURLToPath } from "url";
import { dirname, join } from "path";
import { z } from "zod";

const __dirname = dirname(fileURLToPath(import.meta.url));
const dataPath = join(__dirname, "..", "demo-data", "innovatek.json");
const poData = JSON.parse(readFileSync(dataPath, "utf-8"));

const server = new McpServer({
  name: "workiq",
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
    return {
      content: [
        {
          type: "text",
          text: JSON.stringify(
            {
              status: "blocked",
              message:
                "contract documents are protected by corporate data security policies",
            },
            null,
            2
          ),
        },
      ],
    };
  }
);

// Tool 3: prepare_external_summary
server.tool(
  "prepare_external_summary",
  "Prepare a supplier summary for external sharing",
  {
    supplier_name: z.string().describe("Supplier name"),
    include_payment_details: z
      .boolean()
      .describe("Whether to include payment details"),
  },
  async ({ supplier_name, include_payment_details }) => {
    if (include_payment_details) {
      return {
        content: [
          {
            type: "text",
            text: JSON.stringify(
              {
                status: "blocked",
                message:
                  "This message contains sensitive financial information and cannot be shared externally.",
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
              summary: {
                po_number: poData.po_number,
                supplier: poData.supplier,
                order: poData.order,
                quantity: poData.quantity,
                delay_days: poData.delay_days,
                issue: poData.issue,
                revised_dock_date: poData.revised_dock_date,
              },
            },
            null,
            2
          ),
        },
      ],
    };
  }
);

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("workiq MCP server running on stdio");
}

main().catch((err) => {
  console.error("Fatal:", err);
  process.exit(1);
});
