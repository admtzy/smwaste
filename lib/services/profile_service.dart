import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final user = supabase.auth.currentUser;

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

  Future<String> uploadImage(
    XFile image,
  ) async {
    final bytes = await image.readAsBytes();

    final fileName =
        'profile_${DateTime.now().millisecondsSinceEpoch}.png';

    await supabase.storage.from('umkm-profile').uploadBinary(
          fileName,
          bytes,
          fileOptions: const FileOptions(
            upsert: true,
          ),
        );

    final imageUrl =
        supabase.storage.from('umkm-profile').getPublicUrl(fileName);

    return imageUrl;
  }

  Future<void> completeProfile({
    required String nama,
    required String alamat,
    required String noHp,
    String? namaUmkm,
    String? kategoriUmkm,
    String? kecamatan,
    String? kabupaten,
    String? metodePencairan,
    String? nomorDana,
    String? nomorShopeepay,
    String? namaBank,
    String? nomorRekening,
    String? namaPemilikRekening,
    required String fotoProfile,
  }) async {
    try {
      final user = supabase.auth.currentUser;

      if (user == null) {
        throw Exception(
          'User belum login',
        );
      }

      await supabase.from('profiles').update({
        'nama': nama,
        'alamat': alamat,
        'no_hp': noHp,
        'nama_umkm': namaUmkm,
        'kategori_umkm': kategoriUmkm,
        'kecamatan': kecamatan,
        'kabupaten': kabupaten,
        'metode_pencairan': metodePencairan,
        'nomor_dana': nomorDana,
        'nomor_shopeepay': nomorShopeepay,
        'nama_bank': namaBank,
        'nomor_rekening': nomorRekening,
        'nama_pemilik_rekening': namaPemilikRekening,
        'foto_profile': fotoProfile,
        'is_profile_complete': true,
      }).eq('id', user.id);
    } catch (e) {
      throw Exception(
        'Gagal complete profile : $e',
      );
    }
  }
}