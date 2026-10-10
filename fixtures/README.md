# TSE fixtures

Raw files from the TSE results CDN (`resultados.tse.jus.br`, ambiente `oficial`), kept byte-for-byte for the replay demo and tests. Never edit them.

- `2026-1t/`: 1st round, 04/10/2026 (pleito 3220; election 6257 = Presidente, 6259 = Governador/Senador). Files mirror their URL path under `oficial/`.
- `2026-1t/manifest.json`: URL, SHA-256, size, ETag and Last-Modified of every file, plus fetch time.

Contents: EA11 (`ele-c.json`), EA12 (municipalities, 6257 and 6259), EA14 (Brazil tracking), EA15 (tracking per UF), EA20 President (Brazil, 27 UFs, ZZ), EA20 Governor and Senator (27 UFs), EA16 section config (27 UFs + ZZ).

Regenerate with `dart run bin/archive_fixtures.dart` from `urna_aberta_server` (20 req/s, stops at the first error).

These are the final files (generated 05/10/2026). They show the end state, not the night's progression.
