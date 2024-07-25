// model.dart
class Model {
  final int id;
  final String nameModel;
  final String createdAt;
  final String image;
  final int companyID;

  Model({
    required this.id,
    required this.nameModel,
    required this.createdAt,
    required this.image,
    required this.companyID
  });

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      id: json['id'],
      nameModel: json['name_model'],
      createdAt: json['created_at'],
      image: json["image"],
      companyID:json["companyID"]
    );
  }
}
