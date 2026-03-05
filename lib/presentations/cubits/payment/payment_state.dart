// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'payment_cubit.dart';

enum PaymentStatus { initial, loading, success, error }

class PaymentState extends Equatable {
  final PaymentStatus status;
  final PaymentModel? payment;
  final String errorMessage;
  const PaymentState({
    this.status = PaymentStatus.initial,
    this.payment,
    this.errorMessage = '',
  });

  @override
  List<Object?> get props => [status, payment, errorMessage];

  PaymentState copyWith({
    PaymentStatus? status,
    PaymentModel? payment,
    String? errorMessage,
  }) {
    return PaymentState(
      status: status ?? this.status,
      payment: payment ?? this.payment,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
