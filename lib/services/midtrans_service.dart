import 'package:supabase_flutter/supabase_flutter.dart';

class MidtransService {
  final supabase =
      Supabase.instance.client;

  Future<Map<String, dynamic>>
      createPayment({
    required String orderId,
    required int amount,
  }) async {
    final response =
        await supabase.functions.invoke(
      'rapid-action',
      body: {
        'order_id': orderId,
        'amount': amount,
      },
    );

    print(
      '===== MIDTRANS RESPONSE =====',
    );

    print(response.data);

    if (response.data == null) {
      throw Exception(
        'Response dari function kosong',
      );
    }

    return Map<String, dynamic>.from(
      response.data,
    );
  }
}