class Alarm {
  final int id;
  final int hour;
  final int minute;
  final bool isMedicine;
  final bool isPill;
  bool isEnabled;

  Alarm({
    required this.id,
    required this.hour,
    required this.minute,
    required this.isMedicine,
    required this.isPill,
    required this.isEnabled,
  });

  factory Alarm.fromMap(Map<String, dynamic> map) {
    return Alarm(
      id: map['id'],
      hour: map['hour'],
      minute: map['minute'],
      isMedicine: map['isMedicine'],
      isPill: map['isPill'],
      isEnabled: map['isEnabled'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hour': hour,
      'minute': minute,
      'isMedicine': isMedicine,
      'isPill': isPill,
      'isEnabled': isEnabled,
    };
  }
}
