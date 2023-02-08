import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ConstantItems {
  //Regex String
  static String regexEmail =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

//Toast Message
  static toastMessage(String message) {
    Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  //Navigator PushReplacement
  static void navigatorPushReplacement(
    BuildContext context,
    Widget widgetName,
  ) {
    Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => widgetName))
        .onError((error, stackTrace) =>
            (error, stackTrace) => ConstantItems.toastMessage("$error"));
  }

  //Navigator PushReplacement
  static void navigatorPush(
    BuildContext context,
    Widget widgetName,
  ) {
    Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => widgetName))
        .onError((error, stackTrace) =>
            (error, stackTrace) => ConstantItems.toastMessage("$error"));
  }
}
