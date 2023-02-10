import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fb_task/const/const.dart';
import 'package:google_fb_task/ui/home_page.dart';
import 'package:google_fb_task/ui/login/login_page.dart';
import 'package:google_fb_task/utils/shared_pref_services.dart';

class SplashRedirect {
  static var firebaseInstaceVar = FirebaseAuth.instance.currentUser;

  static void usedFuture(BuildContext context) async {
    Future.delayed(const Duration(seconds: 3), () {
      // if (firebaseInstaceVar != null) {
      if (Prefs.getBool('isLogin', false) != false) {
        ConstantItems.navigatorPushReplacement(context, HomePage());
      } else {
        ConstantItems.navigatorPushReplacement(context, const LoginPage());
      }
    });
  }
}
