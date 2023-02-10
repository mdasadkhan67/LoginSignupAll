// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fb_task/const/const.dart';
import 'package:google_fb_task/model/user_signup_model.dart';
import 'package:google_fb_task/ui/home_page.dart';
import 'package:google_fb_task/ui/login/login_page.dart';
import 'package:google_fb_task/ui/phoneAuth/login_phone_page.dart';
import 'package:google_fb_task/utils/shared_pref_services.dart';
import 'package:google_fb_task/widget/background_decoration.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPScreen extends StatefulWidget {
  String otpAutofillText;
  OTPScreen({
    Key? key,
    required this.otpAutofillText,
  }) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var verificationCode = '';
  TextEditingController otpController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    otpController.text = widget.otpAutofillText;
    sendFirebaseOtpVerify();
  }

  void sendFirebaseOtpVerify() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: PhoneLoginScreen.userPhoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        setState(() {
          otpController.text = credential.smsCode.toString();
        });
      },
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        PhoneLoginScreen.verify = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.purpleAccent,
                Colors.amber,
                Colors.blue,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 325,
                height: 370,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
                    const Text(
                      "Phone Verification",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 10.0),
                      child: PinCodeTextField(
                          controller: otpController,
                          pinTheme: PinTheme(
                            inactiveColor: Colors.amberAccent,
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5),
                            fieldHeight: 50,
                            fieldWidth: 40,
                            borderWidth: 1,
                          ),
                          textStyle: const TextStyle(color: Colors.blue),
                          dialogConfig: DialogConfig(),
                          appContext: context,
                          length: 6,
                          onChanged: ((value) {
                            verificationCode = value;
                          })),
                    ),
                    GestureDetector(
                      onTap: () async {
                        try {
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: PhoneLoginScreen.verify,
                                  smsCode: otpController.text);
                          await auth
                              .signInWithCredential(credential)
                              .whenComplete(() {
                                Prefs.setBool('isLogin', true);
                                Prefs.setString('loginBy', 'phone');
                                Prefs.setInt(
                                    'phone',
                                    int.parse(FirebaseAuth
                                        .instance.currentUser!.phoneNumber
                                        .toString()));
                                Prefs.setString(
                                    'imageurl',
                                    FirebaseAuth.instance.currentUser!.photoURL
                                        .toString());
                                Prefs.setString(
                                    'email',
                                    FirebaseAuth.instance.currentUser!.email
                                        .toString());
                                Prefs.setString(
                                    'name',
                                    FirebaseAuth
                                        .instance.currentUser!.displayName
                                        .toString());
                              })
                              .then(
                                (value) async {
                                  if (credential != null) {
                                    String uid = auth.currentUser!.uid;
                                    UserModel newUser = UserModel(
                                      uid: uid,
                                      name: FirebaseAuth
                                          .instance.currentUser!.displayName,
                                      email: FirebaseAuth
                                              .instance.currentUser!.email ??
                                          FirebaseAuth.instance.currentUser!
                                              .providerData[0].email,
                                      phone: FirebaseAuth
                                          .instance.currentUser!.phoneNumber,
                                      imageurl: FirebaseAuth
                                          .instance.currentUser!.photoURL,
                                    );
                                    await FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(uid)
                                        .set(newUser.toMap())
                                        .then((value) => print("UserStored"));
                                  }
                                },
                              )
                              .whenComplete(() => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                  ))
                              .onError((error, stackTrace) =>
                                  ConstantItems.toastMessage("$error"))
                              .then((value) => ConstantItems.navigatorPush(
                                  context, const LoginPage()));
                        } catch (e) {
                          ConstantItems.toastMessage("$e").then((value) =>
                              ConstantItems.navigatorPush(
                                  context, const LoginPage()));
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 250,
                        decoration: BackgroundWidget(),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'VERIFY',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    GestureDetector(
                      onTap: () async {
                        try {
                          sendFirebaseOtpVerify();
                        } catch (e) {
                          ConstantItems.toastMessage("$e").then((value) =>
                              ConstantItems.navigatorPush(
                                  context, PhoneLoginScreen()));
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 250,
                        decoration: BackgroundWidget(),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Resend OTP',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
