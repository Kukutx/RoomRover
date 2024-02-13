class Building {
  final int buildingId;
  final String name;
  final String mapLink;
  final String imageLink;
  final int axisX;
  final int axisY;
  final bool isDeleted;
 
  Building({
    this.buildingId = 0,
    required this.name,
    required this.imageLink,
    required this.mapLink,
    required this.axisX,
    required this.axisY,
    required this.isDeleted
  });
 
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'buildingId': buildingId,
      'name': name,
      'imageLink': imageLink,
      'mapLink': mapLink,
      'axisX': axisX,
      'axisY': axisY,
      'isDeleted' : isDeleted
    };
  }
 
  factory Building.fromJson(Map<String, dynamic> map) {
    return Building(
      buildingId: map['buildingId'] as int,
      name: map['name'] as String,
      imageLink: map ['imageLink'] as String,
      mapLink: map['mapLink'] as String,
      axisX: map['axisX'] as int,
      axisY: map['axisY'] as int,
      isDeleted: map['isDeleted'] as bool,
    );
  }
}
