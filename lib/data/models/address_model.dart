// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AddressModel {
  final String? city;
  final String? address;
  final String? houseNumber;
  final int? zipCode;
  AddressModel({this.city, this.address, this.houseNumber, this.zipCode});

  AddressModel copyWith({
    String? city,
    String? address,
    String? houseNumber,
    int? zipCode,
  }) {
    return AddressModel(
      city: city ?? this.city,
      address: address ?? this.address,
      houseNumber: houseNumber ?? this.houseNumber,
      zipCode: zipCode ?? this.zipCode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'city': city,
      'address': address,
      'houseNo': houseNumber,
      'zipCode': zipCode,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      city: map['city'] != null ? map['city'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      houseNumber: map['houseNo'] != null ? map['houseNo'] as String : null,
      zipCode: map['zipCode'] != null ? map['zipCode'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AddressModel(city: $city, address: $address,houseNumber: $houseNumber, zipCode: $zipCode)';
  }

  @override
  bool operator ==(covariant AddressModel other) {
    if (identical(this, other)) return true;

    return other.city == city &&
        other.address == address &&
        other.houseNumber == houseNumber &&
        other.zipCode == zipCode;
  }

  @override
  int get hashCode {
    return city.hashCode ^
        address.hashCode ^
        houseNumber.hashCode ^
        zipCode.hashCode;
  }

  Null get length => null;
}
