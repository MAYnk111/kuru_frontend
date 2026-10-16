import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_client.dart';
import '../models/growth_models.dart';

class GrowthRepository {
  final ApiClient _client;

  GrowthRepository({ApiClient? client}) : _client = client ?? ApiClient();

  Future<List<DailyGoalModel>> getDailyGoals() async {
    final response = await _client.get(ApiConfig.growthGoals);
    if (response.data is List) {
      return (response.data as List)
          .map((e) => DailyGoalModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<bool> updateGoalStatus(String goalId, bool isCompleted) async {
    final response = await _client.patch(
      ApiConfig.growthGoal(goalId),
      data: {'is_completed': isCompleted},
    );
    return response.statusCode == 200;
  }

  Future<RoadmapModel> getRoadmap() async {
    final response = await _client.get(ApiConfig.growthRoadmap);
    if (response.data is Map<String, dynamic>) {
      return RoadmapModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw Exception('Malformed roadmap data received from backend');
  }

  Future<List<LearningResourceModel>> getResources({String? skill}) async {
    final response = await _client.get(
      ApiConfig.growthResources,
      queryParameters: skill != null ? {'skill': skill} : null,
    );
    if (response.data is List) {
      return (response.data as List)
          .map((e) => LearningResourceModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<List<ProjectRecommendationModel>> getProjects() async {
    final response = await _client.get(ApiConfig.growthProjects);
    if (response.data is List) {
      return (response.data as List)
          .map((e) => ProjectRecommendationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
