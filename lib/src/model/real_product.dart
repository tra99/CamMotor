class RealProductModel {
  final int productId;
  final String name;
  final String img;
  final String price;
  final int qty;
  final int original_price;
  final int wholesale_price;
  final int instock;
  final int discount;
  final int amount_discount;
  final int newProduct;
  final int type_productID;
  final int yearID;
  final int modelID;
  final int companyID;
  final int categoryID;
  final int subcategoryID ;
  final int? resourceID;

  factory RealProductModel.fromJson(Map<String, dynamic> json) {
    return RealProductModel(
      productId: json["id"],
      name: json["name"],
      img: json["image"],
      price: json["price"],
      qty: json["quantity"],
      original_price: json["original_price"],
      wholesale_price: json["wholesale_price"],
      instock: json["sold_out"],
      discount: json["discount"],
      amount_discount: json["amount_discount"],
      newProduct: json["new"],
      type_productID: json["type_productID"],
      yearID: json["yearID"],
      modelID: json["modelID"],
      companyID: json["companyID"],
      categoryID: json["categoryID"],
      subcategoryID : json["subcategoryID"],
      resourceID: json["resourceID"],
    );
  }

  RealProductModel({
    required this.productId,
    required this.name,
    required this.img,
    required this.price,
    required this.qty,
    required this.original_price,
    required this.wholesale_price,
    required this.instock,
    required this.discount,
    required this.amount_discount,
    required this.newProduct,
    required this.type_productID,
    required this.yearID,
    required this.modelID,
    required this.companyID,
    required this.categoryID,
    required this.subcategoryID ,
    required this.resourceID,
  });
}
