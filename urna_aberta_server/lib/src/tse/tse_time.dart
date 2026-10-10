final _date = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$');
final _time = RegExp(r'^(\d{2}):(\d{2}):(\d{2})$');

/// Parses a TSE date (`dd/mm/yyyy`) and time (`hh:mm:ss`). TSE stamps its
/// files in Brasília time, UTC-3 with no daylight saving; returns UTC.
///
/// Throws [FormatException] when either part is missing or malformed.
DateTime parseTseDateTime(Object? date, Object? time, {String what = 'date'}) {
  final d = date is String ? _date.firstMatch(date) : null;
  final t = time is String ? _time.firstMatch(time) : null;
  if (d == null || t == null) {
    throw FormatException('TSE: bad $what "$date $time"');
  }
  int g(RegExpMatch m, int i) => int.parse(m.group(i)!);
  return DateTime.utc(g(d, 3), g(d, 2), g(d, 1), g(t, 1) + 3, g(t, 2), g(t, 3));
}
