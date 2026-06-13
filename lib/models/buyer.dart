class Buyer {
  final String id;
  final String name;
  final String email;
  final String phone;
  final DateTime registeredAt;

  Buyer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    DateTime? registeredAt,
  }) : registeredAt = registeredAt ?? DateTime.now();

  factory Buyer.fromJson(Map<String, dynamic> json) {
    return Buyer(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      registeredAt: DateTime.parse(json['registeredAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'registeredAt': registeredAt.toIso8601String(),
    };
  }
}
