// import 'package:flutter/material.dart';

// import '../../services/order_service.dart';

// class MyOrdersPage
//     extends StatefulWidget {
//   const MyOrdersPage({
//     super.key,
//   });

//   @override
//   State<MyOrdersPage>
//       createState() =>
//           _MyOrdersPageState();
// }

// class _MyOrdersPageState
//     extends State<MyOrdersPage> {
//   final service =
//       OrderService();

//   List orders = [];

//   @override
//   void initState() {
//     super.initState();

//     loadOrders();
//   }

//   Future<void>
//       loadOrders() async {
//     orders =
//         await service
//             .getMyOrders();

//     setState(() {});
//   }

//   @override
//   Widget build(
//     BuildContext context,
//   ) {
//     return Scaffold(
//       appBar: AppBar(
//         title:
//             const Text(
//               'Pesanan Saya',
//             ),
//       ),

//       body: ListView.builder(
//         itemCount:
//             orders.length,

//         itemBuilder:
//             (context, index) {
//           final item =
//               orders[index];

//           return Card(
//             child: ListTile(
//               title: Text(
//                 item['order_status'],
//               ),

//               subtitle: Text(
//                 item[
//                         'payment_status']
//                     .toString(),
//               ),

//               trailing: Text(
//                 'Rp${item['grand_total']}',
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }