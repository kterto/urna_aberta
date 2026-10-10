import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:urna_aberta_server/src/secao/aux_file.dart';
import 'package:urna_aberta_server/src/secao/section_directory.dart';
import 'package:urna_aberta_server/src/tse/tse_urls.dart';

const _root = '../fixtures/2026-1t/oficial/ele2026/arquivo-urna/3220';

void main() {
  group('EA18 aux file', () {
    final aux = parseAux(
      File(
        '$_root/dados/ac/01066/0004/0077/p003220-ac-m01066-z0004-s0077-aux.json',
      ).readAsBytesSync(),
    );

    test('status and generation time (Brasília → UTC)', () {
      expect(aux.status, 'Totalizada');
      expect(aux.oficial, isTrue);
      expect(aux.generatedAt, DateTime.utc(2026, 10, 5, 15, 52, 50));
    });

    test('the urna files received, with their receipt time', () {
      final e = aux.entries.single;
      expect(e.hash, startsWith('4a6b704a'));
      expect(e.status, 'Totalizado');
      expect(e.receivedAt, DateTime.utc(2026, 10, 4, 21, 34, 8));
      expect(e.files['bu'], 'o03220ac0106600040077-bu.dat');
      expect(e.files['vota'], 'o03220ac0106600040077-vota.vsc');
      expect(e.files.keys, containsAll(['rdv', 'log']));
    });

    test('a file without the expected fields is refused', () {
      expect(
        () => parseAux(utf8.encode('{"st":"Totalizada"}')),
        throwsFormatException,
      );
    });
  });

  group('EA16 section directory', () {
    final ac = parseSectionConfig(
      File('$_root/config/ac/ac-p003220-cs.json').readAsBytesSync(),
    );
    final s77 = SectionId(uf: 'ac', municipio: 1066, zona: 4, secao: 77);

    test('municipalities with names, sorted by name', () {
      expect(ac.uf, 'ac');
      final names = ac.municipios.map((m) => m.nome).toList();
      expect(names, contains('PORTO WALTER'));
      expect(names, orderedEquals([...names]..sort()));
      expect(
        ac.municipios.singleWhere((m) => m.nome == 'PORTO WALTER').codigo,
        1066,
      );
    });

    test('zones and sections of a municipality', () {
      expect(ac.zonas(1066), contains(4));
      expect(ac.secoes(1066, 4), containsAll([77, 78]));
      expect(
        ac.secoes(1066, 4),
        orderedEquals([...ac.secoes(1066, 4)]..sort()),
      );
    });

    test('knows which sections exist', () {
      expect(ac.contains(s77), isTrue);
      expect(
        ac.contains(SectionId(uf: 'ac', municipio: 1066, zona: 4, secao: 9999)),
        isFalse,
      );
      expect(
        ac.contains(SectionId(uf: 'sp', municipio: 1066, zona: 4, secao: 77)),
        isFalse,
      );
      expect(ac.sectionCount, greaterThan(2000));
    });

    test('aux generation time per section (Brasília → UTC)', () {
      expect(ac.auxGeneratedAt(s77), DateTime.utc(2026, 10, 5, 0, 8, 17));
    });

    test('unknown municipality or zone gives empty lists', () {
      expect(ac.zonas(99999), isEmpty);
      expect(ac.secoes(1066, 9999), isEmpty);
    });
  });
}
