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
  
  // Warna konsisten dengan AdminProductPage
  final Color primaryGreen = const Color(0xFF236652);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F7),
      appBar: AppBar(
        title: const Text(
          "Riwayat Transaksi",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: primaryGreen,
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureOrder,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: primaryGreen));
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return const Center(child: Text("Belum ada transaksi"));
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                futureOrder = service.getAllOrders();
              });
            },
            color: primaryGreen,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final buyer = order["buyer"];
                final List items = order["order_items"] ?? [];

                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Order
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Order ID: ${order["id"]}", 
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Chip(
                              backgroundColor: statusColor(order["payment_status"] ?? ""),
                              label: Text(
                                (order["payment_status"] ?? "").toUpperCase(),
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),

                        // Section Pembeli
                        const Text("PEMBELI", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF236652))),
                        const SizedBox(height: 5),
                        Text("Nama   : ${buyer?["nama"] ?? "-"}"),
                        Text("Email  : ${buyer?["email"] ?? "-"}"),
                        Text("No HP  : ${buyer?["no_hp"] ?? "-"}"),
                        Text("Alamat : ${buyer?["alamat"] ?? "-"}"),

                        const SizedBox(height: 15),

                        // Section Penjual & Produk
                        const Text("DETAIL PESANAN", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF236652))),
                        const SizedBox(height: 5),
                        ...items.map<Widget>((e) {
                          final seller = e["seller"];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("UMKM: ${seller?["nama_umkm"] ?? "-"}", style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text("Produk: ${e["nama_produk"]}"),
                                Text("Qty: ${e["qty"]} | Harga: Rp ${e["harga"]}"),
                                Text("Subtotal: Rp ${e["subtotal"]}", style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          );
                        }),

                        const Divider(),

                        // Footer Harga (Informasi Lengkap Dipertahankan)
                        _buildPriceRow("Total Produk", "Rp ${order["total"]}"),
                        _buildPriceRow("Ongkir", "Rp ${order["total_ongkir"]}"),
                        _buildPriceRow("Admin Fee", "Rp ${order["admin_fee"]}"),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Divider(thickness: 2),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("GRAND TOTAL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text("Rp ${order["grand_total"]}", 
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
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

  Widget _buildPriceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value),
      ],
    );
  }
}