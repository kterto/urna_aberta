# TSE fixtures

Raw files from the TSE results CDN (`resultados.tse.jus.br`, ambiente `oficial`), kept byte-for-byte for the replay demo and tests. Never edit them.

- `2026-1t/`: 1st round, 04/10/2026 (pleito 3220; election 6257 = Presidente, 6259 = Governador/Senador). Files mirror their URL path under `oficial/`.
- `2026-1t/manifest.json`: URL, SHA-256, size, ETag and Last-Modified of every file, plus fetch time.

Contents: EA11 (`ele-c.json`), EA12 (municipalities, 6257 and 6259), EA14 (Brazil tracking), EA15 (tracking per UF), EA20 President (Brazil, 27 UFs, ZZ), EA20 Governor and Senator (27 UFs), EA16 section config (27 UFs + ZZ).

Each EA20 file also has its signed copy, `<same name>.jws` (fetched 10/10/2026). It is a JWS in compact serialization (EdDSA, Ed25519, key id `sNbt9Q_fLS65zE1_ZLNV-XRRwPY`). Its payload is byte-identical to the `.json`, and all 83 verify with the key in `urna_aberta_server/lib/src/verify/jws.dart`.

Regenerate with `dart run bin/archive_fixtures.dart` from `urna_aberta_server` (20 req/s, stops at the first error).

These are the final files (generated 05/10/2026). They show the end state, not the night's progression.

## One polling section (EA18 + urna files)

Fetched 10/10/2026 to build and test the section decoder:
AC, Porto Walter (01066), zona 0004, seção 0077.

| File | SHA-256 |
|---|---|
| `oficial/ele2026/arquivo-urna/3220/dados/ac/01066/0004/0077/p003220-ac-m01066-z0004-s0077-aux.json` (EA18) | `c449b5edf0d12a831bb05039d31b53da5d0cfd94e834b33b7e302339ce914504` |
| `…/0077/<hash>/o03220ac0106600040077-bu.dat` (boletim de urna, ASN.1) | `e987c40fc752fef52b3e03bea6fbe2f1893c4b2e94309f4f5c933319d8ed8985` |
| `…/0077/<hash>/o03220ac0106600040077-vota.vsc` (urna signatures) | `264a49b0fba78d921ddf7a48139f108b61e381a614ef2c5406efe6bd6239380e` |

`<hash>` is the folder named in the aux file. TSE has not published the
2026 BU and signature schemas; `urna_aberta_server/lib/src/secao/asn1/`
holds TSE's 2022 schemas adapted to these files (every office's votes add
up to the turnout; the BU's SHA-512 matches the urna's signed list).
