import 'package:flutter/material.dart';
import 'package:smwaste/payment_page.dart';

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
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final CheckoutService checkoutService = CheckoutService();

  bool isLoading = false;

  // =========================
  // CHECKOUT LOGIC
  // =========================
  Future<void> prosesCheckout() async {
    try {
      setState(() {
        isLoading = true;
      });

      final result = await checkoutService.checkout();

      final String orderId = result["order_id"]?.toString() ?? "";
      final String token = result["token"]?.toString() ?? "";
      final String redirectUrl = result["redirect_url"]?.toString() ?? "";

      debugPrint("================================");
      debugPrint("CHECKOUT BERHASIL");
      debugPrint("ORDER ID : $orderId");
      debugPrint("TOKEN : $token");
      debugPrint("REDIRECT URL : $redirectUrl");
      debugPrint("================================");

      if (!mounted) return;

      if (redirectUrl.isEmpty) {
        throw Exception("URL pembayaran kosong");
      }

      // =========================
      // PINDAH KE PAYMENT PAGE
      // =========================
      final resultPayment = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentPage(
            paymentUrl: redirectUrl,
            orderId: orderId,
          ),
        ),
      );

      debugPrint("HASIL DARI PAYMENT PAGE = $resultPayment");

      if (resultPayment == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Pembayaran berhasil"),
          ),
        );

        // PERBAIKAN: Menggunakan Navigator.of(context).pop secara aman
        if (mounted) {
          Navigator.pop(context, true);
        }
      }
    } catch (e, s) {
      debugPrint("ERROR CHECKOUT");
      debugPrint(e.toString());
      debugPrint(s.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
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
  Widget build(BuildContext context) {
    // Definisi Palet Warna Berdasarkan Tema HTML
    const colorPrimary = Color(0xFF004E3B);
    const colorOnPrimary = Color(0xFFFFFFFF);
    const colorBackground = Color(0xFFFCF9F8);
    const colorOnBackground = Color(0xFF1C1B1B);
    const colorSurfaceLowest = Color(0xFFFFFFFF);
    const colorOnSurface = Color(0xFF1C1B1B);
    const colorOnSurfaceVariant = Color(0xFF3F4944);
    const colorOutlineVariant = Color(0xFFBFC9C3);

    return Scaffold(
      backgroundColor: colorBackground,
      // Top App Bar sesuai dengan <header class="bg-primary">
      appBar: AppBar(
        backgroundColor: colorPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: colorOnPrimary),
          // PERBAIKAN: Menggunakan maybePop untuk memastikan tumpukan navigasi aman
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          "SMARTWASTE",
          style: TextStyle(
            color: colorOnPrimary,
            fontFamily: 'Hanken Grotesk',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Konten Utama dengan Padding
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Heading Judul Halaman
                    const Text(
                      "Checkout",
                      style: TextStyle(
                        color: colorOnBackground,
                        fontFamily: 'Hanken Grotesk',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Cost Breakdown Card (bg-surface-container-lowest)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: colorSurfaceLowest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorOnBackground.withOpacity(0.1),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Total Produk
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total Produk",
                                style: TextStyle(
                                  color: colorOnSurfaceVariant,
                                  fontFamily: 'Hanken Grotesk',
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "Rp ${widget.totalProduk}",
                                style: const TextStyle(
                                  color: colorOnSurface,
                                  fontFamily: 'Hanken Grotesk',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Ongkir
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Ongkir",
                                style: TextStyle(
                                  color: colorOnSurfaceVariant,
                                  fontFamily: 'Hanken Grotesk',
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "Rp ${widget.totalOngkir}",
                                style: const TextStyle(
                                  color: colorOnSurface,
                                  fontFamily: 'Hanken Grotesk',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Admin Fee
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Admin Fee",
                                style: TextStyle(
                                  color: colorOnSurfaceVariant,
                                  fontFamily: 'Hanken Grotesk',
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "Rp ${widget.adminFee}",
                                style: const TextStyle(
                                  color: colorOnSurface,
                                  fontFamily: 'Hanken Grotesk',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Divider
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Divider(
                              color: colorOutlineVariant,
                              thickness: 1,
                            ),
                          ),

                          // Grand Total
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Grand Total",
                                style: TextStyle(
                                  color: colorOnSurface,
                                  fontFamily: 'Hanken Grotesk',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Rp ${widget.grandTotal}",
                                style: const TextStyle(
                                  color: colorPrimary,
                                  fontFamily: 'Hanken Grotesk',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Action Bar (Fixed di bagian bawah)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorSurfaceLowest,
                border: Border(
                  top: BorderSide(
                    color: colorOnBackground.withOpacity(0.1),
                  ),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorPrimary,
                    foregroundColor: colorOnPrimary,
                    disabledBackgroundColor: colorPrimary.withOpacity(0.6),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: isLoading ? null : prosesCheckout,
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: colorOnPrimary,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          "Bayar Sekarang",
                          style: TextStyle(
                            fontFamily: 'Hanken Grotesk',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}