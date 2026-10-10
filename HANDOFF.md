# Urna Aberta — Project Handoff

> Working name — rename freely. An open-source app and website that let anyone **independently follow and verify** the publication of Brazilian election results, and **learn how the process and its security protocols work**. Bilingual (pt-BR / en).

Built with **Serverpod** (Dart backend) and **Flutter** (mobile + web) for the Serverpod hackathon (submission deadline: next weekend). The 2nd round of the 2026 Brazilian general election is on **Oct 25, 2026**, after the deadline. The demo therefore relies on a **replay of the 1st round (Oct 4, 2026)**.

---

## 1. Why this exists

On election night (Oct 4, 2026), the TSE (Superior Electoral Court) national **presidential** results view stopped updating at **64.81%** from about **19:14 to 20:04** Brasília time (~50 minutes). TSE's note gives no figure for the moment it resumed (press reports of a jump to ~84% are unsourced).

- According to TSE, a data-processing contention ("contenção no processamento de dados"), after a rise in data volume, stalled the module that generates the **"Brasil" (national) publication files** for President.
- **The state view was not affected**: per-UF files, which also carry the President votes, kept being published without interruption.
- Ballot box reports kept being transmitted, received and published. Totalization went on, *except for a brief moment when it was suspended under the security protocol* (TSE's wording).
- The freeze fueled fraud claims on social media; TSE's fact-check (Fato ou Boato, 06/10/2026, updated 09/10) is the primary source: https://www.justicaeleitoral.jus.br/fato-ou-boato/checagens/2026/e-falso-que-a-interrupcao-na-divulgacao-dos-resultados-tenha-fraudado-o-resultado-do-1o-turno-para-presidente

**Key insight:** anyone summing the per-UF presidential files (or per-section files) during the freeze saw the count keep moving. The count never stopped; only the national display did. A tool that shows this live, explains it, and lets people check results down to their own polling section can reduce distrust with transparency instead of rhetoric.

### Goals
1. **Live independent tally:** sum official per-UF (and optionally per-section) data and compare it with TSE's national consolidated file in real time.
2. **Section-level verification:** a voter enters zone and section and sees the official Boletim de Urna (BU, the ballot box tally report). They compare it with the BU printed and posted at the polling place.
3. **Cryptographic checks:** verify TSE file signatures and urna file hashes, and show the result clearly.
4. **Learn:** explainer sections on the election pipeline, its security protocols, and what each verification proves and does not prove.
5. **Bilingual:** pt-BR for Brazilian voters, en for the international hackathon jury and foreign observers.

### Non-goals and honesty principles
- This tool verifies that **published results match what the voting machines recorded**. It **does not** prove anything about the machines themselves. State this explicitly in the UI.
- **Politically neutral.** No candidate commentary, no editorializing. Same visual weight for all candidates.
- **Official data only.** Never fabricate or estimate counts. Every number must trace back to a TSE file, with a link to it.
- Fully open source, with public methodology.

---

## 2. Official data source (verified)

TSE publishes results as **static JSON files on a CDN**. There is no REST API and no auth. Official tech page (specs, FAQ, simulations):
https://www.tse.jus.br/eleicoes/informacoes-tecnicas-sobre-a-divulgacao-de-resultados

### Access rules (critical)
| Rule | Detail |
|---|---|
| Registration | None. No signup, authorization, or agreement needed (Res. TSE nº 23.751/2026, arts. 264–269). |
| Base URL | `https://resultados.tse.jus.br`, environment `oficial` |
| Rate limit | **100 req/s per IP**. Exceeding it means a **10-min block**, and retrying during the block resets the timer. |
| 404s | **Multiple 404s can get your IP blocked.** Files cannot be listed, so build URLs exactly (municipality codes are 5 digits, zero-padded). |
| Conditional requests | ETag / Last-Modified are supported (HTTP 304), but **304s still count toward the rate limit**. |
| Index files | None. Use the tracking files (EA14/EA15) to detect updates. |

### Election codes
- 1st round (2026-10-04), pleito **3220**: `6257` Federal (President), `6259` State, `6261` Conselho Distrital.
- 2nd round codes: read them from `comum/config/ele-c.json` (EA11). **Never hardcode them.**

### URL patterns (from the official simulation docs)
Replace `resultados-sim.tse.jus.br/simulado/simulado2026` with `resultados.tse.jus.br/oficial` and use the real election code:
```
/comum/config/ele-c.json                                  # EA11 elections config
/ele2026/{eleicao}/config/mun-e{eleicao6}-cm.json         # EA12 municipalities config
/ele2026/{eleicao}/dados/br/br-e{eleicao6}-ab.json        # EA14 Brazil tracking
/ele2026/{eleicao}/dados/{uf}/{uf}-e{eleicao6}-ab.json    # EA15 UF tracking
/ele2026/{eleicao}/dados/br/br-c0001-e{eleicao6}-u.json   # EA20 President, Brazil
/ele2026/{eleicao}/dados/{uf}/{uf}-c0001-e{eleicao6}-u.json  # EA20 President, per UF
/ele2026/{eleicao}/dados/{uf}/{uf}-c0003-e{eleicao6}-u.json  # EA20 Governor, per UF
```
`c0001` = President, `c0003` = Governor, `c0005` = Senator. `{eleicao6}` = 6-digit zero-padded code (e.g. `021270`). **Validate every pattern against the official "Instruções para download" PDF before relying on it.**

### File specs (all linked from the TSE tech page → "Documentos")
| Spec | Content | Use here |
|---|---|---|
| EA10 | Elected candidates | Final results |
| EA11 | Elections config (`ele-c.json`) | Discover cycle/election/pleito codes |
| EA12 | Municipalities config | UF → municipality codes |
| EA14 | Brazil tracking | Detect which UFs updated |
| EA15 | UF tracking | Detect which municipalities updated |
| EA16 | Polling section config, one file per UF (`{uf}-p{pleito}-cs.json`) | Section list. The `da`/`ha` fields give the aux-file generation date/time (arrival of urna files). |
| EA17 | Boletim de Urna as JSON (per section) | Section-level tally |
| EA18 | Section aux file (`...-aux.json`, one per section) | Hashes of urna files (BU, RDV, log) |
| EA20 | Unified result file (`-u.json`) | Main results per scope/office |
| JWS manual | Signature verification for published files | Crypto checks |

TSE FAQ note: BU files are **not** necessarily available before the consolidated JSONs (BUs feed totalization). Do not promise to "beat TSE". Promise **transparency and independent cross-checking**.

### Rate-limit budget
~470k–500k polling sections nationwide. At ≤100 req/s, a full section sweep takes over an hour. So:
- **Live tally:** poll EA14 → only the changed UF EA20 files (27 UFs + exterior). That is cheap.
- **Section verification:** **on demand** (a user looks up their section), cached aggressively server-side.
- Keep a global token bucket well under the limit (e.g. 20–30 req/s) and **never** let clients hit TSE directly.

---

## 3. Architecture (Serverpod + Flutter)

```
                ┌──────────────────────────────────────────┐
TSE CDN  ──────▶│ Serverpod server                          │
(static JSON)   │  • Ingestion (FutureCalls, rate-limited)  │
                │  • Normalizer + signature verifier        │
                │  • PostgreSQL (snapshots, history)        │
                │  • Redis cache                            │
                │  • Endpoints + streaming (live updates)   │
                │  • Replay engine (demo mode)              │
                └───────────────┬──────────────────────────┘
                                │ generated Dart client
                ┌───────────────┴───────────────┐
                │ Flutter app (iOS/Android/Web) │
                │  • Live tally & divergence    │
                │  • My section (BU compare)    │
                │  • Learn (explainers)         │
                │  • pt-BR / en                 │
                └───────────────────────────────┘
```

### Server modules
1. **TseClient**: URL builder (unit-tested against known filenames), global token bucket, conditional GETs, 404 guard (refuse URLs that fail validation, back off after any 404).
2. **Ingestion** (Serverpod FutureCalls / scheduled loop):
   - Fetch `ele-c.json` at startup to resolve codes.
   - Poll EA14 → for changed UFs, fetch the President EA20 per UF, plus the BR EA20.
   - Store each version as an immutable snapshot (`scope`, `office`, `fetchedAt`, TSE generation timestamp, `% sections totalized`, raw JSON hash, signature status).
3. **Aggregator**: independent national sum = Σ UF + exterior. Computes divergence vs the BR file (sections %, votes per candidate). Flags a **divergence event** when BR lags.
4. **Verifier**: JWS signature validation per the TSE manual. EA18 hash checks for urna files when fetched.
5. **Section service**: on-demand EA16 → EA18 → EA17 fetch for one section, cached.
6. **Replay engine**: drives the whole system from recorded data on a virtual clock (see §5).
7. **Endpoints / streams**: `liveTally`, `divergenceTimeline`, `section(uf, municipio, zona, secao)`, `verificationStatus`, `replayControl`.

### Scaling note
For real election night traffic, do not fan out WebSockets to every client from one server. Publish a compact `snapshot.json` behind a CDN with a 2–5 s TTL and let clients poll it. Use streams for the hackathon demo. Document the CDN path in the README as the production design.

### Data model (Serverpod `.spy.yaml` sketch)
- `Election` (code, pleito, round, type)
- `ResultSnapshot` (electionCode, scope [br|uf|mun], scopeCode, officeCode, sectionsTotalizedPct, tseGeneratedAt, fetchedAt, rawHash, signatureValid)
- `CandidateTally` (snapshotId, candidateNumber, name, party, votes)
- `DivergenceEvent` (startedAt, endedAt, brPct, ufSumPct, maxGap)
- `SectionCheck` (uf, municipio, zona, secao, buHash, auxHash, signatureValid, fetchedAt)

---

## 4. Features and screens

### 4.1 Live tally ("Apuração independente / Independent count")
- Two side-by-side progress bars: **TSE national file** vs **independent sum of states**.
- Candidate totals from both sources, identical styling.
- When they diverge, show a banner: "The national display is behind the states. The count continues. See why →" (links to Learn).
- Timeline chart of both percentages over the night. The Oct 4 freeze is the hero demo.
- Every number links to the exact TSE file it came from.

### 4.2 My section ("Minha seção / My polling section")
- Input UF → municipality → zone → section (from EA12/EA16).
- Show official BU data (EA17), arrival time (EA16 `da`/`ha`), file hashes (EA18), and signature status.
- Guide: "Compare with the paper BU posted at your polling place".
- **Stretch:** the printed BU carries QR codes, and TSE has an app that reads them. Investigate the official QR spec and allow **scan → automatic compare**. Validate the spec before committing to this.
- **Stretch:** community-contributed BU photos (moderation, privacy, abuse concerns, so probably out of scope for the hackathon).

### 4.3 Verification status
- Per file: ✓ signature valid / ✗ invalid / ⏳ not checked, with a plain-language explanation of what a valid signature means (the file came from TSE and was not altered in transit).

### 4.4 Learn ("Entenda o processo / Understand the process")
Short, illustrated, sourced explainers. **Every claim must cite an official TSE source.** Suggested chapters (research and verify each before writing):
1. **The pipeline:** vote → urna → BU printed and posted → transmission → *apuração* vs *totalização* vs *divulgação* (counting vs totalization vs publication). This distinction is central to the Oct 4 story.
2. **The Boletim de Urna:** what it contains, why it is public, how anyone can check it.
3. **Urna files:** BU, RDV (digital vote record), log. What each is for.
4. **Digital signatures and hashes:** what the JWS/aux-file checks in this app actually verify.
5. **Security protocols:** e.g. public security tests, integrity tests, signing and sealing ceremonies of the systems, source-code inspection by oversight entities. Confirm the current names, scope and dates for 2026 from TSE sources.
6. **Case study, Oct 4, 2026:** what froze, what didn't, and how this app shows it with the replay.
7. **What this app can and cannot prove.**

---

## 5. Replay / demo mode (critical for judging)

Judges will evaluate before Oct 25, so the demo must replay the 1st round convincingly.

- **Capture now:** download and archive the final 1st-round files (ele-c, EA12, EA14/15, EA20 BR + all UFs for President and Governor, EA16 per UF). Store raw files plus hashes in a `fixtures/` bucket or Git LFS, respecting the rate limit.
- **Reconstruct a timeline:** final files show only the end state. Options, from best to worst:
  1. Use EA16 `da`/`ha` per section (urna file arrival times) plus per-section EA17 to rebuild progression. This is expensive to fetch (~500k sections), so consider a single UF or a sample.
  2. Use any public timestamped snapshots of the night (news archives, community dumps). Attribute the source.
  3. A synthetic, clearly labeled curve, interpolated per UF toward final totals, with a **simulated BR freeze at 64.81% for ~50 min**. Label it **"simulation"** in the UI.
- Virtual clock controls: play, pause, 10×/60× speed, jump to the freeze.
- Fallback: the TSE simulation environment (`resultados-sim.tse.jus.br/simulado`, environment `simulado2026`, pleito 17801) may still serve files. Useful for format testing.

---

## 6. Localization

- Flutter `gen_l10n` with ARB files: `app_en.arb`, `app_pt.arb` (pt-BR). Default to the device locale and allow a manual toggle.
- Server returns **data**, never display strings. Candidate names stay as published.
- **Glossary** (keep the Portuguese term plus an English gloss in the en locale; reviewers will see these terms in TSE docs):

| pt-BR | en |
|---|---|
| Apuração | Vote counting |
| Totalização | Totalization (official aggregation) |
| Divulgação | Publication of results |
| Boletim de Urna (BU) | Ballot box tally report |
| Seção eleitoral | Polling section |
| Zona eleitoral | Electoral zone |
| Urna eletrônica | Electronic voting machine |
| Registro Digital do Voto (RDV) | Digital vote record |
| Seções totalizadas | Sections totalized |

- Learn content: author in Markdown per locale (`content/en/*.md`, `content/pt/*.md`) so contributors can translate and review via PRs.

---

## 7. Repository layout (suggested)

```
urna-aberta/
├── urna_aberta_server/      # Serverpod server
│   ├── lib/src/tse/         # TseClient, URL builder, rate limiter
│   ├── lib/src/ingestion/   # FutureCalls, pollers
│   ├── lib/src/verify/      # JWS + hash verification
│   ├── lib/src/replay/      # replay engine, virtual clock
│   ├── lib/src/endpoints/
│   └── lib/src/models/      # .spy.yaml
├── urna_aberta_client/      # generated
├── urna_aberta_flutter/     # app (mobile + web)
│   ├── lib/l10n/            # ARB files
│   └── content/{en,pt}/     # Learn chapters
├── fixtures/                # archived TSE 1st-round files (+ hashes)
├── docs/
│   ├── METHODOLOGY.md       # how every number is computed
│   ├── DATA_SOURCES.md      # TSE specs, URLs, rate limits
│   └── ARCHITECTURE.md
├── README.md                # bilingual summary, demo GIF, links
├── CONTRIBUTING.md
└── LICENSE                  # MIT or Apache-2.0
```

---

## 8. One-week plan

| Day | Deliverable |
|---|---|
| 1 | Repo scaffold (Serverpod + Flutter), CI, l10n setup. **Archive 1st-round fixtures.** URL builder + tests. |
| 2 | TseClient (rate limiter, conditional GET, 404 guard). Ingestion of EA14 + EA20 (BR + UFs). Snapshot models. |
| 3 | Aggregator + divergence detection. Replay engine with virtual clock and the simulated freeze. |
| 4 | Flutter live-tally screen + timeline chart + streaming. |
| 5 | My section (EA16/EA17/EA18) + signature/hash verification UI. |
| 6 | Learn chapters (at least 1, 2, 6, 7), fully sourced, in en + pt. Polish. |
| 7 | Deploy (web demo URL), README with GIF, METHODOLOGY.md, demo video, submission. |

**Cut order if late:** QR scan → per-section sampling in replay → Learn chapters 3–5 → Governor support.

---

## 9. Testing and quality

- Unit tests: URL builder (golden filenames), aggregator math, divergence detection, signature verification against real fixtures.
- Replay integration test: the full 1st-round run must end with Σ UF == BR final totals.
- Never ship a number that isn't traceable to a stored raw file plus hash.

## 10. Open questions / to verify
- [ ] Exact JWS verification flow and key distribution (TSE manual).
- [ ] Whether 1st-round section files (EA16/17/18) remain available after the election and for how long.
- [ ] Official printed-BU QR code spec (for the stretch feature).
- [ ] 2nd-round codes, once `ele-c.json` is updated.
- [ ] Hackathon rules: required Serverpod features, deployment requirements, demo format.
- [ ] Name / domain.

## 11. References
- TSE technical info for results distribution (specs, FAQ, simulation): https://www.tse.jus.br/eleicoes/informacoes-tecnicas-sobre-a-divulgacao-de-resultados
- EA17 Boletim de Urna spec: https://www.tse.jus.br/eleicoes/eleicoes-2022/arquivos/interessados/ea17-arquivo-de-boletim-de-urna
- EA18 Section aux file spec: https://www.tse.jus.br/eleicoes/arquivos/tse-ea18-arquivo-auxiliar-de-secao
- TSE fact-check on the Oct 4 publication freeze (primary): https://www.justicaeleitoral.jus.br/fato-ou-boato/checagens/2026/e-falso-que-a-interrupcao-na-divulgacao-dos-resultados-tenha-fraudado-o-resultado-do-1o-turno-para-presidente
- Press copy of the same: https://tribunadosertao.com.br/politica/2026/10/06/991646-e-falso-que-a-interrupcao-na-divulgacao-dos-resultados-tenha-fraudado-o-resultado-do-1o-turno-para-presidente
- Coverage of the ~50-min interruption and the 2nd-round fix: https://m.imirante.com/noticias/brasil/2026/10/06/ipolitica-falha-no-tse-divulgacao-de-votos-para-por-50-minutos
