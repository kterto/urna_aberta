# Plan: reports anyone can configure

Status (11/10/2026): approved, with sign-in required, an opt-in public link and a limit of 3,000 files. Steps 1 to 4 done (spec and quote, sums, queue, PDF and CSV): the AC cities add up to TSE's AC file and the 34 BUs of Porto Walter's zone to TSE's Porto Walter file, figure by figure.

## Goal

Anyone, whether a voter, a reporter, a researcher or an observer abroad, can put together a report on any election Urna Aberta covers. They choose which elections, which offices, and which places: Brazil, regions, states, cities, a zone, or particular sections. They get a PDF to read and print, and a CSV of the same tables to analyse. Every number comes from TSE's signed files. Every sum we compute is labelled as ours and, where TSE publishes the same total, checked against it.

A report can need hundreds of TSE files, for example every city in Minas Gerais or every section of a zone. So reports go into a queue, are built in the background through the rate-limited client, and show their progress live.

## What the data allows (checked 11/10/2026)

| Place | Source | Files per office |
|---|---|---|
| Brazil (federal offices) | TSE file `br` | 1 |
| Region (N, NE, CO, SE, S) | **our sum** of the region's state files | 3–9 |
| State | TSE state file; for municipal offices, our sum of every city | 1, or up to 853 (MG) |
| City | TSE city file, **also for general elections**: `ac01066-c0001-e006257-u.jws` and `-c0006-e006259-` both return 200 | 1 |
| Zone | **our sum** of the BUs of its sections (TSE publishes no zone file) | 1 per section, plus 2 to check its signatures |
| Section | the BU, as Minha seção reads it | 3 |

- Section files exist for the 2026 1st round (pleito 3220) and for 2024 (pleito 452: `ele2024/arquivo-urna/452/config/ac/ac-p000452-cs.json` returns 200; 2nd round 453). Those for the 2026 2nd round (3221) arrive only after 25/10.
- URLs are only built from EA11, EA12 and the section config, as now.
- Cross-checks come with no extra requests:
  - The sum of the cities is compared with TSE's state file.
  - The sum of the states is compared with `br`.
  - The sum of a zone's sections is compared with nothing, because TSE publishes no zone total, and the report says so.

## The report spec

```
ReportSpec
  elections: [int]            one or more (e.g. President 1st vs 2nd round)
  offices:   [int]            offices those elections elect
  places:    [Place]          each with kind: br | region | uf | municipio | zona | secao
  breakdown: none | uf | municipio | zona   optional: one row per sub-place
  language:  pt | en
```

Before queuing, `relatorios.orcar(spec)` checks the spec and returns a quote: the number of files needed, how many are already stored, and the estimated time at the client's rate. Unknown places and office/place pairs that don't exist (e.g. Senador for a city) are refused with a reason.

## What the PDF contains

1. **Cover**:
   - what was asked, the report ID, when it was generated, and the SHA-256 of the PDF's data (printed so a paper copy can be matched to the stored file)
   - what the report proves and what it does not
2. **Per election × office × place**:
   - Majoritarian offices: ranking, votes, %, valid/blank/null, turnout.
   - Proportional offices: seats by party or federation, TSE's next to ours, QE, and elected candidates.
   - Each table has its Fonte line and file codes, and says whether it is TSE's file or our sum.
3. **Breakdown table**, when asked: one row per state, city or zone.
4. **Cross-checks**: every sum against TSE's total, with "confere" or the difference.
5. **Appendix**: every file used, with its URL, SHA-256, TSE signature status and, for BUs, the voting machine signature status.

Candidates get no colours (brand rule). The fonts are Archivo and Source Serif 4, as static instances in `urna_aberta_server/web/pdf/fonts` (the `pdf` package cannot read variable fonts; cut with fontTools `varLib.instancer`, OFL). The layout follows the Atlas plates.

The CSV is the same tables in long format: `eleicao, cargo, local, nivel, candidato|lista, votos, ...`.

## Server

- **`ReportRequest` table**:
  - owner (`AuthUser`, cascade), spec (JSON), status (`queued`, `running`, `ready`, `failed`), progress (files done/total), error, created, finished
  - storage keys for the PDF and CSV, and the spec's hash
- **Endpoint `relatorios`** (login required):
  - `orcar`, `pedir`, `listar`, `acompanhar(id)` (a stream), `baixar(id, formato)` (a signed storage URL that expires) and `apagar`
  - `publicar(id, sim)`: the owner may give a finished report a public link, `/r/<id>`. Anyone with it gets a page showing the request, report ID, hash and when it was generated, with PDF and CSV links. Publishing is off by default and can be undone.
- **Queue**:
  - `pedir` saves the request and schedules `ReportCall`, a FutureCall stored in the database, so it survives a restart.
  - Reports run one at a time, so they never compete with Resultados or live polling for the TSE rate.
  - Progress goes out through `session.messages` (one instance, so no Redis), and `acompanhar` sends it as it arrives.
  - On startup, any report left `running` is queued again.
- **Builder**:
  - It is pure Dart, so it can be tested on fixtures.
  - It works from the spec to a list of files, then to stored or fetched files, then to aggregates, and then to the PDF (`pdf` package) and the CSV.
  - It reuses `ResultsService` (EA20 reading, `allocateSeats`) and `SectionService` (BU, signatures).
- **Reuse**: not built. Each report reads stored files from the database, so building one again costs no TSE requests once its files are final.
- **Limits**:
  - One queued report per account.
  - At most 3,000 TSE files per report. That covers every city of MG for two offices, and roughly 5 zones' worth of sections. Planning stops as soon as a spec passes the limit, so Brazil broken down by zone is refused without listing every section first. The quote and the request are refused with `tooLarge`.
- **Cache**: the Câmara total goes into `session.caches.local`, keyed by the election and the newest stored file, to fix its 25 s cold call.

## App

- **"Novo relatório"**:
  - Opened from Resultados (prefilled with the current election, office and place), Minha seção (prefilled with the section), and Meu local.
  - It is a pushed screen, so the five tabs stay as they are.
  - Steps: elections → offices → places, with a picker for regions, states, cities and zones → breakdown. The quote is shown before confirming.
- **"Meus relatórios"** (in the account screen): each request with a live status chip and progress, then "Baixar PDF" and "Baixar CSV". A failed report shows its reason and "Tentar de novo".
- Every string is in pt and en.

## Delivery, in order (each step tested and committed on its own)

1. **Spec and quote**: models, validation against EA11, EA12 and the section config, the file list, and `orcar`. Written test-first.
2. **Aggregation**:
   - Region and multi-city sums, plus cross-checks against TSE's totals.
   - The zone sum from BUs.
   - Tests on archived fixtures: the 27 states summed must equal `br` for Presidente, and the 22 AC cities summed (new fixtures, 22 files) must equal the AC state file.
3. **Queue**: table and migration, `ReportCall`, progress messages, the `acompanhar` stream, storage, and download.
4. **PDF and CSV output**.
5. **App**: builder, quote, Meus relatórios, download.
6. **Câmara cache.**

Then step 4 of the hackathon list, health checks.

## Open points

