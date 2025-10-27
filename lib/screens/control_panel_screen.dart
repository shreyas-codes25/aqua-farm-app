import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/control_providers.dart';

class ControlPanelScreen extends ConsumerWidget {
  const ControlPanelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pump = ref.watch(pumpProvider);
    final aerator = ref.watch(aeratorProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Control Panel')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Manual Controls',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            _buildControlTile(
              title: 'Water Pump',
              value: pump,
              icon: Icons.water,
              onChanged: (v) => ref.read(pumpProvider.notifier).state = v,
            ),
            const SizedBox(height: 12),
            _buildControlTile(
              title: 'Aerator',
              value: aerator,
              icon: Icons.air,
              onChanged: (v) => ref.read(aeratorProvider.notifier).state = v,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlTile({
    required String title,
    required bool value,
    required IconData icon,
    required Function(bool) onChanged,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(title),
        trailing: Switch(value: value, onChanged: onChanged),
      ),
    );
  }
}
