import 'dart:io';

import 'package:cardinal/controllers/chat_controller.dart';
import 'package:cardinal/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutx/flutx.dart';

class ChatRoomController extends FxController {
  bool showLoading = true, uiLoading = true;

  late ChatTileModel chat;

  ChatRoomController(this.chat);

  @override
  initState() {
    super.save = false;
    super.initState();
    fetchData();
  }

  void fetchData() async {
    await Future.delayed(const Duration(milliseconds: 100));

    showLoading = false;
    uiLoading = false;
    update();
  }

  Future<void> sendMessage(String userId, MessageModel message) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    String url = '';

    if (message.mediaFiles!.isNotEmpty) {
      await Future.forEach(message.mediaFiles!, (File element) async {
        final fileData = await FirebaseStorage.instance
            .ref('chatFiles/$uid/${DateTime.now().toIso8601String()}')
            .putFile(element);
        url = await fileData.ref.getDownloadURL();
      }).then((_) async {
        final initiator = FirebaseFirestore.instance
            .collection('chats')
            .doc(uid + '_' + userId);
        final receiver = FirebaseFirestore.instance
            .collection('chats')
            .doc(userId + '_' + uid);

        initiator.get().then((value) => {
              if (value.exists)
                {
                  initiator.update({
                    'latestMessage':
                        message.message!.isNotEmpty ? message.message : 'photo',
                    'sentAt': Timestamp.now(),
                    'sentBy': uid,
                  }),
                  initiator.collection('messages').doc().set({
                    'message':
                        message.message!.isNotEmpty ? message.message : 'photo',
                    'sender': uid,
                    'to': userId,
                    'media': url,
                    'mediaType': message.mediaType,
                    'isRead': false,
                    'sentAt': Timestamp.now()
                  })
                }
              else
                {
                  receiver.get().then((value) => {
                        if (value.exists)
                          {
                            receiver.update({
                              'latestMessage': message.message!.isNotEmpty
                                  ? message.message
                                  : 'photo',
                              'sentAt': Timestamp.now(),
                              'sentBy': uid,
                            }),
                            receiver.collection('messages').doc().set({
                              'message': message.message!.isNotEmpty
                                  ? message.message
                                  : 'photo',
                              'sender': uid,
                              'to': userId,
                              'media': url,
                              'mediaType': message.mediaType,
                              'isRead': false,
                              'sentAt': Timestamp.now()
                            })
                          }
                        else
                          {
                            initiator.set({
                              'initiator': uid,
                              'receiver': userId,
                              'startedAt': Timestamp.now(),
                              'latestMessage': message.message!.isNotEmpty
                                  ? message.message
                                  : '',
                              'sentAt': Timestamp.now(),
                              'sentBy': uid,
                            }),
                            initiator.collection('messages').doc().set({
                              'message': message.message ?? '',
                              'sender': uid,
                              'to': userId,
                              'media': url,
                              'mediaType': message.mediaType,
                              'isRead': false,
                              'sentAt': Timestamp.now()
                            }),
                          }
                      })
                }
            });
      });
    } else {
      final initiator = FirebaseFirestore.instance
          .collection('chats')
          .doc(uid + '_' + userId);
      final receiver = FirebaseFirestore.instance
          .collection('chats')
          .doc(userId + '_' + uid);

      initiator.get().then((value) => {
            if (value.exists)
              {
                initiator.update({
                  'latestMessage': message.message ?? 'photo',
                  'sentAt': Timestamp.now(),
                  'sentBy': uid,
                }),
                initiator.collection('messages').doc().set({
                  'message': message.message ?? '',
                  'sender': uid,
                  'to': userId,
                  'media': url,
                  'mediaType': message.mediaType,
                  'isRead': false,
                  'sentAt': Timestamp.now()
                })
              }
            else
              {
                receiver.get().then((value) => {
                      if (value.exists)
                        {
                          receiver.update({
                            'latestMessage': message.message ?? 'photo',
                            'sentAt': Timestamp.now(),
                            'sentBy': uid,
                          }),
                          receiver.collection('messages').doc().set({
                            'message': message.message ?? '',
                            'sender': uid,
                            'to': userId,
                            'media': url,
                            'mediaType': message.mediaType,
                            'isRead': false,
                            'sentAt': Timestamp.now()
                          })
                        }
                      else
                        {
                          initiator.set({
                            'initiator': uid,
                            'receiver': userId,
                            'startedAt': Timestamp.now(),
                            'latestMessage': message.message ?? '',
                            'sentAt': Timestamp.now(),
                            'sentBy': uid,
                          }),
                          initiator.collection('messages').doc().set({
                            'message': message.message ?? '',
                            'sender': uid,
                            'media': url,
                            'to': userId,
                            'mediaType': message.mediaType,
                            'isRead': false,
                            'sentAt': Timestamp.now()
                          }),
                        }
                    })
              }
          });
    }
  }

  @override
  String getTag() {
    return "single_chat_controller";
  }
}
