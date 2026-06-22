import 'package:flutter/material.dart';
import '../../../services/review_service.dart';

class DetailProductPage extends StatelessWidget {
  final Map product;

  const DetailProductPage({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    const Color colorPrimary = Color(0xFF004E3B);
    const Color colorBackground = Color(0xFFFCF9F8);
    const Color colorSurfaceContainerLowest = Color(0xFFFFFFFF);
    const Color colorOnSurface = Color(0xFF1C1B1B);
    const Color colorOnSurfaceVariant = Color(0xFF3F4944);
    const Color colorOutlineVariant = Color(0xFFBFC9C3);

    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: colorOnSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: Border(
          bottom: BorderSide(
            color: colorOutlineVariant.withOpacity(0.3),
            width: 1,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          product['nama_produk'] ?? '-',
          style: const TextStyle(
            fontFamily: 'Hanken Grotesk',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Center(
                child: Container(
                  width: 192,
                  height: 192, 
                  margin: const EdgeInsets.only(bottom: 35), 
                  decoration: BoxDecoration(
                    color: colorSurfaceContainerLowest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black.withOpacity(0.1)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: product['image_url'] != null &&
                          product['image_url'].toString().isNotEmpty
                      ? Image.network(
                          product['image_url'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                            child: Icon(Icons.image,
                                size: 48, color: Colors.grey),
                          ),
                        )
                      : const Center(
                          child: Icon(Icons.image,
                              size: 48, color: Colors.grey),
                        ),
                ),
              ),

              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: colorSurfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black.withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Produk',
                      style: TextStyle(
                        fontFamily: 'Hanken Grotesk',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Divider(color: colorOutlineVariant.withOpacity(0.5)),
                    const SizedBox(height: 8),
                    _buildRowInfo('Nama Produk', product['nama_produk'] ?? '-',
                        colorOnSurface, colorOnSurfaceVariant),
                    _buildRowInfo('Kategori', product['kategori'] ?? '-',
                        colorOnSurface, colorOnSurfaceVariant),
                    _buildRowInfo('Stok', '${product['stok'] ?? 0}',
                        colorOnSurface, colorOnSurfaceVariant),
                    _buildRowInfo('Harga', 'Rp ${product['harga'] ?? 0}',
                        colorOnSurface, colorOnSurfaceVariant),
                    if (product['ongkir'] != null) ...[
                      _buildRowInfo('Ongkir', 'Rp ${product['ongkir']}',
                          colorOnSurface, colorOnSurfaceVariant),
                    ],
                    const SizedBox(height: 8),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        const dashWidth = 5.0;
                        const dashSpace = 3.0;
                        final dashCount = (constraints.constrainWidth() / (dashWidth + dashSpace)).floor();
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(dashCount, (_) {
                            return SizedBox(
                              width: dashWidth,
                              height: 1,
                              child: DecoratedBox(
                                decoration: BoxDecoration(color: colorOutlineVariant.withOpacity(0.5)),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(

                      children: [
                        const Text(
                          'Subtotal',
                          style: TextStyle(
                            fontFamily: 'Hanken Grotesk',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorOnSurface,
                          ),
                        ),
                        Text(
                          'Rp ${product['harga'] ?? 0}',
                          style: const TextStyle(
                            fontFamily: 'Hanken Grotesk',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: colorSurfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black.withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detail Tambahan',
                      style: TextStyle(
                        fontFamily: 'Hanken Grotesk',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Divider(color: colorOutlineVariant.withOpacity(0.5)),
                    const SizedBox(height: 8),
                    _buildRowInfo('Latitude', '${product['latitude'] ?? 0}',
                        colorOnSurface, colorOnSurfaceVariant),
                    _buildRowInfo('Longitude', '${product['longitude'] ?? 0}',
                        colorOnSurface, colorOnSurfaceVariant),
                    const SizedBox(height: 8),
                    Text(
                      'Deskripsi',
                      style: TextStyle(
                        fontFamily: 'Hanken Grotesk',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: colorOnSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product['deskripsi'] ?? '-',
                      style: const TextStyle(
                        fontFamily: 'Hanken Grotesk',
                        fontSize: 14,
                        color: colorOnSurface,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 35),
                decoration: BoxDecoration(
                  color: colorSurfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black.withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Ulasan Pembeli',
                          style: TextStyle(
                            fontFamily: 'Hanken Grotesk',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorPrimary,
                          ),
                        ),
                        FutureBuilder(
                          future: ReviewService().getRatingInfo(product["id"]),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return const SizedBox();
                            final rating = snapshot.data!;
                            return Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  rating["average"].toStringAsFixed(1),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(" (${rating["count"]})",
                                    style:
                                        const TextStyle(color: Colors.grey)),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Divider(color: colorOutlineVariant.withOpacity(0.5)),
                    const SizedBox(height: 12),
                    
                    FutureBuilder(
                      future: ReviewService().getReviews(product["id"]),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(color: colorPrimary),
                            ),
                          );
                        }

                        final reviews = snapshot.data!;
                        if (reviews.isEmpty) {
                          return const Text(
                            "Belum ada ulasan",
                            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                          );
                        }

                        return Column(
                          children: reviews.map((review) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: colorBackground,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                dense: true,
                                leading: const Icon(Icons.star, color: Colors.amber, size: 20),
                                title: Text(
                                  review["profiles"]?["nama"] ?? "-",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${review["rating"]} / 5", style: const TextStyle(fontSize: 11)),
                                    const SizedBox(height: 2),
                                    Text(
                                      review["review"] ?? "",
                                      style: const TextStyle(color: colorOnSurface),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRowInfo(String label, String value, Color textCol, Color labelCol) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Hanken Grotesk',
              color: labelCol,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Hanken Grotesk',
              color: textCol,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

enum DividerStyle { solid, dashed }
extension on Divider {
}