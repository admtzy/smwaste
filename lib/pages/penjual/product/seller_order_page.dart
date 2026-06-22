import 'package:flutter/material.dart';
import 'package:smwaste/pages/penjual/product/seller_order_detail_page.dart';
import '../../../services/order_service.dart';

class SellerOrderPage extends StatefulWidget {
  const SellerOrderPage({
    super.key,
  });

  @override
  State<SellerOrderPage> createState() => _SellerOrderPageState();
}

class _SellerOrderPageState extends State<SellerOrderPage> {
  final orderService = OrderService();
  List orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      final data = await orderService.getSellerOrders();
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

  String getStatus(Map item) {
    final order = item['orders'];

    if (order == null) {
      return '-';
    }

    if (order['payment_status'] == 'pending') {
      return 'Belum Dibayar';
    }

    if (order['payment_status'] == 'paid' &&
        order['order_status'] == 'processed') {
      return 'Siap Dikirim';
    }

    if (order['order_status'] == 'shipped') {
      return 'Dalam Pengiriman';
    }

    if (order['order_status'] == 'completed') {
      return 'Selesai';
    }

    return '-';
  }

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
          'Pesanan Masuk',
          style: TextStyle(
            fontFamily: 'Hanken Grotesk',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: colorPrimary),
            )
          : orders.isEmpty
              ? const Center(
                  child: Text(
                    'Belum ada pesanan',
                    style: TextStyle(
                      fontFamily: 'Hanken Grotesk',
                      color: colorOnSurfaceVariant,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final item = orders[index];
                    final String statusText = getStatus(item);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: colorSurfaceContainerLowest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black.withOpacity(0.1)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SellerOrderDetailPage(
                                item: item,
                              ),
                            ),
                          );
                          loadOrders();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item['nama_produk'] ?? '-',
                                      style: const TextStyle(
                                        fontFamily: 'Hanken Grotesk',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: colorOnSurface,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: colorOnSurfaceVariant,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Divider(color: colorOutlineVariant.withOpacity(0.3)),
                              const SizedBox(height: 6),

                              _buildCardRow('Qty', '${item['qty']}', colorOnSurface, colorOnSurfaceVariant),
                              _buildCardRow('Harga', 'Rp ${item['harga']}', colorOnSurface, colorOnSurfaceVariant),
                              
                              const SizedBox(height: 6),
                              
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final dashCount = (constraints.constrainWidth() / 8).floor();
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: List.generate(dashCount, (_) {
                                      return SizedBox(
                                        width: 4,
                                        height: 1,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(color: colorOutlineVariant.withOpacity(0.4)),
                                        ),
                                      );
                                    }),
                                  );
                                },
                              ),
                              const SizedBox(height: 8),

                              _buildCardRow('Subtotal', 'Rp ${item['subtotal']}', colorPrimary, colorOnSurface, isBoldValue: true),
                              
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Status Pesanan',
                                    style: TextStyle(
                                      fontFamily: 'Hanken Grotesk',
                                      fontSize: 12,
                                      color: colorOnSurfaceVariant.withOpacity(0.8),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildCardRow(String label, String value, Color valueColor, Color labelColor, {bool isBoldValue = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Hanken Grotesk',
              color: labelColor,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Hanken Grotesk',
              color: valueColor,
              fontWeight: isBoldValue ? FontWeight.bold : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}