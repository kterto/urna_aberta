import 'package:flutter_test/flutter_test.dart';
import 'package:urna_aberta_client/urna_aberta_client.dart';
import 'package:urna_aberta_flutter/relatorios/novo_relatorio_controller.dart';

import '../resultados/fake_resultados_source.dart';
import '../secao/fake_secao_source.dart';
import 'fake_relatorios_source.dart';

final ac = ReportPlace(kind: ReportPlaceKind.uf, uf: 'ac');
final porto = ReportPlace(
  kind: ReportPlaceKind.municipio,
  uf: 'ac',
  municipio: 1066,
);

void main() {
  late FakeRelatoriosSource reports;
  late NovoRelatorioController c;

  NovoRelatorioController make({
    ReportDraft draft = const ReportDraft(),
    DateTime? now,
  }) => NovoRelatorioController(
    reports: reports,
    results: FakeResultadosSource(),
    sections: FakeSecaoSource(),
    draft: draft,
    debounce: Duration.zero,
    now: () => now ?? DateTime.utc(2026, 10, 11, 12),
  );

  setUp(() {
    reports = FakeRelatoriosSource();
    c = make();
  });

  tearDown(() => c.dispose());

  test('opens on the newest voting day TSE has published', () async {
    await c.start();
    // The 2nd round (25/10) has not been held yet.
    expect(c.rounds.map((r) => r.day), [
      DateTime.utc(2026, 10, 4),
      DateTime.utc(2024, 10, 27),
      DateTime.utc(2024, 10, 6),
    ]);
    expect(c.days, {DateTime.utc(2026, 10, 4)});
    expect(c.availableOffices, [1, 3, 5, 6, 7, 8]);
  });

  test('a spec needs an election, an office and a place', () async {
    await c.start();
    expect(c.spec, isNull);
    c.toggleOffice(1);
    expect(c.spec, isNull);
    c.addPlace(ac);
    final spec = c.spec!;
    expect(spec.elections, [6259, 6257]);
    expect(spec.offices, [1]);
    expect(spec.places.single.uf, 'ac');
  });

  test('quotes only when signed in, after each change', () async {
    await c.start();
    c
      ..toggleOffice(1)
      ..addPlace(ac);
    await pumpEventQueue();
    expect(reports.quoted, isEmpty);
    c.setSignedIn(true);
    expect(c.quoting, isTrue);
    await pumpEventQueue();
    expect(c.quote!.files, 23);
    c.setBreakdown(ReportBreakdown.municipio);
    expect(c.quote, isNull);
    await pumpEventQueue();
    expect(reports.quoted.last.breakdown, ReportBreakdown.municipio);
    expect(c.quote, isNotNull);
  });

  test('a refusal is kept with its reason', () async {
    reports.refuse = ReportRefused(message: 'x', reason: 'tooLarge');
    await c.start();
    c
      ..setSignedIn(true)
      ..toggleOffice(1)
      ..addPlace(ReportPlace(kind: ReportPlaceKind.br));
    await pumpEventQueue();
    expect(c.refusal!.reason, 'tooLarge');
    expect(c.quote, isNull);
  });

  test('a place is added once, and can be removed', () async {
    await c.start();
    c
      ..addPlace(porto, city: 'PORTO WALTER')
      ..addPlace(porto, city: 'PORTO WALTER');
    expect(c.places, hasLength(1));
    expect(c.cityName(porto), 'PORTO WALTER');
    c.removePlace(porto);
    expect(c.places, isEmpty);
  });

  test('a draft opens on its day, offices and places', () async {
    c = make(
      draft: ReportDraft(
        day: DateTime.utc(2024, 10, 6),
        offices: {11, 1},
        places: [porto],
        names: {'ac01066': 'PORTO WALTER'},
      ),
    );
    await c.start();
    expect(c.days, {DateTime.utc(2024, 10, 6)});
    // President is not voted that day.
    expect(c.offices, {11});
    expect(c.cityName(porto), 'PORTO WALTER');
  });

  test('zones and sections only for the 2026 1st round', () async {
    await c.start();
    expect(c.sectionsAvailable, isTrue);
    c.addPlace(
      ReportPlace(
        kind: ReportPlaceKind.zona,
        uf: 'ac',
        municipio: 1066,
        zona: 4,
      ),
    );
    c.toggleDay(DateTime.utc(2024, 10, 6));
    expect(c.sectionsAvailable, isFalse);
    expect(c.places, isEmpty);
  });

  test('submitting queues the spec', () async {
    await c.start();
    c
      ..setSignedIn(true)
      ..toggleOffice(1)
      ..addPlace(ac);
    await pumpEventQueue();
    final r = await c.submit();
    expect(r!.status, ReportStatus.queued);
    expect(reports.requested.single.places.single.uf, 'ac');
  });

  test('a busy refusal on submit is shown, not thrown', () async {
    await c.start();
    c
      ..setSignedIn(true)
      ..toggleOffice(1)
      ..addPlace(ac);
    await pumpEventQueue();
    reports.refuse = ReportRefused(message: 'x', reason: 'busy');
    expect(await c.submit(), isNull);
    expect(c.refusal!.reason, 'busy');
  });

  test('placeKey matches the server', () {
    expect(placeKey(ReportPlace(kind: ReportPlaceKind.br)), 'br');
    expect(placeKey(porto), 'ac01066');
    expect(
      placeKey(
        ReportPlace(
          kind: ReportPlaceKind.secao,
          uf: 'ac',
          municipio: 1066,
          zona: 4,
          secao: 77,
        ),
      ),
      'ac01066z0004s0077',
    );
  });
}
