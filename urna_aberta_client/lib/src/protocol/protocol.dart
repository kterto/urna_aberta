/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:urna_aberta_client/src/protocol/divergence_event.dart'
    as _ivdor3em;
import 'package:urna_aberta_client/src/protocol/election_summary.dart'
    as _i35jelvf;
import 'package:urna_aberta_client/src/protocol/file_verification.dart'
    as _i4bcni6a;
import 'package:urna_aberta_client/src/protocol/municipio_ref.dart'
    as _iawxlp65;
import 'package:urna_aberta_client/src/protocol/timeline_point.dart'
    as _ipzn9brv;
import 'bu_check.dart' as _ijbwnxcy;
import 'candidate.dart' as _irnb9urg;
import 'candidate_report.dart' as _i8xvblpk;
import 'candidate_tally.dart' as _ixvsuy9r;
import 'candidate_votes.dart' as _iurxdm15;
import 'cargo_result.dart' as _i77b8h6f;
import 'chamber_report.dart' as _igvtxk1g;
import 'data_origin.dart' as _i2ilnjuc;
import 'divergence_event.dart' as _i3f5hnmb;
import 'election_summary.dart' as _ipxcqqyf;
import 'file_not_stored.dart' as _i0m7v5qb;
import 'file_verification.dart' as _ikk6q8b9;
import 'greetings/greeting.dart' as _izw8z7ou;
import 'list_report.dart' as _i49o1wen;
import 'live_status.dart' as _i5q61ine;
import 'municipio_ref.dart' as _i663s1cn;
import 'office_report.dart' as _ie6yu1i3;
import 'replay_night.dart' as _i1vi4thm;
import 'replay_unavailable.dart' as _i6npibdt;
import 'result_file.dart' as _ihi5zekk;
import 'result_snapshot.dart' as _i4dv59av;
import 'result_unavailable.dart' as _ip5wxoe5;
import 'seat_check.dart' as _idhahere;
import 'section_check.dart' as _i1fk3nml;
import 'section_file.dart' as _i4rww364;
import 'section_file_info.dart' as _igdizl70;
import 'section_not_found.dart' as _iakf100n;
import 'section_report.dart' as _i64rlb21;
import 'section_unavailable.dart' as _i8oamffp;
import 'signature_status.dart' as _iomwgc6v;
import 'tally_frame.dart' as _iiyd8otz;
import 'timeline_point.dart' as _i4neo0h8;
import 'uf_progress.dart' as _icbf2ppq;
import 'urna_signature.dart' as _i343iyih;
import 'voto_result.dart' as _iuhijha9;
export 'bu_check.dart';
export 'candidate.dart';
export 'candidate_report.dart';
export 'candidate_tally.dart';
export 'candidate_votes.dart';
export 'cargo_result.dart';
export 'chamber_report.dart';
export 'data_origin.dart';
export 'divergence_event.dart';
export 'election_summary.dart';
export 'file_not_stored.dart';
export 'file_verification.dart';
export 'greetings/greeting.dart';
export 'list_report.dart';
export 'live_status.dart';
export 'municipio_ref.dart';
export 'office_report.dart';
export 'replay_night.dart';
export 'replay_unavailable.dart';
export 'result_file.dart';
export 'result_snapshot.dart';
export 'result_unavailable.dart';
export 'seat_check.dart';
export 'section_check.dart';
export 'section_file.dart';
export 'section_file_info.dart';
export 'section_not_found.dart';
export 'section_report.dart';
export 'section_unavailable.dart';
export 'signature_status.dart';
export 'tally_frame.dart';
export 'timeline_point.dart';
export 'uf_progress.dart';
export 'urna_signature.dart';
export 'voto_result.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _ijbwnxcy.BuCheck) {
      return _ijbwnxcy.BuCheck.fromJson(data) as T;
    }
    if (t == _irnb9urg.Candidate) {
      return _irnb9urg.Candidate.fromJson(data) as T;
    }
    if (t == _i8xvblpk.CandidateReport) {
      return _i8xvblpk.CandidateReport.fromJson(data) as T;
    }
    if (t == _ixvsuy9r.CandidateTally) {
      return _ixvsuy9r.CandidateTally.fromJson(data) as T;
    }
    if (t == _iurxdm15.CandidateVotes) {
      return _iurxdm15.CandidateVotes.fromJson(data) as T;
    }
    if (t == _i77b8h6f.CargoResult) {
      return _i77b8h6f.CargoResult.fromJson(data) as T;
    }
    if (t == _igvtxk1g.ChamberReport) {
      return _igvtxk1g.ChamberReport.fromJson(data) as T;
    }
    if (t == _i2ilnjuc.DataOrigin) {
      return _i2ilnjuc.DataOrigin.fromJson(data) as T;
    }
    if (t == _i3f5hnmb.DivergenceEvent) {
      return _i3f5hnmb.DivergenceEvent.fromJson(data) as T;
    }
    if (t == _ipxcqqyf.ElectionSummary) {
      return _ipxcqqyf.ElectionSummary.fromJson(data) as T;
    }
    if (t == _i0m7v5qb.FileNotStoredException) {
      return _i0m7v5qb.FileNotStoredException.fromJson(data) as T;
    }
    if (t == _ikk6q8b9.FileVerification) {
      return _ikk6q8b9.FileVerification.fromJson(data) as T;
    }
    if (t == _izw8z7ou.Greeting) {
      return _izw8z7ou.Greeting.fromJson(data) as T;
    }
    if (t == _i49o1wen.ListReport) {
      return _i49o1wen.ListReport.fromJson(data) as T;
    }
    if (t == _i5q61ine.LiveStatus) {
      return _i5q61ine.LiveStatus.fromJson(data) as T;
    }
    if (t == _i663s1cn.MunicipioRef) {
      return _i663s1cn.MunicipioRef.fromJson(data) as T;
    }
    if (t == _ie6yu1i3.OfficeReport) {
      return _ie6yu1i3.OfficeReport.fromJson(data) as T;
    }
    if (t == _i1vi4thm.ReplayNight) {
      return _i1vi4thm.ReplayNight.fromJson(data) as T;
    }
    if (t == _i6npibdt.ReplayUnavailableException) {
      return _i6npibdt.ReplayUnavailableException.fromJson(data) as T;
    }
    if (t == _ihi5zekk.ResultFile) {
      return _ihi5zekk.ResultFile.fromJson(data) as T;
    }
    if (t == _i4dv59av.ResultSnapshot) {
      return _i4dv59av.ResultSnapshot.fromJson(data) as T;
    }
    if (t == _ip5wxoe5.ResultUnavailable) {
      return _ip5wxoe5.ResultUnavailable.fromJson(data) as T;
    }
    if (t == _idhahere.SeatCheck) {
      return _idhahere.SeatCheck.fromJson(data) as T;
    }
    if (t == _i1fk3nml.SectionCheck) {
      return _i1fk3nml.SectionCheck.fromJson(data) as T;
    }
    if (t == _i4rww364.SectionFile) {
      return _i4rww364.SectionFile.fromJson(data) as T;
    }
    if (t == _igdizl70.SectionFileInfo) {
      return _igdizl70.SectionFileInfo.fromJson(data) as T;
    }
    if (t == _iakf100n.SectionNotFoundException) {
      return _iakf100n.SectionNotFoundException.fromJson(data) as T;
    }
    if (t == _i64rlb21.SectionReport) {
      return _i64rlb21.SectionReport.fromJson(data) as T;
    }
    if (t == _i8oamffp.SectionUnavailableException) {
      return _i8oamffp.SectionUnavailableException.fromJson(data) as T;
    }
    if (t == _iomwgc6v.SignatureStatus) {
      return _iomwgc6v.SignatureStatus.fromJson(data) as T;
    }
    if (t == _iiyd8otz.TallyFrame) {
      return _iiyd8otz.TallyFrame.fromJson(data) as T;
    }
    if (t == _i4neo0h8.TimelinePoint) {
      return _i4neo0h8.TimelinePoint.fromJson(data) as T;
    }
    if (t == _icbf2ppq.UfProgress) {
      return _icbf2ppq.UfProgress.fromJson(data) as T;
    }
    if (t == _i343iyih.UrnaSignature) {
      return _i343iyih.UrnaSignature.fromJson(data) as T;
    }
    if (t == _iuhijha9.VotoResult) {
      return _iuhijha9.VotoResult.fromJson(data) as T;
    }
    if (t == _isc.getType<_ijbwnxcy.BuCheck?>()) {
      return (data != null ? _ijbwnxcy.BuCheck.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_irnb9urg.Candidate?>()) {
      return (data != null ? _irnb9urg.Candidate.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i8xvblpk.CandidateReport?>()) {
      return (data != null ? _i8xvblpk.CandidateReport.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ixvsuy9r.CandidateTally?>()) {
      return (data != null ? _ixvsuy9r.CandidateTally.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iurxdm15.CandidateVotes?>()) {
      return (data != null ? _iurxdm15.CandidateVotes.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i77b8h6f.CargoResult?>()) {
      return (data != null ? _i77b8h6f.CargoResult.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_igvtxk1g.ChamberReport?>()) {
      return (data != null ? _igvtxk1g.ChamberReport.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i2ilnjuc.DataOrigin?>()) {
      return (data != null ? _i2ilnjuc.DataOrigin.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i3f5hnmb.DivergenceEvent?>()) {
      return (data != null ? _i3f5hnmb.DivergenceEvent.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ipxcqqyf.ElectionSummary?>()) {
      return (data != null ? _ipxcqqyf.ElectionSummary.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i0m7v5qb.FileNotStoredException?>()) {
      return (data != null
              ? _i0m7v5qb.FileNotStoredException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ikk6q8b9.FileVerification?>()) {
      return (data != null ? _ikk6q8b9.FileVerification.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_izw8z7ou.Greeting?>()) {
      return (data != null ? _izw8z7ou.Greeting.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i49o1wen.ListReport?>()) {
      return (data != null ? _i49o1wen.ListReport.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i5q61ine.LiveStatus?>()) {
      return (data != null ? _i5q61ine.LiveStatus.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i663s1cn.MunicipioRef?>()) {
      return (data != null ? _i663s1cn.MunicipioRef.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ie6yu1i3.OfficeReport?>()) {
      return (data != null ? _ie6yu1i3.OfficeReport.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i1vi4thm.ReplayNight?>()) {
      return (data != null ? _i1vi4thm.ReplayNight.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i6npibdt.ReplayUnavailableException?>()) {
      return (data != null
              ? _i6npibdt.ReplayUnavailableException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ihi5zekk.ResultFile?>()) {
      return (data != null ? _ihi5zekk.ResultFile.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i4dv59av.ResultSnapshot?>()) {
      return (data != null ? _i4dv59av.ResultSnapshot.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ip5wxoe5.ResultUnavailable?>()) {
      return (data != null ? _ip5wxoe5.ResultUnavailable.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_idhahere.SeatCheck?>()) {
      return (data != null ? _idhahere.SeatCheck.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i1fk3nml.SectionCheck?>()) {
      return (data != null ? _i1fk3nml.SectionCheck.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i4rww364.SectionFile?>()) {
      return (data != null ? _i4rww364.SectionFile.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_igdizl70.SectionFileInfo?>()) {
      return (data != null ? _igdizl70.SectionFileInfo.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iakf100n.SectionNotFoundException?>()) {
      return (data != null
              ? _iakf100n.SectionNotFoundException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i64rlb21.SectionReport?>()) {
      return (data != null ? _i64rlb21.SectionReport.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i8oamffp.SectionUnavailableException?>()) {
      return (data != null
              ? _i8oamffp.SectionUnavailableException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iomwgc6v.SignatureStatus?>()) {
      return (data != null ? _iomwgc6v.SignatureStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iiyd8otz.TallyFrame?>()) {
      return (data != null ? _iiyd8otz.TallyFrame.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i4neo0h8.TimelinePoint?>()) {
      return (data != null ? _i4neo0h8.TimelinePoint.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_icbf2ppq.UfProgress?>()) {
      return (data != null ? _icbf2ppq.UfProgress.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i343iyih.UrnaSignature?>()) {
      return (data != null ? _i343iyih.UrnaSignature.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iuhijha9.VotoResult?>()) {
      return (data != null ? _iuhijha9.VotoResult.fromJson(data) : null) as T;
    }
    if (t == List<_iuhijha9.VotoResult>) {
      return (data as List)
              .map((e) => deserialize<_iuhijha9.VotoResult>(e))
              .toList()
          as T;
    }
    if (t == List<_i49o1wen.ListReport>) {
      return (data as List)
              .map((e) => deserialize<_i49o1wen.ListReport>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i4neo0h8.TimelinePoint>) {
      return (data as List)
              .map((e) => deserialize<_i4neo0h8.TimelinePoint>(e))
              .toList()
          as T;
    }
    if (t == List<_i3f5hnmb.DivergenceEvent>) {
      return (data as List)
              .map((e) => deserialize<_i3f5hnmb.DivergenceEvent>(e))
              .toList()
          as T;
    }
    if (t == List<_i8xvblpk.CandidateReport>) {
      return (data as List)
              .map((e) => deserialize<_i8xvblpk.CandidateReport>(e))
              .toList()
          as T;
    }
    if (t == List<_ixvsuy9r.CandidateTally>) {
      return (data as List)
              .map((e) => deserialize<_ixvsuy9r.CandidateTally>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<List<_ixvsuy9r.CandidateTally>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_ixvsuy9r.CandidateTally>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i4rww364.SectionFile>) {
      return (data as List)
              .map((e) => deserialize<_i4rww364.SectionFile>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<List<_i4rww364.SectionFile>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i4rww364.SectionFile>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i77b8h6f.CargoResult>) {
      return (data as List)
              .map((e) => deserialize<_i77b8h6f.CargoResult>(e))
              .toList()
          as T;
    }
    if (t == List<_igdizl70.SectionFileInfo>) {
      return (data as List)
              .map((e) => deserialize<_igdizl70.SectionFileInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_iurxdm15.CandidateVotes>) {
      return (data as List)
              .map((e) => deserialize<_iurxdm15.CandidateVotes>(e))
              .toList()
          as T;
    }
    if (t == List<_icbf2ppq.UfProgress>) {
      return (data as List)
              .map((e) => deserialize<_icbf2ppq.UfProgress>(e))
              .toList()
          as T;
    }
    if (t == List<_ipzn9brv.TimelinePoint>) {
      return (data as List)
              .map((e) => deserialize<_ipzn9brv.TimelinePoint>(e))
              .toList()
          as T;
    }
    if (t == List<_ivdor3em.DivergenceEvent>) {
      return (data as List)
              .map((e) => deserialize<_ivdor3em.DivergenceEvent>(e))
              .toList()
          as T;
    }
    if (t == List<_i35jelvf.ElectionSummary>) {
      return (data as List)
              .map((e) => deserialize<_i35jelvf.ElectionSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_iawxlp65.MunicipioRef>) {
      return (data as List)
              .map((e) => deserialize<_iawxlp65.MunicipioRef>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i4bcni6a.FileVerification>) {
      return (data as List)
              .map((e) => deserialize<_i4bcni6a.FileVerification>(e))
              .toList()
          as T;
    }
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _ijbwnxcy.BuCheck => 'BuCheck',
      _irnb9urg.Candidate => 'Candidate',
      _i8xvblpk.CandidateReport => 'CandidateReport',
      _ixvsuy9r.CandidateTally => 'CandidateTally',
      _iurxdm15.CandidateVotes => 'CandidateVotes',
      _i77b8h6f.CargoResult => 'CargoResult',
      _igvtxk1g.ChamberReport => 'ChamberReport',
      _i2ilnjuc.DataOrigin => 'DataOrigin',
      _i3f5hnmb.DivergenceEvent => 'DivergenceEvent',
      _ipxcqqyf.ElectionSummary => 'ElectionSummary',
      _i0m7v5qb.FileNotStoredException => 'FileNotStoredException',
      _ikk6q8b9.FileVerification => 'FileVerification',
      _izw8z7ou.Greeting => 'Greeting',
      _i49o1wen.ListReport => 'ListReport',
      _i5q61ine.LiveStatus => 'LiveStatus',
      _i663s1cn.MunicipioRef => 'MunicipioRef',
      _ie6yu1i3.OfficeReport => 'OfficeReport',
      _i1vi4thm.ReplayNight => 'ReplayNight',
      _i6npibdt.ReplayUnavailableException => 'ReplayUnavailableException',
      _ihi5zekk.ResultFile => 'ResultFile',
      _i4dv59av.ResultSnapshot => 'ResultSnapshot',
      _ip5wxoe5.ResultUnavailable => 'ResultUnavailable',
      _idhahere.SeatCheck => 'SeatCheck',
      _i1fk3nml.SectionCheck => 'SectionCheck',
      _i4rww364.SectionFile => 'SectionFile',
      _igdizl70.SectionFileInfo => 'SectionFileInfo',
      _iakf100n.SectionNotFoundException => 'SectionNotFoundException',
      _i64rlb21.SectionReport => 'SectionReport',
      _i8oamffp.SectionUnavailableException => 'SectionUnavailableException',
      _iomwgc6v.SignatureStatus => 'SignatureStatus',
      _iiyd8otz.TallyFrame => 'TallyFrame',
      _i4neo0h8.TimelinePoint => 'TimelinePoint',
      _icbf2ppq.UfProgress => 'UfProgress',
      _i343iyih.UrnaSignature => 'UrnaSignature',
      _iuhijha9.VotoResult => 'VotoResult',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('urna_aberta.', '');
    }

    switch (data) {
      case _ijbwnxcy.BuCheck():
        return 'BuCheck';
      case _irnb9urg.Candidate():
        return 'Candidate';
      case _i8xvblpk.CandidateReport():
        return 'CandidateReport';
      case _ixvsuy9r.CandidateTally():
        return 'CandidateTally';
      case _iurxdm15.CandidateVotes():
        return 'CandidateVotes';
      case _i77b8h6f.CargoResult():
        return 'CargoResult';
      case _igvtxk1g.ChamberReport():
        return 'ChamberReport';
      case _i2ilnjuc.DataOrigin():
        return 'DataOrigin';
      case _i3f5hnmb.DivergenceEvent():
        return 'DivergenceEvent';
      case _ipxcqqyf.ElectionSummary():
        return 'ElectionSummary';
      case _i0m7v5qb.FileNotStoredException():
        return 'FileNotStoredException';
      case _ikk6q8b9.FileVerification():
        return 'FileVerification';
      case _izw8z7ou.Greeting():
        return 'Greeting';
      case _i49o1wen.ListReport():
        return 'ListReport';
      case _i5q61ine.LiveStatus():
        return 'LiveStatus';
      case _i663s1cn.MunicipioRef():
        return 'MunicipioRef';
      case _ie6yu1i3.OfficeReport():
        return 'OfficeReport';
      case _i1vi4thm.ReplayNight():
        return 'ReplayNight';
      case _i6npibdt.ReplayUnavailableException():
        return 'ReplayUnavailableException';
      case _ihi5zekk.ResultFile():
        return 'ResultFile';
      case _i4dv59av.ResultSnapshot():
        return 'ResultSnapshot';
      case _ip5wxoe5.ResultUnavailable():
        return 'ResultUnavailable';
      case _idhahere.SeatCheck():
        return 'SeatCheck';
      case _i1fk3nml.SectionCheck():
        return 'SectionCheck';
      case _i4rww364.SectionFile():
        return 'SectionFile';
      case _igdizl70.SectionFileInfo():
        return 'SectionFileInfo';
      case _iakf100n.SectionNotFoundException():
        return 'SectionNotFoundException';
      case _i64rlb21.SectionReport():
        return 'SectionReport';
      case _i8oamffp.SectionUnavailableException():
        return 'SectionUnavailableException';
      case _iomwgc6v.SignatureStatus():
        return 'SignatureStatus';
      case _iiyd8otz.TallyFrame():
        return 'TallyFrame';
      case _i4neo0h8.TimelinePoint():
        return 'TimelinePoint';
      case _icbf2ppq.UfProgress():
        return 'UfProgress';
      case _i343iyih.UrnaSignature():
        return 'UrnaSignature';
      case _iuhijha9.VotoResult():
        return 'VotoResult';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'BuCheck') {
      return deserialize<_ijbwnxcy.BuCheck>(data['data']);
    }
    if (dataClassName == 'Candidate') {
      return deserialize<_irnb9urg.Candidate>(data['data']);
    }
    if (dataClassName == 'CandidateReport') {
      return deserialize<_i8xvblpk.CandidateReport>(data['data']);
    }
    if (dataClassName == 'CandidateTally') {
      return deserialize<_ixvsuy9r.CandidateTally>(data['data']);
    }
    if (dataClassName == 'CandidateVotes') {
      return deserialize<_iurxdm15.CandidateVotes>(data['data']);
    }
    if (dataClassName == 'CargoResult') {
      return deserialize<_i77b8h6f.CargoResult>(data['data']);
    }
    if (dataClassName == 'ChamberReport') {
      return deserialize<_igvtxk1g.ChamberReport>(data['data']);
    }
    if (dataClassName == 'DataOrigin') {
      return deserialize<_i2ilnjuc.DataOrigin>(data['data']);
    }
    if (dataClassName == 'DivergenceEvent') {
      return deserialize<_i3f5hnmb.DivergenceEvent>(data['data']);
    }
    if (dataClassName == 'ElectionSummary') {
      return deserialize<_ipxcqqyf.ElectionSummary>(data['data']);
    }
    if (dataClassName == 'FileNotStoredException') {
      return deserialize<_i0m7v5qb.FileNotStoredException>(data['data']);
    }
    if (dataClassName == 'FileVerification') {
      return deserialize<_ikk6q8b9.FileVerification>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_izw8z7ou.Greeting>(data['data']);
    }
    if (dataClassName == 'ListReport') {
      return deserialize<_i49o1wen.ListReport>(data['data']);
    }
    if (dataClassName == 'LiveStatus') {
      return deserialize<_i5q61ine.LiveStatus>(data['data']);
    }
    if (dataClassName == 'MunicipioRef') {
      return deserialize<_i663s1cn.MunicipioRef>(data['data']);
    }
    if (dataClassName == 'OfficeReport') {
      return deserialize<_ie6yu1i3.OfficeReport>(data['data']);
    }
    if (dataClassName == 'ReplayNight') {
      return deserialize<_i1vi4thm.ReplayNight>(data['data']);
    }
    if (dataClassName == 'ReplayUnavailableException') {
      return deserialize<_i6npibdt.ReplayUnavailableException>(data['data']);
    }
    if (dataClassName == 'ResultFile') {
      return deserialize<_ihi5zekk.ResultFile>(data['data']);
    }
    if (dataClassName == 'ResultSnapshot') {
      return deserialize<_i4dv59av.ResultSnapshot>(data['data']);
    }
    if (dataClassName == 'ResultUnavailable') {
      return deserialize<_ip5wxoe5.ResultUnavailable>(data['data']);
    }
    if (dataClassName == 'SeatCheck') {
      return deserialize<_idhahere.SeatCheck>(data['data']);
    }
    if (dataClassName == 'SectionCheck') {
      return deserialize<_i1fk3nml.SectionCheck>(data['data']);
    }
    if (dataClassName == 'SectionFile') {
      return deserialize<_i4rww364.SectionFile>(data['data']);
    }
    if (dataClassName == 'SectionFileInfo') {
      return deserialize<_igdizl70.SectionFileInfo>(data['data']);
    }
    if (dataClassName == 'SectionNotFoundException') {
      return deserialize<_iakf100n.SectionNotFoundException>(data['data']);
    }
    if (dataClassName == 'SectionReport') {
      return deserialize<_i64rlb21.SectionReport>(data['data']);
    }
    if (dataClassName == 'SectionUnavailableException') {
      return deserialize<_i8oamffp.SectionUnavailableException>(data['data']);
    }
    if (dataClassName == 'SignatureStatus') {
      return deserialize<_iomwgc6v.SignatureStatus>(data['data']);
    }
    if (dataClassName == 'TallyFrame') {
      return deserialize<_iiyd8otz.TallyFrame>(data['data']);
    }
    if (dataClassName == 'TimelinePoint') {
      return deserialize<_i4neo0h8.TimelinePoint>(data['data']);
    }
    if (dataClassName == 'UfProgress') {
      return deserialize<_icbf2ppq.UfProgress>(data['data']);
    }
    if (dataClassName == 'UrnaSignature') {
      return deserialize<_i343iyih.UrnaSignature>(data['data']);
    }
    if (dataClassName == 'VotoResult') {
      return deserialize<_iuhijha9.VotoResult>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('urna_aberta', this);
    _iacc.Protocol().registerHostProtocol('urna_aberta', this);
  }

  @override
  String getModuleName() => 'urna_aberta';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
