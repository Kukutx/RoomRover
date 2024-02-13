class Filters {
  final DateTime? dateStart;
  final DateTime? dateEnd;
  final String? email;

  Filters({
    required this.dateStart,
    required this.dateEnd,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'start': dateStart?.toUtc().toIso8601String(),
      'end': dateEnd?.toUtc().toIso8601String(),
      'mail': email,
    };
  }
}