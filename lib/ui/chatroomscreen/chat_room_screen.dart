// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fb_task/const/const.dart';
import 'package:google_fb_task/model/chat_room_model.dart';
import 'package:google_fb_task/model/message_model.dart';
import 'package:google_fb_task/model/user_signup_model.dart';
import 'package:google_fb_task/ui/login/login_page.dart';
import 'package:google_fb_task/utils/chat_screen_utils.dart';
import 'package:google_fb_task/utils/firebase_email_Signup.dart';
import 'package:google_fb_task/utils/login_utils.dart';
import 'package:google_fb_task/utils/shared_pref_services.dart';
import 'package:google_fb_task/widget/background_decoration.dart';
import 'package:uuid/uuid.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModel? targetUser;
  ChatRoom? chatRoom;
  final UserModel userModel;
  ChatRoomPage({
    Key? key,
    this.targetUser,
    this.chatRoom,
    required this.userModel,
  }) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController messageController = TextEditingController();

  void sendMessage() async {
    String msg = messageController.text.trim();
    if (msg != '') {
      MessageModel newMessage = MessageModel(
          messageId: const Uuid().v1(),
          sender: widget.userModel.uid,
          createdob: DateTime.now(),
          text: msg,
          seen: false);

      await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(widget.chatRoom!.chatroomid)
          .collection('messages')
          .doc(newMessage.messageId)
          .set(newMessage.toMap());

      widget.chatRoom!.lastMessage = msg;

      await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(widget.chatRoom!.chatroomid)
          .set(widget.chatRoom!.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.black, Colors.blue]),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.logout_outlined),
              onPressed: (() async {
                var loginType = Prefs.getString('loginBy', '');
                if (loginType == 'google') {
                  LoginUtils.googleLogout(context);
                } else if (loginType == 'facebook') {
                  LoginUtils.facebookLogout(context);
                } else if (loginType == 'phone') {
                  LoginUtils.phoneSignOut(context);
                } else {
                  AuthenticationHelper().signOut(context);
                }
              }),
            ),
          )
        ],
        title: Row(children: [
          CircleAvatar(
            backgroundImage:
                NetworkImage(widget.targetUser!.imageurl.toString()),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(widget.targetUser!.name.toString())
        ]),
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Column(children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chatrooms')
                .doc(widget.chatRoom!.chatroomid)
                .collection('messages')
                .orderBy('createdob', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
                  return Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: dataSnapshot.docs.length,
                      itemBuilder: (context, index) {
                        var currentMessage = MessageModel.fromMap(
                            dataSnapshot.docs[index].data()
                                as Map<String, dynamic>);
                        return Row(
                          mainAxisAlignment:
                              (currentMessage.sender == widget.userModel.uid)
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                          children: [
                            Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                decoration: BackgroundWidgetWithRadius(),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    currentMessage.text.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                )),
                          ],
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text(
                          'Erroe! please check your internet connectivity'));
                } else {
                  return const Center(child: Text('Say Hi to your friend'));
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Row(
            children: [
              Flexible(
                child: TextField(
                  maxLines: null,
                  controller: messageController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter message',
                  ),
                ),
              ),
              const Divider(
                color: Colors.pinkAccent,
                thickness: 1.0,
                height: 2.0,
              ),
              IconButton(
                onPressed: () {
                  sendMessage();
                  messageController.clear();
                },
                icon: const Icon(Icons.send),
                color: Theme.of(context).colorScheme.secondary,
              )
            ],
          )
        ]),
      )),
    );
  }
}
