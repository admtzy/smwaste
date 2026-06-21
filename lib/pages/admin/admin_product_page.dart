import 'package:flutter/material.dart';
import 'package:smwaste/services/product_service.dart';
import '../../../services/review_service.dart';

class AdminProductPage extends StatefulWidget {
  const AdminProductPage({super.key});

  @override
  State<AdminProductPage> createState() => _AdminProductPageState();
}

class _AdminProductPageState extends State<AdminProductPage> {
  final ProductService _service = ProductService();
  final ReviewService reviewService =
    ReviewService();

  List<dynamic> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final data = await _service.getAllProductsAdmin();

      setState(() {
        products = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  // ✅ FIX: harus kirim id + imageUrl
  Future<void> deleteProduct(
    String id,
    String imageUrl,
  ) async {
    try {
      await _service.deleteProductAdmin(
        productId: id,
        imageUrl: imageUrl,
      );

      await loadProducts();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk berhasil dihapus'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void showDetailProduct(String productId) async {
    try {
      final data = await _service.getProductDetailAdmin(productId);

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        builder: (_) {
          return DraggableScrollableSheet(
            initialChildSize: 0.7, // Tinggi awal saat dibuka (70% layar)
            minChildSize: 0.5,     // Tinggi minimal
            maxChildSize: 0.95,    // Tinggi maksimal saat di-scroll mentok atas
            expand: false,
            builder: (_, scrollController) {
              return Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: SingleChildScrollView(
                  controller: scrollController, // Menghubungkan scroll dengan bottom sheet
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Garis penanda handle BottomSheet di bagian atas tengah
                      Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      // IMAGE
                      if (data['image_url'] != null && data['image_url'] != '')
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            data['image_url'],
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                        ),

                      const SizedBox(height: 16, width: double.infinity),

                      // NAME
                      Text(
                        data['nama_produk'] ?? '-',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(),
                      ),

                      // INFO LIST
                      _buildDetailRow(Icons.monetization_on_outlined, 'Harga', 'Rp ${data['harga']}'),
                      _buildDetailRow(Icons.layers_outlined, 'Stok', '${data['stok']} unit'),
                      _buildDetailRow(Icons.category_outlined, 'Kategori', '${data['kategori']}'),
                      _buildDetailRow(Icons.description_outlined, 'Deskripsi', '${data['deskripsi'] ?? '-'}'),
                      _buildDetailRow(Icons.location_on_outlined, 'Latitude', '${data['latitude'] ?? '-'}'),
                      _buildDetailRow(Icons.location_on_outlined, 'Longitude', '${data['longitude'] ?? '-'}'),
                      const SizedBox(height: 20),

                      const Text(
                        "Rating Produk",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      FutureBuilder(
  future: reviewService.getRatingInfo(
    data["id"],
  ),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return const SizedBox();
    }

    final rating =
        snapshot.data as Map<String, dynamic>;

    return Row(
      children: [
        const Icon(
          Icons.star,
          color: Colors.amber,
        ),

        const SizedBox(width: 5),

        Text(
          rating["average"]
              .toStringAsFixed(1),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(width: 5),

        Text(
          "(${rating["count"]} ulasan)",
        ),
      ],
    );
  },
),

                      const SizedBox(height: 20),

                      const Text(
                        "Ulasan Pembeli",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      FutureBuilder(
                        future: reviewService.getReviews(
                          data["id"],
                        ),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final reviews = snapshot.data as List;

                          if (reviews.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.only(bottom: 24),
                              child: Text("Belum ada ulasan"),
                            );
                          }

                          return Column(
                            children: reviews.map((review) {
                              return Card(
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  title: Text(
                                    review["profiles"]?["nama"] ?? "-",
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${review["rating"]}/5",
                                      ),
                                      Text(
                                        review["review"] ?? "",
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 24), // Spacing bawah agar rapi saat scroll mentok
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  // Helper widget untuk mempercantik baris info detail di BottomSheet
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF236652)),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87, fontSize: 14),
                children: [
                  TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ FIX: dialog harus terima 2 data
  void showDeleteDialog(
    String id,
    String imageUrl,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Produk', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Yakin ingin menghapus produk ini dari sistem?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await deleteProduct(id, imageUrl);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF236652);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F7), // Background abu-hijau sangat bersih
      appBar: AppBar(
        title: const Text(
          'Kelola Produk',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: primaryGreen,
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: primaryGreen),
            )
          : products.isEmpty
              ? const Center(
                  child: Text(
                    'Belum ada produk',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadProducts,
                  color: primaryGreen,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];

                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            showDetailProduct(product['id'].toString());
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                            child: ListTile(
                              leading: product['image_url'] != null && product['image_url'] != ''
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        product['image_url'],
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.image, color: Colors.grey),
                                    ),
                              title: Text(
                                product['nama_produk'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Rp ${product['harga']}',
                                      style: const TextStyle(
                                        color: primaryGreen,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Stok: ${product['stok']} | Kategori: ${product['kategori']}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete_outline, // Menggunakan desain outline yang lebih bersih
                                  color: Colors.redAccent,
                                ),
                                onPressed: () {
                                  showDeleteDialog(
                                    product['id'].toString(),
                                    product['image_url'] ?? '',
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}