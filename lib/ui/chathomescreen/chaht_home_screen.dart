import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fb_task/const/const.dart';
import 'package:google_fb_task/utils/chat_screen_utils.dart';
import 'package:google_fb_task/utils/firebase_email_Signup.dart';
import 'package:google_fb_task/utils/login_utils.dart';
import 'package:google_fb_task/utils/shared_pref_services.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  //var firebaseInstanceVar = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  void getUserDetails() async {
    setState(() {
      ChatScreenUtils().getPrefDataInIt();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Screen"),
        actions: [
          IconButton(
            onPressed: ChatScreenUtils().logOut(context),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Column(
        children: [
          Center(child: SizedBox(height: 20)),
          CupertinoButton(
            onPressed: () {},
            color: Theme.of(context).colorScheme.secondary,
            child: Text("Search"),
          )
        ],
      ),
    );
  }
}
