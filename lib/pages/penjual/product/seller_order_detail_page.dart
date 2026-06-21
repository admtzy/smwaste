import 'package:flutter/material.dart';
import '../../../services/order_service.dart';

class SellerOrderDetailPage extends StatefulWidget {
  final Map item;

  const SellerOrderDetailPage({
    super.key,
    required this.item,
  });

  @override
  State<SellerOrderDetailPage> createState() => _SellerOrderDetailPageState();
}

class _SellerOrderDetailPageState extends State<SellerOrderDetailPage> {
  final OrderService orderService = OrderService();
  bool isLoading = false;

  String getStatus() {
    final order = widget.item["orders"];

    if (order == null) {
      return "-";
    }

    if (order["payment_status"] == "pending") {
      return "Belum Dibayar";
    }

    if (order["payment_status"] == "paid" && order["order_status"] == "processed") {
      return "Siap Dikirim";
    }

    if (order["order_status"] == "shipped") {
      return "Sedang Dikirim";
    }

    if (order["order_status"] == "completed") {
      return "Selesai";
    }

    return "-";
  }

  // Helper Warna Badge Status (Konsisten dengan halaman list)
  Color _getBadgeColor(String status) {
    switch (status) {
      case 'Selesai':
        return const Color(0xFF004E3B).withOpacity(0.15);
      case 'Belum Dibayar':
        return const Color(0xFFBA1A1A).withOpacity(0.1);
      case 'Siap Dikirim':
        return const Color(0xFF236652).withOpacity(0.1);
      default:
        return const Color(0xFF526258).withOpacity(0.1);
    }
  }

  Color _getBadgeTextColor(String status) {
    switch (status) {
      case 'Selesai':
        return const Color(0xFF004E3B);
      case 'Belum Dibayar':
        return const Color(0xFFBA1A1A);
      case 'Siap Dikirim':
        return const Color(0xFF236652);
      default:
        return const Color(0xFF526258);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final order = item["orders"];
    final String statusText = getStatus();

    // ==========================================
    // PALET WARNA (Konsisten dengan List)
    // ==========================================
    const Color colorPrimary = Color(0xFF004E3B);
    const Color colorBackground = Color(0xFFFCF9F8);
    const Color colorSurfaceContainerLowest = Color(0xFFFFFFFF);
    const Color colorOnSurface = Color(0xFF1C1B1B);
    const Color colorOnSurfaceVariant = Color(0xFF3F4944);
    const Color colorOutlineVariant = Color(0xFFBFC9C3);

    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: colorOnSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: Border(
          bottom: BorderSide(
            color: colorOutlineVariant.withOpacity(0.3),
            width: 1,
          ),
        ),
        title: const Text(
          "Detail Pesanan",
          style: TextStyle(
            fontFamily: 'Hanken Grotesk',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// FOTO PRODUK
            if ((item["image_url"] ?? "").toString().isNotEmpty) ...[
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      item["image_url"],
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            /// =======================
            /// KARTU INFORMASI PRODUK
            /// =======================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorSurfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black.withOpacity(0.06)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.shopping_bag_outlined, color: colorPrimary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "Informasi Produk",
                        style: TextStyle(
                          fontFamily: 'Hanken Grotesk',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorOnSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Divider(color: colorOutlineVariant.withOpacity(0.3)),
                  const SizedBox(height: 8),
                  _buildDetailRow("Nama Produk", item["nama_produk"] ?? "-", colorOnSurface, colorOnSurfaceVariant),
                  _buildDetailRow("Qty", "${item["qty"] ?? 0}", colorOnSurface, colorOnSurfaceVariant),
                  _buildDetailRow("Harga", "Rp ${item["harga"] ?? 0}", colorOnSurface, colorOnSurfaceVariant),
                  _buildDetailRow("Subtotal", "Rp ${item["subtotal"] ?? 0}", colorPrimary, colorOnSurface, isBoldValue: true),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// =======================
            /// KARTU INFORMASI PESANAN
            /// =======================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorSurfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black.withOpacity(0.06)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.receipt_long_outlined, color: colorPrimary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "Informasi Pesanan",
                        style: TextStyle(
                          fontFamily: 'Hanken Grotesk',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorOnSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Divider(color: colorOutlineVariant.withOpacity(0.3)),
                  const SizedBox(height: 8),
                  _buildDetailRow("Order ID", "${order?["id"] ?? "-"}", colorOnSurface, colorOnSurfaceVariant),
                  
                  // Row khusus Status dengan Badge indah
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Status",
                          style: TextStyle(fontFamily: 'Hanken Grotesk', color: colorOnSurfaceVariant, fontSize: 14),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getBadgeColor(statusText),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            statusText,
                            style: TextStyle(
                              fontFamily: 'Hanken Grotesk',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _getBadgeTextColor(statusText),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  _buildDetailRow("Payment Status", "${order?["payment_status"] ?? "-"}", colorOnSurface, colorOnSurfaceVariant),
                  _buildDetailRow("Order Status", "${order?["order_status"] ?? "-"}", colorOnSurface, colorOnSurfaceVariant),
                  
                  if ((order?["kurir"] ?? "").toString().isNotEmpty)
                    _buildDetailRow("Kurir", "${order["kurir"]}", colorOnSurface, colorOnSurfaceVariant),
                  
                  if ((order?["nomor_resi"] ?? "").toString().isNotEmpty)
                    _buildDetailRow("Nomor Resi", "${order["nomor_resi"]}", colorOnSurface, colorOnSurfaceVariant),
                ],
              ),
            ),

            const SizedBox(height: 32),

            /// =======================
            /// ACTION BUTTON / WIDGET STATUS BANNER
            /// =======================

            // 1. Kondisi Tombol Kirim Barang
            if (order != null && order["payment_status"] == "paid" && order["order_status"] == "processed")
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                          });

                          try {
                            await orderService.shipOrder(order["id"]);

                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Pesanan berhasil dikirim")),
                            );

                            Navigator.pop(context, true);
                          } catch (e) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }

                          if (mounted) {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          "Kirim Barang",
                          style: TextStyle(fontFamily: 'Hanken Grotesk', fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),

            // 2. Banner Status Sedang Dikirim
            if (order != null && order["order_status"] == "shipped")
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF236652).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF236652).withOpacity(0.2)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_shipping_outlined, color: Color(0xFF236652), size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Pesanan sedang dikirim",
                      style: TextStyle(
                        fontFamily: 'Hanken Grotesk',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF236652),
                      ),
                    ),
                  ],
                ),
              ),

            // 3. Banner Status Selesai
            if (order != null && order["order_status"] == "completed")
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF004E3B).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF004E3B).withOpacity(0.2)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline, color: Color(0xFF004E3B), size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Pesanan telah selesai",
                      style: TextStyle(
                        fontFamily: 'Hanken Grotesk',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004E3B),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Komponen pembangun Baris Detail Rata Kanan-Kiri yang bersih
  Widget _buildDetailRow(String label, String value, Color valueColor, Color labelColor, {bool isBoldValue = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.between,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Hanken Grotesk',
              color: labelColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontFamily: 'Hanken Grotesk',
                color: valueColor,
                fontWeight: isBoldValue ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}