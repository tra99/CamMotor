class BikeModel {
  final int id;
  final String nameModel;
  final String image;
  final int companyID;

  BikeModel({
    required this.id,
    required this.nameModel,
    required this.image,
    required this.companyID
  });
  factory BikeModel.fromJson(Map<String, dynamic> json) {
    return BikeModel(
      id: json["id"],
      nameModel: json["name_model"],
      image: json["image"],
      companyID:json["companyID"]
    );
  }
}
class YearModel {
  final int id;
  final String year;
  final int modelId;
  final int companyID;

  YearModel({
    required this.id,
    required this.year,
    required this.modelId,
    required this.companyID
  });
  factory YearModel.fromJson(Map<String, dynamic> json) {
    return YearModel(
      id: json["id"],
      year: json["year"],
      modelId: json["modelID"],
      companyID:json["companyID"]
    );
  }
}

