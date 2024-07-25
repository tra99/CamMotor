class CompanyLogo {
  final int id;
  final String nameCompany;
  final String image;
  final int height;
  final int width;
  late final int typeProductID;
  final String createdAt;
  final String updatedAt;

  CompanyLogo({
    required this.id,
    required this.nameCompany,
    required this.image,
    required this.height,
    required this.width,
    required this.typeProductID,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CompanyLogo.fromJson(Map<String, dynamic> json) {
    return CompanyLogo(
      id: json['id'],
      nameCompany: json['name_company'],
      image: json['image'],
      height: json['height'],
      width: json['width'],
      typeProductID: json['type_productID'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
