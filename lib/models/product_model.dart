class OrderModel {
  final String id;
  final String buyerId;

  final int total;
  final int totalOngkir;
  final int adminFee;
  final int grandTotal;

  final String paymentStatus;
  final String orderStatus;

  final String? snapToken;
  final String? snapUrl;

  OrderModel({
    required this.id,
    required this.buyerId,
    required this.total,
    required this.totalOngkir,
    required this.adminFee,
    required this.grandTotal,
    required this.paymentStatus,
    required this.orderStatus,
    this.snapToken,
    this.snapUrl,
  });

  factory OrderModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OrderModel(
      id: json['id'],
      buyerId: json['buyer_id'],

      total:
          (json['total'] ?? 0)
              .toInt(),

      totalOngkir:
          (json['total_ongkir'] ?? 0)
              .toInt(),

      adminFee:
          (json['admin_fee'] ?? 0)
              .toInt(),

      grandTotal:
          (json['grand_total'] ?? 0)
              .toInt(),

      paymentStatus:
          json['payment_status'] ??
          '',

      orderStatus:
          json['order_status'] ??
          '',

      snapToken:
          json['snap_token'],

      snapUrl:
          json['snap_url'],
    );
  }
}