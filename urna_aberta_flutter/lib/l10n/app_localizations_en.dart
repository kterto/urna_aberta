// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String atlasPlate(int number) {
    return 'Plate $number';
  }

  @override
  String atlasFile(String code) {
    return 'File $code';
  }

  @override
  String atlasOpenFile(String code) {
    return 'Open file $code';
  }

  @override
  String get atlasSimulation => 'Simulation';

  @override
  String atlasSimulationSemantics(String label) {
    return '$label: unofficial data';
  }

  @override
  String get atlasSignatureValid => 'Valid signature';

  @override
  String get atlasSignatureInvalid => 'Invalid signature';

  @override
  String get atlasNotVerified => 'Not verified';

  @override
  String get atlasLearnWhy => 'Learn why';

  @override
  String get atlasDivergenceTitle =>
      'The national release is behind the states.';

  @override
  String get atlasDivergenceBody =>
      'The count goes on: the per-state files are still being updated.';

  @override
  String get atlasCopyHash => 'Copy hash';

  @override
  String get atlasHashCopied => 'Hash copied';

  @override
  String get replayPause => 'Pause replay';

  @override
  String get replayPlay => 'Play replay';

  @override
  String replayClock(String clock) {
    return 'Replay clock $clock';
  }

  @override
  String get replayJumpToFreeze => 'Jump to the pause';

  @override
  String get replaySimulated => 'Simulated replay';

  @override
  String get mapTitle => 'Polling sections counted, by state';

  @override
  String mapSimulationAt(String moment) {
    return 'Simulation · $moment';
  }

  @override
  String get mapSource =>
      'Boundaries: IBGE. Data: TSE, EA20 per state. Approximate scale.';

  @override
  String get mapLayerRegions => 'Regions';

  @override
  String get mapLayerCounted => 'Sections counted';

  @override
  String get mapShowMap => 'Show map';

  @override
  String get mapShowTable => 'Show as table';

  @override
  String get mapClearSelection => 'Clear selection';

  @override
  String mapUfCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count states',
      one: '1 state',
    );
    return '$_temp0';
  }

  @override
  String mapUfUpdated(String region, String moment) {
    return '$region · updated $moment';
  }

  @override
  String get mapCountedCaption => 'sections counted';

  @override
  String get mapHint => 'Tap a state or a legend key.';

  @override
  String get mapNoUfInBand => 'No state in this band';

  @override
  String get mapAverageCaption => 'simple average of the states';

  @override
  String get mapColumnRegion => 'Region';

  @override
  String get mapColumnCounted => '% sections counted';

  @override
  String get mapColumnFile => 'File';

  @override
  String mapLongitudeWest(int degrees) {
    return '$degrees°W';
  }

  @override
  String mapLatitudeSouth(int degrees) {
    return '$degrees°S';
  }

  @override
  String get mapTropic => 'Tropic of Capricorn';

  @override
  String get mapEquator => 'Equator';

  @override
  String mapUfSemantics(String uf, String region, String pct) {
    return '$uf, $region, $pct of polling sections counted';
  }

  @override
  String get chartNationalFileTse => 'TSE national file';

  @override
  String get chartNationalFile => 'National file';

  @override
  String get chartStatesSum => 'Sum of the states';

  @override
  String chartDuoSemantics(String national, String states) {
    return 'TSE national file $national percent; sum of the states $states percent';
  }

  @override
  String get chartDifference => 'Difference: ';

  @override
  String chartPoints(String value) {
    return '$value pp';
  }

  @override
  String get chartDifferenceOf => ' of sections counted';

  @override
  String get chartVotesSemantics => 'Votes per candidacy in both sources';

  @override
  String chartRowSemantics(String label, String national, String states) {
    return '$label: $national in the national file, $states in the sum of the states';
  }

  @override
  String get chartTimelineSemantics =>
      'Timeline of both sources. Use the arrow keys to explore.';

  @override
  String chartTimelinePointSemantics(
    String time,
    String national,
    String states,
  ) {
    return '$time: national file $national, sum of the states $states';
  }

  @override
  String get chartNationalFrozenSuffix => ' · national frozen';

  @override
  String chartFreezeBand(int minutes) {
    return 'National frozen · $minutes min';
  }

  @override
  String chartHourTick(int hour) {
    return '$hour:00';
  }

  @override
  String chartUfSemantics(String uf, String pct) {
    return '$uf: $pct of sections counted';
  }

  @override
  String get apuracaoHeadline => 'The count never stopped.';

  @override
  String get apuracaoLede =>
      'President, 1st round. TSE\'s national file and the sum of each state\'s files, side by side. Every number links to the file it came from.';

  @override
  String get apuracaoDesignSystem => 'Design system';

  @override
  String get apuracaoDuoTitle => 'The two sources compared · President';

  @override
  String get apuracaoDuoSource =>
      '% of polling sections counted. Source: TSE. Sum computed by Urna Aberta.';

  @override
  String apuracaoFrozenSince(String time) {
    return 'frozen since $time';
  }

  @override
  String apuracaoUpdatedAt(String time) {
    return 'updated $time';
  }

  @override
  String get apuracaoVotesTitle => 'Votes per candidacy, in both sources';

  @override
  String get apuracaoVotesSourceSynthetic =>
      'Same ink for every candidacy. Intermediate votes proportional to TSE\'s final files.';

  @override
  String get apuracaoVotesSource =>
      'Same ink for every candidacy. Source: TSE.';

  @override
  String get apuracaoTimelineTitle => 'The night of October 4';

  @override
  String apuracaoTimelineSource(String pct) {
    return 'Synthetic curve that ends at TSE\'s real final files. The national pause at $pct, 19:14 to 20:04, follows the times TSE reported.';
  }

  @override
  String apuracaoCandidateNumber(int number) {
    return 'Number $number';
  }

  @override
  String get apuracaoReplayUnavailable =>
      'The 1st-round files have not been loaded on the server yet.';

  @override
  String get apuracaoServerUnreachable =>
      'Could not reach the Urna Aberta server.';

  @override
  String get apuracaoRetry => 'Try again';

  @override
  String get navApuracao => 'Count';

  @override
  String get navSecao => 'My section';

  @override
  String get navVerificar => 'Verify';

  @override
  String get navEntenda => 'Learn';

  @override
  String get navSistema => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeSystem => 'System';

  @override
  String get themeDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get languageDevice => 'Device';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languageEnglish => 'English';

  @override
  String get entendaTitle => 'Understand the process';

  @override
  String get entendaLede =>
      'Short chapters on how the result leaves the voting machine and reaches you. Every statement cites an official TSE source.';

  @override
  String get entendaCh1Title => 'The path of a vote';

  @override
  String get entendaCh1Summary =>
      'From the voting machine to the posted report, from transmission to publication.';

  @override
  String get entendaCh2Title => 'The ballot box report';

  @override
  String get entendaCh2Summary =>
      'What the Boletim de Urna (BU) contains, why it is public and how to check it.';

  @override
  String get entendaCh3Title => 'The voting machine files';

  @override
  String get entendaCh3Summary => 'BU, RDV and log: what each one is for.';

  @override
  String get entendaCh4Title => 'Signatures and hashes';

  @override
  String get entendaCh4Summary => 'What this app\'s checks actually verify.';

  @override
  String get entendaCh5Title => 'Security protocols';

  @override
  String get entendaCh5Summary =>
      'Public tests, ceremonies and code inspection.';

  @override
  String get entendaCh6Title => 'October 4, 2026';

  @override
  String get entendaCh6Summary =>
      'What stopped, what did not, and how the replay shows it.';

  @override
  String get entendaCh7Title => 'What this app proves';

  @override
  String get entendaCh7Summary =>
      'And, just as clearly, what it does not prove.';

  @override
  String entendaChapterLabel(int number) {
    return 'Chapter $number';
  }

  @override
  String get entendaDraftStamp => 'Draft · sources under review';

  @override
  String get entendaPausePara1 =>
      'On the night of October 4, 2026, at about 19:14 (Brasília time), the national (\"Brasil\") view of the results for President stopped updating, when 64.81% of the data had been published. Generation of those files was restored at 20:04, about 50 minutes later.';

  @override
  String get entendaPausePara2 =>
      'According to TSE, a data-processing contention, after a rise in data volume, stalled the module that generates the publication files for the \"Brasil\" view. The state view was not affected: each state\'s files, which also carry the votes for President, kept being published without interruption.';

  @override
  String get entendaPauseCallout =>
      'Counting (apuração) is done by each voting machine. Totalization (totalização) is the sum of those counts. Publication (divulgação) is the release on the internet. What stopped was the national publication.';

  @override
  String get entendaPausePara3 =>
      'Anyone adding up the per-state (UF) files during the pause saw the count keep going. That is what the Count screen shows in the replay, with the pause at the same time. How the states moved during the pause is a synthetic curve: Urna Aberta kept only that night\'s final files.';

  @override
  String get entendaInProduction =>
      'This chapter is being written. The text will be drawn from TSE\'s official sources and reviewed in Portuguese and English.';

  @override
  String get entendaSources => 'Sources';

  @override
  String get entendaSourceDivulgacao =>
      'TSE · Informações técnicas sobre a divulgação de resultados (technical information on results publication)';

  @override
  String get secaoTitle => 'My polling section';

  @override
  String get secaoLede =>
      'Find the official ballot box report (Boletim de Urna, BU) of your polling section and compare it with the printed report posted at your polling place.';

  @override
  String get secaoFieldUf => 'State';

  @override
  String get secaoUfExterior => 'Abroad';

  @override
  String get secaoFieldMunicipio => 'Municipality';

  @override
  String get secaoFieldZona => 'Zone';

  @override
  String get secaoFieldSecao => 'Section';

  @override
  String get secaoLoadingMunicipios => 'Loading municipalities…';

  @override
  String get secaoLoadingZonas => 'Loading zones…';

  @override
  String get secaoLoadingSecoes => 'Loading sections…';

  @override
  String get secaoLocatePlate => 'Find your polling section';

  @override
  String get secaoFormHint =>
      'Your electoral zone and polling section are on your voter card (título de eleitor) or in the e-Título app. The list comes from TSE\'s section file.';

  @override
  String get secaoSearchButton => 'Find the ballot box report';

  @override
  String get secaoSearchingTse => 'Fetching the section\'s files from TSE…';

  @override
  String secaoSectionTitle(String zona, String secao, String municipio) {
    return 'Section $zona/$secao, $municipio';
  }

  @override
  String get secaoNotPublished =>
      'TSE has not published this section\'s files yet. Come back after the ballot box\'s results are sent.';

  @override
  String secaoNoBu(String status) {
    return 'TSE published the section ($status), but with no ballot box report to check.';
  }

  @override
  String get secaoHashMismatch => 'Hash does not match';

  @override
  String get secaoBuDiffers =>
      'The report received does not match the list of files the ballot box signed. The votes are not shown.';

  @override
  String get secaoBuNotListed =>
      'The ballot box did not list this report among the files it signed. The votes are not shown.';

  @override
  String get secaoListingAltered =>
      'The ballot box\'s file list does not match what it signed. The votes are not shown.';

  @override
  String get secaoComparePlate => 'Ballot box report: file vs paper';

  @override
  String secaoCompareSource(
    String zona,
    String secao,
    String municipio,
    String uf,
    String emitido,
    String recebido,
  ) {
    return 'Section $zona/$secao, $municipio ($uf). Report issued at $emitido (ballot box clock); received by TSE at $recebido (Brasília time).';
  }

  @override
  String secaoTurnout(String aptos, String votaram) {
    return '$aptos eligible voters, $votaram voted. Type the numbers from the printed report in the Paper column.';
  }

  @override
  String get secaoColCandidatura => 'Candidacy';

  @override
  String get secaoColArquivo => 'File';

  @override
  String get secaoColPapel => 'Paper';

  @override
  String get secaoColConfere => 'Match';

  @override
  String get secaoPaperHint => 'Paper';

  @override
  String secaoMismatch(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rows do not match',
      one: 'One row does not match',
    );
    return '$_temp0. First check that you typed the paper number correctly. If the difference remains, photograph the posted report and contact the electoral office (cartório eleitoral) of your zone.';
  }

  @override
  String get secaoAllMatch => 'All numbers match the official file.';

  @override
  String get secaoFilesPlate => 'The section\'s files';

  @override
  String get secaoFilesSource =>
      'The section\'s auxiliary file (EA18), ballot box report and ballot box signatures, as published by TSE.';

  @override
  String get secaoHashMatches => 'Hash matches';

  @override
  String get secaoSignatureUnverified => 'Signature not verified';

  @override
  String secaoHashLabel(String kind) {
    return '$kind · SHA-256';
  }

  @override
  String get secaoKindAux => 'Auxiliary file';

  @override
  String get secaoKindBu => 'Ballot box report';

  @override
  String get secaoKindVota => 'Ballot box signatures';

  @override
  String get secaoProvesLabel => 'What this proves: ';

  @override
  String get secaoProves =>
      'the published report is exactly the file the ballot box listed in its signed file list. ';

  @override
  String get secaoNotYetLabel => 'What it does not prove yet: ';

  @override
  String get secaoNotYet =>
      'Urna Aberta does not yet verify the ballot box\'s digital signature on that list. And nothing here says anything about the ballot box itself.';

  @override
  String get secaoVoteBranco => 'Blank';

  @override
  String get secaoVoteNulo => 'Null';

  @override
  String secaoVoteLegenda(String numero) {
    return 'Party vote $numero';
  }

  @override
  String get secaoVoteCargoSemCandidato => 'Office without candidacy';

  @override
  String get secaoCargoPresidente => 'President';

  @override
  String get secaoCargoGovernador => 'Governor';

  @override
  String get secaoCargoSenador => 'Senator';

  @override
  String get secaoCargoDeputadoFederal => 'Federal Deputy';

  @override
  String get secaoCargoDeputadoEstadual => 'State Deputy';

  @override
  String get secaoCargoDeputadoDistrital => 'District Deputy';

  @override
  String get secaoErrorTitle => 'Could not look up the section';

  @override
  String get secaoErrorNotFound =>
      'TSE does not list this section. Check the zone and section on your voter card.';

  @override
  String get secaoErrorUnavailable =>
      'TSE did not respond just now, or published a file that could not be read. Try again later.';

  @override
  String get secaoErrorServer => 'Could not reach the Urna Aberta server.';

  @override
  String get secaoRetry => 'Try again';

  @override
  String get secaoMatchYes => 'Yes';

  @override
  String get secaoMatchNo => 'No';

  @override
  String get secaoWheelOk => 'OK';

  @override
  String secaoSearchHint(String field) {
    return 'Search $field';
  }

  @override
  String secaoNothingFound(String query) {
    return 'Nothing found for “$query”.';
  }

  @override
  String get ufBrasil => 'Brazil';

  @override
  String get ufExterior => 'Abroad';

  @override
  String get verificarTitle => 'Verify';

  @override
  String get verificarLede =>
      'TSE signs every result file it publishes. Urna Aberta checks the signature when it stores the file, and this device can check it again on its own, without trusting our server.';

  @override
  String get verificarOfficePresidente => 'President';

  @override
  String get verificarOfficeGovernador => 'Governor';

  @override
  String get verificarOfficeSenador => 'Senator';

  @override
  String get verificarSummaryTitle => 'Result file signatures';

  @override
  String get verificarSummarySource =>
      'JWS signature (EdDSA, Ed25519) as described in TSE\'s Manual de verificação dos arquivos JWS. Public key of the official environment, Appendix B.';

  @override
  String get verificarFilesStored => 'files stored';

  @override
  String get verificarValidOnServer => 'valid on the server';

  @override
  String get verificarValidOnDevice => 'valid on this device';

  @override
  String get verificarCheckedHere => 'checked here';

  @override
  String verificarDeviceBad(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count files do not check out on this device. Do not use their numbers.',
      one:
          'One file does not check out on this device. Do not use its numbers.',
    );
    return '$_temp0';
  }

  @override
  String get verificarAllChecked => 'All checked on this device';

  @override
  String get verificarCheckOnDevice => 'Check on this device';

  @override
  String verificarChecking(String done, String total) {
    return 'Checking $done of $total…';
  }

  @override
  String get verificarCheckExplain =>
      'Downloads each signed file and checks its signature with the TSE key built into the app.';

  @override
  String verificarGroupTitle(String office, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count files',
      one: '1 file',
    );
    return '$office · $_temp0';
  }

  @override
  String verificarGroupSource(String when) {
    return 'Final TSE files; the newest was generated $when (Brasília time).';
  }

  @override
  String get verificarColumnServer => 'On the server';

  @override
  String get verificarColumnDevice => 'On this device';

  @override
  String verificarGenerated(String when) {
    return 'generated $when';
  }

  @override
  String verificarOnServer(String status) {
    return 'Server: $status';
  }

  @override
  String verificarOnDevice(String status) {
    return 'Device: $status';
  }

  @override
  String get verificarStatusValid => 'valid signature';

  @override
  String get verificarStatusInvalid => 'invalid signature';

  @override
  String get verificarStatusUnknownKey => 'unknown key';

  @override
  String get verificarStatusUnsigned => 'no signature';

  @override
  String get verificarStatusChecking => 'checking…';

  @override
  String get verificarStatusDownloadFailed => 'could not download';

  @override
  String get verificarStatusDifferentFile => 'different file';

  @override
  String get verificarStatusUnreadable => 'unreadable file';

  @override
  String get verificarStatusNotChecked => 'not checked';

  @override
  String get verificarYourselfTitle => 'Check it yourself';

  @override
  String get verificarYourselfSource =>
      'Key: TSE, Manual de verificação dos arquivos JWS, Appendix B. Recipe tested with OpenSSL 3 on 10/10/2026.';

  @override
  String get verificarYourselfIntro =>
      'You do not have to trust Urna Aberta. Each .jws file carries its own content and TSE\'s signature; with the public key below, any computer can check it.';

  @override
  String get verificarKeyId => 'Key (kid)';

  @override
  String get verificarStep1 =>
      'Download a .jws file from the link on any row above (the same name as the .json, with a different extension).';

  @override
  String get verificarStep2 => 'Save the key below as tse.pem.';

  @override
  String get verificarStep3 =>
      'Run the commands in a terminal. \"Signature Verified Successfully\" means it checks out; conteudo.json is the file TSE signed.';

  @override
  String get verificarTerminal => 'Terminal (macOS or Linux)';

  @override
  String get verificarKeyNote =>
      'The key lives in the app and on the server and is never read from the file itself: a key that came with the file would prove nothing.';

  @override
  String get verificarCopy => 'Copy';

  @override
  String get verificarCopied => 'Copied';

  @override
  String get verificarMeaningTitle => 'What each status means';

  @override
  String get verificarMeaningValidLabel => 'Valid signature';

  @override
  String get verificarMeaningValid =>
      'The file is exactly what TSE signed: it came from TSE and was not altered on the way.';

  @override
  String get verificarMeaningInvalidLabel => 'Invalid signature';

  @override
  String get verificarMeaningInvalid =>
      'The signature does not match the content. Do not use these numbers.';

  @override
  String get verificarMeaningDifferentLabel => 'Different file';

  @override
  String get verificarMeaningDifferent =>
      'The signature checks out, but the file is not the one the Urna Aberta server said it used.';

  @override
  String get verificarMeaningNotCheckedLabel => 'Not checked';

  @override
  String get verificarMeaningNotChecked =>
      'This device has not checked the file yet. The server\'s result still stands, but it depends on you trusting the server.';

  @override
  String get verificarProves =>
      'The signature proves where the published file came from and that it is intact. It proves nothing about how the voting machine works or about the totalization.';

  @override
  String get verificarUrnaNote =>
      'Each voting machine\'s files (the boletim de urna) carry a different signature, checked by hash in My section; Urna Aberta does not yet verify the machine\'s own signature.';

  @override
  String get verificarLoadError => 'Could not reach the Urna Aberta server.';

  @override
  String get verificarRetry => 'Try again';

  @override
  String get apuracaoModeLive => 'Live';

  @override
  String get apuracaoModeReplay => '1st round replay';

  @override
  String apuracaoLiveLede(int round) {
    return 'President, round $round, live. TSE\'s national file and the sum of each state\'s files, side by side. Figures refresh every 30 seconds.';
  }

  @override
  String apuracaoLiveEndedLede(int round) {
    return 'President, round $round. The latest TSE files Urna Aberta stored during the count.';
  }

  @override
  String apuracaoLiveSoon(int round, String date) {
    return 'Live counting for round $round starts on $date at 5 pm Brasília time. Meanwhile, replay the 1st round.';
  }

  @override
  String apuracaoLiveWaiting(int round) {
    return 'Polls for round $round have closed. Waiting for TSE\'s first files; meanwhile, replay the 1st round.';
  }

  @override
  String apuracaoLiveStale(String time) {
    return 'No connection to the server: these are the figures from $time.';
  }

  @override
  String apuracaoLiveTimelineTitle(int round) {
    return 'The round $round count';
  }

  @override
  String get apuracaoLiveTimelineSource =>
      'Each point is a moment a TSE file changed, stored by Urna Aberta with its signature checked.';

  @override
  String get apuracaoLiveNoNational => 'no file yet';

  @override
  String get atlasLive => 'Live';

  @override
  String get entendaPausePara2b =>
      'TSE also states that during the pause the ballot box reports (boletins de urna) kept being transmitted, received and published, and that totalization went on normally, except for a brief moment when it was suspended under the security protocol.';

  @override
  String get entendaSourceFatoOuBoato =>
      'TSE · Fato ou Boato: É falso que a interrupção na divulgação dos resultados tenha fraudado o resultado do 1º turno para presidente (fact-check, Oct 6, 2026)';
}
