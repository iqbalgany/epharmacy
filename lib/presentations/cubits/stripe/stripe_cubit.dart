import 'package:bloc/bloc.dart';
import 'package:epharmacy/data/remote_datasource/stripe/stripe_remote_datasource.dart';
import 'package:epharmacy/presentations/cubits/payment/payment_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

part 'stripe_state.dart';

class StripeCubit extends Cubit<StripeState> {
  final StripeRemoteDatasource _stripeRemoteDatasource;
  final PaymentCubit _paymentCubit;

  StripeCubit(this._stripeRemoteDatasource, this._paymentCubit)
    : super(const StripeState());

  Future<void> processStripePayment(double amount) async {
    emit(state.copyWith(status: StripeStatus.loading));

    try {
      final paymentIntent = await _stripeRemoteDatasource.createPaymentIntent(
        amount.toString(),
        'IDR',
      );

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          merchantDisplayName: 'epharmacy',
          paymentIntentClientSecret: paymentIntent['client_secret'],
          customerEphemeralKeySecret: paymentIntent['ephemeralKey'],
          customerId: paymentIntent['customer'],
          style: ThemeMode.system,
          applePay: PaymentSheetApplePay(merchantCountryCode: 'ID'),
          googlePay: PaymentSheetGooglePay(
            merchantCountryCode: 'ID',
            testEnv: true,
          ),
          allowsDelayedPaymentMethods: true,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        await _paymentCubit.createPayment(
          paymentIntent['id'],
          amount,
          currentUser.uid,
          'Succeeded',
        );
      }

      emit(state.copyWith(status: StripeStatus.success));
    } catch (e) {
      if (e is StripeException) {
        emit(
          state.copyWith(
            status: StripeStatus.failure,
            errorMessage: 'Pembayaran dibatalkan',
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: StripeStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }
}
