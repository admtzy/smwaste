import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
          "Selesaikan pembayaran lalu kembali ke aplikasi dan tekan Cek Status.",
        ),
      ),
    );
  }

  //---------------------------------
  // CEK STATUS
  //---------------------------------

  Future<void> cekStatus() async {
    setState(() {
      loading = true;
    });

    try {
      final result =
          await midtransService
              .checkPaymentStatus(
        widget.orderId,
      );

      debugPrint(
        result.toString(),
      );

      final status =
          result["transaction_status"]
                  ?.toString() ??
              "";

      debugPrint(
        "STATUS = $status",
      );

      if (status ==
              "settlement" ||
          status == "capture" ||
          status == "paid") {
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
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text(
              "Status pembayaran : $status",
            ),
          ),
        );
      }
    } catch (e) {
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

    setState(() {
      loading = false;
    });
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
              SizedBox(
                width:
                    double.infinity,
                child:
                    ElevatedButton(
                  onPressed:
                      bayar,
                  child:
                      const Text(
                    "Bayar Sekarang",
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              SizedBox(
                width:
                    double.infinity,
                child:
                    ElevatedButton(
                  onPressed:
                      loading
                          ? null
                          : cekStatus,
                  child:
                      loading
                          ? const CircularProgressIndicator()
                          : const Text(
                              "Cek Status Pembayaran",
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