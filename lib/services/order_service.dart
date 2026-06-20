import 'package:smwaste/services/notification_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderService {
  final supabase = Supabase.instance.client;

  // ===================================
  // ORDER PEMBELI
  // ===================================

  Future<List<dynamic>> getMyOrders() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception("User belum login");
    }

    return await supabase
        .from("orders")
        .select()
        .eq(
          "buyer_id",
          user.id,
        )
        .order(
          "created_at",
          ascending: false,
        );
  }

  // ===================================
  // ITEM ORDER
  // ===================================

  Future<List<dynamic>> getOrderItems(
    String orderId,
  ) async {
    return await supabase
        .from("order_items")
        .select("""
          *,
          products(
            nama_produk,
            image_url
          )
        """)
        .eq(
          "order_id",
          orderId,
        );
  }

  // ===================================
  // ORDER PENJUAL
  // ===================================

  Future<List<dynamic>> getSellerOrders() async {
  final user = supabase.auth.currentUser;

  final data = await supabase
      .from("order_items")
      .select("""
        *,
        orders(*)
      """)
      .eq("seller_id", user!.id);

  print("====================");
  print(data);
  print("====================");

  return data;
}

  // ===================================
  // DETAIL ORDER
  // ===================================

  Future<Map<String, dynamic>> getOrderDetail(
    String orderId,
  ) async {
    return await supabase
        .from("orders")
        .select()
        .eq(
          "id",
          orderId,
        )
        .single();
  }

  // ===================================
  // UPDATE PAID
  // ===================================

  Future<void> markAsPaid(
    String orderId,
  ) async {
    await supabase
        .from("orders")
        .update({
          "payment_status": "paid",
          "order_status": "processed",
        })
        .eq(
          "id",
          orderId,
        );
  }

  // ===================================
  // KIRIM PESANAN
  // ===================================

  Future<void> shipOrder(
    String orderId,
  ) async {
    final order = await supabase
        .from("orders")
        .select()
        .eq(
          "id",
          orderId,
        )
        .single();

    await supabase
        .from("orders")
        .update({
          "order_status": "shipped",
          "shipped_at":
              DateTime.now().toIso8601String(),
        })
        .eq(
          "id",
          orderId,
        );

    await NotificationService()
        .createNotification(
      userId: order["buyer_id"],
      title: "Pesanan Dikirim",
      message:
          "Pesanan Anda sedang dalam perjalanan.",
    );
  }

  // ===================================
  // KONFIRMASI DITERIMA
  // ===================================

  Future<void> confirmReceived(
    String orderId,
  ) async {
    final order = await supabase
        .from("orders")
        .select()
        .eq(
          "id",
          orderId,
        )
        .single();

    await supabase
        .from("orders")
        .update({
          "order_status": "completed",
          "completed_at":
              DateTime.now().toIso8601String(),
        })
        .eq(
          "id",
          orderId,
        );

    await NotificationService()
        .createNotification(
      userId: order["buyer_id"],
      title: "Pesanan Selesai",
      message:
          "Terima kasih telah berbelanja.",
    );
  }
}