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

  Stream<ProductModel> getProductById(String productId) {
    return _firebaseFirestore
        .collection(FirebaseConstans.products)
        .doc(productId)
        .snapshots()
        .map((snapshot) {
          return ProductModel.fromMap(snapshot.data() as Map<String, dynamic>);
        });
  }

  Stream<List<ProductModel>> getProductByCategory(String categoryName) {
    CollectionReference productCollection = _firebaseFirestore.collection(
      FirebaseConstans.products,
    );

    Query query = productCollection;

    if (categoryName != 'All') {
      query = query.where('categoryName', isEqualTo: categoryName);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['productId'] = doc.id;
        return ProductModel.fromMap(data);
      }).toList();
    });
  }

  Stream<List<ProductModel>> getRelatedProducts(String categoryName) {
    CollectionReference productCollection = _firebaseFirestore.collection(
      FirebaseConstans.products,
    );

    Query query = productCollection;

    if (categoryName != 'All') {
      query = query.where('categoryName', isEqualTo: categoryName);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['productId'] = doc.id;
        return ProductModel.fromMap(data);
      }).toList();
    });
  }

  Stream<List<ProductModel>> searchProducts(String search) {
    return _firebaseFirestore
        .collection(FirebaseConstans.products)
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
          final allProducts = snapshot.docs.map((doc) {
            final data = doc.data();
            data['productId'] = doc.id;
            return ProductModel.fromMap(data);
          }).toList();

          if (search.isEmpty) {
            return allProducts;
          } else {
            return allProducts.where((product) {
              final productName = product.name.toLowerCase();
              final searchInput = search.toLowerCase();

              return productName.contains(searchInput);
            }).toList();
          }
        });
  }
}
