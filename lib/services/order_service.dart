import 'package:smwaste/services/notification_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderService {
  final supabase =
      Supabase.instance.client;

  Future<List<dynamic>>
      getMyOrders() async {
    final user =
        supabase.auth.currentUser;

    if (user == null) {
      throw Exception(
        'User belum login',
      );
    }

    return await supabase
        .from('orders')
        .select()
        .eq(
          'buyer_id',
          user.id,
        )
        .order(
          'created_at',
          ascending: false,
        );
  }

  Future<List<dynamic>> getOrderItems(
    String orderId,
  ) async {
    return await supabase
        .from('order_items')
        .select('''
          *,
          products(
            nama_produk,
            image_url
          )
        ''')
        .eq(
          'order_id',
          orderId,
        );
  }
  
  Future<List<dynamic>>
      getSellerOrders() async {

    final user =
        supabase.auth.currentUser;

    if (user == null) {
      throw Exception(
        'User belum login',
      );
    }

    final data =
        await supabase
            .from('order_items')
            .select('''
              *,
              orders(*)
            ''')
            .eq(
              'seller_id',
              user.id,
            )
            .order(
              'id',
              ascending: false,
            );

    return data;
  }

  Future<void> shipOrder(
    String orderId,
  ) async {

    final order =
        await supabase
            .from('orders')
            .select()
            .eq(
              'id',
              orderId,
            )
            .single();

    await supabase
        .from('orders')
        .update({
          'order_status':
              'shipped',
        })
        .eq(
          'id',
          orderId,
        );

    await NotificationService()
        .createNotification(
      userId:
          order['buyer_id'],

      title:
          'Pesanan Dikirim',

      message:
          'Pesanan Anda sedang dalam perjalanan.',
    );
  }

  Future<Map<String, dynamic>>
      getOrderDetail(
    String orderId,
  ) async {
    return await supabase
        .from('orders')
        .select()
        .eq(
          'id',
          orderId,
        )
        .single();
  }

  Future<void> markAsPaid(String orderId) async {
    await supabase
        .from('orders')
        .update({
          'payment_status': 'paid',
          'order_status': 'pending',
        })
        .eq('id', orderId);
  }

  Future<void>
      confirmReceived(
    String orderId,
  ) async {
    await supabase
        .from('orders')
        .update({
      'order_status':
          'completed',

      'completed_at':
          DateTime.now()
              .toIso8601String(),
    })
        .eq(
      'id',
      orderId,
    );
  }
}