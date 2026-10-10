import 'package:flutter/material.dart';

import '../design/platform.dart';
import '../design/tokens.dart';
import '../design/typography.dart';
import '../design/widgets/atlas_components.dart';
import '../design/widgets/charts.dart';
import '../design/widgets/map_plate.dart';
import 'sample_data.dart';

/// In-app gallery of the Urna Aberta design system.
class DesignSystemScreen extends StatelessWidget {
  const DesignSystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wide = isWideLayout(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Sistema de design')),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: wide ? Space.x6 : Space.x4,
          vertical: Space.x4,
        ),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1240),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Colors(),
                  _Type(),
                  _Components(),
                  _Charts(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch(this.name, this.color);

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    final hex =
        '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
    return Container(
      width: 148,
      decoration: BoxDecoration(
        color: p.plate,
        border: Border.all(color: p.rule),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(height: 56, color: color),
          Padding(
            padding: const EdgeInsets.all(Space.x2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.labelMedium),
                Text(hex, style: AtlasType.source.copyWith(color: p.inkMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Colors extends StatelessWidget {
  const _Colors();

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHead(
          title: 'Cor',
          lede:
              'Papel de atlas e tinta. Cor tem três trabalhos: região, totalização e estado. Candidaturas nunca recebem cor.',
        ),
        Plate(
          title: 'Superfícies, tinta e casca',
          child: Wrap(
            spacing: Space.x3,
            runSpacing: Space.x3,
            children: [
              _Swatch('Papel', p.paper),
              _Swatch('Prancha', p.plate),
              _Swatch('Poço', p.plateSunk),
              _Swatch('Tinta', p.ink),
              _Swatch('Tinta 2', p.inkSecondary),
              _Swatch('Tinta 3', p.inkMuted),
              _Swatch('Fio', p.rule),
              _Swatch('Casca', p.shell),
            ],
          ),
        ),
        const SizedBox(height: Space.x4),
        Plate(
          title: 'Regiões IBGE · validado para daltonismo em todos os pares',
          child: Wrap(
            spacing: Space.x3,
            runSpacing: Space.x3,
            children: [
              for (final r in Regiao.values) _Swatch(r.nomePt, p.region(r)),
            ],
          ),
        ),
        const SizedBox(height: Space.x4),
        Plate(
          title: 'Totalização, fontes e estado',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  for (var i = 0; i < 5; i++)
                    Expanded(
                      child: Container(
                        height: 48,
                        color: p.totalizacaoRamp[i],
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.all(6),
                        child: Text(
                          '${i * 20}–${(i + 1) * 20}',
                          style: AtlasType.tableFigure.copyWith(
                            fontSize: 12,
                            color:
                                p.totalizacaoRamp[i].computeLuminance() > 0.35
                                ? p.ink
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: Space.x4),
              Wrap(
                spacing: Space.x5,
                runSpacing: Space.x2,
                children: [
                  _dot(context, p.sourceNational, 'Arquivo nacional do TSE'),
                  _dot(context, p.sourceStates, 'Soma dos estados'),
                ],
              ),
              const SizedBox(height: Space.x4),
              const Wrap(
                spacing: Space.x2,
                runSpacing: Space.x2,
                children: [
                  StatusBadge(VerificationStatus.valid),
                  StatusBadge(VerificationStatus.invalid),
                  StatusBadge(VerificationStatus.pending),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dot(BuildContext context, Color c, String label) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(width: 10, height: 10, color: c),
      const SizedBox(width: 8),
      Text(label),
    ],
  );
}

class _Type extends StatelessWidget {
  const _Type();

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    final t = Theme.of(context).textTheme;
    Widget row(String meta, Widget sample) => Container(
      padding: const EdgeInsets.symmetric(vertical: Space.x3),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: p.rule)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(meta, style: AtlasType.source.copyWith(color: p.inkMuted)),
          const SizedBox(height: Space.x1),
          sample,
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHead(
          title: 'Tipografia',
          lede:
              'Archivo para interface, dados e mapa. Source Serif 4 para leitura.',
        ),
        Plate(
          title: 'Escala',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              row(
                'Figura · Archivo 760 · wdth 86',
                Text(
                  '81,37%',
                  style: AtlasType.figureXL.copyWith(color: p.ink),
                ),
              ),
              row(
                'Display de leitura · Source Serif 4',
                Text(
                  'Apuração, totalização e divulgação não são a mesma coisa.',
                  style: AtlasType.display.copyWith(color: p.ink, fontSize: 32),
                ),
              ),
              row(
                'Título de tela · Archivo 720',
                Text('Minha seção eleitoral', style: t.headlineMedium),
              ),
              row(
                'Título de prancha · Archivo 660',
                Text(
                  'Seções totalizadas por UF',
                  style: AtlasType.plateTitle.copyWith(color: p.ink),
                ),
              ),
              row(
                'Leitura · Source Serif 4 · 18/1,6',
                Text(
                  'O boletim de urna é o resultado de uma seção, impresso pela própria urna ao fim da votação.',
                  style: AtlasType.reading.copyWith(color: p.ink),
                ),
              ),
              row(
                'Mapa · wdth 75 / 125',
                Row(
                  children: [
                    Text(
                      'BA · PE · SE',
                      style: AtlasType.mapLabel.copyWith(
                        color: p.ink,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: Space.x4),
                    Text(
                      'NORDESTE',
                      style: AtlasType.mapRegionLabel.copyWith(color: p.ink),
                    ),
                  ],
                ),
              ),
              row(
                'Fonte e código',
                const Wrap(
                  spacing: Space.x2,
                  children: [FileCode('EA20 · c0001 · ba'), SimulationStamp()],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Components extends StatelessWidget {
  const _Components();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHead(
          title: 'Componentes',
          lede: 'Controles padrão de cada plataforma, vestidos de atlas.',
        ),
        Plate(
          title: 'Ações e estados',
          child: Wrap(
            spacing: Space.x3,
            runSpacing: Space.x3,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FilledButton(
                onPressed: () {},
                child: const Text('Verificar minha seção'),
              ),
              OutlinedButton(
                onPressed: () {},
                child: const Text('Abrir arquivo no TSE'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Ver metodologia'),
              ),
              const FilledButton(
                onPressed: null,
                child: Text('Aguardando arquivo'),
              ),
              AtlasSegmented<int>(
                segments: const {
                  0: 'Presidente',
                  1: 'Governador',
                  2: 'Senador',
                },
                selected: 0,
                onChanged: (_) {},
              ),
            ],
          ),
        ),
        const SizedBox(height: Space.x4),
        DivergenceBanner(onLearnMore: () {}),
        const SizedBox(height: Space.x4),
        const HashRow(
          label: 'Hash do BU',
          hash:
              '9f2c7a1e04b83d5f6e19a0c2b7d4e8f1a3c5b6d7e8f9a0b1c2d3e4f5a6b7c8d9',
        ),
      ],
    );
  }
}

class _Charts extends StatelessWidget {
  const _Charts();

  @override
  Widget build(BuildContext context) {
    final byRegion = <Regiao, List<String>>{};
    const regionOf = {
      'AC': Regiao.norte,
      'AP': Regiao.norte,
      'AM': Regiao.norte,
      'PA': Regiao.norte,
      'RO': Regiao.norte,
      'RR': Regiao.norte,
      'TO': Regiao.norte, //
      'AL': Regiao.nordeste,
      'BA': Regiao.nordeste,
      'CE': Regiao.nordeste,
      'MA': Regiao.nordeste,
      'PB': Regiao.nordeste,
      'PE': Regiao.nordeste,
      'PI': Regiao.nordeste,
      'RN': Regiao.nordeste,
      'SE': Regiao.nordeste, //
      'DF': Regiao.centroOeste,
      'GO': Regiao.centroOeste,
      'MT': Regiao.centroOeste,
      'MS': Regiao.centroOeste, //
      'ES': Regiao.sudeste,
      'MG': Regiao.sudeste,
      'RJ': Regiao.sudeste,
      'SP': Regiao.sudeste, //
      'PR': Regiao.sul, 'RS': Regiao.sul, 'SC': Regiao.sul,
    };
    regionOf.forEach((uf, r) => byRegion.putIfAbsent(r, () => []).add(uf));
    final s = SampleData.samples[SampleData.startIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHead(
          title: 'Mapa e gráficos',
          lede:
              'A legenda é o controle: toque em uma região ou faixa para destacar seus estados.',
        ),
        MapPlate(
          pct: SampleData.ufPct,
          momentLabel: SampleData.momentLabel,
          simulation: true,
        ),
        const SizedBox(height: Space.x4),
        Plate(
          title: 'Duas fontes',
          trailing: const SimulationStamp(),
          child: SourceDuo(
            national: s.national,
            states: s.states,
            nationalNote: 'parado desde 21:02',
            statesNote: 'atualizado 21:40',
          ),
        ),
        const SizedBox(height: Space.x4),
        Plate(
          title: 'Votos nas duas fontes',
          child: MirroredBars(rows: SampleData.mirroredRows),
        ),
        const SizedBox(height: Space.x4),
        Plate(
          title: 'Linha do tempo',
          child: TimelineChart(
            samples: SampleData.samples,
            freezeStart: SampleData.freezeStart,
            freezeEnd: SampleData.freezeEnd,
            freezeValue: SampleData.nationalFilePct,
          ),
        ),
        const SizedBox(height: Space.x4),
        Plate(
          title: 'Seções totalizadas por UF, mesma escala',
          fonte: const FonteLine(
            plateNumber: 8,
            source: 'Pequenos múltiplos por região.',
            simulation: true,
          ),
          child: UfSmallMultiples(
            ufsByRegion: byRegion,
            finalPct: SampleData.ufPct,
            curve: SampleData.ufCurve,
          ),
        ),
        const SizedBox(height: Space.x8),
      ],
    );
  }
}
