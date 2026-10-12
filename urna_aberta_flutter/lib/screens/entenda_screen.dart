import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app/router.dart';
import '../design/platform.dart';
import '../design/tokens.dart';
import '../design/typography.dart';
import '../design/widgets/atlas_page.dart';
import '../l10n/l10n.dart';

sealed class _Block {
  const _Block(this.text);

  final String text;
}

class _Para extends _Block {
  const _Para(super.text);
}

class _Callout extends _Block {
  const _Callout(super.text);
}

class _Heading extends _Block {
  const _Heading(super.text);
}

class _SourceRef {
  const _SourceRef(this.label, this.url);

  final String label;
  final String url;
}

class _Chapter {
  const _Chapter(this.title, this.summary, this.body, this.sources);

  final String title;
  final String summary;
  final List<_Block> body;
  final List<_SourceRef> sources;
}

const _tse = 'https://www.tse.jus.br';
const _fatoOuBoatoPause =
    'https://www.justicaeleitoral.jus.br/fato-ou-boato/checagens/2026/e-falso-que-a-interrupcao-na-divulgacao-dos-resultados-tenha-fraudado-o-resultado-do-1o-turno-para-presidente';
const _divulgacaoTecnica =
    '$_tse/eleicoes/informacoes-tecnicas-sobre-a-divulgacao-de-resultados';
const _totalizacao2026 =
    '$_tse/comunicacao/noticias/2026/Outubro/saiba-como-foi-a-totalizacao-dos-votos-no-1o-turno-das-eleicoes-2026';
const _apuracaoTotalizacao =
    '$_tse/comunicacao/noticias/2026/Outubro/entenda-a-diferenca-entre-apuracao-e-totalizacao-de-votos';
const _caminhoDoVoto =
    '$_tse/comunicacao/noticias/2026/Setembro/faltam-7-dias-veja-qual-e-o-caminho-do-voto-depois-de-encerrada-a-votacao';
const _res23751 =
    '$_tse/legislacao/compilada/res/2026/resolucao-no-23-751-de-26-de-fevereiro-de-2026';
const _boletimDuvidas =
    '$_tse/comunicacao/noticias/2022/Outubro/voce-ja-ouviu-falar-do-boletim-de-urna-mas-sabe-o-que-ele-e-tire-suas-duvidas';
const _dadosAbertosResultados =
    'https://dadosabertos.tse.jus.br/group/about/resultados';
const _votacaoSegura =
    '$_tse/eleicoes/historia/processo-eleitoral-brasileiro/votacao/votacao-segura';
const _res23673 =
    '$_tse/legislacao/compilada/res/2021/resolucao-no-23-673-14-de-dezembro-de-2021';
const _mitosVerdades =
    '$_tse/eleicoes/eleicoes-2018/seguranca-das-eleicoes-informatizadas';
const _acompanharResultados =
    '$_tse/comunicacao/noticias/2026/Outubro/terminada-a-votacao-saiba-como-acompanhar-os-resultados-das-eleicoes';
const _ea18 =
    '$_tse/eleicoes/eleicoes-2026-content/arquivos/divulgacao-de-resultados/tse-ea18-arquivo-auxiliar-de-secao';
const _assinaturaResumo =
    '$_tse/comunicacao/noticias/2021/Agosto/assinatura-digital-e-resumos-digitais-trazem-ainda-mais-seguranca-a-urna-eletronica';
const _manualJws =
    '$_tse/eleicoes/eleicoes-2026-content/arquivos/divulgacao-de-resultados/manual-verificacao-jws';
const _manualQr =
    '$_tse/eleicoes/eleicoes-2026-content/arquivos/manual-do-qr-code-no-boletim-de-urna/@@display-file/file/manual-do-qr-code-no-boletim-de-urna.pdf';
const _codigoFonte =
    '$_tse/comunicacao/noticias/2026/Abril/eleicoes-2026-codigos-fonte-dos-sistemas-eleitorais-continuam-abertos-para-inspecao';
const _tps2025 =
    '$_tse/comunicacao/noticias/2025/Novembro/confiabilidade-transparencia-e-seguranca-teste-da-urna-2025-comeca-na-segunda-1o';
const _testeConfirmacao =
    '$_tse/comunicacao/noticias/2026/Maio/eleicoes-2026-testes-confirmam-mais-uma-vez-a-seguranca-do-sistema-eleitoral-brasileiro';
