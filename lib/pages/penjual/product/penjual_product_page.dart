import 'package:flutter/material.dart';
import '../../../services/product_service.dart';
import 'add_product_page.dart';
import 'detail_product_page.dart';
import 'edit_product_page.dart';

class PenjualProductPage extends StatefulWidget {
  const PenjualProductPage({super.key});

  @override
  State<PenjualProductPage> createState() => _PenjualProductPageState();
}

class _PenjualProductPageState extends State<PenjualProductPage> {
  final productService = ProductService();
  List products = [];
  bool isLoading = true;

  Future<void> loadProducts() async {
    try {
      final data = await productService.getMyProducts();
      if (!mounted) return;

      setState(() {
        products = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error : $e')),
      );
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await productService.deleteProduct(id);
      await loadProducts();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil dihapus')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error : $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    const colorPrimary = Color(0xFF004E3B);
    const colorOnPrimary = Color(0xFFFFFFFF);
    const colorSurfaceContainerLowest = Color(0xFFFFFFFF);
    const colorSurfaceContainerHigh = Color(0xFFEBE7E7);
    const colorOnSurface = Color(0xFF1C1B1B);
    const colorOnSurfaceVariant = Color(0xFF3F4944);
    const colorError = Color(0xFFBA1A1A);

    int lowStockCount = products.where((p) {
      final stok = int.tryParse(p['stok'].toString()) ?? 0;
      return stok <= 5;
    }).length;

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8),
      appBar: AppBar(
        backgroundColor: colorSurfaceContainerLowest,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: const Border(bottom: BorderSide(color: Colors.black12, width: 1)),
        title: const Text(
          'Produk Saya',
          style: TextStyle(
            color: colorOnSurface,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: colorOnSurface),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: colorOnSurface),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: colorPrimary,
        foregroundColor: colorOnPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductPage()),
          );
          if (result == true) {
            loadProducts();
          }
        },
        child: const Icon(Icons.add, size: 24),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: colorPrimary),
            )
          : CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colorPrimary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Produk',
                                  style: TextStyle(
                                    color: colorOnPrimary.withOpacity(0.8),
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${products.length}',
                                  style: const TextStyle(
                                    color: colorOnPrimary,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colorSurfaceContainerHigh,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Stok Rendah',
                                  style: TextStyle(
                                    color: colorOnSurfaceVariant,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$lowStockCount',
                                  style: const TextStyle(
                                    color: colorError,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                products.isEmpty
                    ? const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text('Belum ada produk'),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final product = products[index];
                              final stokValue = int.tryParse(product['stok'].toString()) ?? 0;
                              final isLowStock = stokValue <= 5;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: colorSurfaceContainerLowest,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.black.withOpacity(0.1)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      product['image_url'] != null && product['image_url'].toString().isNotEmpty
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(6),
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
                                                color: Colors.grey.shade300,
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: const Icon(Icons.image),
                                            ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    product['nama_produk'] ?? '-',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: colorOnSurface,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                                
                                                PopupMenuButton<String>(
                                                  icon: const Icon(Icons.more_vert, size: 20, color: colorOnSurfaceVariant),
                                                  padding: EdgeInsets.zero,
                                                  constraints: const BoxConstraints(),
                                                  onSelected: (value) async {
                                                    if (value == 'detail') {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) => DetailProductPage(product: product),
                                                        ),
                                                      );
                                                    }
                                                    if (value == 'edit') {
                                                      final result = await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) => EditProductPage(product: product),
                                                        ),
                                                      );
                                                      if (result == true) {
                                                        loadProducts();
                                                      }
                                                    }
                                                    if (value == 'delete') {
                                                      final confirm = await showDialog<bool>(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: const Text('Hapus Produk'),
                                                            content: const Text('Yakin ingin menghapus produk?'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () => Navigator.pop(context, false),
                                                                child: const Text('Batal'),
                                                              ),
                                                              ElevatedButton(
                                                                onPressed: () => Navigator.pop(context, true),
                                                                child: const Text('Hapus'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                      if (confirm == true) {
                                                        deleteProduct(product['id'].toString());
                                                      }
                                                    }
                                                  },
                                                  itemBuilder: (context) => const [
                                                    PopupMenuItem(value: 'detail', child: Text('Detail')),
                                                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                                                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Text(
                                                  'Rp ${product['harga']} / kg',
                                                  style: const TextStyle(
                                                    color: colorPrimary,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Text(
                                                  'Stok: ${product['stok']} kg',
                                                  style: TextStyle(
                                                    color: isLowStock ? colorError : colorOnSurfaceVariant,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (product['kecamatan'] != null || product['kabupaten'] != null)
                                              Padding(
                                                padding: const EdgeInsets.only(top: 2),
                                                child: Text(
                                                  '${product['kecamatan'] ?? '-'}, ${product['kabupaten'] ?? '-'}',
                                                  style: TextStyle(
                                                    color: colorOnSurfaceVariant.withOpacity(0.6),
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            childCount: products.length,
                          ),
                        ),
                      ),
              ],
            ),
    );
  }
}