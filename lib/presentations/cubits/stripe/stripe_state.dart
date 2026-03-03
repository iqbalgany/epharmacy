// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'stripe_cubit.dart';

enum StripeStatus { initial, loading, success, failure }

class StripeState extends Equatable {
  final StripeStatus status;
  final String? errorMessage;
  const StripeState({
    this.status = StripeStatus.initial,
    this.errorMessage = '',
  });

  @override
  List<Object?> get props => [status, errorMessage];

  StripeState copyWith({StripeStatus? status, String? errorMessage}) {
    return StripeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
