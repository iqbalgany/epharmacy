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

  Future<Either<Failure, Unit>> addProductToCart(ProductModel product) async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        return Left(Failure(message: 'User is not authenticated'));
      }

      String cartId = const Uuid().v1();

      await _firebaseFirestore
          .collection(FirebaseConstans.carts)
          .doc(user.uid)
          .set({
            'cart': FieldValue.arrayUnion([
              CartModel(
                cartId: cartId,
                image: product.image.toString(),
                productId: product.productId.toString(),
                quantity: 1,
                cost: product.price.toDouble(),
                name: product.name,
                price: product.price,
              ).toJson(),
            ]),
          }, SetOptions(merge: true));

      return Right(unit);
    } on FirebaseException catch (e) {
      return Left(
        Failure(message: e.message ?? 'An error on firebase occurred'),
      );
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

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
