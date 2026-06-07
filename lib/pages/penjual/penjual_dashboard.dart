import 'package:flutter/material.dart';
import 'package:smwaste/pages/penjual/product/seller_order_page.dart';

import '../profile/edit_profile_page.dart';

import 'product/penjual_product_page.dart';

class PenjualDashboard
    extends StatefulWidget {
  const PenjualDashboard({
    super.key,
  });

  @override
  State<PenjualDashboard>
      createState() =>
          _PenjualDashboardState();
}

class _PenjualDashboardState
    extends State<PenjualDashboard> {
  int currentIndex = 0;

  final pages = [
    const PenjualHomePage(),

    // =========================
    // PRODUK PAGE
    // =========================

    const PenjualProductPage(),

    const SellerOrderPage(),

    const EditProfilePage(),
  ];

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex:
            currentIndex,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Produk',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Pesanan',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

class PenjualHomePage
    extends StatelessWidget {
  const PenjualHomePage({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Home Penjual",
        ),
      ),
    );
  }
}

class OrderPage
    extends StatelessWidget {
  const OrderPage({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Pesanan Penjual",
        ),
      ),
    );
  }
}