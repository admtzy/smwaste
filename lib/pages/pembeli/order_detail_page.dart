import 'package:flutter/material.dart';
import '../../services/order_service.dart';

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
  final orderService = OrderService();

  List items = [];

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {
    final result =
        await orderService.getOrderItems(widget.order['id']);

    setState(() {
      items = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
      ),
      body: Column(
        children: [

          /// =========================
          /// INFO ORDER
          /// =========================
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status : ${order['order_status']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text('Pembayaran : ${order['payment_status']}'),
                const Divider(),
              ],
            ),
          ),

          /// =========================
          /// LIST ITEMS
          /// =========================
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                return ListTile(
                  title: Text(
                    item['products']?['nama_produk']?.toString() ??
                        'Produk',
                  ),
                  subtitle: Text('Qty ${item['qty']}'),
                  trailing: Text('Rp ${item['subtotal']}'),
                );
              },
            ),
          ),

          /// =========================
          /// BUTTON DITERIMA
          /// =========================
          if (order['order_status'] == 'shipped')
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await orderService.confirmReceived(order['id']);

                    if (!mounted) return;

                    Navigator.pop(context, true);
                  },
                  child: const Text('Barang Diterima'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}