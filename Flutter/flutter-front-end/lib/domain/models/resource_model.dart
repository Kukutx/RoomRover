class ResourceModel {
  final int resourceId;
  final String name;
  final String? description;
  final int posX;
  final int posY;
  final int buildingId;
  final bool isDeleted;
  final bool isFree;
  final int resourceType;
  final int seatsNumber;

  ResourceModel(
      {required this.resourceId,
      required this.name,
      required this.description,
      required this.posX,
      required this.posY,
      required this.buildingId,
      required this.isDeleted,
      this.isFree = false,
      required this.resourceType,
      required this.seatsNumber});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'resourceId': resourceId,
      'name': name,
      'description': description,
      'posX': posX,
      'posY': posY,
      'buildingId': buildingId,
      'isDeleted': isDeleted,
      'isFree': isFree,
      'resourceType': resourceType,
      'seatsNumber': seatsNumber
    };
  }

  factory ResourceModel.fromJson(Map<String, dynamic> map) {
    return ResourceModel(
      resourceId: map['resourceId'] as int,
      name: map['name'] as String,
      description: map['description'] as String?,
      posX: map['posX'] as int,
      posY: map['posY'] as int,
      buildingId: map['buildingId'] as int,
      isDeleted: map['isDeleted'] as bool,
      isFree: map['isFree'] ?? false ,
      resourceType: map['resourceType'] as int,
      seatsNumber: map['seatsNumber'] as int,
    );
  }
}


