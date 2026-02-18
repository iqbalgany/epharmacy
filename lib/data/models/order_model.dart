// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:epharmacy/data/models/address_model.dart';
import 'package:epharmacy/data/models/cart_model.dart';
import 'package:flutter/foundation.dart';

class OrderModel {
  final String? uid;
  final List<CartModel> products;
  final double total;
  final String orderId;
  final AddressModel address;
  final bool? isAccepted;
  final bool? isDelivered;
  final DateTime date;
  OrderModel({
    this.uid,
    required this.products,
    required this.total,
    required this.orderId,
    required this.address,
    this.isAccepted,
    this.isDelivered,
    required this.date,
  });

  OrderModel copyWith({
    String? uid,
    List<CartModel>? products,
    double? total,
    String? orderId,
    AddressModel? address,
    bool? isAccepted,
    bool? isDelivered,
    DateTime? date,
  }) {
    return OrderModel(
      uid: uid ?? this.uid,
      products: products ?? this.products,
      total: total ?? this.total,
      orderId: orderId ?? this.orderId,
      address: address ?? this.address,
      isAccepted: isAccepted ?? this.isAccepted,
      isDelivered: isDelivered ?? this.isDelivered,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'products': products.map((x) => x.toMap()).toList(),
      'total': total,
      'orderId': orderId,
      'address': address.toMap(),
      'isAccepted': isAccepted,
      'isDelivered': isDelivered,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      products: List<CartModel>.from(
        (map['products'] as List<int>).map<CartModel>(
          (x) => CartModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      total: map['total'] as double,
      orderId: map['orderId'] as String,
      address: AddressModel.fromMap(map['address'] as Map<String, dynamic>),
      isAccepted: map['isAccepted'] != null ? map['isAccepted'] as bool : null,
      isDelivered: map['isDelivered'] != null
          ? map['isDelivered'] as bool
          : null,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrderModel(uid: $uid, products: $products, total: $total, orderId: $orderId, address: $address, isAccepted: $isAccepted, isDelivered: $isDelivered, date: $date)';
  }

  @override
  bool operator ==(covariant OrderModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        listEquals(other.products, products) &&
        other.total == total &&
        other.orderId == orderId &&
        other.address == address &&
        other.isAccepted == isAccepted &&
        other.isDelivered == isDelivered &&
        other.date == date;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        products.hashCode ^
        total.hashCode ^
        orderId.hashCode ^
        address.hashCode ^
        isAccepted.hashCode ^
        isDelivered.hashCode ^
        date.hashCode;
  }
}
