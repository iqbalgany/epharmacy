// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'order_cubit.dart';

enum OrderStatus { initial, loading, success, error }

class OrderState extends Equatable {
  final OrderStatus? status;
  final OrderModel? order;
  final List<OrderModel> orders;
  final String? errorMessage;
  const OrderState({
    this.status = OrderStatus.initial,
    this.order,
    this.errorMessage = '',
    this.orders = const [],
  });

  @override
  List<Object?> get props => [status, order, errorMessage, orders];

  OrderState copyWith({
    OrderStatus? status,
    OrderModel? order,
    List<OrderModel>? orders,
    String? errorMessage,
  }) {
    return OrderState(
      status: status ?? this.status,
      order: order ?? this.order,
      orders: orders ?? this.orders,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
