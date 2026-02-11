import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epharmacy/constants/firebase_constans.dart';
import 'package:epharmacy/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDatasource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<User?> get authStatechange => _firebaseAuth.authStateChanges();

  Future<UserModel?> getCurrentUserData() async {
    try {
      final User? currentUser = _firebaseAuth.currentUser;

      if (currentUser != null) {
        DocumentSnapshot doc = await _firebaseFirestore
            .collection(FirebaseConstans.users)
            .doc(currentUser.uid)
            .get();

        if (doc.exists) {
          return UserModel.fromMap(doc.data() as Map<String, dynamic>);
        }
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> signupWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? profileImage,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      UserModel newUser = UserModel(
        uid: userCredential.user!.uid,
        firstName: firstName,
        lastName: lastName,
        profileImage: profileImage,
      );

      await _firebaseFirestore
          .collection(FirebaseConstans.users)
          .doc(newUser.uid)
          .set(newUser.toMap());

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
