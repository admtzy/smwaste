import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountService {
  final supabase = Supabase.instance.client;

  Future<List<dynamic>> getAllUsers() async {
    try {
      final response = await supabase
          .from('profiles')
          .select()
          .order(
            'created_at',
            ascending: false,
          );

      debugPrint(
        response.toString(),
      );

      return response;
    } catch (e) {
      debugPrint(
        e.toString(),
      );

      return [];
    }
  }

  Future<void> updateProfile({
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
      }).eq('id', user.id);
    } catch (e) {
      throw Exception(
        'Update profile gagal : $e',
      );
    }
  }

  Future<void> deleteUser(
    String id,
  ) async {
    try {
      await supabase.from('profiles').delete().eq('id', id);
    } catch (e) {
      throw Exception(
        'Delete user gagal : $e',
      );
    }
  }

  Future<void> deleteMyAccount() async {
    try {
      final user = supabase.auth.currentUser;

      if (user == null) {
        throw Exception(
          'User belum login',
        );
      }

      await supabase.from('profiles').delete().eq('id', user.id);

      await supabase.auth.signOut();
    } catch (e) {
      throw Exception(
        'Delete akun gagal : $e',
      );
    }
  }
}