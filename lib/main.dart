import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';
import 'package:smartaquaapp/screens/dashboard_screen.dart';
import 'package:smartaquaapp/screens/login_screen.dart';
import 'package:smartaquaapp/theme/theme.dart';

void main() {
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
