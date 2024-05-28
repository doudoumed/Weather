class weatherData {
  factory weatherData.fromJson(Map<String, dynamic> json) {
    return weatherData(
        date: json['date'],
        time: json['time'],
        locatin: json['location '],
        temp: json['temperature'],
        humid: json['humidity']);
  }
  weatherData({
    required this.date,
    required this.time,
    required this.locatin,
    required this.temp,
    required this.humid,
  });
  final String date;
  final String time;
  final String locatin;
  final int temp;
  final int humid;
}
