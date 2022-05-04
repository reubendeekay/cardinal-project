import 'package:cached_network_image/cached_network_image.dart';
import 'package:cardinal/controllers/chat_controller.dart';
import 'package:cardinal/helpers/loading_effect.dart';
import 'package:cardinal/models/message_model.dart';
import 'package:cardinal/providers/auth_provider.dart';
import 'package:cardinal/theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutx/flutx.dart';
import 'package:intl/intl.dart';

import '../controllers/chat_room_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class ChatRoom extends StatefulWidget {
  final ChatTileModel chat;

  const ChatRoom(this.chat, {Key? key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  late ThemeData theme;
  late CustomTheme customTheme;
  late ChatRoomController estateSingleChatController;
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
    estateSingleChatController =
        FxControllerStore.putOrFind(ChatRoomController(widget.chat));
  }

  Widget _buildReceiveMessage(MessageModel message) {
    return Padding(
      padding: FxSpacing.horizontal(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: FxContainer(
              //color: customTheme.medicarePrimary.withAlpha(40),
              margin: FxSpacing.right(140),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FxText.bodySmall(
                    message.message!,
                    color: theme.colorScheme.onBackground,
                    xMuted: true,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FxText.labelSmall(
                      DateFormat('HH:mm ').format(message.sentAt!.toDate()),
                      color: theme.colorScheme.onBackground,
                      xMuted: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendMessage(MessageModel message) {
    return Padding(
      padding: FxSpacing.horizontal(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: FxContainer(
              color: customTheme.estatePrimary,
              margin: FxSpacing.left(140),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FxText.bodySmall(
                    message.message!,
                    color: customTheme.estateOnPrimary,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FxText.labelSmall(
                      DateFormat('HH:mm ').format(message.sentAt!.toDate()),
                      color: customTheme.estateOnPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<ChatRoomController>(
        controller: estateSingleChatController,
        builder: (estateSingleChatController) {
          return Scaffold(
            body: Padding(
              padding: FxSpacing.top(MediaQuery.of(context).padding.top),
              child: Column(
                children: [
                  SizedBox(
                    height: 2,
                    child: estateSingleChatController.showLoading
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
    if (estateSingleChatController.uiLoading) {
      return Container(
          margin: FxSpacing.top(16),
          child: LoadingEffect.getSearchLoadingScreen(
            context,
          ));
    } else {
      return Column(
        children: [
          FxContainer(
            color: theme.scaffoldBackgroundColor,
            child: Row(
              children: [
                InkWell(
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: theme.colorScheme.onBackground,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                FxSpacing.width(8),
                FxContainer.rounded(
                  paddingAll: 0,
                  child: Image(
                    width: 40,
                    height: 40,
                    image: CachedNetworkImageProvider(
                        widget.chat.user!.profilePic!),
                  ),
                ),
                FxSpacing.width(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FxText.bodyMedium(
                        widget.chat.user!.fullName!,
                        fontWeight: 600,
                      ),
                      FxSpacing.height(2),
                      Row(
                        children: [
                          FxContainer.rounded(
                            paddingAll: 3,
                            color: customTheme.groceryPrimary,
                            child: Container(),
                          ),
                          FxSpacing.width(4),
                          FxText.bodySmall(
                            widget.chat.user!.isOnline! ? 'Online' : 'Offline',
                            color: theme.colorScheme.onBackground,
                            xMuted: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                FxSpacing.width(16),
                FxContainer.rounded(
                    color: customTheme.estatePrimary,
                    paddingAll: 8,
                    child: Icon(
                      Icons.videocam_rounded,
                      color: customTheme.estateOnPrimary,
                      size: 16,
                    )),
                FxSpacing.width(8),
                InkWell(
                  onTap: () async {
                    await FlutterPhoneDirectCaller.callNumber(
                        widget.chat.user!.phoneNumber!);
                  },
                  child: FxContainer.rounded(
                    color: customTheme.estatePrimary,
                    paddingAll: 8,
                    child: Icon(
                      Icons.call,
                      color: customTheme.estateOnPrimary,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chats')
                .doc(widget.chat.chatRoomId)
                .collection('messages')
                .orderBy('sentAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              List<DocumentSnapshot> docs = snapshot.data!.docs;

              return ListView(
                reverse: true,
                children: List.generate(docs.length, (index) {
                  final message = MessageModel.fromJson(docs[index]);
                  return message.senderId == uid
                      ? Column(
                          children: [
                            _buildSendMessage(message),
                            FxSpacing.height(16),
                          ],
                        )
                      : Column(
                          children: [
                            _buildReceiveMessage(message),
                            FxSpacing.height(16),
                          ],
                        );
                }),
              );
            },
          )),
          FxContainer(
            margin: FxSpacing.fromLTRB(14, 5, 24, 24),
            paddingAll: 0,
            child: FxTextField(
              controller: messageController,
              focusedBorderColor: customTheme.estatePrimary,
              cursorColor: customTheme.estatePrimary,
              textFieldStyle: FxTextFieldStyle.outlined,
              labelText: 'Type Something ...',
              labelStyle: FxTextStyle.bodySmall(
                  color: theme.colorScheme.onBackground, xMuted: true),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              filled: true,
              fillColor: customTheme.border,
              suffixIcon: InkWell(
                onTap: () {
                  if (messageController.text.isEmpty) {
                    return;
                  }
                  final MessageModel userMessage = MessageModel(
                    senderId: uid,
                    message: messageController.text,
                    mediaFiles: [],
                    mediaType: 'text',
                    isRead: false,
                    receiverId: widget.chat.user!.userId,
                    sentAt: Timestamp.now(),
                  );
                  estateSingleChatController.sendMessage(
                      widget.chat.user!.userId!, userMessage);
                  messageController.clear();
                },
                child: Icon(
                  FeatherIcons.send,
                  color: customTheme.estatePrimary,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
