import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @atlasPlate.
  ///
  /// In pt, this message translates to:
  /// **'Prancha {number}'**
  String atlasPlate(int number);

  /// No description provided for @atlasFile.
  ///
  /// In pt, this message translates to:
  /// **'Arquivo {code}'**
  String atlasFile(String code);

  /// No description provided for @atlasOpenFile.
  ///
  /// In pt, this message translates to:
  /// **'Abrir arquivo {code}'**
  String atlasOpenFile(String code);

  /// No description provided for @atlasSimulation.
  ///
  /// In pt, this message translates to:
  /// **'Simulação'**
  String get atlasSimulation;

  /// No description provided for @atlasSimulationSemantics.
  ///
  /// In pt, this message translates to:
  /// **'{label}: dados não oficiais'**
  String atlasSimulationSemantics(String label);

  /// No description provided for @atlasSignatureValid.
  ///
  /// In pt, this message translates to:
  /// **'Assinatura válida'**
  String get atlasSignatureValid;

  /// No description provided for @atlasSignatureInvalid.
  ///
  /// In pt, this message translates to:
  /// **'Assinatura inválida'**
  String get atlasSignatureInvalid;

  /// No description provided for @atlasNotVerified.
  ///
  /// In pt, this message translates to:
  /// **'Não verificado'**
  String get atlasNotVerified;

  /// No description provided for @atlasLearnWhy.
  ///
  /// In pt, this message translates to:
  /// **'Entenda por quê'**
  String get atlasLearnWhy;

  /// No description provided for @atlasDivergenceTitle.
  ///
  /// In pt, this message translates to:
  /// **'A divulgação nacional está atrás dos estados.'**
  String get atlasDivergenceTitle;

  /// No description provided for @atlasDivergenceBody.
  ///
  /// In pt, this message translates to:
  /// **'A contagem continua: os arquivos por UF seguem sendo atualizados.'**
  String get atlasDivergenceBody;

  /// No description provided for @atlasCopyHash.
  ///
  /// In pt, this message translates to:
  /// **'Copiar hash'**
  String get atlasCopyHash;

  /// No description provided for @atlasHashCopied.
  ///
  /// In pt, this message translates to:
  /// **'Hash copiado'**
  String get atlasHashCopied;

  /// No description provided for @replayPause.
  ///
  /// In pt, this message translates to:
  /// **'Pausar replay'**
  String get replayPause;

  /// No description provided for @replayPlay.
  ///
  /// In pt, this message translates to:
  /// **'Reproduzir replay'**
  String get replayPlay;

  /// No description provided for @replayClock.
  ///
  /// In pt, this message translates to:
  /// **'Relógio do replay {clock}'**
  String replayClock(String clock);

  /// No description provided for @replayJumpToFreeze.
  ///
  /// In pt, this message translates to:
  /// **'Ir para a pausa'**
  String get replayJumpToFreeze;

  /// No description provided for @replaySimulated.
  ///
  /// In pt, this message translates to:
  /// **'Replay simulado'**
  String get replaySimulated;

  /// No description provided for @mapTitle.
  ///
  /// In pt, this message translates to:
  /// **'Seções totalizadas por UF'**
  String get mapTitle;

  /// No description provided for @mapSimulationAt.
  ///
  /// In pt, this message translates to:
  /// **'Simulação · {moment}'**
  String mapSimulationAt(String moment);

  /// No description provided for @mapSource.
  ///
  /// In pt, this message translates to:
  /// **'Malhas: IBGE. Dados: TSE, EA20 por UF. Escala aproximada.'**
  String get mapSource;

  /// No description provided for @mapLayerRegions.
  ///
  /// In pt, this message translates to:
  /// **'Regiões'**
  String get mapLayerRegions;

  /// No description provided for @mapLayerCounted.
  ///
  /// In pt, this message translates to:
  /// **'Seções totalizadas'**
  String get mapLayerCounted;

  /// No description provided for @mapShowMap.
  ///
  /// In pt, this message translates to:
  /// **'Ver mapa'**
  String get mapShowMap;

  /// No description provided for @mapShowTable.
  ///
  /// In pt, this message translates to:
  /// **'Ver em tabela'**
  String get mapShowTable;

  /// No description provided for @mapClearSelection.
  ///
  /// In pt, this message translates to:
  /// **'Limpar seleção'**
  String get mapClearSelection;

  /// No description provided for @mapUfCount.
  ///
  /// In pt, this message translates to:
  /// **'{count} UF'**
  String mapUfCount(int count);

  /// No description provided for @mapUfUpdated.
  ///
  /// In pt, this message translates to:
  /// **'{region} · atualizado {moment}'**
  String mapUfUpdated(String region, String moment);

  /// No description provided for @mapCountedCaption.
  ///
  /// In pt, this message translates to:
  /// **'seções totalizadas'**
  String get mapCountedCaption;

  /// No description provided for @mapHint.
  ///
  /// In pt, this message translates to:
  /// **'Toque em um estado ou em uma chave da legenda.'**
  String get mapHint;

  /// No description provided for @mapNoUfInBand.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma UF nesta faixa'**
  String get mapNoUfInBand;

  /// No description provided for @mapAverageCaption.
  ///
  /// In pt, this message translates to:
  /// **'média simples das UFs'**
  String get mapAverageCaption;

  /// No description provided for @mapColumnRegion.
  ///
  /// In pt, this message translates to:
  /// **'Região'**
  String get mapColumnRegion;

  /// No description provided for @mapColumnCounted.
  ///
  /// In pt, this message translates to:
  /// **'% seções totalizadas'**
  String get mapColumnCounted;

  /// No description provided for @mapColumnFile.
  ///
  /// In pt, this message translates to:
  /// **'Arquivo'**
  String get mapColumnFile;

  /// No description provided for @mapLongitudeWest.
  ///
  /// In pt, this message translates to:
  /// **'{degrees}°O'**
  String mapLongitudeWest(int degrees);

  /// No description provided for @mapLatitudeSouth.
  ///
  /// In pt, this message translates to:
  /// **'{degrees}°S'**
  String mapLatitudeSouth(int degrees);

  /// No description provided for @mapTropic.
  ///
  /// In pt, this message translates to:
  /// **'Trópico de Capricórnio'**
  String get mapTropic;

  /// No description provided for @mapEquator.
  ///
  /// In pt, this message translates to:
  /// **'Equador'**
  String get mapEquator;

  /// No description provided for @mapUfSemantics.
  ///
  /// In pt, this message translates to:
  /// **'{uf}, {region}, {pct} das seções totalizadas'**
  String mapUfSemantics(String uf, String region, String pct);

  /// No description provided for @chartNationalFileTse.
  ///
  /// In pt, this message translates to:
  /// **'Arquivo nacional do TSE'**
  String get chartNationalFileTse;

  /// No description provided for @chartNationalFile.
  ///
  /// In pt, this message translates to:
  /// **'Arquivo nacional'**
  String get chartNationalFile;

  /// No description provided for @chartStatesSum.
  ///
  /// In pt, this message translates to:
  /// **'Soma dos estados'**
  String get chartStatesSum;

  /// No description provided for @chartDuoSemantics.
  ///
  /// In pt, this message translates to:
  /// **'Arquivo nacional do TSE {national} por cento; soma dos estados {states} por cento'**
  String chartDuoSemantics(String national, String states);

  /// No description provided for @chartDifference.
  ///
  /// In pt, this message translates to:
  /// **'Diferença: '**
  String get chartDifference;

  /// No description provided for @chartPoints.
  ///
  /// In pt, this message translates to:
  /// **'{value} p.p.'**
  String chartPoints(String value);

  /// No description provided for @chartDifferenceOf.
  ///
  /// In pt, this message translates to:
  /// **' de seções totalizadas'**
  String get chartDifferenceOf;

  /// No description provided for @chartVotesSemantics.
  ///
  /// In pt, this message translates to:
  /// **'Votos por candidatura nas duas fontes'**
  String get chartVotesSemantics;

  /// No description provided for @chartRowSemantics.
  ///
  /// In pt, this message translates to:
  /// **'{label}: {national} no arquivo nacional, {states} na soma dos estados'**
  String chartRowSemantics(String label, String national, String states);

  /// No description provided for @chartTimelineSemantics.
  ///
  /// In pt, this message translates to:
  /// **'Linha do tempo das duas fontes. Use as setas para explorar.'**
  String get chartTimelineSemantics;

  /// No description provided for @chartTimelinePointSemantics.
  ///
  /// In pt, this message translates to:
  /// **'{time}: arquivo nacional {national}, soma dos estados {states}'**
  String chartTimelinePointSemantics(
    String time,
    String national,
    String states,
  );

  /// No description provided for @chartNationalFrozenSuffix.
  ///
  /// In pt, this message translates to:
  /// **' · nacional parado'**
  String get chartNationalFrozenSuffix;

  /// No description provided for @chartFreezeBand.
  ///
  /// In pt, this message translates to:
  /// **'Nacional parado · {minutes} min'**
  String chartFreezeBand(int minutes);

  /// No description provided for @chartHourTick.
  ///
  /// In pt, this message translates to:
  /// **'{hour}h'**
  String chartHourTick(int hour);

  /// No description provided for @chartUfSemantics.
  ///
  /// In pt, this message translates to:
  /// **'{uf}: {pct} das seções totalizadas'**
  String chartUfSemantics(String uf, String pct);

  /// No description provided for @apuracaoHeadline.
  ///
  /// In pt, this message translates to:
  /// **'A contagem não parou.'**
  String get apuracaoHeadline;

  /// No description provided for @apuracaoLede.
  ///
  /// In pt, this message translates to:
  /// **'Presidente, 1º turno. O arquivo nacional do TSE e a soma dos arquivos de cada estado, lado a lado. Cada número leva ao arquivo de onde veio.'**
  String get apuracaoLede;

  /// No description provided for @apuracaoDesignSystem.
  ///
  /// In pt, this message translates to:
  /// **'Sistema de design'**
  String get apuracaoDesignSystem;

  /// No description provided for @apuracaoDuoTitle.
  ///
  /// In pt, this message translates to:
  /// **'Comparação das duas fontes · Presidente'**
  String get apuracaoDuoTitle;

  /// No description provided for @apuracaoDuoSource.
  ///
  /// In pt, this message translates to:
  /// **'% de seções totalizadas. Fonte: TSE. Soma calculada pela Urna Aberta.'**
  String get apuracaoDuoSource;

  /// No description provided for @apuracaoFrozenSince.
  ///
  /// In pt, this message translates to:
  /// **'parado desde {time}'**
  String apuracaoFrozenSince(String time);

  /// No description provided for @apuracaoUpdatedAt.
  ///
  /// In pt, this message translates to:
  /// **'atualizado {time}'**
  String apuracaoUpdatedAt(String time);

  /// No description provided for @apuracaoVotesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Votos por candidatura, nas duas fontes'**
  String get apuracaoVotesTitle;

  /// No description provided for @apuracaoVotesSourceSynthetic.
  ///
  /// In pt, this message translates to:
  /// **'Mesma tinta para todas as candidaturas. Votos intermediários proporcionais aos arquivos finais do TSE.'**
  String get apuracaoVotesSourceSynthetic;

  /// No description provided for @apuracaoVotesSource.
  ///
  /// In pt, this message translates to:
  /// **'Mesma tinta para todas as candidaturas. Fonte: TSE.'**
  String get apuracaoVotesSource;

  /// No description provided for @apuracaoTimelineTitle.
  ///
  /// In pt, this message translates to:
  /// **'A noite de 4 de outubro'**
  String get apuracaoTimelineTitle;

  /// No description provided for @apuracaoTimelineSource.
  ///
  /// In pt, this message translates to:
  /// **'Curva sintética que termina nos arquivos finais reais do TSE. A pausa nacional em {pct}, das 19h14 às 20h04, segue o horário informado pelo TSE.'**
  String apuracaoTimelineSource(String pct);

  /// No description provided for @apuracaoCandidateNumber.
  ///
  /// In pt, this message translates to:
  /// **'Número {number}'**
  String apuracaoCandidateNumber(int number);

  /// No description provided for @apuracaoReplayUnavailable.
  ///
  /// In pt, this message translates to:
  /// **'Os arquivos do 1º turno ainda não foram carregados no servidor.'**
  String get apuracaoReplayUnavailable;

  /// No description provided for @apuracaoServerUnreachable.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível falar com o servidor da Urna Aberta.'**
  String get apuracaoServerUnreachable;

  /// No description provided for @apuracaoRetry.
  ///
  /// In pt, this message translates to:
  /// **'Tentar de novo'**
  String get apuracaoRetry;

  /// No description provided for @navApuracao.
  ///
  /// In pt, this message translates to:
  /// **'Apuração'**
  String get navApuracao;

  /// No description provided for @navSecao.
  ///
  /// In pt, this message translates to:
  /// **'Minha seção'**
  String get navSecao;

  /// No description provided for @navVerificar.
  ///
  /// In pt, this message translates to:
  /// **'Verificar'**
  String get navVerificar;

  /// No description provided for @navEntenda.
  ///
  /// In pt, this message translates to:
  /// **'Entenda'**
  String get navEntenda;

  /// No description provided for @themeLight.
  ///
  /// In pt, this message translates to:
  /// **'Claro'**
  String get themeLight;

  /// No description provided for @themeSystem.
  ///
  /// In pt, this message translates to:
  /// **'Sistema'**
  String get themeSystem;

  /// No description provided for @themeDark.
  ///
  /// In pt, this message translates to:
  /// **'Escuro'**
  String get themeDark;

  /// No description provided for @language.
  ///
  /// In pt, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @languageDevice.
  ///
  /// In pt, this message translates to:
  /// **'Do aparelho'**
  String get languageDevice;

  /// No description provided for @languagePortuguese.
  ///
  /// In pt, this message translates to:
  /// **'Português'**
  String get languagePortuguese;

  /// No description provided for @languageEnglish.
  ///
  /// In pt, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @entendaTitle.
  ///
  /// In pt, this message translates to:
  /// **'Entenda o processo'**
  String get entendaTitle;

  /// No description provided for @entendaLede.
  ///
  /// In pt, this message translates to:
  /// **'Capítulos curtos sobre como o resultado sai da urna e chega até você. Cada afirmação cita uma fonte oficial do TSE.'**
  String get entendaLede;

  /// No description provided for @entendaCh1Title.
  ///
  /// In pt, this message translates to:
  /// **'O caminho do voto'**
  String get entendaCh1Title;

  /// No description provided for @entendaCh1Summary.
  ///
  /// In pt, this message translates to:
  /// **'Da urna ao boletim afixado, da transmissão à divulgação.'**
  String get entendaCh1Summary;

  /// No description provided for @entendaCh2Title.
  ///
  /// In pt, this message translates to:
  /// **'O Boletim de Urna'**
  String get entendaCh2Title;

  /// No description provided for @entendaCh2Summary.
  ///
  /// In pt, this message translates to:
  /// **'O que ele contém, por que é público e como conferir.'**
  String get entendaCh2Summary;

  /// No description provided for @entendaCh3Title.
  ///
  /// In pt, this message translates to:
  /// **'Os arquivos da urna'**
  String get entendaCh3Title;

  /// No description provided for @entendaCh3Summary.
  ///
  /// In pt, this message translates to:
  /// **'BU, RDV e log: para que serve cada um.'**
  String get entendaCh3Summary;

  /// No description provided for @entendaCh4Title.
  ///
  /// In pt, this message translates to:
  /// **'Assinaturas e hashes'**
  String get entendaCh4Title;

  /// No description provided for @entendaCh4Summary.
  ///
  /// In pt, this message translates to:
  /// **'O que as verificações deste app realmente checam.'**
  String get entendaCh4Summary;

  /// No description provided for @entendaCh5Title.
  ///
  /// In pt, this message translates to:
  /// **'Protocolos de segurança'**
  String get entendaCh5Title;

  /// No description provided for @entendaCh5Summary.
  ///
  /// In pt, this message translates to:
  /// **'Testes públicos, cerimônias e inspeção do código.'**
  String get entendaCh5Summary;

  /// No description provided for @entendaCh6Title.
  ///
  /// In pt, this message translates to:
  /// **'4 de outubro de 2026'**
  String get entendaCh6Title;

  /// No description provided for @entendaCh6Summary.
  ///
  /// In pt, this message translates to:
  /// **'O que parou, o que não parou, e como o replay mostra isso.'**
  String get entendaCh6Summary;

  /// No description provided for @entendaCh7Title.
  ///
  /// In pt, this message translates to:
  /// **'O que este app prova'**
  String get entendaCh7Title;

  /// No description provided for @entendaCh7Summary.
  ///
  /// In pt, this message translates to:
  /// **'E, com a mesma clareza, o que ele não prova.'**
  String get entendaCh7Summary;

  /// No description provided for @entendaChapterLabel.
  ///
  /// In pt, this message translates to:
  /// **'Capítulo {number}'**
  String entendaChapterLabel(int number);

  /// No description provided for @entendaPausePara1.
  ///
  /// In pt, this message translates to:
  /// **'Na noite de 4 de outubro de 2026, por volta das 19h14 (horário de Brasília), a visualização nacional (\"Brasil\") dos resultados para presidente parou de ser atualizada, quando 64,81% dos dados haviam sido divulgados. A geração desses arquivos foi restabelecida às 20h04, cerca de 50 minutos depois.'**
  String get entendaPausePara1;

  /// No description provided for @entendaPausePara2.
  ///
  /// In pt, this message translates to:
  /// **'Segundo o TSE, uma contenção no processamento de dados, depois de um aumento no volume de dados, paralisou o módulo que gera os arquivos de divulgação da visualização \"Brasil\". A visualização estadual não foi afetada: os arquivos de cada estado, que também trazem os votos para presidente, continuaram a ser publicados sem interrupção.'**
  String get entendaPausePara2;

  /// No description provided for @entendaPauseCallout.
  ///
  /// In pt, this message translates to:
  /// **'Apuração é a contagem feita por cada urna. Totalização é a soma dessas contagens. Divulgação é a publicação na internet. O que parou foi a divulgação nacional.'**
  String get entendaPauseCallout;

  /// No description provided for @entendaPausePara3.
  ///
  /// In pt, this message translates to:
  /// **'Quem somava os arquivos por UF durante a pausa via a contagem seguir. É isso que a tela Apuração mostra no replay, com a pausa no mesmo horário. A evolução dos estados durante a pausa é uma curva sintética: a Urna Aberta guardou apenas os arquivos finais daquela noite.'**
  String get entendaPausePara3;

  /// No description provided for @entendaSources.
  ///
  /// In pt, this message translates to:
  /// **'Fontes'**
  String get entendaSources;

  /// No description provided for @entendaSourceDivulgacao.
  ///
  /// In pt, this message translates to:
  /// **'TSE · Informações técnicas sobre a divulgação de resultados'**
  String get entendaSourceDivulgacao;

  /// No description provided for @entendaCh1Para1.
  ///
  /// In pt, this message translates to:
  /// **'A votação vai das 8h às 17h, no horário de Brasília. A seção só é encerrada depois que todos os eleitores que receberam senha terminam de votar. Então a urna eletrônica apura os votos da seção e imprime o Boletim de Urna (BU).'**
  String get entendaCh1Para1;

  /// No description provided for @entendaCh1Para2.
  ///
  /// In pt, this message translates to:
  /// **'O presidente da mesa assina as vias do BU com os demais mesários e com os fiscais presentes, e afixa uma cópia assinada em local visível da seção. O BU, o Registro Digital do Voto e os demais arquivos da urna são gerados e assinados digitalmente.'**
  String get entendaCh1Para2;

  /// No description provided for @entendaCh1Para3.
  ///
  /// In pt, this message translates to:
  /// **'A urna não tem conexão com a internet nem com outras redes. A mídia de resultado, um dispositivo removível com os dados da votação, é retirada da urna e levada à Justiça Eleitoral, ou os arquivos são enviados do próprio local de votação pelo JE-Connect, por uma rede privada. Antes de somar, os sistemas da Justiça Eleitoral conferem a assinatura digital e a integridade de cada arquivo.'**
  String get entendaCh1Para3;

  /// No description provided for @entendaCh1Callout.
  ///
  /// In pt, this message translates to:
  /// **'Apuração é a contagem feita por cada urna. Totalização é a soma das apurações de todas as urnas do país e do exterior. Divulgação é a última etapa: a publicação no Portal Resultados.'**
  String get entendaCh1Callout;

  /// No description provided for @entendaCh1Para4.
  ///
  /// In pt, this message translates to:
  /// **'As três etapas acontecem em sequência, e os resultados são divulgados à medida que os boletins chegam. Por isso uma pausa na divulgação, como a de 4 de outubro, não interrompe a apuração nem a totalização (capítulo 6).'**
  String get entendaCh1Para4;

  /// No description provided for @entendaCh2Para1.
  ///
  /// In pt, this message translates to:
  /// **'O Boletim de Urna é o resultado impresso de uma seção. Ele identifica o município, a zona, a seção e a urna, e traz a quantidade de eleitores aptos e de eleitores que compareceram, os votos de cada candidato e de cada partido, os votos brancos e nulos e a soma geral.'**
  String get entendaCh2Para1;

  /// No description provided for @entendaCh2Para2.
  ///
  /// In pt, this message translates to:
  /// **'São impressas cinco vias obrigatórias e até cinco adicionais. Uma é afixada no local de votação, outra fica com o presidente da seção, e fiscais de partidos podem receber uma via.'**
  String get entendaCh2Para2;

  /// No description provided for @entendaCh2Para3.
  ///
  /// In pt, this message translates to:
  /// **'O BU impresso traz QR Codes com os dados da votação. Qualquer cidadão ou entidade fiscalizadora pode lê-los com os aplicativos Boletim na Mão ou e-Título e comparar com o resultado da mesma seção divulgado pelo TSE.'**
  String get entendaCh2Para3;

  /// No description provided for @entendaCh2Para4.
  ///
  /// In pt, this message translates to:
  /// **'O TSE publica na internet os boletins enviados para totalização. Os arquivos espelham os boletins impressos, sem o processamento do sistema de totalização. É esse arquivo que a tela Minha seção busca para a sua seção.'**
  String get entendaCh2Para4;

  /// No description provided for @entendaCh3Para1.
  ///
  /// In pt, this message translates to:
  /// **'Cada urna grava, além do boletim, outros arquivos. O TSE disponibiliza no Portal Resultados o boletim de urna, o Registro Digital do Voto (RDV) e o log da urna, que podem ser baixados para consulta e auditoria. O portal de dados abertos traz os mesmos arquivos de todas as seções, por UF.'**
  String get entendaCh3Para1;

  /// No description provided for @entendaCh3Para2.
  ///
  /// In pt, this message translates to:
  /// **'O RDV é o arquivo em que os votos são registrados, separados por cargo e gravados em posições aleatórias. Não há como ligar um voto do RDV a um eleitor. O BU é gerado a partir dele, e o RDV permite que partidos recontem os votos da urna a qualquer tempo.'**
  String get entendaCh3Para2;

  /// No description provided for @entendaCh3Para3.
  ///
  /// In pt, this message translates to:
  /// **'O log é o registro cronológico das principais operações do software da urna: início e fim da votação, relatórios emitidos, aplicativos executados, ajustes de relógio e procedimentos de contingência.'**
  String get entendaCh3Para3;

  /// No description provided for @entendaCh3Para4.
  ///
  /// In pt, this message translates to:
  /// **'Para cada seção, o TSE publica também um arquivo auxiliar com a lista dos hashes dos arquivos de urna recebidos e a situação de cada um (recebido, rejeitado, excluído ou totalizado). A tela Minha seção usa essa lista.'**
  String get entendaCh3Para4;

  /// No description provided for @entendaCh4Para1.
  ///
  /// In pt, this message translates to:
  /// **'Um hash é uma pequena sequência de caracteres calculada a partir de um arquivo e que o identifica de forma inequívoca. Por menor que seja a diferença entre dois arquivos, os hashes são completamente diferentes.'**
  String get entendaCh4Para1;

  /// No description provided for @entendaCh4Para2.
  ///
  /// In pt, this message translates to:
  /// **'Uma assinatura digital usa um par de chaves: a chave privada, conhecida só por quem assina, e a chave pública, que pode ser distribuída a todos. Quem tem a chave pública confere que o arquivo veio de quem assinou e não foi alterado.'**
  String get entendaCh4Para2;

  /// No description provided for @entendaCh4Para3.
  ///
  /// In pt, this message translates to:
  /// **'A urna assina tudo o que sai dela: boletim, RDV e log. Os arquivos de resultado da divulgação vêm em pares JSON e JWS; o JWS traz os mesmos dados com uma assinatura digital do TSE, no algoritmo EdDSA com chave Ed25519. O manual do TSE pede que a chave pública não seja tirada do próprio arquivo verificado.'**
  String get entendaCh4Para3;

  /// No description provided for @entendaCh4Callout.
  ///
  /// In pt, this message translates to:
  /// **'A Urna Aberta confere duas coisas: a assinatura do TSE em cada arquivo de resultado (tela Verificar) e o hash do boletim da sua seção contra a lista do arquivo auxiliar (tela Minha seção).'**
  String get entendaCh4Callout;

  /// No description provided for @entendaCh4Para4.
  ///
  /// In pt, this message translates to:
  /// **'A assinatura da própria urna sobre o boletim ainda não é conferida pela Urna Aberta. Para isso, use o QR Code do boletim impresso com o aplicativo Boletim na Mão.'**
  String get entendaCh4Para4;

  /// No description provided for @entendaCh5Para1.
  ///
  /// In pt, this message translates to:
  /// **'O código-fonte da urna fica aberto às entidades fiscalizadoras um ano antes de cada eleição. Para 2026, a abertura foi em 2 de outubro de 2025. Podem fiscalizar, entre outros, partidos, federações e coligações, OAB, Ministério Público, Defensoria Pública, Congresso Nacional, CGU, Polícia Federal e TCU.'**
  String get entendaCh5Para1;

  /// No description provided for @entendaCh5Para2.
  ///
  /// In pt, this message translates to:
  /// **'No Teste Público de Segurança, investigadores inscritos tentam atacar os sistemas eleitorais. A edição para 2026 começou em 1º de dezembro de 2025, com 38 planos de teste. No Teste de Confirmação, em maio de 2026, o TSE concluiu que nenhum achado fragilizou o sigilo ou a integridade do voto.'**
  String get entendaCh5Para2;

  /// No description provided for @entendaCh5Para3.
  ///
  /// In pt, this message translates to:
  /// **'Em 4 de setembro de 2026, na Cerimônia de Assinatura Digital e Lacração, os sistemas foram assinados digitalmente pelo TSE e por representantes das entidades fiscalizadoras, e as mídias foram lacradas e guardadas na sala-cofre do TSE.'**
  String get entendaCh5Para3;

  /// No description provided for @entendaCh5Para4.
  ///
  /// In pt, this message translates to:
  /// **'No dia da eleição, o Teste de Integridade usa urnas sorteadas na véspera: entre 8h e 17h, cédulas de papel preenchidas por voluntários são digitadas uma a uma, com filmagem e acesso público, e o resultado da urna é comparado com as cédulas. Em 2026 houve também a versão com biometria de eleitores voluntários.'**
  String get entendaCh5Para4;

  /// No description provided for @entendaCh5Para5.
  ///
  /// In pt, this message translates to:
  /// **'Depois da totalização, as entidades fiscalizadoras podem pedir os boletins, os RDVs e os logs das urnas e os registros dos sistemas de totalização.'**
  String get entendaCh5Para5;

  /// No description provided for @entendaCh7Para1.
  ///
  /// In pt, this message translates to:
  /// **'A Urna Aberta lê os mesmos arquivos que o TSE publica e mostra de onde vem cada número, com o código do arquivo.'**
  String get entendaCh7Para1;

  /// No description provided for @entendaCh7ProvesTitle.
  ///
  /// In pt, this message translates to:
  /// **'O que ela prova'**
  String get entendaCh7ProvesTitle;

  /// No description provided for @entendaCh7Para2.
  ///
  /// In pt, this message translates to:
  /// **'Que os arquivos de resultado foram assinados pelo TSE e não foram alterados depois (assinatura EdDSA conferida com a chave oficial, no servidor e, se você pedir, no seu aparelho). Que a soma independente dos estados e do exterior bate, ou não, com o arquivo nacional. Que o boletim publicado da sua seção é exatamente o arquivo cujo hash consta da lista do arquivo auxiliar.'**
  String get entendaCh7Para2;

  /// No description provided for @entendaCh7NotTitle.
  ///
  /// In pt, this message translates to:
  /// **'O que ela não prova'**
  String get entendaCh7NotTitle;

  /// No description provided for @entendaCh7Para3.
  ///
  /// In pt, this message translates to:
  /// **'Nada sobre o funcionamento da urna, o software dela ou se cada voto foi registrado como o eleitor quis: isso é o papel dos protocolos do capítulo 5. Ela ainda não confere a assinatura da urna sobre o boletim, e não confere que o boletim publicado é igual ao impresso: essa comparação é sua, com o boletim afixado ou o Boletim na Mão.'**
  String get entendaCh7Para3;

  /// No description provided for @entendaCh7Para4.
  ///
  /// In pt, this message translates to:
  /// **'Partes marcadas como simulação, como a evolução dos estados no replay da noite de 4 de outubro, são curvas sintéticas e não dados oficiais.'**
  String get entendaCh7Para4;

  /// No description provided for @entendaSourceTotalizacao2026.
  ///
  /// In pt, this message translates to:
  /// **'TSE · Saiba como foi a totalização dos votos no 1º turno das Eleições 2026'**
  String get entendaSourceTotalizacao2026;

  /// No description provided for @entendaSourceApuracaoTotalizacao.
  ///
  /// In pt, this message translates to:
  /// **'TSE · Entenda a diferença entre apuração e totalização de votos'**
  String get entendaSourceApuracaoTotalizacao;

  /// No description provided for @entendaSourceCaminhoDoVoto.
  ///
  /// In pt, this message translates to:
  /// **'TSE · Veja qual é o caminho do voto depois de encerrada a votação'**
  String get entendaSourceCaminhoDoVoto;

  /// No description provided for @entendaSourceRes23751.
  ///
  /// In pt, this message translates to:
  /// **'TSE · Resolução nº 23.751/2026 (atos gerais do processo eleitoral)'**
  String get entendaSourceRes23751;

  /// No description provided for @entendaSourceBoletimDuvidas.
  ///
  /// In pt, this message translates to:
  /// **'TSE · Você já ouviu falar do Boletim de Urna? Tire suas dúvidas'**
  String get entendaSourceBoletimDuvidas;

  /// No description provided for @entendaSourceDadosAbertosResultados.
  ///
  /// In pt, this message translates to:
  /// **'TSE · Portal de Dados Abertos: Resultados'**
  String get entendaSourceDadosAbertosResultados;

  /// No description provided for @entendaSourceVotacaoSegura.
  ///
  /// In pt, this message translates to:
  /// **'TSE · Votação segura'**
  String get entendaSourceVotacaoSegura;

  /// No description provided for @entendaSourceRes23673.
  ///
  /// In pt, this message translates to:
  /// **'TSE · Resolução nº 23.673/2021 (fiscalização e auditoria)'**
  String get entendaSourceRes23673;

  /// No description provided for @entendaSourceMitosVerdades.
  ///
  /// In pt, this message translates to:
  /// **'TSE · Segurança das eleições informatizadas: mitos e verdades'**
  String get entendaSourceMitosVerdades;

  /// No description provided for @entendaSourceAcompanharResultados.
  ///
  /// In pt, this message translates to:
  /// **'TSE · Terminada a votação, saiba como acompanhar os resultados'**
  String get entendaSourceAcompanharResultados;

  /// No description provided for @entendaSourceEa18.
  ///
  /// In pt, this message translates to:
  /// **'TSE · EA18: arquivo auxiliar de seção'**
  String get entendaSourceEa18;

  /// No description provided for @entendaSourceAssinaturaResumo.
  ///
  /// In pt, this message translates to:
  /// **'TSE · Assinatura digital e resumos digitais trazem mais segurança à urna'**
  String get entendaSourceAssinaturaResumo;

  /// No description provided for @entendaSourceManualJws.
  ///
  /// In pt, this message translates to:
  /// **'TSE · Manual de verificação dos arquivos JWS'**
  String get entendaSourceManualJws;

  /// No description provided for @entendaSourceManualQr.
  ///
  /// In pt, this message translates to:
  /// **'TSE · Manual do QR Code no Boletim de Urna'**
  String get entendaSourceManualQr;

  /// No description provided for @entendaSourceCodigoFonte.
  ///
  /// In pt, this message translates to:
  /// **'TSE · Códigos-fonte dos sistemas eleitorais continuam abertos para inspeção'**
  String get entendaSourceCodigoFonte;

  /// No description provided for @entendaSourceTps2025.
  ///
  /// In pt, this message translates to:
  /// **'TSE · Teste da Urna 2025 começa na segunda (1º)'**
  String get entendaSourceTps2025;

  /// No description provided for @entendaSourceTesteConfirmacao.
  ///
  /// In pt, this message translates to:
  /// **'TSE · Testes confirmam, mais uma vez, a segurança do sistema eleitoral'**
  String get entendaSourceTesteConfirmacao;

  /// No description provided for @entendaSourceLacracao2026.
  ///
  /// In pt, this message translates to:
  /// **'TSE · Sistemas das Eleições 2026 são assinados digitalmente e lacrados'**
  String get entendaSourceLacracao2026;

  /// No description provided for @entendaSourceTesteIntegridade.
  ///
  /// In pt, this message translates to:
  /// **'TSE · Como funciona o Teste de Integridade'**
  String get entendaSourceTesteIntegridade;

  /// No description provided for @entendaSourceTesteIntegridade2026.
  ///
  /// In pt, this message translates to:
  /// **'TSE · Teste de Integridade confirma correspondência entre cédulas e votos'**
  String get entendaSourceTesteIntegridade2026;

  /// No description provided for @secaoTitle.
  ///
  /// In pt, this message translates to:
  /// **'Minha seção'**
  String get secaoTitle;

  /// No description provided for @secaoLede.
  ///
  /// In pt, this message translates to:
  /// **'Encontre o Boletim de Urna oficial da sua seção e compare com o boletim impresso e afixado no local de votação.'**
  String get secaoLede;

  /// No description provided for @secaoFieldUf.
  ///
  /// In pt, this message translates to:
  /// **'UF'**
  String get secaoFieldUf;

  /// No description provided for @secaoUfExterior.
  ///
  /// In pt, this message translates to:
  /// **'Exterior'**
  String get secaoUfExterior;

  /// No description provided for @secaoFieldMunicipio.
  ///
  /// In pt, this message translates to:
  /// **'Município'**
  String get secaoFieldMunicipio;

  /// No description provided for @secaoFieldZona.
  ///
  /// In pt, this message translates to:
  /// **'Zona'**
  String get secaoFieldZona;

  /// No description provided for @secaoFieldSecao.
  ///
  /// In pt, this message translates to:
  /// **'Seção'**
  String get secaoFieldSecao;

  /// No description provided for @secaoLoadingMunicipios.
  ///
  /// In pt, this message translates to:
  /// **'Carregando municípios…'**
  String get secaoLoadingMunicipios;

  /// No description provided for @secaoLoadingZonas.
  ///
  /// In pt, this message translates to:
  /// **'Carregando zonas…'**
  String get secaoLoadingZonas;

  /// No description provided for @secaoLoadingSecoes.
  ///
  /// In pt, this message translates to:
  /// **'Carregando seções…'**
  String get secaoLoadingSecoes;

  /// No description provided for @secaoLocatePlate.
  ///
  /// In pt, this message translates to:
  /// **'Localizar seção'**
  String get secaoLocatePlate;

  /// No description provided for @secaoFormHint.
  ///
  /// In pt, this message translates to:
  /// **'Zona e seção estão no seu título de eleitor ou no e-Título. A lista vem do arquivo de seções do TSE.'**
  String get secaoFormHint;

  /// No description provided for @secaoSearchButton.
  ///
  /// In pt, this message translates to:
  /// **'Buscar boletim de urna'**
  String get secaoSearchButton;

  /// No description provided for @secaoSearchingTse.
  ///
  /// In pt, this message translates to:
  /// **'Buscando os arquivos da seção no TSE…'**
  String get secaoSearchingTse;

  /// No description provided for @secaoSectionTitle.
  ///
  /// In pt, this message translates to:
  /// **'Seção {zona}/{secao}, {municipio}'**
  String secaoSectionTitle(String zona, String secao, String municipio);

  /// No description provided for @secaoNotPublished.
  ///
  /// In pt, this message translates to:
  /// **'O TSE ainda não publicou os arquivos desta seção. Volte depois do envio da urna.'**
  String get secaoNotPublished;

  /// status is TSE's own status word, e.g. Totalizada
  ///
  /// In pt, this message translates to:
  /// **'O TSE publicou a seção ({status}), mas sem boletim de urna para conferir.'**
  String secaoNoBu(String status);

  /// No description provided for @secaoHashMismatch.
  ///
  /// In pt, this message translates to:
  /// **'Hash não confere'**
  String get secaoHashMismatch;

  /// No description provided for @secaoBuDiffers.
  ///
  /// In pt, this message translates to:
  /// **'O boletim recebido não confere com a lista de arquivos assinada pela urna. Os votos não são exibidos.'**
  String get secaoBuDiffers;

  /// No description provided for @secaoBuNotListed.
  ///
  /// In pt, this message translates to:
  /// **'A urna não listou este boletim entre os arquivos que assinou. Os votos não são exibidos.'**
  String get secaoBuNotListed;

  /// No description provided for @secaoListingAltered.
  ///
  /// In pt, this message translates to:
  /// **'A lista de arquivos da urna não confere com o que ela assinou. Os votos não são exibidos.'**
  String get secaoListingAltered;

  /// No description provided for @secaoComparePlate.
  ///
  /// In pt, this message translates to:
  /// **'Boletim de Urna: arquivo vs papel'**
  String get secaoComparePlate;

  /// No description provided for @secaoCompareSource.
  ///
  /// In pt, this message translates to:
  /// **'Seção {zona}/{secao}, {municipio} ({uf}). Boletim emitido às {emitido} (relógio da urna); recebido pelo TSE às {recebido} (Brasília).'**
  String secaoCompareSource(
    String zona,
    String secao,
    String municipio,
    String uf,
    String emitido,
    String recebido,
  );

  /// Both numbers are already formatted.
  ///
  /// In pt, this message translates to:
  /// **'{aptos} eleitores aptos, {votaram} votaram. Digite os números do boletim impresso na coluna Papel.'**
  String secaoTurnout(String aptos, String votaram);

  /// No description provided for @secaoColCandidatura.
  ///
  /// In pt, this message translates to:
  /// **'Candidatura'**
  String get secaoColCandidatura;

  /// No description provided for @secaoColArquivo.
  ///
  /// In pt, this message translates to:
  /// **'Arquivo'**
  String get secaoColArquivo;

  /// No description provided for @secaoColPapel.
  ///
  /// In pt, this message translates to:
  /// **'Papel'**
  String get secaoColPapel;

  /// No description provided for @secaoColConfere.
  ///
  /// In pt, this message translates to:
  /// **'Confere'**
  String get secaoColConfere;

  /// No description provided for @secaoPaperHint.
  ///
  /// In pt, this message translates to:
  /// **'Papel'**
  String get secaoPaperHint;

  /// No description provided for @secaoMismatch.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{Uma linha não confere} other{{count} linhas não conferem}}. Primeiro confira se digitou o número do papel corretamente. Se a diferença continuar, fotografe o boletim afixado e procure o cartório eleitoral da sua zona.'**
  String secaoMismatch(int count);

  /// No description provided for @secaoAllMatch.
  ///
  /// In pt, this message translates to:
  /// **'Todos os números conferem com o arquivo oficial.'**
  String get secaoAllMatch;

  /// No description provided for @secaoFilesPlate.
  ///
  /// In pt, this message translates to:
  /// **'Arquivos da seção'**
  String get secaoFilesPlate;

  /// No description provided for @secaoFilesSource.
  ///
  /// In pt, this message translates to:
  /// **'Arquivo auxiliar da seção (EA18), boletim de urna e assinaturas da urna, como publicados pelo TSE.'**
  String get secaoFilesSource;

  /// No description provided for @secaoHashMatches.
  ///
  /// In pt, this message translates to:
  /// **'Hash confere'**
  String get secaoHashMatches;

  /// No description provided for @secaoSignatureUnverified.
  ///
  /// In pt, this message translates to:
  /// **'Assinatura não verificada'**
  String get secaoSignatureUnverified;

  /// No description provided for @secaoHashLabel.
  ///
  /// In pt, this message translates to:
  /// **'{kind} · SHA-256'**
  String secaoHashLabel(String kind);

  /// No description provided for @secaoKindAux.
  ///
  /// In pt, this message translates to:
  /// **'Arquivo auxiliar'**
  String get secaoKindAux;

  /// No description provided for @secaoKindBu.
  ///
  /// In pt, this message translates to:
  /// **'Boletim de urna'**
  String get secaoKindBu;

  /// No description provided for @secaoKindVota.
  ///
  /// In pt, this message translates to:
  /// **'Assinaturas da urna'**
  String get secaoKindVota;

  /// No description provided for @secaoProvesLabel.
  ///
  /// In pt, this message translates to:
  /// **'O que isto prova: '**
  String get secaoProvesLabel;

  /// No description provided for @secaoProves.
  ///
  /// In pt, this message translates to:
  /// **'o boletim publicado é exatamente o arquivo que a urna listou na sua lista de arquivos assinada. '**
  String get secaoProves;

  /// No description provided for @secaoNotYetLabel.
  ///
  /// In pt, this message translates to:
  /// **'O que ainda não prova: '**
  String get secaoNotYetLabel;

  /// No description provided for @secaoNotYet.
  ///
  /// In pt, this message translates to:
  /// **'a assinatura digital da urna sobre essa lista ainda não é verificada pela Urna Aberta. E nada aqui diz algo sobre a urna em si.'**
  String get secaoNotYet;

  /// No description provided for @secaoVoteBranco.
  ///
  /// In pt, this message translates to:
  /// **'Branco'**
  String get secaoVoteBranco;

  /// No description provided for @secaoVoteNulo.
  ///
  /// In pt, this message translates to:
  /// **'Nulo'**
  String get secaoVoteNulo;

  /// No description provided for @secaoVoteLegenda.
  ///
  /// In pt, this message translates to:
  /// **'Legenda {numero}'**
  String secaoVoteLegenda(String numero);

  /// No description provided for @secaoVoteCargoSemCandidato.
  ///
  /// In pt, this message translates to:
  /// **'Cargo sem candidatura'**
  String get secaoVoteCargoSemCandidato;

  /// No description provided for @secaoCargoPresidente.
  ///
  /// In pt, this message translates to:
  /// **'Presidente'**
  String get secaoCargoPresidente;

  /// No description provided for @secaoCargoGovernador.
  ///
  /// In pt, this message translates to:
  /// **'Governador'**
  String get secaoCargoGovernador;

  /// No description provided for @secaoCargoSenador.
  ///
  /// In pt, this message translates to:
  /// **'Senador'**
  String get secaoCargoSenador;

  /// No description provided for @secaoCargoDeputadoFederal.
  ///
  /// In pt, this message translates to:
  /// **'Deputado Federal'**
  String get secaoCargoDeputadoFederal;

  /// No description provided for @secaoCargoDeputadoEstadual.
  ///
  /// In pt, this message translates to:
  /// **'Deputado Estadual'**
  String get secaoCargoDeputadoEstadual;

  /// No description provided for @secaoCargoDeputadoDistrital.
  ///
  /// In pt, this message translates to:
  /// **'Deputado Distrital'**
  String get secaoCargoDeputadoDistrital;

  /// No description provided for @secaoErrorTitle.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível buscar a seção'**
  String get secaoErrorTitle;

  /// No description provided for @secaoErrorNotFound.
  ///
  /// In pt, this message translates to:
  /// **'O TSE não lista esta seção. Confira a zona e a seção no seu título de eleitor.'**
  String get secaoErrorNotFound;

  /// No description provided for @secaoErrorUnavailable.
  ///
  /// In pt, this message translates to:
  /// **'O TSE não respondeu agora ou publicou um arquivo que não pôde ser lido. Tente de novo mais tarde.'**
  String get secaoErrorUnavailable;

  /// No description provided for @secaoErrorServer.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível falar com o servidor da Urna Aberta.'**
  String get secaoErrorServer;

  /// No description provided for @secaoRetry.
  ///
  /// In pt, this message translates to:
  /// **'Tentar de novo'**
  String get secaoRetry;

  /// No description provided for @secaoMatchYes.
  ///
  /// In pt, this message translates to:
  /// **'Sim'**
  String get secaoMatchYes;

  /// No description provided for @secaoMatchNo.
  ///
  /// In pt, this message translates to:
  /// **'Não'**
  String get secaoMatchNo;

  /// No description provided for @secaoWheelOk.
  ///
  /// In pt, this message translates to:
  /// **'OK'**
  String get secaoWheelOk;

  /// field is the picker's label in lowercase
  ///
  /// In pt, this message translates to:
  /// **'Buscar {field}'**
  String secaoSearchHint(String field);

  /// No description provided for @secaoNothingFound.
  ///
  /// In pt, this message translates to:
  /// **'Nada encontrado para “{query}”.'**
  String secaoNothingFound(String query);

  /// No description provided for @ufBrasil.
  ///
  /// In pt, this message translates to:
  /// **'Brasil'**
  String get ufBrasil;

  /// No description provided for @ufExterior.
  ///
  /// In pt, this message translates to:
  /// **'Exterior'**
  String get ufExterior;

  /// No description provided for @verificarTitle.
  ///
  /// In pt, this message translates to:
  /// **'Verificar'**
  String get verificarTitle;

  /// No description provided for @verificarLede.
  ///
  /// In pt, this message translates to:
  /// **'O TSE assina cada arquivo de resultado que publica. A Urna Aberta confere a assinatura ao guardar o arquivo, e este aparelho pode conferir de novo por conta própria, sem confiar no nosso servidor.'**
  String get verificarLede;

  /// No description provided for @verificarOfficePresidente.
  ///
  /// In pt, this message translates to:
  /// **'Presidente'**
  String get verificarOfficePresidente;

  /// No description provided for @verificarOfficeGovernador.
  ///
  /// In pt, this message translates to:
  /// **'Governador'**
  String get verificarOfficeGovernador;

  /// No description provided for @verificarOfficeSenador.
  ///
  /// In pt, this message translates to:
  /// **'Senador'**
  String get verificarOfficeSenador;

  /// No description provided for @verificarSummaryTitle.
  ///
  /// In pt, this message translates to:
  /// **'Assinaturas dos arquivos de resultado'**
  String get verificarSummaryTitle;

  /// No description provided for @verificarSummarySource.
  ///
  /// In pt, this message translates to:
  /// **'Assinatura JWS (EdDSA, Ed25519) conforme o Manual de verificação dos arquivos JWS do TSE. Chave pública do ambiente oficial, Apêndice B.'**
  String get verificarSummarySource;

  /// No description provided for @verificarFilesStored.
  ///
  /// In pt, this message translates to:
  /// **'arquivos guardados'**
  String get verificarFilesStored;

  /// No description provided for @verificarValidOnServer.
  ///
  /// In pt, this message translates to:
  /// **'válidos no servidor'**
  String get verificarValidOnServer;

  /// No description provided for @verificarValidOnDevice.
  ///
  /// In pt, this message translates to:
  /// **'válidos neste aparelho'**
  String get verificarValidOnDevice;

  /// No description provided for @verificarCheckedHere.
  ///
  /// In pt, this message translates to:
  /// **'conferidos aqui'**
  String get verificarCheckedHere;

  /// No description provided for @verificarDeviceBad.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{Um arquivo não confere neste aparelho. Não use os números dele.} other{{count} arquivos não conferem neste aparelho. Não use os números deles.}}'**
  String verificarDeviceBad(int count);

  /// No description provided for @verificarAllChecked.
  ///
  /// In pt, this message translates to:
  /// **'Todos conferidos neste aparelho'**
  String get verificarAllChecked;

  /// No description provided for @verificarCheckOnDevice.
  ///
  /// In pt, this message translates to:
  /// **'Conferir neste aparelho'**
  String get verificarCheckOnDevice;

  /// No description provided for @verificarChecking.
  ///
  /// In pt, this message translates to:
  /// **'Conferindo {done} de {total}…'**
  String verificarChecking(String done, String total);

  /// No description provided for @verificarCheckExplain.
  ///
  /// In pt, this message translates to:
  /// **'Baixa cada arquivo assinado e confere a assinatura com a chave do TSE que vem dentro do app.'**
  String get verificarCheckExplain;

  /// No description provided for @verificarGroupTitle.
  ///
  /// In pt, this message translates to:
  /// **'{office} · {count, plural, =1{1 arquivo} other{{count} arquivos}}'**
  String verificarGroupTitle(String office, int count);

  /// No description provided for @verificarGroupSource.
  ///
  /// In pt, this message translates to:
  /// **'Arquivos finais do TSE, o mais recente gerado em {when} (Brasília).'**
  String verificarGroupSource(String when);

  /// No description provided for @verificarColumnServer.
  ///
  /// In pt, this message translates to:
  /// **'No servidor'**
  String get verificarColumnServer;

  /// No description provided for @verificarColumnDevice.
  ///
  /// In pt, this message translates to:
  /// **'Neste aparelho'**
  String get verificarColumnDevice;

  /// No description provided for @verificarGenerated.
  ///
  /// In pt, this message translates to:
  /// **'gerado {when}'**
  String verificarGenerated(String when);

  /// No description provided for @verificarOnServer.
  ///
  /// In pt, this message translates to:
  /// **'Servidor: {status}'**
  String verificarOnServer(String status);

  /// No description provided for @verificarOnDevice.
  ///
  /// In pt, this message translates to:
  /// **'Aparelho: {status}'**
  String verificarOnDevice(String status);

  /// No description provided for @verificarStatusValid.
  ///
  /// In pt, this message translates to:
  /// **'assinatura válida'**
  String get verificarStatusValid;

  /// No description provided for @verificarStatusInvalid.
  ///
  /// In pt, this message translates to:
  /// **'assinatura inválida'**
  String get verificarStatusInvalid;

  /// No description provided for @verificarStatusUnknownKey.
  ///
  /// In pt, this message translates to:
  /// **'chave desconhecida'**
  String get verificarStatusUnknownKey;

  /// No description provided for @verificarStatusUnsigned.
  ///
  /// In pt, this message translates to:
  /// **'sem assinatura'**
  String get verificarStatusUnsigned;

  /// No description provided for @verificarStatusChecking.
  ///
  /// In pt, this message translates to:
  /// **'conferindo…'**
  String get verificarStatusChecking;

  /// No description provided for @verificarStatusDownloadFailed.
  ///
  /// In pt, this message translates to:
  /// **'não foi possível baixar'**
  String get verificarStatusDownloadFailed;

  /// No description provided for @verificarStatusDifferentFile.
  ///
  /// In pt, this message translates to:
  /// **'outro arquivo'**
  String get verificarStatusDifferentFile;

  /// No description provided for @verificarStatusUnreadable.
  ///
  /// In pt, this message translates to:
  /// **'arquivo ilegível'**
  String get verificarStatusUnreadable;

  /// No description provided for @verificarStatusNotChecked.
  ///
  /// In pt, this message translates to:
  /// **'não conferido'**
  String get verificarStatusNotChecked;

  /// No description provided for @verificarYourselfTitle.
  ///
  /// In pt, this message translates to:
  /// **'Confira você mesmo'**
  String get verificarYourselfTitle;

  /// No description provided for @verificarYourselfSource.
  ///
  /// In pt, this message translates to:
  /// **'Chave: TSE, Manual de verificação dos arquivos JWS, Apêndice B. Receita testada com OpenSSL 3 em 10/10/2026.'**
  String get verificarYourselfSource;

  /// No description provided for @verificarYourselfIntro.
  ///
  /// In pt, this message translates to:
  /// **'Não precisa confiar na Urna Aberta. Cada arquivo .jws traz o próprio conteúdo e a assinatura do TSE; com a chave pública abaixo, qualquer computador confere.'**
  String get verificarYourselfIntro;

  /// No description provided for @verificarKeyId.
  ///
  /// In pt, this message translates to:
  /// **'Chave (kid)'**
  String get verificarKeyId;

  /// No description provided for @verificarStep1.
  ///
  /// In pt, this message translates to:
  /// **'Baixe um arquivo .jws pelo link de qualquer linha acima (o mesmo nome do .json, com outra terminação).'**
  String get verificarStep1;

  /// No description provided for @verificarStep2.
  ///
  /// In pt, this message translates to:
  /// **'Salve a chave abaixo como tse.pem.'**
  String get verificarStep2;

  /// No description provided for @verificarStep3.
  ///
  /// In pt, this message translates to:
  /// **'Rode os comandos no terminal. \"Signature Verified Successfully\" quer dizer que confere; conteudo.json é o arquivo que o TSE assinou.'**
  String get verificarStep3;

  /// No description provided for @verificarTerminal.
  ///
  /// In pt, this message translates to:
  /// **'Terminal (macOS ou Linux)'**
  String get verificarTerminal;

  /// No description provided for @verificarKeyNote.
  ///
  /// In pt, this message translates to:
  /// **'A chave fica dentro do app e do servidor, nunca é lida do próprio arquivo: uma chave que viesse junto com o arquivo não provaria nada.'**
  String get verificarKeyNote;

  /// No description provided for @verificarCopy.
  ///
  /// In pt, this message translates to:
  /// **'Copiar'**
  String get verificarCopy;

  /// No description provided for @verificarCopied.
  ///
  /// In pt, this message translates to:
  /// **'Copiado'**
  String get verificarCopied;

  /// No description provided for @verificarMeaningTitle.
  ///
  /// In pt, this message translates to:
  /// **'O que cada estado significa'**
  String get verificarMeaningTitle;

  /// No description provided for @verificarMeaningValidLabel.
  ///
  /// In pt, this message translates to:
  /// **'Assinatura válida'**
  String get verificarMeaningValidLabel;

  /// No description provided for @verificarMeaningValid.
  ///
  /// In pt, this message translates to:
  /// **'O arquivo é exatamente o que o TSE assinou: veio do TSE e não foi alterado no caminho.'**
  String get verificarMeaningValid;

  /// No description provided for @verificarMeaningInvalidLabel.
  ///
  /// In pt, this message translates to:
  /// **'Assinatura inválida'**
  String get verificarMeaningInvalidLabel;

  /// No description provided for @verificarMeaningInvalid.
  ///
  /// In pt, this message translates to:
  /// **'A assinatura não confere com o conteúdo. Não use estes números.'**
  String get verificarMeaningInvalid;

  /// No description provided for @verificarMeaningDifferentLabel.
  ///
  /// In pt, this message translates to:
  /// **'Outro arquivo'**
  String get verificarMeaningDifferentLabel;

  /// No description provided for @verificarMeaningDifferent.
  ///
  /// In pt, this message translates to:
  /// **'A assinatura confere, mas o arquivo não é o que o servidor da Urna Aberta disse ter usado.'**
  String get verificarMeaningDifferent;

  /// No description provided for @verificarMeaningNotCheckedLabel.
  ///
  /// In pt, this message translates to:
  /// **'Não conferido'**
  String get verificarMeaningNotCheckedLabel;

  /// No description provided for @verificarMeaningNotChecked.
  ///
  /// In pt, this message translates to:
  /// **'Este aparelho ainda não conferiu o arquivo. O resultado do servidor continua valendo, mas depende de você confiar nele.'**
  String get verificarMeaningNotChecked;

  /// No description provided for @verificarProves.
  ///
  /// In pt, this message translates to:
  /// **'A assinatura prova a origem e a integridade do arquivo publicado. Ela não prova nada sobre o funcionamento da urna nem sobre a totalização.'**
  String get verificarProves;

  /// No description provided for @verificarUrnaNote.
  ///
  /// In pt, this message translates to:
  /// **'Os arquivos de cada urna (boletim de urna) têm outra assinatura, conferida em Minha seção pelo hash; a assinatura da própria urna ainda não é verificada pela Urna Aberta.'**
  String get verificarUrnaNote;

  /// No description provided for @verificarLoadError.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível falar com o servidor da Urna Aberta.'**
  String get verificarLoadError;

  /// No description provided for @verificarRetry.
  ///
  /// In pt, this message translates to:
  /// **'Tentar de novo'**
  String get verificarRetry;

  /// No description provided for @apuracaoModeLive.
  ///
  /// In pt, this message translates to:
  /// **'Ao vivo'**
  String get apuracaoModeLive;

  /// No description provided for @apuracaoModeReplay.
  ///
  /// In pt, this message translates to:
  /// **'Reprise do 1º turno'**
  String get apuracaoModeReplay;

  /// No description provided for @apuracaoLiveLede.
  ///
  /// In pt, this message translates to:
  /// **'Presidente, {round}º turno, ao vivo. O arquivo nacional do TSE e a soma dos arquivos de cada estado, lado a lado. Os números se atualizam a cada 30 segundos.'**
  String apuracaoLiveLede(int round);

  /// No description provided for @apuracaoLiveEndedLede.
  ///
  /// In pt, this message translates to:
  /// **'Presidente, {round}º turno. Os últimos arquivos do TSE guardados pela Urna Aberta durante a apuração.'**
  String apuracaoLiveEndedLede(int round);

  /// No description provided for @apuracaoLiveSoon.
  ///
  /// In pt, this message translates to:
  /// **'A apuração ao vivo do {round}º turno começa em {date}, às 17h (Brasília). Enquanto isso, reveja o 1º turno.'**
  String apuracaoLiveSoon(int round, String date);

  /// No description provided for @apuracaoLiveWaiting.
  ///
  /// In pt, this message translates to:
  /// **'As urnas do {round}º turno fecharam. Aguardando os primeiros arquivos do TSE; enquanto isso, reveja o 1º turno.'**
  String apuracaoLiveWaiting(int round);

  /// No description provided for @apuracaoLiveStale.
  ///
  /// In pt, this message translates to:
  /// **'Sem conexão com o servidor: estes são os números de {time}.'**
  String apuracaoLiveStale(String time);

  /// No description provided for @apuracaoLiveTimelineTitle.
  ///
  /// In pt, this message translates to:
  /// **'A apuração do {round}º turno'**
  String apuracaoLiveTimelineTitle(int round);

  /// No description provided for @apuracaoLiveTimelineSource.
  ///
  /// In pt, this message translates to:
  /// **'Cada ponto é um momento em que um arquivo do TSE mudou, guardado pela Urna Aberta com a assinatura conferida.'**
  String get apuracaoLiveTimelineSource;

  /// No description provided for @apuracaoLiveNoNational.
  ///
  /// In pt, this message translates to:
  /// **'ainda sem arquivo'**
  String get apuracaoLiveNoNational;

  /// No description provided for @atlasLive.
  ///
  /// In pt, this message translates to:
  /// **'Ao vivo'**
  String get atlasLive;

  /// No description provided for @entendaPausePara2b.
  ///
  /// In pt, this message translates to:
  /// **'O TSE informa ainda que, durante a pausa, os boletins de urna continuaram a ser transmitidos, recebidos e publicados, e que o cálculo da totalização seguiu normalmente, exceto por um breve momento em que foi suspenso pelo protocolo de segurança.'**
  String get entendaPausePara2b;

  /// No description provided for @entendaSourceFatoOuBoato.
  ///
  /// In pt, this message translates to:
  /// **'TSE · Fato ou Boato: É falso que a interrupção na divulgação dos resultados tenha fraudado o resultado do 1º turno para presidente (06/10/2026)'**
  String get entendaSourceFatoOuBoato;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
