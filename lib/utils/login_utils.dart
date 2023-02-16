import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_fb_task/const/const.dart';
import 'package:google_fb_task/model/user_signup_model.dart';
import 'package:google_fb_task/provider/isloading_provider.dart';
import 'package:google_fb_task/ui/chathomescreen/chat_home_page.dart';
import 'package:google_fb_task/ui/login/login_page.dart';
import 'package:google_fb_task/ui/profile_screen/profile_screen.dart';
import 'package:google_fb_task/utils/shared_pref_services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class LoginUtils {
  //Code For Facebook

  static facebookLogin(BuildContext context) async {
    final isLoading = Provider.of<IsLoadingProvider>(context, listen: false);
    isLoading.setIsLoadingTrue();
    try {
      final result = await FacebookAuth.i.login(permissions: [
        'public_profile',
        'email',
      ]);
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.i.getUserData();
        // final fbimgUrl = userData['picture']['data']['url'].toString();
        // Prefs.setString('email', userData['email']);
        // Prefs.setString('name', userData['name']);
        // Prefs.setString(
        //     'imageurl', userData['picture']['data']['url'].toString());
        // Prefs.setInt('phone', 0);
        Prefs.setString('loginBy', 'facebook');
        Prefs.setBool('isLogin', true);
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        FirebaseAuth.instance.signInWithCredential(facebookAuthCredential).then(
          (value) {
            FirebaseAuth.instance.currentUser!
                .updateDisplayName(userData['name'].toString());
            FirebaseAuth.instance.currentUser!
                .updateEmail(userData['email'].toString());
            FirebaseAuth.instance.currentUser!
                .updatePhotoURL(userData['picture']['data']['url'].toString());
            FirebaseAuth.instance.currentUser!.updatePhoneNumber;
            UserModel newUser = UserModel(
              uid: FirebaseAuth.instance.currentUser!.uid,
              name: FirebaseAuth.instance.currentUser!.displayName,
              email: FirebaseAuth.instance.currentUser!.email ??
                  FirebaseAuth.instance.currentUser!.providerData[0].email,
              phone: FirebaseAuth.instance.currentUser!.phoneNumber,
              imageurl: FirebaseAuth.instance.currentUser!.photoURL,
            );
            FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .set(newUser.toMap())
                .then((value) => print("UserStored"))
                .then((value) {
              isLoading.setIsLoadingFalse();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) {
                  if (Prefs.getBool('isLogin', false) != false) {
                    if (FirebaseAuth.instance.currentUser!.photoURL != '') {
                      return ChatHomeScreen(
                        userModel: UserModel(
                          uid: FirebaseAuth.instance.currentUser!.uid,
                          email: FirebaseAuth.instance.currentUser!.email,
                          imageurl: '',
                          name: '',
                          phone:
                              FirebaseAuth.instance.currentUser!.phoneNumber ??
                                  '',
                        ),
                      );
                    } else {
                      return ProfileScreen(
                        userModel: UserModel(
                          uid: FirebaseAuth.instance.currentUser!.uid,
                          email: FirebaseAuth.instance.currentUser!.email,
                          imageurl: '',
                          name: '',
                          phone:
                              FirebaseAuth.instance.currentUser!.phoneNumber ??
                                  '',
                        ),
                      );
                    }
                  } else {
                    return LoginPage();
                  }
                }),
              );
            });
          },
        ).onError(
          (error, stackTrace) {
            ConstantItems.toastMessage(
              error.toString(),
            );
          },
        );
      }
    } catch (error) {
      ConstantItems.toastMessage(
        error.toString(),
      );
    }
  }

  static void facebookLogout(BuildContext context) async {
    final isLoading = Provider.of<IsLoadingProvider>(context, listen: false);
    isLoading.setIsLoadingFalse();
    Prefs.setBool('isLogin', false);
    Prefs.setString('loginBy', '');
    await FirebaseAuth.instance.signOut();
    await FacebookAuth.instance.logOut().then((value) =>
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage())));
  }

