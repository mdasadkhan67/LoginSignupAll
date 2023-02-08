// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fb_task/ui/home_page.dart';
import 'package:google_fb_task/ui/login_phone_page.dart';
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
        print(
            "++++++++++++++++++++++++ ${FirebaseAuth.instance.currentUser!.phoneNumber.toString()}");
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
              const SizedBox(
                height: 50,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 325,
                height: 370,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  children: [
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
                          textStyle: TextStyle(color: Colors.amberAccent),
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
                              .then((value) => FirebaseFirestore.instance
                                      .collection('UserData')
                                      .add({
                                    'email': FirebaseAuth
                                        .instance.currentUser!.email,
                                    'imageurl': FirebaseAuth
                                        .instance.currentUser!.photoURL,
                                    'name': FirebaseAuth
                                        .instance.currentUser!.displayName,
                                    'phone': FirebaseAuth
                                        .instance.currentUser!.phoneNumber
                                  }))
                              .whenComplete(() => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                  ));
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 250,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xFF8A2387),
                              Color(0xFFE94057),
                              Color(0xFFF27121),
                            ],
                          ),
                        ),
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
