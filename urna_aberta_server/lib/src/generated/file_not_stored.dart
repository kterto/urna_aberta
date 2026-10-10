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

/// No stored file (or no stored signature) has that id.
abstract class FileNotStoredException
    implements
        _is.SerializableException,
        _is.SerializableModel,
        _is.ProtocolSerialization {
  FileNotStoredException._({required this.message});

  factory FileNotStoredException({required String message}) =
      _FileNotStoredExceptionImpl;

  factory FileNotStoredException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return FileNotStoredException(
      message: jsonSerialization['message'] as String,
    );
  }

  String message;

  /// Returns a shallow copy of this [FileNotStoredException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  FileNotStoredException copyWith({String? message});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FileNotStoredException',
      'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FileNotStoredException',
      'message': message,
    };
  }

  @override
  String toString() {
    return 'FileNotStoredException(message: $message)';
  }
}

class _FileNotStoredExceptionImpl extends FileNotStoredException {
  _FileNotStoredExceptionImpl({required String message})
    : super._(message: message);

  /// Returns a shallow copy of this [FileNotStoredException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  FileNotStoredException copyWith({String? message}) {
    return FileNotStoredException(message: message ?? this.message);
  }
}
