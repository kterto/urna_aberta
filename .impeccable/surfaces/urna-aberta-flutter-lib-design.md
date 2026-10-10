---
version: 1
slug: "urna-aberta-flutter-lib-design"
primary_target: "urna_aberta_flutter/lib/design"
related_targets: ["urna_aberta_flutter/lib/showcase"]
---

# Surface: Urna Aberta design system + showcase

Scope: Flutter design system (tokens, themes, type, components, charts, Brazil map) shared by app (iOS/Android) and website (Flutter web), plus an in-app showcase route. Visitor mode: Operate (Learn chapters: Read).

Audience/job: voter on phone, election night, checks the count keeps moving and verifies own section; secondary jury/press on desktop.

## Direction contract

THESIS: The election read as an IBGE thematic atlas plate: five regional color fields, numbered legend keys, a source line under every figure. Refuses the news-portal results page (headline %, party-colored bars, generic choropleth).

OWN-WORLD: Cool atlas paper ground (#F3F5F1) / night plate ground (#0E1719); deep atlas-blue ink shell (masthead/rail). Five validated region hues (N green, NE ochre, CO rust, SE blue, S magenta), one teal sequential ramp for totalização, candidates in neutral ink only. Archivo / Archivo Narrow for UI, data and map lettering with tabular figures; Source Serif 4 for reading. Hairline graticule rules, square legend keys, figure frames as "Prancha" plates with Fonte lines.

STORY: Visitor sees the national file and the sum of states side by side, understands the count never stopped, taps a state or region, follows every number to its TSE file, then verifies their section.

FIRST VIEWPORT: Phone Apuração: compact top bar; two big tabular figures (TSE nacional | Soma dos estados) mirrored on one center rule with divergence banner; atlas map plate below with legend-as-control; native tab bar (Apuração · Minha seção · Verificar · Entenda). Web: atlas-blue masthead nav, 12-col grid, map plate 7 cols left, comparison and mirrored candidate pyramid 5 cols right, timeline full width beneath.

FORM: Atlas IBGE (impeccable's pick, my list #1), seed key 38f1cb38. Signature move: the atlas legend is the control — tapping a legend key or region focuses those UFs at full ink, the rest drop to half-tone. Raises kept: mirrored two-source pyramid on one center rule (labanotation); one fixed scale for all UF small multiples (botanical folio); file code as catalog number on every figure (catalog sleeve); hierarchy by scale contrast (type specimen); focus lifts one, dims rest (streaming wall).

FINISH: unreviewed and undocumented is unfinished; this build ends with the finish review, the verdict, DESIGN.md, and every shipping raster carrying its provenance
