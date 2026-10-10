# Urna Aberta

**Acompanhe e confira a divulgação dos resultados das eleições brasileiras a partir dos arquivos oficiais do TSE.**
Follow and verify the publication of Brazilian election results, straight from TSE's official files.

Urna Aberta reads TSE's own signed result files and lets anyone follow an election count live, or look up the result of any Brazilian election, every office, in every state and municipality: President, Governor, Senator, federal, state and district deputies, and in municipal years Mayor and city councillors. Where a number can be recomputed, it recomputes it and says whether it matches TSE: the sum of the states against the national file, the seat allocation of every proportional race, the urna's own signature on the files of your polling section.

It is an independent cross-check, not an official source. It reads only files TSE publishes, never estimates a number, and says plainly what it proves and what it does not. The night of October 4, 2026, when TSE's national display stopped for about 50 minutes while the states kept publishing, is kept as a case study you can replay.

## Português

A Urna Aberta lê os arquivos assinados do TSE para você acompanhar a apuração ao vivo e consultar o resultado de qualquer eleição brasileira, de qualquer cargo, em cada estado e município: de Presidente a Vereador. Onde dá para refazer a conta, refaz e mostra se bate com a do TSE: a soma dos estados contra o arquivo nacional, a distribuição das vagas de deputados e vereadores, a assinatura da própria urna na sua seção. Explica em capítulos curtos, com fontes oficiais, como o resultado sai da urna e chega até você. Português e inglês.

## What it does

| Screen | What you get |
|---|---|
| **Apuração** (counting) | TSE's national file and the independent sum of the states, side by side, with a divergence banner, a map by region or by sections totalized, and a timeline. Live on election night (2nd round: from 17:00 Brasília time on October 25, 2026, until 06:00 the next day); otherwise the October 4 case study, replayed with play, pause, 10×/60× and "jump to the pause". |
| **Resultados** (results) | Any election TSE lists (2024 municipal, 2026 general), any office, any UF or municipality. Majoritarian offices: ranking with votes, share and status. Deputies and councillors: seats per party or federation, TSE's next to ours with a "matches TSE" badge or every difference, why a party-quotient seat went unfilled, and a searchable candidate list. Deputado Federal for Brazil sums the 27 races into the Câmara (513 seats). |
| **Minha seção** (my section) | State → municipality → zone → section. Shows the official ballot box report (boletim de urna, BU) with the votes for every office, next to blank fields for the numbers on the paper copy, and flags any line that differs. Checks the BU's hash against the file list the voting machine signed, and that machine's own signature (see below). |
| **Verificar** (verify) | Every stored result file with its TSE signature status. Your device can re-check any signature itself, without trusting our server. |
| **Entenda** (learn) | Eight short chapters, each sourced to official pages (TSE, the Electoral Code, STF): the path of the vote, the BU, the machine's files, signatures and hashes, security protocols, October 4, how seats are distributed, and what this app proves. |

Every figure carries its source line and TSE file code. Anything that is not official data (the replay's state-by-state curve during the pause, for instance) is stamped *simulação*. Candidates never get a color.

## What is verified, and how

- **TSE result files** (`.json` + signed `.jws`): EdDSA, Ed25519, checked against TSE's official key, pinned in `urna_aberta_server/lib/src/verify/jws.dart`. The key is never taken from the file being checked.
- **The section's BU**: its SHA-512 must equal the hash the voting machine listed in its signature file (`-vota.vsc`), and that listing must hash to the value the machine signed.
- **The voting machine's own signature** (2020 and 2022 models): Ed521, which is EdDSA on curve E-521 with SHAKE256, as in TSE's *Manual do QR Code no Boletim de Urna*. The machine signs SHA-512 of its listing's hash. Its certificate must be signed by TSE's urna certification authority (AC UE2022 or AC UE2020), whose keys are pinned in `urna_aberta_server/lib/src/secao/urna_certificate.dart`. Each pinned key verifies its CA's live revocation list on `acue20xx.tse.jus.br`. The CA certificates came from a public mirror of TSE's file-format package, not from a tse.jus.br download, and the parent CA (AC URNA v2) is not checked. Older machine models use an algorithm this app does not check; the app says so instead of claiming a result.

- **Seat allocation** (deputies, councillors): recomputed from the votes in each signed file, following the Electoral Code (arts. 106–112), TSE Resolution 23.677 and the 2024 STF ruling on remainders, in `urna_aberta_server/lib/src/results/seats.dart`. It matches TSE's quotient, seats per list and elected candidates on all 80 archived races (2026 deputies in every UF, 2024 councils in the 26 capitals); any difference would be shown.

**What none of this proves:** anything about how a voting machine works, its software, or whether each vote was recorded as the voter intended. It also cannot tell that the published BU matches the paper one; that comparison is yours, with the posted report or TSE's Boletim na Mão app.

## How it is built

```
urna_aberta_server/   Serverpod 4 server (Dart)
  lib/src/tse/        URL builder, rate-limited TSE client, EA11/EA20 readers
  lib/src/tally/      independent national sum and divergence detection
  lib/src/live/       election-night polling (a FutureCall every 30 s)
  lib/src/replay/     1st-round replay on a virtual clock
  lib/src/secao/      section lookup, BU and signature decoding, Ed521
  lib/src/results/    any office's result, seat allocation, the Câmara
  lib/src/verify/     TSE JWS signature checks
urna_aberta_client/   generated client (do not edit)
urna_aberta_flutter/  Flutter app for iOS, Android and web
  lib/design/         the "Atlas IBGE" design system
  lib/l10n/           pt-BR and en strings
fixtures/             archived TSE files, 2026 1st round and 2024 municipal (Git LFS), see fixtures/README.md
```

Polling respects TSE's servers: one global token bucket, conditional GETs only, and a back-off after any 404. Outside the live window the server makes no requests. Set `URNA_LIVE=off` to disable live polling entirely.

## Running it

You need the Flutter SDK (3.44 or later), the Serverpod CLI 4.0, and Git LFS (`git lfs install` before cloning, so the fixtures download).

```sh
git clone https://github.com/kterto/urna_aberta.git
cd urna_aberta
serverpod start
```

`serverpod start` runs the server with its embedded PostgreSQL, applies migrations, launches the Flutter app, and hot-reloads both as you edit. At startup the server loads any 1st-round files from `fixtures/` it has not stored yet, for the replay.

The design-system gallery is not part of the app; run it with `flutter run -t lib/showcase/main.dart` from `urna_aberta_flutter`.

## Tests

```sh
cd urna_aberta_server && dart test       # no Docker needed: Serverpod manages the test database
cd urna_aberta_flutter && flutter test
```

Signature tests run against real TSE files in `fixtures/`, including a voting machine's signature file and certificate.

## Data sources

All data comes from TSE's results CDN (`resultados.tse.jus.br`), fetched as signed `.jws` files, and its published specifications (EA11 to EA20, the JWS verification manual, the BU QR code manual). Results are fetched on demand, once per file, and stored with their signature. Chapter sources are linked inside the app. Product notes: `PRODUCT.md`; full spec: `HANDOFF.md`.
