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

/// How large a place a report covers.
enum ReportPlaceKind implements _is.SerializableModel {
  br,

  /// One of the five IBGE regions.
  regiao,
  uf,
  municipio,
  zona,
  secao;

  static ReportPlaceKind fromJson(String name) {
    switch (name) {
      case 'br':
        return ReportPlaceKind.br;
      case 'regiao':
        return ReportPlaceKind.regiao;
      case 'uf':
        return ReportPlaceKind.uf;
      case 'municipio':
        return ReportPlaceKind.municipio;
      case 'zona':
        return ReportPlaceKind.zona;
      case 'secao':
        return ReportPlaceKind.secao;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "ReportPlaceKind"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
