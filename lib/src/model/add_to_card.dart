class AddToCardModel {
  final int id;
  final int quantity_order;
  final int total;
  final int orderID;
  final String createdAt;
  final String updatedAt;

  AddToCardModel({
    required this.id,
    required this.quantity_order,
    required this.total,
    required this.orderID,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AddToCardModel.fromJson(Map<String, dynamic> json) {
    return AddToCardModel(
      id: json['id'],
      quantity_order: json['quantity_order'],
      total: json['total'],
      orderID: json['orderID'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
