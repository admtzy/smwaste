import 'package:supabase_flutter/supabase_flutter.dart';

class SellerOrderService {

  final supabase =
      Supabase.instance.client;

  Future<List<dynamic>>
      getOrders() async {

    final user =
        supabase.auth.currentUser;

    final result =
        await supabase
            .from('order_items')
            .select('''
              *,
              orders(*)
            ''')
            .eq(
              'seller_id',
              user!.id,
            );

    return result;
  }

  Future<void>
      shipOrder({

    required String orderId,

    required String kurir,

    required String resi,

  }) async {

    await supabase
        .from('orders')
        .update({

      'order_status':
          'shipped',

      'kurir':
          kurir,

      'nomor_resi':
          resi,

      'shipped_at':
          DateTime.now()
              .toIso8601String(),

    }).eq(
      'id',
      orderId,
    );
  }
}