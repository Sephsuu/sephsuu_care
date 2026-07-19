import 'package:sephsuu_care/core/api/api_client.dart';

class HealthCatalogService {
  final ApiClient _apiClient;

  HealthCatalogService(this._apiClient);

  Future<List<HealthCatalogItem>> getAllergies() {
    return _apiClient.requestData<List<HealthCatalogItem>>(
      path: '/allergies',
      method: RequestMethod.get,
      fromJson: _itemsFromList,
    );
  }

  Future<List<HealthCatalogItem>> getConditions() {
    return _apiClient.requestData<List<HealthCatalogItem>>(
      path: '/conditions',
      method: RequestMethod.get,
      fromJson: _itemsFromList,
    );
  }

  Future<List<HealthCatalogItem>> getMedications() {
    return _apiClient.requestData<List<HealthCatalogItem>>(
      path: '/medications',
      method: RequestMethod.get,
      fromJson: _itemsFromList,
    );
  }

  static List<HealthCatalogItem> _itemsFromList(dynamic data) {
    if (data is! List) return [];

    return data
        .whereType<Map>()
        .map(HealthCatalogItem.fromJson)
        .where((item) => item.id > 0 && item.name.isNotEmpty)
        .toList();
  }
}

class HealthCatalogItem {
  final int id;
  final String name;

  const HealthCatalogItem({required this.id, required this.name});

  factory HealthCatalogItem.fromJson(Map<dynamic, dynamic> json) {
    return HealthCatalogItem(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse('${json['id']}') ?? 0,
      name: json['name']?.toString().trim() ?? '',
    );
  }
}
