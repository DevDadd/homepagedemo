// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserStateCWProxy {
  UserState user(User? user);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `UserState(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserState(...).copyWith(id: 12, name: "My name")
  /// ```
  UserState call({User? user});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfUserState.copyWith(...)` or call `instanceOfUserState.copyWith.fieldName(value)` for a single field.
class _$UserStateCWProxyImpl implements _$UserStateCWProxy {
  const _$UserStateCWProxyImpl(this._value);

  final UserState _value;

  @override
  UserState user(User? user) => call(user: user);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `UserState(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserState(...).copyWith(id: 12, name: "My name")
  /// ```
  UserState call({Object? user = const $CopyWithPlaceholder()}) {
    return UserState(
      user: user == const $CopyWithPlaceholder()
          ? _value.user
          // ignore: cast_nullable_to_non_nullable
          : user as User?,
    );
  }
}

extension $UserStateCopyWith on UserState {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfUserState.copyWith(...)` or `instanceOfUserState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserStateCWProxy get copyWith => _$UserStateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserState _$UserStateFromJson(Map<String, dynamic> json) => UserState(
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserStateToJson(UserState instance) => <String, dynamic>{
  'user': instance.user,
};
