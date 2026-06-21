import 'package:flutter/material.dart';
import 'package:smwaste/pages/penjual/product/seller_order_page.dart';
import '../profile/edit_profile_page.dart';
import 'product/penjual_product_page.dart';
import '../../services/product_service.dart';
import '../../services/order_service.dart';

// =========================================================================
// CONTAINER UTAMA: MEMILIKI BOTTOM NAVIGATION BAR
// =========================================================================
class PenjualDashboard extends StatefulWidget {
  const PenjualDashboard({super.key});

  @override
  State<PenjualDashboard> createState() => _PenjualDashboardState();
}

class _PenjualDashboardState extends State<PenjualDashboard> {
  int currentIndex = 0;

  // Halaman-halaman sekarang aktif digunakan di sini
  final pages = [
    const PenjualHomePage(),
    const PenjualProductPage(),
    const SellerOrderPage(),
    const EditProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    const Color colorPrimary = Color(0xFF004E3B);
    const Color colorBackground = Color(0xFFFCF9F8);
    const Color colorSecondaryContainer = Color(0xFFD5E7DA);
    const Color colorOnSecondaryContainer = Color(0xFF101F17);
    const Color colorSecondary = Color(0xFF526258);

    return Scaffold(
      backgroundColor: colorBackground,
      body: pages[currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: BottomNavigationBar(
                currentIndex: currentIndex,
                onTap: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: colorOnSecondaryContainer,
                unselectedItemColor: colorSecondary,
                selectedLabelStyle: const TextStyle(
                  fontFamily: 'Hanken Grotesk',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontFamily: 'Hanken Grotesk',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                items: [
                  BottomNavigationBarItem(
                    icon: const Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Icon(Icons.home_outlined),
                    ),
                    activeIcon: _buildActiveIcon(Icons.home, colorSecondaryContainer, colorPrimary),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: const Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Icon(Icons.store_outlined),
                    ),
                    activeIcon: _buildActiveIcon(Icons.store, colorSecondaryContainer, colorPrimary),
                    label: 'Produk',
                  ),
                  BottomNavigationBarItem(
                    icon: const Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Icon(Icons.receipt_long_outlined),
                    ),
                    activeIcon: _buildActiveIcon(Icons.receipt_long, colorSecondaryContainer, colorPrimary),
                    label: 'Pesanan',
                  ),
                  BottomNavigationBarItem(
                    icon: const Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Icon(Icons.person_outline),
                    ),
                    activeIcon: _buildActiveIcon(Icons.person, colorSecondaryContainer, colorPrimary),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveIcon(IconData iconData, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Icon(iconData, color: iconColor),
    );
  }
}

// =========================================================================
// HALAMAN HOME: MENAMPILKAN RINGKASAN DATA REALTIME SUPABASE
// =========================================================================
class PenjualHomePage extends StatefulWidget {
  const PenjualHomePage({super.key});

  @override
  State<PenjualHomePage> createState() => _PenjualHomePageState();
}

class _PenjualHomePageState extends State<PenjualHomePage> {
  final ProductService _productService = ProductService();
  final OrderService _orderService = OrderService();

  bool _isLoading = true;
  String _errorMessage = '';

  List<dynamic> _myProducts = [];
  List<Map<String, dynamic>> _sellerOrders = [];
  
  String _totalPenjualanText = "Rp 0";
  String _produkAktifText = "0";

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final results = await Future.wait([
        _productService.getMyProducts(),
        _orderService.getSellerOrders(),
      ]);

      _myProducts = results[0];
      _sellerOrders = results[1] as List<Map<String, dynamic>>;

      _produkAktifText = _myProducts.length.toString();

      int totalSales = 0;
      for (var item in _sellerOrders) {
        final orderData = item["orders"];
        if (orderData != null) {
          final String status = orderData["order_status"] ?? '';
          if (status == 'processed' || status == 'shipped' || status == 'completed') {
            final int harga = item["harga"] ?? 0;
            final int quantity = item["quantity"] ?? 1; 
            totalSales += (harga * quantity);
          }
        }
      }
      _totalPenjualanText = _formatKeRupiah(totalSales);

    } catch (e) {
      _errorMessage = 'Gagal memuat data: $e';
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatKeRupiah(int number) {
    if (number == 0) return "Rp 0";
    final s = number.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buffer.write(s[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    return "Rp ${buffer.toString().split('').reversed.join('')}";
  }

  @override
  Widget build(BuildContext context) {
    const Color colorPrimary = Color(0xFF004E3B);
    const Color colorOnSurface = Color(0xFF1C1B1B);
    const Color colorOutline = Color(0xFF707974);

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8),
      appBar: AppBar(
        backgroundColor: colorPrimary,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const ClipOval(
                child: Icon(Icons.recycling, color: colorPrimary, size: 20),
              ),
            ),
            const SizedBox(width: 8),
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
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _fetchDashboardData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: colorPrimary))
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red, fontFamily: 'Hanken Grotesk')))
              : RefreshIndicator(
                  onRefresh: _fetchDashboardData,
                  color: colorPrimary,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Ringkasan Bisnis",
                          style: TextStyle(
                            fontFamily: 'Hanken Grotesk',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorOnSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildSummaryCard(
                                context,
                                Icons.account_balance_wallet_outlined,
                                "Total Penjualan",
                                _totalPenjualanText,
                                colorPrimary,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildSummaryCard(
                                context,
                                Icons.inventory_2_outlined,
                                "Produk Aktif",
                                _produkAktifText,
                                colorPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Produk Saya",
                              style: TextStyle(
                                fontFamily: 'Hanken Grotesk',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: colorOnSurface,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Lihat Semua",
                                style: TextStyle(
                                  fontFamily: 'Hanken Grotesk',
                                  color: colorPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _myProducts.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Text("Belum ada produk aktif.", style: TextStyle(fontFamily: 'Hanken Grotesk', color: colorOutline)),
                              )
                            : SizedBox(
                                height: 205,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: _myProducts.length,
                                  itemBuilder: (context, index) {
                                    final produk = _myProducts[index];
                                    return _buildProductCard(
                                      produk['nama_produk'] ?? '-',
                                      _formatKeRupiah(produk['harga'] ?? 0),
                                      "Stok: ${produk['stok'] ?? 0}",
                                      imageUrlFallback: produk['image_url'],
                                    );
                                  },
                                ),
                              ),
                        const SizedBox(height: 28),
                        const Text(
                          "Pesanan Terbaru",
                          style: TextStyle(
                            fontFamily: 'Hanken Grotesk',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorOnSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _sellerOrders.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Text("Belum ada pesanan terbaru.", style: TextStyle(fontFamily: 'Hanken Grotesk', color: colorOutline)),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _sellerOrders.length > 5 ? 5 : _sellerOrders.length,
                                itemBuilder: (context, index) {
                                  final item = _sellerOrders[index];
                                  final orderData = item["orders"] ?? {};
                                  final productData = item["products"] ?? {};

                                  String statusRaw = (orderData["order_status"] ?? 'PENDING').toUpperCase();
                                  
                                  Color badgeBg = const Color(0xFFE5E2E1);
                                  Color badgeText = colorOutline;
                                  if (statusRaw == 'PROCESSED' || statusRaw == 'PAID') {
                                    badgeBg = const Color(0xFFD5E7DA);
                                    badgeText = const Color(0xFF004F12);
                                  } else if (statusRaw == 'SHIPPED') {
                                    badgeBg = const Color(0xFFFFF4D4);
                                    badgeText = const Color(0xFF8A6D00);
                                  }

                                  int hargaItem = item["harga"] ?? 0;
                                  int kuantitasItem = item["quantity"] ?? 1;

                                  return _buildOrderRow(
                                    "User ${orderData['buyer_id']?.substring(0, 5) ?? '...'}", 
                                    "${productData['nama_produk'] ?? 'Produk'} x$kuantitasItem",
                                    statusRaw,
                                    _formatKeRupiah(hargaItem * kuantitasItem),
                                    badgeBg,
                                    badgeText,
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, IconData icon, String title, String value, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Hanken Grotesk',
              fontSize: 12,
              color: Color(0xFF707974),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Hanken Grotesk',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1C1B1B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(String name, String price, String stock, {String? imageUrlFallback}) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 14, bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            ),
            child: imageUrlFallback != null && imageUrlFallback.isNotEmpty
                ? ClipRRect(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                    child: Image.network(
                      imageUrlFallback,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image_outlined, color: Colors.grey)),
                    ),
                  )
                : const Center(child: Icon(Icons.image_outlined, color: Colors.grey)),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontFamily: 'Hanken Grotesk', fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(fontFamily: 'Hanken Grotesk', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF004E3B)),
                ),
                const SizedBox(height: 2),
                Text(
                  stock,
                  style: const TextStyle(fontFamily: 'Hanken Grotesk', fontSize: 11, color: Color(0xFF707974)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOrderRow(String customer, String item, String status, String total, Color badgeBg, Color badgeText) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFD5E7DA),
            child: Text(
              customer.isNotEmpty ? customer[0] : 'U',
              style: const TextStyle(fontFamily: 'Hanken Grotesk', color: Color(0xFF101F17), fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(customer, style: const TextStyle(fontFamily: 'Hanken Grotesk', fontSize: 14, fontWeight: FontWeight.w600)),
                Text(item, style: const TextStyle(fontFamily: 'Hanken Grotesk', fontSize: 12, color: Color(0xFF707974))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(999)),
                child: Text(
                  status,
                  style: TextStyle(fontFamily: 'Hanken Grotesk', fontSize: 10, fontWeight: FontWeight.bold, color: badgeText),
                ),
              ),
              const SizedBox(height: 4),
              Text(total, style: const TextStyle(fontFamily: 'Hanken Grotesk', fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }
}