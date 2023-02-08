import 'package:flutter/material.dart';

class RadientButton extends StatelessWidget {
  String btnName;
  RadientButton({
    Key? key,
    required this.btnName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 250,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
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
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Text(
          btnName,
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
