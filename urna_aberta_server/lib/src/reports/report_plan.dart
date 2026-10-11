import '../generated/protocol.dart';
import '../live/elections.dart';
import '../secao/section_directory.dart' show SectionDirectory;
import '../tse/ea12.dart';
import '../tse/tse_urls.dart';

/// The five IBGE regions and their UFs.
const regions = <String, List<String>>{
  'n': ['ac', 'am', 'ap', 'pa', 'ro', 'rr', 'to'],
  'ne': ['al', 'ba', 'ce', 'ma', 'pb', 'pe', 'pi', 'rn', 'se'],
  'co': ['df', 'go', 'ms', 'mt'],
  'se': ['es', 'mg', 'rj', 'sp'],
  's': ['pr', 'rs', 'sc'],
};

/// One EA20 result file a report reads.
typedef ResultNeed = ({int election, Office office, Scope scope});

/// One polling section a report reads: its aux file, BU and signature file.
/// [year] picks the URL cycle.
typedef SectionNeed = ({int pleito, int year, SectionId id});

/// One table of a report: an office of an election in a place, from TSE's
/// own file for that place or, when [summed], from our sum of the files
/// (or sections) inside it.
class ReportItem {
  ReportItem({
    required this.election,
    required this.office,
    required this.place,
    required this.results,
    required this.sections,
    this.reference,
    this.sectionsWithoutFiles = 0,
    this.breakdown = const [],
  });

  final Election election;
  final Office office;
  final ReportPlace place;
  final List<ResultNeed> results;
  final List<SectionNeed> sections;

  /// For a sum of sections: the file of the race they belong to, read for
  /// candidate names and party labels (the BU has only numbers).
  final ResultNeed? reference;

  /// Sections TSE lists in the place with no urna files: never requested.
  final int sectionsWithoutFiles;

  /// One row per UF, municipality or zone inside [place], when asked.
  final List<ReportItem> breakdown;

  bool get summed => results.length + sections.length > 1;
}

class ReportPlan {
  ReportPlan(this.items) {
    void add(ReportItem i) {
      results.addAll(i.results);
      if (i.reference case final r?) results.add(r);
      sections.addAll(i.sections);
      i.breakdown.forEach(add);
    }

    items.forEach(add);
  }

  final List<ReportItem> items;
  final results = <ResultNeed>{};
  final sections = <SectionNeed>{};

  /// TSE files read, each once: a section is three.
  int get files => results.length + 3 * sections.length;

  int get tables => items.fold(0, (n, i) => n + 1 + i.breakdown.length);

  int get sectionsWithoutFiles => items.fold(
    0,
    (n, i) =>
        n +
        i.sectionsWithoutFiles +
        i.breakdown.fold(0, (m, b) => m + b.sectionsWithoutFiles),
  );
}

