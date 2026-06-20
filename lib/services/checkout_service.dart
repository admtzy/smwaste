import 'package:supabase_flutter/supabase_flutter.dart';

import 'cart_service.dart';
import 'midtrans_service.dart';
import 'notification_service.dart';

class CheckoutService {
  final supabase =
      Supabase.instance.client;

  final cartService =
      CartService();

  final notifService =
      NotificationService();

  // ===================================
  // PROSES ORDER YANG SUDAH DIBAYAR
  // ===================================
  Future<void> processPaidOrder(
    String orderId,
  ) async {
    try {
      final order = await supabase
          .from('orders')
          .select()
          .eq('id', orderId)
          .single();

      // Sudah pernah diproses
      if (order['order_status'] ==
          'processed') {
        return;
      }

      // Belum dibayar
      if (order['payment_status'] !=
          'paid') {
        return;
      }

      final items = await supabase
          .from('order_items')
          .select()
          .eq('order_id', orderId);

      for (final item in items) {
        final product =
            await supabase
                .from('products')
                .select(
                  'id, stok',
                )
                .eq(
                  'id',
                  item['product_id'],
                )
                .single();

        final int stokSekarang =
            (product['stok'] ?? 0)
                .toInt();

        final int qty =
            (item['qty'] ?? 0)
                .toInt();

        final int stokBaru =
            stokSekarang - qty;

        await supabase
            .from('products')
            .update({
              'stok': stokBaru,
            })
            .eq(
              'id',
              item['product_id'],
            );

        await notifService
            .createNotification(
          userId:
              item['seller_id'],
          title:
              'Pembayaran Berhasil',
          message:
              'Pesanan telah dibayar dan siap diproses.',
        );
      }

      await supabase
          .from('orders')
          .update({
            'order_status':
                'processed',
          })
          .eq('id', orderId);
    } catch (e) {
      throw Exception(
        'Gagal memproses order: $e',
      );
    }
  }

  // ===================================
  // UBAH STATUS MENJADI PAID
  // ===================================
  Future<void> markOrderPaid(
    String orderId,
  ) async {
    try {
      await supabase
          .from('orders')
          .update({
            'payment_status':
                'paid',
            'paid_at':
                DateTime.now()
                    .toIso8601String(),
          })
          .eq('id', orderId);

      await processPaidOrder(
        orderId,
      );
    } catch (e) {
      throw Exception(
        'Gagal update pembayaran: $e',
      );
    }
  }

  // ===================================
  // CHECKOUT
  // ===================================
  Future<Map<String, dynamic>>
      checkout() async {
    try {
      final user =
          supabase.auth.currentUser;

      if (user == null) {
        throw Exception(
          'User belum login',
        );
      }

      final carts =
          await cartService
              .getCart();

      if (carts.isEmpty) {
        throw Exception(
          'Keranjang kosong',
        );
      }

      int totalProduk = 0;
      int totalOngkir = 0;

      for (var item in carts) {
        final int harga =
            (item['products']
                        ['harga'] ??
                    0)
                .toInt();

        final int qty =
            (item['qty'] ?? 0)
                .toInt();

        final int ongkir =
            (item['ongkir'] ??
                    0)
                .toInt();

        totalProduk +=
            harga * qty;

        totalOngkir +=
            ongkir;
      }

      final int adminFee =
          (totalProduk * 0.1)
              .round();

      final int grandTotal =
          totalProduk +
              totalOngkir +
              adminFee;

      // ===================================
      // INSERT ORDER
      // ===================================

      final order =
          await supabase
              .from('orders')
              .insert({
                'buyer_id':
                    user.id,
                'total':
                    totalProduk,
                'total_ongkir':
                    totalOngkir,
                'admin_fee':
                    adminFee,
                'grand_total':
                    grandTotal,
                'payment_status':
                    'pending',
                'order_status':
                    'pending',
              })
              .select()
              .single();

      final String orderId =
          order['id'];

      // ===================================
      // INSERT ORDER ITEMS
      // ===================================

      for (var item in carts) {
        final product =
            item['products'];

        final String sellerId =
            product['seller_id'];

        final int harga =
            (product['harga'] ??
                    0)
                .toInt();

        final int qty =
            (item['qty'] ?? 0)
                .toInt();

        await supabase
            .from('order_items')
            .insert({
          'order_id':
              orderId,
          'seller_id':
              sellerId,
          'product_id':
              product['id'],
          'nama_produk':
              product[
                  'nama_produk'],
          'image_url':
              product[
                  'image_url'],
          'qty': qty,
          'harga': harga,
          'ongkir':
              item['ongkir'] ??
                  0,
          'subtotal':
              harga * qty,
        });

        await notifService
            .createNotification(
          userId:
              sellerId,
          title:
              'Pesanan Baru',
          message:
              'Produk Anda baru saja dipesan.',
        );
      }

      // ===================================
      // MIDTRANS
      // ===================================

      final payment =
          await MidtransService()
              .createPayment(
        orderId: orderId,
        amount: grandTotal,
      );

      final String token =
          payment['token']
                  ?.toString() ??
              '';

      final String redirectUrl =
          payment[
                      'redirect_url']
                  ?.toString() ??
              '';

      // ===================================
      // SAVE TOKEN
      // ===================================

      await supabase
          .from('orders')
          .update({
            'midtrans_order_id':
                orderId,
            'snap_token':
                token,
            'redirect_url':
                redirectUrl,
          })
          .eq(
            'id',
            orderId,
          );

      // ===================================
      // NOTIF BUYER
      // ===================================

      await notifService
          .createNotification(
        userId: user.id,
        title:
            'Checkout Berhasil',
        message:
            'Silakan lanjutkan pembayaran.',
      );

      await supabase
          .from('carts')
          .delete()
          .eq(
            'user_id',
            user.id,
          );

      return {
        'order_id': orderId,
        'token': token,
        'redirect_url':
            redirectUrl,
      };
    } catch (e) {
      throw Exception(
        'Checkout gagal : $e',
      );
    }
  }
}