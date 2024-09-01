class Order {
  final int orderID;
  final int? paymentID;
  final int status;
  final int userID;
  final String createdAt;
  final String updatedAt;
  final int productID;
  final String name;
  final String image;
  final int height;
  final int total;
  final int width;
  final int typeProductID;
  final int yearID;
  final int modelID;
  final int companyID;
  final int categoryID;
  final int subcategoryID;
  final int resourceID;
  final String description;
  final String price;
  final int quantity;

  Order({
    required this.orderID,
    required this.quantity,
    this.paymentID,
    required this.total,
    required this.price,
    required this.status,
    required this.userID,
    required this.createdAt,
    required this.updatedAt,
    required this.productID,
    required this.name,
    required this.image,
    required this.height,
    required this.width,
    required this.typeProductID,
    required this.yearID,
    required this.modelID,
    required this.companyID,
    required this.categoryID,
    required this.subcategoryID,
    required this.resourceID,
    required this.description,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderID: json['orderID'],
      quantity: json['quantity_order'],
      price: json['price'],
      total: json['total'],
      paymentID: json['paymentID'],
      status: json['status'],
      userID: json['userID'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      productID: json['productID'],
      name: json['name'],
      image: json['image'],
      height: json['height'],
      width: json['width'],
      typeProductID: json['type_productID'],
      yearID: json['yearID'],
      modelID: json['modelID'],
      companyID: json['companyID'],
      categoryID: json['categoryID'],
      subcategoryID: json['subcategoryID'],
      resourceID: json['resourceID'],
      description: json['description'],
    );
  }
}

class OrdersResponse {
  final Map<int, List<Order>> orders;

  OrdersResponse({required this.orders});

  factory OrdersResponse.fromJson(Map<String, dynamic> json) {
    Map<int, List<Order>> orders = {};

    json['order'].forEach((key, value) {
      List<Order> orderList = [];
      for (var orderJson in value) {
        orderList.add(Order.fromJson(orderJson));
      }
      orders[int.parse(key)] = orderList;
    });

    return OrdersResponse(orders: orders);
  }
}
