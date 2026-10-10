import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design/platform.dart';
import '../design/tokens.dart';
import '../design/typography.dart';
import '../design/widgets/atlas_components.dart';
import '../design/widgets/atlas_page.dart';

/// My polling section: locate it, read the official BU, compare with paper.
class SecaoScreen extends StatefulWidget {
  const SecaoScreen({super.key});

  @override
  State<SecaoScreen> createState() => _SecaoScreenState();
}

class _SecaoScreenState extends State<SecaoScreen> {
  static const _ufs = ['BA', 'PE', 'SP', 'RJ', 'MG'];
  static const _municipios = {
    'BA': ['Salvador', 'Feira de Santana'],
    'PE': ['Recife', 'Olinda'],
    'SP': ['São Paulo', 'Campinas'],
    'RJ': ['Rio de Janeiro', 'Niterói'],
    'MG': ['Belo Horizonte', 'Uberlândia'],
  };

  /// Sample BU rows: candidacy and official file count. SIMULATION.
  static const _bu = [
    ('Candidatura A', 112),
    ('Candidatura B', 98),
    ('Candidatura C', 14),
    ('Brancos', 6),
    ('Nulos', 4),
  ];

  String _uf = 'BA';
  String _municipio = 'Salvador';
  final _zona = TextEditingController(text: '0042');
  final _secao = TextEditingController(text: '0117');
  bool _loaded = false;
  late final List<TextEditingController> _paper = [
    for (final r in _bu) TextEditingController(text: '${r.$2}'),
  ];

  @override
  void dispose() {
    _zona.dispose();
    _secao.dispose();
    for (final c in _paper) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wide = isWideLayout(context);
    final form = Plate(
      title: 'Localizar seção',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flex(
            direction: wide ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _wrap(
                wide,
                _PickerField(
                  label: 'UF',
                  value: _uf,
                  options: _ufs,
                  onChanged: (v) => setState(() {
                    _uf = v;
                    _municipio = _municipios[v]!.first;
                  }),
                ),
              ),
              _gap(wide),
              _wrap(
                wide,
                _PickerField(
                  label: 'Município',
                  value: _municipio,
                  options: _municipios[_uf]!,
                  onChanged: (v) => setState(() => _municipio = v),
                ),
              ),
              _gap(wide),
              _wrap(wide, _NumberField(label: 'Zona', controller: _zona)),
              _gap(wide),
              _wrap(wide, _NumberField(label: 'Seção', controller: _secao)),
            ],
          ),
          const SizedBox(height: Space.x2),
          Text(
            'Zona e seção estão no seu título de eleitor ou no e-Título.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: context.atlas.inkMuted),
          ),
          const SizedBox(height: Space.x4),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton(
              onPressed: () => setState(() => _loaded = true),
              child: const Text('Buscar boletim de urna'),
            ),
          ),
        ],
      ),
    );

    return AtlasPage(
      title: 'Minha seção',
      lede:
          'Encontre o Boletim de Urna oficial da sua seção e compare com o boletim impresso e afixado no local de votação.',
      maxWidth: 1040,
      children: [
        form,
        if (_loaded) ...[
          const SizedBox(height: Space.x5),
          _result(context, wide),
        ],
      ],
    );
  }

  Widget _wrap(bool wide, Widget w) => wide ? Expanded(child: w) : w;
  Widget _gap(bool wide) => SizedBox(width: Space.x3, height: Space.x3);

  Widget _result(BuildContext context, bool wide) {
    final p = context.atlas;
    final t = Theme.of(context).textTheme;
    final mismatches = <int>[
      for (var i = 0; i < _bu.length; i++)
        if (int.tryParse(_paper[i].text) != _bu[i].$2) i,
    ];
    final compare = Plate(
      title: 'Boletim de Urna: arquivo vs papel',
      trailing: const SimulationStamp(),
      fonte: FonteLine(
        plateNumber: 9,
        source:
            'Seção ${_zona.text}/${_secao.text}, $_municipio ($_uf). Chegada do arquivo: 18:07.',
        codes: [FileCode('EA17 · BU · ${_zona.text}/${_secao.text}')],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Digite os números do boletim impresso na coluna Papel.',
            style: t.bodySmall?.copyWith(color: p.inkSecondary),
          ),
          const SizedBox(height: Space.x3),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2.2),
              1: FlexColumnWidth(1),
              2: FixedColumnWidth(96),
              3: FlexColumnWidth(1.1),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder(horizontalInside: BorderSide(color: p.rule)),
            children: [
              TableRow(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: p.ink, width: 1.5)),
                ),
                children: [
                  for (final h in [
                    'Candidatura',
                    'Arquivo',
                    'Papel',
                    'Confere',
                  ])
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: Space.x2),
                      child: Text(
                        h,
                        style: t.labelMedium?.copyWith(color: p.inkSecondary),
                        textAlign: h == 'Arquivo'
                            ? TextAlign.end
                            : TextAlign.start,
                      ),
                    ),
                ],
              ),
              for (var i = 0; i < _bu.length; i++)
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: Space.x2),
                      child: Text(_bu[i].$1, style: t.bodyMedium),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: Space.x4),
                      child: Text(
                        '${_bu[i].$2}',
                        textAlign: TextAlign.end,
                        style: AtlasType.tableFigure.copyWith(color: p.ink),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: TextField(
                        controller: _paper[i],
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textAlign: TextAlign.end,
                        style: AtlasType.tableFigure.copyWith(color: p.ink),
                        decoration: InputDecoration(
                          isDense: true,
                          semanticCounterText: '',
                          labelText: null,
                          hintText: 'Papel',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: Space.x3),
                      child: _Match(ok: !mismatches.contains(i)),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: Space.x4),
          if (mismatches.isEmpty)
            Text(
              'Todos os números conferem com o arquivo oficial.',
              style: t.bodyMedium?.copyWith(color: p.statusValid),
            )
          else
            Text(
              '${mismatches.length == 1 ? 'Uma linha não confere' : '${mismatches.length} linhas não conferem'}. '
              'Primeiro confira se digitou o número do papel corretamente. Se a diferença continuar, '
              'fotografe o boletim afixado e procure o cartório eleitoral da sua zona.',
              style: t.bodyMedium?.copyWith(color: p.ink),
            ),
        ],
      ),
    );

    final files = Plate(
      title: 'Arquivos da seção',
      fonte: const FonteLine(
        plateNumber: 10,
        source: 'Hashes do arquivo auxiliar da seção (EA18).',
        simulation: true,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: Space.x3,
            runSpacing: Space.x2,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const StatusBadge(VerificationStatus.valid),
              Text(
                'O arquivo veio do TSE e não foi alterado no caminho.',
                style: t.bodySmall?.copyWith(color: p.inkSecondary),
              ),
            ],
          ),
          const SizedBox(height: Space.x3),
          const HashRow(
            label: 'BU',
            hash:
                '9f2c7a1e04b83d5f6e19a0c2b7d4e8f1a3c5b6d7e8f9a0b1c2d3e4f5a6b7c8d9',
          ),
          const SizedBox(height: Space.x2),
          const HashRow(
            label: 'RDV',
            hash:
                '4b1e9c03d2a7f6e85b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a',
          ),
          const SizedBox(height: Space.x2),
          const HashRow(label: 'Log', hash: 'pendente'),
          const SizedBox(height: Space.x3),
          Text.rich(
            TextSpan(
              style: t.bodySmall?.copyWith(color: p.inkSecondary),
              children: const [
                TextSpan(
                  text: 'O que isto prova: ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: 'o arquivo publicado é o que a urna registrou. ',
                ),
                TextSpan(
                  text: 'O que não prova: ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: 'nada sobre a urna em si.'),
              ],
            ),
          ),
        ],
      ),
    );

    if (!wide) {
      return Column(
        children: [
          compare,
          const SizedBox(height: Space.x5),
          files,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 6, child: compare),
        const SizedBox(width: Space.x5),
        Expanded(flex: 5, child: files),
      ],
    );
  }
}

