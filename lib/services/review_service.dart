import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewService {
  final supabase = Supabase.instance.client;

  Future<void> addReview({
    required String productId,
    required String orderId,
    required int rating,
    required String review,
  }) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception("Belum login");
    }

    await supabase.from("product_reviews").insert({
      "product_id": productId,
      "order_id": orderId,
      "buyer_id": user.id,
      "rating": rating,
      "review": review,
    });

    final reviews = await supabase
        .from("product_reviews")
        .select("rating")
        .eq("product_id", productId);

    double total = 0;

    for (final item in reviews) {
      total += item["rating"];
    }

    final avg = total / reviews.length;

    await supabase
        .from("products")
        .update({
          "rating_average": avg,
          "rating_count": reviews.length,
        })
        .eq("id", productId);
  }

  Future<Map<String, dynamic>> getRatingInfo(
  String productId,
) async {
  final reviews = await supabase
      .from("product_reviews")
      .select()
      .eq(
        "product_id",
        productId,
      );

  if (reviews.isEmpty) {
    return {
      "average": 0.0,
      "count": 0,
    };
  }

  double total = 0;

  for (final item in reviews) {
    total +=
        (item["rating"] ?? 0)
            .toDouble();
  }

  return {
    "average":
        total / reviews.length,
    "count":
        reviews.length,
  };
}

  // Future<List<dynamic>> getReviews(
  //   String productId,
  // ) async {
  //   return await supabase
  //       .from("product_reviews")
  //       .select("""
  //       *,
  //       profiles(
  //         nama
  //       )
  //     """)
  //       .eq("product_id", productId)
  //       .order(
  //         "created_at",
  //         ascending: false,
  //       );
  // }

  Future<List<dynamic>> getReviews(
  String productId,
) async {

  return await supabase
      .from("product_reviews")
      .select("""
      *,
      profiles(
        nama
      )
    """)
      .eq(
        "product_id",
        productId,
      )
      .order(
        "created_at",
        ascending: false,
      );
}

  Future<bool> sudahReview(
    String orderId,
  ) async {
    final user = supabase.auth.currentUser;

    final data = await supabase
        .from("product_reviews")
        .select()
        .eq(
          "order_id",
          orderId,
        )
        .eq(
          "buyer_id",
          user!.id,
        );

    return data.isNotEmpty;
  }
}