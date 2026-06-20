import 'package:supabase_flutter/supabase_flutter.dart';

class CartService {
  final supabase = Supabase.instance.client;

  // =========================
  // ADD TO CART
  // =========================
  Future<void> addToCart({
    required String productId,
    required int qty,
  }) async {
    try {
      final user = supabase.auth.currentUser;

      if (user == null) {
        throw Exception('User belum login');
      }

      // ambil produk
      final product = await supabase
          .from('products')
          .select()
          .eq('id', productId)
          .maybeSingle();

      if (product == null) {
        throw Exception('Produk tidak ditemukan');
      }

      final int stok = product['stok'] ?? 0;

      if (stok <= 0) {
        throw Exception('Stok habis');
      }

      if (qty > stok) {
        throw Exception('Stok hanya tersedia $stok');
      }

      // cek cart existing
      final existingCart = await supabase
          .from('carts')
          .select()
          .eq('product_id', productId)
          .eq('user_id', user.id)
          .maybeSingle();

      if (existingCart != null) {
        final oldQty = existingCart['qty'] ?? 0;
        final totalQty = oldQty + qty;

        if (totalQty > stok) {
          throw Exception('Jumlah cart melebihi stok');
        }

        await supabase
            .from('carts')
            .update({'qty': totalQty})
            .eq('id', existingCart['id']);
      } else {
        await supabase.from('carts').insert({
          'user_id': user.id,
          'product_id': productId,
          'qty': qty,
        });
      }
    } catch (e) {
      throw Exception('Gagal tambah keranjang: $e');
    }
  }

  // =========================
  // GET CART + ONGKIR (FIXED)
  // =========================
  Future<List> getCart() async {
    try {
      final user = supabase.auth.currentUser;

      if (user == null) {
        throw Exception('User belum login');
      }

      // 🔥 FIX: pakai inner join supaya products tidak NULL
      final data = await supabase
          .from('carts')
          .select('''
            id,
            qty,
            products!inner(
              id,
              nama_produk,
              harga,
              stok,
              image_url,
              seller_id
            )
          ''')
          .eq('user_id', user.id);

      // ambil data buyer
      final buyer = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (buyer == null) {
        throw Exception('Profil buyer tidak ditemukan');
      }

      final buyerKabupaten = buyer['kabupaten'];
      final buyerKecamatan = buyer['kecamatan'];

      for (var item in data) {
        final product = item['products'];

        // 🔥 safety check
        if (product == null) continue;

        final sellerId = product['seller_id'];

        if (sellerId == null) continue;

        final seller = await supabase
            .from('profiles')
            .select()
            .eq('id', sellerId)
            .maybeSingle();

        if (seller == null) continue;

        final sellerKabupaten = seller['kabupaten'];
        final sellerKecamatan = seller['kecamatan'];

        int ongkir = 0;

        if (buyerKabupaten == sellerKabupaten) {
          if (buyerKecamatan == sellerKecamatan) {
            ongkir = 5000;
          } else {
            ongkir = 10000;
          }
        } else {
          ongkir = 0;
        }

        item['ongkir'] = ongkir;
        item['seller_kecamatan'] = sellerKecamatan;
        item['seller_kabupaten'] = sellerKabupaten;
      }

      return data;
    } catch (e) {
      throw Exception('Gagal load cart: $e');
    }
  }

  // =========================
  // DELETE CART
  // =========================
  Future<void> deleteCart(String cartId) async {
    await supabase.from('carts').delete().eq('id', cartId);
  }

  // =========================
  // UPDATE QTY
  // =========================
  Future<void> updateQty({
    required String cartId,
    required int qty,
    required int stock,
  }) async {
    if (qty <= 0) throw Exception('Qty minimal 1');
    if (qty > stock) throw Exception('Qty melebihi stok');

    await supabase
        .from('carts')
        .update({'qty': qty})
        .eq('id', cartId);
  }

  // =========================
  // CLEAR CART
  // =========================
  Future<void> clearCart() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    await supabase
        .from('carts')
        .delete()
        .eq('user_id', user.id);
  }
}