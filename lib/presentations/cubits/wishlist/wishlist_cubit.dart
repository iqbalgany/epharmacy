import 'package:bloc/bloc.dart';
import 'package:epharmacy/data/local%20storage/product_local_storage.dart';
import 'package:epharmacy/data/models/product_model.dart';
import 'package:equatable/equatable.dart';

part 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit() : super(const WishlistState()) {
    loadWishlist();
  }

  void loadWishlist() {
    emit(state.copyWith(status: WishlistStatus.loading));

    try {
      final box = WishlistLocalStorage.getBox();
      final List<ProductModel> products = box.values.toList();

      emit(state.copyWith(status: WishlistStatus.loaded, wishlist: products));
    } catch (e) {
      emit(
        state.copyWith(
          status: WishlistStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> addProduct(ProductModel product) async {
    try {
      final box = WishlistLocalStorage.getBox();

      if (box.values.any((element) => element.productId == product.productId)) {
        emit(
          state.copyWith(
            status: WishlistStatus.failure,
            errorMessage: 'Produk sudah ada di wishlist',
          ),
        );
        return;
      }

      await box.add(product);

      emit(state.copyWith(status: WishlistStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: WishlistStatus.failure,
          errorMessage: 'Gagal menambahkan produk $e',
        ),
      );
    }
  }

  Future<void> deleteProduct(int index) async {
    try {
      final box = WishlistLocalStorage.getBox();

      await box.deleteAt(index);

      emit(state.copyWith(status: WishlistStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: WishlistStatus.failure,
          errorMessage: 'Gagal menghapus produk $e',
        ),
      );
    }
  }

  Future<void> clearWishlist() async {
    emit(state.copyWith(status: WishlistStatus.loading));
    try {
      final box = WishlistLocalStorage.getBox();

      await box.clear();

      emit(state.copyWith(status: WishlistStatus.success, wishlist: []));
    } catch (e) {
      emit(
        state.copyWith(
          status: WishlistStatus.failure,
          errorMessage: 'Gagal menghilangkan wishlist',
        ),
      );
    }
  }
}
