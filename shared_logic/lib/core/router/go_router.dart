import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_logic/core/di/di.dart';
import 'package:shared_logic/feature/profile/cubit/user_cubit.dart';
import 'package:shared_logic/feature/profile/data/model/user.dart';
import 'package:shared_logic/feature/profile/presentation/pages/edit_profile_page.dart';
import 'package:shared_logic/feature/profile/presentation/pages/profile_page.dart';

class AppRouteConstant {
  AppRouteConstant._();

  static const String initial = '/';
  static const String profilepage = '/profile-page';
  static const String editProfilePage = '/edit-profile-page';
  static const String testAnimation = '/test-animation';

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}

class AppRoutes {
  static final AppRoutes _singleton = AppRoutes._internal();

  factory AppRoutes() {
    return _singleton;
  }

  AppRoutes._internal();

  GoRouter router = GoRouter(
    initialLocation: AppRouteConstant.initial,
    navigatorKey: AppRouteConstant.navigatorKey,
    routes: <RouteBase>[
      GoRoute(
        path: AppRouteConstant.initial,
        builder: (BuildContext context, GoRouterState state) {
          final UserCubit userCubit = getIt.get();
          return BlocProvider.value(value: userCubit, child: ProfilePage());
        },
      ),
      GoRoute(
        path: AppRouteConstant.editProfilePage,
        builder: (BuildContext context, GoRouterState state) {
          final UserCubit userCubit = getIt.get();
          final user = state.extra as User?;
          return BlocProvider.value(
            value: userCubit,
            child: EditProfilePage(
              idCard: user?.idCard ?? '',
              date: user?.date ?? '',
              place: user?.placeID ?? '',
              address: user?.contactAdress ?? '',
              city: user?.city ?? '',
              phone: user?.phone ?? '',
              gmail: user?.email ?? '',
            ),
          );
        },
      ),
    ],
  );
}
