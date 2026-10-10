/// A decoded boletim de urna (BU): one urna's vote totals for its section.
///
/// TSE has not published the 2026 BU schema. The decoder follows the 2022
/// `bu.asn1` (TSE, urna software documentation) adapted to the fields seen
/// in real 2026 files; see `asn1/bu2026_patched.asn1`.
library;

import 'der.dart';

enum TipoVoto { nominal, branco, nulo, legenda, cargoSemCandidato }

/// A wall-clock time as the urna recorded it, in the urna's local time zone
/// (which TSE does not state in the file).
class UrnaTime {
  const UrnaTime(
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.second,
  );

  final int year, month, day, hour, minute, second;

  /// `YYYY-MM-DDThh:mm:ss`, with no zone.
  String get iso =>
      '${_p(year, 4)}-${_p(month)}-${_p(day)}T${_p(hour)}:${_p(minute)}:${_p(second)}';

  static String _p(int v, [int w = 2]) => v.toString().padLeft(w, '0');

  static final _je = RegExp(r'^(\d{4})(\d{2})(\d{2})T(\d{2})(\d{2})(\d{2})$');

  /// Parses the Justiça Eleitoral format `YYYYMMDDThhmmss`.
  static UrnaTime parse(String s) {
    final m = _je.firstMatch(s);
    if (m == null) throw FormatException('BU: bad date-time "$s"');
    int g(int i) => int.parse(m.group(i)!);
    return UrnaTime(g(1), g(2), g(3), g(4), g(5), g(6));
  }
}

class Boletim {
  const Boletim({
    required this.pleito,
    required this.oficial,
    required this.municipio,
    required this.zona,
    required this.secao,
    required this.local,
    required this.emitidoEm,
    required this.abertura,
    required this.encerramento,
    required this.comparecimento,
    required this.eleicoes,
  });

  final int pleito;

  /// False for simulation or training files.
  final bool oficial;
  final int municipio, zona, secao, local;
  final UrnaTime emitidoEm;
  final UrnaTime? abertura, encerramento;
  final int comparecimento;
  final List<BoletimEleicao> eleicoes;
}

class BoletimEleicao {
  const BoletimEleicao({
    required this.eleicao,
    required this.aptos,
    required this.cargos,
  });

  final int eleicao;
  final int aptos;
  final List<BoletimCargo> cargos;
}

class BoletimCargo {
  const BoletimCargo({
    required this.codigo,
    required this.nome,
    required this.comparecimento,
    required this.votos,
  });

  /// TSE office code (1 President, 3 Governor, 5 Senator, 6 Federal Deputy…).
  final int codigo;
  final String nome;
  final int comparecimento;
  final List<BoletimVoto> votos;

  int get totalVotos => votos.fold(0, (a, v) => a + v.votos);
}

class BoletimVoto {
  const BoletimVoto({
    required this.tipo,
    required this.votos,
    this.partido,
    this.numero,
  });

  final TipoVoto tipo;
  final int votos;
  final int? partido;
  final int? numero;
}

/// Decodes a `-bu.dat` file. Throws [FormatException] when the bytes are not
/// a BU envelope, use an unknown layout, or a vote total does not add up to
/// the turnout for its office.
Boletim decodeBoletim(List<int> bytes) {
  try {
    return _decode(bytes);
  } on FormatException {
    rethrow;
  } on Object catch (e) {
    // A layout this decoder does not know (wrong element where one was
    // expected) surfaces as a range or state error; report it as a format
    // problem, never as a partial result.
    throw FormatException('BU: unexpected layout ($e)');
  }
}

const _envelopeBoletimUrna = 1;
const _faseOficial = 2;

/// Seats per office in a BU, for the turnout check: each voter casts one
/// vote per seat (two Senate seats in 2026).
const _seatsFor = {5: 2};

const _cargoNomes = {
  1: 'Presidente',
  2: 'Vice-Presidente',
  3: 'Governador',
  4: 'Vice-Governador',
  5: 'Senador',
  6: 'Deputado Federal',
  7: 'Deputado Estadual',
  8: 'Deputado Distrital',
  9: '1º Suplente de Senador',
  10: '2º Suplente de Senador',
  11: 'Prefeito',
  12: 'Vice-Prefeito',
  13: 'Vereador',
};

