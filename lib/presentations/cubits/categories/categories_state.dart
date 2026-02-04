// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'categories_cubit.dart';

enum CategoriesStatus { initial, loading, success, error }

class CategoriesState extends Equatable {
  final CategoriesStatus status;
  final List<CategoryModel> categories;
  final String errorMessage;
  const CategoriesState({
    this.status = CategoriesStatus.initial,
    this.categories = const [],
    this.errorMessage = '',
  });

  @override
  List<Object> get props => [status, categories, errorMessage];

  CategoriesState copyWith({
    CategoriesStatus? status,
    List<CategoryModel>? categories,
    String? errorMessage,
  }) {
    return CategoriesState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
