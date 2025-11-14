import 'package:flutter/material.dart';

class Thirdpage extends StatefulWidget {
  int selectedIndex;
  Thirdpage({super.key, required this.selectedIndex});

  @override
  State<Thirdpage> createState() => _ThirdpageState();
}

class _ThirdpageState extends State<Thirdpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF111315),
    );
  }
}
