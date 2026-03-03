import 'package:dio/dio.dart';
import 'package:epharmacy/core/constants/api_constants.dart';
import 'package:epharmacy/core/constants/helpers.dart';

class StripeRemoteDatasource {
  final Dio _dio;

  StripeRemoteDatasource(this._dio);

  Future<Map<String, dynamic>> createPaymentIntent(
    String amount,
    String currency,
  ) async {
    try {
      final response = await _dio.post(
        ApiConstants.paymentUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${ApiConstants.stripeSecret}',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        data: {'amount': Helpers.calculateAmount(amount), 'currency': currency},
      );

      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['error']['message'] ?? 'Payment Intent Error';
    }
  }
}
