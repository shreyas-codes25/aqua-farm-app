import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smartaquaapp/providers/history_provider.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../providers/connectivity_provider.dart';
import '../providers/species_provider.dart';
import '../providers/alerts_provider.dart';
import '../models/alert_item.dart';
import 'alerts_screen.dart';
import 'control_panel_screen.dart';
import 'settings_screen.dart';
import 'do_chart_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;

  Future<void> _showSystemNotification(int unackCount) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'alerts_channel_id',
          'Alerts',
          channelDescription: 'Notifications for unacknowledged alerts',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await FlutterLocalNotificationsPlugin().show(
      0,
      'Smart Aqua Alert',
      'You have $unackCount unacknowledged alerts!',
      notificationDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    final connectivity = ref.watch(connectivityProvider);
    final alerts = ref.watch(alertsProvider);
    final sensor = ref.watch(sensorStreamProvider);

    final pages = [
      _buildDashboard(context, ref, sensor, connectivity),
      const ControlPanelScreen(),
      const AlertsScreen(),
      const DOChartScreen(),
      const SettingsScreen(),
    ];

    return SafeArea(
      child: Scaffold(
        body: pages[_selectedIndex],
        bottomNavigationBar: _buildStylishBottomBar(ref, alerts),
      ),
    );
  }

  /// 🧭 Stylish Bottom Navigation Bar
  Widget _buildStylishBottomBar(WidgetRef ref, List<AlertItem> alerts) {
    final unackCount = alerts.where((a) => !a.acknowledged).length;

    return StylishBottomBar(
      option: BubbleBarOptions(barStyle: BubbleBarStyle.vertical),

      items: [
        BottomBarItem(
          icon: const Icon(Icons.dashboard_outlined),
          selectedIcon: const Icon(Icons.dashboard),
          selectedColor: Colors.teal,
          unSelectedColor: Colors.grey,
          title: const Text('Dashboard'),
        ),
        BottomBarItem(
          icon: const Icon(Icons.control_camera_outlined),
          selectedIcon: const Icon(Icons.control_camera),
          selectedColor: Colors.teal,
          unSelectedColor: Colors.grey,
          title: const Text('Control'),
        ),
        BottomBarItem(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications_none),
              if (unackCount > 0)
                Positioned(
                  right: -6,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '$unackCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          selectedIcon: const Icon(Icons.notifications),
          selectedColor: Colors.teal,
          unSelectedColor: Colors.grey,
          title: const Text('Alerts'),
        ),
        BottomBarItem(
          icon: const Icon(Icons.bar_chart_outlined),
          selectedIcon: const Icon(Icons.bar_chart),
          selectedColor: Colors.teal,
          unSelectedColor: Colors.grey,
          title: const Text('Charts'),
        ),
        BottomBarItem(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          selectedColor: Colors.teal,
          unSelectedColor: Colors.grey,
          title: const Text('Settings'),
        ),
      ],

      currentIndex: _selectedIndex,
      hasNotch: false,
      onTap: (index) {
        setState(() => _selectedIndex = index);
      },
    );
  }

  /// 🏠 Dashboard Main View
  Widget _buildDashboard(
    BuildContext context,
    WidgetRef ref,
    AsyncValue sensor,
    bool connectivity,
  ) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Aqua Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.data_array_sharp),
            onPressed: () async {
              // Add dummy alerts
              ref.read(alertsProvider.notifier).addDummyAlerts(3);

              // Count unacknowledged alerts
              final alerts = ref.read(alertsProvider);
              final unackCount = alerts.where((a) => !a.acknowledged).length;

              // Show system notification
              await _showSystemNotification(unackCount);
            },

          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(width * 0.04),
        child: Column(
          children: [
            _buildHeader(context, ref, connectivity, width),
            SizedBox(height: height * 0.02),
            Expanded(
              child: sensor.when(
                data: (r) => _buildSensorCards(context, ref, r, width, height),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    bool connectivity,
    double width,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            children: [
              Icon(
                connectivity ? Icons.cloud_done : Icons.cloud_off,
                color: connectivity ? Colors.green : Colors.red,
                size: 28,
              ),
              SizedBox(width: width * 0.02),
              Flexible(
                child: Text(
                  connectivity ? 'Online' : 'Offline (Data stored locally)',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: width * 0.02),
              ElevatedButton(
                onPressed: () => ref.read(connectivityProvider.notifier).state =
                    !connectivity,
                child: const Text('Toggle Offline'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSensorCards(
    BuildContext context,
    WidgetRef ref,
    dynamic reading,
    double width,
    double height,
  ) {
    final species = ref.watch(speciesProvider);
    final threshold = species.doThreshold;

    Color doColor;
    if (reading.doLevel >= threshold) {
      doColor = Colors.green;
    } else if (reading.doLevel >= threshold - 0.5) {
      doColor = Colors.orange;
    } else {
      doColor = Colors.red;
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sensorCard(reading, threshold, doColor, ref, width),
          SizedBox(height: height * 0.02),
          _summaryCard(reading, width),
        ],
      ),
    );
  }

  Widget _sensorCard(
    reading,
    threshold,
    doColor,
    WidgetRef ref,
    double width,
  ) => Card(
    elevation: 6,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: EdgeInsets.all(width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Live Sensor Readings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: width * 0.04),
          Wrap(
            spacing: width * 0.03,
            runSpacing: width * 0.03,
            children: [
              _sensorTile(
                'Temperature',
                '${reading.temperature} °C',
                Icons.thermostat_outlined,
                Colors.orange,
                width,
              ),
              _sensorTile(
                'pH',
                '${reading.ph}',
                Icons.science_outlined,
                Colors.blue,
                width,
              ),
              _sensorTile(
                'DO',
                '${reading.doLevel} mg/L',
                Icons.air,
                doColor,
                width,
              ),
              _sensorTile(
                'Turbidity',
                '${reading.turbidity} NTU',
                Icons.opacity,
                Colors.brown,
                width,
              ),
            ],
          ),
          SizedBox(height: width * 0.04),
          Text(
            'Species: ${ref.read(speciesProvider).label} (DO threshold: $threshold mg/L)',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
          Text(
            'Last updated: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(reading.time)}',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    ),
  );

  Widget _summaryCard(reading, double width) => Card(
    elevation: 6,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: EdgeInsets.all(width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Summary',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: width * 0.03),
          Wrap(
            spacing: width * 0.03,
            runSpacing: width * 0.03,
            children: [
              _statTile(
                'Temp',
                '${reading.temperature} °C',
                Icons.thermostat,
                width,
              ),
              _statTile(
                'DO',
                '${reading.doLevel} mg/L',
                Icons.water_drop,
                width,
              ),
              _statTile('pH', '${reading.ph}', Icons.science, width),
              _statTile(
                'Turbidity',
                '${reading.turbidity} NTU',
                Icons.opacity,
                width,
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _statTile(String title, String value, IconData icon, double width) =>
      Container(
        width: width * 0.28,
        padding: EdgeInsets.all(width * 0.03),
        decoration: BoxDecoration(
          color: Colors.teal.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.teal),
            SizedBox(height: width * 0.01),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      );

  Widget _sensorTile(
    String title,
    String value,
    IconData icon,
    Color color,
    double width,
  ) => Container(
    width: width * 0.35,
    padding: EdgeInsets.all(width * 0.03),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Row(
      children: [
        Container(
          padding: EdgeInsets.all(width * 0.02),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        SizedBox(width: width * 0.03),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.grey[700])),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    ),
  );
}
