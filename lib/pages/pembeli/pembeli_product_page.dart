import 'package:flutter/material.dart';

import '../../services/cart_service.dart';
import '../../services/product_service.dart';
import 'cart_page.dart';

class PembeliProductPage extends StatefulWidget {
  const PembeliProductPage({
    super.key,
  });

  @override
  State<PembeliProductPage> createState() => _PembeliProductPageState();
}

class _PembeliProductPageState extends State<PembeliProductPage> {
  final ProductService productService = ProductService();
  final CartService cartService = CartService();

  List products = [];
  bool isLoading = true;

  // Warna tema disesuaikan dengan Dashboard Pembeli (Primary Green: 0xFF236652)
  final Color primaryGreen = const Color(0xFF236652);
  final Color colorBackground = const Color(0xfffcf9f8);
  final Color colorSurfaceContainerLowest = const Color(0xffffffff);
  final Color colorSurfaceContainerLow = const Color(0xfff6f3f2);
  final Color colorOnSurfaceVariant = const Color(0xff3f4944);
  final Color colorOnSurface = const Color(0xff1c1b1b);
  final Color colorError = const Color(0xffba1a1a);
  final Color colorSurfaceVariant = const Color(0xffe5e2e1);

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final data = await productService.getProducts();

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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error load produk : $e',
          ),
        ),
      );
    }
  }

  Future<void> addCart(dynamic product) async {
    try {
      await cartService.addToCart(
        productId: product['id'],
        qty: 1,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berhasil tambah keranjang'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        backgroundColor: primaryGreen, // Menggunakan warna primary
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // Ikon Logo sesuai permintaan
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Icon(Icons.recycling, color: primaryGreen, size: 20),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "SMARTWASTE",
              style: TextStyle(
                fontFamily: 'Hanken Grotesk',
                fontWeight: FontWeight.w800,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CartPage(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white, // Warna ikon disesuaikan dengan latar AppBar
                ),
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.redAccent, // Warna badge agar kontras dengan hijau
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: const Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: colorSurfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.search, color: colorOnSurfaceVariant),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Cari produk ramah lingkungan...",
                        hintStyle: TextStyle(
                          fontFamily: 'Hanken Grotesk',
                          color: colorOnSurfaceVariant.withOpacity(0.7),
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 48,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildChip('Semua', true),
                _buildChip('Makanan Organik', false),
                _buildChip('Daur Ulang', false),
                _buildChip('Pupuk Kompos', false),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(primaryGreen),
                    ),
                  )
                : products.isEmpty
                    ? Center(
                        child: Text(
                          'Produk kosong',
                          style: TextStyle(
                            fontFamily: 'Hanken Grotesk',
                            color: colorOnSurfaceVariant,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.68,
                        ),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          final int stok = product['stok'] ?? 0;
                          final bool isHabis = stok <= 0;

                          return Container(
                            decoration: BoxDecoration(
                              color: colorSurfaceContainerLowest,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.black.withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: ColorFiltered(
                              colorFilter: isHabis
                                  ? ColorFilter.mode(
                                      Colors.grey.withOpacity(0.3),
                                      BlendMode.luminosity,
                                    )
                                  : const ColorFilter.mode(
                                      Colors.transparent,
                                      BlendMode.multiply,
                                    ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        product['image_url'] != null &&
                                                product['image_url']
                                                    .toString()
                                                    .isNotEmpty
                                            ? Image.network(
                                                product['image_url'],
                                                width: double.infinity,
                                                height: double.infinity,
                                                fit: BoxFit.cover,
                                              )
                                            : Container(
                                                color: colorSurfaceContainerLow,
                                                child: Center(
                                                  child: Icon(
                                                    Icons.image,
                                                    size: 40,
                                                    color: colorOnSurfaceVariant,
                                                  ),
                                                ),
                                              ),
                                        if (isHabis)
                                          Container(
                                            color: Colors.black.withOpacity(0.2),
                                            child: Center(
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 12, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: colorSurfaceVariant,
                                                  borderRadius:
                                                      BorderRadius.circular(99),
                                                ),
                                                child: const Text(
                                                  'HABIS',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 11,
                                                    letterSpacing: 1.2,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product['nama_produk'] ?? '-',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: colorOnSurface,
                                          ),
                                        ),
                                        Text(
                                          isHabis ? 'Stok Kosong' : 'Stok: $stok',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isHabis
                                                ? colorError
                                                : colorOnSurfaceVariant,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Rp ${product['harga']}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: isHabis
                                                    ? colorOnSurfaceVariant
                                                    : primaryGreen,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: isHabis
                                                  ? null
                                                  : () => addCart(product),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Container(
                                                width: 36,
                                                height: 36,
                                                decoration: BoxDecoration(
                                                  color: isHabis
                                                      ? colorSurfaceVariant
                                                      : primaryGreen,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: const Icon(
                                                  Icons.add_shopping_cart,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isActive,
        onSelected: (_) {},
        labelStyle: TextStyle(
          color: isActive ? Colors.white : colorOnSurfaceVariant,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
        backgroundColor: colorSurfaceContainerLow,
        selectedColor: primaryGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(99),
          side: BorderSide(
            color: isActive ? primaryGreen : colorSurfaceVariant,
          ),
        ),
        showCheckmark: false,
      ),
    );
  }
}