import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_client.dart';
import '../models/career_assessment_model.dart';

class CareerTwinRepository {
  final ApiClient _client;

  CareerTwinRepository({ApiClient? client}) : _client = client ?? ApiClient();

  Future<CareerAssessmentModel> getCareerAssessment() async {
    final response = await _client.get(ApiConfig.careerTwin);
    if (response.data is Map<String, dynamic>) {
      return CareerAssessmentModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw Exception('Malformed career twin data received from backend');
  }

  Future<bool> connectGitHub(String username) async {
    final response = await _client.post(
      ApiConfig.githubConnect,
      data: {'github_username': username},
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<void> requestReassessment() async {
    await _client.post(ApiConfig.careerTwinAssess);
  }
}
