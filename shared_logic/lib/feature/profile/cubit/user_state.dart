import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_logic/feature/profile/data/model/user.dart';

part 'user_state.g.dart';

@CopyWith()
@JsonSerializable()
class UserState extends Equatable {
  const UserState({this.user});
  final User? user;
  factory UserState.fromJson(Map<String, dynamic> json) =>
    _$UserStateFromJson(json);

Map<String, dynamic> toJson() => _$UserStateToJson(this);
  @override
  List<Object?> get props => [user];
}
