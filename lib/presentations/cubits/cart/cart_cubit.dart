import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:epharmacy/data/models/cart_model.dart';
import 'package:epharmacy/data/models/product_model.dart';
import 'package:epharmacy/data/remote_datasource/cart/cart_remote_datasource.dart';
import 'package:equatable/equatable.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRemoteDatasource _cartRemoteDatasource;

  StreamSubscription? _cartSubscription;

  CartCubit(this._cartRemoteDatasource) : super(const CartState()) {
    getCartItems();
    onLoadCart();
  }

  Future<void> onLoadCart() async {
    emit(state.copyWith(status: CartStatus.loading));
    _cartSubscription?.cancel();

    _cartSubscription = _cartRemoteDatasource.getCartItems().listen(
      (cartList) {
        double total = cartList.fold(
          0.0,
          (sum, item) => sum + ((item.cost ?? 0) * (item.quantity ?? 0)),
        );

        emit(
          state.copyWith(
            carts: cartList,
            grandTotal: total,
            status: CartStatus.success,
          ),
        );
      },
      onError: (error) {
        emit(
          state.copyWith(status: CartStatus.error, message: error.toString()),
        );
      },
    );
  }

  void getCartItems() {
    _cartSubscription?.cancel();

    _cartSubscription = _cartRemoteDatasource.getCartItems().listen(
      (carts) {
        emit(state.copyWith(status: CartStatus.success, carts: carts));
      },
      onError: (error) {
        emit(
          state.copyWith(status: CartStatus.error, message: error.toString()),
        );
      },
    );
  }

  Future<void> addProductToCart(ProductModel product) async {
    emit(state.copyWith(status: CartStatus.loading));

    final result = await _cartRemoteDatasource.addProductToCart(product);

    result.fold(
      (failure) => emit(
        state.copyWith(status: CartStatus.error, message: failure.message),
      ),
      (success) => emit(
        state.copyWith(
          status: CartStatus.success,
          message: '${product.name} added to cart',
        ),
      ),
    );
  }

  Future<void> removeCartItem(CartModel item) async {
    emit(state.copyWith(status: CartStatus.loading));

    final result = await _cartRemoteDatasource.removeCartItem(item);

    result.fold(
      (failure) => emit(
        state.copyWith(status: CartStatus.error, message: failure.message),
      ),
      (success) {
        final updatedList = List<CartModel>.from(state.carts!)
          ..removeWhere((element) => element.cartId == item.cartId);

        emit(
          state.copyWith(
            status: CartStatus.success,
            message: '${item.name} removed from cart',
            carts: updatedList,
          ),
        );
      },
    );
  }

  Future<void> decreaseQuantity(CartModel item) async {
    emit(state.copyWith(status: CartStatus.loading));

    final result = await _cartRemoteDatasource.decreaseQuantity(item);

    result.fold(
      (failure) => emit(
        state.copyWith(status: CartStatus.error, message: failure.message),
      ),
      (success) => emit(
        state.copyWith(
          status: CartStatus.success,
          message: '${item.name} quantity decreased',
        ),
      ),
    );
  }

  Future<void> increaseQuantity(CartModel item) async {
    emit(state.copyWith(status: CartStatus.loading));

    final result = await _cartRemoteDatasource.increaseQuantity(item);

    result.fold(
      (failure) => emit(
        state.copyWith(status: CartStatus.error, message: failure.message),
      ),
      (success) => emit(
        state.copyWith(
          status: CartStatus.success,
          message: '${item.name} quantity increased',
        ),
      ),
    );
  }

  Future<void> clearCart() async {
    emit(state.copyWith(status: CartStatus.loading));

    final result = await _cartRemoteDatasource.clearCart();

    result.fold(
      (failure) => emit(
        state.copyWith(status: CartStatus.error, message: failure.message),
      ),
      (success) => emit(
        state.copyWith(status: CartStatus.success, message: 'Cart cleared'),
      ),
    );
  }

  @override
  Future<void> close() {
    _cartSubscription?.cancel();
    return super.close();
  }
}
