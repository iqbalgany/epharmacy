import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:epharmacy/data/models/product_model.dart';
import 'package:epharmacy/data/remote_datasource/product/product_remote_datasource.dart';
import 'package:equatable/equatable.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRemoteDatasource _productRemoteDatasource;
  StreamSubscription? _productsSubscription;

  ProductCubit(this._productRemoteDatasource) : super(const ProductState()) {
    getProducts();
  }

  void getProducts() {
    emit(state.copyWith(status: ProductStatus.loading));

    _productsSubscription?.cancel();

    _productsSubscription = _productRemoteDatasource.getProducts().listen(
      (productData) {
        if (isClosed) return;

        emit(
          state.copyWith(status: ProductStatus.success, products: productData),
        );
      },
      onError: (error) {
        if (isClosed) return;

        emit(
          state.copyWith(
            status: ProductStatus.error,
            errorMessage: error.toString(),
          ),
        );
      },
    );
  }

  void getProductById(String productId) {
    emit(state.copyWith(status: ProductStatus.loading));

    _productsSubscription?.cancel();

    _productsSubscription = _productRemoteDatasource
        .getProductById(productId)
        .listen(
          (productData) {
            if (isClosed) return;

            emit(
              state.copyWith(
                status: ProductStatus.success,
                product: productData,
              ),
            );
          },
          onError: (error) {
            if (isClosed) return;

            emit(
              state.copyWith(
                status: ProductStatus.error,
                errorMessage: error.toString(),
              ),
            );
          },
        );
  }

  void getProductByCategory(String categoryName) {
    emit(state.copyWith(status: ProductStatus.loading));

    _productsSubscription?.cancel();

    _productsSubscription = _productRemoteDatasource
        .getProductByCategory(categoryName)
        .listen(
          (products) {
            if (isClosed) return;

            emit(
              state.copyWith(status: ProductStatus.success, products: products),
            );
          },
          onError: (error) {
            if (isClosed) return;

            emit(
              state.copyWith(
                status: ProductStatus.error,
                errorMessage: error.toString(),
              ),
            );
          },
        );
  }

  void getRelatedProducts(String categoryName) {
    emit(state.copyWith(status: ProductStatus.loading));

    _productsSubscription?.cancel();

    _productsSubscription = _productRemoteDatasource
        .getRelatedProducts(categoryName)
        .listen(
          (products) {
            if (isClosed) return;

            emit(
              state.copyWith(status: ProductStatus.success, products: products),
            );
          },
          onError: (error) {
            if (isClosed) return;

            emit(
              state.copyWith(
                status: ProductStatus.error,
                errorMessage: error.toString(),
              ),
            );
          },
        );
  }

  void searchProducts(String search) {
    emit(state.copyWith(status: ProductStatus.loading));

    _productsSubscription?.cancel();

    _productsSubscription = _productRemoteDatasource
        .searchProducts(search)
        .listen(
          (products) {
            if (isClosed) return;

            emit(
              state.copyWith(status: ProductStatus.success, products: products),
            );
          },
          onError: (error) {
            if (isClosed) return;

            emit(
              state.copyWith(
                status: ProductStatus.error,
                errorMessage: error.toString(),
              ),
            );
          },
        );
  }

  @override
  Future<void> close() {
    _productsSubscription?.cancel();
    return super.close();
  }
}
