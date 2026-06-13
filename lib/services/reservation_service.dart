import '../models/buyer.dart';
import '../models/property.dart';
import '../models/agent.dart';
import '../models/reservation.dart';
import 'json_service.dart';
import 'property_repository.dart';

class ReservationService {
  static Future<List<Property>> getProperties() async {
    return PropertyRepository.getProperties();
  }

  static Future<List<Agent>> getAgents() async {
    final data = await JsonService.readAgents();
    return data.map((e) => Agent.fromJson(e)).toList();
  }

  static Future<List<Buyer>> getBuyers() async {
    final data = await JsonService.readBuyers();
    return data.map((e) => Buyer.fromJson(e)).toList();
  }

  static Future<Buyer> saveBuyer(Buyer buyer) async {
    final buyers = await getBuyers();
    buyers.add(buyer);
    await JsonService.writeBuyers(buyers.map((e) => e.toJson()).toList());
    return buyer;
  }

  static Future<List<Reservation>> getReservations() async {
    final data = await JsonService.readReservations();
    return data.map((e) => Reservation.fromJson(e)).toList();
  }

  static Future<List<Reservation>> getReservationsByBuyer(
      String buyerId) async {
    final reservations = await getReservations();
    return reservations.where((r) => r.buyerId == buyerId).toList();
  }

  static Future<Reservation> createReservation(
      Reservation reservation) async {
    final reservations = await getReservations();
    reservations.add(reservation);
    await JsonService.writeReservations(
        reservations.map((e) => e.toJson()).toList());
    return reservation;
  }

  static Future<Reservation> updateReservation(
      Reservation updated) async {
    final reservations = await getReservations();
    final index = reservations.indexWhere((r) => r.id == updated.id);
    if (index != -1) {
      reservations[index] = updated;
      await JsonService.writeReservations(
          reservations.map((e) => e.toJson()).toList());
    }
    return updated;
  }

  static Future<void> cancelReservation(String id) async {
    final reservations = await getReservations();
    final index = reservations.indexWhere((r) => r.id == id);
    if (index != -1) {
      reservations[index] = reservations[index]
          .copyWith(status: ReservationStatus.cancelled);
      await JsonService.writeReservations(
          reservations.map((e) => e.toJson()).toList());
    }
  }

  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
