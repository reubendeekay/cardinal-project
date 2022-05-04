import 'package:cardinal/providers/agent_provider.dart';
import 'package:cardinal/screens/agent/dashboard_action_model.dart';
import 'package:cardinal/screens/agent/agent_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutx/core/state_management/controller.dart';
import 'package:provider/provider.dart';

class AgentSplashController extends FxController {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await Provider.of<AgentProvider>(context, listen: false)
          .getAgentProperties(FirebaseAuth.instance.currentUser!.uid);
      goToDashboard();
    });
  }

  goToDashboard() async {
    getAgentActions();
    await Future.delayed(const Duration(seconds: 1));

    Navigator.of(context, rootNavigator: true).pushReplacement(
      PageRouteBuilder(
          transitionDuration: const Duration(seconds: 2),
          pageBuilder: (_, __, ___) => const AgentDashboard()),
    );
  }

  @override
  String getTag() {
    return "splash_screen_2";
  }
}
