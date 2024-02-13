class ReservationTimeRange  {
  final int buildingId;
  final DateTime startDateTime;
  final DateTime endDateTime;

  ReservationTimeRange(
      {required this.buildingId,
      required this.startDateTime,
      required this.endDateTime});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'buildingId': buildingId,
      'startDateTime': startDateTime.toIso8601String(),
      'endDateTime': endDateTime.toIso8601String()
    };
  }
}