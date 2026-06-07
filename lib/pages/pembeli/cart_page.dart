import 'package:flutter/material.dart';

import '../../services/cart_service.dart';
import 'checkout_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    super.key,
  });

  @override
  State<CartPage> createState() =>
      _CartPageState();
}

class _CartPageState
    extends State<CartPage> {
  final CartService cartService =
      CartService();

  List carts = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadCart();
  }

  Future<void> loadCart() async {
    try {
      final data =
          await cartService.getCart();

      if (!mounted) return;

      setState(() {
        carts = data;
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
            e.toString(),
          ),
        ),
      );
    }
  }

  // =========================
  // TOTAL BARANG
  // =========================

  double get total {
    double result = 0;

    for (var item in carts) {
      final product =
          item['products'];

      result +=
          (product['harga'] *
                  item['qty'])
              .toDouble();
    }

    return result;
  }

  // =========================
  // TOTAL ONGKIR
  // =========================

  double get totalOngkir {
    double result = 0;

    for (var item in carts) {
      result +=
          (item['ongkir'] ?? 0)
              .toDouble();
    }

    return result;
  }

  // =========================
  // GRAND TOTAL
  // =========================

  double get grandTotal {
    return total + totalOngkir;
  }

  Future<void> deleteCart(
    String id,
  ) async {
    try {
      await cartService.deleteCart(
        id,
      );

      await loadCart();

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Cart dihapus',
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
          'Keranjang',
        ),
      ),

      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : carts.isEmpty
              ? const Center(
                  child: Text(
                    'Keranjang kosong',
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount:
                            carts.length,
                        itemBuilder:
                            (context, index) {
                          final cart =
                              carts[index];

                          final product =
                              cart[
                                  'products'];

                          return Card(
                            margin:
                                const EdgeInsets.all(
                              10,
                            ),

                            child: ListTile(
                              leading:
                                  product['image_url'] !=
                                              null &&
                                          product[
                                                  'image_url']
                                              .toString()
                                              .isNotEmpty
                                      ? Image.network(
                                          product[
                                              'image_url'],
                                          width:
                                              60,
                                          fit: BoxFit
                                              .cover,
                                        )
                                      : const Icon(
                                          Icons
                                              .image,
                                        ),

                              title: Text(
                                product[
                                    'nama_produk'],
                              ),

                              subtitle:
                                  Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Text(
                                    'Rp ${product['harga']}',
                                  ),

                                  Text(
                                    'Qty : ${cart['qty']}',
                                  ),

                                  Text(
                                    'Subtotal : Rp ${product['harga'] * cart['qty']}',
                                  ),

                                  Text(
                                    'Ongkir : Rp ${cart['ongkir']}',
                                  ),

                                  Text(
                                    'Seller : ${cart['seller_kecamatan']}, ${cart['seller_kabupaten']}',
                                  ),
                                ],
                              ),

                              trailing:
                                  IconButton(
                                onPressed:
                                    () =>
                                        deleteCart(
                                          cart[
                                              'id'],
                                        ),

                                icon:
                                    const Icon(
                                  Icons.delete,
                                  color:
                                      Colors.red,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    Container(
                      padding:
                          const EdgeInsets.all(
                        20,
                      ),

                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,

                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [
                              const Text(
                                'Pembayaran',

                                style:
                                    TextStyle(
                                  fontSize:
                                      18,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),

                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .end,

                                children: [
                                  Text(
                                    'Barang : Rp $total',
                                  ),

                                  Text(
                                    'Ongkir : Rp $totalOngkir',
                                  ),

                                  const SizedBox(
                                    height: 5,
                                  ),

                                  Text(
                                    'Total : Rp $grandTotal',

                                    style:
                                        const TextStyle(
                                      fontSize:
                                          18,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          SizedBox(
                            width: double
                                .infinity,

                            child:
                              ElevatedButton(
                                onPressed: () {

                                  final int totalProduk =
                                      total.toInt();

                                  final int ongkir =
                                      totalOngkir.toInt();

                                  final int adminFee =
                                      (totalProduk * 0.1)
                                          .round();

                                  final int grandTotal =
                                      totalProduk +
                                      ongkir +
                                      adminFee;

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) =>
                                              CheckoutPage(
                                                totalProduk:
                                                    totalProduk,

                                                totalOngkir:
                                                    ongkir,

                                                adminFee:
                                                    adminFee,

                                                grandTotal:
                                                    grandTotal,
                                              ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Checkout',
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}