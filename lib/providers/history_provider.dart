import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/sensor_reading.dart';
import '../models/alert_item.dart';
import 'species_provider.dart';
import 'control_providers.dart';
import 'alerts_provider.dart';

// Simulated sensor stream
final sensorStreamProvider = StreamProvider<SensorReading>((ref) {
  final rng = Random();
  double lastDO = 5.0;

  return Stream<SensorReading>.periodic(const Duration(seconds: 5), (_) {
    final now = DateTime.now();
    final temp = 27 + rng.nextDouble() * 2;
    final ph = 7 + (rng.nextDouble() - 0.5) * 0.5;
    final doChange = (rng.nextDouble() - 0.4) * 0.3;
    lastDO = (lastDO + doChange).clamp(2.0, 9.0);
    final turb = 10 + rng.nextDouble() * 2;

    return SensorReading(
      time: now,
      temperature: double.parse(temp.toStringAsFixed(2)),
      ph: double.parse(ph.toStringAsFixed(2)),
      doLevel: double.parse(lastDO.toStringAsFixed(2)),
      turbidity: double.parse(turb.toStringAsFixed(2)),
    );
  }).asBroadcastStream();
});

final historyProvider =
StateNotifierProvider<HistoryNotifier, List<SensorReading>>((ref) {
  final notifier = HistoryNotifier();

  ref.listen<AsyncValue<SensorReading>>(sensorStreamProvider, (prev, next) {
    next.whenData((reading) {
      notifier.add(reading);

      // Alert check
      final species = ref.read(speciesProvider);
      final threshold = species.doThreshold;
      if (reading.doLevel < threshold) {
        final aeratorOn = ref.read(aeratorProvider);
        final action = aeratorOn
            ? 'Aerator already running'
            : 'Aerator started (auto)';

        if (!aeratorOn) {
          ref.read(aeratorProvider.notifier).state = true;
        }

        ref.read(alertsProvider.notifier).add(
          AlertItem(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            type: 'Low DO Alert',
            time: DateTime.now(),
            actionTaken: action,
          ),
        );
      }
    });
  });

  return notifier;
});

class HistoryNotifier extends StateNotifier<List<SensorReading>> {
  HistoryNotifier() : super([]);

  void add(SensorReading reading) {
    final updated = [reading, ...state];
    if (updated.length > 40) updated.removeRange(40, updated.length);
    state = updated;
  }

  void clear() => state = [];
}
