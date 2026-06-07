import 'package:flutter/material.dart';

import '../../services/product_service.dart';

class AdminProductPage extends StatefulWidget {
  const AdminProductPage({super.key});

  @override
  State<AdminProductPage> createState() =>
      _AdminProductPageState();
}

class _AdminProductPageState
    extends State<AdminProductPage> {
  final productService = ProductService();

  List products = [];

  Future<void> loadProducts() async {
    final data =
        await productService.getProducts();

    setState(() {
      products = data;
    });
  }

  @override
  void initState() {
    super.initState();

    loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Produk'),
      ),

      body: ListView.builder(
        itemCount: products.length,

        itemBuilder: (context, index) {
          final product = products[index];

          return Card(
            child: ListTile(
              leading: Image.network(
                product['image_url'],
                width: 60,
              ),

              title: Text(
                product['nama_produk'],
              ),

              subtitle: Text(
                'Rp ${product['harga']}',
              ),

              trailing: IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),

                onPressed: () async {
                  await productService
                      .deleteProduct(
                    product['id'],
                  );

                  loadProducts();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}