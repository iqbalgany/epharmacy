import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseConstans {
  static const categories = 'categories';
  static const products = 'products';
  static const cart = 'cart';
  static const userCollection = 'users';
  static final currentUser = FirebaseAuth.instance.currentUser;
  static final user = FirebaseAuth.instance.currentUser;
  static final cartRef = FirebaseFirestore.instance
      .collection('users')
      .doc(user?.uid.toString());
}
