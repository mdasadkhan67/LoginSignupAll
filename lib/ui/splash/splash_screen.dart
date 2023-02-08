import 'package:flutter/material.dart';
import 'package:google_fb_task/utils/splash_method.dart';

class SpalashScreen extends StatefulWidget {
  const SpalashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SpalashScreen> createState() => _SpalashScreenState();
}

class _SpalashScreenState extends State<SpalashScreen> {
  @override
  void initState() {
    super.initState();
    SplashRedirect.usedFuture(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/abc.png',
              width: 300,
              height: 150,
            ),
            const SizedBox(),
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Login Task",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
