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
  /// **'Curva sintética que termina nos arquivos finais reais do TSE, com a pausa nacional de {pct} simulada.'**
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

  /// No description provided for @navSistema.
  ///
  /// In pt, this message translates to:
  /// **'Sistema'**
  String get navSistema;

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

  /// No description provided for @entendaDraftStamp.
  ///
  /// In pt, this message translates to:
  /// **'Rascunho · revisar fontes'**
  String get entendaDraftStamp;

  /// No description provided for @entendaPausePara1.
  ///
  /// In pt, this message translates to:
  /// **'Na noite de 4 de outubro de 2026, a página nacional de resultados para Presidente ficou parada em 64,81% por cerca de 50 a 60 minutos. Depois, saltou para perto de 84%.'**
  String get entendaPausePara1;

  /// No description provided for @entendaPausePara2.
  ///
  /// In pt, this message translates to:
  /// **'Segundo o TSE, um gargalo no processamento travou o módulo que gera os arquivos de publicação \"Brasil\". Os arquivos de cada estado continuaram sendo atualizados normalmente durante todo o tempo.'**
  String get entendaPausePara2;

  /// No description provided for @entendaPauseCallout.
  ///
  /// In pt, this message translates to:
  /// **'Totalização é a contagem oficial. Divulgação é a publicação dessa contagem. O que parou foi a divulgação nacional.'**
  String get entendaPauseCallout;

  /// No description provided for @entendaPausePara3.
  ///
  /// In pt, this message translates to:
  /// **'Quem somava os arquivos por UF durante a pausa via a contagem seguir. É isso que a tela Apuração mostra no replay: as duas fontes lado a lado.'**
  String get entendaPausePara3;

  /// No description provided for @entendaInProduction.
  ///
  /// In pt, this message translates to:
  /// **'Este capítulo está em produção. O texto será escrito a partir das fontes oficiais do TSE e revisado em português e inglês.'**
  String get entendaInProduction;

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
