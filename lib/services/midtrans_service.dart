import 'package:supabase_flutter/supabase_flutter.dart';

class MidtransService {
  final SupabaseClient supabase =
      Supabase.instance.client;

  // ===================================
  // CREATE PAYMENT
  // ===================================

  Future<Map<String, dynamic>> createPayment({
    required String orderId,
    required int amount,
  }) async {
    try {
      print("==================================");
      print("CREATE PAYMENT");
      print("ORDER ID : $orderId");
      print("AMOUNT : $amount");

      final response =
          await supabase.functions.invoke(
        "rapid-action",
        body: {
          "order_id": orderId,
          "amount": amount,
        },
      );

      print("HTTP STATUS : ${response.status}");
      print("DATA : ${response.data}");

      if (response.data == null) {
        throw Exception("Response kosong");
      }

      return Map<String, dynamic>.from(
        response.data,
      );
    } catch (e, s) {
      print("ERROR CREATE PAYMENT");
      print(e);
      print(s);

      rethrow;
    }
  }

  // ===================================
  // CEK STATUS PEMBAYARAN
  // ===================================

Future<Map<String, dynamic>>
    checkPaymentStatus(
  String orderId,
) async {
  final response =
      await supabase.functions.invoke(
    "cek-payment",
    body: {
      "order_id": orderId,
    },
  );

  print(response.data);

  return Map<String, dynamic>.from(
    response.data,
  );
}
}