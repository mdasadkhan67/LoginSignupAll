import 'package:flutter/material.dart';
import 'package:google_fb_task/provider/isloading_provider.dart';
import 'package:google_fb_task/ui/login/login_form_widget.dart';
import 'package:google_fb_task/widget/background_decoration.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              height: 500,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: const LoginFormWidget(),
            )
          ],
        ),
      ),
    );
  }
}
