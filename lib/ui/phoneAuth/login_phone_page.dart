import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fb_task/const/const.dart';
import 'package:google_fb_task/ui/phoneAuth/phone_OTP_screen.dart';
import 'package:google_fb_task/ui/signup/signup_page.dart';
import 'package:google_fb_task/utils/login_utils.dart';
import 'package:google_fb_task/widget/background_decoration.dart';
import 'package:google_fb_task/widget/button_gradiant.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneLoginScreen extends StatefulWidget {
  static String verify = '';
  static String userPhoneNumber = '';

  PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController phoneTEC = TextEditingController();
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
                height: 50,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 325,
                height: 400,
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
                        "Phone Verification",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        width: 260,
                        height: 77,
                        child: IntlPhoneField(
                          keyboardType: TextInputType.phone,
                          cursorColor: Colors.purple,
                          initialCountryCode: 'IN',
                          decoration: const InputDecoration(
                            iconColor: Colors.purple,
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                          onChanged: (phone) {
                            PhoneLoginScreen.userPhoneNumber =
                                phone.completeNumber;
                            _formKey.currentState?.validate();
                          },
                          onCountryChanged: (country) {},
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            ConstantItems.navigatorPush(context,
                                OTPScreen(otpAutofillText: phoneTEC.text));
                            ConstantItems.toastMessage(
                                'Verification code will be send soon ');
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 250,
                          decoration: BackgroundWidget(),
                          padding: const EdgeInsets.all(12.0),
                          child: const Text(
                            'Get OTP',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
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
                              ConstantItems.navigatorPush(
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
                            ConstantItems.navigatorPushReplacement(
                                context, const SignUpPage());
                          }),
                          child: RadientButton(
                            btnName: "SignUp",
                          )),
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
