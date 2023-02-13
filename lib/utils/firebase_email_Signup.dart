import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fb_task/const/const.dart';
import 'package:google_fb_task/model/user_signup_model.dart';
import 'package:google_fb_task/ui/chathomescreen/chaht_home_screen.dart';
import 'package:google_fb_task/ui/login/login_page.dart';
import 'package:google_fb_task/ui/profile_screen/profile_screen.dart';
import 'package:google_fb_task/utils/shared_pref_services.dart';

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
        await Prefs.setBool('isLogin', true);
        Prefs.setString('loginBy', 'email');
        await Prefs.setString('email', email);
        await Prefs.setString('phone', phone.toString());
        await Prefs.setString('password', password);
        await Prefs.setString('name', '');
        await Prefs.setString('imageurl', '');
        await Prefs.setInt('phone', 0);
        await FirebaseAuth.instance.currentUser!.updateEmail(email);
        await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
        await FirebaseAuth.instance.currentUser!.updatePassword(password);
        await FirebaseAuth.instance.currentUser!.updatePhotoURL(
            'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png');
      }).then((result) {
        if (result == null) {
          ConstantItems.navigatorPushReplacement(
            context,
            ProfileScreen(
              userModel: UserModel(
                uid: FirebaseAuth.instance.currentUser!.uid,
                email:
                    FirebaseAuth.instance.currentUser!.providerData[0].email ??
                        FirebaseAuth.instance.currentUser!.email,
                imageurl: '',
                name: '',
                phone: phone,
              ),
            ),
          );
        } else {
          ConstantItems.toastMessage(
              "User already registerd with the same Email Id");
        }
      });
    } on FirebaseAuthException catch (e) {
      return ConstantItems.toastMessage("${e.message}");
    }
  }

  Future signIn({String? email, String? password, context}) async {
    try {
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
          })
          .then((value) async {
            Prefs.setString('loginBy', 'email');
            await Prefs.setBool('isLogin', true);
            await Prefs.setString(
                'email', FirebaseAuth.instance.currentUser!.email.toString());
            await Prefs.setString('password', password);
            await Prefs.setString('name', '');
            await Prefs.setString('imageurl', '');
            await Prefs.setInt('phone', 0);
            await FirebaseAuth.instance.currentUser!.updateEmail(email);
            await FirebaseAuth.instance.currentUser!.updatePassword(password);
          })
          .then((value) =>
              ConstantItems.navigatorPushReplacement(context, ChatHomePage()))
          .onError(
            (error, stackTrace) => ConstantItems.toastMessage("User not found"),
          );
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signOut(context) async {
    await Prefs.setBool('isLogin', false);
    Prefs.setString('loginBy', '');
    await _auth.signOut().then((value) =>
        ConstantItems.navigatorPushReplacement(context, const LoginPage()));
  }
}
