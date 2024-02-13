class NewReservation {
 final int reservationId;
 final DateTime startDateTime;
 final DateTime endDateTime;
 final int resourceId;
 final bool isDeleted;
 final List<int> usersId;

 NewReservation({
    required this.reservationId,
    required this.startDateTime,
    required this.endDateTime,
    required this.resourceId,
    required this.isDeleted,
    required this.usersId,
 });

 factory NewReservation.fromJson(Map<String, dynamic> json) {
    return NewReservation(
      reservationId: json['reservationId'],
      startDateTime: DateTime.parse(json['startDateTime']),
      endDateTime: DateTime.parse(json['endDateTime']),
      resourceId: json['resourceId'],
      isDeleted: json['isDeleted'],
      usersId: List<int>.from(json['usersId']),
    );
 }

 Map<String, dynamic> toJson() {
    return {
      'reservationId': reservationId,
      'startDateTime': startDateTime.toIso8601String(),
      'endDateTime': endDateTime.toIso8601String(),
      'resourceId': resourceId,
      'isDeleted': isDeleted,
      'usersId': usersId,
    };
 }
}
