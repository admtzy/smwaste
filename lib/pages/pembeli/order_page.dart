import 'package:flutter/material.dart';
import '../../services/order_service.dart';
import 'order_detail_page.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key,});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final orderService = OrderService();
  List orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    final data = await orderService.getMyOrders();

    if (!mounted) return;

    setState(() {
      orders = data;
      isLoading = false;
    });
  }

  String getStatusText(Map order) {
    if (order['payment_status'] == 'pending') {
      return 'Menunggu Pembayaran';
    }
    if (order['payment_status'] == 'paid' && order['order_status'] == 'pending') {
      return 'Menunggu Pengiriman';
    }
    if (order['order_status'] == 'shipped') {
      return 'Sedang Dikirim';
    }
    if (order['order_status'] == 'completed') {
      return 'Pesanan Selesai';
    }
    return '-';
  }

  Color getBadgeBgColor(String paymentStatus) {
    if (paymentStatus == 'paid') {
      return const Color(0xFFD5E7DA);
    }
    return const Color(0xFFE5E2E1);
  }

  Color getBadgeTextColor(String paymentStatus) {
    if (paymentStatus == 'paid') {
      return const Color(0xFF58685E);
    }
    return const Color(0xFF3F4944);
  }

  @override
  Widget build(BuildContext context) {
    const colorBackground = Color(0xFFFCF9F8);
    const colorSurface = Color(0xFFFCF9F8);
    const colorOnSurface = Color(0xFF1C1B1B);
    const colorOnSurfaceVariant = Color(0xFF3F4944);
    const colorSurfaceContainerLowest = Color(0xFFFFFFFF);
    const colorOutlineVariant = Color(0xFFBFC9C3);
    const colorPrimary = Color(0xFF004E3B);

    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        backgroundColor: colorSurface,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Pesanan Saya',
          style: TextStyle(
            color: colorOnSurface,
            fontFamily: 'Hanken Grotesk',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: colorPrimary,
                ),
              )
            : orders.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada pesanan',
                      style: TextStyle(
                        color: colorOnSurfaceVariant,
                        fontFamily: 'Hanken Grotesk',
                        fontSize: 14,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      
                      final String orderIdRaw = order['id']?.toString() ?? "";
                      final String displayId = orderIdRaw.length > 8 
                          ? orderIdRaw.substring(0, 8) 
                          : orderIdRaw;

                      final String statusText = getStatusText(order);
                      final String paymentStatus = order['payment_status']?.toString() ?? "";

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        decoration: BoxDecoration(
                          color: colorSurfaceContainerLowest,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorOutlineVariant,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OrderDetailPage(
                                  order: order,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Order $displayId',
                                      style: const TextStyle(
                                        color: colorOnSurface,
                                        fontFamily: 'Hanken Grotesk',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
                                      color: colorOnSurfaceVariant,
                                      size: 24,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  statusText,
                                  style: const TextStyle(
                                    color: colorOnSurfaceVariant,
                                    fontFamily: 'Hanken Grotesk',
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Rp ${order['grand_total']}',
                                  style: const TextStyle(
                                    color: colorOnSurface,
                                    fontFamily: 'Hanken Grotesk',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: getBadgeBgColor(paymentStatus),
                                        borderRadius: BorderRadius.circular(9999),
                                      ),
                                      child: Text(
                                        paymentStatus.toUpperCase(),
                                        style: TextStyle(
                                          color: getBadgeTextColor(paymentStatus),
                                          fontFamily: 'Hanken Grotesk',
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Pembayaran : $paymentStatus',
                                      style: const TextStyle(
                                        color: colorOnSurfaceVariant,
                                        fontFamily: 'Hanken Grotesk',
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}