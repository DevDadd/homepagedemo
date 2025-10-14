import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homepageintern/feature/home/presentation/pages/homepage.dart';
import 'package:homepageintern/feature/ordercommand/presentation/pages/commandorder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      child: MaterialApp(
        theme: ThemeData(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
        ),
        debugShowCheckedModeBanner: false,
        home: Commandorder(),
      ),
    );
  }
}
