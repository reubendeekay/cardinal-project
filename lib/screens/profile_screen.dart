import 'package:cached_network_image/cached_network_image.dart';
import 'package:cardinal/controllers/search_controller.dart';
import 'package:cardinal/helpers/time_helper.dart';
import 'package:cardinal/providers/auth_provider.dart';
import 'package:cardinal/screens/agent/agent_registration_screen.dart';
import 'package:cardinal/screens/agent/agent_dashboard.dart';
import 'package:cardinal/screens/agent/post_property_screen.dart';
import 'package:cardinal/screens/agent/agent_splash.dart';
import 'package:cardinal/screens/settings/account_setting_screen.dart';
import 'package:cardinal/screens/settings/notification_setting_screen.dart';
import 'package:cardinal/screens/splash_screen.dart';
import 'package:cardinal/screens/wishlist/wishlist_screen.dart';
import 'package:cardinal/theme/app_theme.dart';
import 'package:cardinal/helpers/loading_effect.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

import '../controllers/profile_controller.dart';

class EstateProfileScreen extends StatefulWidget {
  const EstateProfileScreen({Key? key}) : super(key: key);

  @override
  _EstateProfileScreenState createState() => _EstateProfileScreenState();
}

class _EstateProfileScreenState extends State<EstateProfileScreen> {
  late ThemeData theme;
  late CustomTheme customTheme;

  late EstateProfileController estateProfileController;

  @override
  void initState() {
    super.initState();
    estateProfileController =
        FxControllerStore.putOrFind(EstateProfileController());
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
  }

  Widget _buildSingleRow({String? title, IconData? icon, Function? onTap}) {
    return InkWell(
      onTap: () => onTap!(),
      child: Row(
        children: [
          FxContainer(
            paddingAll: 8,
            borderRadiusAll: 4,
            color: theme.colorScheme.onBackground.withAlpha(20),
            child: Icon(
              icon,
              color: customTheme.estatePrimary,
              size: 20,
            ),
          ),
          FxSpacing.width(16),
          Expanded(
            child: FxText.bodySmall(
              title!,
              letterSpacing: 0.5,
            ),
          ),
          FxSpacing.width(16),
          Icon(
            Icons.keyboard_arrow_right,
            color: theme.colorScheme.onBackground.withAlpha(160),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<EstateProfileController>(
        controller: estateProfileController,
        builder: (estateProfileController) {
          return SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  SizedBox(
                    height: 2,
                    child: estateProfileController.showLoading
                        ? LinearProgressIndicator(
                            color: customTheme.estatePrimary,
                            minHeight: 2,
                          )
                        : Container(
                            height: 2,
                          ),
                  ),
                  Expanded(
                    child: _buildBody(context),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildBody(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).user;

    if (estateProfileController.uiLoading) {
      return Container(
          margin: FxSpacing.top(16),
          child: LoadingEffect.getSearchLoadingScreen(
            context,
          ));
    } else {
      return ListView(
        padding: FxSpacing.all(24),
        children: [
          Center(
            child: FxContainer(
              paddingAll: 0,
              borderRadiusAll: 24,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(24),
                ),
                child: Image(
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                  image: CachedNetworkImageProvider(user!.profilePic!),
                ),
              ),
            ),
          ),
          FxSpacing.height(24),
          FxText.titleLarge(
            user.fullName!,
            textAlign: TextAlign.center,
            fontWeight: 600,
            letterSpacing: 0.8,
          ),
          FxSpacing.height(4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FxContainer.rounded(
                color: customTheme.estatePrimary,
                height: 6,
                width: 6,
                child: Container(),
              ),
              FxSpacing.width(6),
              FxText.labelMedium(
                'Joined since ' + getCreatedAt(user.createdAt!),
                color: customTheme.estatePrimary,
                muted: true,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          FxSpacing.height(24),
          FxText.bodySmall(
            'General',
            color: theme.colorScheme.onBackground,
            xMuted: true,
          ),
          FxSpacing.height(24),
          _buildSingleRow(
              title: 'Profile settings',
              icon: FeatherIcons.user,
              onTap: () {
                Get.to(() => const AccountSettingScreen());
              }),
          FxSpacing.height(8),
          const Divider(),
          FxSpacing.height(8),
          _buildSingleRow(
              title: user.isAgent! ? 'Agent Dashboard' : 'Agent Registration',
              icon: FeatherIcons.creditCard,
              onTap: () {
                Get.to(() => user.isAgent!
                    ? const AgentSplashScreen()
                    : const AgentRegistrationScreen());
              }),
          FxSpacing.height(8),
          const Divider(),
          FxSpacing.height(8),
          _buildSingleRow(title: 'Password', icon: FeatherIcons.lock),
          FxSpacing.height(8),
          const Divider(),
          FxSpacing.height(8),
          _buildSingleRow(
              title: 'Wishlist',
              icon: Icons.favorite_border_outlined,
              onTap: () {
                Get.to(() => const WishlistScreen());
              }),
          FxSpacing.height(8),
          const Divider(),
          FxSpacing.height(8),
          _buildSingleRow(
              title: 'Notifications',
              icon: FeatherIcons.bell,
              onTap: () {
                Get.to(() => const NotificationSettingScreen());
              }),
          FxSpacing.height(8),
          const Divider(),
          FxSpacing.height(8),
          _buildSingleRow(
              title: 'Logout',
              icon: FeatherIcons.logOut,
              onTap: () async {
                Get.offAll(() => const EstateSplashScreen());
                await FirebaseAuth.instance.signOut();
              }),
        ],
      );
    }
  }
}
