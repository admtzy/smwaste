import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/checkout_service.dart';

class CheckoutPage extends StatefulWidget {
  final int totalProduk;
  final int totalOngkir;
  final int adminFee;
  final int grandTotal;

  const CheckoutPage({
    super.key,
    required this.totalProduk,
    required this.totalOngkir,
    required this.adminFee,
    required this.grandTotal,
  });

  @override
  State<CheckoutPage> createState() =>
      _CheckoutPageState();
}

class _CheckoutPageState
    extends State<CheckoutPage> {
  final CheckoutService checkoutService =
      CheckoutService();

  bool isLoading = false;

  // =========================
  // OPEN MIDTRANS
  // =========================

  Future<void> openPayment(
    String url,
  ) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode:
            LaunchMode
                .externalApplication,
      );
    } else {
      throw Exception(
        'Gagal membuka halaman pembayaran',
      );
    }
  }

  // =========================
  // CHECKOUT
  // =========================

  Future<void>
      prosesCheckout() async {
    try {
      setState(() {
        isLoading = true;
      });

      final result =
          await checkoutService
              .checkout();

      final String orderId =
          result['order_id']
                  ?.toString() ??
              '';

      final String token =
          result['token']
                  ?.toString() ??
              '';

      final String redirectUrl =
          result['redirect_url']
                  ?.toString() ??
              '';

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            'Order berhasil dibuat\n$orderId',
          ),
        ),
      );

      debugPrint(
        'TOKEN : $token',
      );

      debugPrint(
        'URL : $redirectUrl',
      );

      if (redirectUrl.isNotEmpty) {
        await openPayment(
          redirectUrl,
        );
      } else {
        throw Exception(
          'URL pembayaran kosong',
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text(
          'Checkout',
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(
          16,
        ),
        child: Column(
          children: [
            ListTile(
              title:
                  const Text(
                'Total Produk',
              ),
              trailing: Text(
                'Rp ${widget.totalProduk}',
              ),
            ),

            ListTile(
              title:
                  const Text(
                'Ongkir',
              ),
              trailing: Text(
                'Rp ${widget.totalOngkir}',
              ),
            ),

            ListTile(
              title:
                  const Text(
                'Admin Fee',
              ),
              trailing: Text(
                'Rp ${widget.adminFee}',
              ),
            ),

            const Divider(),

            ListTile(
              title:
                  const Text(
                'Grand Total',
              ),
              trailing: Text(
                'Rp ${widget.grandTotal}',
                style:
                    const TextStyle(
                  fontWeight:
                      FontWeight
                          .bold,
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width:
                  double.infinity,
              height: 50,
              child:
                  ElevatedButton(
                onPressed:
                    isLoading
                        ? null
                        : prosesCheckout,
                child:
                    isLoading
                        ? const SizedBox(
                            width:
                                20,
                            height:
                                20,
                            child:
                                CircularProgressIndicator(),
                          )
                        : const Text(
                            'Bayar Sekarang',
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}