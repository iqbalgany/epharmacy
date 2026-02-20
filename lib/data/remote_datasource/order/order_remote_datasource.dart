import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epharmacy/constants/firebase_constans.dart';
import 'package:epharmacy/core/failure.dart';
import 'package:epharmacy/data/models/order_model.dart';
import 'package:fpdart/fpdart.dart';

class OrderRemoteDatasource {
  final FirebaseFirestore _firebaseFirestore;
  OrderRemoteDatasource(this._firebaseFirestore);

  CollectionReference<OrderModel> get _ordersRef => _firebaseFirestore
      .collection(FirebaseConstans.orders)
      .withConverter<OrderModel>(
        fromFirestore: (snapshot, _) => OrderModel.fromMap(snapshot.data()!),
        toFirestore: (order, _) => order.toMap(),
      );

  Future<Either<dynamic, Unit>> createOrder(OrderModel order) async {
    try {
      await _ordersRef.doc(order.orderId).set(order);

      return Right(unit);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Stream<List<OrderModel>> getUserOrders(String userId) {
    return _ordersRef
        .where('uid', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => doc.data()).toList();
        });
  }
}
