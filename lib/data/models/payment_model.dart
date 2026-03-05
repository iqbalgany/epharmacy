// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PaymentModel {
  final String transactionId;
  final double amount;
  final String userId;
  final DateTime date;
  final String status;

  PaymentModel({
    required this.transactionId,
    required this.amount,
    required this.userId,
    required this.date,
    required this.status,
  });

  PaymentModel copyWith({
    String? transactionId,
    double? amount,
    String? userId,
    DateTime? date,
    String? status,
  }) {
    return PaymentModel(
      transactionId: transactionId ?? this.transactionId,
      amount: amount ?? this.amount,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'transactionId': transactionId,
      'amount': amount,
      'userId': userId,
      'date': date.millisecondsSinceEpoch,
      'status': status,
    };
  }

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      transactionId: map['transactionId'] as String,
      amount: map['amount'] as double,
      userId: map['userId'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentModel.fromJson(String source) =>
      PaymentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PaymentModel(transactionId: $transactionId, amount: $amount, userId: $userId, date: $date, status: $status)';
  }

  @override
  bool operator ==(covariant PaymentModel other) {
    if (identical(this, other)) return true;

    return other.transactionId == transactionId &&
        other.amount == amount &&
        other.userId == userId &&
        other.date == date &&
        other.status == status;
  }

  @override
  int get hashCode {
    return transactionId.hashCode ^
        amount.hashCode ^
        userId.hashCode ^
        date.hashCode ^
        status.hashCode;
  }
}
