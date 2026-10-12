/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:urna_aberta_server/src/generated/protocol.dart' as _iyugoj1j;

/// An ordinary election TSE lists in EA11, with the offices it elects.
abstract class ElectionSummary
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ElectionSummary._({
    required this.code,
    required this.round,
    required this.day,
    required this.name,
    required this.level,
    required this.offices,
    required this.allMunicipalities,
    required this.municipalScopes,
  });

  factory ElectionSummary({
    required int code,
    required int round,
    required DateTime day,
    required String name,
    required String level,
    required List<int> offices,
    required bool allMunicipalities,
    required List<String> municipalScopes,
  }) = _ElectionSummaryImpl;

  factory ElectionSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return ElectionSummary(
      code: jsonSerialization['code'] as int,
      round: jsonSerialization['round'] as int,
      day: _is.DateTimeJsonExtension.fromJson(jsonSerialization['day']),
      name: jsonSerialization['name'] as String,
      level: jsonSerialization['level'] as String,
      offices: _iyugoj1j.Protocol().deserialize<List<int>>(
        jsonSerialization['offices'],
      ),
      allMunicipalities: _is.BoolJsonExtension.fromJson(
        jsonSerialization['allMunicipalities'],
      ),
      municipalScopes: _iyugoj1j.Protocol().deserialize<List<String>>(
        jsonSerialization['municipalScopes'],
      ),
    );
  }

  int code;

  int round;

  /// Election day (Brasília calendar), at 00:00 UTC.
  DateTime day;

  String name;

  /// `federal`, `state` or `municipal`.
  String level;

  /// TSE office codes, e.g. 6 Deputado Federal, 13 Vereador.
  List<int> offices;

  /// Municipal elections held everywhere: the municipality list is EA12.
  bool allMunicipalities;

  /// Otherwise, the municipality scopes it covers (`sp71072`), if any.
  List<String> municipalScopes;

  /// Returns a shallow copy of this [ElectionSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ElectionSummary copyWith({
    int? code,
    int? round,
    DateTime? day,
    String? name,
    String? level,
    List<int>? offices,
    bool? allMunicipalities,
    List<String>? municipalScopes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ElectionSummary',
      'code': code,
      'round': round,
      'day': day.toJson(),
      'name': name,
      'level': level,
      'offices': offices.toJson(),
      'allMunicipalities': allMunicipalities,
      'municipalScopes': municipalScopes.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ElectionSummary',
      'code': code,
      'round': round,
      'day': day.toJson(),
      'name': name,
      'level': level,
      'offices': offices.toJson(),
      'allMunicipalities': allMunicipalities,
      'municipalScopes': municipalScopes.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ElectionSummaryImpl extends ElectionSummary {
  _ElectionSummaryImpl({
    required int code,
    required int round,
    required DateTime day,
    required String name,
    required String level,
    required List<int> offices,
    required bool allMunicipalities,
    required List<String> municipalScopes,
  }) : super._(
         code: code,
         round: round,
         day: day,
         name: name,
         level: level,
         offices: offices,
         allMunicipalities: allMunicipalities,
         municipalScopes: municipalScopes,
       );

  /// Returns a shallow copy of this [ElectionSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ElectionSummary copyWith({
    int? code,
    int? round,
    DateTime? day,
    String? name,
    String? level,
    List<int>? offices,
    bool? allMunicipalities,
    List<String>? municipalScopes,
  }) {
    return ElectionSummary(
      code: code ?? this.code,
      round: round ?? this.round,
      day: day ?? this.day,
      name: name ?? this.name,
      level: level ?? this.level,
      offices: offices ?? this.offices.map((e0) => e0).toList(),
      allMunicipalities: allMunicipalities ?? this.allMunicipalities,
      municipalScopes:
          municipalScopes ?? this.municipalScopes.map((e0) => e0).toList(),
    );
  }
}
