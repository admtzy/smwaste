import 'package:flutter/material.dart';
import 'package:smwaste/pages/admin/admin_product_page.dart';
// import 'package:smwaste/pages/admin/manage_users_page.dart';

import 'manage_users_page.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int currentIndex = 0;

  final pages = [
    const AdminHomePage(),
    const ManageUsersPage(),
    const AdminProductPage(),
    const AdminProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF236652);

    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryGreen,
        unselectedItemColor: Colors.grey,

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
            icon: Icon(Icons.group),
            label: 'Users',
          ),
          
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2), // ✅ PRODUCT ICON
            label: 'Products',
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

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Dashboard Admin",
        ),
      ),
    );
  }
}

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Profile Admin",
        ),
      ),
    );
  }
}