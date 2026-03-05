import 'package:bloc/bloc.dart';
import 'package:epharmacy/data/models/payment_model.dart';
import 'package:epharmacy/data/remote_datasource/payment/payment_remote_datasource.dart';
import 'package:equatable/equatable.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRemoteDatasource _paymentRemoteDatasource;
  PaymentCubit(this._paymentRemoteDatasource) : super(const PaymentState());

  Future<void> createPayment(
    String transactionId,
    double amount,
    String userId,
    String status,
  ) async {
    emit(state.copyWith(status: PaymentStatus.loading));

    final paymentData = PaymentModel(
      transactionId: transactionId,
      amount: amount,
      userId: userId,
      date: DateTime.now(),
      status: status,
    );

    final result = await _paymentRemoteDatasource.createPayment(paymentData);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PaymentStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (success) => emit(
        state.copyWith(status: PaymentStatus.success, payment: paymentData),
      ),
    );
  }
}
