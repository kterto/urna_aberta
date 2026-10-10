import 'package:test/test.dart';
import 'package:urna_aberta_server/src/tse/tse_urls.dart';

/// Golden URLs from HANDOFF.md §2 (official environment, 1st round 2026:
/// election 6257 = Federal/President). Every pattern must still be checked
/// against the official "Instruções para download" PDF.
void main() {
  final urls = TseUrls.oficial();
  const president = Office.presidente;

  group('TseUrls builds the official file names', () {
    test('EA11 elections config', () {
      expect(
        urls.electionsConfig().toString(),
        'https://resultados.tse.jus.br/oficial/comum/config/ele-c.json',
      );
    });

    test('EA12 municipalities config pads the election code to 6 digits', () {
      expect(
        urls.municipalitiesConfig(6257).toString(),
        'https://resultados.tse.jus.br/oficial/ele2026/6257/config/mun-e006257-cm.json',
      );
    });

    test('EA14 Brazil tracking', () {
      expect(
        urls.brazilTracking(6257).toString(),
        'https://resultados.tse.jus.br/oficial/ele2026/6257/dados/br/br-e006257-ab.json',
      );
    });

    test('EA15 UF tracking uses the lowercase UF', () {
      expect(
        urls.ufTracking(6257, 'BA').toString(),
        'https://resultados.tse.jus.br/oficial/ele2026/6257/dados/ba/ba-e006257-ab.json',
      );
    });

    test('EA20 President, Brazil', () {
      expect(
        urls.result(6257, Scope.brazil(), president).toString(),
        'https://resultados.tse.jus.br/oficial/ele2026/6257/dados/br/br-c0001-e006257-u.json',
      );
    });

    test('EA20 President, per UF', () {
      expect(
        urls.result(6257, Scope.uf('sp'), president).toString(),
        'https://resultados.tse.jus.br/oficial/ele2026/6257/dados/sp/sp-c0001-e006257-u.json',
      );
    });

    test('EA20 Governor, per UF (state election code)', () {
      expect(
        urls.result(6259, Scope.uf('BA'), Office.governador).toString(),
        'https://resultados.tse.jus.br/oficial/ele2026/6259/dados/ba/ba-c0003-e006259-u.json',
      );
    });

    test('EA20 Senator office code is c0005', () {
      expect(
        urls.result(6259, Scope.uf('RJ'), Office.senador).path,
        endsWith('/rj-c0005-e006259-u.json'),
      );
    });

    test('exterior (ZZ) is a valid President scope', () {
      expect(
        urls.result(6257, Scope.uf('ZZ'), president).path,
        endsWith('/dados/zz/zz-c0001-e006257-u.json'),
      );
    });

    test('EA16 section config lives under arquivo-urna by pleito', () {
      expect(
        urls.sectionConfig(3220, 'AC').toString(),
        'https://resultados.tse.jus.br/oficial/ele2026/arquivo-urna/3220/config/ac/ac-p003220-cs.json',
      );
    });

    test('simulation environment swaps host, environment and cycle', () {
      final sim = TseUrls.simulado();
      expect(
        sim.brazilTracking(17801).toString(),
        'https://resultados-sim.tse.jus.br/simulado/simulado2026/17801/dados/br/br-e017801-ab.json',
      );
    });
  });

  group('TseUrls refuses URLs that would 404 (404s risk an IP block)', () {
    test('unknown UF', () {
      expect(() => Scope.uf('XX'), throwsArgumentError);
    });

    test('BR is not a UF; use Scope.brazil()', () {
      expect(() => Scope.uf('BR'), throwsArgumentError);
    });

    test('non-positive election code', () {
      expect(() => urls.brazilTracking(0), throwsArgumentError);
    });

    test('election code longer than 6 digits', () {
      expect(() => urls.brazilTracking(1234567), throwsArgumentError);
    });

    test('exterior has no governor or senator', () {
      expect(
        () => urls.result(6259, Scope.uf('ZZ'), Office.governador),
        throwsArgumentError,
      );
    });

    test('Brazil scope only exists for President', () {
      expect(
        () => urls.result(6259, Scope.brazil(), Office.governador),
        throwsArgumentError,
      );
    });

    test(
      'there is no UF tracking file for Brazil or exterior lookups by BR',
      () {
        expect(() => urls.ufTracking(6257, 'BR'), throwsArgumentError);
      },
    );
  });

  test('all 27 UFs plus exterior are known', () {
    expect(Scope.ufs, hasLength(28));
    expect(Scope.ufs, containsAll(['ac', 'df', 'sp', 'to', 'zz']));
  });
}
