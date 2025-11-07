import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/experience_repository.dart';
import '../../data/models/experience_model.dart';

final experienceProvider =
StateNotifierProvider<ExperienceNotifier, ExperienceState>(
        (ref) => ExperienceNotifier(ExperienceRepository()));

class ExperienceState {
  final List<Experience> experiences;
  final Set<int> selectedIds;
  final String description;
  final bool isLoading;

  ExperienceState({
    this.experiences = const [],
    this.selectedIds = const {},
    this.description = '',
    this.isLoading = false,
  });

  ExperienceState copyWith({
    List<Experience>? experiences,
    Set<int>? selectedIds,
    String? description,
    bool? isLoading,
  }) {
    return ExperienceState(
      experiences: experiences ?? this.experiences,
      selectedIds: selectedIds ?? this.selectedIds,
      description: description ?? this.description,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ExperienceNotifier extends StateNotifier<ExperienceState> {
  final ExperienceRepository repo;
  ExperienceNotifier(this.repo) : super(ExperienceState()) {
    loadExperiences();
  }

  Future<void> loadExperiences() async {
    state = state.copyWith(isLoading: true);
    final data = await repo.getExperiences();
    state = state.copyWith(experiences: data, isLoading: false);
  }

  void toggleSelection(int id) {
    final newIds = {...state.selectedIds};
    newIds.contains(id) ? newIds.remove(id) : newIds.add(id);
    state = state.copyWith(selectedIds: newIds);
  }

  void updateDescription(String text) {
    state = state.copyWith(description: text);
  }
}
