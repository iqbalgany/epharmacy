import 'dart:convert';

import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class ProductModel {
  @HiveField(0)
  final String productId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String image;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final double oldPrice;

  @HiveField(5)
  final bool? isAvailable;

  @HiveField(6)
  final String description;

  @HiveField(7)
  final String? categoryName;

  ProductModel({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.oldPrice,
    this.isAvailable = true,
    required this.description,
    this.categoryName,
  });

  ProductModel copyWith({
    String? productId,
    String? name,
    String? image,
    double? price,
    double? oldPrice,
    bool? isAvailable,
    String? description,
    String? categoryName,
  }) {
    return ProductModel(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      isAvailable: isAvailable ?? this.isAvailable,
      description: description ?? this.description,
      categoryName: categoryName ?? this.categoryName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productId': productId,
      'name': name,
      'image': image,
      'price': price,
      'oldPrice': oldPrice,
      'isAvailable': isAvailable,
      'description': description,
      'categoryName': categoryName,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productId: map['productId'] as String? ?? '',
      name: map['name'] as String? ?? 'No Name',
      image: map['image'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      oldPrice: (map['oldPrice'] as num?)?.toDouble() ?? 0.0,
      isAvailable: map['isAvailable'] != null
          ? map['isAvailable'] as bool?
          : true,
      description: map['description'] as String? ?? '',
      categoryName: map['categoryName'] != null
          ? map['categoryName'] as String?
          : '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductModel(productId: $productId, name: $name, image: $image, price: $price, oldPrice: $oldPrice, isAvailable: $isAvailable, description: $description, categoryName: $categoryName)';
  }

  @override
  bool operator ==(covariant ProductModel other) {
    if (identical(this, other)) return true;

    return other.productId == productId &&
        other.name == name &&
        other.image == image &&
        other.price == price &&
        other.oldPrice == oldPrice &&
        other.isAvailable == isAvailable &&
        other.description == description &&
        other.categoryName == categoryName;
  }

  @override
  int get hashCode {
    return productId.hashCode ^
        name.hashCode ^
        image.hashCode ^
        price.hashCode ^
        oldPrice.hashCode ^
        isAvailable.hashCode ^
        description.hashCode ^
        categoryName.hashCode;
  }
}
