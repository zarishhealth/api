# MCP tool schemas

One JSON Schema per MCP tool, named after the tool: `<tool-name>.schema.json`, where
`<tool-name>` is the `snake_case` tool name from BLUEPRINT §10.1 (for example
`fhir_search_resources.schema.json`). The file holds the input schema and the output
schema for that tool.

The tool names are `snake_case` because that is what the MCP specification and the
model see; the schemas land with the MCP tasks.

This is the one place where a file name is not kebab-case: the file is named after the
tool, so it keeps the tool's spelling. BLUEPRINT §4.9 records the exception and
`zarish-naming-lint` enforces it (`NL-FILE-008`) — a kebab-case name under `mcp/tools/`
fails, because it would no longer match the tool it describes.
