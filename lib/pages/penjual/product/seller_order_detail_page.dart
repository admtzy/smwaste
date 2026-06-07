import 'package:flutter/material.dart';

import '../../../services/order_service.dart';

class SellerOrderDetailPage
    extends StatefulWidget {

  final Map item;

  const SellerOrderDetailPage({
    super.key,
    required this.item,
  });

  @override
  State<SellerOrderDetailPage>
      createState() =>
          _SellerOrderDetailPageState();
}

class _SellerOrderDetailPageState
    extends State<SellerOrderDetailPage> {

  final orderService =
      OrderService();

  bool isLoading = false;

  String getStatus() {

    final order =
        widget.item['orders'];

    if (order == null) {
      return '-';
    }

    if (order['payment_status'] ==
        'pending') {
      return 'Belum Dibayar';
    }

    if (order['payment_status'] ==
            'paid' &&
        order['order_status'] ==
            'pending') {
      return 'Siap Dikirim';
    }

    if (order['order_status'] ==
        'shipped') {
      return 'Sedang Dikirim';
    }

    if (order['order_status'] ==
        'completed') {
      return 'Selesai';
    }

    return '-';
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    final item =
        widget.item;

    final order =
        item['orders'];

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Detail Pesanan',
        ),
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(
          16,
        ),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            if(item['image_url'] != null)

              Center(
                child: Image.network(
                  item['image_url'],
                  height: 180,
                ),
              ),

            const SizedBox(
              height: 20,
            ),

            const Text(
              'Informasi Produk',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const Divider(),

            Text(
              'Nama Produk : ${item['nama_produk'] ?? '-'}',
            ),

            Text(
              'Qty : ${item['qty']}',
            ),

            Text(
              'Harga : Rp ${item['harga']}',
            ),

            Text(
              'Subtotal : Rp ${item['subtotal']}',
            ),

            const SizedBox(
              height: 20,
            ),

            const Text(
              'Informasi Pesanan',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const Divider(),

            Text(
              'Order ID : ${order?['id'] ?? '-'}',
            ),

            Text(
              'Status : ${getStatus()}',
            ),

            Text(
              'Payment : ${order?['payment_status'] ?? '-'}',
            ),

            Text(
              'Order Status : ${order?['order_status'] ?? '-'}',
            ),

            const SizedBox(
              height: 20,
            ),

            if(order != null &&
                order['kurir'] != null)

              Text(
                'Kurir : ${order['kurir']}',
              ),

            if(order != null &&
                order['nomor_resi'] != null)

              Text(
                'Resi : ${order['nomor_resi']}',
              ),

            const SizedBox(
              height: 20,
            ),

            if(order != null &&
                order['payment_status'] ==
                    'paid' &&
                order['order_status'] ==
                    'pending')

              SizedBox(

                width:
                    double.infinity,

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
                                  order[
                                      'id'],
                                );

                                if(!mounted) return;

                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Pesanan berhasil dikirim',
                                    ),
                                  ),
                                );

                                Navigator.pop(
                                  context,
                                  true,
                                );

                              } catch(e){

                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      e.toString(),
                                    ),
                                  ),
                                );
                              }

                              if(mounted){

                                setState(() {
                                  isLoading =
                                      false;
                                });
                              }
                            },

                  child:
                      const Text(
                    'Kirim Barang',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}