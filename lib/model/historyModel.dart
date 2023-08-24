class HistoryModel {
  final String text;
  final String dateTime;

  final String hour;

  const HistoryModel({
    required this.text,
    required this.dateTime,
    required this.hour,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'dateTime': dateTime,
      'hour': hour,
    };
  }

  @override
  String toString() {
    return 'History{text: $text, dateTime: $dateTime, hour: $hour}';
  }
}
