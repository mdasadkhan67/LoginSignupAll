import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_field/phone_number.dart';

class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;

  Future signUp({
    String? name,
    String? email,
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
        await FirebaseAuth.instance.currentUser!.updateEmail(email);
        await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
        await FirebaseAuth.instance.currentUser!.updatePassword(password);

        await FirebaseAuth.instance.currentUser!.updatePhotoURL(
            'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png');
      });
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signIn({String? email, String? password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email!, password: password!);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signOut() async {
    await _auth.signOut();
  }
}
