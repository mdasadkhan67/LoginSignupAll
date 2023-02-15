import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fb_task/const/const.dart';
import 'package:google_fb_task/model/user_signup_model.dart';
import 'package:google_fb_task/ui/chathomescreen/chat_home_page.dart';
import 'package:google_fb_task/ui/login/login_page.dart';
import 'package:google_fb_task/ui/profile_screen/profile_screen.dart';
import 'package:google_fb_task/utils/shared_pref_services.dart';

class SplashRedirect {
  static var firebaseInstaceVar = FirebaseAuth.instance.currentUser;

  static void usedFuture(BuildContext context) async {
    Future.delayed(const Duration(seconds: 3), () {
      // if (firebaseInstaceVar != null) {
      if (Prefs.getBool('isLogin', false) != false) {
        if (firebaseInstaceVar!.photoURL != '') {
          ConstantItems.navigatorPushReplacement(
              context,
              ChatHomeScreen(
                userModel: UserModel(
                  uid: FirebaseAuth.instance.currentUser!.uid,
                  name: FirebaseAuth.instance.currentUser!.displayName ?? '',
                  email: FirebaseAuth.instance.currentUser!.email ?? '',
                  phone: FirebaseAuth.instance.currentUser!.phoneNumber ?? '',
                  imageurl: FirebaseAuth.instance.currentUser!.photoURL ?? '',
                ),
              ));
        } else {
          ConstantItems.navigatorPushReplacement(
              context,
              ProfileScreen(
                userModel: UserModel(
                  uid: FirebaseAuth.instance.currentUser!.uid,
                  name: FirebaseAuth.instance.currentUser!.displayName ?? '',
                  email: FirebaseAuth.instance.currentUser!.email ?? '',
                  phone: FirebaseAuth.instance.currentUser!.phoneNumber ?? '',
                  imageurl: FirebaseAuth.instance.currentUser!.photoURL ?? '',
                ),
              ));
        }
      } else {
        ConstantItems.navigatorPushReplacement(context, const LoginPage());
      }
    });
  }
}
