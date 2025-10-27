import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Control states
final pumpProvider = StateProvider<bool>((ref) => false);
final aeratorProvider = StateProvider<bool>((ref) => false);
final feederProvider = StateProvider<bool>((ref) => false);
