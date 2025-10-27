import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smartaquaapp/screens/dashboard_screen.dart';
import 'package:smartaquaapp/screens/login_screen.dart';
import 'package:smartaquaapp/theme/theme.dart';

// 🚨 Import the local notifications plugin
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// 🔔 Create a global instance (accessible in other files)
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🧩 Android initialization settings
  const AndroidInitializationSettings androidInitSettings =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  // 🧩 iOS (optional)
  const DarwinInitializationSettings iosInitSettings =
  DarwinInitializationSettings();

  const InitializationSettings initSettings = InitializationSettings(
    android: androidInitSettings,
    iOS: iosInitSettings,
  );

  // 🧩 Initialize the notifications plugin
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  // ✅ Ask for permission (for Android 13+ and iOS)
  final androidPlugin = flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();
  await androidPlugin?.requestNotificationsPermission();
  // await androidPlugin?.requestNotificationPolicyAccess();

  runApp(const ProviderScope(child: SmartAquaApp()));
}

class SmartAquaApp extends StatelessWidget {
  const SmartAquaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Aqua Prototype',
      theme: smartAquaTheme,
      home: const LoginScreen(),
    );
  }
}
