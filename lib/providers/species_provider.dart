import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// 🌊 Main broad categories
enum SpeciesCategory { fish, prawns }

extension SpeciesCategoryExt on SpeciesCategory {
  String get label => this == SpeciesCategory.fish ? 'Fish' : 'Prawns';
  double get doThreshold => this == SpeciesCategory.fish ? 5.0 : 4.0;
}

/// 🐟 Detailed farmed species found in India
class Species {
  final String label;
  final double doThreshold;
  final SpeciesCategory category;

  const Species({
    required this.label,
    required this.doThreshold,
    required this.category,
  });

  // Common DO thresholds for major aquaculture species (mg/L)
  static const Map<String, Species> speciesData = {
    'Rohu': Species(label: 'Rohu', doThreshold: 5.0, category: SpeciesCategory.fish),
    'Catla': Species(label: 'Catla', doThreshold: 5.0, category: SpeciesCategory.fish),
    'Tilapia': Species(label: 'Tilapia', doThreshold: 4.5, category: SpeciesCategory.fish),
    'Catfish': Species(label: 'Catfish', doThreshold: 4.0, category: SpeciesCategory.fish),
    'Prawn': Species(label: 'Prawn', doThreshold: 3.5, category: SpeciesCategory.prawns),
    'Shrimp': Species(label: 'Shrimp', doThreshold: 3.0, category: SpeciesCategory.prawns),
    'Mrigal': Species(label: 'Mrigal', doThreshold: 5.0, category: SpeciesCategory.fish),
    'Common Carp': Species(label: 'Common Carp', doThreshold: 4.5, category: SpeciesCategory.fish),
  };
}

/// 🧠 Single species provider (used for one active selection)
class SpeciesNotifier extends StateNotifier<Species> {
  SpeciesNotifier()
      : super(const Species(
    label: 'Rohu',
    doThreshold: 5.0,
    category: SpeciesCategory.fish,
  ));

  void setSpeciesFromLabel(String label) {
    state = Species.speciesData[label] ??
        const Species(label: 'Unknown', doThreshold: 4.0, category: SpeciesCategory.fish);
  }

  void setCategory(SpeciesCategory category) {
    state = category == SpeciesCategory.fish
        ? const Species(label: 'Fish', doThreshold: 5.0, category: SpeciesCategory.fish)
        : const Species(label: 'Prawns', doThreshold: 4.0, category: SpeciesCategory.prawns);
  }
}

final speciesProvider =
StateNotifierProvider<SpeciesNotifier, Species>((ref) => SpeciesNotifier());

/// 🧩 Multi-selection provider (used for SpeciesSelectionScreen)
class SelectedSpeciesNotifier extends StateNotifier<List<Species>> {
  SelectedSpeciesNotifier() : super([]);

  void toggleSelection(String label) {
    final species = Species.speciesData[label];
    if (species == null) return;

    if (state.any((s) => s.label == label)) {
      state = state.where((s) => s.label != label).toList();
    } else {
      state = [...state, species];
    }
  }

  void clearSelections() => state = [];
}

final selectedSpeciesProvider =
StateNotifierProvider<SelectedSpeciesNotifier, List<Species>>(
        (ref) => SelectedSpeciesNotifier());
