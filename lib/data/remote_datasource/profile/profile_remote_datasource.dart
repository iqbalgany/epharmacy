import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epharmacy/constants/firebase_constans.dart';
import 'package:epharmacy/data/models/user_model.dart';

class ProfileRemoteDatasource {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<UserModel> updateUserProfile({required UserModel user}) async {
    try {
      await _firebaseFirestore
          .collection(FirebaseConstans.users)
          .doc(user.uid)
          .update(user.toMap());

      return user;
    } catch (e) {
      rethrow;
    }
  }
}
