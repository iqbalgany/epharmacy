import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:epharmacy/data/models/address_model.dart';
import 'package:epharmacy/data/remote_datasource/address/address_remote_datasource.dart';
import 'package:equatable/equatable.dart';

part 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  final AddressRemoteDatasource _addressRemoteDatasource;
  AddressCubit(this._addressRemoteDatasource) : super(const AddressState());

  StreamSubscription? _cartSubscription;

  Future<void> addAddress(AddressModel address) async {
    emit(state.copyWith(status: AddressStatus.loading));

    try {
      final result = await _addressRemoteDatasource.addAddress(address);

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: AddressStatus.error,
              errorMessage: failure.message,
            ),
          );
        },
        (success) {
          emit(state.copyWith(status: AddressStatus.success, address: address));
        },
      );
    } catch (e) {
      emit(
        state.copyWith(status: AddressStatus.error, errorMessage: e.toString()),
      );
    }
  }

  void getAddress() {
    _cartSubscription?.cancel();

    _cartSubscription = _addressRemoteDatasource.getAddress().listen(
      (address) {
        log("DEBUG: Cubit menerima ${address.length} address");
        emit(state.copyWith(status: AddressStatus.success, address: address));
      },
      onError: (error) {
        log("DEBUG: Cubit Error: $error");
        emit(
          state.copyWith(
            status: AddressStatus.error,
            errorMessage: error.toString(),
          ),
        );
      },
    );
  }

  Future<void> updateAddress(AddressModel address) async {
    emit(state.copyWith(status: AddressStatus.loading));
    try {
      final result = await _addressRemoteDatasource.updateAddress(address);

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: AddressStatus.error,
              errorMessage: failure.message,
            ),
          );
        },
        (success) {
          emit(state.copyWith(status: AddressStatus.success, address: address));
        },
      );
    } catch (e) {
      emit(
        state.copyWith(status: AddressStatus.error, errorMessage: e.toString()),
      );
    }
  }
}
