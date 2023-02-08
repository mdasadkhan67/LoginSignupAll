import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fb_task/model/user_signup_model.dart';
import 'package:google_fb_task/ui/home_page.dart';
import 'package:google_fb_task/ui/login_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginUtils {
  //Code For Facebook

  static facebookLogin(BuildContext context) async {
    try {
      final result =
          await FacebookAuth.i.login(permissions: ['public_profile', 'email']);
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.i.getUserData();
        // final fbimgUrl = userData['picture']['data']['url'].toString();
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        var finalResult = FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential)
            .then((value) => FirebaseFirestore.instance
                    .collection('UserData')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .set({
                  'email': userData['email'],
                  'imageurl': userData['picture']['data']['url'],
                  'name': userData['name'],
                  'phone': userData['phone']
                }))
            .then(
          (value) {
            FirebaseAuth.instance.currentUser!
                .updateDisplayName(userData['name'].toString());
            FirebaseAuth.instance.currentUser!
                .updateEmail(userData['email'].toString());
            FirebaseAuth.instance.currentUser!
                .updatePhotoURL(userData['picture']['data']['url'].toString());

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ).onError(
          (error, stackTrace) {
            Fluttertoast.showToast(
                // msg: "An account already exists with the same email address",
                msg: error.toString(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          },
        );
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  static void facebookLogout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await FacebookAuth.instance.logOut().then((value) =>
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage())));
  }

//Code for Google
  static googleLogin(BuildContext context) async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      var reslut = await _googleSignIn.signIn();
      if (reslut == null) {
        return;
      }
      final userData = await reslut.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: userData.accessToken, idToken: userData.idToken);

      var finalResult = await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) => FirebaseFirestore.instance
                  .collection('UserData')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .set({
                'email': FirebaseAuth.instance.currentUser!.email,
                'imageurl': FirebaseAuth.instance.currentUser!.photoURL,
                'name': FirebaseAuth.instance.currentUser!.displayName,
                'phone': FirebaseAuth.instance.currentUser!.phoneNumber
              }))
          .then((value) => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage())));
    } catch (error) {
      print(error.toString());
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }

  static Future<void> googleLogout(BuildContext context) async {
    await GoogleSignIn().signOut();
    await GoogleSignIn().disconnect();
    await FirebaseAuth.instance.signOut().then((value) =>
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage())));
  }

//Firebase User DataStore,
  static Future dataUpload(UserSignUpModel user) async {
    await FirebaseFirestore.instance.collection('UserData').add(user.toMap());
  }
}
