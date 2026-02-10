import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epharmacy/constants/firebase_constans.dart';
import 'package:epharmacy/core/failure.dart';
import 'package:epharmacy/data/models/cart_model.dart';
import 'package:epharmacy/data/models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class CartRemoteDatasource {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;
  CartRemoteDatasource(this._firebaseFirestore, this._firebaseAuth);

  String? _getuid() => _firebaseAuth.currentUser?.uid;
  Stream<List<CartModel>> getCartItems() {
    final uid = _getuid();
    if (uid == null) {
      log("DEBUG: UID is null");
      return Stream.error('User is not authenticated');
    }

    return _firebaseFirestore
        .collection(FirebaseConstans.carts)
        .doc(uid)
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists || snapshot.data() == null) {
            log("DEBUG: Dokumen cart untuk UID $uid tidak ditemukan");
            return [];
          }

          final data = snapshot.data() as Map<String, dynamic>;

          // Debugging log
          log("DEBUG: Raw Data Firestore: $data");

          final List<dynamic> cartList = data['cart'] ?? [];

          try {
            return cartList
                .map((item) {
                  try {
                    // --- PERBAIKAN DI SINI ---
                    // Gunakan .fromMap karena item sudah berupa Map, bukan String JSON
                    return CartModel.fromMap(item as Map<String, dynamic>);
                    // -------------------------
                  } catch (e) {
                    log("DEBUG: Error parsing item $item. Error: $e");
                    // Kita return null dulu agar tidak throw exception fatal
                    // Nanti kita filter di bawah
                    return null;
                  }
                })
                // Filter item yang null (gagal parsing) agar list tetap valid
                .where((element) => element != null)
                .cast<CartModel>() // Ubah tipe kembali ke List<CartModel>
                .toList();
          } catch (e) {
            log("DEBUG: Fatal Error saat mapping list: $e");
            return <CartModel>[];
          }
        });
  }

  Future<Either<Failure, Unit>> addProductToCart(ProductModel product) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return Left(Failure(message: 'User is not authenticated'));
      }

      final docRef = _firebaseFirestore
          .collection(FirebaseConstans.carts)
          .doc(user.uid);

      // Gunakan Transaction agar aman saat update data bersamaan
      await _firebaseFirestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        // Jika dokumen belum ada, buat baru
        if (!snapshot.exists) {
          String cartId = const Uuid().v1();
          transaction.set(docRef, {
            'cart': [
              CartModel(
                cartId: cartId,
                image: product.image.toString(),
                productId: product.productId.toString(),
                quantity: 1,
                cost: product.price.toDouble(),
                name: product.name,
                price: product.price,
              ).toMap(), // Gunakan toMap()
            ],
          });
          return;
        }

        final data = snapshot.data() as Map<String, dynamic>;
        final List<dynamic> rawList = List.from(data['cart'] ?? []);

        // Cek apakah produk ini SUDAH ADA di cart berdasarkan productId
        final index = rawList.indexWhere(
          (item) => item['productId'] == product.productId.toString(),
        );

        if (index != -1) {
          // --- SKENARIO 1: PRODUK SUDAH ADA -> UPDATE QUANTITY ---
          final currentQty = rawList[index]['quantity'] as int;
          rawList[index]['quantity'] = currentQty + 1;
          // Opsional: Update cost total jika perlu (price * quantity baru)
        } else {
          // --- SKENARIO 2: PRODUK BARU -> TAMBAH KE LIST ---
          String cartId = const Uuid().v1();
          rawList.add(
            CartModel(
              cartId: cartId,
              image: product.image.toString(),
              productId: product.productId.toString(),
              quantity: 1,
              cost: product.price.toDouble(),
              name: product.name,
              price: product.price,
            ).toMap(),
          );
        }

        transaction.update(docRef, {'cart': rawList});
      });

      return Right(unit);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  // Future<Either<Failure, Unit>> addProductToCart(ProductModel product) async {
  //   try {
  //     final user = _firebaseAuth.currentUser;

  //     if (user == null) {
  //       return Left(Failure(message: 'User is not authenticated'));
  //     }

  //     String cartId = const Uuid().v1();

  //     await _firebaseFirestore
  //         .collection(FirebaseConstans.carts)
  //         .doc(user.uid)
  //         .set({
  //           'cart': FieldValue.arrayUnion([
  //             CartModel(
  //               cartId: cartId,
  //               image: product.image.toString(),
  //               productId: product.productId.toString(),
  //               quantity: 1,
  //               cost: product.price.toDouble(),
  //               name: product.name,
  //               price: product.price,
  //             ).toJson(),
  //           ]),
  //         }, SetOptions(merge: true));

  //     return Right(unit);
  //   } on FirebaseException catch (e) {
  //     return Left(
  //       Failure(message: e.message ?? 'An error on firebase occurred'),
  //     );
  //   } catch (e) {
  //     return Left(Failure(message: e.toString()));
  //   }
  // }

  Future<Either<dynamic, Unit>> removeCartItem(CartModel cartItem) async {
    try {
      final uid = _getuid();
      if (uid == null) {
        return Left(Failure(message: 'User is not authenticated'));
      }

      await _firebaseFirestore
          .collection(FirebaseConstans.carts)
          .doc(uid)
          .update({
            'cart': FieldValue.arrayRemove([cartItem.toJson()]),
          });

      return Right(unit);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, Unit>> clearCart() async {
    try {
      final uid = _getuid();
      if (uid == null) {
        return Left(Failure(message: 'User is not authenticated'));
      }
      await _firebaseFirestore
          .collection(FirebaseConstans.carts)
          .doc(uid)
          .update({'cart': FieldValue.delete()});
      return Right(unit);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, Unit>> increaseQuantity(CartModel item) async {
    try {
      final uid = _getuid();
      if (uid == null) {
        return Left(Failure(message: 'User is not authenticated'));
      }

      final cartRef = _firebaseFirestore
          .collection(FirebaseConstans.carts)
          .doc(uid);

      await _firebaseFirestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(cartRef);

        if (!snapshot.exists) return;

        final data = snapshot.data() as Map<String, dynamic>;

        final List<dynamic> rawList = data['cart'] ?? [];

        final index = rawList.indexWhere(
          (element) => element['cartId'] == item.cartId,
        );

        if (index != -1) {
          final currentQty = rawList[index]['quantity'] as int? ?? 0;
          rawList[index]['quantity'] = currentQty + 1;

          transaction.update(cartRef, {'cart': rawList});
        }
      });

      return Right(unit);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, Unit>> decreaseQuantity(CartModel item) async {
    try {
      final uid = _getuid();
      if (uid == null) {
        return Left(Failure(message: 'User is not authenticated'));
      }

      final cartRef = _firebaseFirestore
          .collection(FirebaseConstans.carts)
          .doc(uid);

      await _firebaseFirestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(cartRef);
        if (!snapshot.exists) return;

        final data = snapshot.data() as Map<String, dynamic>;
        final List<dynamic> rawList = List.from(data['cart'] ?? []);

        final index = rawList.indexWhere(
          (element) => element['cartId'] == item.cartId,
        );

        if (index != -1) {
          final currentQty = rawList[index]['quantity'] as int? ?? 1;

          if (currentQty > 1) {
            rawList[index]['quantity'] = currentQty - 1;
          } else {
            rawList.removeAt(index);
          }

          transaction.update(cartRef, {'cart': rawList});
        }
      });
      return Right(unit);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
