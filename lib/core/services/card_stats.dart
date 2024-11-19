class CardStatistics {
  final int currentYear;
  final int lastYear;
  final int total;

  CardStatistics(
      {required this.currentYear, required this.lastYear, required this.total});

  factory CardStatistics.fromJson(Map<String, dynamic> json) {
    return CardStatistics(
      currentYear: json['current_year'],
      lastYear: json['last_year'],
      total: json['total'],
    );
  }
}
