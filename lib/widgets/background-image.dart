import 'package:flutter/material.dart';

Widget backgroundImage(image) {
  return ShaderMask(
    shaderCallback: (rect) => LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.center,
      colors: [Colors.black, Colors.transparent],
    ).createShader(rect),
    blendMode: BlendMode.darken,
    child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
        ),
      ),
    ),
  );
}
