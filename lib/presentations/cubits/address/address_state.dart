// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'address_cubit.dart';

enum AddressStatus { initial, loading, success, error }

class AddressState extends Equatable {
  final AddressStatus? status;
  final String? errorMessage;
  final AddressModel? address;
  const AddressState({
    this.status = AddressStatus.initial,
    this.errorMessage = '',
    this.address,
  });

  @override
  List<Object?> get props => [status, errorMessage, address];

  AddressState copyWith({
    AddressStatus? status,
    String? errorMessage,
    AddressModel? address,
  }) {
    return AddressState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      address: address ?? this.address,
    );
  }
}
