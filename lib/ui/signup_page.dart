import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fb_task/model/user_signup_model.dart';
import 'package:google_fb_task/ui/home_page.dart';
import 'package:google_fb_task/ui/login_phone_page.dart';
import 'package:google_fb_task/utils/firebase_email_Signup.dart';
import 'package:google_fb_task/utils/login_utils.dart';
import 'package:google_fb_task/widget/background_decoration.dart';
import 'package:google_fb_task/widget/button_gradiant.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

// ignore: deprecated_member_use
final databaseReference = FirebaseDatabase.instance.reference();

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isShowPassword = true;
  bool isShowPassword1 = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BackgroundWidget(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 60,
              ),
              Container(
                width: 325,
                height: 700,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: 260,
                        height: 60,
                        child: TextFormField(
                          controller: nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter your name';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            suffix: Icon(
                              FontAwesomeIcons.person,
                              color: Colors.red,
                            ),
                            labelText: "Full Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        width: 260,
                        height: 60,
                        child: TextFormField(
                          controller: phoneController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter a phone!';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            suffix: Icon(
                              FontAwesomeIcons.phoneFlip,
                              color: Colors.red,
                            ),
                            labelText: "Number",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        width: 260,
                        height: 60,
                        child: TextFormField(
                          controller: emailController,
                          validator: ((value) {
                            if (value!.isEmpty ||
                                !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                              return 'Enter a valid email!';
                            }
                            return null;
                          }),
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            suffix: Icon(
                              FontAwesomeIcons.envelope,
                              color: Colors.red,
                            ),
                            labelText: "Email Address",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        width: 260,
                        height: 60,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter a valid password!';
                            }
                            return null;
                          },
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: isShowPassword,
                          decoration: InputDecoration(
                            suffix: IconButton(
                              onPressed: (() {
                                setState(() {
                                  if (isShowPassword) {
                                    isShowPassword = false;
                                  } else {
                                    isShowPassword = true;
                                  }
                                });
                              }),
                              icon: Icon(
                                isShowPassword == true
                                    ? FontAwesomeIcons.eyeSlash
                                    : FontAwesomeIcons.solidEye,
                                color: Colors.red,
                              ),
                            ),
                            labelText: "Password",
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      SizedBox(
                        width: 260,
                        height: 60,
                        child: TextFormField(
                          controller: confirmPasswordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter a valid password!';
                            } else if (passwordController.text !=
                                confirmPasswordController.text) {
                              return "Password does not match";
                            } else {
                              return null;
                            }
                          },
                          obscureText: isShowPassword1,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            suffix: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (isShowPassword1) {
                                    isShowPassword1 = false;
                                  } else {
                                    isShowPassword1 = true;
                                  }
                                });
                              },
                              icon: Icon(
                                isShowPassword1 == true
                                    ? FontAwesomeIcons.eyeSlash
                                    : FontAwesomeIcons.solidEye,
                                color: Colors.red,
                              ),
                            ),
                            labelText: "Confirm Password",
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      GestureDetector(
                          onTap: () {
                            AuthenticationHelper()
                                .signUp(
                              name: nameController.text,
                              email: emailController.text,
                              password: passwordController.text,
                            )
                                // .then(
                                //   (value) => LoginUtils.dataUpload(
                                //     UserSignUpModel(
                                //       name: nameController.text,
                                //       email: emailController.text,
                                //       phone: phoneController.text,
                                //       imageurl:
                                //           'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png',
                                //     ),
                                //   ),
                                // )
                                .then((result) {
                              if (result == null) {
                                Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()))
                                    .onError((error, stackTrace) =>
                                        Fluttertoast.showToast(
                                            msg: "${error.toString()}",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0));
                              }
                            });
                          },
                          child: RadientButton(
                            btnName: "SignUp",
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      const Divider(
                        indent: 35,
                        endIndent: 35,
                        thickness: 1.2,
                        color: Colors.grey,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              LoginUtils.facebookLogin(context);
                            },
                            icon: const Icon(
                              FontAwesomeIcons.facebook,
                              color: Colors.blue,
                              size: 40,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              LoginUtils.googleLogin(context);
                            },
                            icon: const Icon(
                              FontAwesomeIcons.google,
                              size: 40,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              FontAwesomeIcons.twitter,
                              color: Colors.orangeAccent,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: (() {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PhoneLoginScreen()));
                        }),
                        child: Container(
                          alignment: Alignment.center,
                          width: 70,
                          height: 30,
                          decoration: const BoxDecoration(
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
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
