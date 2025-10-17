// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ordercommand_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$OrdercommandStateCWProxy {
  OrdercommandState isClickedSell(bool isClickedSell);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `OrdercommandState(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// OrdercommandState(...).copyWith(id: 12, name: "My name")
  /// ```
  OrdercommandState call({bool isClickedSell});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfOrdercommandState.copyWith(...)` or call `instanceOfOrdercommandState.copyWith.fieldName(value)` for a single field.
class _$OrdercommandStateCWProxyImpl implements _$OrdercommandStateCWProxy {
  const _$OrdercommandStateCWProxyImpl(this._value);

  final OrdercommandState _value;

  @override
  OrdercommandState isClickedSell(bool isClickedSell) =>
      call(isClickedSell: isClickedSell);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `OrdercommandState(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// OrdercommandState(...).copyWith(id: 12, name: "My name")
  /// ```
  OrdercommandState call({
    Object? isClickedSell = const $CopyWithPlaceholder(),
  }) {
    return OrdercommandState(
      isClickedSell:
          isClickedSell == const $CopyWithPlaceholder() || isClickedSell == null
          ? _value.isClickedSell
          // ignore: cast_nullable_to_non_nullable
          : isClickedSell as bool,
    );
  }
}

extension $OrdercommandStateCopyWith on OrdercommandState {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfOrdercommandState.copyWith(...)` or `instanceOfOrdercommandState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$OrdercommandStateCWProxy get copyWith =>
      _$OrdercommandStateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrdercommandState _$OrdercommandStateFromJson(Map<String, dynamic> json) =>
    OrdercommandState(isClickedSell: json['isClickedSell'] as bool? ?? false);

Map<String, dynamic> _$OrdercommandStateToJson(OrdercommandState instance) =>
    <String, dynamic>{'isClickedSell': instance.isClickedSell};
