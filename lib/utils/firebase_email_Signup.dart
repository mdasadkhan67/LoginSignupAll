import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fb_task/const/const.dart';
import 'package:google_fb_task/model/user_signup_model.dart';
import 'package:google_fb_task/provider/isloading_provider.dart';
import 'package:google_fb_task/ui/chathomescreen/chat_home_page.dart';
import 'package:google_fb_task/ui/login/login_page.dart';
import 'package:google_fb_task/ui/profile_screen/profile_screen.dart';
import 'package:google_fb_task/utils/shared_pref_services.dart';
import 'package:provider/provider.dart';

class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;
  Future signUp({
    context,
    String? name,
    String? email,
    String phone = '',
    String? password,
    String? imageurl,
  }) async {
    try {
      final isLoading = Provider.of<IsLoadingProvider>(context, listen: false);
      isLoading.setIsLoadingTrue();
      await _auth
          .createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      )
          .then((value) async {
        // ignore: unnecessary_null_comparison
        if (_auth != null) {
          String uid = _auth.currentUser!.uid;
          UserModel newUser = UserModel(
              uid: uid, name: name, email: email, phone: phone, imageurl: "");
          await FirebaseFirestore.instance
              .collection("users")
              .doc(uid)
              .set(newUser.toMap());
        }
      }).then((value) async {
        Prefs.setBool('isLogin', true);
        Prefs.setString('loginBy', 'email');
        await FirebaseAuth.instance.currentUser!.updateEmail(email);
        await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
        await FirebaseAuth.instance.currentUser!.updatePassword(password);
        await FirebaseAuth.instance.currentUser!.updatePhotoURL('');
      }).then((result) {
        if (result == null) {
          isLoading.setIsLoadingFalse();
          if (Prefs.getBool('isLogin', false) != false) {
            if (FirebaseAuth.instance.currentUser!.photoURL == '') {
              ConstantItems.navigatorPushReplacement(
                context,
                ProfileScreen(
                  userModel: UserModel(
                    uid: FirebaseAuth.instance.currentUser!.uid,
                    email: FirebaseAuth
                            .instance.currentUser!.providerData[0].email ??
                        FirebaseAuth.instance.currentUser!.email,
                    imageurl: '',
                    name: '',
                    phone: phone,
                  ),
                ),
              );
            } else {
              ConstantItems.navigatorPushReplacement(
                context,
                ChatHomeScreen(
                  userModel: UserModel(
                    uid: FirebaseAuth.instance.currentUser!.uid,
                    email: FirebaseAuth
                            .instance.currentUser!.providerData[0].email ??
                        FirebaseAuth.instance.currentUser!.email,
                    imageurl: '',
                    name: '',
                    phone: phone,
                  ),
                ),
              );
            }
          }
        } else {
          isLoading.setIsLoadingFalse();
          ConstantItems.toastMessage(
              "User already registerd with the same Email Id");
        }
      });
    } on FirebaseAuthException catch (e) {
      final isLoading = Provider.of<IsLoadingProvider>(context, listen: false);
      isLoading.setIsLoadingFalse();
      return ConstantItems.toastMessage("${e.message}");
    }
  }

  Future signIn({String? email, String? password, context}) async {
    try {
      final isLoading = Provider.of<IsLoadingProvider>(context, listen: false);
      isLoading.setIsLoadingTrue();
      await _auth
          .signInWithEmailAndPassword(email: email!, password: password!)
          .then((value) async {
        if (_auth != null) {
          String uid = _auth.currentUser!.uid;
          DocumentSnapshot userData = await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .get();
          UserModel userModel =
              UserModel.fromMap(userData.data() as Map<String, dynamic>);
        }
      }).then((value) async {
        // await Prefs.setString(
        //     'email', FirebaseAuth.instance.currentUser!.email.toString());
        // await Prefs.setString('password', password);
        // await Prefs.setString('name', '');
        // await Prefs.setString('imageurl', '');
        // await Prefs.setInt('phone', 0);
        Prefs.setString('loginBy', 'email');
        await Prefs.setBool('isLogin', true);
        await FirebaseAuth.instance.currentUser!.updateEmail(email);
        await FirebaseAuth.instance.currentUser!.updatePassword(password);
      }).then((value) {
        isLoading.setIsLoadingFalse();
        if (Prefs.getBool('isLogin', false) != false) {
          if (FirebaseAuth.instance.currentUser!.photoURL != null ||
              FirebaseAuth.instance.currentUser!.photoURL != '') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                        userModel: UserModel(
                          uid: FirebaseAuth.instance.currentUser!.uid,
                          email: FirebaseAuth.instance.currentUser!.email,
                          imageurl: '',
                          name: '',
                          phone:
                              FirebaseAuth.instance.currentUser!.phoneNumber ??
                                  '',
                        ),
                      )),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatHomeScreen(
                        userModel: UserModel(
                          uid: FirebaseAuth.instance.currentUser!.uid,
                          email: FirebaseAuth.instance.currentUser!.email,
                          imageurl: '',
                          name: '',
                          phone:
                              FirebaseAuth.instance.currentUser!.phoneNumber ??
                                  '',
                        ),
                      )),
            );
          }
        } else {
          isLoading.setIsLoadingFalse();
          ConstantItems.navigatorPushReplacement(context, LoginPage());
        }
      }).onError(
        (error, stackTrace) {
          isLoading.setIsLoadingFalse();
          return ConstantItems.toastMessage("User not found");
        },
      );
    } on FirebaseAuthException catch (e) {
      final isLoading = Provider.of<IsLoadingProvider>(context, listen: false);
      isLoading.setIsLoadingFalse();
      return e.message;
    }
  }

  Future signOut(context) async {
    final isLoading = Provider.of<IsLoadingProvider>(context, listen: false);
    isLoading.setIsLoadingTrue();
    await Prefs.setBool('isLogin', false);
    Prefs.setString('loginBy', '');
    await _auth.signOut().then((value) =>
        ConstantItems.navigatorPushReplacement(context, const LoginPage()));
  }
}
