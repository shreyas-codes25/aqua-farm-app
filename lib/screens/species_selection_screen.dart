import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/species_provider.dart';

class SpeciesSelectionScreen extends ConsumerWidget {
  const SpeciesSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSpecies = ref.watch(selectedSpeciesProvider);
    final notifier = ref.read(selectedSpeciesProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Farmed Species'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select the species you are farming',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: Species.speciesData.keys.map((label) {
                  final species = Species.speciesData[label]!;
                  final isSelected =
                  selectedSpecies.any((s) => s.label == label);

                  return GestureDetector(
                    onTap: () => notifier.toggleSelection(label),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.teal.shade100 : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? Colors.teal : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            species.category == SpeciesCategory.fish
                                ? Icons.set_meal
                                : Icons.water,
                            color: isSelected ? Colors.teal : Colors.grey[700],
                            size: 40,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? Colors.teal.shade900
                                  : Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'DO ≥ ${species.doThreshold} mg/L',
                            style:
                            TextStyle(fontSize: 13, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedSpecies.isEmpty
                    ? null
                    : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Selected: ${selectedSpecies.map((s) => s.label).join(", ")}',
                      ),
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save & Go Back',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
