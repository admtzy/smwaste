import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:smwaste/pages/admin/admin_product_page.dart';
import 'package:smwaste/pages/admin/admin_order_page.dart';
import '../../services/product_service.dart';
import '../../services/account_service.dart';
import 'manage_users_page.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const AdminHomePage(),
    const ManageUsersPage(),
    const AdminProductPage(),
    const AdminOrderPage(), 
  ];

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF004E3B);

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryGreen,
        unselectedItemColor: const Color(0xFF526258),
        backgroundColor: const Color(0xFFFCF9F8),
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Users",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: "Products",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "Orders",
          ),
        ],
      ),
    );
  }
}

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final productService = ProductService();
  final accountService = AccountService();
  final supabase = Supabase.instance.client;

  int totalUsers = 0;
  int totalProducts = 0;
  int totalOrders = 0;
  double totalRevenue = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      final users = await accountService.getAllUsers();
      final products = await productService.getAllProductsAdmin();
      final ordersData = await supabase.from('orders').select('grand_total');

      if (!mounted) return;

      double revenueSum = 0.0;
      for (var order in ordersData) {
        revenueSum += (order['grand_total'] ?? 0).toDouble();
      }

      setState(() {
        totalUsers = users.length;
        totalProducts = products.length;
        totalOrders = ordersData.length;
        totalRevenue = revenueSum;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const colorBackground = Color(0xFFFCF9F8);
    const colorPrimary = Color(0xFF004E3B);
    const colorOnPrimary = Color(0xFFFFFFFF);
    const colorOnBackground = Color(0xFF1C1B1B);
    const colorOnSurfaceVariant = Color(0xFF3F4944);
    const colorSurfaceContainer = Color(0xFFF0EDEC);
    const colorOutlineVariant = Color(0xFFBFC9C3);

    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        backgroundColor: colorPrimary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: const [
            Icon(Icons.recycling, color: colorOnPrimary),
            SizedBox(width: 8),
            Text(
              'SMARTWASTE',
              style: TextStyle(
                color: colorOnPrimary,
                fontFamily: 'Hanken Grotesk',
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: colorOnPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: colorPrimary),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dashboard Overview',
                      style: TextStyle(
                        color: colorOnBackground,
                        fontFamily: 'Hanken Grotesk',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Welcome back, Admin',
                      style: TextStyle(
                        color: colorOnSurfaceVariant,
                        fontFamily: 'Hanken Grotesk',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),

                    const SizedBox(height: 24),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.3,
                      children: [
                        _buildStatCard(Icons.group, 'Total Users', totalUsers.toString(), colorSurfaceContainer, colorPrimary, colorOnSurfaceVariant, colorOnBackground, colorOutlineVariant),
                        _buildStatCard(Icons.inventory_2, 'Active Products', totalProducts.toString(), colorSurfaceContainer, colorPrimary, colorOnSurfaceVariant, colorOnBackground, colorOutlineVariant),
                        _buildStatCard(Icons.receipt_long, 'Monthly Orders', totalOrders.toString(), colorSurfaceContainer, colorPrimary, colorOnSurfaceVariant, colorOnBackground, colorOutlineVariant),
                        _buildStatCard(Icons.payments, 'Total Revenue', 'Rp ${totalRevenue >= 1000 ? "${(totalRevenue / 1000).toStringAsFixed(1)}k" : totalRevenue.toStringAsFixed(0)}', colorSurfaceContainer, colorPrimary, colorOnSurfaceVariant, colorOnBackground, colorOutlineVariant),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard(IconData icon, String label, String value, Color bg, Color iconColor, Color labelColor, Color valueColor, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: iconColor),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: labelColor, fontFamily: 'Hanken Grotesk', fontSize: 12)),
              Text(value, style: TextStyle(color: valueColor, fontFamily: 'Hanken Grotesk', fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}