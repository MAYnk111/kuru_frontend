import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_client.dart';
import '../models/job_model.dart';

class JobRepository {
  final ApiClient _client;

  JobRepository({ApiClient? client}) : _client = client ?? ApiClient();

  Future<List<JobModel>> getJobs({
    String? filter,
    String? searchQuery,
    String? location,
  }) async {
    final queryParams = <String, dynamic>{};
    if (filter != null && filter != 'For You') queryParams['type'] = filter;
    if (searchQuery != null && searchQuery.isNotEmpty) queryParams['q'] = searchQuery;
    if (location != null && location.isNotEmpty) queryParams['location'] = location;

    final response = await _client.get(
      ApiConfig.jobs,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    if (response.data is List) {
      return (response.data as List)
          .map((item) => JobModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else if (response.data is Map && response.data['jobs'] is List) {
      return (response.data['jobs'] as List)
          .map((item) => JobModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return [];
  }

  Future<JobModel> getJobById(String id) async {
    final response = await _client.get(ApiConfig.jobDetail(id));
    if (response.data is Map<String, dynamic>) {
      return JobModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw Exception('Malformed job details response from server');
  }

  Future<bool> toggleSaveJob(String id, bool currentSavedState) async {
    try {
      await _client.post(
        '${ApiConfig.jobDetail(id)}/save',
        data: {'saved': !currentSavedState},
      );
      return !currentSavedState;
    } catch (_) {
      // Return toggled state optimistically or error
      return !currentSavedState;
    }
  }
}
