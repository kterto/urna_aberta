import 'package:flutter/widgets.dart';
import 'package:urna_aberta_client/urna_aberta_client.dart';

import 'device_check.dart';

/// What Verificar needs from the server; [ServerVerificarSource] wraps the
/// generated client.
abstract interface class VerificarSource {
  Future<List<FileVerification>> arquivos();
  Future<String> jws(int snapshotId);
}

class ServerVerificarSource implements VerificarSource {
  ServerVerificarSource(this._client);

  final Client _client;

  @override
  Future<List<FileVerification>> arquivos() => _client.verificar.arquivos();

  @override
  Future<String> jws(int snapshotId) => _client.verificar.jws(snapshotId);
}

/// Provides the [VerificarSource] to the screens below it.
class VerificarScope extends InheritedWidget {
  const VerificarScope({super.key, required this.source, required super.child});

  final VerificarSource source;

  static VerificarSource of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<VerificarScope>();
    assert(scope != null, 'No VerificarScope above this widget');
    return scope!.source;
  }

  @override
  bool updateShouldNotify(VerificarScope old) => source != old.source;
}

/// The server's signature results per file, and the device's own re-check
/// of each signed file with the key the app carries.
class VerificarController extends ChangeNotifier {
  VerificarController(this._source);

  final VerificarSource _source;

  /// Files checked at once; each is a download plus an Ed25519 check.
  static const _parallel = 4;

  List<FileVerification>? _files;
  Object? _error;
  bool _loading = false;
  bool _checkingAll = false;
  final _device = <int, DeviceCheck>{};
  final _failed = <int>{};
  final _checking = <int>{};

  List<FileVerification>? get files => _files;
  Object? get error => _error;
  bool get loading => _loading;
  bool get checkingAll => _checkingAll;

  DeviceCheck? deviceResult(int snapshotId) => _device[snapshotId];
  bool isChecking(int snapshotId) => _checking.contains(snapshotId);

  /// The download failed; the file was not checked.
  bool downloadFailed(int snapshotId) => _failed.contains(snapshotId);
  int get checkedCount => _device.length;

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _files = await _source.arquivos();
    } catch (e) {
      _error = e;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Checks every file not yet checked on this device.
  Future<void> checkAll() async {
    final todo = [
      for (final f in _files ?? const <FileVerification>[])
        if (!_device.containsKey(f.snapshotId)) f,
    ];
    if (todo.isEmpty || _checkingAll) return;
    _checkingAll = true;
    notifyListeners();
    var next = 0;
    Future<void> worker() async {
      while (next < todo.length) {
        await _check(todo[next++]);
      }
    }

    await Future.wait([for (var i = 0; i < _parallel; i++) worker()]);
    _checkingAll = false;
    notifyListeners();
  }

  Future<void> _check(FileVerification f) async {
    final id = f.snapshotId;
    _checking.add(id);
    _failed.remove(id);
    notifyListeners();
    try {
      _device[id] = await checkOnDevice(
        await _source.jws(id),
        expectedSha256: f.sha256,
      );
    } catch (_) {
      _failed.add(id);
    } finally {
      _checking.remove(id);
      notifyListeners();
    }
  }
}
