import 'package:flutter/material.dart';

import '../../services/order_service.dart';
import 'order_detail_page.dart';

// 1. Buat RouteObserver global di file main.dart Anda jika belum ada:
// final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({
    super.key,
  });

  @override
  State<MyOrderPage> createState() => _MyOrdersPageState();
}

// Tambahkan RouteAware pada State kelas Anda
class _MyOrdersPageState extends State<MyOrderPage> with RouteAware {
  final orderService = OrderService();
  List orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Daftarkan halaman ini ke routeObserver global
    // routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute<void>);
  }

  @override
  void dispose() {
    // Batalkan pendaftaran saat widget dihancurkan
    // routeObserver.unsubscribe(this);
    super.dispose();
  }

  // Fungsi ini otomatis berjalan saat halaman di atasnya di-pop (pengguna kembali ke halaman ini)
  @override
  void didPopNext() {
    loadOrders(); // Muat ulang otomatis data pesanan baru
  }

  Future<void> loadOrders() async {
    try {
      // Memastikan indikator loading muncul jika data kosong
      if (orders.isEmpty) {
        setState(() {
          isLoading = true;
        });
      }

      final data = await orderService.getMyOrders();

      if (!mounted) return;

      setState(() {
        orders = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  String getStatus(Map order) {
    if (order['payment_status'] == 'pending') {
      return 'Menunggu Pembayaran';
    }

    if (order['payment_status'] == 'paid' &&
        order['order_status'] == 'pending') {
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

  Color getStatusColor(String status) {
    switch (status) {
      case 'Pesanan Selesai':
        return const Color(0xFF006A1B);
      case 'Sedang Dikirim':
        return const Color(0xFF276955);
      case 'Menunggu Pengiriman':
        return const Color(0xFF526258);
      case 'Menunggu Pembayaran':
        return const Color(0xFFBA1A1A);
      default:
        return const Color(0xFF3F4944);
    }
  }

  @override
  Widget build(BuildContext context) {
    const colorPrimary = Color(0xFF004E3B);
    const colorOnPrimary = Color(0xFFFFFFFF);
    const colorBackground = Color(0xFFFCF9F8);
    const colorOnBackground = Color(0xFF1C1B1B);
    const colorSurfaceLowest = Color(0xFFFFFFFF);
    const colorOnSurface = Color(0xFF1C1B1B);
    const colorOnSurfaceVariant = Color(0xFF3F4944);

    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        backgroundColor: colorPrimary,
        elevation: 0,
        // Baris ini yang menghilangkan tombol back secara otomatis
        automaticallyImplyLeading: false, 
        title: const Text(
          "SMARTWASTE",
          style: TextStyle(
            color: colorOnPrimary,
            fontFamily: 'Hanken Grotesk',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0, bottom: 8.0),
              child: Text(
                "Pesanan Saya",
                style: TextStyle(
                  color: colorOnBackground,
                  fontFamily: 'Hanken Grotesk',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: colorPrimary,
                      ),
                    )
                  : orders.isEmpty
                      ? Center(
                          child: Text(
                            'Belum ada pesanan',
                            style: TextStyle(
                              color: colorOnSurfaceVariant,
                              fontFamily: 'Hanken Grotesk',
                              fontSize: 14,
                            ),
                          ),
                        )
                      : RefreshIndicator(
                          color: colorPrimary,
                          onRefresh: loadOrders,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            itemCount: orders.length,
                            itemBuilder: (context, index) {
                              final order = orders[index];
                              final String statusText = getStatus(order);
                              final Color statusColor = getStatusColor(statusText);
                              
                              final String orderIdRaw = order['id']?.toString() ?? "";
                              final String displayId = orderIdRaw.length > 8 
                                  ? orderIdRaw.substring(0, 8) 
                                  : orderIdRaw;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 16.0),
                                decoration: BoxDecoration(
                                  color: colorSurfaceLowest,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: colorOnBackground.withOpacity(0.1),
                                  ),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () async {
                                    // Eksekusi perpindahan halaman secara asinkronus
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => OrderDetailPage(
                                          order: order,
                                        ),
                                      ),
                                    );
                                    // Ketika kembali dari detail page, langsung panggil ulang data
                                    if (mounted) {
                                      loadOrders();
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Order #$displayId',
                                                style: const TextStyle(
                                                  color: colorOnSurface,
                                                  fontFamily: 'Hanken Grotesk',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Rp ${order['grand_total']}',
                                                style: const TextStyle(
                                                  color: colorPrimary,
                                                  fontFamily: 'Hanken Grotesk',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Pembayaran: ${order['payment_status']}',
                                                style: const TextStyle(
                                                  color: colorOnSurfaceVariant,
                                                  fontFamily: 'Hanken Grotesk',
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: statusColor.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  statusText,
                                                  style: TextStyle(
                                                    color: statusColor,
                                                    fontFamily: 'Hanken Grotesk',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 14,
                                          color: colorOnSurfaceVariant,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}