import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/job_model.dart';
import '../../data/repositories/job_repository.dart';

final jobRepositoryProvider = Provider<JobRepository>((ref) {
  return JobRepository();
});

class JobState {
  final bool isLoading;
  final String? errorMessage;
  final List<JobModel> jobs;
  final String selectedFilter;
  final String searchQuery;

  JobState({
    this.isLoading = false,
    this.errorMessage,
    this.jobs = const [],
    this.selectedFilter = 'For You',
    this.searchQuery = '',
  });

  JobState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<JobModel>? jobs,
    String? selectedFilter,
    String? searchQuery,
  }) {
    return JobState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      jobs: jobs ?? this.jobs,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class JobNotifier extends Notifier<JobState> {
  late final JobRepository _repository;

  @override
  JobState build() {
    _repository = ref.watch(jobRepositoryProvider);
    Future.microtask(() => loadJobs());
    return JobState(isLoading: true);
  }

  Future<void> loadJobs() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final jobs = await _repository.getJobs(
        filter: state.selectedFilter,
        searchQuery: state.searchQuery,
      );
      state = state.copyWith(isLoading: false, jobs: jobs);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void setFilter(String filter) {
    if (state.selectedFilter != filter) {
      state = state.copyWith(selectedFilter: filter);
      loadJobs();
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    loadJobs();
  }

  void toggleSaveJob(String id) {
    final updatedList = state.jobs.map((job) {
      if (job.id == id) {
        final newSaved = !job.isSaved;
        _repository.toggleSaveJob(id, job.isSaved);
        return job.copyWith(isSaved: newSaved);
      }
      return job;
    }).toList();
    state = state.copyWith(jobs: updatedList);
  }
}

final jobNotifierProvider =
    NotifierProvider<JobNotifier, JobState>(JobNotifier.new);

final jobDetailProvider =
    FutureProvider.family<JobModel, String>((ref, id) async {
  final repo = ref.watch(jobRepositoryProvider);
  return await repo.getJobById(id);
});
