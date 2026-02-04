// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'product_cubit.dart';

enum ProductStatus { initial, loading, success, error }

class ProductState extends Equatable {
  final ProductStatus status;
  final List<ProductModel> products;
  final String errorMessage;
  const ProductState({
    this.status = ProductStatus.initial,
    this.products = const [],
    this.errorMessage = '',
  });

  @override
  List<Object> get props => [status, products, errorMessage];

  ProductState copyWith({
    ProductStatus? status,
    List<ProductModel>? products,
    String? errorMessage,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
