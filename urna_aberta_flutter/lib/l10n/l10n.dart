import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

export 'app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// The language the viewer picked; null follows the device.
final localeNotifier = ValueNotifier<Locale?>(null);
