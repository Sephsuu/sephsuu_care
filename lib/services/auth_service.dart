import 'package:sephsuu_care/core/api/api_client.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String username,
    required String email,
    required String dateOfBirth,
    required String gender,
    String role = 'patient',
    String? contactNumber,
  }) async {
    final data = await _apiClient.requestData<Map<String, dynamic>>(
      path: '/auth/register',
      method: RequestMethod.post,
      withAuth: false,
      body: {
        'full_name': fullName,
        'username': username,
        'email': email,
        'role': role.toUpperCase(),
        'contact_number': contactNumber,
        'date_of_birth': dateOfBirth,
        'gender': gender,
      },
      fromJson: (data) => Map<String, dynamic>.from(data as Map),
    );

    await _saveTokens(data);
    return data;
  }

  Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
  }) async {
    final data = await _apiClient.requestData<Map<String, dynamic>>(
      path: '/auth/login',
      method: RequestMethod.post,
      withAuth: false,
      body: {'identifier': identifier, 'password': password},
      fromJson: (data) => Map<String, dynamic>.from(data as Map),
    );

    await _saveTokens(data);
    return data;
  }

  Future<void> _saveTokens(Map<String, dynamic> data) async {
    final accessToken = data['access_token']?.toString();
    final refreshToken = data['refresh_token']?.toString();

    if (accessToken == null || refreshToken == null) return;

    final expiresIn = data['expires_in'];

    await _apiClient.saveAuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: data['token_type']?.toString(),
      expiresIn: expiresIn is int ? expiresIn : int.tryParse('$expiresIn'),
    );
  }
}
