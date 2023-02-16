// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fb_task/const/const.dart';
import 'package:google_fb_task/model/user_signup_model.dart';
import 'package:google_fb_task/provider/isloading_provider.dart';
import 'package:google_fb_task/ui/chathomescreen/chat_home_page.dart';
import 'package:google_fb_task/ui/login/login_page.dart';
import 'package:google_fb_task/ui/phoneAuth/login_phone_page.dart';
import 'package:google_fb_task/ui/profile_screen/profile_screen.dart';
import 'package:google_fb_task/utils/shared_pref_services.dart';
import 'package:google_fb_task/widget/background_decoration.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

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
                          final isLoading = Provider.of<IsLoadingProvider>(
                              context,
                              listen: false);
                          isLoading.setIsLoadingTrue();
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: PhoneLoginScreen.verify,
                                  smsCode: otpController.text);
                          await auth
                              .signInWithCredential(credential)
                              .whenComplete(() async {
                            Prefs.setBool('isLogin', true);
                            Prefs.setString('loginBy', 'phone');
                          }).then(
                            (value) async {
                              String uid = auth.currentUser!.uid;
                              UserModel newUser = UserModel(
                                uid: uid,
                                name: FirebaseAuth
                                    .instance.currentUser!.phoneNumber,
                                email:
                                    '${FirebaseAuth.instance.currentUser!.phoneNumber}@gmail.com',
                                phone: FirebaseAuth
                                    .instance.currentUser!.phoneNumber,
                                imageurl: '',
                              );
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(uid)
                                  .set(newUser.toMap());
                            },
                          ).whenComplete(() async {
                            isLoading.setIsLoadingFalse();
                            if (Prefs.getBool('isLogin', false) != false) {
                              if (FirebaseAuth.instance.currentUser!.photoURL ==
                                  null) {
                                await Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                            userModel: UserModel(
                                              uid: FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              email:
                                                  '${FirebaseAuth.instance.currentUser!.phoneNumber}@gmail.com',
                                              imageurl:
                                                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                              name:
                                                  'name : ${FirebaseAuth.instance.currentUser!.uid.toString()}',
                                              phone: FirebaseAuth.instance
                                                  .currentUser!.phoneNumber,
                                            ),
                                          )),
                                );
                              } else if (FirebaseAuth
                                      .instance.currentUser!.photoURL ==
                                  '') {
                                await Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                            userModel: UserModel(
                                              uid: FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              email:
                                                  '${FirebaseAuth.instance.currentUser!.phoneNumber}@gmail.com',
                                              imageurl:
                                                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                              name:
                                                  'name : ${FirebaseAuth.instance.currentUser!.uid.toString()}',
                                              phone: FirebaseAuth.instance
                                                  .currentUser!.phoneNumber,
                                            ),
                                          )),
                                );
                              } else {
                                await Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatHomeScreen(
                                            userModel: UserModel(
                                              uid: FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              email:
                                                  '${FirebaseAuth.instance.currentUser!.phoneNumber}',
                                              imageurl: FirebaseAuth.instance
                                                  .currentUser!.photoURL,
                                              name: FirebaseAuth.instance
                                                  .currentUser!.displayName,
                                              phone: FirebaseAuth.instance
                                                  .currentUser!.phoneNumber,
                                            ),
                                          )),
                                );
                              }
                            } else {
                              ConstantItems.navigatorPushReplacement(
                                  context, LoginPage());
                            }
                          }).onError((error, stackTrace) {
                            isLoading.setIsLoadingFalse();
                            return ConstantItems.toastMessage("$error");
                          }).then((value) => ConstantItems.navigatorPush(
                                  context, const LoginPage()));
                        } catch (e) {
                          final isLoading = Provider.of<IsLoadingProvider>(
                              context,
                              listen: false);
                          isLoading.setIsLoadingFalse();
                          ConstantItems.toastMessage(e.toString()).then(
                              (value) => ConstantItems.navigatorPushReplacement(
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
                              ConstantItems.navigatorPushReplacement(
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
