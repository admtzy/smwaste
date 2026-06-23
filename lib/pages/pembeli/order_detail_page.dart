import 'package:flutter/material.dart';
import '../../services/order_service.dart';
import 'rivew_page.dart';
import '../../services/review_service.dart';

class OrderDetailPage extends StatefulWidget {
  final Map order;

  const OrderDetailPage({
    super.key,
    required this.order,
  });

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final OrderService orderService = OrderService();
  final ReviewService reviewService = ReviewService();

  bool sudahReview = false;
  List items = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loadItems();
    cekReview();
  }

  Future<void> loadItems() async {
    final result = await orderService.getOrderItems(
      widget.order["id"],
    );

    if (!mounted) return;

    setState(() {
      items = result;
    });
  }

  Future<void> cekReview() async {
    try {
      final result = await reviewService.sudahReview(
        widget.order["id"],
      );

      if (!mounted) return;

      setState(() {
        sudahReview = result;
      });
    } catch (_) {}
  }

  String getStatus() {
    final order = widget.order;

    if (order["payment_status"] == "pending") {
      return "Menunggu Pembayaran";
    }

    if (order["payment_status"] == "paid" &&
        order["order_status"] == "processed") {
      return "Sedang Diproses Penjual";
    }

    if (order["order_status"] == "shipped") {
      return "Sedang Dikirim";
    }

    if (order["order_status"] == "completed") {
      return "Pesanan Selesai";
    }

    return "-";
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    const colorBackground = Color(0xFFFCF9F8);
    const colorSurface = Color(0xFFFCF9F8);
    const colorOnSurface = Color(0xFF1C1B1B);
    const colorOnSurfaceVariant = Color(0xFF3F4944);
    const colorSurfaceContainerLowest = Color(0xFFFFFFFF);
    const colorOutlineVariant = Color(0xFFBFC9C3);
    const colorPrimary = Color(0xFF004E3B);
    const colorOnPrimary = Color(0xFFFFFFFF);

    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        backgroundColor: colorSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: colorOnSurface),
          onPressed: () => Navigator.maybePop(context),
        ),
        titleSpacing: 0,
        title: const Text(
          "Detail Pesanan",
          style: TextStyle(
            color: colorOnSurface,
            fontFamily: 'Hanken Grotesk',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24.0),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(bottom:16.0), 
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: colorOutlineVariant.withOpacity(0.3), 
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Status : ${getStatus()}",
                          style: const TextStyle(
                            color: colorOnSurface,
                            fontFamily: 'Hanken Grotesk',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Payment : ${order["payment_status"] ?? "-"}",
                          style: const TextStyle(
                            color: colorOnSurfaceVariant,
                            fontFamily: 'Hanken Grotesk',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Order Status : ${order["order_status"] ?? "-"}",
                          style: const TextStyle(
                            color: colorOnSurfaceVariant,
                            fontFamily: 'Hanken Grotesk',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if ((order["kurir"] ?? "").toString().isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            "Kurir : ${order["kurir"]}",
                            style: const TextStyle(
                              color: colorOnSurfaceVariant,
                              fontFamily: 'Hanken Grotesk',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                        if ((order["nomor_resi"] ?? "").toString().isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            "Resi : ${order["nomor_resi"]}",
                            style: const TextStyle(
                              color: colorOnSurfaceVariant,
                              fontFamily: 'Hanken Grotesk',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),
                  ...items.map((item) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: colorSurfaceContainerLowest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorOnSurface.withOpacity(0.1),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6F3F2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: item["products"]?["image_url"] != null
                                ? Image.network(
                                    item["products"]["image_url"],
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.image, color: colorOutlineVariant),
                          ),
                          const SizedBox(width: 16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item["products"]?["nama_produk"] ?? "-",
                                  style: const TextStyle(
                                    color: colorOnSurface,
                                    fontFamily: 'Hanken Grotesk',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Qty : ${item["qty"] ?? 0}",
                                  style: const TextStyle(
                                    color: colorOnSurfaceVariant,
                                    fontFamily: 'Hanken Grotesk',
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  "Harga : Rp ${item["harga"] ?? 0}",
                                  style: const TextStyle(
                                    color: colorOnSurfaceVariant,
                                    fontFamily: 'Hanken Grotesk',
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Subtotal : Rp ${item["subtotal"] ?? 0}",
                                  style: const TextStyle(
                                    color: colorPrimary,
                                    fontFamily: 'Hanken Grotesk',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),

            if (order["payment_status"] == "paid" && order["order_status"] == "shipped")
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrimary,
                      foregroundColor: colorOnPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: loading
                        ? null
                        : () async {
                            setState(() {
                              loading = true;
                            });

                            try {
                              await orderService.confirmReceived(
                                order["id"],
                              );

                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Pesanan telah selesai",
                                  ),
                                ),
                              );

                              Navigator.pop(
                                context,
                                true,
                              );
                            } catch (e) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    e.toString(),
                                  ),
                                ),
                              );
                            }

                            if (mounted) {
                              setState(() {
                                loading = false;
                              });
                            }
                          },
                    child: loading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: colorOnPrimary,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            "Barang Diterima",
                            style: TextStyle(
                              fontFamily: 'Hanken Grotesk',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                  ),
                ),
              ),

            if (order["order_status"] == "completed" && !sudahReview && items.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrimary,
                      foregroundColor: colorOnPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReviewPage(
                            productId: items.first["product_id"],
                            orderId: order["id"],
                          ),
                        ),
                      );

                      if (result == true) {
                        cekReview();
                      }
                    },
                    child: const Text(
                      "Beri Penilaian",
                      style: TextStyle(
                        fontFamily: 'Hanken Grotesk',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
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