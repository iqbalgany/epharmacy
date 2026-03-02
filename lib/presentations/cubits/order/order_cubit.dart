import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:epharmacy/data/models/address_model.dart';
import 'package:epharmacy/data/models/cart_model.dart';
import 'package:epharmacy/data/models/order_model.dart';
import 'package:epharmacy/data/models/user_model.dart';
import 'package:epharmacy/data/remote_datasource/order/order_remote_datasource.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRemoteDatasource _orderRemoteDatasource;

  StreamSubscription<List<OrderModel>>? _orderSubscription;

  OrderCubit(this._orderRemoteDatasource) : super(const OrderState());

  Future<void> createOrder({
    required String uid,
    required UserModel user,
    required AddressModel address,
    required double total,
    required List<CartModel> products,
  }) async {
    emit(state.copyWith(status: OrderStatus.loading));

    try {
      String orderId = const Uuid().v1();

      if (products.isEmpty) {
        emit(
          state.copyWith(
            status: OrderStatus.error,
            errorMessage: 'Cart is empty',
          ),
        );
        return;
      }

      final newOrder = OrderModel(
        uid: uid,
        products: products,
        total: total,
        orderId: orderId,
        address: address,
        date: DateTime.now(),
        isAccepted: false,
        isCancelled: false,
        isDelivered: false,
      );

      final result = await _orderRemoteDatasource.createOrder(newOrder);

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

  void fetchUserOrders(String userId) {
    emit(state.copyWith(status: OrderStatus.loading));

    _orderSubscription?.cancel();

    _orderSubscription = _orderRemoteDatasource
        .getUserOrders(userId)
        .listen(
          (orderList) {
            emit(
              state.copyWith(status: OrderStatus.success, orders: orderList),
            );
          },
          onError: (error) {
            emit(
              state.copyWith(
                status: OrderStatus.error,
                errorMessage: error.toString(),
              ),
            );
          },
        );
  }

  @override
  Future<void> close() {
    _orderSubscription?.cancel();
    return super.close();
  }
}
