class OrderDetailModel {
  final int id;
  final int total;
  final String status;
  final int userID;
  final int orderId;
  final String paymentID;
  final String createdAt;
  final String updatedAt;

  OrderDetailModel({
    required this.id,
    required this.total,
    required this.status,
    required this.userID,
    required this.paymentID,
    required this.createdAt,
    required this.updatedAt,
    required this.orderId,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      id: json['id'],
      total: json['total'],
      status: json['status'],
      userID: json['userID'],
      paymentID: json['paymentID'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      orderId: json['orderId'],
    );
  }
}
