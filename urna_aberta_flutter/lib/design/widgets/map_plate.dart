import 'package:flutter/material.dart';

import '../geo/brasil_geo.dart';
import '../platform.dart';
import '../tokens.dart';
import '../typography.dart';
import 'atlas_components.dart';
import 'brazil_map.dart';

/// The map as a complete plate: layer switch, legend-as-control, UF detail,
/// table view and Fonte line. Wide layouts pin the detail beside the map;
/// phones open it in a bottom sheet.
class MapPlate extends StatefulWidget {
  const MapPlate({
    super.key,
    required this.pct,
    required this.momentLabel,
    this.plateNumber = 4,
    this.simulation = false,
  });

  final Map<String, double> pct;
  final String momentLabel;
  final int plateNumber;
  final bool simulation;

  @override
  State<MapPlate> createState() => _MapPlateState();
}

class _MapPlateState extends State<MapPlate> {
  MapLayer _layer = MapLayer.regioes;
  MapFocus? _focus;
  String? _selected;
  bool _table = false;
  late final Future<BrasilGeo> _geo = BrasilGeo.load();

  void _onSelect(BrasilGeo geo, String? sigla, bool wide) {
    setState(() => _selected = sigla);
    if (!wide && sigla != null) {
      showModalBottomSheet<void>(
        context: context,
        builder: (_) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              Space.x5,
              0,
              Space.x5,
              Space.x5,
            ),
            child: _UfDetail(
              uf: geo.bySigla(sigla),
              pct: widget.pct[sigla] ?? 0,
              moment: widget.momentLabel,
            ),
          ),
        ),
      ).whenComplete(() {
        if (mounted) setState(() => _selected = null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BrasilGeo>(
      future: _geo,
      builder: (context, snap) {
        final geo = snap.data;
        return Plate(
          title: 'Seções totalizadas por UF',
          padding: EdgeInsets.zero,
          trailing: widget.simulation
              ? SimulationStamp(label: 'Simulação · ${widget.momentLabel}')
              : null,
          fonte: FonteLine(
            plateNumber: widget.plateNumber,
            source: 'Malhas: IBGE. Dados: TSE, EA20 por UF. Escala aproximada.',
            codes: const [FileCode('EA20 · c0001 · {uf}')],
          ),
          child: geo == null
              ? const SizedBox(
                  height: 320,
                  child: Center(child: CircularProgressIndicator()),
                )
              : _body(context, geo),
        );
      },
    );
  }

  Widget _body(BuildContext context, BrasilGeo geo) {
    final p = context.atlas;
    return LayoutBuilder(
      builder: (context, c) {
        final wide = c.maxWidth >= 760;
        final map = BrazilMap(
          geo: geo,
          pct: widget.pct,
          layer: _layer,
          focus: _focus,
          selected: _selected,
          furniture: wide,
          onSelect: (s) => _onSelect(geo, s, wide),
        );
        final legend = _Legend(
          geo: geo,
          pct: widget.pct,
          layer: _layer,
          focus: _focus,
          onFocus: (f) => setState(() => _focus = f == _focus ? null : f),
        );
        final detail = _selected != null
            ? _UfDetail(
                uf: geo.bySigla(_selected!),
                pct: widget.pct[_selected] ?? 0,
                moment: widget.momentLabel,
              )
            : _FocusDetail(
                geo: geo,
                pct: widget.pct,
                focus: _focus,
                layer: _layer,
              );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(Space.x4),
              child: Wrap(
                spacing: Space.x3,
                runSpacing: Space.x2,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  AtlasSegmented<MapLayer>(
                    segments: const {
                      MapLayer.regioes: 'Regiões',
                      MapLayer.totalizacao: 'Seções totalizadas',
                    },
                    selected: _layer,
                    onChanged: (l) => setState(() {
                      _layer = l;
                      _focus = null;
                    }),
                  ),
                  TextButton.icon(
                    onPressed: () => setState(() => _table = !_table),
                    icon: Icon(AtlasIcons.table(context), size: 18),
                    label: Text(_table ? 'Ver mapa' : 'Ver em tabela'),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: p.rule),
            if (_table)
              _UfTable(geo: geo, pct: widget.pct)
            else if (wide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(Space.x3),
                      child: map,
                    ),
                  ),
                  Container(
                    width: 300,
                    decoration: BoxDecoration(
                      border: Border(left: BorderSide(color: p.rule)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(Space.x4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          legend,
                          const SizedBox(height: Space.x4),
                          detail,
                          if (_selected != null || _focus != null)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () => setState(() {
                                  _selected = null;
                                  _focus = null;
                                }),
                                child: const Text('Limpar seleção'),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            else ...[
              Padding(padding: const EdgeInsets.all(Space.x2), child: map),
              Divider(height: 1, color: p.rule),
              Padding(
                padding: const EdgeInsets.all(Space.x3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    legend,
                    if (_focus != null) ...[
                      const SizedBox(height: Space.x3),
                      _FocusDetail(
                        geo: geo,
                        pct: widget.pct,
                        focus: _focus,
                        layer: _layer,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({
    required this.geo,
    required this.pct,
    required this.layer,
    required this.focus,
    required this.onFocus,
  });

  final BrasilGeo geo;
  final Map<String, double> pct;
  final MapLayer layer;
  final MapFocus? focus;
  final ValueChanged<MapFocus> onFocus;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    final t = Theme.of(context).textTheme;
    final keys = layer == MapLayer.regioes
        ? [
            for (final r in Regiao.values)
              LegendKey(
                color: p.region(r),
                label: r.nomePt,
                trailing: '${geo.ufs.where((u) => u.regiao == r).length} UF',
                selected: focus == RegionFocus(r),
                onTap: () => onFocus(RegionFocus(r)),
              ),
          ]
        : [
            for (var c = 4; c >= 0; c--)
              LegendKey(
                color: p.totalizacaoRamp[c],
                label: '${c * 20}–${(c + 1) * 20}%',
                trailing:
                    '${geo.ufs.where((u) => ClassFocus.classOf(pct[u.sigla] ?? 0) == c).length} UF',
                selected: focus == ClassFocus(c),
                onTap: () => onFocus(ClassFocus(c)),
              ),
          ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          layer == MapLayer.regioes ? 'Regiões' : 'Seções totalizadas',
          style: t.titleSmall,
        ),
        const SizedBox(height: Space.x1),
        ...keys,
      ],
    );
  }
}

class _UfDetail extends StatelessWidget {
  const _UfDetail({required this.uf, required this.pct, required this.moment});

  final UfShape uf;
  final double pct;
  final String moment;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    final t = Theme.of(context).textTheme;
    final file = '${uf.sigla.toLowerCase()}-c0001-e006257-u.json';
    return _DetailBox(
      children: [
        Text(uf.nome, style: t.headlineSmall),
        Text(
          '${uf.regiao.nomePt} · atualizado $moment',
          style: t.bodySmall?.copyWith(color: p.inkMuted),
        ),
        const SizedBox(height: Space.x3),
        _BigPct(pct: pct, caption: 'seções totalizadas'),
        _ProgressBar(value: pct / 100),
        FileCode(
          'EA20 · $file',
          url: Uri.parse(
            'https://www.tse.jus.br/eleicoes/informacoes-tecnicas-sobre-a-divulgacao-de-resultados',
          ),
        ),
      ],
    );
  }
}

class _FocusDetail extends StatelessWidget {
  const _FocusDetail({
    required this.geo,
    required this.pct,
    required this.focus,
    required this.layer,
  });

  final BrasilGeo geo;
  final Map<String, double> pct;
  final MapFocus? focus;
  final MapLayer layer;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    final t = Theme.of(context).textTheme;
    final f = focus;
    if (f == null) {
      return _DetailBox(
        children: [
          Text(
            'Toque em um estado ou em uma chave da legenda.',
            style: t.bodyMedium?.copyWith(color: p.inkSecondary),
          ),
        ],
      );
    }
    final list = geo.ufs
        .where((u) => f.includes(u, pct[u.sigla] ?? 0))
        .toList();
    final avg = list.isEmpty
        ? 0.0
        : list.map((u) => pct[u.sigla] ?? 0).reduce((a, b) => a + b) /
              list.length;
    final name = switch (f) {
      RegionFocus(:final regiao) => regiao.nomePt,
      ClassFocus(:final index) => '${index * 20}–${(index + 1) * 20}%',
    };
    return _DetailBox(
      children: [
        Text(name, style: t.headlineSmall),
        Text(
          list.isEmpty
              ? 'Nenhuma UF nesta faixa'
              : list.map((u) => u.sigla).join(' · '),
          style: t.bodySmall?.copyWith(color: p.inkMuted),
        ),
        const SizedBox(height: Space.x3),
        _BigPct(pct: avg, caption: 'média simples das UFs'),
        _ProgressBar(value: avg / 100),
        FileCode('EA20 · c0001 · ${list.length} UF'),
      ],
    );
  }
}

class _DetailBox extends StatelessWidget {
  const _DetailBox({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(Space.x4),
        decoration: BoxDecoration(
          color: context.atlas.plateSunk,
          borderRadius: BorderRadius.circular(Corner.plate),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}

class _BigPct extends StatelessWidget {
  const _BigPct({required this.pct, required this.caption});

  final double pct;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '${pct.toStringAsFixed(1).replaceAll('.', ',')}%',
            style: AtlasType.figureL.copyWith(color: p.ink),
          ),
          TextSpan(
            text: '  $caption',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: p.inkSecondary),
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.x3),
      child: Container(
        height: 6,
        decoration: BoxDecoration(
          color: p.plate,
          border: Border.all(color: p.rule),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: value.clamp(0, 1),
          child: ColoredBox(color: p.sourceStates),
        ),
      ),
    );
  }
}

class _UfTable extends StatefulWidget {
  const _UfTable({required this.geo, required this.pct});

  final BrasilGeo geo;
  final Map<String, double> pct;

  @override
  State<_UfTable> createState() => _UfTableState();
}

class _UfTableState extends State<_UfTable> {
  int _sortColumn = 0;
  bool _ascending = true;

  @override
  Widget build(BuildContext context) {
    final ufs = [...widget.geo.ufs]
      ..sort((a, b) {
        final r = switch (_sortColumn) {
          1 => a.regiao.index.compareTo(b.regiao.index),
          2 => (widget.pct[a.sigla] ?? 0).compareTo(widget.pct[b.sigla] ?? 0),
          _ => a.nome.compareTo(b.nome),
        };
        return _ascending ? r : -r;
      });
    void sort(int i, bool asc) => setState(() {
      _sortColumn = i;
      _ascending = asc;
    });
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(Space.x2),
      child: DataTable(
        sortColumnIndex: _sortColumn,
        sortAscending: _ascending,
        headingTextStyle: Theme.of(context).textTheme.labelMedium,
        dataTextStyle: AtlasType.tableFigure.copyWith(color: context.atlas.ink),
        columns: [
          DataColumn(label: const Text('UF'), onSort: sort),
          DataColumn(label: const Text('Região'), onSort: sort),
          DataColumn(
            label: const Text('% seções totalizadas'),
            numeric: true,
            onSort: sort,
          ),
          const DataColumn(label: Text('Arquivo')),
        ],
        rows: [
          for (final u in ufs)
            DataRow(
              cells: [
                DataCell(Text('${u.nome} (${u.sigla})')),
                DataCell(Text(u.regiao.nomePt)),
                DataCell(
                  Text(
                    (widget.pct[u.sigla] ?? 0)
                        .toStringAsFixed(1)
                        .replaceAll('.', ','),
                  ),
                ),
                DataCell(
                  FileCode('${u.sigla.toLowerCase()}-c0001-e006257-u.json'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
