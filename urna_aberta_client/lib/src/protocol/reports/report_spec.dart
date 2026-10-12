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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:urna_aberta_client/src/protocol/protocol.dart' as _ihdok87d;
import '../reports/report_breakdown.dart' as _ijhbww5f;
import '../reports/report_place.dart' as _i89t3rc2;

/// What a report covers: every listed office of every listed election that
/// elects it, in every listed place.
abstract class ReportSpec
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ReportSpec._({
    required this.elections,
    required this.offices,
    required this.places,
    required this.breakdown,
    required this.language,
  });

  factory ReportSpec({
    required List<int> elections,
    required List<int> offices,
    required List<_i89t3rc2.ReportPlace> places,
    required _ijhbww5f.ReportBreakdown breakdown,
    required String language,
  }) = _ReportSpecImpl;

  factory ReportSpec.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReportSpec(
      elections: _ihdok87d.Protocol().deserialize<List<int>>(
        jsonSerialization['elections'],
      ),
      offices: _ihdok87d.Protocol().deserialize<List<int>>(
        jsonSerialization['offices'],
      ),
      places: _ihdok87d.Protocol().deserialize<List<_i89t3rc2.ReportPlace>>(
        jsonSerialization['places'],
      ),
      breakdown: _ijhbww5f.ReportBreakdown.fromJson(
        (jsonSerialization['breakdown'] as String),
      ),
      language: jsonSerialization['language'] as String,
    );
  }

  List<int> elections;

  List<int> offices;

  List<_i89t3rc2.ReportPlace> places;

  _ijhbww5f.ReportBreakdown breakdown;

  /// `pt` or `en`.
  String language;

  /// Returns a shallow copy of this [ReportSpec]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ReportSpec copyWith({
    List<int>? elections,
    List<int>? offices,
    List<_i89t3rc2.ReportPlace>? places,
    _ijhbww5f.ReportBreakdown? breakdown,
    String? language,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReportSpec',
      'elections': elections.toJson(),
      'offices': offices.toJson(),
      'places': places.toJson(valueToJson: (v) => v.toJson()),
      'breakdown': breakdown.toJson(),
      'language': language,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReportSpec',
      'elections': elections.toJson(),
      'offices': offices.toJson(),
      'places': places.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'breakdown': breakdown.toJson(),
      'language': language,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ReportSpecImpl extends ReportSpec {
  _ReportSpecImpl({
    required List<int> elections,
    required List<int> offices,
    required List<_i89t3rc2.ReportPlace> places,
    required _ijhbww5f.ReportBreakdown breakdown,
    required String language,
  }) : super._(
         elections: elections,
         offices: offices,
         places: places,
         breakdown: breakdown,
         language: language,
       );

  /// Returns a shallow copy of this [ReportSpec]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ReportSpec copyWith({
    List<int>? elections,
    List<int>? offices,
    List<_i89t3rc2.ReportPlace>? places,
    _ijhbww5f.ReportBreakdown? breakdown,
    String? language,
  }) {
    return ReportSpec(
      elections: elections ?? this.elections.map((e0) => e0).toList(),
      offices: offices ?? this.offices.map((e0) => e0).toList(),
      places: places ?? this.places.map((e0) => e0.copyWith()).toList(),
      breakdown: breakdown ?? this.breakdown,
      language: language ?? this.language,
    );
  }
}
