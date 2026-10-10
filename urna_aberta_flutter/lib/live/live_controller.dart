import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:urna_aberta_client/urna_aberta_client.dart';

import '../replay/replay_controller.dart';

/// The live presidential count from the server, refreshed every
/// [refreshEvery] while TSE's publishing window is open.
class LiveController extends ChangeNotifier {
  LiveController(this._source, {PeriodicTimer? timer})
    : _timer = timer ?? Timer.periodic;

  final TallySource _source;
  final PeriodicTimer _timer;

  /// The server polls TSE every 30 s; asking more often shows nothing new.
  static const refreshEvery = Duration(seconds: 30);

  LiveStatus? _status;
  Object? _error;
  bool _stale = false;
  Timer? _ticker;
  bool _disposed = false;

  LiveStatus? get status => _status;

  /// The first load failed; nothing to show.
  Object? get error => _error;

  /// The last refresh failed; [status] is older than it should be.
  bool get stale => _stale;

  Future<void> load() async {
    try {
      _apply(await _source.live());
      _error = null;
      _stale = false;
    } catch (e) {
      if (_status == null) {
        _error = e;
      } else {
        _stale = true;
      }
    }
    if (!_disposed) notifyListeners();
  }

  void _apply(LiveStatus s) {
    _status = s;
    if (s.open) {
      _ticker ??= _timer(refreshEvery, (_) => load());
    } else {
      _ticker?.cancel();
      _ticker = null;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _ticker?.cancel();
    super.dispose();
  }
}