//Code for Google
  static googleLogin(BuildContext context) async {
    final isLoading = Provider.of<IsLoadingProvider>(context, listen: false);
    isLoading.setIsLoadingTrue();
    GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      var reslut = await googleSignIn.signIn();
      if (reslut == null) {
        return;
      }
      final userData = await reslut.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: userData.accessToken, idToken: userData.idToken);

      await FirebaseAuth.instance.signInWithCredential(credential).then(
          (value) async {
        if (userData != null) {
          String uid = FirebaseAuth.instance.currentUser!.uid;
          UserModel newUser = UserModel(
            uid: FirebaseAuth.instance.currentUser!.uid,
            name: FirebaseAuth.instance.currentUser!.displayName,
            email: FirebaseAuth.instance.currentUser!.email ??
                FirebaseAuth.instance.currentUser!.providerData[0].email,
            phone: FirebaseAuth.instance.currentUser!.phoneNumber,
            imageurl: FirebaseAuth.instance.currentUser!.photoURL,
          );
          await FirebaseFirestore.instance
              .collection("users")
              .doc(uid)
              .set(newUser.toMap())
              .then((value) => print("UserStored"));
        }
      }).whenComplete(
        () async {
          // await Prefs.setString(
          //     'email',
          //     FirebaseAuth.instance.currentUser!.email ??
          //         FirebaseAuth.instance.currentUser!.providerData[0].email
          //             .toString());
          // await Prefs.setString('name',
          //     FirebaseAuth.instance.currentUser!.displayName.toString());
          // await Prefs.setString('imageurl',
          //     FirebaseAuth.instance.currentUser!.photoURL.toString());
          // await Prefs.setInt('phone', 0);
          Prefs.setBool('isLogin', true);
          Prefs.setString('loginBy', 'google');
        },
      ).then((value) {
        isLoading.setIsLoadingFalse();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            if (Prefs.getBool('isLogin', false) != false) {
              if (FirebaseAuth.instance.currentUser!.photoURL != '') {
                return ChatHomeScreen(
                  userModel: UserModel(
                    uid: FirebaseAuth.instance.currentUser!.uid,
                    email: FirebaseAuth
                            .instance.currentUser!.providerData[0].email ??
                        FirebaseAuth.instance.currentUser!.email,
                    imageurl: '',
                    name: '',
                    phone: FirebaseAuth.instance.currentUser!.phoneNumber ?? '',
                  ),
                );
              } else {
                return ProfileScreen(
                  userModel: UserModel(
                    uid: FirebaseAuth.instance.currentUser!.uid,
                    email: FirebaseAuth
                            .instance.currentUser!.providerData[0].email ??
                        FirebaseAuth.instance.currentUser!.email,
                    imageurl: '',
                    name: '',
                    phone: FirebaseAuth.instance.currentUser!.phoneNumber ?? '',
                  ),
                );
              }
            } else {
              return LoginPage();
            }
          }),
        );
      }).onError(
          (error, stackTrace) => ConstantItems.toastMessage(error.toString()));
    } catch (error) {
      ConstantItems.toastMessage(error.toString());
      ConstantItems.navigatorPushReplacement(context, const LoginPage());
    }
  }

  static Future<void> googleLogout(BuildContext context) async {
    final isLoading = Provider.of<IsLoadingProvider>(context, listen: false);
    isLoading.setIsLoadingFalse();
    Prefs.setBool('isLogin', false);
    Prefs.setString('loginBy', '');
    await GoogleSignIn().disconnect();
    await FirebaseAuth.instance.signOut();
    await FacebookAuth.instance.logOut().then((value) =>
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage())));
  }

//Logout By Phone
  static Future<void> phoneSignOut(context) async {
    final isLoading = Provider.of<IsLoadingProvider>(context, listen: false);
    isLoading.setIsLoadingFalse();
    Prefs.setBool('isLogin', false);
    Prefs.setString('loginBy', '');
    await FirebaseAuth.instance.signOut().then((value) =>
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage())));
  }
}
