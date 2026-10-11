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

/// A report spec that cannot be built. The message is Portuguese; the app
/// shows its own text by reason.
abstract class ReportRefused
    implements
        _is.SerializableException,
        _is.SerializableModel,
        _is.ProtocolSerialization {
  ReportRefused._({
    required this.message,
    required this.reason,
  });

  factory ReportRefused({
    required String message,
    required String reason,
  }) = _ReportRefusedImpl;

  factory ReportRefused.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReportRefused(
      message: jsonSerialization['message'] as String,
      reason: jsonSerialization['reason'] as String,
    );
  }

  String message;

  /// `invalidRequest`, `notPublished`, `tooLarge` (over the file limit),
  /// `busy` (the viewer already has a report in the queue) or `notFound`.
  String reason;

  /// Returns a shallow copy of this [ReportRefused]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ReportRefused copyWith({
    String? message,
    String? reason,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReportRefused',
      'message': message,
      'reason': reason,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReportRefused',
      'message': message,
      'reason': reason,
    };
  }

  @override
  String toString() {
    return 'ReportRefused(message: $message, reason: $reason)';
  }
}

class _ReportRefusedImpl extends ReportRefused {
  _ReportRefusedImpl({
    required String message,
    required String reason,
  }) : super._(
         message: message,
         reason: reason,
       );

  /// Returns a shallow copy of this [ReportRefused]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ReportRefused copyWith({
    String? message,
    String? reason,
  }) {
    return ReportRefused(
      message: message ?? this.message,
      reason: reason ?? this.reason,
    );
  }
}
