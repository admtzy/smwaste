import 'package:flutter/material.dart';

import '../profile/edit_profile_page.dart';

import 'cart_page.dart';
import 'pembeli_product_page.dart';
import 'my_order_page.dart';

class PembeliDashboard
    extends StatefulWidget {
  const PembeliDashboard({
    super.key,
  });

  @override
  State<PembeliDashboard>
      createState() =>
          _PembeliDashboardState();
}

class _PembeliDashboardState
    extends State<PembeliDashboard> {
  int currentIndex = 0;

  // =========================
  // PAGES
  // =========================

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    pages = [
      const PembeliProductPage(),

      const CartPage(),

      const MyOrderPage(),

      const EditProfilePage(),
    ];
  }

  // =========================
  // UI
  // =========================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      // =========================
      // BODY
      // =========================

      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),

      // =========================
      // BOTTOM NAVIGATION
      // =========================

      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex:
            currentIndex,

        type:
            BottomNavigationBarType.fixed,

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

          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Keranjang',
          ),

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