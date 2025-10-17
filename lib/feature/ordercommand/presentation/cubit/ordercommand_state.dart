import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ordercommand_state.g.dart';

@JsonSerializable()
@CopyWith()
class OrdercommandState extends Equatable {
   const OrdercommandState({this.isClickedSell = false});
  final bool isClickedSell;
  @override
  List<Object> get props => [isClickedSell];
}

