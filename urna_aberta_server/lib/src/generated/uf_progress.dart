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

/// Sections totalized in one UF (or exterior, `zz`).
abstract class UfProgress
    implements _is.SerializableModel, _is.ProtocolSerialization {
  UfProgress._({
    required this.scopeCode,
    required this.sectionsTotal,
    required this.sectionsTotalized,
  });

  factory UfProgress({
    required String scopeCode,
    required int sectionsTotal,
    required int sectionsTotalized,
  }) = _UfProgressImpl;

  factory UfProgress.fromJson(Map<String, dynamic> jsonSerialization) {
    return UfProgress(
      scopeCode: jsonSerialization['scopeCode'] as String,
      sectionsTotal: jsonSerialization['sectionsTotal'] as int,
      sectionsTotalized: jsonSerialization['sectionsTotalized'] as int,
    );
  }

  String scopeCode;

  int sectionsTotal;

  int sectionsTotalized;

  /// Returns a shallow copy of this [UfProgress]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UfProgress copyWith({
    String? scopeCode,
    int? sectionsTotal,
    int? sectionsTotalized,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UfProgress',
      'scopeCode': scopeCode,
      'sectionsTotal': sectionsTotal,
      'sectionsTotalized': sectionsTotalized,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UfProgress',
      'scopeCode': scopeCode,
      'sectionsTotal': sectionsTotal,
      'sectionsTotalized': sectionsTotalized,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _UfProgressImpl extends UfProgress {
  _UfProgressImpl({
    required String scopeCode,
    required int sectionsTotal,
    required int sectionsTotalized,
  }) : super._(
         scopeCode: scopeCode,
         sectionsTotal: sectionsTotal,
         sectionsTotalized: sectionsTotalized,
       );

  /// Returns a shallow copy of this [UfProgress]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UfProgress copyWith({
    String? scopeCode,
    int? sectionsTotal,
    int? sectionsTotalized,
  }) {
    return UfProgress(
      scopeCode: scopeCode ?? this.scopeCode,
      sectionsTotal: sectionsTotal ?? this.sectionsTotal,
      sectionsTotalized: sectionsTotalized ?? this.sectionsTotalized,
    );
  }
}
