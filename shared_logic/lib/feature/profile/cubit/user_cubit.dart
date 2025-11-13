import 'package:bloc/bloc.dart';
import 'package:shared_logic/feature/profile/cubit/user_state.dart';
import 'package:shared_logic/feature/profile/data/model/user.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserState());
  void addUser(User user) {
    emit(state.copyWith(user: user));
  }

  User? getUser() {
    return state.user;
  }

  void updateUser(User updateUser) {
    emit(state.copyWith(user: updateUser));
  }
}
