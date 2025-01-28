import 'package:flutter/material.dart';
import 'package:sampple_app2/pages/form.dart';
import 'package:sampple_app2/pages/homescreen.dart';
import 'package:sampple_app2/pages/login_page.dart';
import 'package:sampple_app2/pages/register_page.dart';

class NavigationService {
  late GlobalKey<NavigatorState> _navigatorKey;

  final Map<String, Widget Function(BuildContext)> _routes = {
    "/login": (context) => const LoginPage(),
    "/register": (context) => const RegisterPage(),
    "/home": (context) => const HomeScreen(),
  };

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  Map<String, Widget Function(BuildContext)> get routes => _routes;

  NavigationService() {
    _navigatorKey = GlobalKey<NavigatorState>();
  }

  void pushNamed(String routeName) {
    _navigatorKey.currentState?.pushNamed(routeName);
  }

  void pushReplacementNamed(String routeName) {
    _navigatorKey.currentState?.pushReplacementNamed(routeName);
  }

  void goBack() {
    return _navigatorKey.currentState?.pop();
  }
}