const _lacracao2026 =
    '$_tse/comunicacao/noticias/2026/Setembro/sistemas-das-eleicoes-gerais-de-2026-sao-assinados-digitalmente-e-lacrados-pelo-tse';
const _testeIntegridade =
    '$_tse/comunicacao/noticias/2026/Agosto/como-funciona-o-teste-de-integridade-a-prova-dos-nove-da-urna-eletronica';
const _codigoEleitoral =
    'https://www.planalto.gov.br/ccivil_03/leis/l4737compilado.htm';
const _res23677 =
    '$_tse/legislacao/compilada/res/2021/resolucao-no-23-677-de-16-de-dezembro-de-2021';
const _stfSobras2024 =
    'https://noticias.stf.jus.br/postsnoticias/supremo-invalida-regra-sobre-distribuicao-de-sobras-eleitorais-em-eleicoes-proporcionais/';
const _stfSobras2025 =
    'https://noticias.stf.jus.br/postsnoticias/decisao-do-stf-sobre-distribuicao-de-sobras-eleitorais-vale-desde-2022/';
const _testeIntegridade2026 =
    '$_tse/comunicacao/noticias/2026/Outubro/teste-de-integridade-no-tse-confirma-correspondencia-entre-cedulas-e-votos-registrados-nas-urnas';

List<_Chapter> _chapters(AppLocalizations l) => [
  _Chapter(
    l.entendaCh1Title,
    l.entendaCh1Summary,
    [
      _Para(l.entendaCh1Para1),
      _Para(l.entendaCh1Para2),
      _Para(l.entendaCh1Para3),
      _Callout(l.entendaCh1Callout),
      _Para(l.entendaCh1Para4),
    ],
    [
      _SourceRef(l.entendaSourceCaminhoDoVoto, _caminhoDoVoto),
      _SourceRef(l.entendaSourceApuracaoTotalizacao, _apuracaoTotalizacao),
      _SourceRef(l.entendaSourceTotalizacao2026, _totalizacao2026),
      _SourceRef(l.entendaSourceRes23751, _res23751),
    ],
  ),
  _Chapter(
    l.entendaCh2Title,
    l.entendaCh2Summary,
    [
      _Para(l.entendaCh2Para1),
      _Para(l.entendaCh2Para2),
      _Para(l.entendaCh2Para3),
      _Para(l.entendaCh2Para4),
    ],
    [
      _SourceRef(l.entendaSourceBoletimDuvidas, _boletimDuvidas),
      _SourceRef(l.entendaSourceTotalizacao2026, _totalizacao2026),
      _SourceRef(l.entendaSourceRes23751, _res23751),
      _SourceRef(
        l.entendaSourceDadosAbertosResultados,
        _dadosAbertosResultados,
      ),
    ],
  ),
  _Chapter(
    l.entendaCh3Title,
    l.entendaCh3Summary,
    [
      _Para(l.entendaCh3Para1),
      _Para(l.entendaCh3Para2),
      _Para(l.entendaCh3Para3),
      _Para(l.entendaCh3Para4),
    ],
    [
      _SourceRef(l.entendaSourceAcompanharResultados, _acompanharResultados),
      _SourceRef(l.entendaSourceVotacaoSegura, _votacaoSegura),
      _SourceRef(l.entendaSourceRes23673, _res23673),
      _SourceRef(l.entendaSourceMitosVerdades, _mitosVerdades),
      _SourceRef(l.entendaSourceEa18, _ea18),
    ],
  ),
  _Chapter(
    l.entendaCh4Title,
    l.entendaCh4Summary,
    [
      _Para(l.entendaCh4Para1),
      _Para(l.entendaCh4Para2),
      _Para(l.entendaCh4Para3),
      _Callout(l.entendaCh4Callout),
      _Para(l.entendaCh4Para4),
    ],
    [
      _SourceRef(l.entendaSourceRes23673, _res23673),
      _SourceRef(l.entendaSourceAssinaturaResumo, _assinaturaResumo),
      _SourceRef(l.entendaSourceManualJws, _manualJws),
      _SourceRef(l.entendaSourceEa18, _ea18),
      _SourceRef(l.entendaSourceManualQr, _manualQr),
    ],
  ),
  _Chapter(
    l.entendaCh5Title,
    l.entendaCh5Summary,
    [
      _Para(l.entendaCh5Para1),
      _Para(l.entendaCh5Para2),
      _Para(l.entendaCh5Para3),
      _Para(l.entendaCh5Para4),
      _Para(l.entendaCh5Para5),
    ],
    [
      _SourceRef(l.entendaSourceCodigoFonte, _codigoFonte),
      _SourceRef(l.entendaSourceRes23673, _res23673),
      _SourceRef(l.entendaSourceTps2025, _tps2025),
      _SourceRef(l.entendaSourceTesteConfirmacao, _testeConfirmacao),
      _SourceRef(l.entendaSourceLacracao2026, _lacracao2026),
      _SourceRef(l.entendaSourceTesteIntegridade, _testeIntegridade),
      _SourceRef(l.entendaSourceTesteIntegridade2026, _testeIntegridade2026),
    ],
  ),
  _Chapter(
    l.entendaCh6Title,
    l.entendaCh6Summary,
    [
      _Para(l.entendaPausePara1),
      _Para(l.entendaPausePara2),
      _Para(l.entendaPausePara2b),
      _Callout(l.entendaPauseCallout),
      _Para(l.entendaPausePara3),
    ],
    [
      _SourceRef(l.entendaSourceFatoOuBoato, _fatoOuBoatoPause),
      _SourceRef(l.entendaSourceDivulgacao, _divulgacaoTecnica),
    ],
  ),
  _Chapter(
    l.entendaChSeatsTitle,
    l.entendaChSeatsSummary,
    [
      _Para(l.entendaChSeatsPara1),
      _Para(l.entendaChSeatsPara2),
      _Para(l.entendaChSeatsPara3),
      _Para(l.entendaChSeatsPara4),
      _Para(l.entendaChSeatsPara5),
      _Callout(l.entendaChSeatsCallout),
    ],
    [
      _SourceRef(l.entendaSourceCodigoEleitoral, _codigoEleitoral),
      _SourceRef(l.entendaSourceRes23677, _res23677),
      _SourceRef(l.entendaSourceStfSobras2024, _stfSobras2024),
      _SourceRef(l.entendaSourceStfSobras2025, _stfSobras2025),
    ],
  ),
  _Chapter(
    l.entendaCh7Title,
    l.entendaCh7Summary,
    [
      _Para(l.entendaCh7Para1),
      _Heading(l.entendaCh7ProvesTitle),
      _Para(l.entendaCh7Para2),
      _Heading(l.entendaCh7NotTitle),
      _Para(l.entendaCh7Para3),
      _Para(l.entendaCh7Para4),
    ],
    [
      _SourceRef(l.entendaSourceManualJws, _manualJws),
      _SourceRef(l.entendaSourceEa18, _ea18),
      _SourceRef(l.entendaSourceManualQr, _manualQr),
      _SourceRef(l.entendaSourceRes23673, _res23673),
    ],
  ),
];

