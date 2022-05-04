import 'package:cardinal/providers/agent_provider.dart';
import 'package:cardinal/providers/auth_provider.dart';
import 'package:cardinal/screens/agent/agent_dashboard_controler.dart';
import 'package:cardinal/screens/agent/agent_splash_controller.dart';
import 'package:cardinal/theme/app_theme.dart';

import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:provider/provider.dart';

class AgentSplashScreen extends StatefulWidget {
  const AgentSplashScreen({Key? key}) : super(key: key);

  @override
  _AgentSplashScreenState createState() => _AgentSplashScreenState();
}

class _AgentSplashScreenState extends State<AgentSplashScreen> {
  late ThemeData theme;

  late AgentSplashController controller;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.estateTheme;

    controller = FxControllerStore.putOrFind(AgentSplashController());
  }

  @override
  Widget build(BuildContext context) {
    final agent = Provider.of<AuthProvider>(context, listen: false).agent;

    return FxBuilder<AgentSplashController>(
        controller: controller,
        builder: (controller) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: "splash_username",
                    child: FxText.titleLarge(
                      "Hey ${agent!.agentName!.split(' ')[0]},",
                      fontWeight: 700,
                    ),
                  ),
                  FxText.bodySmall(
                    "Wait here, we are fetching data",
                  ),
                ],
              ),
            ),
          );
        });
  }
}
