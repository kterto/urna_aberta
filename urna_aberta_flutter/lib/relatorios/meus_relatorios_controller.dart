import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:urna_aberta_client/urna_aberta_client.dart';

import 'relatorios_source.dart';

/// "Meus relatórios": the viewer's reports, each unfinished one followed
/// live until it is ready or failed.
class MeusRelatoriosController extends ChangeNotifier {
  MeusRelatoriosController(
    this._source, {
    required this.open,
    this.followAgainAfter = const Duration(seconds: 5),
  });

  final RelatoriosSource _source;

  /// Opens a link (a download, or a report's public page).
  final Future<void> Function(Uri) open;

  /// Waits before following again a report whose stream dropped.
  final Duration followAgainAfter;

  List<ReportRequest> _reports = const [];
  bool _loading = false;
  Object? _error;
  final _following = <int, StreamSubscription<ReportRequest>>{};
  final _busy = <int>{};
  bool _disposed = false;

  List<ReportRequest> get reports => _reports;
  bool get loading => _loading;
  Object? get error => _error;

  /// A download, publish or delete is in flight for [id].
  bool busy(int id) => _busy.contains(id);

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _reports = await _source.listar();
      _reports.where(_unfinished).forEach(_follow);
    } on Object catch (e) {
      _error = e;
    }
    _loading = false;
    _notify();
  }

  static bool _unfinished(ReportRequest r) =>
      r.status == ReportStatus.queued || r.status == ReportStatus.running;

  void _follow(ReportRequest r) {
    if (_following.containsKey(r.id)) return;
    _following[r.id!] = _source
        .acompanhar(r.id!)
        .listen(
          _replace,
          onError: (Object _) => _followAgain(r.id!),
          onDone: () => _followAgain(r.id!),
        );
  }

  /// The stream drops when the connection or the server restarts, while
  /// the report goes on being built.
  void _followAgain(int id) {
    _following.remove(id);
    Timer(followAgainAfter, () {
      final r = _reports.where((x) => x.id == id).firstOrNull;
      if (!_disposed && r != null && _unfinished(r)) _follow(r);
    });
  }

  void _replace(ReportRequest r) {
    _reports = [
      for (final x in _reports) x.id == r.id ? r : x,
    ];
    _notify();
  }

  /// Saves the file through a ten-minute link the browser opens.
  Future<void> download(ReportRequest r, String format) => _with(
    r.id!,
    () async => open(Uri.parse(await _source.link(r.id!, format))),
  );

  Future<void> publish(ReportRequest r, bool public) => _with(r.id!, () async {
    _replace(await _source.publicar(r.id!, public));
  });

  /// The public page of a published report.
  Future<String?> publicLink(ReportRequest r) => _source.linkPublico(r.id!);

  Future<void> delete(ReportRequest r) => _with(r.id!, () async {
    await _source.apagar(r.id!);
    _following.remove(r.id)?.cancel();
    _reports = [
      for (final x in _reports)
        if (x.id != r.id) x,
    ];
  });

  /// Asks for the same report again (after a failure).
  Future<ReportRequest> retry(ReportRequest r) async {
    final again = await _source.pedir(r.spec);
    _reports = [again, ..._reports];
    _follow(again);
    _notify();
    return again;
  }

  Future<void> _with(int id, Future<void> Function() action) async {
    _busy.add(id);
    _notify();
    try {
      await action();
    } finally {
      _busy.remove(id);
      _notify();
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    for (final s in _following.values) {
      s.cancel();
    }
    super.dispose();
  }
}
