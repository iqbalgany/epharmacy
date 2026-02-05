import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epharmacy/constants/firebase_constans.dart';
import 'package:epharmacy/data/models/category_model.dart';

class CategoriesRemoteDatasource {
  final FirebaseFirestore _firebaseFirestore;

  CategoriesRemoteDatasource({FirebaseFirestore? firebaseFirestore})
    : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Stream<List<CategoryModel>> getCategories() {
    return _firebaseFirestore
        .collection(FirebaseConstans.categories)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return CategoryModel.fromMap(doc.data());
          }).toList();
        });
  }
}
