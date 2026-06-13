import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/property.dart';
import 'api_service.dart';

class PropertyRepository {
  static String? _cachePath;

  static Future<void> init() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      _cachePath = '${dir.path}/properties_cache.json';
    } catch (_) {
      final home = Platform.environment['HOME'] ?? '/tmp';
      final fallback = '$home/.cache/inmobiliaria';
      await Directory(fallback).create(recursive: true);
      _cachePath = '$fallback/properties_cache.json';
    }
  }

  static Future<List<Property>> getProperties() async {
    try {
      final apiData = await ApiService.fetchAllProperties();
      if (apiData.isNotEmpty) {
        if (_cachePath != null) {
          await File(_cachePath!).writeAsString(json.encode(apiData));
        }
        return apiData.map((e) => Property.fromApi(e)).toList();
      }
    } catch (_) {}

    try {
      if (_cachePath != null) {
        final cacheFile = File(_cachePath!);
        if (await cacheFile.exists()) {
          final data = await cacheFile.readAsString();
          final list = List<Map<String, dynamic>>.from(json.decode(data));
          return list.map((e) => Property.fromApi(e)).toList();
        }
      }
    } catch (_) {}

    final bundleData =
        await rootBundle.loadString('assets/data/properties.json');
    final list = List<Map<String, dynamic>>.from(json.decode(bundleData));
    return list.map((e) => Property.fromJson(e)).toList();
  }
}
