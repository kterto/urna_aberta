import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../design/platform.dart';
import '../design/tokens.dart';
import '../design/typography.dart';
import '../design/widgets/atlas_components.dart';
import '../design/widgets/atlas_page.dart';
import '../l10n/l10n.dart';

class _Chapter {
  const _Chapter(this.title, this.summary);

  final String title;
  final String summary;
}

List<_Chapter> _chapters(AppLocalizations l) => [
  _Chapter(l.entendaCh1Title, l.entendaCh1Summary),
  _Chapter(l.entendaCh2Title, l.entendaCh2Summary),
  _Chapter(l.entendaCh3Title, l.entendaCh3Summary),
  _Chapter(l.entendaCh4Title, l.entendaCh4Summary),
  _Chapter(l.entendaCh5Title, l.entendaCh5Summary),
  _Chapter(l.entendaCh6Title, l.entendaCh6Summary),
  _Chapter(l.entendaCh7Title, l.entendaCh7Summary),
];

/// Learn: chapter index plus the reading experience.
class EntendaScreen extends StatelessWidget {
  const EntendaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    final t = Theme.of(context).textTheme;
    final wide = isWideLayout(context);
    final l = context.l10n;
    final chapters = _chapters(l);

    final index = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < chapters.length; i++)
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
                          chapters[i].title,
                          style: AtlasType.headlineSerif.copyWith(
                            color: p.ink,
                            fontSize: wide ? 26 : 21,
                          ),
                        ),
                        const SizedBox(height: Space.x1),
                        Text(
                          chapters[i].summary,
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
      title: l.entendaTitle,
      lede: l.entendaLede,
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
    final l = context.l10n;
    final ch = _chapters(l)[index];
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
                  l.entendaChapterLabel(index + 1),
                  style: t.labelMedium?.copyWith(color: p.inkMuted),
                ),
                const SizedBox(height: Space.x2),
                Text(
                  ch.title,
                  style: (wide ? AtlasType.display : AtlasType.headlineSerif)
                      .copyWith(color: p.ink),
                ),
                const SizedBox(height: Space.x3),
                SimulationStamp(label: l.entendaDraftStamp),
                const SizedBox(height: Space.x6),
                if (index == 5) ...[
                  para(
                    l.entendaPausePara1,
                  ),
                  para(
                    l.entendaPausePara2,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: Space.x4),
                    padding: const EdgeInsets.all(Space.x4),
                    decoration: BoxDecoration(
                      color: p.plateSunk,
                      borderRadius: BorderRadius.circular(Corner.plate),
                    ),
                    child: Text(
                      l.entendaPauseCallout,

                      style: AtlasType.headlineSerif.copyWith(
                        color: p.ink,
                        fontSize: 21,
                        height: 1.35,
                      ),
                    ),
                  ),
                  para(
                    l.entendaPausePara3,
                  ),
                ] else
                  para(
                    l.entendaInProduction,
                  ),
                const SizedBox(height: Space.x4),
                Text(l.entendaSources, style: t.titleSmall),
                const SizedBox(height: Space.x2),
                _Source(
                  l.entendaSourceDivulgacao,
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
