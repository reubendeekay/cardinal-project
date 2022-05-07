import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cardinal/controllers/chat_controller.dart';
import 'package:cardinal/helpers/loading_effect.dart';
import 'package:cardinal/models/property_model.dart';
import 'package:cardinal/models/user_model.dart';
import 'package:cardinal/providers/agent_provider.dart';
import 'package:cardinal/providers/auth_provider.dart';
import 'package:cardinal/screens/agent/all_agents_properties.dart';
import 'package:cardinal/screens/chat_room.dart';
import 'package:cardinal/theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/route_manager.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/agent_controller.dart';
import '../../models/agent_model.dart';
import '../property_details_screen.dart';

class AgentProfile extends StatefulWidget {
  final AgentModel agent;

  const AgentProfile(this.agent, {Key? key}) : super(key: key);

  @override
  _AgentProfileState createState() => _AgentProfileState();
}

class _AgentProfileState extends State<AgentProfile> {
  late ThemeData theme;
  late CustomTheme customTheme;
  late AgentController estateSingleAgentController;
  late EstateChatController estateChatController;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
    estateSingleAgentController =
        FxControllerStore.putOrFind(AgentController(widget.agent));
    estateChatController = FxControllerStore.putOrFind(EstateChatController());

    estateSingleAgentController.fetchAgentListings();
  }

  Widget propertyTile(PropertyModel property) {
    return FxCard(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PropertyDetailsScreen(property)));
      },
      margin: FxSpacing.right(16),
      width: 200,
      paddingAll: 16,
      borderRadiusAll: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FxContainer(
            paddingAll: 0,
            borderRadiusAll: 8,
            clipBehavior: Clip.hardEdge,
            child: AspectRatio(
              aspectRatio: 16 / 10,
              child: Image(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(property.coverImage!),
              ),
            ),
          ),
          FxSpacing.height(8),
          FxText.bodyLarge(
            property.name!,
            fontWeight: 700,
          ),
          FxSpacing.height(4),
          FxText.bodySmall(
            property.address!,
            xMuted: true,
          ),
          FxSpacing.height(4),
          FxText.bodySmall(
            'KES ' + property.price!,
          ),
        ],
      ),
    );
  }

  List<Widget> agentProperties() {
    List<Widget> list = [];
    list.add(FxSpacing.width(24));

    for (PropertyModel house in estateSingleAgentController.properties!) {
      list.add(propertyTile(house));
      print(house.name);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<AgentController>(
        controller: estateSingleAgentController,
        builder: (estateSingleAgentController) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: FxSpacing.top(5),
                child: Column(
                  children: [
                    SizedBox(
                      height: 2,
                      child: estateSingleAgentController.showLoading
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
            ),
          );
        });
  }

  Widget _buildBody() {
    if (estateSingleAgentController.uiLoading) {
      return Container(
          margin: FxSpacing.top(16),
          child: LoadingEffect.getSearchLoadingScreen(
            context,
          ));
    } else {
      return ListView(
        padding: FxSpacing.top(8),
        children: [
          Padding(
            padding: FxSpacing.horizontal(24),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: FxContainer.bordered(
                    paddingAll: 4,
                    child: Icon(
                      Icons.chevron_left_outlined,
                      color: theme.colorScheme.onBackground.withAlpha(200),
                    ),
                  ),
                ),
                FxSpacing.width(64),
                FxText.bodyLarge(
                  'Agent Profile',
                  fontWeight: 700,
                ),
              ],
            ),
          ),
          FxSpacing.height(24),
          Padding(
            padding: FxSpacing.horizontal(24),
            child: FxContainer(
              paddingAll: 12,
              borderRadiusAll: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      FxContainer(
                        paddingAll: 0,
                        borderRadiusAll: 12,
                        clipBehavior: Clip.hardEdge,
                        child: Image(
                          height: 56,
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                              widget.agent.profilePic!),
                        ),
                      ),
                      FxSpacing.width(16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FxText.bodyLarge(
                            widget.agent.agentName!,
                            fontWeight: 700,
                          ),
                          FxSpacing.height(8),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: theme.colorScheme.onBackground
                                    .withAlpha(180),
                              ),
                              FxSpacing.width(4),
                              FxText.bodySmall(
                                widget.agent.address!,
                                xMuted: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  FxSpacing.height(16),
                  FxText.bodySmall(
                    'Information',
                    fontWeight: 700,
                  ),
                  FxSpacing.height(8),
                  Row(
                    children: [
                      FxContainer.rounded(
                          paddingAll: 4,
                          color: customTheme.estatePrimary.withAlpha(40),
                          child: Icon(
                            Icons.phone,
                            color: customTheme.estatePrimary,
                            size: 14,
                          )),
                      FxSpacing.width(12),
                      FxText.bodySmall(
                        widget.agent.phoneNumber!,
                      ),
                    ],
                  ),
                  FxSpacing.height(8),
                  Row(
                    children: [
                      FxContainer.rounded(
                          paddingAll: 4,
                          color: customTheme.estatePrimary.withAlpha(40),
                          child: Icon(
                            widget.agent.website != null
                                ? MdiIcons.web
                                : Icons.house,
                            color: customTheme.estatePrimary,
                            size: 14,
                          )),
                      FxSpacing.width(12),
                      InkWell(
                        onTap: widget.agent.website == null
                            ? null
                            : () async {
                                await launchUrl(
                                    Uri.parse(widget.agent.website!));
                              },
                        child: FxText.bodySmall(
                          widget.agent.website ??
                              widget.agent.numProperties!.toString() +
                                  ' Listings',
                          style: widget.agent.website == null
                              ? null
                              : TextStyle(
                                  color: customTheme.estatePrimary,
                                  decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                  FxSpacing.height(16),
                  FxText.bodySmall(
                    'About Me',
                    fontWeight: 700,
                  ),
                  FxSpacing.height(8),
                  RichText(
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: widget.agent.description,
                          style: FxTextStyle.bodySmall(
                            color: theme.colorScheme.onBackground,
                            xMuted: true,
                            height: 1.5,
                          )),
                      TextSpan(
                        text: " Read more",
                        style: FxTextStyle.bodySmall(
                          color: customTheme.estatePrimary,
                        ),
                      ),
                    ]),
                  ),
                  FxSpacing.height(16),
                  FxButton.block(
                    padding: FxSpacing.symmetric(horizontal: 24, vertical: 16),
                    onPressed: () async {
                      final users = estateChatController.contactedUsers;
                      List<String> room = users.map<String>((e) {
                        return e.chatRoomId!
                                .contains(uid + '_' + widget.agent.userId!)
                            ? uid + '_' + widget.agent.userId!
                            : widget.agent.userId! + '_' + uid;
                      }).toList();
                      final isAgent = await FirebaseFirestore.instance
                          .collection('agents')
                          .doc(widget.agent.userId!)
                          .get();
                      Get.to(() => ChatRoom(ChatTileModel(
                            chatRoomId: room.isEmpty
                                ? uid + '_' + widget.agent.userId!
                                : room.first,
                            user: UserModel(
                              userId: isAgent.id,
                              fullName: isAgent['agentName'],
                              profilePic: isAgent['profilePic'],
                              isAgent: true,
                              phoneNumber: isAgent['phoneNumber'],
                              email: isAgent['email'],
                              lastSeen: Timestamp.now(),
                              isOnline: true,
                            ),
                          )));
                    },
                    child: FxText.bodyMedium(
                      'Ask A Question',
                      color: customTheme.estateOnPrimary,
                      fontWeight: 700,
                    ),
                    backgroundColor: customTheme.estatePrimary,
                    borderRadiusAll: 12,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
          FxSpacing.height(16),
          Padding(
            padding: FxSpacing.horizontal(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FxText.bodyMedium(
                  'Agent Listings',
                  fontWeight: 700,
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => AllAgentProperies(
                          agent: widget.agent,
                        ));
                  },
                  child: FxText.labelSmall(
                    'See All',
                    xMuted: true,
                  ),
                ),
              ],
            ),
          ),
          FxSpacing.height(16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: agentProperties(),
            ),
          ),
        ],
      );
    }
  }
}