Boletim _decode(List<int> bytes) {
  // EntidadeEnvelopeGenerico (unchanged since 2022): cabecalho, fase,
  // urna OPTIONAL, identificacao, tipoEnvelope, seguranca OPTIONAL,
  // conteudo. A seguranca block means the content is encrypted.
  final envelope = DerNode.parse(bytes).children;
  final conteudo = _expect(envelope.last, DerNode.octetString);
  final beforeContent = envelope[envelope.length - 2];
  if (beforeContent.isUniversal(DerNode.sequence)) {
    throw const FormatException('BU: encrypted envelope');
  }
  final tipo = _expect(beforeContent, DerNode.enumerated).asInt;
  if (tipo != _envelopeBoletimUrna) {
    throw FormatException('BU: envelope type $tipo is not a BU');
  }
  final bu = DerNode.parse(conteudo.bytes).children;

  // EntidadeBoletimUrna (2026 layout).
  final cabecalho = bu[0].children;
  final fase = bu[1].asInt;
  final secao = bu[3].children;
  final munZona = secao[0].children;
  final dadosSecao = bu[5];
  UrnaTime? abertura, encerramento;
  if (dadosSecao.isContext(0)) {
    abertura = UrnaTime.parse(dadosSecao.children[0].asString);
    encerramento = UrnaTime.parse(dadosSecao.children[1].asString);
  }
  final comparecimento = _expect(bu[6], DerNode.integer).asInt;
  final resultados = _expect(bu[8], DerNode.sequence);

  return Boletim(
    pleito: cabecalho[1].asInt,
    oficial: fase == _faseOficial,
    municipio: munZona[0].asInt,
    zona: munZona[1].asInt,
    secao: secao[2].asInt,
    local: secao[1].asInt,
    emitidoEm: UrnaTime.parse(_expect(bu[4], DerNode.generalString).asString),
    abertura: abertura,
    encerramento: encerramento,
    comparecimento: comparecimento,
    eleicoes: [for (final e in resultados.children) _eleicao(e)],
  );
}

BoletimEleicao _eleicao(DerNode node) {
  // idEleicao, qtdEleitoresAptos, two 2026 integers, results, signatures.
  final f = node.children;
  final resultados = f.singleWhere((n) => n.isUniversal(DerNode.sequence));
  return BoletimEleicao(
    eleicao: _expect(f[0], DerNode.integer).asInt,
    aptos: _expect(f[1], DerNode.integer).asInt,
    cargos: [
      for (final r in resultados.children) ..._cargos(r),
    ],
  );
}

Iterable<BoletimCargo> _cargos(DerNode resultadoVotacao) sync* {
  // tipoCargo, qtdComparecimento, totaisVotosCargo.
  final f = resultadoVotacao.children;
  final comparecimento = _expect(f[1], DerNode.integer).asInt;
  for (final total in _expect(f[2], DerNode.sequence).children) {
    final t = total.children;
    // codigoCargo is a CHOICE: [1] constitutional office, [2] free consult.
    final codigo = t[0].asInt;
    final nome = t[0].isContext(1)
        ? _cargoNomes[codigo] ?? 'Cargo $codigo'
        : 'Consulta $codigo';
    final votos = [
      for (final v in _expect(t[2], DerNode.sequence).children) _voto(v),
    ];
    final cargo = BoletimCargo(
      codigo: codigo,
      nome: nome,
      comparecimento: comparecimento,
      votos: votos,
    );
    final seats = _seatsFor[codigo] ?? 1;
    if (cargo.totalVotos != comparecimento * seats) {
      throw FormatException(
        'BU: $nome has ${cargo.totalVotos} votes for $comparecimento voters',
      );
    }
    yield cargo;
  }
}

BoletimVoto _voto(DerNode node) {
  // [1] tipoVoto, [2] quantidadeVotos, [3] identificacaoVotavel OPTIONAL.
  int? partido, numero;
  int? tipo, votos;
  for (final f in node.children) {
    if (f.isContext(1)) tipo = f.asInt;
    if (f.isContext(2)) votos = f.asInt;
    if (f.isContext(3)) {
      partido = f.children[0].asInt;
      numero = f.children[1].asInt;
    }
  }
  if (tipo == null ||
      votos == null ||
      tipo < 1 ||
      tipo > TipoVoto.values.length) {
    throw const FormatException('BU: vote record without type or count');
  }
  return BoletimVoto(
    tipo: TipoVoto.values[tipo - 1],
    votos: votos,
    partido: partido,
    numero: numero,
  );
}

DerNode _expect(DerNode n, int universalTag) {
  if (!n.isUniversal(universalTag)) {
    throw FormatException(
      'BU: expected universal tag $universalTag, got ${n.tag}',
    );
  }
  return n;
}
