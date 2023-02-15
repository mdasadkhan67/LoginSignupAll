// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fb_task/const/const.dart';
import 'package:google_fb_task/model/chat_room_model.dart';
import 'package:google_fb_task/model/firebase_helper.dart';
import 'package:google_fb_task/model/user_signup_model.dart';
import 'package:google_fb_task/ui/chatroomscreen/chat_room_screen.dart';
import 'package:google_fb_task/ui/chatsearchscreen/chaht_search_screen.dart';
import 'package:google_fb_task/ui/login/login_page.dart';
import 'package:google_fb_task/utils/chat_screen_utils.dart';
import 'package:google_fb_task/utils/firebase_email_Signup.dart';
import 'package:google_fb_task/utils/login_utils.dart';
import 'package:google_fb_task/utils/shared_pref_services.dart';
import 'package:google_fb_task/widget/background_decoration.dart';

class ChatHomeScreen extends StatefulWidget {
  final UserModel? userModel;
  const ChatHomeScreen({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  ChatRoom? chatRoomModel;

  Future<ChatRoom> getChatRoomModel(UserModel targetUser) async {
    ChatRoom chatRoom = ChatRoom();
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('chatrooms')
        .where("participants.${widget.userModel!.uid}", isEqualTo: true)
        .where(
          "participants.${targetUser.uid}",
          isEqualTo: true,
        )
        .get();
    if (snapshot.docs.isNotEmpty) {
      //fetch existing one
      Map<String, dynamic> docData =
          snapshot.docs[0].data() as Map<String, dynamic>;
      ChatRoom existingChatRoom =
          ChatRoom.fromMap(docData as Map<String, dynamic>);
      chatRoom.chatroomid = docData['chatroomid'];
    }

    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BackgroundWidget(),
        ),
        title: const Text('Chat Task App'),
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
      ),
      body: SafeArea(
        child: Container(
          decoration: BackgroundWidget(),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chatrooms')
                .where("participants.${widget.userModel?.uid}", isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot chatRoomSnapShot =
                      snapshot.data as QuerySnapshot;
                  return ListView.builder(
                    itemCount: chatRoomSnapShot.docs.length,
                    itemBuilder: (context, index) {
                      ChatRoom chatRoomModel = ChatRoom();
                      chatRoomModel = ChatRoom.fromMap(
                          chatRoomSnapShot.docs[index].data()
                              as Map<String, dynamic>);
                      Map<String, dynamic> participants =
                          chatRoomModel.participants!;
                      //Get Key By Map In String
                      List<String> participantsKeys =
                          participants.keys.toList();
                      //Remove Our Name From List
                      participantsKeys.remove(widget.userModel?.uid);
                      // return Text("Asad Khan");
                      return FutureBuilder(
                        future: FirebaseHelper.getUserModelById(
                            participantsKeys[0]),
                        builder: (context, userData) {
                          if (userData.connectionState ==
                              ConnectionState.done) {
                            if (userData.data != null) {
                              UserModel targetUser = userData.data as UserModel;
                              return Card(
                                child: ListTile(
                                  onTap: (() async {
                                    await getChatRoomModel(targetUser).then(
                                        (value) {
                                      chatRoomModel.chatroomid =
                                          value.chatroomid;
                                    }).then(
                                        (value) => ConstantItems.navigatorPush(
                                            context,
                                            ChatRoomPage(
                                              userModel: widget.userModel!,
                                              targetUser: targetUser,
                                              chatRoom: chatRoomModel,
                                            )));
                                  }),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      targetUser.imageurl.toString(),
                                    ),
                                  ),
                                  title: Text(
                                    targetUser.name.toString(),
                                  ),
                                  subtitle: Text(
                                    (snapshot.data!.docs[index]
                                                .data()['lastMessage'] !=
                                            '')
                                        ? snapshot.data!.docs[index]
                                            .data()['lastMessage']
                                            .toString()
                                        : targetUser.email.toString(),
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
                          }
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.hasError.toString()),
                  );
                } else {
                  return const Center(
                    child: Text('No chat'),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ConstantItems.navigatorPush(
              context,
              ChatHomePage(
                userModel: UserModel(
                    uid: FirebaseAuth.instance.currentUser!.uid,
                    name: FirebaseAuth.instance.currentUser!.displayName,
                    email: FirebaseAuth
                            .instance.currentUser!.providerData[0].email ??
                        FirebaseAuth.instance.currentUser!.email,
                    phone: FirebaseAuth.instance.currentUser!.phoneNumber ?? '',
                    imageurl: FirebaseAuth.instance.currentUser!.photoURL),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
