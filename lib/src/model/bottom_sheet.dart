class Student {
  final int id;
  final String name;
  final String icons;
  final String createdAt;
  final String updatedAt;

  Student({
    required this.id,
    required this.name,
    required this.icons,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      icons: json['icons'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
