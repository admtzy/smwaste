import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/location_service.dart';
import '../../../services/product_service.dart';

class AddProductPage
    extends StatefulWidget {
  const AddProductPage({
    super.key,
  });

  @override
  State<AddProductPage>
      createState() =>
          _AddProductPageState();
}

class _AddProductPageState
    extends State<AddProductPage> {
  final productService =
      ProductService();

  final locationService =
      LocationService();

  // =========================
  // CONTROLLER
  // =========================

  final namaC =
      TextEditingController();

  final deskripsiC =
      TextEditingController();

  final hargaC =
      TextEditingController();

  final stokC =
      TextEditingController();

  // =========================

  String kategori =
      'Makanan';

  XFile? image;

  double latitude = 0;
  double longitude = 0;

  bool isLoading = false;

  // =========================
  // CAMERA
  // =========================

  Future<void> pickCamera() async {
    try {
      final result =
          await productService
              .pickFromCamera();

      if (result != null) {
        setState(() {
          image = result;
        });
      }
    } catch (e) {
      showMessage(
        'Camera Error : $e',
      );
    }
  }

  // =========================
  // GALLERY
  // =========================

  Future<void> pickGallery() async {
    try {
      final result =
          await productService
              .pickFromGallery();

      if (result != null) {
        setState(() {
          image = result;
        });
      }
    } catch (e) {
      showMessage(
        'Gallery Error : $e',
      );
    }
  }

  // =========================
  // GET LOCATION
  // =========================

  Future<void> getLocation() async {
    try {
      Position position =
          await locationService
              .getCurrentLocation();

      setState(() {
        latitude =
            position.latitude;

        longitude =
            position.longitude;
      });

      showMessage(
        'GPS berhasil diambil',
      );
    } catch (e) {
      showMessage(
        'GPS Error : $e',
      );
    }
  }

  // =========================
  // SAVE PRODUCT
  // =========================

  Future<void> saveProduct() async {
    try {
      // =========================
      // VALIDASI
      // =========================

      if (namaC.text.isEmpty ||
          deskripsiC.text.isEmpty ||
          hargaC.text.isEmpty ||
          stokC.text.isEmpty) {
        showMessage(
          'Semua field wajib diisi',
        );

        return;
      }

      if (image == null) {
        showMessage(
          'Upload gambar dulu',
        );

        return;
      }

      if (latitude == 0 ||
          longitude == 0) {
        showMessage(
          'Ambil GPS terlebih dahulu',
        );

        return;
      }

      final harga =
          int.tryParse(
        hargaC.text,
      );

      final stok =
          int.tryParse(
        stokC.text,
      );

      if (harga == null ||
          stok == null) {
        showMessage(
          'Harga dan stok harus angka',
        );

        return;
      }

      // =========================
      // LOADING
      // =========================

      setState(() {
        isLoading = true;
      });

      // =========================
      // UPLOAD IMAGE
      // =========================

      final imageUrl =
          await productService
              .uploadImage(
        image!,
      );

      // =========================
      // INSERT DB
      // =========================

      await productService
          .addProduct(
        namaProduk:
            namaC.text.trim(),

        deskripsi:
            deskripsiC.text.trim(),

        harga: harga,

        stok: stok,

        kategori: kategori,

        imageUrl: imageUrl,

        latitude: latitude,

        longitude: longitude,
      );

      if (!mounted) return;

      showMessage(
        'Produk berhasil ditambahkan',
      );

      Navigator.pop(context);
    } catch (e) {
      showMessage(
        'Error : $e',
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // =========================
  // SNACKBAR
  // =========================

  void showMessage(
    String msg,
  ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }

  // =========================
  // DISPOSE
  // =========================

  @override
  void dispose() {
    namaC.dispose();
    deskripsiC.dispose();
    hargaC.dispose();
    stokC.dispose();

    super.dispose();
  }

  // =========================
  // UI
  // =========================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Produk',
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(
          20,
        ),

        child: SingleChildScrollView(
          child: Column(
            children: [
              // =========================
              // PREVIEW IMAGE
              // =========================

              if (image != null)
                Container(
                  width:
                      double.infinity,

                  height: 220,

                  margin:
                      const EdgeInsets.only(
                    bottom: 20,
                  ),

                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),

                    child: kIsWeb
                        ? Image.network(
                            image!.path,
                            fit: BoxFit
                                .cover,
                          )
                        : Image.file(
                            File(
                              image!.path,
                            ),
                            fit: BoxFit
                                .cover,
                          ),
                  ),
                ),

              // =========================
              // NAMA
              // =========================

              TextField(
                controller: namaC,

                decoration:
                    const InputDecoration(
                  labelText:
                      'Nama Produk',

                  border:
                      OutlineInputBorder(),
                ),
              ),

              const SizedBox(
                height: 15,
              ),

              // =========================
              // DESKRIPSI
              // =========================

              TextField(
                controller:
                    deskripsiC,

                maxLines: 3,

                decoration:
                    const InputDecoration(
                  labelText:
                      'Deskripsi',

                  border:
                      OutlineInputBorder(),
                ),
              ),

              const SizedBox(
                height: 15,
              ),

              // =========================
              // HARGA
              // =========================

              TextField(
                controller: hargaC,

                keyboardType:
                    TextInputType
                        .number,

                decoration:
                    const InputDecoration(
                  labelText:
                      'Harga',

                  border:
                      OutlineInputBorder(),
                ),
              ),

              const SizedBox(
                height: 15,
              ),

              // =========================
              // STOK
              // =========================

              TextField(
                controller: stokC,

                keyboardType:
                    TextInputType
                        .number,

                decoration:
                    const InputDecoration(
                  labelText:
                      'Stok',

                  border:
                      OutlineInputBorder(),
                ),
              ),

              const SizedBox(
                height: 15,
              ),

              // =========================
              // KATEGORI
              // =========================

              DropdownButtonFormField<
                  String>(
                value: kategori,

                decoration:
                    const InputDecoration(
                  border:
                      OutlineInputBorder(),
                ),

                items: const [
                  DropdownMenuItem(
                    value:
                        'Makanan',

                    child: Text(
                      'Makanan',
                    ),
                  ),

                  DropdownMenuItem(
                    value:
                        'Minuman',

                    child: Text(
                      'Minuman',
                    ),
                  ),

                  DropdownMenuItem(
                    value:
                        'Fashion',

                    child: Text(
                      'Fashion',
                    ),
                  ),
                ],

                onChanged: (
                  value,
                ) {
                  setState(() {
                    kategori =
                        value!;
                  });
                },
              ),

              const SizedBox(
                height: 20,
              ),

              // =========================
              // CAMERA
              // =========================

              SizedBox(
                width:
                    double.infinity,

                child:
                    ElevatedButton.icon(
                  onPressed:
                      pickCamera,

                  icon: const Icon(
                    Icons.camera_alt,
                  ),

                  label: const Text(
                    'Ambil Dari Kamera',
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              // =========================
              // GALLERY
              // =========================

              SizedBox(
                width:
                    double.infinity,

                child:
                    ElevatedButton.icon(
                  onPressed:
                      pickGallery,

                  icon: const Icon(
                    Icons.photo,
                  ),

                  label: const Text(
                    'Ambil Dari Gallery',
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              // =========================
              // GPS
              // =========================

              SizedBox(
                width:
                    double.infinity,

                child:
                    ElevatedButton.icon(
                  onPressed:
                      getLocation,

                  icon: const Icon(
                    Icons.location_on,
                  ),

                  label: Text(
                    latitude == 0
                        ? 'Ambil GPS'
                        : 'GPS Berhasil',
                  ),
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              // =========================
              // SAVE
              // =========================

              SizedBox(
                width:
                    double.infinity,

                height: 50,

                child:
                    ElevatedButton(
                  onPressed:
                      isLoading
                          ? null
                          : saveProduct,

                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Simpan Produk',
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