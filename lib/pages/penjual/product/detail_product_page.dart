import 'package:flutter/material.dart';
import '../../../services/review_service.dart';

class DetailProductPage
    extends StatelessWidget {
  final Map product;

  const DetailProductPage({
    super.key,
    required this.product,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product['nama_produk'] ??
              '-',
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            // =========================
            // IMAGE
            // =========================

            product['image_url'] !=
                        null &&
                    product['image_url']
                        .toString()
                        .isNotEmpty
                ? Image.network(
                    product['image_url'],

                    width:
                        double.infinity,

                    height: 300,

                    fit: BoxFit.cover,

                    errorBuilder:
                        (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return Container(
                        height: 300,
                        color:
                            Colors.grey,
                        child:
                            const Center(
                          child: Icon(
                            Icons.image,
                            size: 80,
                          ),
                        ),
                      );
                    },
                  )
                : Container(
                    height: 300,
                    width:
                        double.infinity,
                    color: Colors.grey,
                    child: const Center(
                      child: Icon(
                        Icons.image,
                        size: 80,
                      ),
                    ),
                  ),

            // =========================
            // CONTENT
            // =========================

            Padding(
              padding:
                  const EdgeInsets.all(
                20,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [
                  // =========================
                  // NAMA PRODUK
                  // =========================

                  Text(
                    product[
                            'nama_produk'] ??
                        '-',

                    style:
                        const TextStyle(
                      fontSize: 24,
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  // =========================
                  // HARGA
                  // =========================

                  Text(
                    'Rp ${product['harga'] ?? 0}',

                    style:
                        const TextStyle(
                      fontSize: 22,
                      color:
                          Colors.green,
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),


                  const SizedBox(
  height: 10,
),

FutureBuilder(
  future: ReviewService()
      .getRatingInfo(
    product["id"],
  ),

  builder: (
    context,
    snapshot,
  ) {

    if (!snapshot.hasData) {
      return const SizedBox();
    }

    final rating =
        snapshot.data!;

    return Row(
      children: [

        const Icon(
          Icons.star,
          color: Colors.amber,
        ),

        const SizedBox(
          width: 5,
        ),

        Text(
          rating["average"]
              .toStringAsFixed(1),
          style:
              const TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(
          width: 5,
        ),

        Text(
          "(${rating["count"]} ulasan)",
        ),
      ],
    );
  },
),
                  const SizedBox(
                    height: 20,
                  ),

                  // =========================
                  // KATEGORI
                  // =========================

                  infoItem(
                    'Kategori',
                    product[
                            'kategori'] ??
                        '-',
                  ),

                  // =========================
                  // STOK
                  // =========================

                  infoItem(
                    'Stok',
                    '${product['stok'] ?? 0}',
                  ),

                  // =========================
                  // KECAMATAN
                  // =========================

                  // infoItem(
                  //   'Kecamatan',
                  //   product[
                  //           'kecamatan'] ??
                  //       '-',
                  // ),

                  // // =========================
                  // // KABUPATEN
                  // // =========================

                  // infoItem(
                  //   'Kabupaten',
                  //   product[
                  //           'kabupaten'] ??
                  //       '-',
                  // ),

                  // =========================
                  // ONGKIR
                  // =========================

                  if (product[
                          'ongkir'] !=
                      null)
                    infoItem(
                      'Ongkir',
                      'Rp ${product['ongkir']}',
                    ),

                  const SizedBox(
                    height: 20,
                  ),

                  // =========================
                  // DESKRIPSI
                  // =========================

                  const Text(
                    'Deskripsi',
                   

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),

                   const SizedBox(
  height: 30,
),

const Text(
  "Ulasan Pembeli",
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(
  height: 15,
),

FutureBuilder(
  future: ReviewService().getReviews(
    product["id"],
  ),

  builder: (
    context,
    snapshot,
  ) {

    if (!snapshot.hasData) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final reviews =
        snapshot.data!;

    if (reviews.isEmpty) {
      return const Text(
        "Belum ada ulasan",
      );
    }

    return Column(
      children: reviews.map(
        (review) {

          return Card(
            child: ListTile(

              leading: const Icon(
                Icons.star,
                color: Colors.amber,
              ),

              title: Text(
                review["profiles"]
                        ?["nama"] ??
                    "-",
              ),

              subtitle: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Text(
                    "${review["rating"]} / 5",
                  ),

                  Text(
                    review["review"] ??
                        "",
                  ),
                ],
              ),
            ),
          );
        },
      ).toList(),
    );
  },
),
                  const SizedBox(
                    height: 10,
                  ),

                  Text(
                    product[
                            'deskripsi'] ??
                        '-',
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  // =========================
                  // GPS
                  // =========================

                  const Text(
                    'Lokasi GPS',

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  infoItem(
                    'Latitude',
                    '${product['latitude'] ?? 0}',
                  ),

                  infoItem(
                    'Longitude',
                    '${product['longitude'] ?? 0}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // ITEM INFO
  // =========================

  Widget infoItem(
    String title,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 12,
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          SizedBox(
            width: 110,

            child: Text(
              '$title :',

              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}