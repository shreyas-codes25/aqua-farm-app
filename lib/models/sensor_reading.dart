class SensorReading {
  final DateTime time;
  final double temperature;
  final double ph;
  final double doLevel;
  final double turbidity;


  SensorReading({
    required this.time,
    required this.temperature,
    required this.ph,
    required this.doLevel,
    required this.turbidity,
  });
}