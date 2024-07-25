class ResourceModel {
  final int id;
  final String description;
  final String image;

  ResourceModel({
    required this.id,
    required this.description,
    required this.image
  });
  factory ResourceModel.fromJson(Map<String, dynamic> json) {
    return ResourceModel(
      id: json["id"],
      description: json["description"],
      image:json["icons"]
    );
  }
}