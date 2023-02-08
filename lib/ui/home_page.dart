// ignore_for_file: public_member_api_docs, sort_constructors_first, unnecessary_null_in_if_null_operators
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fb_task/utils/firebase_email_Signup.dart';

import 'package:google_fb_task/utils/login_utils.dart';

class HomePage extends StatefulWidget {
  String? fbImageUrl;
  HomePage({
    Key? key,
    this.fbImageUrl,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                                            (FirebaseAuth.instance.currentUser!
                                                        .photoURL !=
                                                    null)
                                                ? FirebaseAuth.instance
                                                    .currentUser!.photoURL
                                                    .toString()
                                                : 'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png',
                                          ),
                                          radius: 55,
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    (FirebaseAuth.instance.currentUser!
                                                .displayName !=
                                            null)
                                        ? "Name: ${FirebaseAuth.instance.currentUser!.displayName}"
                                        : '',
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
                                    (FirebaseAuth.instance.currentUser!.email !=
                                            null)
                                        ? "Email: ${FirebaseAuth.instance.currentUser!.email}"
                                        : '',
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
                                    (FirebaseAuth.instance.currentUser!
                                                .phoneNumber !=
                                            null)
                                        ? "Phone: ${FirebaseAuth.instance.currentUser!.phoneNumber}"
                                        : '',
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
                                        LoginUtils.googleLogout(context);
                                        LoginUtils.facebookLogout(context);
                                        AuthenticationHelper().signOut();
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
