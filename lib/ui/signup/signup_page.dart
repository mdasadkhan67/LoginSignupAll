import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fb_task/ui/signup/signup_form_widget.dart';
import 'package:google_fb_task/widget/background_decoration.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

// ignore: deprecated_member_use
final databaseReference = FirebaseDatabase.instance.reference();

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BackgroundWidget(),
        child: const SignUpFormWidget(),
      ),
    );
  }
}
