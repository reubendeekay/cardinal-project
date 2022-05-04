import 'package:cardinal/helpers/loading_effect.dart';
import 'package:cardinal/screens/chat/widgets/chat_tile.dart';
import 'package:cardinal/screens/chat_room.dart';
import 'package:cardinal/theme/app_theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';

import '../controllers/chat_controller.dart';
import '../models/chat.dart';

class EstateChatScreen extends StatefulWidget {
  const EstateChatScreen({Key? key}) : super(key: key);

  @override
  _EstateChatScreenState createState() => _EstateChatScreenState();
}

class _EstateChatScreenState extends State<EstateChatScreen> {
  late ThemeData theme;
  late CustomTheme customTheme;

  late EstateChatController estateChatController;

  @override
  void initState() {
    super.initState();
    estateChatController = FxControllerStore.putOrFind(EstateChatController());
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
  }

  List<Widget> _buildChatList() {
    List<Widget> list = [];

    list.add(FxSpacing.width(16));

    for (ChatTileModel chat in estateChatController.contactedUsers) {
      list.add(ChatTile(
          context: context,
          customTheme: customTheme,
          theme: theme,
          chat: chat));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<EstateChatController>(
        controller: estateChatController,
        builder: (estateHomeController) {
          return SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  SizedBox(
                    height: 2,
                    child: estateHomeController.showLoading
                        ? LinearProgressIndicator(
                            color: customTheme.estatePrimary,
                            minHeight: 2,
                          )
                        : Container(
                            height: 2,
                          ),
                  ),
                  Expanded(
                    child: _buildBody(),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildBody() {
    if (estateChatController.uiLoading) {
      return Container(
          margin: FxSpacing.top(16),
          child: LoadingEffect.getSearchLoadingScreen(
            context,
          ));
    } else {
      return ListView(
        padding: FxSpacing.horizontal(
          24,
        ),
        children: [
          FxSpacing.height(16),
          Center(
            child: FxText.bodyLarge(
              'Chats',
              fontWeight: 700,
            ),
          ),
          FxSpacing.height(16),
          FxTextField(
            textFieldStyle: FxTextFieldStyle.outlined,
            labelText: 'Search your agent',
            focusedBorderColor: customTheme.estatePrimary,
            cursorColor: customTheme.estatePrimary,
            labelStyle: FxTextStyle.bodySmall(
                color: theme.colorScheme.onBackground, xMuted: true),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: customTheme.estatePrimary.withAlpha(40),
            suffixIcon: Icon(
              FeatherIcons.search,
              color: customTheme.estatePrimary,
              size: 20,
            ),
          ),
          FxSpacing.height(20),
          Column(
            children: _buildChatList(),
          ),
        ],
      );
    }
  }
}
