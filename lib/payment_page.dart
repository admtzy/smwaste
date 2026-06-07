import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentPage extends StatelessWidget {

  final String paymentUrl;

  const PaymentPage({
    super.key,
    required this.paymentUrl,
  });

  Future<void> bayar() async {

    await launchUrl(
      Uri.parse(paymentUrl),
      mode:
          LaunchMode
              .externalApplication,
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    return Scaffold(

      appBar: AppBar(
        title:
            const Text(
              'Pembayaran',
            ),
      ),

      body: Center(

        child: ElevatedButton(

          onPressed: bayar,

          child: const Text(
            'Bayar dengan Midtrans',
          ),
        ),
      ),
    );
  }
}