import 'dart:convert';

import 'package:sephsuu_care/core/sync/models/pending_operation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SyncQueueService {
  static const String _key = 'pending_operations';

  Future<List<PendingOperation>> getPendingOperations() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    if (raw == null) return [];

    final List decoded = jsonDecode(raw);

    return decoded
        .map((item) => PendingOperation.fromJson(item))
        .toList();
  }

  Future<void> addOperation(PendingOperation operation) async {
    final prefs = await SharedPreferences.getInstance();
    final operations = await getPendingOperations();

    operations.add(operation);

    final encoded = jsonEncode(
      operations.map((item) => item.toJson()).toList(),
    );

    await prefs.setString(_key, encoded);
  }

  Future<void> removeOperation(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final operations = await getPendingOperations();

    operations.removeWhere((item) => item.id == id);

    final encoded = jsonEncode(
      operations.map((item) => item.toJson()).toList(),
    );

    await prefs.setString(_key, encoded);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}