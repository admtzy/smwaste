import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/profile_service.dart';

import '../pembeli/pembeli_dashboard.dart';
import '../penjual/penjual_dashboard.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final profileService = ProfileService();
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

  String kategori = 'FNB';
  String role = '';
  String metodePencairan = 'DANA';
  bool isLoading = false;
  XFile? image;

  final Color _colorPrimary = const Color(0xFF276955);
  final Color _colorSecondaryContainer = const Color(
    0xFFd5e7da,
  );
  final Color _colorSurface = const Color(0xFFfcf9f8);
  final Color _colorOnSurface = const Color(0xFF1c1b1b);
  final Color _colorOnSurfaceVariant = const Color(0xFF3f4944);

  @override
  void initState() {
    super.initState();
    loadRole();
  }

  Future<void> loadRole() async {
    final profile = await profileService.getProfile();
    if (profile != null) {
      setState(() {
        role = profile['role'];
      });
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  Future<void> saveProfile() async {
    if (namaC.text.isEmpty ||
        alamatC.text.isEmpty ||
        noHpC.text.isEmpty ||
        kecamatanC.text.isEmpty ||
        kabupatenC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pastikan semua data wajib terisi')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String imageUrl = '';
      if (image != null) {
        imageUrl = await profileService.uploadImage(image!);
      }

      await profileService.completeProfile(
        nama: namaC.text.trim(),
        alamat: alamatC.text.trim(),
        noHp: noHpC.text.trim(),

        namaUmkm: role == 'penjual' ? namaUmkmC.text.trim() : null,
        kategoriUmkm: role == 'penjual' ? kategori : null,

        kecamatan: kecamatanC.text.trim(),
        kabupaten: kabupatenC.text.trim(),

        metodePencairan: role == 'penjual' ? metodePencairan : null,
        nomorDana: metodePencairan == 'DANA' ? danaC.text.trim() : null,
        nomorShopeepay: metodePencairan == 'ShopeePay'
            ? shopeeC.text.trim()
            : null,
        namaBank: metodePencairan == 'Bank' ? bankC.text.trim() : null,
        nomorRekening: metodePencairan == 'Bank' ? rekeningC.text.trim() : null,
        namaPemilikRekening: metodePencairan == 'Bank'
            ? pemilikRekeningC.text.trim()
            : null,

        fotoProfile: imageUrl,
      );

      if (!mounted) return;

      if (role == 'penjual') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PenjualDashboard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PembeliDashboard()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() {
      isLoading = false;
    });
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
    return Scaffold(
      backgroundColor: _colorSurface,
      appBar: AppBar(
        backgroundColor: _colorSurface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Lengkapi Profil',
          style: TextStyle(
            fontFamily: 'Hanken Grotesk',
            color: _colorOnSurface,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: role.isEmpty
          ? Center(child: CircularProgressIndicator(color: _colorPrimary))
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Silakan lengkapi data diri Anda untuk menyelesaikan pendaftaran.',
                      style: TextStyle(
                        fontFamily: 'Hanken Grotesk',
                        color: _colorOnSurfaceVariant,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 32),

                    Center(
                      child: GestureDetector(
                        onTap: pickImage,
                        child: Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: _colorSecondaryContainer,
                                shape: BoxShape.circle,
                                image: image != null
                                    ? DecorationImage(
                                        image: FileImage(File(image!.path)),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: image == null
                                  ? Icon(
                                      Icons.person,
                                      size: 50,
                                      color: _colorPrimary.withOpacity(0.5),
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _colorPrimary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    _buildSectionTitle('Informasi Pribadi'),
                    _buildTextField(
                      label: 'NAMA LENGKAP',
                      hint: 'Masukkan nama Anda',
                      controller: namaC,
                    ),
                    _buildTextField(
                      label: 'NOMOR HP',
                      hint: 'Cth. 08123456789',
                      controller: noHpC,
                      isNumber: true,
                    ),
                    const SizedBox(height: 16),

                    _buildSectionTitle('Alamat Pengiriman / Usaha'),
                    _buildTextField(
                      label: 'ALAMAT LENGKAP',
                      hint: 'Nama jalan, gedung, no. rumah',
                      controller: alamatC,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: 'KECAMATAN',
                            hint: 'Cth. Kebayoran',
                            controller: kecamatanC,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            label: 'KOTA / KAB',
                            hint: 'Cth. Jakarta',
                            controller: kabupatenC,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (role == 'penjual') ...[
                      _buildSectionTitle('Detail UMKM (Khusus Penjual)'),
                      _buildTextField(
                        label: 'NAMA UMKM',
                        hint: 'Masukkan nama usaha Anda',
                        controller: namaUmkmC,
                      ),

                      _buildLabel('KATEGORI UMKM'),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: kategori,
                        icon: Icon(
                          Icons.expand_more,
                          color: _colorOnSurfaceVariant,
                        ),
                        dropdownColor: Colors.white,
                        decoration: _inputDecoration('Pilih Kategori'),
                        items: const [
                          DropdownMenuItem(
                            value: 'FNB',
                            child: Text('Food & Beverage (F&B)'),
                          ),
                          DropdownMenuItem(
                            value: 'Industri Kreatif',
                            child: Text('Industri Kreatif'),
                          ),
                          DropdownMenuItem(
                            value: 'Fashion',
                            child: Text('Fashion & Pakaian'),
                          ),
                        ],
                        onChanged: (val) => setState(() => kategori = val!),
                      ),
                      const SizedBox(height: 24),

                      _buildSectionTitle('Pengaturan Pencairan Dana'),
                      _buildLabel('METODE PENCAIRAN'),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: metodePencairan,
                        icon: Icon(
                          Icons.expand_more,
                          color: _colorOnSurfaceVariant,
                        ),
                        dropdownColor: Colors.white,
                        decoration: _inputDecoration('Pilih Metode'),
                        items: const [
                          DropdownMenuItem(value: 'DANA', child: Text('DANA')),
                          DropdownMenuItem(
                            value: 'ShopeePay',
                            child: Text('ShopeePay'),
                          ),
                          DropdownMenuItem(
                            value: 'Bank',
                            child: Text('Transfer Bank'),
                          ),
                        ],
                        onChanged: (val) =>
                            setState(() => metodePencairan = val!),
                      ),
                      const SizedBox(height: 16),

                      if (metodePencairan == 'DANA')
                        _buildTextField(
                          label: 'NOMOR DANA',
                          hint: 'Masukkan nomor DANA',
                          controller: danaC,
                          isNumber: true,
                        ),

                      if (metodePencairan == 'ShopeePay')
                        _buildTextField(
                          label: 'NOMOR SHOPEEPAY',
                          hint: 'Masukkan nomor ShopeePay',
                          controller: shopeeC,
                          isNumber: true,
                        ),

                      if (metodePencairan == 'Bank') ...[
                        _buildTextField(
                          label: 'NAMA BANK',
                          hint: 'Cth. BCA, Mandiri, BNI',
                          controller: bankC,
                        ),
                        _buildTextField(
                          label: 'NOMOR REKENING',
                          hint: 'Masukkan nomor rekening',
                          controller: rekeningC,
                          isNumber: true,
                        ),
                        _buildTextField(
                          label: 'NAMA PEMILIK REKENING',
                          hint: 'Sesuai buku tabungan',
                          controller: pemilikRekeningC,
                        ),
                      ],
                    ],

                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _colorPrimary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : const Text(
                                "Simpan Profil",
                                style: TextStyle(
                                  fontFamily: 'Hanken Grotesk',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Hanken Grotesk',
          color: _colorPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(label),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            style: TextStyle(
              fontFamily: 'Hanken Grotesk',
              color: _colorOnSurface,
              fontSize: 14,
            ),
            decoration: _inputDecoration(hint),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Hanken Grotesk',
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
        color: _colorOnSurfaceVariant,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontFamily: 'Hanken Grotesk',
        color: _colorOnSurfaceVariant.withOpacity(0.5),
        fontSize: 14,
      ),
      filled: true,
      fillColor: _colorSecondaryContainer,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: _colorPrimary, width: 2),
      ),
    );
  }
}
