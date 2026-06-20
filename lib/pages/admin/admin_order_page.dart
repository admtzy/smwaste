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
              itemBuilder: (context, index) {
                final order = orders[index];

                final buyer = order["buyer"];

                final List items = order["order_items"] ?? [];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "PEMBELI",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        textIfNotNull("Nama : ", buyer?["nama"]),
                        textIfNotNull("Email : ", buyer?["email"]),
                        textIfNotNull("No HP : ", buyer?["no_hp"]),
                        textIfNotNull("Alamat : ", buyer?["alamat"]),

                        const Divider(),

                        Text("Order ID : ${order["id"]}"),
                        Text("Grand Total : Rp ${order["grand_total"]}"),
                        Text("Total Produk : Rp ${order["total"]}"),
                        Text("Ongkir : Rp ${order["total_ongkir"]}"),
                        Text("Admin Fee : Rp ${order["admin_fee"]}"),

                        const SizedBox(height: 15),

                        const Text(
                          "PENJUAL",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        ...items.map<Widget>((e) {
                          final seller = e["seller"];

                          return Card(
                            margin:
                                const EdgeInsets.symmetric(vertical: 5),
                            color: Colors.grey.shade100,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  // Text(
                                  //   "DEBUG : ${seller.toString()}",
                                  // ),

                                  textIfNotNull(
                                    "Nama : ",
                                    seller?["nama"],
                                  ),

                                  textIfNotNull(
                                    "Email : ",
                                    seller?["email"],
                                  ),

                                  textIfNotNull(
                                    "No HP : ",
                                    seller?["no_hp"],
                                  ),

                                  textIfNotNull(
                                    "Alamat : ",
                                    seller?["alamat"],
                                  ),

                                  textIfNotNull(
                                    "Nama UMKM : ",
                                    seller?["nama_umkm"],
                                  ),

                                  textIfNotNull(
                                    "Kategori : ",
                                    seller?["kategori_umkm"],
                                  ),

                                  const Divider(),

                                  textIfNotNull(
                                    "Produk : ",
                                    e["nama_produk"],
                                  ),

                                  textIfNotNull(
                                    "Qty : ",
                                    e["qty"],
                                  ),

                                  textIfNotNull(
                                    "Harga : Rp ",
                                    e["harga"],
                                  ),

                                  textIfNotNull(
                                    "Subtotal : Rp ",
                                    e["subtotal"],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Chip(
                            backgroundColor: statusColor(
                              order["payment_status"] ?? "",
                            ),
                            label: Text(
                              order["payment_status"] ?? "",
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
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