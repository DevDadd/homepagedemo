import 'package:flutter/material.dart';
import 'package:shared_logic/core/di/di.dart';
import 'package:shared_logic/core/router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setup();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRoutes().router,
    );
  }
}
