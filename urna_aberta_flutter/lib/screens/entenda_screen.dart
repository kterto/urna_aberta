import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../design/platform.dart';
import '../design/tokens.dart';
import '../design/typography.dart';
import '../design/widgets/atlas_components.dart';
import '../design/widgets/atlas_page.dart';

class _Chapter {
  const _Chapter(this.title, this.summary);

  final String title;
  final String summary;
}

const _chapters = [
  _Chapter(
    'O caminho do voto',
    'Da urna ao boletim afixado, da transmissão à divulgação.',
  ),
  _Chapter(
    'O Boletim de Urna',
    'O que ele contém, por que é público e como conferir.',
  ),
  _Chapter('Os arquivos da urna', 'BU, RDV e log: para que serve cada um.'),
  _Chapter(
    'Assinaturas e hashes',
    'O que as verificações deste app realmente checam.',
  ),
  _Chapter(
    'Protocolos de segurança',
    'Testes públicos, cerimônias e inspeção do código.',
  ),
  _Chapter(
    '4 de outubro de 2026',
    'O que parou, o que não parou, e como o replay mostra isso.',
  ),
  _Chapter(
    'O que este app prova',
    'E, com a mesma clareza, o que ele não prova.',
  ),
];

/// Learn: chapter index plus the reading experience.
class EntendaScreen extends StatelessWidget {
  const EntendaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    final t = Theme.of(context).textTheme;
    final wide = isWideLayout(context);

    final index = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < _chapters.length; i++)
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => _ChapterScreen(index: i)),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: Space.x4),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: i == 0 ? p.ink : p.rule,
                    width: i == 0 ? 2 : 1,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 36,
                    child: Text(
                      '${i + 1}',
                      style: AtlasType.figureM.copyWith(color: p.inkMuted),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _chapters[i].title,
                          style: AtlasType.headlineSerif.copyWith(
                            color: p.ink,
                            fontSize: wide ? 26 : 21,
                          ),
                        ),
                        const SizedBox(height: Space.x1),
                        Text(
                          _chapters[i].summary,
                          style: t.bodyMedium?.copyWith(color: p.inkSecondary),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: p.inkMuted),
                ],
              ),
            ),
          ),
      ],
    );

    return AtlasPage(
      title: 'Entenda o processo',
      lede:
          'Capítulos curtos sobre como o resultado sai da urna e chega até você. Cada afirmação cita uma fonte oficial do TSE.',
      maxWidth: 880,
      children: [index],
    );
  }
}

class _ChapterScreen extends StatelessWidget {
  const _ChapterScreen({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    final t = Theme.of(context).textTheme;
    final ch = _chapters[index];
    final reading = AtlasType.reading.copyWith(color: p.ink);
    final wide = isWideLayout(context);

    Widget para(String s) => Padding(
      padding: const EdgeInsets.only(bottom: Space.x4),
      child: Text(s, style: reading),
    );

    return Scaffold(
      appBar: AppBar(title: Text(ch.title, overflow: TextOverflow.ellipsis)),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: wide ? Space.x6 : Space.x4,
          vertical: Space.x6,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Capítulo ${index + 1}',
                  style: t.labelMedium?.copyWith(color: p.inkMuted),
                ),
                const SizedBox(height: Space.x2),
                Text(
                  ch.title,
                  style: (wide ? AtlasType.display : AtlasType.headlineSerif)
                      .copyWith(color: p.ink),
                ),
                const SizedBox(height: Space.x3),
                const SimulationStamp(label: 'Rascunho · revisar fontes'),
                const SizedBox(height: Space.x6),
                if (index == 5) ...[
                  para(
                    'Na noite de 4 de outubro de 2026, a página nacional de resultados para Presidente ficou parada em 64,81% por cerca de 50 a 60 minutos. Depois, saltou para perto de 84%.',
                  ),
                  para(
                    'Segundo o TSE, um gargalo no processamento travou o módulo que gera os arquivos de publicação "Brasil". Os arquivos de cada estado continuaram sendo atualizados normalmente durante todo o tempo.',
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: Space.x4),
                    padding: const EdgeInsets.all(Space.x4),
                    decoration: BoxDecoration(
                      color: p.plateSunk,
                      borderRadius: BorderRadius.circular(Corner.plate),
                    ),
                    child: Text(
                      'Totalização é a contagem oficial. Divulgação é a publicação dessa contagem. O que parou foi a divulgação nacional.',
                      style: AtlasType.headlineSerif.copyWith(
                        color: p.ink,
                        fontSize: 21,
                        height: 1.35,
                      ),
                    ),
                  ),
                  para(
                    'Quem somava os arquivos por UF durante a pausa via a contagem seguir. É isso que a tela Apuração mostra no replay: as duas fontes lado a lado.',
                  ),
                ] else
                  para(
                    'Este capítulo está em produção. O texto será escrito a partir das fontes oficiais do TSE e revisado em português e inglês.',
                  ),
                const SizedBox(height: Space.x4),
                Text('Fontes', style: t.titleSmall),
                const SizedBox(height: Space.x2),
                _Source(
                  'TSE · Informações técnicas sobre a divulgação de resultados',
                  'https://www.tse.jus.br/eleicoes/informacoes-tecnicas-sobre-a-divulgacao-de-resultados',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Source extends StatelessWidget {
  const _Source(this.label, this.url);

  final String label;
  final String url;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        alignment: Alignment.centerLeft,
      ),
      onPressed: () =>
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
      icon: Icon(AtlasIcons.external(context), size: 16),
      label: Text(label),
    );
  }
}
