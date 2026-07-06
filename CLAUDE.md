# DiasporaNodeInfo — Claude Code working notes

Swift package implementing the fediverse NodeInfo protocol (discovery + schema decode). Library + `nodeinfo-cli` executable. Planned Spud consumer via versioned remote pin (like LemmyKit).

## Build / test

- `swift build` / `swift test` — zero-warning discipline; both pristine before committing. 41 Swift Testing tests.
- No CI (deliberate — macOS runners too expensive); always test locally.
- CLI has no test harness (deliberate); verify by running: `swift run nodeinfo-cli lemmy.world` (exit 0) and an invalid domain (message on stderr, exit 1).
- Stale SourceKit diagnostics are common (phantom "no such module" / "no member" while builds are green) — trust `swift build`, not IDE diagnostics.

## Conventions

- Keep a Changelog + STRICT semver: API additions (even conformances / enum cases) = minor, per precedent (1.1.0, 1.3.0, 1.5.0); platform-floor bumps = major.
- Changelog cut is the last commit before tagging; annotated tag message = bare version string (e.g. `2.0.0`).
- NEVER move a published tag — SPM resolves and caches by tag.
- BSD-2-Clause header block on every file; conventional commits.
- No speculative convenience API: `Decodable` conformance IS the decode API (a `NodeInfo(data:)` wrapper was built and cut pre-2.0.0 for this reason).

## Architecture invariants

- `v2_0`/`v2_1` are mirrored frozen namespaces — never share schema types across versions; shared logic only in internal `Utils/` helpers (`LenientDecoding`).
- `fetch(for:)` is typed throws (`throws(NodeInfoManager.Error)`) — nothing escapes untyped; adding `Error` cases is source-breaking for consumers (taxonomy considered complete).
- Usage counters decode leniently (int, int-as-string; anything else nil, never throws); encoding omits nil keys. Pinned by round-trip tests.
- Spec-rule deviations (no HTTP fallback, whole-5xx range, no content-type validation) are deliberate — keep the rule-numbered comments in `NodeInfoManager`.
- `NodeInfoManagerTests` MUST stay `@Suite(.serialized)` (MockURLProtocol static stub state); the other suites are parallel-safe structs.
