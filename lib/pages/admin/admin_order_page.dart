import 'package:flutter/material.dart';

import '../../services/admin_order_service.dart';

class AdminOrderPage extends StatefulWidget {
  const AdminOrderPage({super.key});

  @override
  State<AdminOrderPage> createState() => _AdminOrderPageState();
}

class _AdminOrderPageState extends State<AdminOrderPage> {
  final service = AdminOrderService();

  late Future<List<dynamic>> futureOrder;

  @override
  void initState() {
    super.initState();
    futureOrder = service.getAllOrders();
  }

  Color statusColor(String status) {
    switch (status) {
      case "paid":
        return Colors.green;
      case "pending":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget textIfNotNull(String title, dynamic value) {
    if (value == null) {
      return const SizedBox();
    }

    if (value.toString().isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Text("$title$value"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Transaksi"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureOrder,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return const Center(
              child: Text("Belum ada transaksi"),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                futureOrder = service.getAllOrders();
              });
            },
            child: ListView.builder(
              itemCount: orders.length,
              // Di bagian _AdminOrderPageState, perbarui bagian itemBuilder:

              itemBuilder: (context, index) {
                final order = orders[index];
                final buyer = order["buyer"];
                final List items = order["order_items"] ?? [];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.black.withOpacity(0.1)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header: Order ID & Status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("ORDER ID", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                                Text("#${order["id"].toString().substring(0, 8)}", style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Chip(
                              backgroundColor: statusColor(order["payment_status"] ?? "").withOpacity(0.2),
                              label: Text(
                                (order["payment_status"] ?? "").toUpperCase(),
                                style: TextStyle(color: statusColor(order["payment_status"] ?? ""), fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        
                        // Buyer Info
                        const Text("PEMBELI", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                        Text(buyer?["nama"] ?? "-", style: const TextStyle(fontWeight: FontWeight.w500)),
                        Text(buyer?["no_hp"] ?? "-", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        Text(buyer?["alamat"] ?? "-", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        
                        const SizedBox(height: 12),
                        
                        // Seller Info
                        const Text("PENJUAL (UMKM)", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                        ...items.map((e) => Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(e["seller"]?["nama_umkm"] ?? "-", style: const TextStyle(fontWeight: FontWeight.w500)),
                        )).toList(),

                        const Divider(),

                        // Product Summary
                        const Text("RINGKASAN PRODUK", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                        ...items.map((e) => Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e["nama_produk"] ?? ""),
                              Text("x ${e["qty"]}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        )).toList(),

                        const SizedBox(height: 12),

                        // Total
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total Harga", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("Rp ${order["grand_total"]}", style: const TextStyle(color: Color(0xFF004E3B), fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}