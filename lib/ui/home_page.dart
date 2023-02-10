// ignore_for_file: public_member_api_docs, sort_constructors_first, unnecessary_null_in_if_null_operators, unnecessary_null_comparison
import 'package:flutter/material.dart';
import 'package:google_fb_task/utils/firebase_email_Signup.dart';
import 'package:google_fb_task/utils/login_utils.dart';
import 'package:google_fb_task/utils/shared_pref_services.dart';
import 'package:google_fb_task/widget/background_decoration.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = '';
  String userEmail = '';
  int userPhone = 0;
  String userProfile = '';
  String loginBy = '';

  //var firebaseInstanceVar = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  void getUserDetails() async {
    setState(() {
      loginBy = Prefs.getString('loginBy', '')!;
      userName = Prefs.getString('name', '')!;
      userEmail = Prefs.getString('email', '')!;
      userProfile = Prefs.getString('imageurl', '')!;
      userPhone = Prefs.getInt('phone', 0)!;
    });
    print(userEmail);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BackgroundWidget(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Card(
                          elevation: 50,
                          shadowColor: Colors.black,
                          color: Colors.white,
                          child: SizedBox(
                            width: 380,
                            height: 400,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.purpleAccent,
                                    radius: 65,
                                    child: CircleAvatar(
                                        backgroundColor: Colors.blue,
                                        radius: 60,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            // (firebaseInstanceVar!.photoURL !=
                                            //         null)For Data Retrive From Firebse
                                            (userProfile == 'null' ||
                                                    userProfile == null ||
                                                    userProfile == '')
                                                ? 'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png'
                                                : userProfile,
                                          ),
                                          radius: 55,
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    // (firebaseInstanceVar!.displayName != null) For Data Retrive From Firebse

                                    (userName == 'null' ||
                                            userName == null ||
                                            userName == '')
                                        ? ""
                                        : "Name: $userName",
                                    style: TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold,
                                      foreground: Paint()
                                        ..shader = const LinearGradient(
                                          colors: <Color>[
                                            Colors.purpleAccent,
                                            Colors.amber,
                                            Colors.blue,
                                            //add more color here.
                                          ],
                                        ).createShader(
                                          const Rect.fromLTWH(
                                              0.0, 0.0, 200.0, 100.0),
                                        ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    //(firebaseInstanceVar!.email != null) For Data Retrive From Firebse
                                    (userEmail == 'null' ||
                                            userEmail == null ||
                                            userEmail == '')
                                        ? " "
                                        : "Email: $userEmail",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      foreground: Paint()
                                        ..shader = const LinearGradient(
                                          colors: <Color>[
                                            Colors.purpleAccent,
                                            Colors.amber,
                                            Colors.blue,
                                          ],
                                        ).createShader(
                                          const Rect.fromLTWH(
                                              0.0, 0.0, 200.0, 100.0),
                                        ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    //(firebaseInstanceVar!.phoneNumber != null) For Data Retrive From Firebse
                                    (userPhone != 0 ||
                                            userPhone == null ||
                                            userPhone == '')
                                        ? "Phone: $userPhone"
                                        : "",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      foreground: Paint()
                                        ..shader = const LinearGradient(
                                          colors: <Color>[
                                            Colors.purpleAccent,
                                            Colors.amber,
                                            Colors.blue,
                                          ],
                                        ).createShader(
                                          const Rect.fromLTWH(
                                              0.0, 0.0, 200.0, 100.0),
                                        ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Container(
                                    height: 35.0,
                                    decoration: const BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                      Colors.purpleAccent,
                                      Colors.amber,
                                      Colors.blue,
                                    ])),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (loginBy == 'google') {
                                          LoginUtils.googleLogout(context);
                                        } else if (loginBy == 'facebook') {
                                          LoginUtils.facebookLogout(context);
                                        } else if (loginBy == 'phone') {
                                          LoginUtils.phoneSignOut(context);
                                        } else {
                                          AuthenticationHelper()
                                              .signOut(context);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent),
                                      child: const Text('Logout'),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
