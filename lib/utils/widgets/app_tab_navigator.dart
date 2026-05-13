import 'package:flutter/material.dart';

class AppTabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget rootPage;

  const AppTabNavigator({
    super.key,
    required this.navigatorKey,
    required this.rootPage,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (_) {
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/'),
          builder: (_) => rootPage,
        );
      },
    );
  }
}