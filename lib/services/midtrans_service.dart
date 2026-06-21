import 'package:supabase_flutter/supabase_flutter.dart';

class MidtransService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> createPayment({
    required String orderId,
    required int amount,
  }) async {
    try {
      final response = await supabase.functions.invoke(
        "rapid-action",
        body: {
          "order_id": orderId,
          "amount": amount,
        },
      );

      if (response.data == null) {
        throw Exception(
          "Response kosong",
        );
      }

      return Map<String, dynamic>.from(
        response.data,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> checkPaymentStatus(
    String orderId,
  ) async {
    try {
      final response = await supabase.functions.invoke(
        "cek-payment",
        body: {
          "order_id": orderId,
        },
      );

      if (response.data == null) {
        throw Exception(
          "Response kosong",
        );
      }

      return Map<String, dynamic>.from(
        response.data,
      );
    } catch (e) {
      rethrow;
    }
  }
}