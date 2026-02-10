import 'dart:convert';

class CartModel {
  final String? cartId;
  final String? image;
  final String? productId;
  int? quantity;
  final double? cost;
  final String? name;
  final double? price;
  CartModel({
    this.cartId,
    this.image,
    this.productId,
    this.quantity,
    this.cost,
    this.name,
    this.price,
  });

  CartModel copyWith({
    String? cartId,
    String? image,
    String? productId,
    int? quantity,
    double? cost,
    String? name,
    double? price,
  }) {
    return CartModel(
      cartId: cartId ?? this.cartId,
      image: image ?? this.image,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      cost: cost ?? this.cost,
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cartId': cartId,
      'image': image,
      'productId': productId,
      'quantity': quantity,
      'cost': cost,
      'name': name,
      'price': price,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      cartId: map['cartId'] as String?,
      image: map['image'] as String?,
      productId: map['productId'] as String?,
      name: map['name'] as String?,
      quantity: (map['quantity'] as num?)?.toInt(),
      cost: (map['cost'] as num?)?.toDouble(),
      price: (map['price'] as num?)?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory CartModel.fromJson(String source) =>
      CartModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CartModel(cartId: $cartId, image: $image, productId: $productId, quantity: $quantity, cost: $cost, name: $name, price: $price)';
  }

  @override
  bool operator ==(covariant CartModel other) {
    if (identical(this, other)) return true;

    return other.cartId == cartId &&
        other.image == image &&
        other.productId == productId &&
        other.quantity == quantity &&
        other.cost == cost &&
        other.name == name &&
        other.price == price;
  }

  @override
  int get hashCode {
    return cartId.hashCode ^
        image.hashCode ^
        productId.hashCode ^
        quantity.hashCode ^
        cost.hashCode ^
        name.hashCode ^
        price.hashCode;
  }
}
