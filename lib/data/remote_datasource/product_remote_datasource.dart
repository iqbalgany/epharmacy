import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epharmacy/constants/firebase_constans.dart';
import 'package:epharmacy/data/models/product_model.dart';

class ProductRemoteDatasource {
  final FirebaseFirestore _firebaseFirestore;

  ProductRemoteDatasource({FirebaseFirestore? firebaseFirestore})
    : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Stream<List<ProductModel>> getProducts() {
    return _firebaseFirestore
        .collection(FirebaseConstans.products)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['productId'] = doc.id;
            return ProductModel.fromMap(data);
          }).toList();
        });
  }
}
