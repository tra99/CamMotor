class PropertyModel {
  final int id;
  final int value;
  final int pathID;
  final int resourceID;

  PropertyModel({
    required this.id,
    required this.value,
    required this.pathID,
    required this.resourceID,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json["id"],
      value: json["value"],
      pathID: json["pathID"],
      resourceID: json["resourceID"]
    );
  }
}