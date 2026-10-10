# Product

<!-- impeccable:product-schema 1 -->

## Platform

adaptive

One editorial brand across iOS, Android and web (all Flutter). Each platform keeps its own idioms: mobile gets native navigation (bottom bar, sheets, back gestures, safe areas, haptics), web gets long-form editorial layouts, wide grids, hover, keyboard and deep links. Feature parity across platforms is required; layout and interaction are not identical.

## Users

- **Primary: Brazilian voter on a phone, election night.** Possibly anxious or distrustful after the Oct 4, 2026 publication freeze. Wants to know if the count is still moving, and to check their own polling section against the paper Boletim de Urna. May be on weak mobile data. pt-BR.
- **Secondary: hackathon jury, journalists, foreign observers** on desktop web. Want to understand the divergence story, the methodology and the security process. Often en.
- Tie-breaker when needs collide: the voter on the phone wins.

## Product Purpose

Urna Aberta lets anyone independently follow and verify the publication of Brazilian election results, and learn how the process and its security protocols work. Success: a voter can see, in seconds, that the per-state count kept moving while the national display froze, and can trace every number to an official TSE file.

## Positioning

An independent cross-check built only from official TSE files: it sums per-UF results and compares them with TSE's national file live, verifies file signatures and hashes, and lets a voter compare their section's official BU with the posted paper one. Transparency instead of rhetoric.

## Operating Context

- Live election nights (2nd round Oct 25, 2026) and a replay of the 1st round (Oct 4, 2026) for the hackathon demo, with virtual clock controls (play, pause, 10×/60×, jump to the freeze).
- Users compare on-screen data with a paper BU at their polling place.
- Data sources: TSE static JSON files (EA11–EA20), signatures (JWS), aux-file hashes (EA18).

## Capabilities and Constraints

- Features: Live tally (TSE national file vs independent sum of states, divergence banner, timeline chart); My section (UF → municipality → zone → section, BU data, hashes, signature status); Verification status per file (valid / invalid / not checked); Learn chapters (pipeline, BU, urna files, signatures, security protocols, Oct 4 case study, what the app can and cannot prove).
- Geography: 27 UFs plus exterior, grouped in five regions (Norte, Nordeste, Centro-Oeste, Sudeste, Sul).
- Bilingual pt-BR / en; Portuguese official terms kept with English gloss (Apuração, Totalização, Divulgação, Boletim de Urna, Seção, Zona, RDV).
- Stack: Serverpod backend, Flutter frontend (mobile + web). Server returns data, never display strings.
- Replay timeline may be synthetic; when it is, the UI must label it "simulation".
- Open: QR scan of printed BU (stretch), 2nd-round codes, final domain.

## Brand Commitments

- Name: **Urna Aberta**.
- Politically neutral: no candidate commentary, identical visual weight for all candidates (no party colors).
- Official data only: never fabricate or estimate counts; every number links to its TSE source file.
- Explicit honesty: state that the app verifies published results match machine records, not the machines themselves.
- Open source, public methodology.

## Evidence on Hand

- HANDOFF.md (product spec). No archived fixtures, screenshots, logos, or real candidate data yet. Do not fabricate candidate names or vote counts in shipped UI; samples must be clearly marked placeholders.

## Product Principles

1. Trace every number: a source link is part of the number, not a footnote.
2. Neutral by construction: equal weight for every candidate, state, and region.
3. Say what is proven and what is not.
4. Calm under pressure: the election-night voter on a phone comes first.
5. Same truth on every platform; best interaction for each.

## Accessibility & Inclusion

- WCAG 2.2 AA in light and dark themes; never rely on color alone for status (signature valid/invalid, divergence).
- Map and charts need non-visual equivalents (lists/tables) and keyboard and screen reader access.
- Readable on low-end Android phones and weak connections.
