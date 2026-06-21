import 'package:supabase_flutter/supabase_flutter.dart';
import 'notification_service.dart';

class OrderService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getMyOrders() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception("User belum login");
    }

    final data = await supabase
        .from("orders")
        .select()
        .eq("buyer_id", user.id)
        .order(
          "created_at",
          ascending: false,
        );

    return List<Map<String, dynamic>>.from(data);
  }

  Future<List<Map<String, dynamic>>> getOrderItems(
    String orderId,
  ) async {
    final data = await supabase
        .from("order_items")
        .select("""
          *,
          products(
            id,
            nama_produk,
            image_url,
            harga
          )
        """)
        .eq(
          "order_id",
          orderId,
        );

    return List<Map<String, dynamic>>.from(data);
  }

  Future<List<Map<String, dynamic>>> getSellerOrders() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception("Belum Login");
    }

    final items = await supabase
        .from("order_items")
        .select("""
          *,
          products(
            id,
            nama_produk,
            image_url
          )
        """)
        .eq("seller_id", user.id)
        .order(
          "created_at",
          ascending: false,
        );

    if (items.isEmpty) {
      return [];
    }

    final orderIds = items
        .map((e) => e["order_id"])
        .toSet()
        .toList();

    final orders = await supabase
        .from("orders")
        .select()
        .inFilter("id", orderIds);

    final List<Map<String, dynamic>> result = [];

    for (final item in items) {
      Map<String, dynamic>? order;

      try {
        order = orders.firstWhere(
          (e) => e["id"] == item["order_id"],
        );
      } catch (_) {
        order = null;
      }

      result.add({
        ...Map<String, dynamic>.from(item),
        "orders": order,
      });
    }

    return result;
  }

  Future<Map<String, dynamic>> getOrderDetail(
    String orderId,
  ) async {
    final data = await supabase
        .from("orders")
        .select()
        .eq(
          "id",
          orderId,
        )
        .single();

    return Map<String, dynamic>.from(data);
  }

  Future<void> markAsPaid(
    String orderId,
  ) async {
    await supabase
        .from("orders")
        .update({
          "payment_status": "paid",
          "order_status": "processed",
          "paid_at": DateTime.now().toIso8601String(),
        })
        .eq(
          "id",
          orderId,
        );
  }

  Future<void> shipOrder(
    String orderId,
  ) async {
    final order = await getOrderDetail(
      orderId,
    );

    await supabase
        .from("orders")
        .update({
          "order_status": "shipped",
          "shipped_at": DateTime.now().toIso8601String(),
        })
        .eq(
          "id",
          orderId,
        );

    await NotificationService().createNotification(
      userId: order["buyer_id"],
      title: "Pesanan Dikirim",
      message: "Pesanan Anda sedang dikirim.",
    );
  }

  Future<void> confirmReceived(
    String orderId,
  ) async {
    final order = await getOrderDetail(
      orderId,
    );

    await supabase
        .from("orders")
        .update({
          "order_status": "completed",
          "completed_at": DateTime.now().toIso8601String(),
        })
        .eq(
          "id",
          orderId,
        );

    await NotificationService().createNotification(
      userId: order["buyer_id"],
      title: "Pesanan Selesai",
      message: "Terima kasih telah berbelanja.",
    );
  }
}