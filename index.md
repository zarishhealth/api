---
title: ZarishHealth API contracts
---

# ZarishHealth API contracts

This site publishes the contract material for the ZarishHealth API. It is not a running
service: nothing here accepts a request. The live endpoints live on `{API_ORIGIN}`, which is
not decided yet.

## OpenAPI

- [OpenAPI 3.1 document](openapi/v1/zarish-api.yaml)

## JSON Schemas

Each schema carries a permanent `$id` under `https://zarishhealth.github.io/api/json-schema/`.

- [Clinical form](json-schema/clinical-form.schema.json)
- [Geography record](json-schema/geography-record.schema.json)
- [Registration rules](json-schema/registration-rules.schema.json)
- [Site configuration](json-schema/site-config.schema.json)

## MCP tool schemas

- [MCP tool schemas](mcp/tools/README.md)

## Problem types

RFC 9457 problem types are documented under `https://zarishhealth.github.io/docs/problems/`.

- [Problem types](problems/README.md)

## Protobuf

- [Sync envelope](proto/zarishhealth/sync/v1/sync.proto)

## Licence

The contracts are Apache-2.0; see [LICENSE](LICENSE) and `LICENSES/`.