/// Learn: chapter index plus the reading experience.
class EntendaScreen extends StatelessWidget {
  const EntendaScreen({super.key});

  /// How many chapters [_chapters] lists; their addresses are
  /// `/entenda/1` to `/entenda/8`.
  static const chapters = 8;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    final t = Theme.of(context).textTheme;
    final wide = isWideLayout(context);
    final l = context.l10n;
    final chapters = _chapters(l);
    assert(chapters.length == EntendaScreen.chapters);

    final index = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < chapters.length; i++)
          InkWell(
            onTap: () => context.go(Paths.chapter(i)),
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

/// One chapter, over the shell.
class EntendaChapterScreen extends StatelessWidget {
  const EntendaChapterScreen({super.key, required this.index});

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
                const SizedBox(height: Space.x6),
                for (final block in ch.body)
                  switch (block) {
                    _Para(:final text) => para(text),
                    _Heading(:final text) => Padding(
                      padding: const EdgeInsets.only(
                        top: Space.x2,
                        bottom: Space.x2,
                      ),
                      child: Text(text, style: t.titleMedium),
                    ),
                    _Callout(:final text) => Container(
                      margin: const EdgeInsets.only(bottom: Space.x4),
                      padding: const EdgeInsets.all(Space.x4),
                      decoration: BoxDecoration(
                        color: p.plateSunk,
                        borderRadius: BorderRadius.circular(Corner.plate),
                      ),
                      child: Text(
                        text,
                        style: AtlasType.headlineSerif.copyWith(
                          color: p.ink,
                          fontSize: 21,
                          height: 1.35,
                        ),
                      ),
                    ),
                  },
                const SizedBox(height: Space.x4),
                Text(l.entendaSources, style: t.titleSmall),
                const SizedBox(height: Space.x2),
                for (final source in ch.sources) ...[
                  _Source(source.label, source.url),
                  const SizedBox(height: Space.x2),
                ],
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
