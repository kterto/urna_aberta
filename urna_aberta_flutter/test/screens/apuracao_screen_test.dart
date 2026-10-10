import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:urna_aberta_client/urna_aberta_client.dart';
import 'package:urna_aberta_flutter/design/widgets/atlas_components.dart';
import 'package:urna_aberta_flutter/replay/replay_controller.dart';
import 'package:urna_aberta_flutter/screens/apuracao_screen.dart';
import '../support/test_app.dart';

DateTime brt(int day, int hour, int minute) =>
    DateTime.utc(2026, 10, day, hour + 3, minute);

class StubSource implements TallySource {
  StubSource({this.origin = DataOrigin.synthetic, this.fail});

  final DataOrigin origin;
  Object? fail;

  @override
  Future<ReplayNight> night() async {
    if (fail != null) throw fail!;
    return ReplayNight(
      origin: DataOrigin.synthetic,
      electionCode: 6257,
      officeCode: 1,
      start: brt(4, 17, 0),
      end: brt(5, 1, 0),
      freezeStart: brt(4, 21, 2),
      freezeEnd: brt(4, 21, 57),
      finalsGeneratedAt: brt(5, 12, 52),
    );
  }

  @override
  Future<TallyFrame> frame(DateTime at) async => TallyFrame(
    at: at,
    origin: origin,
    nationalPct: 64.81,
    statesPct: 74.8,
    missingScopes: [],
    candidates: [
      CandidateVotes(
        candidateNumber: 22,
        national: 100,
        states: 120,
        ballotName: 'FULANO DE TAL',
        party: 'XX',
      ),
    ],
    ufs: [UfProgress(scopeCode: 'sp', sectionsTotal: 10, sectionsTotalized: 7)],
  );

  @override
  Future<List<TimelinePoint>> timeline(
    DateTime from,
    DateTime to,
    int stepSeconds,
  ) async => [
    for (
      var t = from;
      !t.isAfter(to);
      t = t.add(Duration(seconds: stepSeconds))
    )
      TimelinePoint(at: t, nationalPct: 10, statesPct: 12),
  ];
}

Future<void> pumpScreen(
  WidgetTester tester,
  TallySource source, {
  Locale locale = const Locale('pt'),
  Size size = const Size(400, 2400),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    testApp(
      locale: locale,
      home: TallyScope(
        source: source,
        child: const Scaffold(body: ApuracaoScreen()),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
}

void main() {
  testWidgets('shows both sources, candidates and Brasília time', (
    tester,
  ) async {
    await pumpScreen(tester, StubSource());
    expect(find.textContaining('64,81'), findsWidgets);
    expect(find.textContaining('74,8'), findsWidgets);
    expect(find.textContaining('FULANO DE TAL'), findsOneWidget);
    expect(find.textContaining('21:40'), findsWidgets);
  });

  testWidgets('non-live data carries the simulation stamp', (tester) async {
    await pumpScreen(tester, StubSource());
    expect(find.byType(SimulationStamp), findsWidgets);
  });

  testWidgets('live data: the figure plates carry no simulation stamp', (
    tester,
  ) async {
    await pumpScreen(tester, StubSource(origin: DataOrigin.live));
    for (final title in [
      'Comparação das duas fontes · Presidente',
      'Votos por candidatura, nas duas fontes',
    ]) {
      expect(
        find.descendant(
          of: find.widgetWithText(Plate, title),
          matching: find.byType(SimulationStamp),
        ),
        findsNothing,
        reason: title,
      );
    }
  });

  testWidgets('a failed load explains and retries', (tester) async {
    final source = StubSource(fail: Exception('offline'));
    await pumpScreen(tester, source);
    expect(find.text('Tentar de novo'), findsOneWidget);
    source.fail = null;
    await tester.tap(find.text('Tentar de novo'));
    await tester.pump();
    await tester.pump();
    expect(find.textContaining('FULANO DE TAL'), findsOneWidget);
  });

  for (final size in const [Size(400, 2400), Size(1300, 2400)]) {
    testWidgets('in English, with English numbers (${size.width.toInt()}px)', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        StubSource(),
        locale: const Locale('en'),
        size: size,
      );
      expect(find.text('The two sources compared · President'), findsOneWidget);
      expect(find.text('TSE national file'), findsOneWidget);
      expect(find.text('64.81%'), findsWidgets);
      expect(find.textContaining('64,81'), findsNothing);
      expect(find.text('Simulated replay'.toUpperCase()), findsOneWidget);
      expect(find.text('frozen since 21:02'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
