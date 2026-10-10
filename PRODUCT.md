# Product

<!-- impeccable:product-schema 1 -->

## Platform

adaptive

One editorial brand across iOS, Android and web (all Flutter). Each platform keeps its own idioms: mobile gets native navigation (bottom bar, sheets, back gestures, safe areas, haptics), web gets long-form editorial layouts, wide grids, hover, keyboard and deep links. Feature parity across platforms is required; layout and interaction are not identical.

## Users

- **Primary: Brazilian voter on a phone.** On election night, wants to know the count is moving and how their state or city is voting; afterwards, wants to see who was elected for every office (President to Vereador) and check their own polling section against the paper Boletim de Urna. Possibly distrustful; may be on weak mobile data. pt-BR.
- **Secondary: journalists, researchers, campaigns, foreign observers, hackathon jury** on desktop web. Want results by office and place, the seat allocation behind proportional races, the methodology and the security process. Often en.
- Tie-breaker when needs collide: the voter on the phone wins.

## Product Purpose

Urna Aberta lets anyone follow a Brazilian election count as TSE publishes it and analyse the results of any election, every office, from TSE's own signed files: President, Governor, Senator, federal, state and district deputies, and in municipal years Mayor and city councillors. It verifies what it can (file signatures, the urna's signature and hashes, an independent seat allocation for proportional offices) and explains how the process and its security protocols work. Success: anyone can find, in seconds, who was elected where and why, and trace every number to an official TSE file.

## Positioning

An independent reading of official TSE files only. It sums per-state results against TSE's national file live, verifies every file's signature, re-runs the proportional seat allocation (quociente eleitoral, quociente partidário, sobras) and compares it with TSE's seat by seat, and lets a voter compare their section's official BU with the posted paper one. Transparency instead of rhetoric. The Oct 4, 2026 pause in national publication is a documented case study, not the product's premise.

## Operating Context

- Election nights live (2026 2nd round on Oct 25; 2028 municipal next), with a replay of the Oct 4, 2026 1st round as a case study.
- Any time: final results of 2024 (municipal) and 2026 (general) elections, fetched on demand from TSE and stored signed.
- Users compare on-screen data with a paper BU at their polling place.
- Data sources: TSE static files (EA11 elections, EA12 municipalities, EA20 results, EA16/EA18 sections), JWS signatures, urna `.vsc` signatures.

## Capabilities and Constraints

- Features: Apuração (live national file vs sum of states, divergence banner, timeline; Oct 4 replay as case study); Resultados (any office, any UF or municipality, rankings, seats by party or federation with the independent seat check, the Câmara summed); Minha seção (UF → municipality → zone → section, BU, hashes, urna signature); Verificar (signature status per file); Entenda (chapters on the pipeline, BU, urna files, signatures, security protocols, seat distribution, the Oct 4 case, what the app can and cannot prove).
- Geography: 27 UFs plus exterior, 5,570 municipalities, five regions (Norte, Nordeste, Centro-Oeste, Sudeste, Sul).
- Bilingual pt-BR / en; Portuguese official terms kept with English gloss (Apuração, Totalização, Divulgação, Boletim de Urna, Seção, Zona, RDV, quociente eleitoral).
- Stack: Serverpod backend, Flutter frontend (mobile + web). Server returns data, never display strings.
- TSE rate limits and 404 blocking: no file is requested before an election's polls close or for a place TSE does not list.
- Replay timeline may be synthetic; when it is, the UI must label it "simulation".

## Brand Commitments

- Name: **Urna Aberta**.
- Politically neutral: no candidate commentary, identical visual weight for all candidates (no party colors).
- Official data only: never fabricate or estimate counts; every number links to its TSE source file.
- Explicit honesty: state that the app verifies published results match machine records, not the machines themselves.
- Open source, public methodology.

## Evidence on Hand

- HANDOFF.md (original spec), docs/PLAN-multi-election.md (current plan).
- `fixtures/`: signed TSE files for the 2026 1st round (all offices) and the 2024 municipal election (26 capitals), with manifests.
- Real candidate names and vote counts come only from TSE files; samples in the design-system gallery are anonymous placeholders.

## Product Principles

1. Trace every number: a source link is part of the number, not a footnote.
2. Recompute what can be recomputed (sums, seat allocation) and show where it agrees with TSE and where it does not.
3. Neutral by construction: equal weight for every candidate, state, and region.
4. Say what is proven and what is not.
5. Calm under pressure: the election-night voter on a phone comes first.
6. Same truth on every platform; best interaction for each.

## Accessibility & Inclusion

- WCAG 2.2 AA in light and dark themes; never rely on color alone for status (signature valid/invalid, divergence).
- Map and charts need non-visual equivalents (lists/tables) and keyboard and screen reader access.
- Readable on low-end Android phones and weak connections.