class _Match extends StatelessWidget {
  const _Match({required this.ok});

  final bool ok;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    final c = ok ? p.statusValid : p.statusInvalid;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          ok ? AtlasIcons.valid(context) : AtlasIcons.invalid(context),
          size: 16,
          color: c,
        ),
        const SizedBox(width: 4),
        Text(
          ok ? 'Sim' : 'Não',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: c),
        ),
      ],
    );
  }
}

/// iOS: tappable field that opens a native wheel picker. Elsewhere: a
/// Material dropdown menu.
class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    if (shellKindOf(context) == ShellKind.ios) {
      return InkWell(
        onTap: () {
          var picked = options.indexOf(value);
          showCupertinoModalPopup<void>(
            context: context,
            builder: (ctx) => Container(
              height: 280,
              color: context.atlas.plate,
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: CupertinoButton(
                        child: const Text('OK'),
                        onPressed: () {
                          onChanged(options[picked]);
                          Navigator.of(ctx).pop();
                        },
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 36,
                        scrollController: FixedExtentScrollController(
                          initialItem: picked,
                        ),
                        onSelectedItemChanged: (i) => picked = i,
                        children: [
                          for (final o in options) Center(child: Text(o)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: const Icon(CupertinoIcons.chevron_down, size: 16),
          ),
          child: Text(value),
        ),
      );
    }
    return DropdownMenu<String>(
      label: Text(label),
      initialSelection: value,
      expandedInsets: EdgeInsets.zero,
      dropdownMenuEntries: [
        for (final o in options) DropdownMenuEntry(value: o, label: o),
      ],
      onSelected: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({required this.label, required this.controller});

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
      ],
      style: AtlasType.tableFigure.copyWith(
        fontSize: 15,
        color: context.atlas.ink,
      ),
      decoration: InputDecoration(labelText: label),
    );
  }
}
