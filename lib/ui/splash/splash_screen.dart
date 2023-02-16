import 'package:flutter/material.dart';
import 'package:google_fb_task/utils/shared_pref_services.dart';
import 'package:google_fb_task/utils/splash_method.dart';

class SpalashScreen extends StatefulWidget {
  const SpalashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SpalashScreen> createState() => _SpalashScreenState();
}

class _SpalashScreenState extends State<SpalashScreen> {
  initializeGlobalPrefs() async {
    await Prefs.init();
  }

  @override
  void initState() {
    super.initState();
    //initializeGlobalPrefs();
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
              width: MediaQuery.of(context).size.width,
              height: 250,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "ChatApp",
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Open Sans',
                  fontSize: 40),
            ),
          ],
        ),
      ),
    );
  }
}
