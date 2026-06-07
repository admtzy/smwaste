import 'package:flutter/material.dart';

import '../../services/cart_service.dart';
import '../../services/product_service.dart';
import 'cart_page.dart';

class PembeliProductPage
    extends StatefulWidget {
  const PembeliProductPage({
    super.key,
  });

  @override
  State<PembeliProductPage>
      createState() =>
          _PembeliProductPageState();
}

class _PembeliProductPageState
    extends State<PembeliProductPage> {
  final ProductService productService =
      ProductService();

  final CartService cartService =
      CartService();

  List products = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final data =
          await productService
              .getProducts();

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
            'Error load produk : $e',
          ),
        ),
      );
    }
  }

  Future<void> addCart(
    dynamic product,
  ) async {
    try {
      await cartService.addToCart(
        productId: product['id'],
        qty: 1,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Berhasil tambah keranjang',
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
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Produk',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const CartPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.shopping_cart,
            ),
          ),
        ],
      ),

      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : products.isEmpty
              ? const Center(
                  child: Text(
                    'Produk kosong',
                  ),
                )
              : GridView.builder(
                  padding:
                      const EdgeInsets.all(
                    12,
                  ),
                  itemCount:
                      products.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing:
                        10,
                    mainAxisSpacing:
                        10,
                    childAspectRatio:
                        0.7,
                  ),
                  itemBuilder:
                      (context, index) {
                    final product =
                        products[index];

                    return Card(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(
                          10,
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Expanded(
                              child: product[
                                              'image_url'] !=
                                          null &&
                                      product[
                                              'image_url']
                                          .toString()
                                          .isNotEmpty
                                  ? Image.network(
                                      product[
                                          'image_url'],
                                      width: double
                                          .infinity,
                                      fit: BoxFit
                                          .cover,
                                    )
                                  : Container(
                                      color: Colors
                                          .grey,
                                      child:
                                          const Center(
                                        child:
                                            Icon(
                                          Icons
                                              .image,
                                          size:
                                              50,
                                        ),
                                      ),
                                    ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            Text(
                              product[
                                      'nama_produk'] ??
                                  '-',
                              maxLines: 2,
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

                            const SizedBox(
                              height: 5,
                            ),

                            Text(
                              'Rp ${product['harga']}',
                            ),

                            Text(
                              'Stok : ${product['stok']}',
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            SizedBox(
                              width: double
                                  .infinity,
                              child:
                                  ElevatedButton(
                                onPressed:
                                    product['stok'] <=
                                            0
                                        ? null
                                        : () =>
                                            addCart(
                                              product,
                                            ),
                                child:
                                    const Text(
                                  'Tambah Cart',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}