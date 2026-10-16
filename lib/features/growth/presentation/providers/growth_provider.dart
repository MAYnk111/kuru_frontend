import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/growth_models.dart';
import '../../data/repositories/growth_repository.dart';

final growthRepositoryProvider = Provider<GrowthRepository>((ref) {
  return GrowthRepository();
});

class GrowthState {
  final bool isLoading;
  final String? errorMessage;
  final String activeTab; // 'Today', 'Roadmap', 'Resources'
  final List<DailyGoalModel> goals;
  final RoadmapModel? roadmap;
  final List<LearningResourceModel> resources;
  final List<ProjectRecommendationModel> projects;
  final String selectedResourceFilter;

  GrowthState({
    this.isLoading = false,
    this.errorMessage,
    this.activeTab = 'Today',
    this.goals = const [],
    this.roadmap,
    this.resources = const [],
    this.projects = const [],
    this.selectedResourceFilter = 'All',
  });

  int get completedGoalsCount => goals.where((g) => g.isCompleted).length;
  int get totalGoalsCount => goals.length;
  double get goalsProgress => totalGoalsCount == 0 ? 0 : completedGoalsCount / totalGoalsCount;

  GrowthState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? activeTab,
    List<DailyGoalModel>? goals,
    RoadmapModel? roadmap,
    List<LearningResourceModel>? resources,
    List<ProjectRecommendationModel>? projects,
    String? selectedResourceFilter,
  }) {
    return GrowthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      activeTab: activeTab ?? this.activeTab,
      goals: goals ?? this.goals,
      roadmap: roadmap ?? this.roadmap,
      resources: resources ?? this.resources,
      projects: projects ?? this.projects,
      selectedResourceFilter: selectedResourceFilter ?? this.selectedResourceFilter,
    );
  }
}

class GrowthNotifier extends Notifier<GrowthState> {
  late final GrowthRepository _repository;

  @override
  GrowthState build() {
    _repository = ref.watch(growthRepositoryProvider);
    Future.microtask(() => loadAllGrowthData());
    return GrowthState(isLoading: true);
  }

  Future<void> loadAllGrowthData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final goals = await _repository.getDailyGoals();
      final roadmap = await _repository.getRoadmap();
      final resources = await _repository.getResources();
      final projects = await _repository.getProjects();

      state = state.copyWith(
        isLoading: false,
        goals: goals,
        roadmap: roadmap,
        resources: resources,
        projects: projects,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void setActiveTab(String tab) {
    state = state.copyWith(activeTab: tab);
  }

  void setResourceFilter(String filter) {
    state = state.copyWith(selectedResourceFilter: filter);
  }

  Future<void> toggleGoal(String goalId) async {
    final originalGoals = state.goals;
    final currentGoal = originalGoals.firstWhere((g) => g.id == goalId);
    final targetState = !currentGoal.isCompleted;

    // Optimistic UI update
    final updatedList = originalGoals.map((g) {
      if (g.id == goalId) return g.copyWith(isCompleted: targetState);
      return g;
    }).toList();
    state = state.copyWith(goals: updatedList);

    try {
      final success = await _repository.updateGoalStatus(goalId, targetState);
      if (!success) {
        // Rollback
        state = state.copyWith(goals: originalGoals);
      }
    } catch (_) {
      // Rollback on error
      state = state.copyWith(goals: originalGoals);
    }
  }
}

final growthNotifierProvider =
    NotifierProvider<GrowthNotifier, GrowthState>(GrowthNotifier.new);
