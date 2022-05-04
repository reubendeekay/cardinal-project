import 'package:cardinal/screens/auth_screen/login_screen.dart';
import 'package:cardinal/screens/search_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

class SplashController extends FxController {
  @override
  String getTag() {
    return "splash_controller";
  }

  void goToSearchScreen() {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(builder: (context) => EstateSearchScreen()),
    );
  }

  void goToLogin() {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(builder: (context) => EstateLoginScreen()),
    );
  }
}
