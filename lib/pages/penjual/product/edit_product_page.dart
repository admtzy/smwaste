import 'package:flutter/material.dart';

import '../../../services/product_service.dart';

class EditProductPage extends StatefulWidget {
  final Map product;

  const EditProductPage({
    super.key,
    required this.product,
  });

  @override
  State<EditProductPage> createState() =>
      _EditProductPageState();
}

class _EditProductPageState
    extends State<EditProductPage> {
  final productService =
      ProductService();

  late TextEditingController namaC;

  late TextEditingController
      deskripsiC;

  late TextEditingController hargaC;

  late TextEditingController stokC;

  // late TextEditingController
  //     kecamatanC;

  // late TextEditingController
  //     kabupatenC;

  late String kategori;

  bool isLoading = false;

  // =========================
  // INIT
  // =========================

  @override
  void initState() {
    super.initState();

    namaC = TextEditingController(
      text:
          widget.product['nama_produk'] ??
          '',
    );

    deskripsiC =
        TextEditingController(
      text:
          widget.product['deskripsi'] ??
          '',
    );

    hargaC = TextEditingController(
      text:
          widget.product['harga']
              .toString(),
    );

    stokC = TextEditingController(
      text:
          widget.product['stok']
              .toString(),
    );

    // kecamatanC =
    //     TextEditingController(
    //   text:
    //       widget.product['kecamatan'] ??
    //       '',
    // );

    // kabupatenC =
    //     TextEditingController(
    //   text:
    //       widget.product['kabupaten'] ??
    //       '',
    // );

    kategori =
        widget.product['kategori'] ??
        'Makanan';
  }

  // =========================
  // UPDATE PRODUCT
  // =========================

  Future<void> updateProduct() async {
    try {
      if (namaC.text.isEmpty ||
          deskripsiC.text.isEmpty ||
          hargaC.text.isEmpty ||
          stokC.text.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          const SnackBar(
            content: Text(
              'Semua field wajib diisi',
            ),
          ),
        );

        return;
      }

      setState(() {
        isLoading = true;
      });

      await productService
          .updateProduct(
        id: widget.product['id'],

        namaProduk:
            namaC.text.trim(),

        deskripsi:
            deskripsiC.text.trim(),

        harga: int.parse(
          hargaC.text,
        ),

        stok: int.parse(
          stokC.text,
        ),

        kategori: kategori,

        // kecamatan:
        //     kecamatanC.text.trim(),

        // kabupaten:
        //     kabupatenC.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Produk berhasil diupdate',
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            'Error : $e',
          ),
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

  // =========================
  // DISPOSE
  // =========================

  @override
  void dispose() {
    namaC.dispose();

    deskripsiC.dispose();

    hargaC.dispose();

    stokC.dispose();

    // kecamatanC.dispose();

    // kabupatenC.dispose();

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
          'Edit Produk',
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(20),

        child: SingleChildScrollView(
          child: Column(
            children: [
              // =========================
              // IMAGE
              // =========================

              if (widget.product['image_url'] !=
                      null &&
                  widget
                      .product['image_url']
                      .toString()
                      .isNotEmpty)
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),

                  child: Image.network(
                    widget.product[
                        'image_url'],

                    width:
                        double.infinity,

                    height: 220,

                    fit: BoxFit.cover,
                  ),
                ),

              const SizedBox(height: 20),

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

              const SizedBox(height: 15),

              // =========================
              // DESKRIPSI
              // =========================

              TextField(
                controller: deskripsiC,

                maxLines: 4,

                decoration:
                    const InputDecoration(
                  labelText:
                      'Deskripsi',

                  border:
                      OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              // =========================
              // HARGA
              // =========================

              TextField(
                controller: hargaC,

                keyboardType:
                    TextInputType.number,

                decoration:
                    const InputDecoration(
                  labelText: 'Harga',

                  border:
                      OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              // =========================
              // STOK
              // =========================

              TextField(
                controller: stokC,

                keyboardType:
                    TextInputType.number,

                decoration:
                    const InputDecoration(
                  labelText: 'Stok',

                  border:
                      OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

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

                  labelText:
                      'Kategori',
                ),

                items: const [
                  DropdownMenuItem(
                    value: 'Makanan',

                    child: Text(
                      'Makanan',
                    ),
                  ),

                  DropdownMenuItem(
                    value: 'Minuman',

                    child: Text(
                      'Minuman',
                    ),
                  ),

                  DropdownMenuItem(
                    value: 'Fashion',

                    child: Text(
                      'Fashion',
                    ),
                  ),
                ],

                onChanged: (value) {
                  setState(() {
                    kategori = value!;
                  });
                },
              ),

              // const SizedBox(height: 15),

              // // =========================
              // // KECAMATAN
              // // =========================

              // TextField(
              //   controller:
              //       kecamatanC,

              //   decoration:
              //       const InputDecoration(
              //     labelText:
              //         'Kecamatan',

              //     border:
              //         OutlineInputBorder(),
              //   ),
              // ),

              // const SizedBox(height: 15),

              // // =========================
              // // KABUPATEN
              // // =========================

              // TextField(
              //   controller:
              //       kabupatenC,

              //   decoration:
              //       const InputDecoration(
              //     labelText:
              //         'Kabupaten',

              //     border:
              //         OutlineInputBorder(),
              //   ),
              // ),

              const SizedBox(height: 25),

              // =========================
              // BUTTON
              // =========================

              SizedBox(
                width:
                    double.infinity,

                height: 50,

                child: ElevatedButton(
                  onPressed:
                      isLoading
                          ? null
                          : updateProduct,

                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Update Produk',
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