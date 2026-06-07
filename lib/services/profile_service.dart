import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final supabase =
      Supabase.instance.client;

  // =========================
  // GET PROFILE
  // =========================

  Future<Map<String, dynamic>?>
      getProfile() async {
    try {
      final user =
          supabase.auth.currentUser;

      if (user == null) return null;

      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      return data;
    } catch (e) {
      return null;
    }
  }

  // =========================
  // UPLOAD IMAGE
  // =========================

  Future<String> uploadImage(
    XFile image,
  ) async {
    final bytes =
        await image.readAsBytes();

    final fileName =
        'profile_${DateTime.now().millisecondsSinceEpoch}.png';

    await supabase.storage
        .from('umkm-profile')
        .uploadBinary(
          fileName,
          bytes,
          fileOptions:
              const FileOptions(
            upsert: true,
          ),
        );

    final imageUrl = supabase.storage
        .from('umkm-profile')
        .getPublicUrl(fileName);

    return imageUrl;
  }

  // =========================
  // COMPLETE PROFILE
  // =========================

  Future<void> completeProfile({
    required String nama,
    required String alamat,
    required String noHp,

    // seller
    String? namaUmkm,
    String? kategoriUmkm,

    // lokasi
    String? kecamatan,
    String? kabupaten,

    // pencairan
    String? metodePencairan,

    String? nomorDana,
    String? nomorShopeepay,

    String? namaBank,
    String? nomorRekening,
    String? namaPemilikRekening,

    required String fotoProfile,
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
          .from('profiles')
          .update({
        'nama': nama,
        'alamat': alamat,
        'no_hp': noHp,

        // seller
        'nama_umkm': namaUmkm,
        'kategori_umkm':
            kategoriUmkm,

        // lokasi
        'kecamatan':
            kecamatan,
        'kabupaten':
            kabupaten,

        // pencairan
        'metode_pencairan':
            metodePencairan,

        'nomor_dana':
            nomorDana,

        'nomor_shopeepay':
            nomorShopeepay,

        'nama_bank': namaBank,

        'nomor_rekening':
            nomorRekening,

        'nama_pemilik_rekening':
            namaPemilikRekening,

        // profile
        'foto_profile':
            fotoProfile,

        'is_profile_complete':
            true,
      }).eq('id', user.id);
    } catch (e) {
      throw Exception(
        'Gagal complete profile : $e',
      );
    }
  }
}