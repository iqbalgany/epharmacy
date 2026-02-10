// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'cart_cubit.dart';

enum CartStatus { initial, loading, success, error }

class CartState extends Equatable {
  final CartStatus status;
  final List<CartModel>? carts;

  final String message;
  const CartState({
    this.status = CartStatus.initial,
    this.carts = const [],
    this.message = '',
  });

  @override
  List<Object?> get props => [status, carts, message];

  CartState copyWith({
    CartStatus? status,
    List<CartModel>? carts,
    String? message,
  }) {
    return CartState(
      status: status ?? this.status,
      message: message ?? this.message,
      carts: carts ?? this.carts,
    );
  }
}
