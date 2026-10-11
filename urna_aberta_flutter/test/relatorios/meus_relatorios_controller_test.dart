import 'package:flutter_test/flutter_test.dart';
import 'package:urna_aberta_client/urna_aberta_client.dart';
import 'package:urna_aberta_flutter/relatorios/meus_relatorios_controller.dart';

import 'fake_relatorios_source.dart';

void main() {
  late FakeRelatoriosSource source;
  late List<Uri> opened;
  late MeusRelatoriosController c;

  setUp(() {
    source = FakeRelatoriosSource();
    opened = [];
    c = MeusRelatoriosController(source, open: (u) async => opened.add(u));
  });

  tearDown(() => c.dispose());

  test('an unfinished report is followed until it is ready', () async {
    source.reports = [
      sampleRequest(id: 7, status: ReportStatus.running, filesDone: 3),
    ];
    await c.load();
    final stream = source.streams[7]!;
    stream.add(
      sampleRequest(id: 7, status: ReportStatus.running, filesDone: 12),
    );
    await pumpEventQueue();
    expect(c.reports.single.filesDone, 12);
    stream.add(sampleRequest(id: 7));
    await pumpEventQueue();
    expect(c.reports.single.status, ReportStatus.ready);
  });

  test('a dropped stream is followed again while the report runs', () async {
    c = MeusRelatoriosController(
      source,
      open: (u) async => opened.add(u),
      followAgainAfter: Duration.zero,
    );
    source.reports = [
      sampleRequest(id: 7, status: ReportStatus.running, filesDone: 3),
    ];
    await c.load();
    // The server restarted: the stream ends, the report is queued again.
    await source.streams.remove(7)!.close();
    await pumpEventQueue();
    source.streams[7]!.add(
      sampleRequest(id: 7, status: ReportStatus.running, filesDone: 40),
    );
    await pumpEventQueue();
    expect(c.reports.single.filesDone, 40);

    source.streams.remove(7)!.addError(StateError('connection lost'));
    await pumpEventQueue();
    source.streams[7]!.add(sampleRequest(id: 7));
    await pumpEventQueue();
    expect(c.reports.single.status, ReportStatus.ready);
  });

  test('a finished report is not followed', () async {
    source.reports = [sampleRequest()];
    await c.load();
    expect(source.streams, isEmpty);
  });

  test('downloading opens a signed link', () async {
    source.reports = [sampleRequest(id: 3)];
    await c.load();
    await c.download(c.reports.single, 'pdf');
    expect(source.links, [(3, 'pdf')]);
    expect(opened.single.path, '/d/token-3-pdf');
  });

  test('publishing gives the report its public link', () async {
    source.reports = [sampleRequest(id: 3)];
    await c.load();
    await c.publish(c.reports.single, true);
    expect(c.reports.single.publicToken, 'tok3');
    expect(await c.publicLink(c.reports.single), endsWith('/r/tok3'));
    await c.publish(c.reports.single, false);
    expect(c.reports.single.publicToken, isNull);
  });

  test('deleting removes it', () async {
    source.reports = [sampleRequest(id: 3), sampleRequest(id: 4)];
    await c.load();
    await c.delete(c.reports.first);
    expect(c.reports.map((r) => r.id), [4]);
  });

  test('retrying a failed report queues it again and follows it', () async {
    source.reports = [
      sampleRequest(
        id: 3,
        status: ReportStatus.failed,
        errorReason: 'tseUnavailable',
      ),
    ];
    await c.load();
    final again = await c.retry(c.reports.single);
    expect(c.reports.first.id, again.id);
    expect(source.streams.keys, contains(again.id));
  });

  test('a failed load is kept as an error', () async {
    final failing = _FailingSource();
    final c2 = MeusRelatoriosController(failing, open: (_) async {});
    await c2.load();
    expect(c2.error, isNotNull);
    c2.dispose();
  });
}

class _FailingSource extends FakeRelatoriosSource {
  @override
  Future<List<ReportRequest>> listar() async => throw Exception('offline');
}
