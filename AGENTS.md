# Urna Aberta (Flutter & Serverpod project)

Urna Aberta lets anyone follow a Brazilian election count and analyse the results of any election, every office, from TSE's signed files, verify them, and learn how the process works. Bilingual pt-BR / en. Product truth lives in `PRODUCT.md`, the full spec in `HANDOFF.md`.

## Design system

- Visual world: "Atlas IBGE" (thematic atlas plates). Approved reference page: https://claude.ai/artifact/NRLMS5JuxKwVYYwDijN4s7. Direction contract: `.impeccable/surfaces/urna-aberta-flutter-lib-design.md`.
- Code: `urna_aberta_flutter/lib/design/` — `tokens.dart` (AtlasPalette light/dark as a ThemeExtension, Regiao, spacing, motion), `typography.dart` (bundled Archivo + Source Serif 4), `theme.dart`, `platform.dart` (iOS / Android / web idioms, icons), `geo/brasil_geo.dart` (IBGE UF + region outlines from `assets/geo/brasil_uf.json`), `widgets/` (Plate, FileCode, SimulationStamp, StatusBadge, DivergenceBanner, BrazilMap, MapPlate, SourceDuo, MirroredBars, TimelineChart, UfSmallMultiples, ReplayBar, AtlasPage).
- Rules: candidacies never get a color; every figure carries a Fonte line and its TSE file code; any non-official data shows `SimulationStamp`; status always icon + label; region and data colors were validated for color-vision deficiency, so change them only after re-running a palette validator.
- App icon and favicon: SVG masters and generator in `urna_aberta_flutter/assets/brand/` (same glyph as the wordmark `_BallotMark`); rerun `sh assets/brand/build_icons.sh` after changing them, never edit the generated PNGs.
- Shell (`lib/app/shell.dart`): wide web = masthead; wide native = NavigationRail; iOS phone = CupertinoTabBar; Android phone = NavigationBar. Sections: Apuração, Resultados, Minha seção, Verificar, Entenda (named in `Section`). Routes live in `lib/app/router.dart` (go_router, path URLs under the `/app/` base; Serverpod's `FlutterRoute` answers any `/app/...` path with the app): each section is a `StatefulShellRoute` branch keeping its state, Entenda chapters are `/entenda/N`, and `/conta`, `/relatorios`, `/relatorios/novo` are pushed over the shell with `context.push` so the section underneath survives. Add a screen there, never with `Navigator.push`, or a refresh loses it. The design-system gallery (`lib/showcase/design_system_screen.dart`) is not linked from the app; run it with `flutter run -t lib/showcase/main.dart`.
- Resultados: `urna_aberta_server/lib/src/results/` (full EA20 reader, `seats.dart` proportional allocation that must match TSE on every archived race, `ResultsService` fetching signed `.jws` once into `result_file`). Never request a file before an election's polls close or for a municipality EA12/EA11 does not list: a 404 pauses every TSE request. App side: `lib/resultados/` + `lib/screens/resultados_screen.dart`.
- Live count: `urna_aberta_server/lib/src/live/`. A recurring FutureCall (`LivePollCall`, every 30 s, scheduled in `server.dart`) polls each election's EA20 `.jws` files with conditional GETs only inside its live window (17:00 Brasília on election day to 06:00 next day; elections and dates come from EA11). Before TSE publishes, it probes one file per election and waits 5 min after a 404. Off with `URNA_LIVE=off`. Never import `src/generated/future_calls.dart` from a FutureCall file: its analysis then fails and the file is never generated.
- Languages: pt-BR (source) and en, via `gen_l10n`. Every user-facing string goes in `urna_aberta_flutter/lib/l10n/app_pt.arb` (template) and `app_en.arb`, read with `context.l10n`; numbers, percentages and times through `lib/l10n/format.dart` (`context.integer/percent/hm/dayHm`). The app follows the device language until the viewer picks one (`localeNotifier`; masthead PT | EN on wide web, app-bar menu elsewhere). Server messages are Portuguese: the app shows its own text chosen by exception type. The design-system gallery stays Portuguese-only.
- `lib/showcase/sample_data.dart` is SIMULATION data (anonymous candidacies) used only by the design-system gallery. Apuração reads the server's `tally` endpoint through `lib/replay/replay_controller.dart` (`TallyScope` provides the source; each viewer owns its replay clock).


This project is a Flutter app (frontend) backed by a Serverpod server (backend). Always build the app's backend with Serverpod.
Build for multiple users, use Serverpod's built-in authentication, which is already set up in `lib/server.dart`.

The user starts the server and Flutter app with `serverpod start`. There is no need to check if the server is running: make the changes and call the `serverpod` MCP tools as needed. If the server is not running, an informative error message will be received from the MCP server. Then STOP and ask the user to start it. NEVER start the server yourself. The Flutter app is started along with it, or can be launched from the MCP tool `spawn_flutter_app`.

While running, `serverpod start` watches for file changes to run incremental code generation and hot reload both the server and the Flutter app.

Calling `serverpod generate` directly is not needed, but might be useful to troubleshoot when an incremental generation fails.

ALWAYS use the MCP server instead of the command line. Use the MCP server to:

- `create_migration` and `apply_migrations` for database (after you change data models).
- `create_repair_migration` if the database has drifted out of sync with the migrations.
- `tail_server_logs` to read logs from the server.
- `tail_flutter_logs` to read the raw stdout/stderr of the Flutter app.
- `hot_reload` / `hot_restart` to reload or restart the server and the Flutter app. ALWAYS call `hot_restart` after doing changes in the Flutter app that may not work with normal hot reload (which is automatically applied).
- `spawn_flutter_app` to start a Flutter app declared under `serverpod: flutter_apps:` in the server `pubspec.yaml`.
- `get_flutter_app_dtd` (Dart tooling daemon) for connecting to the app through the `dart` MCP.

NEVER edit generated code. The server's `lib/src/generated/` directory and the whole `urna_aberta_client` package are rewritten by the code generator. Change the `.spy.yaml` models, the endpoints, or `lib/server.dart` instead.

Migrations are a narrow exception: the `migration.sql` of a generated migration MAY be edited by hand when the generated SQL would lose data — to add a data transformation, or to reach a destructive change through non-destructive steps. Never touch the other files in the migration directory, and keep the schema the SQL ends up with identical to `definition.sql` — new databases are created from that file and never run `migration.sql`.

Only when the server cannot be started at all, fall back to the CLI in the server package:

- `serverpod generate` to regenerate the client and the generated server code.
- `serverpod create-migration` after changing a model with a `table` (add `--force` for destructive changes). It only writes the migration; `serverpod start` applies pending migrations when it boots the server.

Tests need no Docker. `config/test.yaml` sets `database.dataPath`, so Serverpod starts and manages the test database (an embedded PostgreSQL) itself, and the project's `docker-compose.yaml` is not used for it. Just run `dart test` in the server package.

Checklist after doing changes, in this order:

- `dart analyze` (CLI)
- `dart format` (CLI)
- `create_migration` and `apply_migrations` (MCP - only if necessary)
- Do `serverpod` MCP `hot_restart` if required (hot reload is done automatically). Will also hot restart Flutter app
- Run tests, if applicable (`dart test` in the server package)
- Check `serverpod` MCP `tail_server_logs` and `tail_flutter_logs` for any issues.

If the user asks you to test the app:

1. Use `get_flutter_app_dtd` (`serverpod` MCP) to get the Flutter app's DTD
2. Pass the DTD to `connect_dart_tooling_daemon` (`dart` MCP) to connect to the app
3. Use `flutter_driver` (`dart` MCP) to navigate through the app

The app is launched from `urna_aberta_flutter/lib/driver.dart`, which starts the Flutter driver extension with text entry emulation turned off so the app stays usable by hand. To let the driver type, set `enableTextEntryEmulation: true` there and `hot_restart` the app.

