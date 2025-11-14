import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homepageintern/feature/home/presentation/pages/homepage.dart';
import 'package:homepageintern/feature/ordercommand/presentation/cubit/ordercommand_cubit.dart';
import 'package:shared_logic1/startpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      child: BlocProvider(
        create: (context) => OrdercommandCubit(),
        child: MaterialApp(
          navigatorKey: navigatorKey,
          theme: ThemeData(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
          ),
          debugShowCheckedModeBanner: false,
          home: Startpage(
            onNavigateToHome: () {
              navigatorKey.currentState?.pushReplacement(
                MaterialPageRoute(builder: (context) => const Homepage()),
              );
            },
          ),
        ),
      ),
    );
  }
}
