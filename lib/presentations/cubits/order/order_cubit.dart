import 'package:bloc/bloc.dart';
import 'package:epharmacy/data/models/address_model.dart';
import 'package:epharmacy/data/models/order_model.dart';
import 'package:epharmacy/data/models/user_model.dart';
import 'package:epharmacy/data/remote_datasource/order/order_remote_datasource.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRemoteDatasource _orderRemoteDatasource;
  OrderCubit(this._orderRemoteDatasource) : super(const OrderState());

  Future<void> createOrder(
    String uid,
    UserModel user,
    AddressModel address,
    double total,
  ) async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      String orderId = const Uuid().v1();

      final newOrder = OrderModel(
            uid: uid,
            products: user.cart!.toList(),
            total: total,
            orderId: orderId,
            address: address,
            date: DateTime.now(),
            isAccepted: false,
            isCancelled: false,
            isDelivered: false,
          ),
          result = await _orderRemoteDatasource.createOrder(newOrder);

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: OrderStatus.error,
              errorMessage: failure.toString(),
            ),
          );
        },
        (success) {
          emit(state.copyWith(status: OrderStatus.success, order: newOrder));
        },
      );
    } catch (e) {
      emit(
        state.copyWith(status: OrderStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Stream<List<OrderModel>> getUserOrders(String userId) {
    return _orderRemoteDatasource.getUserOrders(userId);
  }
}
