import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartaquaapp/screens/species_selection_screen.dart';
import '../providers/species_provider.dart';
import '../providers/connectivity_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityProvider);
    final selectedSpecies = ref.watch(selectedSpeciesProvider);

    const userName = "Shreyas";
    const userEmail = "shreyas@apple.com";
    const deviceId = "ESP32-AQ1234";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SpeciesSelectionScreen(),
                ),
              );
            },
            child: const Text(
              "Select Species",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 👤 Profile Info
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage:
                    AssetImage('assets/profile_placeholder.png'),
                  ),
                  const SizedBox(height: 12),
                  Text(userName,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600)),
                  Text(userEmail, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 25),

            /// 🔌 Device Info
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: Icon(
                  connectivity ? Icons.cloud_done : Icons.cloud_off,
                  color: connectivity ? Colors.green : Colors.red,
                ),
                title: Text('Connected Device: $deviceId'),
                subtitle: Text(connectivity ? 'Online' : 'Offline'),
              ),
            ),
            const SizedBox(height: 25),

            /// 🐟 Selected Species List
            const Text(
              'Farmed Species',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            if (selectedSpecies.isEmpty)
              const Text(
                'No species selected yet.',
                style: TextStyle(color: Colors.grey),
              )
            else
              Column(
                children: selectedSpecies.map((s) {
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: Icon(
                        s.category == SpeciesCategory.fish
                            ? Icons.set_meal
                            : Icons.water,
                        color: Colors.teal,
                      ),
                      title: Text(s.label),
                      subtitle: Text(
                          'Category: ${s.category.label} | DO ≥ ${s.doThreshold} mg/L'),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
