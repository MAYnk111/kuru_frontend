import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/career_assessment_model.dart';
import '../../data/repositories/career_twin_repository.dart';

final careerTwinRepositoryProvider = Provider<CareerTwinRepository>((ref) {
  return CareerTwinRepository();
});

class CareerTwinState {
  final bool isLoading;
  final String? errorMessage;
  final CareerAssessmentModel? assessment;
  final String selectedSubTab; // 'Overview', 'Skills', 'Projects', 'Simulate'

  CareerTwinState({
    this.isLoading = false,
    this.errorMessage,
    this.assessment,
    this.selectedSubTab = 'Overview',
  });

  CareerTwinState copyWith({
    bool? isLoading,
    String? errorMessage,
    CareerAssessmentModel? assessment,
    String? selectedSubTab,
  }) {
    return CareerTwinState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      assessment: assessment ?? this.assessment,
      selectedSubTab: selectedSubTab ?? this.selectedSubTab,
    );
  }
}

class CareerTwinNotifier extends Notifier<CareerTwinState> {
  late final CareerTwinRepository _repository;

  @override
  CareerTwinState build() {
    _repository = ref.watch(careerTwinRepositoryProvider);
    Future.microtask(() => loadAssessment());
    return CareerTwinState(isLoading: true);
  }

  Future<void> loadAssessment() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final assessment = await _repository.getCareerAssessment();
      state = state.copyWith(isLoading: false, assessment: assessment);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void setSubTab(String tab) {
    state = state.copyWith(selectedSubTab: tab);
  }

  Future<void> triggerReassessment() async {
    try {
      await _repository.requestReassessment();
      await loadAssessment();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}

final careerTwinNotifierProvider =
    NotifierProvider<CareerTwinNotifier, CareerTwinState>(CareerTwinNotifier.new);
