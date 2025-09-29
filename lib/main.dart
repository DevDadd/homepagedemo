import 'package:flutter/material.dart';
import 'package:homepageintern/feature/home/presentation/pages/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}
