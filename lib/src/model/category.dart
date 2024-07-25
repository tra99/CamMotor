class CategoryModel {
  final int id;
  final String name;
  final int yearID;
  final String image;

  CategoryModel({
    required this.id,
    required this.name,
    required this.yearID,
    required this.image
  });
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json["id"],
      name: json["name"],
      yearID: json["yearID"],
      image:json["image"]
    );
  }
}