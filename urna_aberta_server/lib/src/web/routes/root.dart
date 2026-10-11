import 'package:serverpod/serverpod.dart';

/// The site root opens the Flutter web app.
class RootRoute extends WidgetRoute {
  @override
  Future<WebWidget> build(Session session, Request request) async =>
      RedirectWidget(url: '/app/');
}
