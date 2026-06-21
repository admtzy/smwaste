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

    // Defenisi Palet Warna Berdasarkan HTML Tailwind SMARTWASTE
    const colorBackground = Color(0xFFFCF9F8); // bg-background
    const colorSurface = Color(0xFFFCF9F8); // bg-surface
    const colorOnSurface = Color(0xFF1C1B1B); // text-on-surface
    const colorOnSurfaceVariant = Color(0xFF3F4944); // text-on-surface-variant
    const colorSurfaceContainerLowest = Color(0xFFFFFFFF); // bg-surface-container-lowest
    const colorOutlineVariant = Color(0xFFBFC9C3); // border-outline-variant
    const colorPrimary = Color(0xFF004E3B); // text-primary / button primary
    const colorOnPrimary = Color(0xFFFFFFFF); // text-on-primary

    return Scaffold(
      backgroundColor: colorBackground,
      // Top App Bar sesuai rancangan <header class="bg-surface">
      appBar: AppBar(
        backgroundColor: colorSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: colorOnSurface),
          // PERBAIKAN: Menggunakan maybePop agar lebih aman bagi tumpukan navigasi
          onPressed: () => Navigator.maybePop(context),
        ),
        titleSpacing: 0,
        title: const Text(
          "Detail Pesanan",
          style: TextStyle(
            color: colorOnSurface,
            fontFamily: 'Hanken Grotesk',
            fontSize: 20, // text-headline-md
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24.0), // px-lg py-md
                children: [
                  /// ========================
                  /// STATUS ORDER (Section)
                  /// ========================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(bottom:16.0), // pb-md
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: colorOutlineVariant.withOpacity(0.3), // border-outline-variant/30
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
                            fontSize: 16, // text-title-sm
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8), // gap-sm
                        Text(
                          "Payment : ${order["payment_status"] ?? "-"}",
                          style: const TextStyle(
                            color: colorOnSurfaceVariant,
                            fontFamily: 'Hanken Grotesk',
                            fontSize: 14, // text-body-medium
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4), // gap-xs
                        Text(
                          "Order Status : ${order["order_status"] ?? "-"}",
                          style: const TextStyle(
                            color: colorOnSurfaceVariant,
                            fontFamily: 'Hanken Grotesk',
                            fontSize: 14, // text-body-medium
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
                  const SizedBox(height: 35), // gap-xxl dari template

                  /// ========================
                  /// LIST PRODUK (Section)
                  /// ========================
                  ...items.map((item) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      padding: const EdgeInsets.all(16.0), // p-md
                      decoration: BoxDecoration(
                        color: colorSurfaceContainerLowest,
                        borderRadius: BorderRadius.circular(12), // rounded-xl
                        border: Border.all(
                          color: colorOnSurface.withOpacity(0.1), // border-black/10
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05), // shadow-sm
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Gambar Produk Kiri
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6F3F2), // bg-surface-container-low
                              borderRadius: BorderRadius.circular(8), // rounded-lg
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: item["products"]?["image_url"] != null
                                ? Image.network(
                                    item["products"]["image_url"],
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.image, color: colorOutlineVariant),
                          ),
                          const SizedBox(width: 16), // gap-md

                          // Rincian Teks Kanan
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item["products"]?["nama_produk"] ?? "-",
                                  style: const TextStyle(
                                    color: colorOnSurface,
                                    fontFamily: 'Hanken Grotesk',
                                    fontSize: 14, // text-body-medium
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4), // gap-xs
                                Text(
                                  "Qty : ${item["qty"] ?? 0}",
                                  style: const TextStyle(
                                    color: colorOnSurfaceVariant,
                                    fontFamily: 'Hanken Grotesk',
                                    fontSize: 12, // text-body-sm
                                  ),
                                ),
                                Text(
                                  "Harga : Rp ${item["harga"] ?? 0}",
                                  style: const TextStyle(
                                    color: colorOnSurfaceVariant,
                                    fontFamily: 'Hanken Grotesk',
                                    fontSize: 12, // text-body-sm
                                  ),
                                ),
                                const SizedBox(height: 4), // mt-xs
                                Text(
                                  "Subtotal : Rp ${item["subtotal"] ?? 0}",
                                  style: const TextStyle(
                                    color: colorPrimary, // text-primary
                                    fontFamily: 'Hanken Grotesk',
                                    fontSize: 16, // text-title-sm
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

            /// ========================
            /// BUTTON BARANG DITERIMA
            /// ========================
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
                        borderRadius: BorderRadius.circular(8), // rounded-lg
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

                            // PERBAIKAN: Melindungi setState di dalam blok catch/akhir fungsi async
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

            /// ========================
            /// BUTTON REVIEW
            /// ========================
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
                        borderRadius: BorderRadius.circular(8), // rounded-lg
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