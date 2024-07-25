class PathModel {
  final int id;
  final String property;
  final String standart;

  PathModel({
    required this.id,
    required this.property,
    required this.standart,
  });

  factory PathModel.fromJson(Map<String, dynamic> json) {
    return PathModel(
      id: json["id"],
      property: json["property"],
      standart: json["standart"],
    );
  }
}