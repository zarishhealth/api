# Problem types

The RFC 9457 problem types of the JSON API (`/api/v1`). The `type` member is the
permanent URI below; each one resolves to a page in the `docs` repository under
`problems/`.

| Slug | Status | Meaning |
| --- | --- | --- |
| `validation-failed` | 422 | Body failed schema or business validation |
| `malformed-request` | 400 | Syntax error |
| `unauthenticated` | 401 | Missing or invalid token |
| `forbidden` | 403 | Token lacks the scope or role |
| `not-found` | 404 | Resource absent, also used where the caller may not know it exists |
| `version-conflict` | 409 / 412 | `ETag` / `If-Match` mismatch |
| `sync-conflict` | 409 | Concurrent edits queued for review |
| `rate-limited` | 429 | Carries `Retry-After` |
| `unsupported-protocol-version` | 400 | Unsupported MCP or API version |
| `internal-error` | 500 | No internals; carries the `instance` correlation identifier |

Response shape:

```json
{
  "type": "https://zarishhealth.github.io/docs/problems/validation-failed",
  "title": "Validation failed",
  "status": 422,
  "detail": "One or more fields are invalid.",
  "instance": "urn:uuid:0192f4a8-7b3c-7d1e-9a2b-3c4d5e6f7a8b",
  "errors": [{ "pointer": "/birthDate", "code": "invalid-date" }]
}
```

`detail` and `errors` never echo personal data. The slugs and the URIs are permanent.
