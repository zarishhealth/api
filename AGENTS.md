# AGENTS.md — api

**Scope:** this repository. The workspace rules are in
`/home/healthbgd/zarishhealth/GOVERNANCE.md`; where the two disagree, the stricter
rule wins.

Contracts only — no implementation. `openapi/v1/zarish-api.yaml` is the source of
truth for `/api/v1`, `proto/` for the sync protocol, `json-schema/` for data files
in `content/`, `mcp/tools/` for MCP tool inputs, `problems/` for the RFC 9457
problem types.

## Verify

```sh
scripts/check.sh                                   # buf, breaking, spectral, json, naming, reuse, gitleaks
scripts/check.sh buf spectral                      # one or more named checks
```

No workflow is committed. `buf breaking --against '.git#branch=main'` runs once the
repository has a `main` branch. A check whose tool is missing is reported as
skipped — never as passing.

## Cautions

- Never break `v1`: additive changes only. A breaking change needs a new major
  path (`v2`), and the old contract stays valid for ever.
- `$id`, `$schema` and problem-type URIs use the permanent
  `https://zarishhealth.github.io/...` bases, never `{API_ORIGIN}`.
- JSON keys are `camelCase`; Protobuf and query parameters are `snake_case`.
- No personal data in examples: use synthetic values only.
