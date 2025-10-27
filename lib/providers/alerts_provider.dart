import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/alert_item.dart';
import 'dart:math';
final alertsProvider = StateNotifierProvider<AlertsNotifier, List<AlertItem>>(
      (ref) => AlertsNotifier(),
);


class AlertsNotifier extends StateNotifier<List<AlertItem>> {
  AlertsNotifier() : super([]);

  void add(AlertItem alert) => state = [alert, ...state];

  void acknowledge(String id) {
    state = [
      for (final a in state)
        if (a.id == id)
          AlertItem(
            id: a.id,
            type: a.type,
            time: a.time,
            actionTaken: a.actionTaken,
            acknowledged: true,
          )
        else
          a,
    ];
  }

  void clear() => state = [];

  /// Add dummy alerts
  void addDummyAlerts(int count) {
    final random = Random();
    final types = ['High DO', 'Low pH', 'High Turbidity', 'Temperature Alert'];
    final actions = ['Notified', 'Checked', 'Alarm Triggered', 'Ignored'];

    for (int i = 0; i < count; i++) {
      final alert = AlertItem(
        id: DateTime.now().millisecondsSinceEpoch.toString() + i.toString(),
        type: types[random.nextInt(types.length)],
        time: DateTime.now().subtract(Duration(minutes: random.nextInt(60))),
        actionTaken: actions[random.nextInt(actions.length)],
        acknowledged: random.nextBool(),
      );
      add(alert);
    }
  }
}
