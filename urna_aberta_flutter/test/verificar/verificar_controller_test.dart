import 'package:flutter_test/flutter_test.dart';
import 'package:urna_aberta_flutter/verificar/device_check.dart';
import 'package:urna_aberta_flutter/verificar/verificar_controller.dart';

import 'fake_verificar_source.dart';

void main() {
  late FakeVerificarSource source;
  late VerificarController c;

  setUp(() {
    source = FakeVerificarSource();
    c = VerificarController(source);
  });

  test(
    'loads the stored files; nothing is checked on the device yet',
    () async {
      await c.load();
      expect(c.files!.map((f) => f.scopeCode), ['br', 'ac', 'sp']);
      expect(c.deviceResult(1), isNull);
      expect(c.checkedCount, 0);
    },
  );

  test('checks every file on the device and catches a swapped one', () async {
    await c.load();
    await c.checkAll();
    expect(c.deviceResult(1), DeviceCheck.valid);
    expect(c.deviceResult(2), DeviceCheck.valid);
    expect(c.deviceResult(3), DeviceCheck.differentFile);
    expect(c.checkedCount, 3);
    expect(c.checkingAll, isFalse);
  });

  test('checking again does not download the files again', () async {
    await c.load();
    await c.checkAll();
    await c.checkAll();
    expect(source.jwsCalls, [1, 2, 3]);
  });

  test('a failed load is kept for the screen and cleared on retry', () async {
    source.fail = StateError('offline');
    await c.load();
    expect(c.error, isA<StateError>());
    source.fail = null;
    await c.load();
    expect(c.error, isNull);
    expect(c.files, hasLength(3));
  });
}
