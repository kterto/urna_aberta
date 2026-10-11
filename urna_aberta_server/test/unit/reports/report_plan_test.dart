import 'dart:io';

import 'package:test/test.dart';
import 'package:urna_aberta_server/src/generated/protocol.dart';
import 'package:urna_aberta_server/src/live/elections.dart';
import 'package:urna_aberta_server/src/reports/report_plan.dart';
import 'package:urna_aberta_server/src/secao/section_directory.dart';
import 'package:urna_aberta_server/src/tse/ea12.dart';
import 'package:urna_aberta_server/src/tse/tse_urls.dart';
import 'package:urna_aberta_server/src/verify/jws.dart';

const _root = '../fixtures';

final _ea12Cache = <int, Municipalities>{};

Municipalities _ea12(Election e) => _ea12Cache[e.day.$1] ??= _readEa12(e);

Municipalities _readEa12(Election e) {
  if (e.day.$1 == 2024) {
    final jws = File(
      '$_root/2024/oficial/ele2024/619/config/mun-e000619-cm.jws',
    ).readAsStringSync();
    return parseEa12(TseJws.parse(jws).payload);
  }
  return parseEa12(
    File(
      '$_root/2026-1t/oficial/ele2026/6257/config/mun-e006257-cm.json',
    ).readAsBytesSync(),
  );
}

ReportSpec spec(
  List<int> offices,
  List<ReportPlace> places, {
  List<int> elections = const [6257, 6259],
  ReportBreakdown breakdown = ReportBreakdown.none,
}) => ReportSpec(
  elections: elections,
  offices: offices,
  places: places,
  breakdown: breakdown,
  language: 'pt',
);

final br = ReportPlace(kind: ReportPlaceKind.br);
ReportPlace regiao(String r) =>
    ReportPlace(kind: ReportPlaceKind.regiao, regiao: r);
ReportPlace uf(String u) => ReportPlace(kind: ReportPlaceKind.uf, uf: u);
ReportPlace municipio(String u, int m) =>
    ReportPlace(kind: ReportPlaceKind.municipio, uf: u, municipio: m);
ReportPlace zona(String u, int m, int z) =>
    ReportPlace(kind: ReportPlaceKind.zona, uf: u, municipio: m, zona: z);
ReportPlace secao(String u, int m, int z, int s) => ReportPlace(
  kind: ReportPlaceKind.secao,
  uf: u,
  municipio: m,
  zona: z,
  secao: s,
);

Set<String> scopes(ReportPlan p) => {for (final r in p.results) r.scope.code};

