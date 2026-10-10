# Plan: follow and analyse any Brazilian election

Status (10/10/2026): approved; all five steps done. Live on election night: the poller fetches every office TSE publishes; Resultados re-reads any incomplete file every 30 s (stored per version, falling back to the last one if TSE fails) and marks it live; Apuração links to it. Unverifiable until 25/10: the live 2nd-round files themselves.

## Goal

Urna Aberta becomes a tool to follow an election count live **and** to analyse the results of any Brazilian election, every office, straight from TSE's signed files. First build: the 2026 general election (all offices) and the 2024 municipal election. The 2028 municipal election follows on the same code. The October 4, 2026 pause stays as a case study (Entenda ch. 6 and a replay you can open), no longer the headline.

## What the data gives us (verified 10/10/2026)

- TSE's own Resultados app fetches only `.jws` files (signed, Ed25519, same key `sNbt9Q_…` for 2024 and 2026); the JSON is the payload. We do the same and verify every file.
- 2026, per UF: `ele2026/6259/dados/<uf>/<uf>-c<cargo>-e006259-u.jws`, cargo 3 Governador, 5 Senador, 6 Dep. Federal, 7 Dep. Estadual, 8 Dep. Distrital (DF; derived from EA11, not yet observed).
- 2024, per municipality: `ele2024/<619|620>/dados/<uf>/<uf><mun5>-c<0011|0013>-e<000619|000620>-u.jws`. Municipality list (EA12): `ele2024/<ele>/config/mun-e<ele6>-cm.jws` (TSE 5-digit code + IBGE 7-digit code).
- EA20 for proportional offices has seats (`nv`), TSE's electoral quotient (`qe`), seats won per party/federation (`vag`), nominal and legend votes, and each candidate's status (`Eleito por QP`, `Eleito por média`, `Suplente`, `Não eleito`) and vote validity (`Válido`, `Anulado`, `Anulado sub judice`).
- URLs are only ever built from EA11/EA12 entries, never guessed.

## Seat allocation (independent computation)

Implemented as a pure function, step by step from Código Eleitoral arts. 106–112, Res.-TSE 23.677/2021 (consolidated), and STF ADIs 7228/7263/7325 (third phase open to all lists, valid since 2022):

1. Valid votes = nominal + legend for valid candidacies; sub judice votes excluded.
2. QE = V / seats, fraction ≤ 0.5 dropped, > 0.5 rounded up. Checked against TSE's `qe`.
3. QP = floor(list votes / QE); QP seats go to candidates with ≥ 10% QE.
4. Remainders by highest average (list votes / (QP + seats won + 1)) among lists with ≥ 80% QE and a candidate with ≥ 20% QE.
5. Then all lists and candidates, no thresholds. If no list reaches QE, steps 4–5 distribute every seat.
6. Ties: more list votes, then more candidate votes; same-list ties go to the older candidate.

Every result is compared seat by seat with TSE (`vag`, `st`) and any difference is shown, never hidden.

## Product and screens

- **Apuração**: what TSE is publishing now (live on election nights, any office with live files), otherwise the latest election's final count. Neutral headline. The Oct 4 replay moves behind a "Caso: 4 de outubro" entry.
- **Resultados** (new tab): election → office → UF / municipality.
  - Majoritarian offices (Presidente, Governador, Senador, Prefeito): ranking with votes, %, status, 2nd-round marker.
  - Proportional offices (Deputados, Vereador): seats by party/federation, QE and QP table, elected and suplentes, our computation vs TSE per seat, candidate search. National Câmara composition (513 seats, sum of the 27 UFs).
  - Every figure keeps its Fonte line, TSE file code and signature status. No party colors (brand rule): parties are told apart by label and order.
- **Minha seção**, **Verificar**: unchanged, extended to any election with section files.
- **Entenda**: new chapter "Como as vagas são distribuídas" (proportional system), sourced; chapter 6 stays as the case study; copy reframed around following and checking any election.
- Mobile: 5 tabs (Apuração · Resultados · Minha seção · Verificar · Entenda), the platform maximum.

## Server

- Offices: add Dep. Federal (6), Estadual (7), Distrital (8), Prefeito (11), Vereador (13). Scopes: add municipality (`<uf><mun5>`), validated against EA12.
- URL builder per election cycle (`ele2024`, `ele2026`, later `ele2028`); fetch `.jws`, verify, store raw (existing `ResultSnapshot`).
- Election catalog from EA11 (ordinary elections and their offices/scopes; supplementary elections listed later).
- EA20 reader extended: lists, parties, federations, legend votes, seats, quotient, statuses, validity, birth dates.
- On-demand fetch with cache: final files are immutable, so each is fetched once through the rate-limited client.
- `resultados` endpoint: `elections()`, `offices(election)`, `result(election, office, scope)`, `seats(...)`, `camara(election)`.
- Live: extend polling to every office TSE publishes on a given night (2nd round 2026: Presidente + Governador). Municipal nights (2028) poll capitals plus the municipalities people open, not all 5,569.

## Delivery, in order (each phase tested and committed on its own)

1. **Data layer**: offices, municipality scope, per-cycle URLs, `.jws` fetch, EA12 reader, full EA20 reader. Archive fixtures: 2026 deputies (all UFs), 2024 Prefeito + Vereador for the 26 capitals (both rounds where held), EA12 2024. About 140 requests, rate-limited.
2. **Seat engine**: TDD on the rules above, then a sweep over every archived file that must match TSE's `qe`, `vag` and elected list exactly (SP Dep. Federal 70 seats = 60 QP + 10 média; SP Vereador 2024 55 = 46 + 9).
3. **Resultados**: endpoint and screen, majoritarian and proportional views, national Câmara.
4. **Reframe**: PRODUCT.md, Apuração headline and replay entry, Entenda lede + new chapter, README, design brief.
5. **Live for every office**: governor live on 25/10; groundwork for municipal nights.

## Open points

- DF Deputado Distrital URL is derived from EA11, not yet observed.
- Whether 2024 also serves `.json` siblings is unknown and not needed (`.jws` carries the payload).
- Municipalities beyond the capitals are fetched on demand, so they need the TSE CDN at the time of use.
