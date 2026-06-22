import 'package:flutter/material.dart';
import '../../../services/product_service.dart';

class EditProductPage extends StatefulWidget {
  final Map product;

  const EditProductPage({
    super.key,
    required this.product,
  });

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final productService = ProductService();

  late TextEditingController namaC;
  late TextEditingController deskripsiC;
  late TextEditingController hargaC;
  late TextEditingController stokC;
  late String kategori;
  bool isLoading = false;

  static const Color colorPrimary = Color(0xFF004E3B);
  static const Color colorBackground = Color(0xFFFCF9F8);
  static const Color colorSurfaceContainer = Color(0xFFF0EDEC);
  static const Color colorSecondaryContainer = Color(0xFFD5E7DA);
  static const Color colorOnSurface = Color(0xFF1C1B1B);
  static const Color colorOnSurfaceVariant = Color(0xFF3F4944);

  @override
  void initState() {
    super.initState();
    namaC = TextEditingController(text: widget.product['nama_produk'] ?? '');
    deskripsiC = TextEditingController(text: widget.product['deskripsi'] ?? '');
    hargaC = TextEditingController(text: widget.product['harga']?.toString() ?? '');
    stokC = TextEditingController(text: widget.product['stok']?.toString() ?? '');
    kategori = widget.product['kategori'] ?? 'Makanan';
  }

  Future<void> updateProduct() async {
    try {
      if (namaC.text.isEmpty ||
          deskripsiC.text.isEmpty ||
          hargaC.text.isEmpty ||
          stokC.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Semua field wajib diisi')),
        );
        return;
      }

      setState(() {
        isLoading = true;
      });

      await productService.updateProduct(
        id: widget.product['id'],
        namaProduk: namaC.text.trim(),
        deskripsi: deskripsiC.text.trim(),
        harga: int.parse(hargaC.text),
        stok: int.parse(stokC.text),
        kategori: kategori,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil diupdate')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error : $e')),
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
  void dispose() {
    namaC.dispose();
    deskripsiC.dispose();
    hargaC.dispose();
    stokC.dispose();
    super.dispose();
  }

  Widget _buildFormLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: colorOnSurfaceVariant,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  InputDecoration _inputStyle({String? prefixText, String? hintText}) {
    return InputDecoration(
      prefixText: prefixText,
      hintText: hintText,
      prefixStyle: const TextStyle(color: colorOnSurfaceVariant, fontWeight: FontWeight.w500),
      fillColor: colorSecondaryContainer,
      filled: true,
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF004e3b), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        backgroundColor: colorBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: colorOnSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Produk',
          style: TextStyle(
            color: colorOnSurface,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              width: double.infinity,
              height: 192,
              decoration: BoxDecoration(
                color: colorSurfaceContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black.withOpacity(0.05)),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  if (widget.product['image_url'] != null && widget.product['image_url'].toString().isNotEmpty)
                    Image.network(
                      widget.product['image_url'],
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  Container(
                    color: Colors.black.withOpacity(0.15),
                    child: const Center(
                      child: Icon(
                        Icons.photo_camera,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),

            _buildFormLabel('Nama Produk'),
            TextField(
              controller: namaC,
              style: const TextStyle(color: colorOnSurface),
              decoration: _inputStyle(),
            ),
            const SizedBox(height: 24),

            _buildFormLabel('Deskripsi'),
            TextField(
              controller: deskripsiC,
              maxLines: 4,
              style: const TextStyle(color: colorOnSurface),
              decoration: _inputStyle(),
            ),
            const SizedBox(height: 24),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFormLabel('Harga'),
                      TextField(
                        controller: hargaC,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: colorOnSurface),
                        decoration: _inputStyle(prefixText: 'Rp '),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFormLabel('Stok'),
                      TextField(
                        controller: stokC,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: colorOnSurface),
                        decoration: _inputStyle(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            _buildFormLabel('Kategori'),
            DropdownButtonFormField<String>(
              value: kategori,
              dropdownColor: colorBackground,
              style: const TextStyle(color: colorOnSurface, fontSize: 14),
              decoration: _inputStyle(),
              icon: const Icon(Icons.expand_more, color: colorOnSurfaceVariant),
              items: const [
                DropdownMenuItem(value: 'Makanan', child: Text('Makanan')),
                DropdownMenuItem(value: 'Minuman', child: Text('Minuman')),
                DropdownMenuItem(value: 'Fashion', child: Text('Fashion')),
              ],
              onChanged: (value) {
                setState(() {
                  kategori = value!;
                });
              },
            ),
            const SizedBox(height: 35),

            Divider(color: Colors.black.withOpacity(0.05), thickness: 1),
            const SizedBox(height: 24),      
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorBackground,
          border: Border(top: BorderSide(color: Colors.black.withOpacity(0.05))),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
          onPressed: isLoading ? null : updateProduct,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorPrimary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: colorPrimary.withOpacity(0.6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
            ),
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                  )
                : const Text(
                    'Update Produk',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
          ),
        ),
      ),
    );
  }
}