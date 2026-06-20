import 'package:flutter/material.dart';
import '../../../services/order_service.dart';

class SellerOrderDetailPage extends StatefulWidget {
  final Map item;

  const SellerOrderDetailPage({
    super.key,
    required this.item,
  });

  @override
  State<SellerOrderDetailPage> createState() =>
      _SellerOrderDetailPageState();
}

class _SellerOrderDetailPageState
    extends State<SellerOrderDetailPage> {
  final OrderService orderService =
      OrderService();

  bool isLoading = false;

  String getStatus() {
    final order = widget.item["orders"];

    if (order == null) {
      return "-";
    }

    if (order["payment_status"] ==
        "pending") {
      return "Belum Dibayar";
    }

    if (order["payment_status"] ==
            "paid" &&
        order["order_status"] ==
            "processed") {
      return "Siap Dikirim";
    }

    if (order["order_status"] ==
        "shipped") {
      return "Sedang Dikirim";
    }

    if (order["order_status"] ==
        "completed") {
      return "Selesai";
    }

    return "-";
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    final order = item["orders"];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail Pesanan",
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            /// FOTO
            if ((item["image_url"] ??
                    "")
                .toString()
                .isNotEmpty)
              Center(
                child: Image.network(
                  item["image_url"],
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(
              height: 20,
            ),

            /// =======================
            /// PRODUK
            /// =======================

            const Text(
              "Informasi Produk",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const Divider(),

            Text(
              "Nama Produk : ${item["nama_produk"] ?? "-"}",
            ),

            Text(
              "Qty : ${item["qty"] ?? 0}",
            ),

            Text(
              "Harga : Rp ${item["harga"] ?? 0}",
            ),

            Text(
              "Subtotal : Rp ${item["subtotal"] ?? 0}",
            ),

            const SizedBox(
              height: 20,
            ),

            /// =======================
            /// ORDER
            /// =======================

            const Text(
              "Informasi Pesanan",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const Divider(),

            Text(
              "Order ID : ${order?["id"] ?? "-"}",
            ),

            Text(
              "Status : ${getStatus()}",
            ),

            Text(
              "Payment : ${order?["payment_status"] ?? "-"}",
            ),

            Text(
              "Order Status : ${order?["order_status"] ?? "-"}",
            ),

            const SizedBox(
              height: 12,
            ),

            if ((order?["kurir"] ??
                    "")
                .toString()
                .isNotEmpty)
              Text(
                "Kurir : ${order["kurir"]}",
              ),

            if ((order?["nomor_resi"] ??
                    "")
                .toString()
                .isNotEmpty)
              Text(
                "Nomor Resi : ${order["nomor_resi"]}",
              ),

            const SizedBox(
              height: 25,
            ),

            /// =======================
            /// BUTTON KIRIM
            /// =======================

            if (order != null &&
                order["payment_status"] ==
                    "paid" &&
                order["order_status"] ==
                    "processed")
              SizedBox(
                width:
                    double.infinity,

                height: 50,

                child:
                    ElevatedButton(
                  onPressed:
                      isLoading
                          ? null
                          : () async {
                              setState(() {
                                isLoading =
                                    true;
                              });

                              try {
                                await orderService
                                    .shipOrder(
                                  order["id"],
                                );

                                if (!mounted) {
                                  return;
                                }

                                ScaffoldMessenger.of(
                                        context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text(
                                      "Pesanan berhasil dikirim",
                                    ),
                                  ),
                                );

                                Navigator.pop(
                                  context,
                                  true,
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(
                                        context)
                                    .showSnackBar(
                                  SnackBar(
                                    content:
                                        Text(
                                      e.toString(),
                                    ),
                                  ),
                                );
                              }

                              if (mounted) {
                                setState(() {
                                  isLoading =
                                      false;
                                });
                              }
                            },

                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          "Kirim Barang",
                        ),
                ),
              ),

            if (order != null &&
                order["order_status"] ==
                    "shipped")
              Container(
                width:
                    double.infinity,
                padding:
                    const EdgeInsets.all(
                  12,
                ),
                decoration:
                    BoxDecoration(
                  color: Colors.green
                      .shade100,
                  borderRadius:
                      BorderRadius.circular(
                    10,
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Pesanan sedang dikirim",
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),

            if (order != null &&
                order["order_status"] ==
                    "completed")
              Container(
                width:
                    double.infinity,
                padding:
                    const EdgeInsets.all(
                  12,
                ),
                decoration:
                    BoxDecoration(
                  color: Colors.blue
                      .shade100,
                  borderRadius:
                      BorderRadius.circular(
                    10,
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Pesanan telah selesai",
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}