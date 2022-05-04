import 'package:cached_network_image/cached_network_image.dart';
import 'package:cardinal/controllers/chat_controller.dart';
import 'package:cardinal/models/user_model.dart';
import 'package:cardinal/providers/auth_provider.dart';
import 'package:cardinal/screens/chat_room.dart';
import 'package:cardinal/theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ChatTile extends StatelessWidget {
  ChatTile({
    Key? key,
    required this.context,
    required this.customTheme,
    required this.theme,
    required this.chat,
  }) : super(key: key);

  final BuildContext context;
  final CustomTheme customTheme;
  final ThemeData theme;
  final ChatTileModel chat;
  EstateChatController estateChatController = EstateChatController();

  @override
  Widget build(BuildContext context) {
    return FxContainer(
      onTap: () async {
        final users = estateChatController.contactedUsers;
        List<String> room = users.map<String>((e) {
          return e.chatRoomId!.contains(uid + '_' + chat.user!.userId!)
              ? uid + '_' + chat.user!.userId!
              : chat.user!.userId! + '_' + uid;
        }).toList();
        final isAgent = await FirebaseFirestore.instance
            .collection('agents')
            .doc(chat.user!.userId!)
            .get();
        if (isAgent.exists) {
          Get.to(() => ChatRoom(ChatTileModel(
                chatRoomId:
                    room.isEmpty ? uid + '_' + chat.user!.userId! : room.first,
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
        } else {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(chat.user!.userId!)
              .get()
              .then((value) {
            Get.to(() => ChatRoom(ChatTileModel(
                  chatRoomId: room.isEmpty
                      ? uid + '_' + chat.user!.userId!
                      : room.first,
                  user: UserModel(
                    userId: value.id,
                    fullName: value['name'],
                    profilePic: value['profilePic'],
                    isAgent: value['isAgent'],
                    phoneNumber: value['phone'],
                    email: value['email'],
                    lastSeen: value['lastSeen'],
                    isOnline: value['isOnline'],
                  ),
                )));
          });
        }
      },
      margin: FxSpacing.bottom(16),
      paddingAll: 16,
      borderRadiusAll: 16,
      child: Row(
        children: [
          Stack(
            children: [
              FxContainer.rounded(
                paddingAll: 0,
                child: Image(
                  height: 54,
                  width: 54,
                  image: CachedNetworkImageProvider(chat.user!.profilePic!),
                ),
              ),
              Positioned(
                right: 4,
                bottom: 2,
                child: FxContainer.rounded(
                  paddingAll: 5,
                  child: Container(),
                  color: customTheme.groceryPrimary,
                ),
              )
            ],
          ),
          FxSpacing.width(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxText.bodyMedium(
                  chat.user!.fullName!,
                  fontWeight: 600,
                ),
                FxSpacing.height(4),
                FxText.bodySmall(
                  chat.latestMessageSenderId == uid
                      ? 'You: ' + chat.latestMessage!
                      : chat.latestMessage!,
                  xMuted: true,
                  muted: false,
                  fontWeight: true ? 400 : 600,
                ),
              ],
            ),
          ),
          FxSpacing.width(8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FxText.bodySmall(
                DateFormat('HH:mm ').format(chat.time!.toDate()),
                fontSize: 10,
                color: theme.colorScheme.onBackground,
                xMuted: true,
              ),
              true
                  ? FxSpacing.height(16)
                  : FxContainer.rounded(
                      paddingAll: 6,
                      color: customTheme.estatePrimary,
                      child: FxText.bodySmall(
                        chat.latestMessage!,
                        fontSize: 10,
                        color: customTheme.estateOnPrimary,
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
