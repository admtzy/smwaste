import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../services/review_service.dart';

class ReviewPage extends StatefulWidget {
  final String productId;
  final String orderId;

  const ReviewPage({
    super.key,
    required this.productId,
    required this.orderId,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final ReviewService reviewService = ReviewService();
  final TextEditingController reviewController = TextEditingController();

  int rating = 5;
  bool loading = false;

  Future<void> submitReview() async {
    try {
      setState(() {
        loading = true;
      });

      await reviewService.addReview(
        productId: widget.productId,
        orderId: widget.orderId,
        rating: rating,
        review: reviewController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Terima kasih atas penilaian Anda",
          ),
        ),
      );

      Navigator.pop(
        context,
        true,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
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

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const colorBackground = Color(0xFFFCF9F8);
    const colorSurface = Color(0xFFFCF9F8);
    const colorOnSurface = Color(0xFF1C1B1B);
    const colorOnSurfaceVariant = Color(0xFF3F4944);
    const colorOutlineVariant = Color(0xFFBFC9C3);
    const colorPrimary = Color(0xFF004E3B);
    const colorOnPrimary = Color(0xFFFFFFFF);

    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        backgroundColor: colorSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: colorOnSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: const Text(
          "Beri Penilaian",
          style: TextStyle(
            color: colorOnSurface,
            fontFamily: 'Hanken Grotesk',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Bagaimana kualitas produk ini?",
                style: TextStyle(
                  color: colorOnSurface,
                  fontFamily: 'Hanken Grotesk',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: RatingBar.builder(
                  initialRating: 5,
                  minRating: 1,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 40,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (value) {
                    rating = value.toInt();
                  },
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: reviewController,
                maxLines: 5,
                cursorColor: colorPrimary,
                style: const TextStyle(
                  fontFamily: 'Hanken Grotesk',
                  color: colorOnSurface,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: "Tulis ulasan Anda...",
                  hintStyle: const TextStyle(
                    color: colorOnSurfaceVariant,
                    fontFamily: 'Hanken Grotesk',
                  ),
                  filled: true,
                  fillColor: const Color(0xFFFFFFFF),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: colorPrimary, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: colorOutlineVariant),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorPrimary,
                    foregroundColor: colorOnPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: loading ? null : submitReview,
                  child: loading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: colorOnPrimary,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          "Kirim Penilaian",
                          style: TextStyle(
                            fontFamily: 'Hanken Grotesk',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
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