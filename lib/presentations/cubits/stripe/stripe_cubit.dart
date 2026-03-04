import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:epharmacy/data/remote_datasource/stripe/stripe_remote_datasource.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

part 'stripe_state.dart';

class StripeCubit extends Cubit<StripeState> {
  final StripeRemoteDatasource _stripeRemoteDatasource;

  StripeCubit(this._stripeRemoteDatasource) : super(const StripeState());

  Future<void> processStripePayment(double amount) async {
    emit(state.copyWith(status: StripeStatus.loading));

    try {
      log("Step 1: Creating Intent");
      final paymentIntent = await _stripeRemoteDatasource.createPaymentIntent(
        amount.toString(),
        'IDR',
      );

      log("Step 2: Initializing Payment Sheet");
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

      log("Step 3: Presenting Payment Sheet");
      await Stripe.instance.presentPaymentSheet();

      emit(state.copyWith(status: StripeStatus.success));
    } catch (e) {
      log("Stripe Error: $e");
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
