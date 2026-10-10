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

  /// `19:52`, Brasília time.
  String hm(DateTime utc) => DateFormat.Hm(_tag).format(brasilia(utc));

  /// `25/10` / `Oct 25`, Brasília calendar.
  String day(DateTime utc) {
    final b = brasilia(utc);
    return Localizations.localeOf(this).languageCode == 'pt'
        ? DateFormat('dd/MM', _tag).format(b)
        : DateFormat.MMMd(_tag).format(b);
  }

  /// `05/10 12:51` / `Oct 5, 12:51`, Brasília time.
  String dayHm(DateTime utc) {
    final b = brasilia(utc);
    final time = DateFormat.Hm(_tag).format(b);
    return Localizations.localeOf(this).languageCode == 'pt'
        ? '${DateFormat('dd/MM', _tag).format(b)} $time'
        : '${DateFormat.MMMd(_tag).format(b)}, $time';
  }

  /// `29/09/2026 10:31` / `Sep 29, 2026, 10:31`, Brasília time.
  String dateHm(DateTime utc) {
    final b = brasilia(utc);
    final time = DateFormat.Hm(_tag).format(b);
    return Localizations.localeOf(this).languageCode == 'pt'
        ? '${DateFormat('dd/MM/yyyy', _tag).format(b)} $time'
        : '${DateFormat.yMMMd(_tag).format(b)}, $time';
  }
}
