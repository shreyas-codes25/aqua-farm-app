import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/alerts_provider.dart';
import '../models/alert_item.dart';

class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alerts = ref.watch(alertsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Alerts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: alerts.isEmpty
            ? const Center(child: Text('No active alerts 🎉'))
            : ListView.builder(
          itemCount: alerts.length,
          itemBuilder: (context, index) {
            final a = alerts[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: a.acknowledged ? Colors.grey[100] : Colors.red.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(a.type, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  '${DateFormat('yyyy-MM-dd HH:mm:ss').format(a.time)} · ${a.actionTaken}',
                ),
                trailing: a.acknowledged
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : ElevatedButton(
                  onPressed: () => ref.read(alertsProvider.notifier).acknowledge(a.id),
                  child: const Text('Acknowledge'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
