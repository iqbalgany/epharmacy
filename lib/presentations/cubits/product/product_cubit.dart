import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:epharmacy/data/models/product_model.dart';
import 'package:epharmacy/data/remote_datasource/product_remote_datasource.dart';
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
        emit(
          state.copyWith(status: ProductStatus.success, products: productData),
        );
      },
      onError: (error) {
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
