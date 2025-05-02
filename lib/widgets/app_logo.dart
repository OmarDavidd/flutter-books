import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "A  T  I  U  M",
        style: TextStyle(
          fontSize: 40,
          fontFamily: "Roboto",
          color: Color(0xFF5E4B3B),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
