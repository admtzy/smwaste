import 'package:flutter/material.dart';
import '../../services/cart_service.dart';
import 'checkout_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService cartService = CartService();
  List carts = [];
  bool isLoading = true;

  // Palette warna SMARTWASTE sesuai mockup HTML
  final Color colorPrimary = const Color(0xff004e3b);
  final Color colorBackground = const Color(0xfffcf9f8);
  final Color colorSurfaceContainerLowest = const Color(0xffffffff);
  final Color colorOnSurface = const Color(0xff1c1b1b);
  final Color colorOnSurfaceVariant = const Color(0xff3f4944);
  final Color colorOutlineVariant = const Color(0xffbfc9c3);
  final Color colorSecondaryFixed = const Color(0xffd5e7da);
  final Color colorSecondaryFixedDim = const Color(0xffb9cbbe);

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    try {
      final data = await cartService.getCart();
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  // =========================
  // LOGIKA PERHITUNGAN (TETAP DART)
  // =========================
  double get total {
    double result = 0;
    for (var item in carts) {
      final product = item['products'];
      result += (product['harga'] * item['qty']).toDouble();
    }
    return result;
  }

  double get totalOngkir {
    double result = 0;
    for (var item in carts) {
      result += (item['ongkir'] ?? 0).toDouble();
    }
    return result;
  }

  double get adminFee {
    return (total * 0.1).roundToDouble(); // Biaya admin 10%
  }

  double get grandTotal {
    return total + totalOngkir + adminFee;
  }

  Future<void> deleteCart(String id) async {
    try {
      await cartService.deleteCart(id);
      await loadCart();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cart dihapus')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        backgroundColor: colorSurfaceContainerLowest,
        elevation: 0,
        // PERBAIKAN: Hanya munculkan tombol back jika halaman ini dibuka via Navigator.push
        automaticallyImplyLeading: Navigator.canPop(context),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: colorOnSurface),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          'Keranjang',
          style: TextStyle(
            color: colorOnSurface,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: colorPrimary))
          : carts.isEmpty
              ? Center(
                  child: Text(
                    'Keranjang kosong',
                    style: TextStyle(color: colorOnSurfaceVariant),
                  ),
                )
              : Column(
                  children: [
                    // List Item di Keranjang
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: carts.length,
                        itemBuilder: (context, index) {
                          final cart = carts[index];
                          final product = cart['products'];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colorSurfaceContainerLowest,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: colorOutlineVariant.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Thumbnail Gambar Produk
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: colorOutlineVariant.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: product['image_url'] != null &&
                                          product['image_url']
                                              .toString()
                                              .isNotEmpty
                                      ? Image.network(
                                          product['image_url'],
                                          fit: BoxFit.cover,
                                        )
                                      : Icon(Icons.image,
                                          color: colorOnSurfaceVariant),
                                ),
                                const SizedBox(width: 16),
                                // Rincian Item (Sesuai Visual Terstruktur HTML)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              product['nama_produk'] ?? '',
                                              style: TextStyle(
                                                color: colorOnSurface,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () =>
                                                deleteCart(cart['id'].toString()),
                                            child: const Icon(
                                              Icons.delete_outline,
                                              color: Colors.red,
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on,
                                              size: 14,
                                              color: colorOnSurfaceVariant),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Seller: ${cart['seller_kecamatan']}, ${cart['seller_kabupaten']}',
                                            style: TextStyle(
                                              color: colorOnSurfaceVariant,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Subtotal: Rp ${product['harga'] * cart['qty']}',
                                        style: TextStyle(
                                          color: colorOnSurfaceVariant,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        'Ongkir: Rp ${cart['ongkir'] ?? 0}',
                                        style: TextStyle(
                                          color: colorOnSurfaceVariant,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Rp ${product['harga']}',
                                            style: TextStyle(
                                              color: colorPrimary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          // Kontrol Kuantitas (Tactile Input Style)
                                          Container(
                                            decoration: BoxDecoration(
                                              color: colorSecondaryFixed
                                                  .withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: colorSecondaryFixedDim),
                                            ),
                                            child: Row(
                                              children: [
                                                _quantityButton(
                                                    Icons.remove, () {}),
                                                SizedBox(
                                                  width: 32,
                                                  child: Text(
                                                    '${cart['qty']}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: colorOnSurface,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                _quantityButton(
                                                    Icons.add, () {}),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // Sliding Sheet / Container Bottom Ringkasan Pembayaran
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: colorSurfaceContainerLowest,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          )
                        ],
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ringkasan Pembayaran',
                              style: TextStyle(
                                color: colorOnSurface,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _summaryRow('Total Harga (${carts.length} Barang)',
                                'Rp ${total.toInt()}'),
                            const SizedBox(height: 8),
                            _summaryRow(
                                'Total Ongkos Kirim', 'Rp ${totalOngkir.toInt()}'),
                            const SizedBox(height: 8),
                            _summaryRow('Biaya Admin (10%)', 'Rp ${adminFee.toInt()}'),
                            const Divider(height: 24, thickness: 0.5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Pembayaran',
                                  style: TextStyle(
                                    color: colorOnSurface,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Rp ${grandTotal.toInt()}',
                                  style: TextStyle(
                                    color: colorPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorPrimary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CheckoutPage(
                                        totalProduk: total.toInt(),
                                        totalOngkir: totalOngkir.toInt(),
                                        adminFee: adminFee.toInt(),
                                        grandTotal: grandTotal.toInt(),
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Checkout',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: 32,
        height: 32,
        child: Icon(icon, size: 18, color: colorOnSurface),
      ),
    );
  }

  Widget _summaryRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(color: colorOnSurfaceVariant, fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(color: colorOnSurfaceVariant, fontSize: 14),
        ),
      ],
    );
  }
}