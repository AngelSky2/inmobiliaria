import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class JsonService {
  static late String _documentsPath;

  static Future<void> init() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      _documentsPath = dir.path;
    } catch (_) {
      final home = Platform.environment['HOME'] ?? '/tmp';
      _documentsPath = '$home/.cache/inmobiliaria';
      await Directory(_documentsPath).create(recursive: true);
    }
  }

  static String get _buyersPath => '$_documentsPath/buyers.json';
  static String get _reservationsPath => '$_documentsPath/reservations.json';

  static Future<void> _ensureFileExists(String path, String defaultValue) async {
    final file = File(path);
    if (!await file.exists()) {
      await file.writeAsString(defaultValue);
    }
  }

  static Future<List<Map<String, dynamic>>> readBuyers() async {
    await _ensureFileExists(_buyersPath, '[]');
    final data = await File(_buyersPath).readAsString();
    return List<Map<String, dynamic>>.from(json.decode(data) as List);
  }

  static Future<void> writeBuyers(List<Map<String, dynamic>> buyers) async {
    await File(_buyersPath).writeAsString(json.encode(buyers));
  }

  static Future<List<Map<String, dynamic>>> readReservations() async {
    await _ensureFileExists(_reservationsPath, '[]');
    final data = await File(_reservationsPath).readAsString();
    return List<Map<String, dynamic>>.from(json.decode(data) as List);
  }

  static Future<void> writeReservations(
      List<Map<String, dynamic>> reservations) async {
    await File(_reservationsPath).writeAsString(json.encode(reservations));
  }

  static Future<List<Map<String, dynamic>>> readProperties() async {
    final data =
        await rootBundle.loadString('assets/data/properties.json');
    return List<Map<String, dynamic>>.from(json.decode(data) as List);
  }

  static Future<List<Map<String, dynamic>>> readAgents() async {
    final data =
        await rootBundle.loadString('assets/data/agents.json');
    return List<Map<String, dynamic>>.from(json.decode(data) as List);
  }
}
