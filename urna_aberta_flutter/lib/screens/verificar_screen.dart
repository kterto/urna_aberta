import 'package:flutter/material.dart';

import '../design/tokens.dart';
import '../design/widgets/atlas_components.dart';
import '../design/widgets/atlas_page.dart';

/// Verification status per published file.
class VerificarScreen extends StatelessWidget {
  const VerificarScreen({super.key});

  /// SIMULATION rows.
  static const _files = [
    (
      'Presidente · Brasil',
      'br-c0001-e006257-u.json',
      VerificationStatus.valid,
      '21:41:07',
    ),
    (
      'Presidente · Bahia',
      'ba-c0001-e006257-u.json',
      VerificationStatus.valid,
      '21:40:52',
    ),
    (
      'Presidente · São Paulo',
      'sp-c0001-e006257-u.json',
      VerificationStatus.valid,
      '21:41:03',
    ),
    (
      'Presidente · Pará',
      'pa-c0001-e006257-u.json',
      VerificationStatus.pending,
      '21:39:30',
    ),
    (
      'Governador · Bahia',
      'ba-c0003-e006259-u.json',
      VerificationStatus.invalid,
      '21:38:11',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    final t = Theme.of(context).textTheme;
    return AtlasPage(
      title: 'Verificar',
      lede:
          'Cada arquivo publicado pelo TSE é assinado. Aqui você vê, arquivo por arquivo, se a assinatura confere.',
      maxWidth: 1040,
      children: [
        Plate(
          title: 'Arquivos verificados',
          padding: EdgeInsets.zero,
          trailing: const SimulationStamp(),
          fonte: const FonteLine(
            plateNumber: 11,
            source: 'Verificação JWS conforme manual do TSE.',
          ),
          child: Column(
            children: [
              for (final f in _files)
                Container(
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: p.rule)),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: Space.x4,
                    vertical: Space.x3,
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: Space.x3,
                    runSpacing: Space.x2,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(f.$1, style: t.titleSmall),
                          const SizedBox(height: Space.x1),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FileCode(
                                f.$2,
                                url: Uri.parse(
                                  'https://www.tse.jus.br/eleicoes/informacoes-tecnicas-sobre-a-divulgacao-de-resultados',
                                ),
                              ),
                              const SizedBox(width: Space.x2),
                              Text(
                                'gerado ${f.$4}',
                                style: t.bodySmall?.copyWith(color: p.inkMuted),
                              ),
                            ],
                          ),
                        ],
                      ),
                      StatusBadge(f.$3),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: Space.x5),
        Plate(
          title: 'O que cada estado significa',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (s, text) in const [
                (
                  VerificationStatus.valid,
                  'O arquivo veio do TSE e não foi alterado no caminho até você.',
                ),
                (
                  VerificationStatus.invalid,
                  'A assinatura não confere. Não use estes números; tentaremos baixar de novo.',
                ),
                (
                  VerificationStatus.pending,
                  'Ainda não verificamos este arquivo. Os números aparecem marcados até a verificação.',
                ),
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: Space.x3),
                  child: Wrap(
                    spacing: Space.x3,
                    runSpacing: Space.x1,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 190,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: StatusBadge(s),
                        ),
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 560),
                        child: Text(text, style: t.bodyMedium),
                      ),
                    ],
                  ),
                ),
              Text(
                'A assinatura prova a origem do arquivo. Ela não prova nada sobre o funcionamento da urna.',
                style: t.bodySmall?.copyWith(color: p.inkSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
