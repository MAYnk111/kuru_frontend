import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_client.dart';
import '../models/application_model.dart';

class ApplicationRepository {
  final ApiClient _client;

  ApplicationRepository({ApiClient? client}) : _client = client ?? ApiClient();

  Future<ApplicationsDataWrapper> getApplications() async {
    final response = await _client.get(ApiConfig.applications);
    if (response.data is Map<String, dynamic>) {
      return ApplicationsDataWrapper.fromJson(response.data as Map<String, dynamic>);
    }
    throw Exception('Malformed applications data from server');
  }

  Future<bool> tailorResumeForRole({
    required String targetRole,
    required String targetCompany,
  }) async {
    final response = await _client.post(
      ApiConfig.resumeTailor,
      data: {
        'target_role': targetRole,
        'target_company': targetCompany,
      },
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }
}
