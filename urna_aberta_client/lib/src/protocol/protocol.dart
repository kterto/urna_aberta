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
import 'package:urna_aberta_client/src/protocol/timeline_point.dart'
    as _ipzn9brv;
import 'candidate_tally.dart' as _ixvsuy9r;
import 'candidate_votes.dart' as _iurxdm15;
import 'data_origin.dart' as _i2ilnjuc;
import 'divergence_event.dart' as _i3f5hnmb;
import 'greetings/greeting.dart' as _izw8z7ou;
import 'replay_night.dart' as _i1vi4thm;
import 'replay_unavailable.dart' as _i6npibdt;
import 'result_snapshot.dart' as _i4dv59av;
import 'tally_frame.dart' as _iiyd8otz;
import 'timeline_point.dart' as _i4neo0h8;
import 'uf_progress.dart' as _icbf2ppq;
export 'candidate_tally.dart';
export 'candidate_votes.dart';
export 'data_origin.dart';
export 'divergence_event.dart';
export 'greetings/greeting.dart';
export 'replay_night.dart';
export 'replay_unavailable.dart';
export 'result_snapshot.dart';
export 'tally_frame.dart';
export 'timeline_point.dart';
export 'uf_progress.dart';
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

    if (t == _ixvsuy9r.CandidateTally) {
      return _ixvsuy9r.CandidateTally.fromJson(data) as T;
    }
    if (t == _iurxdm15.CandidateVotes) {
      return _iurxdm15.CandidateVotes.fromJson(data) as T;
    }
    if (t == _i2ilnjuc.DataOrigin) {
      return _i2ilnjuc.DataOrigin.fromJson(data) as T;
    }
    if (t == _i3f5hnmb.DivergenceEvent) {
      return _i3f5hnmb.DivergenceEvent.fromJson(data) as T;
    }
    if (t == _izw8z7ou.Greeting) {
      return _izw8z7ou.Greeting.fromJson(data) as T;
    }
    if (t == _i1vi4thm.ReplayNight) {
      return _i1vi4thm.ReplayNight.fromJson(data) as T;
    }
    if (t == _i6npibdt.ReplayUnavailableException) {
      return _i6npibdt.ReplayUnavailableException.fromJson(data) as T;
    }
    if (t == _i4dv59av.ResultSnapshot) {
      return _i4dv59av.ResultSnapshot.fromJson(data) as T;
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
    if (t == _isc.getType<_ixvsuy9r.CandidateTally?>()) {
      return (data != null ? _ixvsuy9r.CandidateTally.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iurxdm15.CandidateVotes?>()) {
      return (data != null ? _iurxdm15.CandidateVotes.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i2ilnjuc.DataOrigin?>()) {
      return (data != null ? _i2ilnjuc.DataOrigin.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i3f5hnmb.DivergenceEvent?>()) {
      return (data != null ? _i3f5hnmb.DivergenceEvent.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_izw8z7ou.Greeting?>()) {
      return (data != null ? _izw8z7ou.Greeting.fromJson(data) : null) as T;
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
    if (t == _isc.getType<_i4dv59av.ResultSnapshot?>()) {
      return (data != null ? _i4dv59av.ResultSnapshot.fromJson(data) : null)
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
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
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
      _ixvsuy9r.CandidateTally => 'CandidateTally',
      _iurxdm15.CandidateVotes => 'CandidateVotes',
      _i2ilnjuc.DataOrigin => 'DataOrigin',
      _i3f5hnmb.DivergenceEvent => 'DivergenceEvent',
      _izw8z7ou.Greeting => 'Greeting',
      _i1vi4thm.ReplayNight => 'ReplayNight',
      _i6npibdt.ReplayUnavailableException => 'ReplayUnavailableException',
      _i4dv59av.ResultSnapshot => 'ResultSnapshot',
      _iiyd8otz.TallyFrame => 'TallyFrame',
      _i4neo0h8.TimelinePoint => 'TimelinePoint',
      _icbf2ppq.UfProgress => 'UfProgress',
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
      case _ixvsuy9r.CandidateTally():
        return 'CandidateTally';
      case _iurxdm15.CandidateVotes():
        return 'CandidateVotes';
      case _i2ilnjuc.DataOrigin():
        return 'DataOrigin';
      case _i3f5hnmb.DivergenceEvent():
        return 'DivergenceEvent';
      case _izw8z7ou.Greeting():
        return 'Greeting';
      case _i1vi4thm.ReplayNight():
        return 'ReplayNight';
      case _i6npibdt.ReplayUnavailableException():
        return 'ReplayUnavailableException';
      case _i4dv59av.ResultSnapshot():
        return 'ResultSnapshot';
      case _iiyd8otz.TallyFrame():
        return 'TallyFrame';
      case _i4neo0h8.TimelinePoint():
        return 'TimelinePoint';
      case _icbf2ppq.UfProgress():
        return 'UfProgress';
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
    if (dataClassName == 'CandidateTally') {
      return deserialize<_ixvsuy9r.CandidateTally>(data['data']);
    }
    if (dataClassName == 'CandidateVotes') {
      return deserialize<_iurxdm15.CandidateVotes>(data['data']);
    }
    if (dataClassName == 'DataOrigin') {
      return deserialize<_i2ilnjuc.DataOrigin>(data['data']);
    }
    if (dataClassName == 'DivergenceEvent') {
      return deserialize<_i3f5hnmb.DivergenceEvent>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_izw8z7ou.Greeting>(data['data']);
    }
    if (dataClassName == 'ReplayNight') {
      return deserialize<_i1vi4thm.ReplayNight>(data['data']);
    }
    if (dataClassName == 'ReplayUnavailableException') {
      return deserialize<_i6npibdt.ReplayUnavailableException>(data['data']);
    }
    if (dataClassName == 'ResultSnapshot') {
      return deserialize<_i4dv59av.ResultSnapshot>(data['data']);
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
