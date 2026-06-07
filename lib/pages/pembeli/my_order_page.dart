import 'package:flutter/material.dart';

import '../../services/order_service.dart';
import 'order_detail_page.dart';

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({
    super.key,
  });

  @override
  State<MyOrderPage> createState() =>
      _MyOrdersPageState();
}

class _MyOrdersPageState
    extends State<MyOrderPage> {
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
              .getMyOrders();

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
    Map order,
  ) {

    if(order['payment_status']
        == 'pending') {

      return 'Menunggu Pembayaran';
    }

    if(order['payment_status']
            == 'paid' &&
        order['order_status']
            == 'pending') {

      return 'Menunggu Pengiriman';
    }

    if(order['order_status']
        == 'shipped') {

      return 'Sedang Dikirim';
    }

    if(order['order_status']
        == 'completed') {

      return 'Pesanan Selesai';
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
          'Pesanan Saya',
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
              : RefreshIndicator(
                  onRefresh:
                      loadOrders,
                  child:
                      ListView.builder(
                    itemCount:
                        orders.length,
                    itemBuilder:
                        (context,
                            index) {
                      final order =
                          orders[index];

                      return Card(
                        margin:
                            const EdgeInsets.all(
                          10,
                        ),
                        child:
                            ListTile(
                          title: Text(
                            'Order ${order['id'].toString().substring(0, 8)}',
                          ),

                          subtitle:
                              Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              const SizedBox(
                                height:
                                    5,
                              ),

                              Text(
                                getStatus(
                                  order,
                                ),
                              ),

                              Text(
                                'Rp ${order['grand_total']}',
                              ),

                              Text(
                                'Pembayaran : ${order['payment_status']}',
                              ),
                            ],
                          ),

                          trailing:
                              const Icon(
                            Icons
                                .arrow_forward_ios,
                            size: 16,
                          ),

                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) =>
                                        OrderDetailPage(
                                          order:
                                              order,
                                        ),
                              ),
                            );

                            loadOrders();
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}