/// Turns a [ReportSpec] into the files it needs, checking every place
/// against EA11, EA12 and the section config first: no URL is built for
/// anything TSE does not list.
class ReportPlanner {
  ReportPlanner({
    required this._elections,
    required this._municipalities,
    required this._sections,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final List<Election> Function() _elections;
  final Future<Municipalities> Function(Election) _municipalities;
  final Future<SectionDirectory> Function(int pleito, int year, String uf)
  _sections;
  final DateTime Function() _now;

  /// Most TSE files one report may read.
  static const fileLimit = 3000;

  Future<ReportPlan> plan(ReportSpec spec) async {
    if (spec.elections.isEmpty || spec.offices.isEmpty || spec.places.isEmpty) {
      throw _invalid('Escolha ao menos uma eleição, um cargo e um local.');
    }
    if (spec.language != 'pt' && spec.language != 'en') {
      throw _invalid('Idioma ${spec.language} não suportado.');
    }
    final elections = [for (final code in spec.elections) _election(code)];
    final offices = [
      for (final code in spec.offices)
        Office.byCode(code) ?? (throw _invalid('Cargo $code desconhecido.')),
    ];
    for (final o in offices) {
      if (!elections.any((e) => e.offices.contains(o))) {
        throw _invalid(
          'Nenhuma das eleições escolhidas elege o cargo ${o.code}.',
        );
      }
    }
    final items = <ReportItem>[];
    for (final place in spec.places) {
      _checkShape(place);
      for (final e in elections) {
        for (final o in offices) {
          if (!e.offices.contains(o)) continue;
          final item = await _item(e, o, place);
          items.add(
            ReportItem(
              election: e,
              office: o,
              place: place,
              results: item.results,
              sections: item.sections,
              reference: item.reference,
              sectionsWithoutFiles: item.sectionsWithoutFiles,
              breakdown: [
                for (final sub in await _subPlaces(e, o, place, spec.breakdown))
                  await _item(e, o, sub),
              ],
            ),
          );
        }
      }
    }
    return ReportPlan(items);
  }

  Election _election(int code) {
    final e =
        _elections().where((e) => e.code == code).firstOrNull ??
        (throw _invalid('O TSE não lista a eleição $code.'));
    if (_now().isBefore(e.opensAt)) {
      throw ReportRefused(
        message: 'O TSE ainda não publicou resultados da eleição $code.',
        reason: 'notPublished',
      );
    }
    return e;
  }

  static void _checkShape(ReportPlace p) {
    final ok = switch (p.kind) {
      ReportPlaceKind.br => true,
      ReportPlaceKind.regiao => regions.containsKey(p.regiao),
      ReportPlaceKind.uf => _isUf(p.uf),
      ReportPlaceKind.municipio => _isUf(p.uf) && p.municipio != null,
      ReportPlaceKind.zona =>
        _isUf(p.uf) && p.municipio != null && p.zona != null,
      ReportPlaceKind.secao =>
        _isUf(p.uf) && p.municipio != null && p.zona != null && p.secao != null,
    };
    if (!ok) throw _invalid('Local incompleto ou desconhecido: ${_label(p)}.');
  }

  static bool _isUf(String? uf) =>
      uf != null && Scope.ufs.contains(uf.toLowerCase());

  /// The files giving [place]'s total for one office of one election.
  Future<ReportItem> _item(Election e, Office o, ReportPlace place) async {
    final uf = place.uf?.toLowerCase();
    ReportItem files(List<Scope> scopes) => ReportItem(
      election: e,
      office: o,
      place: place,
      results: [
        for (final s in scopes) (election: e.code, office: o, scope: s),
      ],
      sections: const [],
    );

    switch (place.kind) {
      case ReportPlaceKind.br:
        return files(
          o.level == OfficeLevel.federal
              ? [Scope.brazil()]
              : await _areaScopes(e, o, Scope.ufs),
        );
      case ReportPlaceKind.regiao:
        return files(await _areaScopes(e, o, regions[place.regiao]!));
      case ReportPlaceKind.uf:
        return files(await _areaScopes(e, o, [uf!]));
      case ReportPlaceKind.municipio:
        return files([await _city(e, o, uf!, place.municipio!)]);
      case ReportPlaceKind.zona:
      case ReportPlaceKind.secao:
        await _city(e, o, uf!, place.municipio!);
        final dir = await _sections(e.pleito, e.day.$1, uf);
        final ids = place.kind == ReportPlaceKind.secao
            ? [place.secao!]
            : dir.secoes(place.municipio!, place.zona!);
        final sections = <SectionNeed>[];
        var withoutFiles = 0;
        for (final s in ids) {
          final id = SectionId(
            uf: uf,
            municipio: place.municipio!,
            zona: place.zona!,
            secao: s,
          );
          if (!dir.contains(id)) {
            throw _invalid('O TSE não lista ${_label(place)}.');
          }
          if (dir.auxGeneratedAt(id) == null) {
            withoutFiles++;
          } else {
            sections.add((pleito: e.pleito, year: e.day.$1, id: id));
          }
        }
        if (ids.isEmpty) throw _invalid('O TSE não lista ${_label(place)}.');
        return ReportItem(
          election: e,
          office: o,
          place: place,
          results: const [],
          sections: sections,
          reference: (
            election: e.code,
            office: o,
            scope: _race(o, uf, place.municipio!),
          ),
          sectionsWithoutFiles: withoutFiles,
        );
    }
  }

  /// The files covering [ufs]: one per UF for federal and state offices
  /// (only the UFs that elect a state office), one per city for municipal
  /// ones. Refused when none of [ufs] elects the office.
  Future<List<Scope>> _areaScopes(
    Election e,
    Office o,
    List<String> ufs,
  ) async {
    final scopes = <Scope>[];
    if (o.level == OfficeLevel.municipal) {
      for (final uf in ufs) {
        scopes.addAll(await _cities(e, o, uf));
      }
    } else {
      final electing = {
        for (final (s, office) in e.targets)
          if (office == o && !s.isBrazil && !s.isMunicipality) s.code,
      };
      for (final uf in ufs) {
        if (electing.contains(uf)) scopes.add(Scope.uf(uf));
      }
    }
    if (scopes.isEmpty) {
      throw _invalid(
        'O cargo ${o.code} não é eleito em ${ufs.join(', ')} na eleição ${e.code}.',
      );
    }
    return scopes;
  }

  /// The cities of [uf] that elect a municipal office in [e].
  Future<List<Scope>> _cities(Election e, Office o, String uf) async {
    if (e.allMunicipalities) {
      final ea12 = await _municipalities(e);
      return [
        for (final m in ea12.byUf[uf] ?? const <Municipio>[])
          Scope.municipality(uf, m.code),
      ];
    }
    return [
      for (final (s, office) in e.targets)
        if (office == o && s.isMunicipality && s.uf == uf) s,
    ];
  }

  /// A city's own file: listed in EA12, and electing [o] there.
  Future<Scope> _city(Election e, Office o, String uf, int code) async {
    final Scope scope;
    try {
      scope = Scope.municipality(uf, code);
    } on ArgumentError {
      throw _invalid('Município $uf $code desconhecido.');
    }
    final listed = o.level == OfficeLevel.municipal
        ? (await _cities(e, o, uf)).contains(scope)
        : (await _municipalities(e)).byCode(uf, code) != null &&
              (o.level == OfficeLevel.federal ||
                  e.targets.any((t) => t.$2 == o && t.$1.code == uf));
    if (!listed) {
      throw _invalid(
        'O TSE não lista o cargo ${o.code} em $scope na eleição ${e.code}.',
      );
    }
    return scope;
  }

  /// The scope whose file covers the whole race a city's sections vote in.
  static Scope _race(Office o, String uf, int municipio) => switch (o.level) {
    OfficeLevel.federal => Scope.brazil(),
    OfficeLevel.state => Scope.uf(uf),
    OfficeLevel.municipal => Scope.municipality(uf, municipio),
  };

  /// The rows under [place] for [breakdown]; none when it is not finer.
  Future<List<ReportPlace>> _subPlaces(
    Election e,
    Office o,
    ReportPlace place,
    ReportBreakdown breakdown,
  ) async {
    final depth = ReportPlaceKind.values.indexOf(place.kind);
    final ufs = switch (place.kind) {
      ReportPlaceKind.br => Scope.ufs,
      ReportPlaceKind.regiao => regions[place.regiao]!,
      _ => [place.uf!.toLowerCase()],
    };
    switch (breakdown) {
      case ReportBreakdown.none:
        return const [];
      case ReportBreakdown.uf:
        if (depth >= ReportPlaceKind.uf.index) return const [];
        if (o.level == OfficeLevel.municipal) {
          return [
            for (final uf in ufs)
              if (uf != 'zz' && (await _cities(e, o, uf)).isNotEmpty)
                ReportPlace(kind: ReportPlaceKind.uf, uf: uf),
          ];
        }
        return [
          for (final s in await _areaScopes(e, o, ufs))
            ReportPlace(kind: ReportPlaceKind.uf, uf: s.code),
        ];
      case ReportBreakdown.municipio:
        if (depth >= ReportPlaceKind.municipio.index) return const [];
        final places = <ReportPlace>[];
        for (final uf in ufs) {
          if (uf == 'zz' && o != Office.presidente) continue;
          final cities = o.level == OfficeLevel.municipal
              ? [for (final s in await _cities(e, o, uf)) s.municipio!]
              : (o.level == OfficeLevel.state &&
                    !e.targets.any((t) => t.$2 == o && t.$1.code == uf))
              ? const <int>[]
              : [
                  for (final m
                      in (await _municipalities(e)).byUf[uf] ??
                          const <Municipio>[])
                    m.code,
                ];
          for (final m in cities) {
            places.add(
              ReportPlace(
                kind: ReportPlaceKind.municipio,
                uf: uf,
                municipio: m,
              ),
            );
          }
        }
        return places;
      case ReportBreakdown.zona:
        if (depth >= ReportPlaceKind.zona.index) return const [];
        final places = <ReportPlace>[];
        for (final uf in ufs) {
          if (uf == 'zz') continue;
          final dir = await _sections(e.pleito, e.day.$1, uf);
          final cities = place.kind == ReportPlaceKind.municipio
              ? [place.municipio!]
              : [for (final m in dir.municipios) m.codigo];
          for (final m in cities) {
            for (final z in dir.zonas(m)) {
              places.add(
                ReportPlace(
                  kind: ReportPlaceKind.zona,
                  uf: uf,
                  municipio: m,
                  zona: z,
                ),
              );
            }
          }
        }
        return places;
    }
  }

  static String _label(ReportPlace p) => [
    p.kind.name,
    ?p.regiao,
    ?p.uf,
    ?p.municipio?.toString(),
    if (p.zona != null) 'zona ${p.zona}',
    if (p.secao != null) 'seção ${p.secao}',
  ].join(' ');

  static ReportRefused _invalid(String message) =>
      ReportRefused(message: message, reason: 'invalidRequest');
}
