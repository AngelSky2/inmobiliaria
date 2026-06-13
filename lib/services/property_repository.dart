import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/property.dart';

class PropertyRepository {
  static Future<List<Property>> getProperties() async {
    final data =
        await rootBundle.loadString('assets/data/properties.json');
    final list = List<Map<String, dynamic>>.from(json.decode(data));
    return list.map((e) => Property.fromApi(e)).toList();
  }
}
