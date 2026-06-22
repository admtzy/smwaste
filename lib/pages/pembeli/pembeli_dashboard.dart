import 'package:flutter/material.dart';
import '../profile/edit_profile_page.dart';
// import 'cart_page.dart';
import 'pembeli_product_page.dart';
import 'my_order_page.dart';

class PembeliDashboard extends StatefulWidget {
  const PembeliDashboard({super.key});

  @override
  State<PembeliDashboard> createState() => _PembeliDashboardState();
}

class _PembeliDashboardState extends State<PembeliDashboard> {
  int currentIndex = 0;
  
  // Warna tema yang diseragamkan dengan halaman lain
  final Color primaryGreen = const Color(0xFF236652);

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      const PembeliProductPage(),
      // const CartPage(),
      const MyOrderPage(),
      const EditProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        // Diterapkan warna agar konsisten dengan tema hijau aplikasi
        selectedItemColor: primaryGreen,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront),
            label: 'Produk',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.shopping_cart),
          //   label: 'Keranjang',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}