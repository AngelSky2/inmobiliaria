enum ReservationStatus {
  confirmed,
  cancelled,
  completed;

  String get label {
    switch (this) {
      case ReservationStatus.confirmed:
        return 'Confirmada';
      case ReservationStatus.cancelled:
        return 'Cancelada';
      case ReservationStatus.completed:
        return 'Completada';
    }
  }
}

class Reservation {
  final String id;
  final String buyerId;
  final String propertyId;
  final String agentId;
  final DateTime date;
  final String time;
  final ReservationStatus status;
  final DateTime createdAt;

  Reservation({
    required this.id,
    required this.buyerId,
    required this.propertyId,
    required this.agentId,
    required this.date,
    required this.time,
    this.status = ReservationStatus.confirmed,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Reservation copyWith({
    String? id,
    String? buyerId,
    String? propertyId,
    String? agentId,
    DateTime? date,
    String? time,
    ReservationStatus? status,
    DateTime? createdAt,
  }) {
    return Reservation(
      id: id ?? this.id,
      buyerId: buyerId ?? this.buyerId,
      propertyId: propertyId ?? this.propertyId,
      agentId: agentId ?? this.agentId,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] as String,
      buyerId: json['buyerId'] as String,
      propertyId: json['propertyId'] as String,
      agentId: json['agentId'] as String,
      date: DateTime.parse(json['date'] as String),
      time: json['time'] as String,
      status: ReservationStatus.values.firstWhere(
        (e) => e.name == json['status'],
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyerId': buyerId,
      'propertyId': propertyId,
      'agentId': agentId,
      'date': date.toIso8601String().split('T').first,
      'time': time,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
