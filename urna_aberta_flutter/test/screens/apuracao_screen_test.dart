import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:urna_aberta_client/urna_aberta_client.dart';
import 'package:urna_aberta_flutter/design/widgets/atlas_components.dart';
import 'package:urna_aberta_flutter/design/widgets/replay_bar.dart';
import 'package:urna_aberta_flutter/replay/replay_controller.dart';
import 'package:urna_aberta_flutter/screens/apuracao_screen.dart';
import '../support/test_app.dart';

DateTime brt(int day, int hour, int minute) =>
    DateTime.utc(2026, 10, day, hour + 3, minute);

class StubSource implements TallySource {
  /// Before the 2nd round: nothing live yet. Far-future dates keep the
  /// "starts on" notice true whenever the test runs.
  LiveStatus liveStatus = LiveStatus(
    electionCode: 6258,
    round: 2,
    opensAt: DateTime.utc(2099, 10, 25, 20),
    closesAt: DateTime.utc(2099, 10, 26, 9),
    open: false,
    timeline: [],
    divergence: [],
  );

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
      freezeStart: brt(4, 19, 14),
      freezeEnd: brt(4, 20, 4),
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

  @override
  Future<LiveStatus> live() async => liveStatus;
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
    // The replay opens paused at the start of the count.
    expect(find.text('17:00'), findsWidgets);
  });

  testWidgets('"jump to the pause" goes straight to the freeze', (
    tester,
  ) async {
    await pumpScreen(tester, StubSource());
    await tester.tap(find.text('Ir para a pausa'));
    await tester.pump();
    await tester.pump();
    expect(find.text('parado desde 19:14'), findsOneWidget);
  });

  testWidgets('no headline about one night, no design-system shortcut', (
    tester,
  ) async {
    await pumpScreen(tester, StubSource());
    expect(find.text('A contagem não parou.'), findsNothing);
    expect(find.byTooltip('Sistema de design'), findsNothing);
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
      await tester.tap(find.text('Jump to the pause'));
      await tester.pump();
      await tester.pump();
      expect(find.text('The two sources compared · President'), findsOneWidget);
      expect(find.text('TSE national file'), findsOneWidget);
      expect(find.text('64.81%'), findsWidgets);
      expect(find.textContaining('64,81'), findsNothing);
      expect(find.text('Simulated replay'.toUpperCase()), findsOneWidget);
      expect(find.text('frozen since 19:14'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  group('live count', () {
    LiveStatus liveNow({bool withFrame = true}) => LiveStatus(
      electionCode: 6258,
      round: 2,
      opensAt: DateTime.utc(2026, 10, 25, 20),
      closesAt: DateTime.utc(2099, 10, 26, 9),
      open: true,
      frame: withFrame
          ? TallyFrame(
              at: DateTime.utc(2026, 10, 25, 22, 15),
              origin: DataOrigin.live,
              nationalPct: 51.2,
              statesPct: 55.4,
              missingScopes: [],
              candidates: [
                CandidateVotes(
                  candidateNumber: 13,
                  national: 900,
                  states: 950,
                  ballotName: 'BELTRANO',
                  party: 'YY',
                ),
              ],
              ufs: [
                UfProgress(
                  scopeCode: 'ba',
                  sectionsTotal: 10,
                  sectionsTotalized: 6,
                ),
              ],
            )
          : null,
      timeline: [
        TimelinePoint(
          at: DateTime.utc(2026, 10, 25, 20, 30),
          nationalPct: 10,
          statesPct: 11,
        ),
        TimelinePoint(
          at: DateTime.utc(2026, 10, 25, 22, 15),
          nationalPct: 51.2,
          statesPct: 55.4,
        ),
      ],
      divergence: [],
    );

    testWidgets('before the count: the replay, and when live starts', (
      tester,
    ) async {
      await pumpScreen(tester, StubSource());
      expect(find.textContaining('começa em 25/10, às 17h'), findsOneWidget);
      expect(find.byType(ReplayBar), findsOneWidget);
      expect(find.byType(LiveStamp), findsNothing);
      // The replay is a case study, and final results are a tap away.
      expect(find.textContaining('caso real'), findsOneWidget);
      expect(find.text('Ver os resultados finais'), findsOneWidget);
    });

    testWidgets('polls closed, no file yet: says it is waiting', (
      tester,
    ) async {
      final source = StubSource()..liveStatus = liveNow(withFrame: false);
      await pumpScreen(tester, source);
      expect(find.textContaining('Aguardando os primeiros'), findsOneWidget);
      expect(find.byType(ReplayBar), findsOneWidget);
    });

    testWidgets('live files: the live count, marked live, no replay clock', (
      tester,
    ) async {
      final source = StubSource()..liveStatus = liveNow();
      await pumpScreen(tester, source);
      expect(find.byType(LiveStamp), findsOneWidget);
      expect(find.byType(ReplayBar), findsNothing);
      expect(find.byType(SimulationStamp), findsNothing);
      expect(find.textContaining('2º turno, ao vivo'), findsOneWidget);
      expect(find.textContaining('51,2'), findsWidgets);
      expect(find.textContaining('BELTRANO'), findsOneWidget);
      expect(find.text('atualizado 19:15'), findsWidgets);
      expect(find.text('br-c0001-e006258-u.json'), findsWidgets);
      // Governor and every other office counted tonight: in Resultados.
      expect(find.text('Ver todos os cargos em apuração'), findsOneWidget);
    });

    testWidgets('the viewer can switch to the replay and back', (
      tester,
    ) async {
      final source = StubSource()..liveStatus = liveNow();
      await pumpScreen(tester, source);
      await tester.tap(find.text('Caso: 4 de outubro'));
      await tester.pump();
      await tester.pump();
      expect(find.byType(ReplayBar), findsOneWidget);
      await tester.tap(find.text('Ao vivo'));
      await tester.pump();
      expect(find.byType(ReplayBar), findsNothing);
    });

    testWidgets('in English', (tester) async {
      final source = StubSource()..liveStatus = liveNow();
      await pumpScreen(tester, source, locale: const Locale('en'));
      expect(find.textContaining('round 2, live'), findsOneWidget);
      expect(find.textContaining('51.2'), findsWidgets);
      expect(find.text('LIVE'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
