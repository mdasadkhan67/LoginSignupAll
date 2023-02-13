import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fb_task/const/const.dart';
import 'package:google_fb_task/model/user_signup_model.dart';
import 'package:google_fb_task/ui/chathomescreen/chaht_home_screen.dart';
import 'package:google_fb_task/ui/phoneAuth/login_phone_page.dart';
import 'package:google_fb_task/ui/profile_screen/profile_screen.dart';
import 'package:google_fb_task/ui/signup/signup_page.dart';
import 'package:google_fb_task/utils/firebase_email_Signup.dart';
import 'package:google_fb_task/utils/login_utils.dart';
import 'package:google_fb_task/widget/button_gradiant.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isShowPassword = true;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () {
              ConstantItems.navigatorPush(context, ChatHomePage());
            },
            child: const Text(
              "Login",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            width: 260,
            height: 60,
            child: TextFormField(
              validator: ((value) {
                if (value!.isEmpty ||
                    !RegExp(ConstantItems.regexEmail).hasMatch(value)) {
                  return 'Enter a valid email!';
                }
                return null;
              }),
              controller: emailController,
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
              keyboardType: TextInputType.visiblePassword,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter a valid password!';
                }
                return null;
              },
              controller: passwordController,
              obscureText: isShowPassword,
              decoration: InputDecoration(
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      if (isShowPassword) {
                        isShowPassword = false;
                      } else {
                        isShowPassword = true;
                      }
                    });
                  },
                  icon: Icon(isShowPassword == true
                      ? FontAwesomeIcons.eyeSlash
                      : FontAwesomeIcons.solidEye),
                  color: Colors.red,
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
          GestureDetector(
            onTap: (() {
              if (_formKey.currentState!.validate()) {
                AuthenticationHelper().signIn(
                    email: emailController.text,
                    password: passwordController.text,
                    context: context);
              }
            }),
            child: RadientButton(btnName: "Login"),
          ),
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
                onPressed: () {
                  ConstantItems.navigatorPushReplacement(
                      context, PhoneLoginScreen());
                },
                icon: const Icon(
                  FontAwesomeIcons.mobile,
                  color: Colors.amberAccent,
                  textDirection: TextDirection.ltr,
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
                ConstantItems.navigatorPush(context, const SignUpPage());
              }),
              child: RadientButton(
                btnName: "SingUp",
              )),
        ],
      ),
    );
  }
}
