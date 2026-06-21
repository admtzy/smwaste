import 'dart:io';
import 'package:flutter/material.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  // Controller untuk menangkap input teks
  final nameC = TextEditingController();
  final phoneC = TextEditingController();
  final addressC = TextEditingController();
  final umkmNameC = TextEditingController();
  final accountNoC = TextEditingController();

  // Variabel untuk menyimpan nilai Dropdown/Pilihan
  String? selectedCategory;
  String? selectedPaymentMethod;
  File? profileImage; // Menyimpan file gambar jika nanti diintegrasikan dengan image_picker
  bool isLoading = false;

  @override
  void dispose() {
    nameC.dispose();
    phoneC.dispose();
    addressC.dispose();
    umkmNameC.dispose();
    accountNoC.dispose();
    super.dispose();
  }

  // Fungsi aksi tombol simpan
  void saveProfile() {
    setState(() {
      isLoading = true;
    });

    // TODO: Masukkan logika integrasi database / API Anda di sini
    // Contoh:
    // await profileService.save(name: nameC.text, ...);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Definisi Palet Warna sesuai HTML SMARTWASTE
    const primaryGreen = Color(0xFF004E3B);
    const onPrimary = Color(0xFFFFFFFF);
    const onSurface = Color(0xFF1C1B1B);
    const onSurfaceVariant = Color(0xFF3F4944);
    const secondaryContainer = Color(0xFFD5E7DA);

    return Scaffold(
      backgroundColor: primaryGreen,
      // 1. TopAppBar (Shared Component di HTML)
      appBar: AppBar(
        backgroundColor: primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: onPrimary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "SMARTWASTE",
          style: TextStyle(
            color: onPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      // 2. Sliding Sheet Layout (Kontainer Putih Melengkung)
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 16),
        decoration: const BoxDecoration(
          color: Color(0xFFFFFFFF), // surface-container-lowest
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 24,
              offset: Offset(0, -4),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                const Text(
                  "Lengkapi Profil",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: primaryGreen,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Langkah terakhir untuk mulai mengelola limbah UMKM Anda dengan cerdas.",
                  style: TextStyle(
                    fontSize: 14,
                    color: onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),

                // Avatar Upload Section
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Jalankan fungsi pick image di sini nanti
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          decoration: const BoxDecoration(
                            color: secondaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: profileImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(48),
                                  child: Image.file(profileImage!, fit: BoxFit.cover),
                                )
                              : const Icon(
                                  Icons.add_a_photo_outlined,
                                  size: 40,
                                  color: primaryGreen,
                                ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "PILIH FOTO PROFIL",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            color: primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // FORM FIELDS
                // Nama Lengkap
                buildLabel("Nama Lengkap", onSurfaceVariant),
                const SizedBox(height: 8),
                TextField(
                  controller: nameC,
                  style: const TextStyle(color: onSurface),
                  decoration: buildInputDecoration("Masukkan nama sesuai KTP", secondaryContainer, onSurfaceVariant),
                ),
                const SizedBox(height: 24),

                // Nomor HP
                buildLabel("Nomor HP", onSurfaceVariant),
                const SizedBox(height: 8),
                TextField(
                  controller: phoneC,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: onSurface),
                  decoration: buildInputDecoration("81234567890", secondaryContainer, onSurfaceVariant).copyWith(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 16, right: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "+62",
                            style: TextStyle(color: onSurfaceVariant, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Alamat Rumah
                buildLabel("Alamat Rumah", onSurfaceVariant),
                const SizedBox(height: 8),
                TextField(
                  controller: addressC,
                  maxLines: 3,
                  style: const TextStyle(color: onSurface),
                  decoration: buildInputDecoration("Masukkan alamat lengkap", secondaryContainer, onSurfaceVariant),
                ),
                const SizedBox(height: 24),

                // Divider Pemisah Informasi Pribadi & Usaha
                const Divider(color: Color(0x4D707974), height: 32),

                // Nama UMKM
                buildLabel("Nama UMKM", onSurfaceVariant),
                const SizedBox(height: 8),
                TextField(
                  controller: umkmNameC,
                  style: const TextStyle(color: onSurface),
                  decoration: buildInputDecoration("Nama usaha Anda", secondaryContainer, onSurfaceVariant),
                ),
                const SizedBox(height: 24),

                // Kategori UMKM
                buildLabel("Kategori UMKM", onSurfaceVariant),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  dropdownColor: Colors.white,
                  hint: Text(
                    "Pilih Kategori",
                    style: TextStyle(color: onSurfaceVariant.withOpacity(0.5), fontSize: 14),
                  ),
                  icon: const Icon(Icons.expand_more, color: onSurfaceVariant),
                  decoration: buildInputDecoration("", secondaryContainer, onSurfaceVariant).copyWith(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  ),
                  items: ['Makanan', 'Minuman', 'Fashion'].map((String category) {
                    return DropdownMenuItem<String>(
                      value: category.toLowerCase(),
                      child: Text(category, style: const TextStyle(color: onSurface)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Metode Pencairan
                buildLabel("Metode Pencairan", onSurfaceVariant),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedPaymentMethod,
                  dropdownColor: Colors.white,
                  hint: Text(
                    "Pilih Metode",
                    style: TextStyle(color: onSurfaceVariant.withOpacity(0.5), fontSize: 14),
                  ),
                  icon: const Icon(Icons.expand_more, color: onSurfaceVariant),
                  decoration: buildInputDecoration("", secondaryContainer, onSurfaceVariant).copyWith(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  ),
                  items: [
                    const DropdownMenuItem(value: 'dana', child: Text('DANA', style: TextStyle(color: onSurface))),
                    const DropdownMenuItem(value: 'bank', child: Text('Rekening Bank', style: TextStyle(color: onSurface))),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value;
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Nomor Rekening / DANA
                buildLabel("Nomor Rekening / DANA", onSurfaceVariant),
                const SizedBox(height: 8),
                TextField(
                  controller: accountNoC,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: onSurface),
                  decoration: buildInputDecoration("Masukkan nomor", secondaryContainer, onSurfaceVariant),
                ),
                const SizedBox(height: 35),

                // Primary Action Button (Simpan & Lanjutkan)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(color: onPrimary, strokeWidth: 2),
                          )
                        : const Text(
                            "Simpan & Lanjutkan",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper Widget untuk membuat Label Huruf Kapital bergaya Material Design
  Widget buildLabel(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
          color: color,
        ),
      ),
    );
  }

  // Helper untuk konfigurasi style background form input field
  InputDecoration buildInputDecoration(String hint, Color fillColor, Color focusColor) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: focusColor.withOpacity(0.5), fontSize: 14),
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF004E3B), width: 2),
      ),
    );
  }
}