import 'package:sephsuu_care/core/api/api_client.dart';

class UserService {
  final ApiClient _apiClient;

  UserService(this._apiClient);

  Future<void> createAllergy(int allergyId, {bool isActive = true}) {
    return _createHealthRecord(
      path: '/users/me/allergies',
      idKey: 'allergy_id',
      id: allergyId,
      isActive: isActive,
    );
  }

  Future<void> createCondition(int conditionId, {bool isActive = true}) {
    return _createHealthRecord(
      path: '/users/me/conditions',
      idKey: 'condition_id',
      id: conditionId,
      isActive: isActive,
    );
  }

  Future<void> createMedication(int medicationId, {bool isActive = true}) {
    return _createHealthRecord(
      path: '/users/me/medications',
      idKey: 'medication_id',
      id: medicationId,
      isActive: isActive,
    );
  }

  Future<void> replaceAllergies(
    Iterable<int> allergyIds, {
    bool isActive = true,
  }) {
    return _replaceHealthRecords(
      path: '/users/me/allergies',
      idsKey: 'allergy_ids',
      ids: allergyIds,
      isActive: isActive,
    );
  }

  Future<void> replaceConditions(
    Iterable<int> conditionIds, {
    bool isActive = true,
  }) {
    return _replaceHealthRecords(
      path: '/users/me/conditions',
      idsKey: 'condition_ids',
      ids: conditionIds,
      isActive: isActive,
    );
  }

  Future<void> replaceMedications(
    Iterable<int> medicationIds, {
    bool isActive = true,
  }) {
    return _replaceHealthRecords(
      path: '/users/me/medications',
      idsKey: 'medication_ids',
      ids: medicationIds,
      isActive: isActive,
    );
  }

  Future<void> _createHealthRecord({
    required String path,
    required String idKey,
    required int id,
    required bool isActive,
  }) async {
    await _apiClient.request<Object?>(
      path: path,
      method: RequestMethod.post,
      body: {idKey: id, 'is_active': isActive},
    );
  }

  Future<void> _replaceHealthRecords({
    required String path,
    required String idsKey,
    required Iterable<int> ids,
    required bool isActive,
  }) async {
    await _apiClient.request<Object?>(
      path: path,
      method: RequestMethod.put,
      body: {idsKey: ids.toSet().toList(), 'is_active': isActive},
    );
  }
}
