class Info {
  final String uuid;
  final int duration;
  final String date;
  int? timestamp;
  Info(
      {required this.uuid,
      required this.duration,
      this.timestamp,
      required this.date});

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'duration': duration,
      'date': date,
    };
  }

  Map<String, dynamic> toUploadMap() {
    return {
      'uuid': uuid,
      'duration': duration,
      'date': date,
      'timestamp': DateTime.now().millisecondsSinceEpoch
    };
  }

  @override
  String toString() {
    return 'Info{uuid: $uuid,duration: $duration, date: $date}';
  }
}
