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

/// Result of checking a TSE file's JWS signature against the pinned key.
enum SignatureStatus implements _is.SerializableModel {
  /// Signed with TSE's published key; the file is exactly what TSE signed.
  valid,

  /// The signature does not match: altered, or not from TSE.
  invalid,

  /// Signed with a key id Urna Aberta does not know.
  unknownKey;

  static SignatureStatus fromJson(String name) {
    switch (name) {
      case 'valid':
        return SignatureStatus.valid;
      case 'invalid':
        return SignatureStatus.invalid;
      case 'unknownKey':
        return SignatureStatus.unknownKey;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "SignatureStatus"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
