import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epharmacy/constants/firebase_constans.dart';
import 'package:epharmacy/core/failure.dart';
import 'package:epharmacy/data/models/address_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

class AddressRemoteDatasource {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;

  AddressRemoteDatasource(this._firebaseAuth, this._firebaseFirestore);

  String? _getuid() => _firebaseAuth.currentUser?.uid;

  Future<Either<Failure, Unit>> addAddress(AddressModel address) async {
    try {
      final uid = _getuid();

      if (uid == null) {
        return Left(Failure(message: 'User is not authenticated'));
      }

      await _firebaseFirestore
          .collection(FirebaseConstans.address)
          .doc(uid)
          .set(address.toMap());

      return Right(unit);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Stream<AddressModel?> getAddress() {
    final uid = _getuid();
    if (uid == null) {
      return Stream.error('User is not authenticated');
    }
    return _firebaseFirestore
        .collection(FirebaseConstans.address)
        .doc(uid)
        .snapshots()
        .map((event) {
          if (event.exists && event.data() != null) {
            return AddressModel.fromMap(event.data() as Map<String, dynamic>);
          } else {
            throw Exception('Alamat belum diatur');
          }
        });
  }

  Future<Either<Failure, Unit>> updateAddress(AddressModel address) async {
    try {
      final uid = _getuid();
      if (uid == null) {
        return Left(Failure(message: 'User is not authenticated'));
      }

      await _firebaseFirestore
          .collection(FirebaseConstans.address)
          .doc(uid)
          .update(address.toMap());

      return Right(unit);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
