import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductService {
  final supabase =
      Supabase.instance.client;

  // =========================
  // GET ALL PRODUCTS
  // =========================

  Future<List<dynamic>>
      getProducts() async {
    final data = await supabase
        .from('products')
        .select()
        .order(
          'created_at',
          ascending: false,
        );

    return data;
  }

  // =========================
  // GET MY PRODUCTS
  // =========================

  Future<List<dynamic>>
      getMyProducts() async {
    final user =
        supabase.auth.currentUser;

    if (user == null) {
      throw Exception(
        'User belum login',
      );
    }

    final data = await supabase
        .from('products')
        .select()
        .eq('seller_id', user.id);

    return data;
  }

  // =========================
  // PICK IMAGE CAMERA
  // =========================

  Future<XFile?> pickFromCamera() async {
    try {
      final picker = ImagePicker();

      final image =
          await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 60,
      );

      return image;
    } catch (e) {
      throw Exception(
        'Gagal membuka kamera: $e',
      );
    }
  }

  // =========================
  // PICK IMAGE GALLERY
  // =========================

  Future<XFile?>
      pickFromGallery() async {
    try {
      final picker = ImagePicker();

      final image =
          await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 60,
      );

      return image;
    } catch (e) {
      throw Exception(
        'Gagal membuka gallery: $e',
      );
    }
  }

  // =========================
  // UPLOAD IMAGE
  // =========================

  Future<String> uploadImage(
    XFile image,
  ) async {
    try {
      final Uint8List bytes =
          await image.readAsBytes();

      final fileName =
          'product_${DateTime.now().millisecondsSinceEpoch}.jpg';

      await supabase.storage
          .from('products')
          .uploadBinary(
            fileName,
            bytes,
            fileOptions:
                const FileOptions(
              upsert: true,
              contentType:
                  'image/jpeg',
            ),
          );

      final imageUrl = supabase
          .storage
          .from('products')
          .getPublicUrl(fileName);

      return imageUrl;
    } on StorageException catch (e) {
      throw Exception(
        'Storage Error: ${e.message}',
      );
    } catch (e) {
      throw Exception(
        'Upload image gagal: $e',
      );
    }
  }

  // =========================
  // ADD PRODUCT
  // =========================

  Future<void> addProduct({
    required String namaProduk,
    required String deskripsi,
    required int harga,
    required int stok,
    required String kategori,
    required String imageUrl,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final user =
          supabase.auth.currentUser;

      if (user == null) {
        throw Exception(
          'User belum login',
        );
      }

      await supabase
          .from('products')
          .insert({
        'seller_id': user.id,

        'nama_produk':
            namaProduk,

        'deskripsi':
            deskripsi,

        'harga': harga,

        'stok': stok,

        'kategori':
            kategori,

        'image_url':
            imageUrl,

        'latitude':
            latitude,

        'longitude':
            longitude,
      });
    } catch (e) {
      throw Exception(
        'Tambah produk gagal: $e',
      );
    }
  }

  // =========================
  // UPDATE PRODUCT
  // =========================

  Future<void> updateProduct({
    required String id,
    required String namaProduk,
    required String deskripsi,
    required int harga,
    required int stok,
    required String kategori, required String kecamatan, required String kabupaten,
  }) async {
    try {
      await supabase
          .from('products')
          .update({
        'nama_produk':
            namaProduk,

        'deskripsi':
            deskripsi,

        'harga': harga,

        'stok': stok,

        'kategori':
            kategori,
      }).eq('id', id);
    } catch (e) {
      throw Exception(
        'Update produk gagal: $e',
      );
    }
  }

  // =========================
// ADMIN GET ALL PRODUCTS
// =========================

  Future<List<dynamic>> getAllProductsAdmin() async {
    try {
      final data = await supabase
          .from('products')
          .select('''
            *,
            profiles (
              id,
              nama,
              email
            )
          ''')
          .order(
            'created_at',
            ascending: false,
          );

      return data;
    } catch (e) {
      throw Exception(
        'Gagal mengambil data produk: $e',
      );
    }
  }

  Future<void> deleteProductAdmin({
    required String productId,
    required String imageUrl,
  }) async {
    try {
      final fileName = imageUrl.split('/').last;

      await supabase.storage
          .from('products')
          .remove([fileName]);

      await supabase
          .from('products')
          .delete()
          .eq('id', productId);
    } catch (e) {
      throw Exception('Admin gagal menghapus produk: $e');
    }
  }
  Future<dynamic> getProductDetailAdmin(
    String productId,
  ) async {
    try {
      final data = await supabase
          .from('products')
          .select()
          .eq('id', productId)
          .single();

      return data;
    } catch (e) {
      throw Exception(
        'Gagal mengambil detail produk: $e',
      );
    }
  }


  // =========================
  // DELETE PRODUCT
  // =========================

  Future<void> deleteProduct(
    String id,
  ) async {
    try {
      await supabase
          .from('products')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception(
        'Delete produk gagal: $e',
      );
    }
  }
}