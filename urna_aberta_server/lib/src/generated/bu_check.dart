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

/// How the BU compares with the hash list the urna signed.
enum BuCheck implements _is.SerializableModel {
  /// The BU hashes to the value the urna listed.
  matches,

  /// The BU's bytes hash differently from the urna's list.
  differs,

  /// The urna's signature file does not list this BU.
  notListed,

  /// The urna's list no longer matches the hash it signed.
  listingAltered,

  /// No BU or signature file was available.
  missing;

  static BuCheck fromJson(String name) {
    switch (name) {
      case 'matches':
        return BuCheck.matches;
      case 'differs':
        return BuCheck.differs;
      case 'notListed':
        return BuCheck.notListed;
      case 'listingAltered':
        return BuCheck.listingAltered;
      case 'missing':
        return BuCheck.missing;
      default:
        throw ArgumentError('Value "$name" cannot be converted to "BuCheck"');
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
