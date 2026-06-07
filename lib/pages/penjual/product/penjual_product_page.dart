import 'package:flutter/material.dart';

import '../../../services/product_service.dart';

import 'add_product_page.dart';
import 'detail_product_page.dart';
import 'edit_product_page.dart';

class PenjualProductPage
    extends StatefulWidget {
  const PenjualProductPage({
    super.key,
  });

  @override
  State<PenjualProductPage>
      createState() =>
          _PenjualProductPageState();
}

class _PenjualProductPageState
    extends State<PenjualProductPage> {
  final productService =
      ProductService();

  List products = [];

  bool isLoading = true;

  // =========================
  // LOAD PRODUCTS
  // =========================

  Future<void> loadProducts() async {
    try {
      final data =
          await productService
              .getMyProducts();

      if (!mounted) return;

      setState(() {
        products = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            'Error : $e',
          ),
        ),
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
      await productService
          .deleteProduct(id);

      await loadProducts();

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Produk berhasil dihapus',
          ),
        ),
      );
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
    }
  }

  // =========================
  // INIT
  // =========================

  @override
  void initState() {
    super.initState();

    loadProducts();
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
          'Produk Saya',
        ),
      ),

      // =========================
      // ADD PRODUCT
      // =========================

      floatingActionButton:
          FloatingActionButton(
        onPressed: () async {
          final result =
              await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const AddProductPage(),
            ),
          );

          if (result == true) {
            loadProducts();
          }
        },

        child: const Icon(
          Icons.add,
        ),
      ),

      // =========================
      // BODY
      // =========================

      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : products.isEmpty
              ? const Center(
                  child: Text(
                    'Belum ada produk',
                  ),
                )
              : ListView.builder(
                  itemCount:
                      products.length,

                  itemBuilder:
                      (context, index) {
                    final product =
                        products[index];

                    return Card(
                      margin:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),

                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.all(
                          10,
                        ),

                        // =========================
                        // IMAGE
                        // =========================

                        leading:
                            product['image_url'] !=
                                        null &&
                                    product[
                                            'image_url']
                                        .toString()
                                        .isNotEmpty
                                ? ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(
                                      8,
                                    ),

                                    child:
                                        Image.network(
                                      product[
                                          'image_url'],

                                      width: 65,
                                      height:
                                          65,

                                      fit: BoxFit
                                          .cover,
                                    ),
                                  )
                                : Container(
                                    width: 65,
                                    height:
                                        65,

                                    decoration:
                                        BoxDecoration(
                                      color:
                                          Colors.grey.shade300,

                                      borderRadius:
                                          BorderRadius.circular(
                                        8,
                                      ),
                                    ),

                                    child:
                                        const Icon(
                                      Icons.image,
                                    ),
                                  ),

                        // =========================
                        // TITLE
                        // =========================

                        title: Text(
                          product[
                                  'nama_produk'] ??
                              '-',

                          maxLines: 1,

                          overflow:
                              TextOverflow
                                  .ellipsis,

                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                        // =========================
                        // SUBTITLE
                        // =========================

                        subtitle: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [
                            const SizedBox(
                              height: 5,
                            ),

                            Text(
                              'Rp ${product['harga']}',
                            ),

                            Text(
                              'Stok : ${product['stok']}',
                            ),

                            Text(
                              '${product['kecamatan'] ?? '-'}, ${product['kabupaten'] ?? '-'}',
                            ),
                          ],
                        ),

                        // =========================
                        // ACTION
                        // =========================

                        trailing:
                            PopupMenuButton<
                                String>(
                          onSelected:
                              (
                            value,
                          ) async {
                            // =========================
                            // DETAIL
                            // =========================

                            if (value ==
                                'detail') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DetailProductPage(
                                    product:
                                        product,
                                  ),
                                ),
                              );
                            }

                            // =========================
                            // EDIT
                            // =========================

                            if (value ==
                                'edit') {
                              final result =
                                  await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      EditProductPage(
                                    product:
                                        product,
                                  ),
                                ),
                              );

                              if (result ==
                                  true) {
                                loadProducts();
                              }
                            }

                            // =========================
                            // DELETE
                            // =========================

                            if (value ==
                                'delete') {
                              final confirm =
                                  await showDialog(
                                context:
                                    context,

                                builder:
                                    (
                                  context,
                                ) {
                                  return AlertDialog(
                                    title:
                                        const Text(
                                      'Hapus Produk',
                                    ),

                                    content:
                                        const Text(
                                      'Yakin ingin menghapus produk?',
                                    ),

                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () {
                                          Navigator.pop(
                                            context,
                                            false,
                                          );
                                        },

                                        child:
                                            const Text(
                                          'Batal',
                                        ),
                                      ),

                                      ElevatedButton(
                                        onPressed:
                                            () {
                                          Navigator.pop(
                                            context,
                                            true,
                                          );
                                        },

                                        child:
                                            const Text(
                                          'Hapus',
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirm ==
                                  true) {
                                deleteProduct(
                                  product[
                                      'id'],
                                );
                              }
                            }
                          },

                          itemBuilder:
                              (
                            context,
                          ) {
                            return const [
                              PopupMenuItem(
                                value:
                                    'detail',

                                child: Text(
                                  'Detail',
                                ),
                              ),

                              PopupMenuItem(
                                value:
                                    'edit',

                                child: Text(
                                  'Edit',
                                ),
                              ),

                              PopupMenuItem(
                                value:
                                    'delete',

                                child: Text(
                                  'Delete',
                                ),
                              ),
                            ];
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}