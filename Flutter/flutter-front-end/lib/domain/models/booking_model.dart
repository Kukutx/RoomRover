class Booking {
  final int reservationId;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final List<String> usersId; //email
  final int resourceId;
  final bool isDeleted;
  final int resourceType;
  late String resourceName;

  Booking({
    this.reservationId = 0,
    required this.startDateTime,
    required this.endDateTime,
    required this.usersId,
    required this.isDeleted,
    required this.resourceId,
    required this.resourceType,
  }) {
    // Assegna il valore corretto a resourceName in base a resourceType
    resourceName = getResourceNameFromType(resourceType);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'reservationId': reservationId,
      'startDateTime': startDateTime,
      'endDateTime': endDateTime,
      'usersId': usersId,
      'isDeletedAdmin': isDeleted,
      'resourceId': resourceId,
      'resourceType': resourceType,
    };
  }

  factory Booking.fromJson(Map<String, dynamic> map) {
    return Booking(
      reservationId: map['reservationId'] as int,
      startDateTime: DateTime.parse(map['startDateTime'] as String),
      endDateTime: DateTime.parse(map['endDateTime'] as String),
      usersId: (map['usersId'] as List<dynamic>)
          .map((dynamic user) => user.toString())
          .toList(),
      isDeleted: map['isDeleted'] as bool,
      resourceType: map['resourceType'] as int,
      resourceId: map['resourceId'] as int,
    );
  }

  // Funzione di utilità per ottenere il nome della risorsa da resourceType
  String getResourceNameFromType(int type) {
    switch (type) {
      case 0:
        return 'Seat';
      case 1:
        return 'PhoneBoot';
      case 2:
        return 'Room';
      default:
        return 'Unknown';
    }
  }
}