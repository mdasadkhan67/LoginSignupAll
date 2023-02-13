import 'package:flutter/cupertino.dart';
import 'package:google_fb_task/utils/firebase_email_Signup.dart';
import 'package:google_fb_task/utils/login_utils.dart';
import 'package:google_fb_task/utils/shared_pref_services.dart';

class ChatScreenUtils {
  String userName = '';
  String userEmail = '';
  int userPhone = 0;
  String userProfile = '';
  String loginBy = '';

  getPrefDataInIt() {
    loginBy = Prefs.getString('loginBy', '')!;
    userName = Prefs.getString('name', '')!;
    userEmail = Prefs.getString('email', '')!;
    userProfile = Prefs.getString('imageurl', '')!;
    userPhone = Prefs.getInt('phone', 0)!;
  }

  logOut(BuildContext context) {
    return (() {
      if (loginBy == 'google') {
        LoginUtils.googleLogout(context);
      } else if (loginBy == 'facebook') {
        LoginUtils.facebookLogout(context);
      } else if (loginBy == 'phone') {
        LoginUtils.phoneSignOut(context);
      } else {
        AuthenticationHelper().signOut(context);
      }
    });
  }
}
