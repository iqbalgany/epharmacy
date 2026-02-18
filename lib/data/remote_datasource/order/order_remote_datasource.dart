import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epharmacy/constants/firebase_constans.dart';
import 'package:epharmacy/core/failure.dart';
import 'package:epharmacy/data/models/order_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

class OrderRemoteDatasource {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;
  OrderRemoteDatasource(this._firebaseFirestore, this._firebaseAuth);

  CollectionReference<OrderModel> get _ordersRef => _firebaseFirestore
      .collection(FirebaseConstans.orders)
      .withConverter(
        fromFirestore: (snapshot, _) => OrderModel.fromJson(snapshot.data()!),
        toFirestore: (order, _) => order.toJson(),
      );

  Future<Either<dynamic, Unit>> createOrder(OrderModel order) async {
    try {
      await _orders.doc(order.orderId).set(order.toJson());

      return Right(unit);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Stream<List<OrderModel>> getUserOrders(String userId) {
    return _orders.where('uid', isEqualTo: userId).snapshots().map((event) {
      List<OrderModel> orders = [];
      for (var doc in event.docs) {
        orders.add(OrderModel.fromJson(doc.data() as Map<String, dynamic>));
      }
      return orders;
    });
  }
}
