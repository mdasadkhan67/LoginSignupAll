import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fb_task/const/const.dart';
import 'package:google_fb_task/ui/home_page.dart';
import 'package:google_fb_task/ui/login/login_page.dart';
import 'package:google_fb_task/utils/firebase_email_Signup.dart';
import 'package:google_fb_task/widget/button_gradiant.dart';

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({super.key});

  @override
  State<SignUpFormWidget> createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
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
    return Container(
        width: 325,
        height: 800,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
                          !RegExp(ConstantItems.regexEmail).hasMatch(value)) {
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
                        borderRadius: BorderRadius.all(Radius.circular(8)),
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
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        AuthenticationHelper()
                            .signUp(
                          name: nameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                        )
                            .then((result) {
                          if (result == null) {
                            ConstantItems.navigatorPushReplacement(
                                context, HomePage());
                          }
                        });
                      }
                    },
                    child: RadientButton(
                      btnName: "SignUp",
                    )),
                const SizedBox(
                  height: 18,
                ),
                GestureDetector(
                    onTap: () {
                      ConstantItems.navigatorPushReplacement(
                          context, const LoginPage());
                    },
                    child: RadientButton(
                      btnName: "Login",
                    )),
              ],
            )));
  }
}
