class OrderModel {
  final String id;
  final String buyerId;

  final int total;
  final int totalOngkir;
  final int adminFee;
  final int grandTotal;

  final String paymentStatus;
  final String orderStatus;

  final String? midtransOrderId;

  OrderModel({
    required this.id,
    required this.buyerId,
    required this.total,
    required this.totalOngkir,
    required this.adminFee,
    required this.grandTotal,
    required this.paymentStatus,
    required this.orderStatus,
    this.midtransOrderId,
  });

  factory OrderModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OrderModel(
      id: json['id'],
      buyerId: json['buyer_id'],

      total: json['total'] ?? 0,
      totalOngkir:
          json['total_ongkir'] ?? 0,

      adminFee:
          json['admin_fee'] ?? 0,

      grandTotal:
          json['grand_total'] ?? 0,

      paymentStatus:
          json['payment_status'] ??
              'pending',

      orderStatus:
          json['order_status'] ??
              'pending',

      midtransOrderId:
          json['midtrans_order_id'],
    );
  }
}