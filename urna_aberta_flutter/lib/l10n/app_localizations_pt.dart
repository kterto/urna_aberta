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
    return 'Curva sintética que termina nos arquivos finais reais do TSE. A pausa nacional em $pct, das 19h14 às 20h04, segue o horário informado pelo TSE.';
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
  String get navResultados => 'Resultados';

  @override
  String get resultadosTitle => 'Resultados';

  @override
  String get resultadosLede =>
      'O resultado de cada cargo, em cada estado ou município, lido do arquivo assinado do TSE. Para deputados e vereadores, a Urna Aberta refaz a distribuição das vagas e compara com a do TSE.';

  @override
  String resultadosRound(String year, int round) {
    return '$year · $roundº turno';
  }

  @override
  String get resultadosElection => 'Eleição';

  @override
  String get resultadosOffice => 'Cargo';

  @override
  String get resultadosPlace => 'Estado';

  @override
  String get resultadosMunicipio => 'Município';

  @override
  String get resultadosMunicipioHint => 'Digite para buscar';

  @override
  String get cargoPrefeito => 'Prefeito';

  @override
  String get cargoVereador => 'Vereador';

  @override
  String get resultadosNotHeld =>
      'Esta votação ainda não aconteceu. O TSE começa a publicar os resultados às 17h (horário de Brasília) do dia da eleição.';

  @override
  String get resultadosChooseMunicipio =>
      'Escolha o município para ver o resultado.';

  @override
  String get resultadosNotPublished =>
      'O TSE ainda não publicou este resultado.';

  @override
  String get resultadosInvalidRequest => 'Este cargo não é eleito neste lugar.';

  @override
  String get resultadosTseUnavailable =>
      'O TSE não respondeu. Tente de novo em instantes.';

  @override
  String get resultadosError => 'Não foi possível carregar o resultado.';

  @override
  String get resultadosSummaryPlate => 'Resumo do resultado';

  @override
  String get resultadosValidVotes => 'Votos válidos';

  @override
  String get resultadosSeats => 'Vagas';

  @override
  String get resultadosQuotient => 'Quociente eleitoral';

  @override
  String get resultadosTotalized => 'Seções totalizadas';

  @override
  String get resultadosBlankNull => 'Brancos e nulos';

  @override
  String resultadosSource(String when) {
    return 'TSE · resultado do cargo (EA20), gerado em $when';
  }

  @override
  String get resultadosSeatsPlate => 'Vagas por partido ou federação';

  @override
  String get resultadosSeatsSource =>
      'TSE · vagas publicadas; Urna Aberta · distribuição refeita a partir dos votos';

  @override
  String get resultadosCheckMatches => 'Nossa conta confere com a do TSE';

  @override
  String resultadosCheckDiffers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nossa conta difere da do TSE em $count pontos',
      one: 'Nossa conta difere da do TSE em 1 ponto',
    );
    return '$_temp0';
  }

  @override
  String get resultadosCheckNote =>
      'A Urna Aberta refez a distribuição das vagas com os votos deste arquivo, pelas regras do Código Eleitoral (arts. 106 a 109) e da Resolução TSE 23.677, e comparou o quociente eleitoral, as vagas de cada partido ou federação e os eleitos com os publicados pelo TSE.';

  @override
  String get resultadosColList => 'Partido ou federação';

  @override
  String get resultadosColVotes => 'Votos';

  @override
  String get resultadosColQp => 'QP';

  @override
  String get resultadosColSeats => 'Vagas';

  @override
  String resultadosOurSeats(int count) {
    return 'nossa conta: $count';
  }

  @override
  String resultadosQpUnfilled(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count vagas do QP sem candidato com 10% do quociente: foram para as sobras',
      one:
          '1 vaga do QP sem candidato com 10% do quociente: foi para as sobras',
    );
    return '$_temp0';
  }

  @override
  String get resultadosKindFederation => 'Federação';

  @override
  String get resultadosKindCoalition => 'Coligação';

  @override
  String get resultadosCandidatesPlate => 'Candidaturas';

  @override
  String get resultadosCandidatesSource =>
      'TSE · votos e situação de cada candidatura';

  @override
  String get resultadosSearch => 'Buscar por nome, número ou partido';

  @override
  String resultadosShowMore(int count) {
    return 'Mostrar mais $count';
  }

  @override
  String get resultadosNoMatch => 'Nenhuma candidatura encontrada.';

  @override
  String resultadosOurSeatDiffers(String how) {
    return 'nossa conta: $how';
  }

  @override
  String get resultadosNotElectedByUs => 'não eleito';

  @override
  String resultadosOfValid(String percent) {
    return '$percent dos válidos';
  }

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
  String get entendaPausePara1 =>
      'Na noite de 4 de outubro de 2026, por volta das 19h14 (horário de Brasília), a visualização nacional (\"Brasil\") dos resultados para presidente parou de ser atualizada, quando 64,81% dos dados haviam sido divulgados. A geração desses arquivos foi restabelecida às 20h04, cerca de 50 minutos depois.';

  @override
  String get entendaPausePara2 =>
      'Segundo o TSE, uma contenção no processamento de dados, depois de um aumento no volume de dados, paralisou o módulo que gera os arquivos de divulgação da visualização \"Brasil\". A visualização estadual não foi afetada: os arquivos de cada estado, que também trazem os votos para presidente, continuaram a ser publicados sem interrupção.';

  @override
  String get entendaPauseCallout =>
      'Apuração é a contagem feita por cada urna. Totalização é a soma dessas contagens. Divulgação é a publicação na internet. O que parou foi a divulgação nacional.';

  @override
  String get entendaPausePara3 =>
      'Quem somava os arquivos por UF durante a pausa via a contagem seguir. É isso que a tela Apuração mostra no replay, com a pausa no mesmo horário. A evolução dos estados durante a pausa é uma curva sintética: a Urna Aberta guardou apenas os arquivos finais daquela noite.';

  @override
  String get entendaSources => 'Fontes';

  @override
  String get entendaSourceDivulgacao =>
      'TSE · Informações técnicas sobre a divulgação de resultados';

  @override
  String get entendaCh1Para1 =>
      'A votação vai das 8h às 17h, no horário de Brasília. A seção só é encerrada depois que todos os eleitores que receberam senha terminam de votar. Então a urna eletrônica apura os votos da seção e imprime o Boletim de Urna (BU).';

  @override
  String get entendaCh1Para2 =>
      'O presidente da mesa assina as vias do BU com os demais mesários e com os fiscais presentes, e afixa uma cópia assinada em local visível da seção. O BU, o Registro Digital do Voto e os demais arquivos da urna são gerados e assinados digitalmente.';

  @override
  String get entendaCh1Para3 =>
      'A urna não tem conexão com a internet nem com outras redes. A mídia de resultado, um dispositivo removível com os dados da votação, é retirada da urna e levada à Justiça Eleitoral, ou os arquivos são enviados do próprio local de votação pelo JE-Connect, por uma rede privada. Antes de somar, os sistemas da Justiça Eleitoral conferem a assinatura digital e a integridade de cada arquivo.';

  @override
  String get entendaCh1Callout =>
      'Apuração é a contagem feita por cada urna. Totalização é a soma das apurações de todas as urnas do país e do exterior. Divulgação é a última etapa: a publicação no Portal Resultados.';

  @override
  String get entendaCh1Para4 =>
      'As três etapas acontecem em sequência, e os resultados são divulgados à medida que os boletins chegam. Por isso uma pausa na divulgação, como a de 4 de outubro, não interrompe a apuração nem a totalização (capítulo 6).';

  @override
  String get entendaCh2Para1 =>
      'O Boletim de Urna é o resultado impresso de uma seção. Ele identifica o município, a zona, a seção e a urna, e traz a quantidade de eleitores aptos e de eleitores que compareceram, os votos de cada candidato e de cada partido, os votos brancos e nulos e a soma geral.';

  @override
  String get entendaCh2Para2 =>
      'São impressas cinco vias obrigatórias e até cinco adicionais. Uma é afixada no local de votação, outra fica com o presidente da seção, e fiscais de partidos podem receber uma via.';

  @override
  String get entendaCh2Para3 =>
      'O BU impresso traz QR Codes com os dados da votação. Qualquer cidadão ou entidade fiscalizadora pode lê-los com os aplicativos Boletim na Mão ou e-Título e comparar com o resultado da mesma seção divulgado pelo TSE.';

  @override
  String get entendaCh2Para4 =>
      'O TSE publica na internet os boletins enviados para totalização. Os arquivos espelham os boletins impressos, sem o processamento do sistema de totalização. É esse arquivo que a tela Minha seção busca para a sua seção.';

  @override
  String get entendaCh3Para1 =>
      'Cada urna grava, além do boletim, outros arquivos. O TSE disponibiliza no Portal Resultados o boletim de urna, o Registro Digital do Voto (RDV) e o log da urna, que podem ser baixados para consulta e auditoria. O portal de dados abertos traz os mesmos arquivos de todas as seções, por UF.';

  @override
  String get entendaCh3Para2 =>
      'O RDV é o arquivo em que os votos são registrados, separados por cargo e gravados em posições aleatórias. Não há como ligar um voto do RDV a um eleitor. O BU é gerado a partir dele, e o RDV permite que partidos recontem os votos da urna a qualquer tempo.';

  @override
  String get entendaCh3Para3 =>
      'O log é o registro cronológico das principais operações do software da urna: início e fim da votação, relatórios emitidos, aplicativos executados, ajustes de relógio e procedimentos de contingência.';

  @override
  String get entendaCh3Para4 =>
      'Para cada seção, o TSE publica também um arquivo auxiliar com a lista dos hashes dos arquivos de urna recebidos e a situação de cada um (recebido, rejeitado, excluído ou totalizado). A tela Minha seção usa essa lista.';

  @override
  String get entendaCh4Para1 =>
      'Um hash é uma pequena sequência de caracteres calculada a partir de um arquivo e que o identifica de forma inequívoca. Por menor que seja a diferença entre dois arquivos, os hashes são completamente diferentes.';

  @override
  String get entendaCh4Para2 =>
      'Uma assinatura digital usa um par de chaves: a chave privada, conhecida só por quem assina, e a chave pública, que pode ser distribuída a todos. Quem tem a chave pública confere que o arquivo veio de quem assinou e não foi alterado.';

  @override
  String get entendaCh4Para3 =>
      'A urna assina tudo o que sai dela: boletim, RDV e log. Os arquivos de resultado da divulgação vêm em pares JSON e JWS; o JWS traz os mesmos dados com uma assinatura digital do TSE, no algoritmo EdDSA com chave Ed25519. O manual do TSE pede que a chave pública não seja tirada do próprio arquivo verificado.';

  @override
  String get entendaCh4Callout =>
      'A Urna Aberta confere três coisas: a assinatura do TSE em cada arquivo de resultado (tela Verificar), o hash do boletim da sua seção contra a lista de arquivos da urna e a assinatura da própria urna sobre essa lista (tela Minha seção).';

  @override
  String get entendaCh4Para4 =>
      'Nas urnas modelo 2020 e 2022, essa assinatura usa EdDSA na curva E-521, como descreve o manual do QR Code do TSE. A Urna Aberta confere a assinatura com a chave do certificado da urna e confere que esse certificado foi emitido pela autoridade certificadora de urnas do TSE, cuja chave fica fixada no código. Urnas de modelos anteriores usam outro algoritmo, que a Urna Aberta não confere.';

  @override
  String get entendaCh5Para1 =>
      'O código-fonte da urna fica aberto às entidades fiscalizadoras um ano antes de cada eleição. Para 2026, a abertura foi em 2 de outubro de 2025. Podem fiscalizar, entre outros, partidos, federações e coligações, OAB, Ministério Público, Defensoria Pública, Congresso Nacional, CGU, Polícia Federal e TCU.';

  @override
  String get entendaCh5Para2 =>
      'No Teste Público de Segurança, investigadores inscritos tentam atacar os sistemas eleitorais. A edição para 2026 começou em 1º de dezembro de 2025, com 38 planos de teste. No Teste de Confirmação, em maio de 2026, o TSE concluiu que nenhum achado fragilizou o sigilo ou a integridade do voto.';

  @override
  String get entendaCh5Para3 =>
      'Em 4 de setembro de 2026, na Cerimônia de Assinatura Digital e Lacração, os sistemas foram assinados digitalmente pelo TSE e por representantes das entidades fiscalizadoras, e as mídias foram lacradas e guardadas na sala-cofre do TSE.';

  @override
  String get entendaCh5Para4 =>
      'No dia da eleição, o Teste de Integridade usa urnas sorteadas na véspera: entre 8h e 17h, cédulas de papel preenchidas por voluntários são digitadas uma a uma, com filmagem e acesso público, e o resultado da urna é comparado com as cédulas. Em 2026 houve também a versão com biometria de eleitores voluntários.';

  @override
  String get entendaCh5Para5 =>
      'Depois da totalização, as entidades fiscalizadoras podem pedir os boletins, os RDVs e os logs das urnas e os registros dos sistemas de totalização.';

  @override
  String get entendaCh7Para1 =>
      'A Urna Aberta lê os mesmos arquivos que o TSE publica e mostra de onde vem cada número, com o código do arquivo.';

  @override
  String get entendaCh7ProvesTitle => 'O que ela prova';

  @override
  String get entendaCh7Para2 =>
      'Que os arquivos de resultado foram assinados pelo TSE e não foram alterados depois (assinatura EdDSA conferida com a chave oficial, no servidor e, se você pedir, no seu aparelho). Que a soma independente dos estados e do exterior bate, ou não, com o arquivo nacional. Que o boletim publicado da sua seção é exatamente o arquivo que a urna listou, e que essa lista foi assinada por uma urna com certificado emitido pelo TSE (urnas modelo 2020 e 2022).';

  @override
  String get entendaCh7NotTitle => 'O que ela não prova';

  @override
  String get entendaCh7Para3 =>
      'Nada sobre o funcionamento da urna, o software dela ou se cada voto foi registrado como o eleitor quis: isso é o papel dos protocolos do capítulo 5. Ela não confere que o boletim publicado é igual ao impresso: essa comparação é sua, com o boletim afixado ou o Boletim na Mão.';

  @override
  String get entendaCh7Para4 =>
      'Partes marcadas como simulação, como a evolução dos estados no replay da noite de 4 de outubro, são curvas sintéticas e não dados oficiais.';

  @override
  String get entendaSourceTotalizacao2026 =>
      'TSE · Saiba como foi a totalização dos votos no 1º turno das Eleições 2026';

  @override
  String get entendaSourceApuracaoTotalizacao =>
      'TSE · Entenda a diferença entre apuração e totalização de votos';

  @override
  String get entendaSourceCaminhoDoVoto =>
      'TSE · Veja qual é o caminho do voto depois de encerrada a votação';

  @override
  String get entendaSourceRes23751 =>
      'TSE · Resolução nº 23.751/2026 (atos gerais do processo eleitoral)';

  @override
  String get entendaSourceBoletimDuvidas =>
      'TSE · Você já ouviu falar do Boletim de Urna? Tire suas dúvidas';

  @override
  String get entendaSourceDadosAbertosResultados =>
      'TSE · Portal de Dados Abertos: Resultados';

  @override
  String get entendaSourceVotacaoSegura => 'TSE · Votação segura';

  @override
  String get entendaSourceRes23673 =>
      'TSE · Resolução nº 23.673/2021 (fiscalização e auditoria)';

  @override
  String get entendaSourceMitosVerdades =>
      'TSE · Segurança das eleições informatizadas: mitos e verdades';

  @override
  String get entendaSourceAcompanharResultados =>
      'TSE · Terminada a votação, saiba como acompanhar os resultados';

  @override
  String get entendaSourceEa18 => 'TSE · EA18: arquivo auxiliar de seção';

  @override
  String get entendaSourceAssinaturaResumo =>
      'TSE · Assinatura digital e resumos digitais trazem mais segurança à urna';

  @override
  String get entendaSourceManualJws =>
      'TSE · Manual de verificação dos arquivos JWS';

  @override
  String get entendaSourceManualQr =>
      'TSE · Manual do QR Code no Boletim de Urna';

  @override
  String get entendaSourceCodigoFonte =>
      'TSE · Códigos-fonte dos sistemas eleitorais continuam abertos para inspeção';

  @override
  String get entendaSourceTps2025 =>
      'TSE · Teste da Urna 2025 começa na segunda (1º)';

  @override
  String get entendaSourceTesteConfirmacao =>
      'TSE · Testes confirmam, mais uma vez, a segurança do sistema eleitoral';

  @override
  String get entendaSourceLacracao2026 =>
      'TSE · Sistemas das Eleições 2026 são assinados digitalmente e lacrados';

  @override
  String get entendaSourceTesteIntegridade =>
      'TSE · Como funciona o Teste de Integridade';

  @override
  String get entendaSourceTesteIntegridade2026 =>
      'TSE · Teste de Integridade confirma correspondência entre cédulas e votos';

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
  String get secaoUrnaSignatureValid => 'Assinatura da urna confere';

  @override
  String get secaoUrnaSignatureInvalid => 'Assinatura da urna não confere';

  @override
  String get secaoUrnaSignatureUnchecked => 'Assinatura não conferida';

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
      'o boletim publicado é exatamente o arquivo que a urna listou, e essa lista foi assinada por uma urna com certificado emitido pelo TSE. ';

  @override
  String get secaoNotYetLabel => 'O que não prova: ';

  @override
  String get secaoNotYet =>
      'nada sobre a urna em si. A assinatura mostra de onde veio o arquivo, não como a urna funcionou.';

  @override
  String get secaoProvesHashOnly =>
      'o boletim publicado é exatamente o arquivo que a urna listou na sua lista de arquivos. ';

  @override
  String get secaoSignatureInvalidNote =>
      'A assinatura não confere: esta lista de arquivos não veio de uma urna certificada pelo TSE, ou foi alterada depois. Não confie nestes números; compare com o boletim impresso.';

  @override
  String get secaoSignatureUncheckedNote =>
      'Este modelo de urna usa um algoritmo de assinatura que a Urna Aberta não confere. Só os hashes foram conferidos.';

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
      'Os arquivos de cada urna (boletim de urna) têm outra assinatura, a da própria urna, conferida em Minha seção.';

  @override
  String get verificarLoadError =>
      'Não foi possível falar com o servidor da Urna Aberta.';

  @override
  String get verificarRetry => 'Tentar de novo';

  @override
  String get apuracaoModeLive => 'Ao vivo';

  @override
  String get apuracaoModeReplay => 'Reprise do 1º turno';

  @override
  String apuracaoLiveLede(int round) {
    return 'Presidente, $roundº turno, ao vivo. O arquivo nacional do TSE e a soma dos arquivos de cada estado, lado a lado. Os números se atualizam a cada 30 segundos.';
  }

  @override
  String apuracaoLiveEndedLede(int round) {
    return 'Presidente, $roundº turno. Os últimos arquivos do TSE guardados pela Urna Aberta durante a apuração.';
  }

  @override
  String apuracaoLiveSoon(int round, String date) {
    return 'A apuração ao vivo do $roundº turno começa em $date, às 17h (Brasília). Enquanto isso, reveja o 1º turno.';
  }

  @override
  String apuracaoLiveWaiting(int round) {
    return 'As urnas do $roundº turno fecharam. Aguardando os primeiros arquivos do TSE; enquanto isso, reveja o 1º turno.';
  }

  @override
  String apuracaoLiveStale(String time) {
    return 'Sem conexão com o servidor: estes são os números de $time.';
  }

  @override
  String apuracaoLiveTimelineTitle(int round) {
    return 'A apuração do $roundº turno';
  }

  @override
  String get apuracaoLiveTimelineSource =>
      'Cada ponto é um momento em que um arquivo do TSE mudou, guardado pela Urna Aberta com a assinatura conferida.';

  @override
  String get apuracaoLiveNoNational => 'ainda sem arquivo';

  @override
  String get atlasLive => 'Ao vivo';

  @override
  String get entendaPausePara2b =>
      'O TSE informa ainda que, durante a pausa, os boletins de urna continuaram a ser transmitidos, recebidos e publicados, e que o cálculo da totalização seguiu normalmente, exceto por um breve momento em que foi suspenso pelo protocolo de segurança.';

  @override
  String get entendaSourceFatoOuBoato =>
      'TSE · Fato ou Boato: É falso que a interrupção na divulgação dos resultados tenha fraudado o resultado do 1º turno para presidente (06/10/2026)';
}
