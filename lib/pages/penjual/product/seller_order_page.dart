import 'package:flutter/material.dart';
import 'package:smwaste/pages/penjual/product/seller_order_detail_page.dart';

import '../../../services/order_service.dart';

class SellerOrderPage
    extends StatefulWidget {
  const SellerOrderPage({
    super.key,
  });

  @override
  State<SellerOrderPage>
      createState() =>
          _SellerOrderPageState();
}

class _SellerOrderPageState
    extends State<SellerOrderPage> {

  final orderService =
      OrderService();

  List orders = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      final data =
          await orderService
              .getSellerOrders();

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

  String getStatus(
    Map item,
  ) {
    final order =
        item['orders'];

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
      return 'Dalam Pengiriman';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pesanan Masuk',
        ),
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : orders.isEmpty
              ? const Center(
                  child: Text(
                    'Belum ada pesanan',
                  ),
                )
              : ListView.builder(
                  itemCount:
                      orders.length,
                  itemBuilder:
                      (context,
                          index) {

                    final item =
                        orders[index];

                    // final order =
                    //     item['orders'];

                    return InkWell(

                      onTap: () async {

                        await Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder: (_) =>
                                SellerOrderDetailPage(
                                  item: item,
                                ),

                          ),
                        );

                        loadOrders();
                      },

                      child: Card(

                        margin: const EdgeInsets.all(
                          10,
                        ),

                        child: Padding(

                          padding: const EdgeInsets.all(
                            12,
                          ),

                          child: Column(

                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [

                              Text(
                                item['nama_produk'] ?? '-',
                                style: const TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(
                                height: 5,
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

                              Text(
                                'Status : ${getStatus(item)}',
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              const Align(
                                alignment:
                                    Alignment.centerRight,
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                ),
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
}