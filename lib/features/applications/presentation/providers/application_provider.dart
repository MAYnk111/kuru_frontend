import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/application_model.dart';
import '../../data/repositories/application_repository.dart';

final applicationRepositoryProvider = Provider<ApplicationRepository>((ref) {
  return ApplicationRepository();
});

class ApplicationState {
  final bool isLoading;
  final String? errorMessage;
  final String activeTab; // 'Overview', 'Resumes', 'Activity'
  final ApplicationMetrics? metrics;
  final List<ApplicationModel> applications;

  ApplicationState({
    this.isLoading = false,
    this.errorMessage,
    this.activeTab = 'Overview',
    this.metrics,
    this.applications = const [],
  });

  ApplicationState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? activeTab,
    ApplicationMetrics? metrics,
    List<ApplicationModel>? applications,
  }) {
    return ApplicationState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      activeTab: activeTab ?? this.activeTab,
      metrics: metrics ?? this.metrics,
      applications: applications ?? this.applications,
    );
  }
}

class ApplicationNotifier extends Notifier<ApplicationState> {
  late final ApplicationRepository _repository;

  @override
  ApplicationState build() {
    _repository = ref.watch(applicationRepositoryProvider);
    Future.microtask(() => loadApplications());
    return ApplicationState(isLoading: true);
  }

  Future<void> loadApplications() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final data = await _repository.getApplications();
      state = state.copyWith(
        isLoading: false,
        metrics: data.metrics,
        applications: data.activeApplications,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void setActiveTab(String tab) {
    state = state.copyWith(activeTab: tab);
  }
}

final applicationNotifierProvider =
    NotifierProvider<ApplicationNotifier, ApplicationState>(ApplicationNotifier.new);
