# Urna Aberta

**Acompanhe e confira a divulgação dos resultados das eleições brasileiras a partir dos arquivos oficiais do TSE.**
Follow and verify the publication of Brazilian election results, straight from TSE's official files.

On the night of the 1st round, October 4, 2026, TSE's national results display stopped updating for about 50 minutes at 64.81%. The count kept going: every state's own file was still being published. Urna Aberta makes that visible. It sums the per-state files itself, puts the sum next to TSE's national file, checks every file's digital signature, and lets a voter check their own polling section against the paper report posted at the door.

It is an independent cross-check, not an official source. It reads only files TSE publishes, never estimates a number, and says plainly what it proves and what it does not.

## Português

A Urna Aberta soma os arquivos de resultado de cada UF e compara com o arquivo nacional do TSE, ao vivo na noite da eleição e em replay da noite do 1º turno. Confere a assinatura digital do TSE em cada arquivo, busca o boletim de urna oficial de qualquer seção, confere o hash do boletim e a assinatura da própria urna, e explica em capítulos curtos, com fontes do TSE, como o resultado sai da urna e chega até você. O app está em português e inglês.

## What it does

| Screen | What you get |
|---|---|
| **Apuração** (counting) | TSE's national file and the independent sum of the states, side by side, with a divergence banner, a map by region or by sections totalized, and a timeline. Live on election night (2nd round: from 17:00 Brasília time on October 25, 2026, until 06:00 the next day); otherwise a replay of the 1st-round night with play, pause, 10×/60× and "jump to the pause". |
| **Minha seção** (my section) | State → municipality → zone → section. Shows the official ballot box report (boletim de urna, BU) with the votes for every office, next to blank fields for the numbers on the paper copy, and flags any line that differs. Checks the BU's hash against the file list the voting machine signed, and that machine's own signature (see below). |
| **Verificar** (verify) | Every stored result file with its TSE signature status. Your device can re-check any signature itself, without trusting our server. |
| **Entenda** (learn) | Seven short chapters, each sourced to official TSE pages: the path of the vote, the BU, the machine's files, signatures and hashes, security protocols, October 4, and what this app proves. |

Every figure carries its source line and TSE file code. Anything that is not official data (the replay's state-by-state curve during the pause, for instance) is stamped *simulação*. Candidates never get a color.

## What is verified, and how

- **TSE result files** (`.json` + signed `.jws`): EdDSA, Ed25519, checked against TSE's official key, pinned in `urna_aberta_server/lib/src/verify/jws.dart`. The key is never taken from the file being checked.
- **The section's BU**: its SHA-512 must equal the hash the voting machine listed in its signature file (`-vota.vsc`), and that listing must hash to the value the machine signed.
- **The voting machine's own signature** (2020 and 2022 models): Ed521, which is EdDSA on curve E-521 with SHAKE256, as in TSE's *Manual do QR Code no Boletim de Urna*. The machine signs SHA-512 of its listing's hash. Its certificate must be signed by TSE's urna certification authority (AC UE2022 or AC UE2020), whose keys are pinned in `urna_aberta_server/lib/src/secao/urna_certificate.dart`. Each pinned key verifies its CA's live revocation list on `acue20xx.tse.jus.br`. The CA certificates came from a public mirror of TSE's file-format package, not from a tse.jus.br download, and the parent CA (AC URNA v2) is not checked. Older machine models use an algorithm this app does not check; the app says so instead of claiming a result.

**What none of this proves:** anything about how a voting machine works, its software, or whether each vote was recorded as the voter intended. It also cannot tell that the published BU matches the paper one; that comparison is yours, with the posted report or TSE's Boletim na Mão app.

## How it is built

```
urna_aberta_server/   Serverpod 4 server (Dart)
  lib/src/tse/        URL builder, rate-limited TSE client, EA11/EA20 readers
  lib/src/tally/      independent national sum and divergence detection
  lib/src/live/       election-night polling (a FutureCall every 30 s)
  lib/src/replay/     1st-round replay on a virtual clock
  lib/src/secao/      section lookup, BU and signature decoding, Ed521
  lib/src/verify/     TSE JWS signature checks
urna_aberta_client/   generated client (do not edit)
urna_aberta_flutter/  Flutter app for iOS, Android and web
  lib/design/         the "Atlas IBGE" design system
  lib/l10n/           pt-BR and en strings
fixtures/2026-1t/     archived 1st-round TSE files (Git LFS), see fixtures/README.md
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

All data comes from TSE's results CDN (`resultados.tse.jus.br`) and its published specifications (EA11 to EA20, the JWS verification manual, the BU QR code manual). Chapter sources are linked inside the app. Product notes: `PRODUCT.md`; full spec: `HANDOFF.md`.
