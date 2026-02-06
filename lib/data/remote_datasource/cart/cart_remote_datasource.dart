import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epharmacy/data/models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CartRemoteDatasource {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;
  final FirebaseStorage _firebaseStorage;
  CartRemoteDatasource({
    required FirebaseFirestore firebaseFirestore,
    required FirebaseAuth firebaseAuth,
    required FirebaseStorage firebaseStorage,
  }) : _firebaseFirestore = firebaseFirestore,
       _firebaseAuth = firebaseAuth,
       _firebaseStorage = firebaseStorage;


       Either<dynamic, Future<void>addProductToCart(ProductModel product, BuildContext context) {
        String cartId = const Uuid
       }
}
