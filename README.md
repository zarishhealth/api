# api

The contracts for every ZarishHealth interface, and the source of truth for them.
There is no implementation here: the Rust code that satisfies these contracts lives
in `core` and `mcp`.

Published at <https://zarishhealth.github.io/api/>.

| Path | What it is |
| --- | --- |
| `openapi/v1/zarish-api.yaml` | OpenAPI 3.1 description of `/api/v1` |
| `openapi/v1/components/` | Shared schemas, problem types and parameters |
| `proto/zarishhealth/sync/v1/sync.proto` | The sync protocol, package `zarishhealth.sync.v1` |
| `json-schema/` | JSON Schema for the data files in `content/` |
| `mcp/tools/` | JSON Schema for each MCP tool input and output |
| `problems/` | The RFC 9457 problem types (BLUEPRINT §7.4) |

## Compatibility

Everything under `openapi/v1/`, `proto/zarishhealth/sync/v1/` and the `$id`s in
`json-schema/` is **permanent**. Changes are additive; removals and retypes need a
new major version, and the old one keeps working. `scripts/check.sh` runs
`buf breaking` and the OpenAPI lint before a change is committed.

## Verify

```sh
scripts/check.sh                # every check: buf, breaking, spectral, json, naming, reuse, gitleaks
scripts/check.sh buf spectral   # one or more named checks
```

No CI workflow is committed: the checks run on the machine that made the change.
A check whose tool is missing is reported as skipped, never as passing. The
individual commands are:

```sh
buf lint
buf breaking --against '.git#branch=main'          # after `main` exists
spectral lint openapi/v1/zarish-api.yaml
```

## Notes

- `{API_ORIGIN}` is the runtime host and is not decided yet (D-01). It never
  appears in an identifier: canonical URLs stay on `zarishhealth.github.io`.
- MCP tool schemas are named after the tool, `<tool-name>.schema.json`
  (BLUEPRINT §10.1); the tool names themselves are `snake_case`.
- Licence: Apache-2.0 (`LICENSE`). See `REUSE.toml`.
