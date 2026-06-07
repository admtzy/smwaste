class OrderItemModel {
  final String id;

  final String orderId;
  final String sellerId;
  final String productId;

  final String namaProduk;

  final String imageUrl;

  final int qty;
  final int harga;
  final int subtotal;

  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.sellerId,
    required this.productId,
    required this.namaProduk,
    required this.imageUrl,
    required this.qty,
    required this.harga,
    required this.subtotal,
  });

  factory OrderItemModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OrderItemModel(
      id: json['id'],
      orderId: json['order_id'],
      sellerId: json['seller_id'],
      productId: json['product_id'],

      namaProduk:
          json['nama_produk'] ??
          '',

      imageUrl:
          json['image_url'] ??
          '',

      qty:
          (json['qty'] ?? 0)
              .toInt(),

      harga:
          (json['harga'] ?? 0)
              .toInt(),

      subtotal:
          (json['subtotal'] ?? 0)
              .toInt(),
    );
  }
}