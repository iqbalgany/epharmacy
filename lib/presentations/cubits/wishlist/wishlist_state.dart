// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'wishlist_cubit.dart';

enum WishlistStatus { initial, loading, loaded, success, failure }

class WishlistState extends Equatable {
  final WishlistStatus status;
  final List<ProductModel> wishlist;
  final String errorMessage;
  const WishlistState({
    this.status = WishlistStatus.initial,
    this.wishlist = const [],
    this.errorMessage = '',
  });

  @override
  List<Object> get props => [status, wishlist, errorMessage];

  WishlistState copyWith({
    WishlistStatus? status,
    List<ProductModel>? wishlist,
    String? errorMessage,
  }) {
    return WishlistState(
      status: status ?? this.status,
      wishlist: wishlist ?? this.wishlist,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
