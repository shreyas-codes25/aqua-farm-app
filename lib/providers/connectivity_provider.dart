import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Simulated online/offline state
final connectivityProvider = StateProvider<bool>((ref) => true);
