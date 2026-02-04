import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:epharmacy/data/models/category_model.dart';
import 'package:epharmacy/data/remote_datasource/categories_remote_datasource.dart';
import 'package:equatable/equatable.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final CategoriesRemoteDatasource _categoriesRemoteDatasource;
  StreamSubscription? _categoriesSubscription;

  CategoriesCubit(this._categoriesRemoteDatasource)
    : super(const CategoriesState()) {
    getCategories();
  }

  void getCategories() {
    emit(state.copyWith(status: CategoriesStatus.loading));

    _categoriesSubscription?.cancel();

    _categoriesSubscription = _categoriesRemoteDatasource
        .getCategories()
        .listen(
          (categoriesData) {
            emit(
              state.copyWith(
                status: CategoriesStatus.success,
                categories: categoriesData,
              ),
            );
          },
          onError: (error) {
            emit(
              state.copyWith(
                status: CategoriesStatus.error,
                errorMessage: error.toString(),
              ),
            );
          },
        );
  }

  @override
  Future<void> close() {
    _categoriesSubscription?.cancel();
    return super.close();
  }
}
