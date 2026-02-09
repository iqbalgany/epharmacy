// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:epharmacy/data/models/cart_model.dart';
import 'package:flutter/foundation.dart';

class UserModel {
  String uid;
  String? firstName;
  String? lastName;
  String? address;
  String? profileImage;
  List<CartModel>? cart;
  UserModel({
    required this.uid,
    this.firstName,
    this.lastName,
    this.address,
    this.profileImage,
    this.cart,
  });

  UserModel copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    String? address,
    String? profileImage,
    List<CartModel>? cart,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      address: address ?? this.address,
      profileImage: profileImage ?? this.profileImage,
      cart: cart ?? this.cart,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'profileImage': profileImage,
      'cart': cart?.map((x) => x.toMap()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      firstName: map['firstName'] != null ? map['firstName'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      profileImage: map['profileImage'] != null
          ? map['profileImage'] as String
          : null,
      cart: map['cart'] != null
          ? List<CartModel>.from(
              (map['cart'] as List<int>).map<CartModel?>(
                (x) => CartModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, firstName: $firstName, lastName: $lastName, address: $address, profileImage: $profileImage, cart: $cart)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.address == address &&
        other.profileImage == profileImage &&
        listEquals(other.cart, cart);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        address.hashCode ^
        profileImage.hashCode ^
        cart.hashCode;
  }
}
