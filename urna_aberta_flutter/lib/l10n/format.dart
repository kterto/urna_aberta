import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../replay/replay_controller.dart' show brasilia;

/// Numbers and times in the viewer's language: `1.234` and `64,81%` in
/// Portuguese, `1,234` and `64.81%` in English. Clock times are always
/// Brasília time, 24-hour.
extension AtlasFormat on BuildContext {
  String get _tag => Localizations.localeOf(this).toLanguageTag();

  String integer(int v) => NumberFormat.decimalPattern(_tag).format(v);

  String decimal(num v, int digits) =>
      (NumberFormat.decimalPattern(_tag)
            ..minimumFractionDigits = digits
            ..maximumFractionDigits = digits)
          .format(v);

  String percent(num v, [int digits = 2]) => '${decimal(v, digits)}%';

  /// `21:40`, Brasília time.
  String hm(DateTime utc) => DateFormat.Hm(_tag).format(brasilia(utc));

  /// `05/10 12:51` / `Oct 5, 12:51`, Brasília time.
  String dayHm(DateTime utc) {
    final b = brasilia(utc);
    final time = DateFormat.Hm(_tag).format(b);
    return Localizations.localeOf(this).languageCode == 'pt'
        ? '${DateFormat('dd/MM', _tag).format(b)} $time'
        : '${DateFormat.MMMd(_tag).format(b)}, $time';
  }
}
