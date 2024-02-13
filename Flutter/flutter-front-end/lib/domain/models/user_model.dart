class User {
  final List<String> businessPhones;
  final String displayName;
  final String givenName;
  final String jobTitle;
  final String mail;
  final String? mobilePhone;
  final String officeLocation;
  final String? preferredLanguage;
  final String surname;
  final String userPrincipalName;
  final String id;

  User({
    required this.businessPhones,
    required this.displayName,
    required this.givenName,
    required this.jobTitle,
    required this.mail,
    this.mobilePhone,
    required this.officeLocation,
    this.preferredLanguage,
    required this.surname,
    required this.userPrincipalName,
    required this.id,
  });

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      businessPhones: List<String>.from(map['businessPhones']),
      displayName: map['displayName'] as String,
      givenName: map['givenName'] as String,
      jobTitle: map['jobTitle'] as String,
      mail: map['mail'] as String,
      mobilePhone: map['mobilePhone'] as String?,
      officeLocation: map['officeLocation'] as String,
      preferredLanguage: map['preferredLanguage'] as String?,
      surname: map['surname'] as String,
      userPrincipalName: map['userPrincipalName'] as String,
      id: map['id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'businessPhones': businessPhones,
      'displayName': displayName,
      'givenName': givenName,
      'jobTitle': jobTitle,
      'mail': mail,
      'mobilePhone': mobilePhone,
      'officeLocation': officeLocation,
      'preferredLanguage': preferredLanguage,
      'surname': surname,
      'userPrincipalName': userPrincipalName,
      'id': id,
    };
  }
}




class UserGetAll {
  final String email;
  final int userId;
  final bool isDeleted;

  UserGetAll({
    required this.email,
    required this.userId,
    required this.isDeleted,
  });

  factory UserGetAll.fromJson(Map<String, dynamic> map) {
    return UserGetAll(
      email: map['email'] as String,
      userId: map['userId'] as int,
      isDeleted: map['isDeleted'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'userId': userId,
      'isDeleted': isDeleted,
    };
  }
}