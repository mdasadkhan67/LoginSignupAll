import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fb_task/ui/home_page.dart';
import 'package:google_fb_task/ui/login_phone_page.dart';
import 'package:google_fb_task/ui/signup_page.dart';
import 'package:google_fb_task/utils/firebase_email_Signup.dart';
import 'package:google_fb_task/utils/login_utils.dart';
import 'package:google_fb_task/widget/background_decoration.dart';
import 'package:google_fb_task/widget/button_gradiant.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isShowPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BackgroundWidget(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 60,
              ),
              Container(
                width: 325,
                height: 470,
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
                        "Login",
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
                          validator: ((value) {
                            if (value!.isEmpty ||
                                !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
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
                        onTap: (() {
                          if (_formKey.currentState!.validate()) {
                            AuthenticationHelper()
                                .signIn(
                                    email: emailController.text,
                                    password: passwordController.text)
                                .then((value) => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage())));
                          } else {}
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
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PhoneLoginScreen()),
                              );
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
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpPage()));
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
                              'Sign Up',
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
