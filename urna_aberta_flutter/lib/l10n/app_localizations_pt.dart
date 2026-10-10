// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String atlasPlate(int number) {
    return 'Prancha $number';
  }

  @override
  String atlasFile(String code) {
    return 'Arquivo $code';
  }

  @override
  String atlasOpenFile(String code) {
    return 'Abrir arquivo $code';
  }

  @override
  String get atlasSimulation => 'Simulação';

  @override
  String atlasSimulationSemantics(String label) {
    return '$label: dados não oficiais';
  }

  @override
  String get atlasSignatureValid => 'Assinatura válida';

  @override
  String get atlasSignatureInvalid => 'Assinatura inválida';

  @override
  String get atlasNotVerified => 'Não verificado';

  @override
  String get atlasLearnWhy => 'Entenda por quê';

  @override
  String get atlasDivergenceTitle =>
      'A divulgação nacional está atrás dos estados.';

  @override
  String get atlasDivergenceBody =>
      'A contagem continua: os arquivos por UF seguem sendo atualizados.';

  @override
  String get atlasCopyHash => 'Copiar hash';

  @override
  String get atlasHashCopied => 'Hash copiado';

  @override
  String get replayPause => 'Pausar replay';

  @override
  String get replayPlay => 'Reproduzir replay';

  @override
  String replayClock(String clock) {
    return 'Relógio do replay $clock';
  }

  @override
  String get replayJumpToFreeze => 'Ir para a pausa';

  @override
  String get replaySimulated => 'Replay simulado';

  @override
  String get mapTitle => 'Seções totalizadas por UF';

  @override
  String mapSimulationAt(String moment) {
    return 'Simulação · $moment';
  }

  @override
  String get mapSource =>
      'Malhas: IBGE. Dados: TSE, EA20 por UF. Escala aproximada.';

  @override
  String get mapLayerRegions => 'Regiões';

  @override
  String get mapLayerCounted => 'Seções totalizadas';

  @override
  String get mapShowMap => 'Ver mapa';

  @override
  String get mapShowTable => 'Ver em tabela';

  @override
  String get mapClearSelection => 'Limpar seleção';

  @override
  String mapUfCount(int count) {
    return '$count UF';
  }

  @override
  String mapUfUpdated(String region, String moment) {
    return '$region · atualizado $moment';
  }

  @override
  String get mapCountedCaption => 'seções totalizadas';

  @override
  String get mapHint => 'Toque em um estado ou em uma chave da legenda.';

  @override
  String get mapNoUfInBand => 'Nenhuma UF nesta faixa';

  @override
  String get mapAverageCaption => 'média simples das UFs';

  @override
  String get mapColumnRegion => 'Região';

  @override
  String get mapColumnCounted => '% seções totalizadas';

  @override
  String get mapColumnFile => 'Arquivo';

  @override
  String mapLongitudeWest(int degrees) {
    return '$degrees°O';
  }

  @override
  String mapLatitudeSouth(int degrees) {
    return '$degrees°S';
  }

  @override
  String get mapTropic => 'Trópico de Capricórnio';

  @override
  String get mapEquator => 'Equador';

  @override
  String mapUfSemantics(String uf, String region, String pct) {
    return '$uf, $region, $pct das seções totalizadas';
  }

  @override
  String get chartNationalFileTse => 'Arquivo nacional do TSE';

  @override
  String get chartNationalFile => 'Arquivo nacional';

  @override
  String get chartStatesSum => 'Soma dos estados';

  @override
  String chartDuoSemantics(String national, String states) {
    return 'Arquivo nacional do TSE $national por cento; soma dos estados $states por cento';
  }

  @override
  String get chartDifference => 'Diferença: ';

  @override
  String chartPoints(String value) {
    return '$value p.p.';
  }

  @override
  String get chartDifferenceOf => ' de seções totalizadas';

  @override
  String get chartVotesSemantics => 'Votos por candidatura nas duas fontes';

  @override
  String chartRowSemantics(String label, String national, String states) {
    return '$label: $national no arquivo nacional, $states na soma dos estados';
  }

  @override
  String get chartTimelineSemantics =>
      'Linha do tempo das duas fontes. Use as setas para explorar.';

  @override
  String chartTimelinePointSemantics(
    String time,
    String national,
    String states,
  ) {
    return '$time: arquivo nacional $national, soma dos estados $states';
  }

  @override
  String get chartNationalFrozenSuffix => ' · nacional parado';

  @override
  String chartFreezeBand(int minutes) {
    return 'Nacional parado · $minutes min';
  }

  @override
  String chartHourTick(int hour) {
    return '${hour}h';
  }

  @override
  String chartUfSemantics(String uf, String pct) {
    return '$uf: $pct das seções totalizadas';
  }

  @override
  String get apuracaoHeadline => 'A contagem não parou.';

  @override
  String get apuracaoLede =>
      'Presidente, 1º turno. O arquivo nacional do TSE e a soma dos arquivos de cada estado, lado a lado. Cada número leva ao arquivo de onde veio.';

  @override
  String get apuracaoDesignSystem => 'Sistema de design';

  @override
  String get apuracaoDuoTitle => 'Comparação das duas fontes · Presidente';

  @override
  String get apuracaoDuoSource =>
      '% de seções totalizadas. Fonte: TSE. Soma calculada pela Urna Aberta.';

  @override
  String apuracaoFrozenSince(String time) {
    return 'parado desde $time';
  }

  @override
  String apuracaoUpdatedAt(String time) {
    return 'atualizado $time';
  }

  @override
  String get apuracaoVotesTitle => 'Votos por candidatura, nas duas fontes';

  @override
  String get apuracaoVotesSourceSynthetic =>
      'Mesma tinta para todas as candidaturas. Votos intermediários proporcionais aos arquivos finais do TSE.';

  @override
  String get apuracaoVotesSource =>
      'Mesma tinta para todas as candidaturas. Fonte: TSE.';

  @override
  String get apuracaoTimelineTitle => 'A noite de 4 de outubro';

  @override
  String apuracaoTimelineSource(String pct) {
    return 'Curva sintética que termina nos arquivos finais reais do TSE, com a pausa nacional de $pct simulada.';
  }

  @override
  String apuracaoCandidateNumber(int number) {
    return 'Número $number';
  }

  @override
  String get apuracaoReplayUnavailable =>
      'Os arquivos do 1º turno ainda não foram carregados no servidor.';

  @override
  String get apuracaoServerUnreachable =>
      'Não foi possível falar com o servidor da Urna Aberta.';

  @override
  String get apuracaoRetry => 'Tentar de novo';

  @override
  String get navApuracao => 'Apuração';

  @override
  String get navSecao => 'Minha seção';

  @override
  String get navVerificar => 'Verificar';

  @override
  String get navEntenda => 'Entenda';

  @override
  String get navSistema => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeDark => 'Escuro';

  @override
  String get language => 'Idioma';

  @override
  String get languageDevice => 'Do aparelho';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languageEnglish => 'English';

  @override
  String get entendaTitle => 'Entenda o processo';

  @override
  String get entendaLede =>
      'Capítulos curtos sobre como o resultado sai da urna e chega até você. Cada afirmação cita uma fonte oficial do TSE.';

  @override
  String get entendaCh1Title => 'O caminho do voto';

  @override
  String get entendaCh1Summary =>
      'Da urna ao boletim afixado, da transmissão à divulgação.';

  @override
  String get entendaCh2Title => 'O Boletim de Urna';

  @override
  String get entendaCh2Summary =>
      'O que ele contém, por que é público e como conferir.';

  @override
  String get entendaCh3Title => 'Os arquivos da urna';

  @override
  String get entendaCh3Summary => 'BU, RDV e log: para que serve cada um.';

  @override
  String get entendaCh4Title => 'Assinaturas e hashes';

  @override
  String get entendaCh4Summary =>
      'O que as verificações deste app realmente checam.';

  @override
  String get entendaCh5Title => 'Protocolos de segurança';

  @override
  String get entendaCh5Summary =>
      'Testes públicos, cerimônias e inspeção do código.';

  @override
  String get entendaCh6Title => '4 de outubro de 2026';

  @override
  String get entendaCh6Summary =>
      'O que parou, o que não parou, e como o replay mostra isso.';

  @override
  String get entendaCh7Title => 'O que este app prova';

  @override
  String get entendaCh7Summary =>
      'E, com a mesma clareza, o que ele não prova.';

  @override
  String entendaChapterLabel(int number) {
    return 'Capítulo $number';
  }

  @override
  String get entendaDraftStamp => 'Rascunho · revisar fontes';

  @override
  String get entendaPausePara1 =>
      'Na noite de 4 de outubro de 2026, a página nacional de resultados para Presidente ficou parada em 64,81% por cerca de 50 a 60 minutos. Depois, saltou para perto de 84%.';

  @override
  String get entendaPausePara2 =>
      'Segundo o TSE, um gargalo no processamento travou o módulo que gera os arquivos de publicação \"Brasil\". Os arquivos de cada estado continuaram sendo atualizados normalmente durante todo o tempo.';

  @override
  String get entendaPauseCallout =>
      'Totalização é a contagem oficial. Divulgação é a publicação dessa contagem. O que parou foi a divulgação nacional.';

  @override
  String get entendaPausePara3 =>
      'Quem somava os arquivos por UF durante a pausa via a contagem seguir. É isso que a tela Apuração mostra no replay: as duas fontes lado a lado.';

  @override
  String get entendaInProduction =>
      'Este capítulo está em produção. O texto será escrito a partir das fontes oficiais do TSE e revisado em português e inglês.';

  @override
  String get entendaSources => 'Fontes';

  @override
  String get entendaSourceDivulgacao =>
      'TSE · Informações técnicas sobre a divulgação de resultados';

  @override
  String get secaoTitle => 'Minha seção';

  @override
  String get secaoLede =>
      'Encontre o Boletim de Urna oficial da sua seção e compare com o boletim impresso e afixado no local de votação.';

  @override
  String get secaoFieldUf => 'UF';

  @override
  String get secaoUfExterior => 'Exterior';

  @override
  String get secaoFieldMunicipio => 'Município';

  @override
  String get secaoFieldZona => 'Zona';

  @override
  String get secaoFieldSecao => 'Seção';

  @override
  String get secaoLoadingMunicipios => 'Carregando municípios…';

  @override
  String get secaoLoadingZonas => 'Carregando zonas…';

  @override
  String get secaoLoadingSecoes => 'Carregando seções…';

  @override
  String get secaoLocatePlate => 'Localizar seção';

  @override
  String get secaoFormHint =>
      'Zona e seção estão no seu título de eleitor ou no e-Título. A lista vem do arquivo de seções do TSE.';

  @override
  String get secaoSearchButton => 'Buscar boletim de urna';

  @override
  String get secaoSearchingTse => 'Buscando os arquivos da seção no TSE…';

  @override
  String secaoSectionTitle(String zona, String secao, String municipio) {
    return 'Seção $zona/$secao, $municipio';
  }

  @override
  String get secaoNotPublished =>
      'O TSE ainda não publicou os arquivos desta seção. Volte depois do envio da urna.';

  @override
  String secaoNoBu(String status) {
    return 'O TSE publicou a seção ($status), mas sem boletim de urna para conferir.';
  }

  @override
  String get secaoHashMismatch => 'Hash não confere';

  @override
  String get secaoBuDiffers =>
      'O boletim recebido não confere com a lista de arquivos assinada pela urna. Os votos não são exibidos.';

  @override
  String get secaoBuNotListed =>
      'A urna não listou este boletim entre os arquivos que assinou. Os votos não são exibidos.';

  @override
  String get secaoListingAltered =>
      'A lista de arquivos da urna não confere com o que ela assinou. Os votos não são exibidos.';

  @override
  String get secaoComparePlate => 'Boletim de Urna: arquivo vs papel';

  @override
  String secaoCompareSource(
    String zona,
    String secao,
    String municipio,
    String uf,
    String emitido,
    String recebido,
  ) {
    return 'Seção $zona/$secao, $municipio ($uf). Boletim emitido às $emitido (relógio da urna); recebido pelo TSE às $recebido (Brasília).';
  }

  @override
  String secaoTurnout(String aptos, String votaram) {
    return '$aptos eleitores aptos, $votaram votaram. Digite os números do boletim impresso na coluna Papel.';
  }

  @override
  String get secaoColCandidatura => 'Candidatura';

  @override
  String get secaoColArquivo => 'Arquivo';

  @override
  String get secaoColPapel => 'Papel';

  @override
  String get secaoColConfere => 'Confere';

  @override
  String get secaoPaperHint => 'Papel';

  @override
  String secaoMismatch(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count linhas não conferem',
      one: 'Uma linha não confere',
    );
    return '$_temp0. Primeiro confira se digitou o número do papel corretamente. Se a diferença continuar, fotografe o boletim afixado e procure o cartório eleitoral da sua zona.';
  }

  @override
  String get secaoAllMatch =>
      'Todos os números conferem com o arquivo oficial.';

  @override
  String get secaoFilesPlate => 'Arquivos da seção';

  @override
  String get secaoFilesSource =>
      'Arquivo auxiliar da seção (EA18), boletim de urna e assinaturas da urna, como publicados pelo TSE.';

  @override
  String get secaoHashMatches => 'Hash confere';

  @override
  String get secaoSignatureUnverified => 'Assinatura não verificada';

  @override
  String secaoHashLabel(String kind) {
    return '$kind · SHA-256';
  }

  @override
  String get secaoKindAux => 'Arquivo auxiliar';

  @override
  String get secaoKindBu => 'Boletim de urna';

  @override
  String get secaoKindVota => 'Assinaturas da urna';

  @override
  String get secaoProvesLabel => 'O que isto prova: ';

  @override
  String get secaoProves =>
      'o boletim publicado é exatamente o arquivo que a urna listou na sua lista de arquivos assinada. ';

  @override
  String get secaoNotYetLabel => 'O que ainda não prova: ';

  @override
  String get secaoNotYet =>
      'a assinatura digital da urna sobre essa lista ainda não é verificada pela Urna Aberta. E nada aqui diz algo sobre a urna em si.';

  @override
  String get secaoVoteBranco => 'Branco';

  @override
  String get secaoVoteNulo => 'Nulo';

  @override
  String secaoVoteLegenda(String numero) {
    return 'Legenda $numero';
  }

  @override
  String get secaoVoteCargoSemCandidato => 'Cargo sem candidatura';

  @override
  String get secaoCargoPresidente => 'Presidente';

  @override
  String get secaoCargoGovernador => 'Governador';

  @override
  String get secaoCargoSenador => 'Senador';

  @override
  String get secaoCargoDeputadoFederal => 'Deputado Federal';

  @override
  String get secaoCargoDeputadoEstadual => 'Deputado Estadual';

  @override
  String get secaoCargoDeputadoDistrital => 'Deputado Distrital';

  @override
  String get secaoErrorTitle => 'Não foi possível buscar a seção';

  @override
  String get secaoErrorNotFound =>
      'O TSE não lista esta seção. Confira a zona e a seção no seu título de eleitor.';

  @override
  String get secaoErrorUnavailable =>
      'O TSE não respondeu agora ou publicou um arquivo que não pôde ser lido. Tente de novo mais tarde.';

  @override
  String get secaoErrorServer =>
      'Não foi possível falar com o servidor da Urna Aberta.';

  @override
  String get secaoRetry => 'Tentar de novo';

  @override
  String get secaoMatchYes => 'Sim';

  @override
  String get secaoMatchNo => 'Não';

  @override
  String get secaoWheelOk => 'OK';

  @override
  String secaoSearchHint(String field) {
    return 'Buscar $field';
  }

  @override
  String secaoNothingFound(String query) {
    return 'Nada encontrado para “$query”.';
  }

  @override
  String get ufBrasil => 'Brasil';

  @override
  String get ufExterior => 'Exterior';

  @override
  String get verificarTitle => 'Verificar';

  @override
  String get verificarLede =>
      'O TSE assina cada arquivo de resultado que publica. A Urna Aberta confere a assinatura ao guardar o arquivo, e este aparelho pode conferir de novo por conta própria, sem confiar no nosso servidor.';

  @override
  String get verificarOfficePresidente => 'Presidente';

  @override
  String get verificarOfficeGovernador => 'Governador';

  @override
  String get verificarOfficeSenador => 'Senador';

  @override
  String get verificarSummaryTitle => 'Assinaturas dos arquivos de resultado';

  @override
  String get verificarSummarySource =>
      'Assinatura JWS (EdDSA, Ed25519) conforme o Manual de verificação dos arquivos JWS do TSE. Chave pública do ambiente oficial, Apêndice B.';

  @override
  String get verificarFilesStored => 'arquivos guardados';

  @override
  String get verificarValidOnServer => 'válidos no servidor';

  @override
  String get verificarValidOnDevice => 'válidos neste aparelho';

  @override
  String get verificarCheckedHere => 'conferidos aqui';

  @override
  String verificarDeviceBad(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count arquivos não conferem neste aparelho. Não use os números deles.',
      one: 'Um arquivo não confere neste aparelho. Não use os números dele.',
    );
    return '$_temp0';
  }

  @override
  String get verificarAllChecked => 'Todos conferidos neste aparelho';

  @override
  String get verificarCheckOnDevice => 'Conferir neste aparelho';

  @override
  String verificarChecking(String done, String total) {
    return 'Conferindo $done de $total…';
  }

  @override
  String get verificarCheckExplain =>
      'Baixa cada arquivo assinado e confere a assinatura com a chave do TSE que vem dentro do app.';

  @override
  String verificarGroupTitle(String office, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos',
      one: '1 arquivo',
    );
    return '$office · $_temp0';
  }

  @override
  String verificarGroupSource(String when) {
    return 'Arquivos finais do TSE, o mais recente gerado em $when (Brasília).';
  }

  @override
  String get verificarColumnServer => 'No servidor';

  @override
  String get verificarColumnDevice => 'Neste aparelho';

  @override
  String verificarGenerated(String when) {
    return 'gerado $when';
  }

  @override
  String verificarOnServer(String status) {
    return 'Servidor: $status';
  }

  @override
  String verificarOnDevice(String status) {
    return 'Aparelho: $status';
  }

  @override
  String get verificarStatusValid => 'assinatura válida';

  @override
  String get verificarStatusInvalid => 'assinatura inválida';

  @override
  String get verificarStatusUnknownKey => 'chave desconhecida';

  @override
  String get verificarStatusUnsigned => 'sem assinatura';

  @override
  String get verificarStatusChecking => 'conferindo…';

  @override
  String get verificarStatusDownloadFailed => 'não foi possível baixar';

  @override
  String get verificarStatusDifferentFile => 'outro arquivo';

  @override
  String get verificarStatusUnreadable => 'arquivo ilegível';

  @override
  String get verificarStatusNotChecked => 'não conferido';

  @override
  String get verificarYourselfTitle => 'Confira você mesmo';

  @override
  String get verificarYourselfSource =>
      'Chave: TSE, Manual de verificação dos arquivos JWS, Apêndice B. Receita testada com OpenSSL 3 em 10/10/2026.';

  @override
  String get verificarYourselfIntro =>
      'Não precisa confiar na Urna Aberta. Cada arquivo .jws traz o próprio conteúdo e a assinatura do TSE; com a chave pública abaixo, qualquer computador confere.';

  @override
  String get verificarKeyId => 'Chave (kid)';

  @override
  String get verificarStep1 =>
      'Baixe um arquivo .jws pelo link de qualquer linha acima (o mesmo nome do .json, com outra terminação).';

  @override
  String get verificarStep2 => 'Salve a chave abaixo como tse.pem.';

  @override
  String get verificarStep3 =>
      'Rode os comandos no terminal. \"Signature Verified Successfully\" quer dizer que confere; conteudo.json é o arquivo que o TSE assinou.';

  @override
  String get verificarTerminal => 'Terminal (macOS ou Linux)';

  @override
  String get verificarKeyNote =>
      'A chave fica dentro do app e do servidor, nunca é lida do próprio arquivo: uma chave que viesse junto com o arquivo não provaria nada.';

  @override
  String get verificarCopy => 'Copiar';

  @override
  String get verificarCopied => 'Copiado';

  @override
  String get verificarMeaningTitle => 'O que cada estado significa';

  @override
  String get verificarMeaningValidLabel => 'Assinatura válida';

  @override
  String get verificarMeaningValid =>
      'O arquivo é exatamente o que o TSE assinou: veio do TSE e não foi alterado no caminho.';

  @override
  String get verificarMeaningInvalidLabel => 'Assinatura inválida';

  @override
  String get verificarMeaningInvalid =>
      'A assinatura não confere com o conteúdo. Não use estes números.';

  @override
  String get verificarMeaningDifferentLabel => 'Outro arquivo';

  @override
  String get verificarMeaningDifferent =>
      'A assinatura confere, mas o arquivo não é o que o servidor da Urna Aberta disse ter usado.';

  @override
  String get verificarMeaningNotCheckedLabel => 'Não conferido';

  @override
  String get verificarMeaningNotChecked =>
      'Este aparelho ainda não conferiu o arquivo. O resultado do servidor continua valendo, mas depende de você confiar nele.';

  @override
  String get verificarProves =>
      'A assinatura prova a origem e a integridade do arquivo publicado. Ela não prova nada sobre o funcionamento da urna nem sobre a totalização.';

  @override
  String get verificarUrnaNote =>
      'Os arquivos de cada urna (boletim de urna) têm outra assinatura, conferida em Minha seção pelo hash; a assinatura da própria urna ainda não é verificada pela Urna Aberta.';

  @override
  String get verificarLoadError =>
      'Não foi possível falar com o servidor da Urna Aberta.';

  @override
  String get verificarRetry => 'Tentar de novo';
}
