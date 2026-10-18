# MCP tool schemas

One JSON Schema per MCP tool, named after the tool: `<tool-name>.schema.json`, where
`<tool-name>` is the `snake_case` tool name from BLUEPRINT §10.1 (for example
`fhir_search_resources.schema.json`). The file holds the input schema and the output
schema for that tool.

The tool names are `snake_case` because that is what the MCP specification and the
model see; the schemas land with the MCP tasks.