void main() {
  final elections = parseElections(
    File('$_root/2026-1t/oficial/comum/config/ele-c.json').readAsBytesSync(),
  );
  final requestedDirs = <(int, String)>[];
  late ReportPlanner planner;

  setUp(() {
    requestedDirs.clear();
    planner = ReportPlanner(
      elections: () => elections,
      municipalities: (e) async => _ea12(e),
      sections: (pleito, year, u) async {
        requestedDirs.add((pleito, u));
        final file = File(
          '$_root/2026-1t/oficial/ele2026/arquivo-urna/$pleito/config/$u/'
          '$u-p00$pleito-cs.json',
        );
        return parseSectionConfig(file.readAsBytesSync());
      },
      now: () => DateTime.utc(2026, 10, 11, 12),
    );
  });

  Future<void> refused(ReportSpec s, String reason) => expectLater(
    planner.plan(s),
    throwsA(isA<ReportRefused>().having((e) => e.reason, 'reason', reason)),
  );

  group('places TSE publishes a file for', () {
    test('Brazil, for President, is the national file', () async {
      final p = await planner.plan(spec([1], [br]));
      expect(scopes(p), {'br'});
      expect(p.results.single.election, 6257);
      expect(p.files, 1);
      expect(p.items.single.summed, isFalse);
    });

    test('a state is its file, for every office asked', () async {
      final p = await planner.plan(spec([1, 3, 6], [uf('AC')]));
      expect(p.results, hasLength(3));
      expect(scopes(p), {'ac'});
      expect(p.items.map((i) => i.office), [
        Office.presidente,
        Office.governador,
        Office.deputadoFederal,
      ]);
    });

    test('a city is its file, for general elections too', () async {
      final p = await planner.plan(spec([1, 6], [municipio('ac', 1066)]));
      expect(scopes(p), {'ac01066'});
      expect(p.files, 2);
    });
  });

  group('places we sum', () {
    test('a region is the sum of its states', () async {
      final p = await planner.plan(spec([1], [regiao('n')]));
      expect(scopes(p), {'ac', 'am', 'ap', 'pa', 'ro', 'rr', 'to'});
      expect(p.items.single.summed, isTrue);
    });

    test('Brazil, for a state office, sums the states that elect it', () async {
      final p = await planner.plan(spec([3], [br]));
      expect(p.results, hasLength(27));
      expect(scopes(p), isNot(contains('zz')));
    });

    test('a state, for a municipal office, sums every city', () async {
      final p = await planner.plan(
        spec([11], [uf('ac')], elections: [619]),
      );
      expect(p.results, hasLength(22));
      expect(p.results.first.scope.isMunicipality, isTrue);
    });

    test('a zone is the sum of its sections', () async {
      final p = await planner.plan(spec([1, 3], [zona('ac', 1066, 4)]));
      expect(p.sections, hasLength(34));
      // Names come from each race's file: Brazil for President, AC for
      // Governor.
      expect(scopes(p), {'br', 'ac'});
      expect(p.items.first.reference!.scope.code, 'br');
      // Each section reads its aux file, BU and signature file, once for
      // both offices.
      expect(p.files, 34 * 3 + 2);
      expect(requestedDirs.toSet(), {(3220, 'ac')});
    });

    test('a section is its three files', () async {
      final p = await planner.plan(spec([1], [secao('ac', 1066, 4, 77)]));
      expect(p.sections.single.id.secao, 77);
      expect(p.files, 3 + 1);
    });
  });

  group('breakdown', () {
    test('Brazil by state lists every UF and abroad for President', () async {
      final p = await planner.plan(
        spec([1], [br], breakdown: ReportBreakdown.uf),
      );
      final item = p.items.single;
      expect(item.breakdown, hasLength(28));
      expect(p.results, hasLength(29));
    });

    test('a state by city reads every city file', () async {
      final p = await planner.plan(
        spec([1], [uf('ac')], breakdown: ReportBreakdown.municipio),
      );
      expect(p.items.single.breakdown, hasLength(22));
      expect(p.results, hasLength(23));
    });

    test('a city by zone reads every section of its zones', () async {
      final p = await planner.plan(
        spec([1], [municipio('ac', 1066)], breakdown: ReportBreakdown.zona),
      );
      expect(p.items.single.breakdown.single.place.zona, 4);
      expect(p.sections, hasLength(34));
    });

    test('is left out where it is not finer than the place', () async {
      final p = await planner.plan(
        spec([1], [municipio('ac', 1066)], breakdown: ReportBreakdown.uf),
      );
      expect(p.items.single.breakdown, isEmpty);
    });
  });

  test('files shared by items are read once', () async {
    final p = await planner.plan(
      spec([1], [uf('ac'), regiao('n')], breakdown: ReportBreakdown.uf),
    );
    expect(p.results, hasLength(7));
    expect(p.items, hasLength(2));
  });

  test('offices an election does not elect are skipped', () async {
    final p = await planner.plan(spec([1, 3], [uf('ac')]));
    expect(
      [for (final i in p.items) (i.election.code, i.office)],
      [
        (6257, Office.presidente),
        (6259, Office.governador),
      ],
    );
  });

  group('refuses', () {
    test('an office none of the elections elects', () async {
      await refused(spec([11], [br]), 'invalidRequest');
    });

    test('an election TSE does not list', () async {
      await refused(spec([1], [br], elections: [1234]), 'invalidRequest');
    });

    test('an election whose polls have not closed', () async {
      await refused(spec([1], [br], elections: [6258]), 'notPublished');
    });

    test('a city EA12 does not list', () async {
      await refused(spec([1], [municipio('ac', 99999)]), 'invalidRequest');
    });

    test('a zone the section config does not list', () async {
      await refused(spec([1], [zona('ac', 1066, 99)]), 'invalidRequest');
    });

    test('a section the section config does not list', () async {
      await refused(spec([1], [secao('ac', 1066, 4, 9999)]), 'invalidRequest');
    });

    test('a place missing the fields its kind needs', () async {
      await refused(
        spec([1], [ReportPlace(kind: ReportPlaceKind.municipio, uf: 'ac')]),
        'invalidRequest',
      );
    });

    test('an unknown region or UF', () async {
      await refused(spec([1], [regiao('x')]), 'invalidRequest');
      await refused(spec([1], [uf('xx')]), 'invalidRequest');
    });

    test('an office not elected in the place', () async {
      await refused(spec([8], [uf('sp')]), 'invalidRequest');
    });

    test('an empty spec', () async {
      await refused(spec([], [br]), 'invalidRequest');
      await refused(spec([1], []), 'invalidRequest');
    });

    test('a language other than pt or en', () async {
      await refused(
        ReportSpec(
          elections: [6257],
          offices: [1],
          places: [br],
          breakdown: ReportBreakdown.none,
          language: 'fr',
        ),
        'invalidRequest',
      );
    });
  });

  test('Presidente for all of Brazil by municipality fits', () async {
    final p = await planner.plan(
      spec([1], [br], elections: [6257], breakdown: ReportBreakdown.municipio),
    );
    // Every municipality, abroad included, plus Brazil's own file.
    expect(p.files, 5758);
    expect(p.files, lessThanOrEqualTo(ReportPlanner.fileLimit));
  });

  test('a spec over the limit is refused as soon as it passes it', () async {
    await refused(spec([11, 13], [br], elections: [619]), 'tooLarge');
    // Brazil by zone would list every zone of every UF first.
    await refused(spec([1], [br], breakdown: ReportBreakdown.zona), 'tooLarge');
  });

  test('every table names its place', () async {
    final p = await planner.plan(
      spec(
        [1],
        [br, regiao('ne'), uf('zz'), secao('ac', 1066, 4, 77)],
      ),
    );
    expect(p.items.map((i) => i.placeName), [
      'Brasil',
      'Nordeste',
      'Exterior',
      'PORTO WALTER (AC), zona 4, seção 77',
    ]);
    expect(placeCode(p.items.last.place), 'ac01066z0004s0077');
    final city = await planner.plan(
      spec([1], [municipio('ac', 1066)], breakdown: ReportBreakdown.zona),
    );
    expect(
      city.items.single.breakdown.single.placeName,
      'PORTO WALTER (AC), zona 4',
    );
  });
}
