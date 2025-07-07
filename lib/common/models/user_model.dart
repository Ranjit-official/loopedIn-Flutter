class UserModel {
  final String id;
  final String name;
  final String title;
  final String company;
  final String industry;
  final String experience;
  final String description;
  final List<String> topics;
  final double angle;
  final double radius;
  final int color;

  UserModel({
    required this.id,
    required this.name,
    required this.title,
    required this.company,
    required this.industry,
    required this.experience,
    required this.description,
    required this.topics,
    required this.angle,
    required this.radius,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'company': company,
      'industry': industry,
      'experience': experience,
      'description': description,
      'topics': topics,
      'angle': angle,
      'radius': radius,
      'color': color,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      title: map['title'] ?? '',
      company: map['company'] ?? '',
      industry: map['industry'] ?? '',
      experience: map['experience'] ?? '',
      description: map['description'] ?? '',
      topics: List<String>.from(map['topics'] ?? []),
      angle: map['angle']?.toDouble() ?? 0.0,
      radius: map['radius']?.toDouble() ?? 0.0,
      color: map['color']?.toInt() ?? 0,
    );
  }
}
