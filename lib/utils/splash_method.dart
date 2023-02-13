import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fb_task/const/const.dart';
import 'package:google_fb_task/ui/chathomescreen/chaht_home_screen.dart';
import 'package:google_fb_task/ui/login/login_page.dart';
import 'package:google_fb_task/ui/profile_screen/profile_screen.dart';
import 'package:google_fb_task/utils/shared_pref_services.dart';

class SplashRedirect {
  static var firebaseInstaceVar = FirebaseAuth.instance.currentUser;

  static void usedFuture(BuildContext context) async {
    Future.delayed(const Duration(seconds: 3), () {
      // if (firebaseInstaceVar != null) {
      if (Prefs.getBool('isLogin', false) != false &&
          Prefs.getString('imageurl', '') != null) {
        ConstantItems.navigatorPushReplacement(context, const ChatHomePage());
      } else if (Prefs.getBool('isLogin', false) != false &&
          (Prefs.getString('imageurl', '') == null ||
              Prefs.getString('imageurl', '') == '')) {
        ConstantItems.navigatorPushReplacement(context, const ProfileScreen());
      } else {
        ConstantItems.navigatorPushReplacement(context, const LoginPage());
      }
    });
  }
}
