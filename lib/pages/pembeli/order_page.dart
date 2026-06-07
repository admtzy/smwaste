import 'package:flutter/material.dart';

import '../../services/order_service.dart';
import 'order_detail_page.dart';

class OrderPage
    extends StatefulWidget {

  const OrderPage({
    super.key,
  });

  @override
  State<OrderPage>
      createState() =>
          _OrderPageState();
}

class _OrderPageState
    extends State<OrderPage> {

  final orderService =
      OrderService();

  List orders = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadOrders();
  }

  Future<void>
      loadOrders() async {

    final data =
        await orderService
            .getMyOrders();

    setState(() {

      orders = data;

      isLoading = false;

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
          'Pesanan Saya',
        ),
      ),

      body: isLoading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : ListView.builder(

              itemCount:
                  orders.length,

              itemBuilder:
                  (context,index){

                final order =
                    orders[index];

                return Card(

                  child: ListTile(

                    title: Text(
                      order['id']
                          .toString()
                          .substring(
                            0,
                            8,
                          ),
                    ),

                    subtitle: Text(
                      order[
                          'order_status'],
                    ),

                    trailing: Text(
                      'Rp ${order['grand_total']}',
                    ),

                    onTap: () {

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder:
                              (_)
                                  => OrderDetailPage(
                                    order:
                                        order,
                                  ),

                        ),

                      );

                    },

                  ),

                );
              },
            ),
    );
  }
}