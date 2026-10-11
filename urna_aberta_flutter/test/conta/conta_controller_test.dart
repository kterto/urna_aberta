import 'package:flutter_test/flutter_test.dart';
import 'package:urna_aberta_flutter/conta/conta_controller.dart';

import 'fake_conta_source.dart';

void main() {
  test('signed out: no place, nothing asked of the server', () async {
    final source = FakeContaSource(place: portoWalter());
    final c = ContaController(source);
    await c.start();
    expect(c.signedIn, isFalse);
    expect(c.place, isNull);
  });

  test('signing in loads the saved place', () async {
    final source = FakeContaSource(place: portoWalter());
    final c = ContaController(source);
    await c.start();
    source.signIn();
    await pumpEventQueue();
    expect(c.signedIn, isTrue);
    expect(c.place!.municipioNome, 'PORTO WALTER');
  });

  test('already signed in at start', () async {
    final c = ContaController(
      FakeContaSource(signedIn: true, place: portoWalter()),
    );
    await c.start();
    expect(c.place!.secao, 77);
  });

  test('saving keeps what the server stored', () async {
    final source = FakeContaSource(signedIn: true);
    final c = ContaController(source);
    await c.start();
    await c.salvar('ac', 1066, 4, 77);
    expect(source.saved, [('ac', 1066, 4, 77)]);
    expect(c.place!.zona, 4);
  });

  test('a refused save keeps the old place and the error', () async {
    final source = FakeContaSource(signedIn: true, place: portoWalter());
    final c = ContaController(source);
    await c.start();
    source.failWith = Exception('refused');
    await expectLater(c.salvar('ac', 1066, 4, 9999), throwsException);
    expect(c.place!.secao, 77);
    expect(c.error, isNotNull);
  });

  test('deleting forgets the place', () async {
    final source = FakeContaSource(signedIn: true, place: portoWalter());
    final c = ContaController(source);
    await c.start();
    await c.apagar();
    expect(c.place, isNull);
    expect(source.place, isNull);
  });

  test('signing out forgets the place locally', () async {
    final source = FakeContaSource(signedIn: true, place: portoWalter());
    final c = ContaController(source);
    await c.start();
    await c.sair();
    await pumpEventQueue();
    expect(c.signedIn, isFalse);
    expect(c.place, isNull);
    expect(source.place, isNotNull);
  });

  test('a failed load is kept as an error, signed in', () async {
    final source = FakeContaSource(signedIn: true)..failWith = Exception('x');
    final c = ContaController(source);
    await c.start();
    expect(c.signedIn, isTrue);
    expect(c.error, isNotNull);
  });
}
