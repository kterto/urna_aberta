import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:urna_aberta_client/urna_aberta_client.dart';

/// The viewer's account: sign-in state and their saved polling place.
abstract interface class ContaSource {
  ValueListenable<bool> get signedIn;
  Future<VoterPlace?> ler();
  Future<VoterPlace> salvar(String uf, int municipio, int? zona, int? secao);
  Future<void> apagar();
  Future<void> sair();

  /// The sign-in form.
  Widget signInForm(BuildContext context);
}

class ContaController extends ChangeNotifier {
  ContaController(this._source);

  final ContaSource _source;

  bool _signedIn = false;
  VoterPlace? _place;
  Object? _error;
  bool _started = false;

  /// Bumped on sign-in and sign-out; a load for an older session is dropped.
  int _generation = 0;

  ContaSource get source => _source;
  bool get signedIn => _signedIn;

  /// The saved place, once loaded; null when signed out or none saved.
  VoterPlace? get place => _place;
  Object? get error => _error;

  Future<void> start() async {
    if (_started) return;
    _started = true;
    _source.signedIn.addListener(_onAuth);
    await _onAuth();
  }

  Future<void> _onAuth() async {
    final generation = ++_generation;
    _signedIn = _source.signedIn.value;
    _place = null;
    _error = null;
    notifyListeners();
    if (!_signedIn) return;
    try {
      final place = await _source.ler();
      if (generation != _generation) return;
      _place = place;
    } on Object catch (e) {
      if (generation != _generation) return;
      _error = e;
    }
    notifyListeners();
  }

  /// Rethrows a refusal so the caller can say why; the old place stays.
  Future<void> salvar(String uf, int municipio, int? zona, int? secao) async {
    _error = null;
    try {
      _place = await _source.salvar(uf, municipio, zona, secao);
    } on Object catch (e) {
      _error = e;
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> apagar() async {
    await _source.apagar();
    _place = null;
    notifyListeners();
  }

  Future<void> sair() => _source.sair();

  @override
  void dispose() {
    _source.signedIn.removeListener(_onAuth);
    super.dispose();
  }
}

/// Provides the one account controller to the whole app.
class ContaScope extends InheritedNotifier<ContaController> {
  const ContaScope({
    super.key,
    required ContaController controller,
    required super.child,
  }) : super(notifier: controller);

  static ContaController? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ContaScope>()?.notifier;

  static ContaController of(BuildContext context) {
    final c = maybeOf(context);
    assert(c != null, 'No ContaScope above this widget.');
    return c!;
  }
}
