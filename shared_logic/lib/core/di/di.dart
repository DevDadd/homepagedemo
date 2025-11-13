import 'package:get_it/get_it.dart';
import 'package:shared_logic/feature/profile/cubit/user_cubit.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<UserCubit>(UserCubit());
}
