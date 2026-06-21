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
  State<ReviewPage> createState() =>
      _ReviewPageState();
}

class _ReviewPageState
    extends State<ReviewPage> {
  final ReviewService reviewService =
      ReviewService();

  final TextEditingController
      reviewController =
      TextEditingController();

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

      ScaffoldMessenger.of(context)
          .showSnackBar(
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

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Beri Penilaian",
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            const Text(
              "Bagaimana kualitas produk ini?",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Center(
              child: RatingBar.builder(
                initialRating: 5,
                minRating: 1,
                allowHalfRating: false,
                itemCount: 5,
                itemSize: 40,

                itemBuilder:
                    (context, _) =>
                        const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),

                onRatingUpdate:
                    (value) {
                  rating =
                      value.toInt();
                },
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            TextField(
              controller:
                  reviewController,

              maxLines: 5,

              decoration:
                  InputDecoration(
                hintText:
                    "Tulis ulasan Anda...",
                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            SizedBox(
              width:
                  double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed:
                    loading
                        ? null
                        : submitReview,

                child:
                    loading
                        ? const CircularProgressIndicator()
                        : const Text(
                            "Kirim Penilaian",
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}