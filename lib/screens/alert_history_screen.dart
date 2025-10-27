import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/alerts_provider.dart';
import 'package:intl/intl.dart';

class AlertHistoryScreen extends ConsumerWidget {
  const AlertHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alerts = ref.watch(alertsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Alert History')),
      body: alerts.isEmpty
          ? const Center(child: Text('No alerts yet'))
          : ListView.builder(
        itemCount: alerts.length,
        itemBuilder: (context, i) {
          final a = alerts[i];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: Icon(Icons.warning,
                  color: a.acknowledged ? Colors.grey : Colors.red),
              title: Text(a.type),
              subtitle: Text(
                '${DateFormat('yyyy-MM-dd HH:mm:ss').format(a.time)}\nAction: ${a.actionTaken}',
              ),
              isThreeLine: true,
              trailing: Text(a.acknowledged ? 'Done' : 'Active'),
            ),
          );
        },
      ),
    );
  }
}
