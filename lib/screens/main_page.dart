import 'package:cardinal/providers/auth_provider.dart';
import 'package:cardinal/providers/location_provider.dart';
import 'package:cardinal/providers/property_provider.dart';
import 'package:cardinal/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'chat_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late CustomTheme customTheme;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
    FxTextStyle.changeFontFamily(GoogleFonts.quicksand);
    FxTextStyle.changeDefaultFontWeight({
      100: FontWeight.w100,
      200: FontWeight.w200,
      300: FontWeight.w300,
      400: FontWeight.w400,
      500: FontWeight.w500,
      600: FontWeight.w600,
      700: FontWeight.w700,
      800: FontWeight.w800,
      900: FontWeight.w900,
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false).getUser(uid);
    Provider.of<LocationProvider>(context, listen: false).getCurrentLocation();

    return Scaffold(
      body: FxBottomNavigationBar(
        activeTitleColor: customTheme.estatePrimary,
        activeContainerColor: customTheme.estatePrimary.withAlpha(50),
        fxBottomNavigationBarType: FxBottomNavigationBarType.containered,
        containerShape: BoxShape.circle,
        showActiveLabel: false,
        showLabel: false,
        activeIconColor: customTheme.estatePrimary,
        iconColor: theme.colorScheme.onBackground.withAlpha(140),
        itemList: [
          FxBottomNavigationBarItem(
            page: const EstateHomeScreen(),
            activeIconData: Icons.other_houses,
            iconData: Icons.other_houses_outlined,
            activeIconSize: 24,
            iconSize: 24,
          ),
          FxBottomNavigationBarItem(
            page: const EstateSearchScreen(),
            activeIconData: Icons.search,
            iconData: Icons.search,
            activeIconSize: 24,
            iconSize: 24,
          ),
          FxBottomNavigationBarItem(
              page: const EstateChatScreen(),
              activeIconData: Icons.chat,
              iconData: Icons.chat_outlined,
              activeIconSize: 22,
              iconSize: 24),
          FxBottomNavigationBarItem(
            page: const EstateProfileScreen(),
            activeIconData: Icons.person,
            iconData: Icons.person_outline,
            activeIconSize: 24,
            iconSize: 24,
          ),
        ],
      ),
    );
  }
}
