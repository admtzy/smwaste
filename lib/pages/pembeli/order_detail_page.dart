import 'package:flutter/material.dart';
import '../../services/order_service.dart';

class OrderDetailPage extends StatefulWidget {
  final Map order;

  const OrderDetailPage({
    super.key,
    required this.order,
  });

  @override
  State<OrderDetailPage> createState() =>
      _OrderDetailPageState();
}

class _OrderDetailPageState
    extends State<OrderDetailPage> {
  final OrderService orderService =
      OrderService();

  List items = [];

  bool loading = false;

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {
    final result =
        await orderService.getOrderItems(
      widget.order["id"],
    );

    if (!mounted) return;

    setState(() {
      items = result;
    });
  }

  String getStatus() {
    final order = widget.order;

    if (order["payment_status"] ==
        "pending") {
      return "Menunggu Pembayaran";
    }

    if (order["payment_status"] ==
            "paid" &&
        order["order_status"] ==
            "processed") {
      return "Sedang Diproses Penjual";
    }

    if (order["order_status"] ==
        "shipped") {
      return "Sedang Dikirim";
    }

    if (order["order_status"] ==
        "completed") {
      return "Pesanan Selesai";
    }

    return "-";
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final order = widget.order;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail Pesanan",
        ),
      ),

      body: Column(
        children: [

          /// ========================
          /// STATUS ORDER
          /// ========================

          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  "Status : ${getStatus()}",
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                Text(
                  "Payment : ${order["payment_status"] ?? "-"}",
                ),

                Text(
                  "Order Status : ${order["order_status"] ?? "-"}",
                ),

                if ((order["kurir"] ?? "")
                    .toString()
                    .isNotEmpty)
                  Text(
                    "Kurir : ${order["kurir"]}",
                  ),

                if ((order["nomor_resi"] ??
                        "")
                    .toString()
                    .isNotEmpty)
                  Text(
                    "Resi : ${order["nomor_resi"]}",
                  ),

                const Divider(),
              ],
            ),
          ),

          /// ========================
          /// LIST PRODUK
          /// ========================

          Expanded(
            child: ListView.builder(
              itemCount:
                  items.length,

              itemBuilder:
                  (context, index) {
                final item =
                    items[index];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),

                  child: ListTile(

                    leading:
                        item["products"]?[
                                    "image_url"] !=
                                null
                            ? Image.network(
                                item["products"]
                                    [
                                    "image_url"],
                                width: 60,
                                fit: BoxFit.cover,
                              )
                            : null,

                    title: Text(
                      item["products"]?[
                              "nama_produk"] ??
                          "-",
                    ),

                    subtitle: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [

                        Text(
                          "Qty : ${item["qty"] ?? 0}",
                        ),

                        Text(
                          "Harga : Rp ${item["harga"] ?? 0}",
                        ),

                        Text(
                          "Subtotal : Rp ${item["subtotal"] ?? 0}",
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          /// ========================
          /// BUTTON BARANG DITERIMA
          /// ========================

          if (order["payment_status"] ==
                  "paid" &&
              order["order_status"] ==
                  "shipped")
            Padding(
              padding:
                  const EdgeInsets.all(
                16,
              ),

              child: SizedBox(
                width:
                    double.infinity,

                height: 50,

                child:
                    ElevatedButton(
                  onPressed:
                      loading
                          ? null
                          : () async {
                              setState(() {
                                loading =
                                    true;
                              });

                              try {
                                await orderService
                                    .confirmReceived(
                                  order["id"],
                                );

                                if (!mounted)
                                  return;

                                ScaffoldMessenger.of(
                                        context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text(
                                      "Pesanan telah selesai",
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
                                  loading =
                                      false;
                                });
                              }
                            },

                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text(
                          "Barang Diterima",
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}