import 'package:supabase_flutter/supabase_flutter.dart';

class AdminOrderService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<dynamic>> getAllOrders() async {
    final data = await supabase
        .from("orders")
        .select("""
        *,
        buyer:profiles!orders_buyer_id_fkey(
          id,
          nama,
          email,
          no_hp,
          alamat
        ),
        order_items(
          *,
          seller:profiles!order_items_seller_id_fkey(
            id,
            nama,
            email,
            no_hp,
            alamat,
            nama_umkm,
            kategori_umkm
          )
        )
      """)
        .order("created_at", ascending: false);

    print("====================");
    print(data);
    print("====================");

    return data;
  }
}