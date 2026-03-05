// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epharmacy/core/constants/firebase_constans.dart';
import 'package:epharmacy/core/failure.dart';
import 'package:epharmacy/data/models/payment_model.dart';
import 'package:fpdart/fpdart.dart';

class PaymentRemoteDatasource {
  final FirebaseFirestore _firebaseFirestore;
  PaymentRemoteDatasource(this._firebaseFirestore);

  CollectionReference get _payments =>
      _firebaseFirestore.collection(FirebaseConstans.payments);

  Future<Either<Failure, Unit>> createPayment(PaymentModel payment) async {
    try {
      await _payments.doc(payment.transactionId).set(payment.toMap());
      return Right(unit);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
