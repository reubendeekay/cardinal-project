import 'package:cardinal/helpers/launc_email.dart';
import 'package:cardinal/helpers/loading_effect.dart';
import 'package:cardinal/providers/agent_provider.dart';
import 'package:cardinal/providers/auth_provider.dart';
import 'package:cardinal/screens/agent/all_agents_properties.dart';
import 'package:cardinal/screens/agent/dashboard_action_model.dart';
import 'package:cardinal/screens/agent/agent_dashboard_controler.dart';
import 'package:cardinal/screens/search_screen.dart';
import 'package:cardinal/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class AgentDashboard extends StatefulWidget {
  const AgentDashboard({Key? key}) : super(key: key);

  @override
  _AgentDashboardState createState() => _AgentDashboardState();
}

class _AgentDashboardState extends State<AgentDashboard>
    with TickerProviderStateMixin {
  late ThemeData theme;

  late AgentDashboardController controller;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.estateTheme;

    controller = FxControllerStore.put(AgentDashboardController(this));
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      addActionButtons();
    });
  }

  Widget actionButton(DashboardActionModel category) {
    bool selected = category == controller.selectedCategory;
    bool last = controller.actions!.last == category;
    return FxContainer(
      margin: FxSpacing.right(last ? 0 : 15),
      width: 90,
      onTap: () {
        controller.changeSelectedCategory(category);
        setState(() {});
        category.onTap!();
      },
      borderRadiusAll: 4,
      color: selected ? theme.colorScheme.primaryContainer : null,
      paddingAll: 12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            category.icon,
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.onBackground.withAlpha(220),
          ),
          const SizedBox(height: 5),
          FxText.bodySmall(
            category.name,
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.onBackground.withAlpha(220),
          ),
        ],
      ),
    );
  }

  Future<void> addActionButtons() async {
    Future ft = Future(() {});
    if (controller.newActions.isEmpty) {
      for (int i = 0; i < controller.actions!.length; i++) {
        ft = ft.then((_) {
          return Future.delayed(const Duration(milliseconds: 100), () {
            controller.newActions.add(actionButton(controller.actions![i]));
            controller.listKey.currentState!.insertItem(i);
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<AgentDashboardController>(
        controller: controller,
        builder: (controller) {
          return _buildBody(context);
        });
  }

  Widget _buildBody(BuildContext context) {
    final agent = Provider.of<AuthProvider>(context).agent;
    final properties = Provider.of<AgentProvider>(context).agentProperties;

    if (controller.uiLoading) {
      return Scaffold(
          body: Padding(
        padding: FxSpacing.top(FxSpacing.safeAreaTop(context) + 20),
        child: LoadingEffect.getSearchLoadingScreen(
          context,
        ),
      ));
    } else {
      return WillPopScope(
        onWillPop: () => controller.onWillPop(),
        child: Scaffold(
          body: ListView(
            padding: FxSpacing.fromLTRB(
                20, FxSpacing.safeAreaTop(context) + 20, 20, 0),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Hero(
                    tag: "splash_username",
                    child: FxText.titleLarge(
                      'Hey ' + agent!.agentName!,
                      fontWeight: 700,
                    ),
                  ),
                  RotationTransition(
                    turns: controller.bellAnimation,
                    key: controller.intro.keys[0],
                    child: InkWell(
                      onTap: () {
                        controller.goToNotification();
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            FeatherIcons.bell,
                            color: theme.colorScheme.onBackground,
                            size: 20,
                          ),
                          Positioned(
                            bottom: -2,
                            right: -2,
                            child: FxContainer.rounded(
                              paddingAll: 3,
                              color: theme.colorScheme.primary,
                              child: Center(
                                  child: FxText.bodySmall(
                                '2',
                                color: theme.colorScheme.onPrimary,
                                fontSize: 8,
                              )),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              FxSpacing.height(4),
              FadeTransition(
                opacity: controller.fadeAnimation,
                child: FxText.bodySmall(
                  'Manage your Agency !!',
                  xMuted: true,
                ),
              ),
              FxSpacing.height(20),
              FadeTransition(
                key: controller.intro.keys[1],
                opacity: controller.fadeAnimation,
                child: FxContainer(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  borderRadiusAll: 4,
                  onTap: () {},
                  color: theme.colorScheme.primaryContainer,
                  border: Border.all(color: theme.colorScheme.primaryContainer),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FxText.titleMedium(
                            'Have Queries? \nReach Out',
                            letterSpacing: 0.3,
                            fontWeight: 700,
                            color: theme.colorScheme.primary,
                          ),
                          FxSpacing.height(4),
                          FxButton.small(
                            elevation: 0,
                            padding: FxSpacing.xy(20, 2),
                            borderRadiusAll: 4,
                            backgroundColor: theme.colorScheme.primary,
                            onPressed: () async {
                              await launchEmail('husseinny1705@gmail.com');
                            },
                            child: FxText.labelLarge(
                              'Contact Us',
                              letterSpacing: 0.3,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                      const FxContainer(
                        paddingAll: 0,
                        borderRadiusAll: 4,
                        height: 100,
                        width: 150,
                        clipBehavior: Clip.hardEdge,
                        child: Image(
                          fit: BoxFit.fill,
                          image: AssetImage(
                              'assets/images/apps/shopping2/images/cover_poster_3.jpg'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FxSpacing.height(20),
              FadeTransition(
                opacity: controller.fadeAnimation,
                child: Row(
                  children: [
                    FxText.bodyLarge(
                      'Actions',
                      letterSpacing: 0,
                      fontWeight: 600,
                    ),
                  ],
                ),
              ),
              FxSpacing.height(20),
              SizedBox(
                key: controller.intro.keys[2],
                height: 80,
                child: AnimatedList(
                    scrollDirection: Axis.horizontal,
                    key: controller.listKey,
                    initialItemCount: controller.newActions.length,
                    itemBuilder: (context, index, animation) {
                      return SlideTransition(
                          position: animation.drive(controller.offset),
                          child: controller.newActions[index]);
                    }),
              ),
              FxSpacing.height(20),
              FadeTransition(
                opacity: controller.fadeAnimation,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FxText.bodyLarge(
                      'Your Listings',
                      letterSpacing: 0,
                      fontWeight: 600,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => AllAgentProperies(
                              agent: agent,
                            ));
                      },
                      child: FxText.bodySmall(
                        'VIEW ALL',
                        fontWeight: 700,
                        letterSpacing: 0.3,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              FxSpacing.height(20),
              SingleChildScrollView(
                child: Column(
                  children: List.generate(
                      properties.length,
                      (index) => PropertyTile(
                            properties[index],
                            isAgent: false,
                          )),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
