class SubCategoryModel {
  final int id;
  final String name;
  final String image;
  final int categoryID;

  SubCategoryModel({
    required this.id,
    required this.name,
    required this.categoryID,
    required this.image
  });
  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json["id"],
      name: json["name"],
      categoryID: json["categoryID"],
      image:json["image"]
    );
  }
}