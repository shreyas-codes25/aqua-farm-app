import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/history_provider.dart';
import 'package:intl/intl.dart';

class DOChartScreen extends ConsumerWidget {
  const DOChartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readings = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('DO Level Trends')),
      body: readings.isEmpty
          ? const Center(child: Text('No data available'))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, _) {
                    final index = value.toInt();
                    if (index < 0 || index >= readings.length) {
                      return const SizedBox.shrink();
                    }
                    final time =
                    DateFormat('HH:mm').format(readings[index].time);
                    return Text(time, style: const TextStyle(fontSize: 10));
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 40),
              ),
            ),
            gridData: FlGridData(show: true),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(
                  readings.length,
                      (i) => FlSpot(i.toDouble(), readings[i].doLevel),
                ),
                isCurved: true,
                barWidth: 3,
                dotData: FlDotData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
