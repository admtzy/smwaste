import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/checkout_service.dart';
import '../services/midtrans_service.dart';

class PaymentPage extends StatefulWidget {
  final String paymentUrl;
  final String orderId;

  const PaymentPage({
    super.key,
    required this.paymentUrl,
    required this.orderId,
  });

  @override
  State<PaymentPage> createState() =>
      _PaymentPageState();
}

class _PaymentPageState
    extends State<PaymentPage> {
  final MidtransService
      midtransService =
      MidtransService();

  bool loading = false;

  @override
  void initState() {
    super.initState();

    debugPrint(
      "========================",
    );
    debugPrint(
      "PAYMENT PAGE",
    );
    debugPrint(
      "ORDER : ${widget.orderId}",
    );
    debugPrint(
      widget.paymentUrl,
    );
    debugPrint(
      "========================",
    );
  }

  //---------------------------------
  // BUKA MIDTRANS
  //---------------------------------

  Future<void> bayar() async {
    final uri =
        Uri.parse(widget.paymentUrl);

    final ok = await launchUrl(
      uri,
      mode:
          LaunchMode
              .externalApplication,
    );

    debugPrint(
      "OPEN MIDTRANS = $ok",
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Selesaikan pembayaran lalu kembali ke aplikasi dan tekan Lihat Bukti Pembayaran.",
        ),
      ),
    );
  }

  //---------------------------------
  // CEK BUKTI PEMBAYARAN
  //---------------------------------

  Future<void> cekBuktiPembayaran() async {
    try {
      setState(() {
        loading = true;
      });

      await CheckoutService()
          .checkPaymentStatus(
        widget.orderId,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            "Pembayaran berhasil",
          ),
        ),
      );

      Navigator.pop(
        context,
        true,
      );
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
          loading = false;
        });
      }
    }
  }

  //---------------------------------
  // UI
  //---------------------------------

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pembayaran",
        ),
      ),
      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.all(
            20,
          ),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment
                    .center,
            children: [

              //---------------------------------
              // BAYAR SEKARANG
              //---------------------------------

              SizedBox(
                width:
                    double.infinity,
                child:
                    ElevatedButton(
                  onPressed: bayar,
                  child:
                      const Text(
                    "Bayar Sekarang",
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              //---------------------------------
              // LIHAT BUKTI PEMBAYARAN
              //---------------------------------

              SizedBox(
                width:
                    double.infinity,
                child:
                    ElevatedButton(
                  onPressed:
                      loading
                          ? null
                          : cekBuktiPembayaran,
                  child: Text(
                    loading
                        ? "Loading..."
                        : "Pembayaran Selesai",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}