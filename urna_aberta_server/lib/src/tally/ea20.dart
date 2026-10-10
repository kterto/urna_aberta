import 'dart:convert';

import '../tse/tse_time.dart';
import 'aggregator.dart';

/// Parses an EA20 result file (`<scope>-c<office>-e<election>-u.json`).
///
/// Throws [FormatException] on anything it cannot read faithfully: a figure
/// is never guessed from a malformed file.
ScopeResult parseEa20(List<int> bytes) {
  final json = jsonDecode(utf8.decode(bytes));
  if (json is! Map<String, dynamic>) {
    throw const FormatException('EA20: top level is not an object');
  }
  final s = _map(json['s'], 's');
  final total = _int(s['ts'], 's.ts');
  final totalized = _int(s['st'], 's.st');
  if (totalized > total) {
    throw FormatException('EA20: $totalized sections totalized of $total');
  }

  final votes = <int, int>{};
  final candidates = <int, CandidateInfo>{};
  for (final carg in _list(json['carg'], 'carg')) {
    for (final agr in _list(_map(carg, 'carg[]')['agr'], 'agr')) {
      for (final par in _list(_map(agr, 'agr[]')['par'], 'par')) {
        final party = _string(_map(par, 'par[]')['sg'], 'par.sg');
        for (final cand in _list(par['cand'], 'cand')) {
          final c = _map(cand, 'cand[]');
          final n = _int(c['n'], 'cand.n');
          if (votes.containsKey(n)) {
            throw FormatException('EA20: candidate $n listed twice');
          }
          votes[n] = _int(c['vap'], 'cand.vap');
          candidates[n] = CandidateInfo(
            ballotName: _string(c['nmu'], 'cand.nmu'),
            party: party,
          );
        }
      }
    }
  }

  return ScopeResult(
    scope: _string(json['cdabr'], 'cdabr').toLowerCase(),
    sectionsTotal: total,
    sectionsTotalized: totalized,
    votes: votes,
    generatedAt: parseTseDateTime(
      json['dg'],
      json['hg'],
      what: 'EA20 generation time',
    ),
    candidates: candidates,
  );
}

Map<String, dynamic> _map(Object? v, String field) => v is Map<String, dynamic>
    ? v
    : throw FormatException('EA20: $field is not an object');

List<dynamic> _list(Object? v, String field) =>
    v is List ? v : throw FormatException('EA20: $field is not a list');

String _string(Object? v, String field) =>
    v is String ? v : throw FormatException('EA20: $field is not a string');

final _digits = RegExp(r'^\d+$');

int _int(Object? v, String field) {
  final s = _string(v, field);
  if (!_digits.hasMatch(s)) {
    throw FormatException('EA20: $field "$s" is not a count');
  }
  return int.parse(s);
}
