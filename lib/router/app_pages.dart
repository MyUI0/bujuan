import 'package:bujuan/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/login/login.dart';
import '../pages/main/main.dart';

part './app_routes.dart';

final shellNavigatorKey = GlobalKey<NavigatorState>();
final rootNavigatorKey = GlobalKey<NavigatorState>();

abstract class AppPages {
  static final pages = [
    GoRoute(path: Routes.login, builder: (c, s) => const LoginPage()),
    ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) => MainPage(body: child),
        routes: [
          GoRoute(path: Routes.home, builder: (c, s) => const HomePage()),
        ])
  ];
}
