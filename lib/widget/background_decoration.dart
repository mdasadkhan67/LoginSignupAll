import 'package:flutter/material.dart';

BoxDecoration BackgroundWidget() {
  return const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.purpleAccent,
        Colors.amber,
        Colors.blue,
      ],
    ),
  );
}

BoxDecoration BackgroundWidgetWithRadius() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(5),
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.purpleAccent,
        Colors.amber,
        Colors.blue,
      ],
    ),
  );
}
