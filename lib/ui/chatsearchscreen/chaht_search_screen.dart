// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fb_task/const/const.dart';
import 'package:google_fb_task/model/chat_room_model.dart';
import 'package:google_fb_task/model/user_signup_model.dart';
import 'package:google_fb_task/ui/chatroomscreen/chat_room_screen.dart';
import 'package:google_fb_task/ui/login/login_page.dart';
import 'package:google_fb_task/utils/chat_screen_utils.dart';
import 'package:google_fb_task/utils/firebase_email_Signup.dart';
import 'package:google_fb_task/utils/login_utils.dart';
import 'package:google_fb_task/utils/shared_pref_services.dart';
import 'package:google_fb_task/widget/background_decoration.dart';
import 'package:google_fb_task/widget/button_gradiant.dart';
import 'package:uuid/uuid.dart';

class ChatHomePage extends StatefulWidget {
  UserModel userModel;

  ChatHomePage({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  TextEditingController searchController = TextEditingController();
  var uuid = Uuid();
  ChatRoom? chatRoomModel;

  Future<ChatRoom?> getChatRoomModel(UserModel targetUser) async {
    ChatRoom chatRoom = ChatRoom();
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('chatrooms')
        .where("participants.${widget.userModel.uid}", isEqualTo: true)
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
    } else {
      //create new one
      ChatRoom newChatRoom =
          ChatRoom(chatroomid: uuid.v1(), lastMessage: '', participants: {
        targetUser.uid.toString(): true,
        widget.userModel.uid.toString(): true,
      });
      await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(newChatRoom.chatroomid)
          .set(newChatRoom.toMap());

      chatRoom = newChatRoom;
    }
    return chatRoom;
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  void getUserDetails() async {
    setState(() {
      ChatScreenUtils.getPrefDataInIt();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BackgroundWidget(),
        ),
        title: const Text("Chat Screen"),
        actions: [
          IconButton(
            onPressed: () {
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
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            children: [
              TextFormField(
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: 'Enter your friend email',
                ),
              ),
              const SizedBox(height: 20),
              // CupertinoButton(
              //   onPressed: () {
              //     setState(() {});
              //   },
              //   color: Theme.of(context).colorScheme.secondary,
              //   child: const Text("Search"),
              // ),
              InkWell(
                  onTap: (() {
                    setState(() {});
                  }),
                  child: RadientButton(btnName: 'Search')),
              const SizedBox(height: 20),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('email', isEqualTo: searchController.text)
                      .where('email', isNotEqualTo: widget.userModel.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot dataSnapshot =
                            snapshot.data as QuerySnapshot;
                        if (dataSnapshot.docs.isNotEmpty) {
                          Map<String, dynamic> userMap = dataSnapshot.docs[0]
                              .data() as Map<String, dynamic>;
                          UserModel searchUser = UserModel.fromMap(userMap);

                          return GestureDetector(
                            onTap: () async {
                              chatRoomModel =
                                  await getChatRoomModel(searchUser);
                              if (chatRoomModel != null) {
                                // ignore: use_build_context_synchronously
                                ConstantItems.navigatorPush(
                                    context,
                                    ChatRoomPage(
                                      userModel: widget.userModel,
                                      targetUser: searchUser,
                                      chatRoom: chatRoomModel!,
                                    ));
                              } else {
                                Fluttertoast.showToast(msg: 'error');
                              }
                              // ConstantItems.navigatorPush(
                              //     context,
                              //     ChatRoomPage(
                              //       targetUser: searchUser,
                              //       userModel: widget.userModel!,
                              //       chatRoom: ,
                              //     ));
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                  backgroundColor: Colors.pink,
                                  backgroundImage:
                                      NetworkImage(searchUser.imageurl!)),
                              title: Text(
                                searchUser.name.toString(),
                              ),
                              subtitle: Text(
                                searchUser.email.toString(),
                              ),
                              trailing: const Icon(Icons.keyboard_arrow_right),
                            ),
                          );
                        } else {
                          return const Text('No result found');
                        }
                      } else if (snapshot.hasError) {
                        return const Text('An error occured!');
                      } else {
                        return const Text('No result found');
                      }
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
