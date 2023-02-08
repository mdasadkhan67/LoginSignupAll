import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fb_task/const/const.dart';
import 'package:google_fb_task/ui/home_page.dart';
import 'package:google_fb_task/ui/login/login_page.dart';

class SplashRedirect {
  static var firebaseInstaceVar = FirebaseAuth.instance.currentUser;

  static void usedFuture(BuildContext context) async {
    Future.delayed(const Duration(seconds: 3), () {
      if (firebaseInstaceVar != null) {
        if (firebaseInstaceVar!.photoURL != null) {
          ConstantItems.navigatorPushReplacement(
              context,
              HomePage(
                fbImageUrl: firebaseInstaceVar!.photoURL.toString(),
              ));
        } else {
          ConstantItems.navigatorPushReplacement(
              context,
              HomePage(
                fbImageUrl:
                    'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png',
              ));
        }
      } else {
        ConstantItems.navigatorPushReplacement(context, const LoginPage());
      }
    });
  }
}
