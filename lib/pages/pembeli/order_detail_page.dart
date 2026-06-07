import 'package:flutter/material.dart';

import '../../services/order_service.dart';

class OrderDetailPage
    extends StatefulWidget {

  final Map order;

  const OrderDetailPage({

    super.key,

    required this.order,

  });

  @override
  State<OrderDetailPage>
      createState() =>
          _OrderDetailPageState();
}

class _OrderDetailPageState
    extends State<OrderDetailPage> {

  final orderService =
      OrderService();

  List items = [];

  @override
  void initState() {
    super.initState();

    loadItems();
  }

  Future<void>
      loadItems() async {

    final result =
        await orderService
            .getOrderItems(
      widget.order['id'],
    );

    setState(() {
      items = result;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(

      appBar: AppBar(
        title:
            const Text(
          'Detail Pesanan',
        ),
      ),

      body: Column(

        children: [

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Text(
                  'Status : ${widget.order['order_status']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  'Pembayaran : ${widget.order['payment_status']}',
                ),

                const Divider(),
              ],
            ),
          ),

          Expanded(

            child:
                ListView.builder(

              itemCount:
                  items.length,

              itemBuilder:
                  (context,index){

                final item =
                    items[index];

                return ListTile(

                  title: Text(
                    item['products']?['nama_produk']
                            ?.toString() ??
                        'Produk',
                  ),

                  subtitle: Text(
                    'Qty ${item['qty']}',
                  ),

                  trailing: Text(
                    'Rp ${item['subtotal']}',
                  ),

                );
              },
            ),
          ),

          if(widget.order[
                  'order_status']
              ==
              'shipped')

            Padding(

              padding:
                  const EdgeInsets.all(
                16,
              ),

              child:
                  SizedBox(

                width:
                    double.infinity,

                child:
                    ElevatedButton(

                  onPressed:
                      () async {

                    await orderService
                        .confirmReceived(
                      widget.order[
                          'id'],
                    );

                    if(!mounted) return;

                    Navigator.pop(
                      context,
                    );

                  },

                  child:
                      const Text(
                    'Barang Diterima',
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}