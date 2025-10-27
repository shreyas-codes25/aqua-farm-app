class AlertItem {
  final String id;
  final String type;
  final DateTime time;
  final String actionTaken;
  bool acknowledged;


  AlertItem({
    required this.id,
    required this.type,
    required this.time,
    required this.actionTaken,
    this.acknowledged = false,
  });
}