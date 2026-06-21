import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Pastikan package ini sesuai tipe XFile Anda

// Asumsi class import dari service Anda tetap berjalan aman di background
import '../../../services/location_service.dart';
import '../../../services/product_service.dart';
// import 'services/product_service.dart';
// import 'package:smartwaste/services/location_service.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  // =========================
  // LOGIC ASLI DART (PERTAHANKAN)
  // =========================
  final productService = ProductService();
  final locationService = LocationService();

  final namaC = TextEditingController();
  final deskripsiC = TextEditingController();
  final hargaC = TextEditingController();
  final stokC = TextEditingController();

  String kategori = 'Makanan';
  XFile? image;

  double latitude = 0;
  double longitude = 0;
  bool isLoading = false;

  // CAMERA LOGIC
  Future<void> pickCamera() async {
    try {
      final result = await productService.pickFromCamera();
      if (result != null) {
        setState(() {
          image = result;
        });
      }
    } catch (e) {
      showMessage('Camera Error : $e');
    }
  }

  // GALLERY LOGIC
  Future<void> pickGallery() async {
    try {
      final result = await productService.pickFromGallery();
      if (result != null) {
        setState(() {
          image = result;
        });
      }
    } catch (e) {
      showMessage('Gallery Error : $e');
    }
  }

  // GET LOCATION LOGIC
  Future<void> getLocation() async {
    try {
      var position = await locationService.getCurrentLocation();
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
      showMessage('GPS berhasil diambil');
    } catch (e) {
      showMessage('GPS Error : $e');
    }
  }

  // SAVE PRODUCT LOGIC
  Future<void> saveProduct() async {
    try {
      if (namaC.text.isEmpty ||
          deskripsiC.text.isEmpty ||
          hargaC.text.isEmpty ||
          stokC.text.isEmpty) {
        showMessage('Semua field wajib diisi');
        return;
      }
      if (image == null) {
        showMessage('Upload gambar dulu');
        return;
      }
      if (latitude == 0 || longitude == 0) {
        showMessage('Ambil GPS terlebih dahulu');
        return;
      }

      final harga = int.tryParse(hargaC.text);
      final stok = int.tryParse(stokC.text);

      if (harga == null || stok == null) {
        showMessage('Harga dan stok harus angka');
        return;
      }

      setState(() {
        isLoading = true;
      });

      final imageUrl = await productService.uploadImage(image!);

      await productService.addProduct(
        namaProduk: namaC.text.trim(),
        deskripsi: deskripsiC.text.trim(),
        harga: harga,
        stok: stok,
        kategori: kategori,
        imageUrl: imageUrl,
        latitude: latitude,
        longitude: longitude,
      );

      if (!mounted) return;
      showMessage('Produk berhasil ditambahkan');
      Navigator.pop(context);
    } catch (e) {
      showMessage('Error : $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  void dispose() {
    namaC.dispose();
    deskripsiC.dispose();
    hargaC.dispose();
    stokC.dispose();
    super.dispose();
  }

  // =========================
  // UI - DISESUAIKAN TOTAL DENGAN TAMPILAN HTML
  // =========================
  @override
  Widget build(BuildContext context) {
    // Definisi Tema Warna Hex Tailwind HTML SMARTWASTE
    const Color primaryGreen = Color(0xFF004E3B);
    const Color onPrimary = Color(0xFFFFFFFF);
    const Color backgroundBg = Color(0xFFF7F9F7);
    const Color surfaceContainerLowest = Color(0xFFFFFFFF);
    const Color secondaryContainer = Color(0xFFD5E7DA);
    const Color onSurface = Color(0xFF1C1B1B);
    const Color onSurfaceVariant = Color(0xFF3F4944);
    const Color outlineVariant = Color(0xFFBFC9C3);

    return Scaffold(
      backgroundColor: backgroundBg,
      // TopAppBar khas HTML
      appBar: AppBar(
        backgroundColor: primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: onPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'SMARTWASTE',
          style: TextStyle(
            color: onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'Hanken Grotesk',
          ),
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 448), // Meniru batas 'max-w-md' di HTML web mockup
          color: surfaceContainerLowest,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 35),
            children: [
              // Judul Halaman Form
              const Text(
                'Tambah Produk',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primaryGreen,
                  fontFamily: 'Hanken Grotesk',
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Isi detail produk yang ingin Anda jual.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: onSurfaceVariant,
                  fontFamily: 'Hanken Grotesk',
                ),
              ),
              const SizedBox(height: 24),

              // =========================
              // FOTO PRODUK SECTION
              // =========================
              const Text(
                'FOTO PRODUK',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: onSurfaceVariant, letterSpacing: 1.5, fontFamily: 'Hanken Grotesk'),
              ),
              const SizedBox(height: 8),
              
              // Preview Gambar Jika Ada / Jika Kosong Tampilkan Tombol Pilih
              if (image != null)
                Container(
                  width: double.infinity,
                  height: 160,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: kIsWeb
                        ? Image.network(image!.path, fit: BoxFit.cover)
                        : Image.file(File(image!.path), fit: BoxFit.cover),
                  ),
                ),

              // Baris Dua Tombol Kamera & Galeri (Menggantikan Area Unggah)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: pickCamera,
                      icon: const Icon(Icons.camera_alt, size: 18, color: primaryGreen),
                      label: const Text('Kamera', style: TextStyle(fontFamily: 'Hanken Grotesk', color: primaryGreen, fontWeight: FontWeight.w500)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: primaryGreen),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: pickGallery,
                      icon: const Icon(Icons.photo, size: 18, color: primaryGreen),
                      label: const Text('Galeri', style: TextStyle(fontFamily: 'Hanken Grotesk', color: primaryGreen, fontWeight: FontWeight.w500)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: primaryGreen),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // =========================
              // NAMA PRODUK
              // =========================
              const Text(
                'NAMA PRODUK',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: onSurfaceVariant, letterSpacing: 1.5, fontFamily: 'Hanken Grotesk'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: namaC,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: onSurface, fontFamily: 'Hanken Grotesk'),
                decoration: InputDecoration(
                  hintText: 'Contoh: Pupuk Kompos Premium',
                  hintStyle: const TextStyle(color: outlineVariant),
                  fillColor: secondaryContainer.withOpacity(0.4),
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 24),

              // =========================
              // KATEGORI (Mengubah Dropdown ke Choice Chips agar Sesuai HTML)
              // =========================
              const Text(
                'KATEGORI',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: onSurfaceVariant, letterSpacing: 1.5, fontFamily: 'Hanken Grotesk'),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['Makanan', 'Minuman', 'Fashion'].map((categoryItem) {
                  final isSelected = kategori == categoryItem;
                  return ChoiceChip(
                    label: Text(categoryItem),
                    selected: isSelected,
                    labelStyle: TextStyle(
                      fontFamily: 'Hanken Grotesk',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? onPrimary : primaryGreen,
                    ),
                    selectedColor: primaryGreen,
                    backgroundColor: surfaceContainerLowest,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9999),
                      side: const BorderSide(color: primaryGreen, width: 1),
                    ),
                    showCheckmark: false,
                    onSelected: (bool selected) {
                      if (selected) {
                        setState(() {
                          kategori = categoryItem; // Menyimpan value balik ke variabel 'kategori'
                        });
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // =========================
              // DESKRIPSI PRODUK
              // =========================
              const Text(
                'DESKRIPSI PRODUK',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: onSurfaceVariant, letterSpacing: 1.5, fontFamily: 'Hanken Grotesk'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: deskripsiC,
                maxLines: 4,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: onSurface, fontFamily: 'Hanken Grotesk'),
                decoration: InputDecoration(
                  hintText: 'Jelaskan detail produk Anda...',
                  hintStyle: const TextStyle(color: outlineVariant),
                  fillColor: secondaryContainer.withOpacity(0.4),
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 24),

              // =========================
              // LOKASI PRODUK (GPS BUTTON)
              // =========================
              const Text(
                'LOKASI PRODUK',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: onSurfaceVariant, letterSpacing: 1.5, fontFamily: 'Hanken Grotesk'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: getLocation,
                icon: const Icon(Icons.my_location, size: 20, color: primaryGreen),
                label: Text(
                  latitude == 0 ? 'Ambil GPS' : 'GPS Berhasil diambil',
                  style: const TextStyle(fontFamily: 'Hanken Grotesk', fontWeight: FontWeight.w500, fontSize: 14, color: primaryGreen),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: const BorderSide(color: primaryGreen),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 24),

              // =========================
              // ALAMAT PENJEMPUTAN (OUTPUT KOORDINAT LOGIC)
              // =========================
              const Text(
                'ALAMAT PENJEMPUTAN (OTOMATIS)',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: onSurfaceVariant, letterSpacing: 1.5, fontFamily: 'Hanken Grotesk'),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: secondaryContainer.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  latitude == 0 && longitude == 0
                      ? 'Alamat akan muncul otomatis setelah menekan tombol Ambil GPS...'
                      : 'Lat: $latitude, Long: $longitude',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: latitude == 0 ? outlineVariant : onSurface,
                    fontFamily: 'Hanken Grotesk',
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // =========================
              // HARGA & STOK GRID (ROW)
              // =========================
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Field Harga
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'HARGA (RP)',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: onSurfaceVariant, letterSpacing: 1.5, fontFamily: 'Hanken Grotesk'),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: hargaC,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: onSurface, fontFamily: 'Hanken Grotesk'),
                          decoration: InputDecoration(
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 16, right: 8, top: 12),
                              child: Text('Rp', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: onSurfaceVariant, fontFamily: 'Hanken Grotesk')),
                            ),
                            hintText: '0',
                            hintStyle: const TextStyle(color: outlineVariant),
                            fillColor: secondaryContainer.withOpacity(0.4),
                            filled: true,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Field Stok
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'STOK',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: onSurfaceVariant, letterSpacing: 1.5, fontFamily: 'Hanken Grotesk'),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: stokC,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: onSurface, fontFamily: 'Hanken Grotesk'),
                          decoration: InputDecoration(
                            hintText: '0',
                            hintStyle: const TextStyle(color: outlineVariant),
                            fillColor: secondaryContainer.withOpacity(0.4),
                            filled: true,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 35),

              // =========================
              // SUBMIT BUTTON (SIMPAN PRODUK)
              // =========================
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : saveProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: onPrimary)
                      : const Text(
                          'Simpan Produk',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Hanken Grotesk'),
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