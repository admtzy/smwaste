// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class PaymentPage
//     extends StatefulWidget {
//   final String paymentUrl;

//   const PaymentPage({
//     super.key,
//     required this.paymentUrl,
//   });

//   @override
//   State<PaymentPage>
//       createState() =>
//           _PaymentPageState();
// }

// class _PaymentPageState
//     extends State<PaymentPage> {
//   late WebViewController
//       controller;

//   @override
//   void initState() {
//     super.initState();

//     controller =
//         WebViewController()
//           ..setJavaScriptMode(
//             JavaScriptMode
//                 .unrestricted,
//           )
//           ..loadRequest(
//             Uri.parse(
//               widget.paymentUrl,
//             ),
//           );
//   }

//   @override
//   Widget build(
//     BuildContext context,
//   ) {
//     return Scaffold(
//       appBar: AppBar(
//         title:
//             const Text(
//               'Pembayaran',
//             ),
//       ),
//       body: WebViewWidget(
//         controller:
//             controller,
//       ),
//     );
//   }
// }