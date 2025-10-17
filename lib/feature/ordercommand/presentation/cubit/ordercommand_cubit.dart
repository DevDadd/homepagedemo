import 'package:bloc/bloc.dart';
import 'package:homepageintern/feature/ordercommand/presentation/cubit/ordercommand_state.dart';


class OrdercommandCubit extends Cubit<OrdercommandState> {
  OrdercommandCubit() : super(OrdercommandState());
  void clickSellButton(){
    emit(state.copyWith(isClickedSell: true));
  }
  void clickBuyButton(){
    emit(state.copyWith(isClickedSell: false));
  }
}
