class Agent {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String photo;

  Agent({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.photo,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      photo: json['photo'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'photo': photo,
    };
  }
}
