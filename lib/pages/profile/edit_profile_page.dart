import 'package:flutter/material.dart';

import '../../services/account_service.dart';
import '../../services/profile_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    super.key,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final accountService = AccountService();
  final profileService = ProfileService();

  // controller
  final namaC = TextEditingController();
  final alamatC = TextEditingController();
  final noHpC = TextEditingController();
  final namaUmkmC = TextEditingController();
  final kecamatanC = TextEditingController();
  final kabupatenC = TextEditingController();
  final danaC = TextEditingController();
  final shopeeC = TextEditingController();
  final bankC = TextEditingController();
  final rekeningC = TextEditingController();
  final pemilikRekeningC = TextEditingController();

  bool isLoading = true;
  String role = '';
  String kategori = 'FNB';
  String metodePencairan = 'DANA';

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final profile = await profileService.getProfile();

      if (!mounted) return;

      if (profile != null) {
        setState(() {
          namaC.text = profile['nama'] ?? '';
          alamatC.text = profile['alamat'] ?? '';
          noHpC.text = profile['no_hp'] ?? '';
          namaUmkmC.text = profile['nama_umkm'] ?? '';
          kecamatanC.text = profile['kecamatan'] ?? '';
          kabupatenC.text = profile['kabupaten'] ?? '';
          danaC.text = profile['nomor_dana'] ?? '';
          shopeeC.text = profile['nomor_shopeepay'] ?? '';
          bankC.text = profile['nama_bank'] ?? '';
          rekeningC.text = profile['nomor_rekening'] ?? '';
          pemilikRekeningC.text = profile['nama_pemilik_rekening'] ?? '';
          role = profile['role'] ?? '';
          kategori = profile['kategori_umkm'] ?? 'FNB';
          metodePencairan = profile['metode_pencairan'] ?? 'DANA';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memuat profil: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> updateProfile() async {
    try {
      setState(() {
        isLoading = true;
      });

      await accountService.updateProfile(
        nama: namaC.text,
        alamat: alamatC.text,
        noHp: noHpC.text,
        namaUmkm: namaUmkmC.text,
        kategoriUmkm: kategori,
        kecamatan: kecamatanC.text,
        kabupaten: kabupatenC.text,
        metodePencairan: metodePencairan,
        nomorDana: danaC.text,
        nomorShopeepay: shopeeC.text,
        namaBank: bankC.text,
        nomorRekening: rekeningC.text,
        namaPemilikRekening: pemilikRekeningC.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile berhasil diupdate"),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;
      if (Navigator.canPop(context)) {
        Navigator.pop(context, true);
      } else {
        loadProfile();
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> deleteAccount() async {
    try {
      setState(() {
        isLoading = true;
      });

      await accountService.deleteMyAccount();

      if (!mounted) return;

      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    namaC.dispose();
    alamatC.dispose();
    noHpC.dispose();
    namaUmkmC.dispose();
    kecamatanC.dispose();
    kabupatenC.dispose();
    danaC.dispose();
    shopeeC.dispose();
    bankC.dispose();
    rekeningC.dispose();
    pemilikRekeningC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const colorBackground = Color(0xFFFCF9F8);
    const colorSurface = Color(0xFFFCF9F8);
    const colorOnSurface = Color(0xFF1C1B1B);
    const colorOnSurfaceVariant = Color(0xFF3F4944);
    const colorOutlineVariant = Color(0xFFBFC9C3);
    const colorPrimary = Color(0xFF004E3B);
    const colorOnPrimary = Color(0xFFFFFFFF);
    const colorError = Color(0xFFBA1A1A);

    InputDecoration customInputDecoration(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: colorOnSurfaceVariant,
          fontFamily: 'Hanken Grotesk',
        ),
        filled: true,
        fillColor: const Color(0xFFFFFFFF),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: colorPrimary, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: colorOutlineVariant),
        ),
      );
    }

    const formTextStyle = TextStyle(
      fontFamily: 'Hanken Grotesk',
      color: colorOnSurface,
      fontSize: 14,
    );

    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        backgroundColor: colorSurface,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            "Edit Profile",
            style: TextStyle(
              color: colorOnSurface,
              fontFamily: 'Hanken Grotesk',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: colorPrimary,
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    TextField(
                      controller: namaC,
                      style: formTextStyle,
                      cursorColor: colorPrimary,
                      decoration: customInputDecoration('Nama'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: alamatC,
                      style: formTextStyle,
                      cursorColor: colorPrimary,
                      decoration: customInputDecoration('Alamat'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: noHpC,
                      style: formTextStyle,
                      cursorColor: colorPrimary,
                      keyboardType: TextInputType.phone,
                      decoration: customInputDecoration('No HP'),
                    ),

                    if (role == 'penjual') ...[
                      const SizedBox(height: 16),
                      TextField(
                        controller: namaUmkmC,
                        style: formTextStyle,
                        cursorColor: colorPrimary,
                        decoration: customInputDecoration('Nama UMKM'),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: kecamatanC,
                        style: formTextStyle,
                        cursorColor: colorPrimary,
                        decoration: customInputDecoration('Kecamatan'),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: kabupatenC,
                        style: formTextStyle,
                        cursorColor: colorPrimary,
                        decoration: customInputDecoration('Kabupaten'),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: kategori,
                        style: formTextStyle,
                        decoration: customInputDecoration('Kategori UMKM'),
                        dropdownColor: Colors.white,
                        items: const [
                          DropdownMenuItem(
                            value: 'FNB',
                            child: Text('FNB'),
                          ),
                          DropdownMenuItem(
                            value: 'Industri Kreatif',
                            child: Text('Industri Kreatif'),
                          ),
                          DropdownMenuItem(
                            value: 'Fashion',
                            child: Text('Fashion'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            kategori = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: metodePencairan,
                        style: formTextStyle,
                        decoration: customInputDecoration('Metode Pencairan'),
                        dropdownColor: Colors.white,
                        items: const [
                          DropdownMenuItem(
                            value: 'DANA',
                            child: Text('DANA'),
                          ),
                          DropdownMenuItem(
                            value: 'ShopeePay',
                            child: Text('ShopeePay'),
                          ),
                          DropdownMenuItem(
                            value: 'Bank',
                            child: Text('Bank'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            metodePencairan = value!;
                          });
                        },
                      ),

                      if (metodePencairan == 'DANA') ...[
                        const SizedBox(height: 16),
                        TextField(
                          controller: danaC,
                          style: formTextStyle,
                          cursorColor: colorPrimary,
                          keyboardType: TextInputType.number,
                          decoration: customInputDecoration('Nomor DANA'),
                        ),
                      ],
                      if (metodePencairan == 'ShopeePay') ...[
                        const SizedBox(height: 16),
                        TextField(
                          controller: shopeeC,
                          style: formTextStyle,
                          cursorColor: colorPrimary,
                          keyboardType: TextInputType.number,
                          decoration: customInputDecoration('Nomor ShopeePay'),
                        ),
                      ],
                      if (metodePencairan == 'Bank') ...[
                        const SizedBox(height: 16),
                        TextField(
                          controller: bankC,
                          style: formTextStyle,
                          cursorColor: colorPrimary,
                          decoration: customInputDecoration('Nama Bank'),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: rekeningC,
                          style: formTextStyle,
                          cursorColor: colorPrimary,
                          keyboardType: TextInputType.number,
                          decoration: customInputDecoration('Nomor Rekening'),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: pemilikRekeningC,
                          style: formTextStyle,
                          cursorColor: colorPrimary,
                          decoration:
                              customInputDecoration('Nama Pemilik Rekening'),
                        ),
                      ],
                    ],

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorPrimary,
                          foregroundColor: colorOnPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: updateProfile,
                        child: const Text(
                          "Update Profile",
                          style: TextStyle(
                            fontFamily: 'Hanken Grotesk',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorError,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: deleteAccount,
                        child: const Text(
                          "Delete Account",
                          style: TextStyle(
                            fontFamily: 'Hanken Grotesk',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}