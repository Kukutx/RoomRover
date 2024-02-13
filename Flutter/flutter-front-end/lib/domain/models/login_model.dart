class LoginModel {
  final String username;
  final String password;
  final String? linkImmagine;

  LoginModel({required this.username, required this.password, this.linkImmagine});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'username': username,
      'password': password,
      'linkImmagine': linkImmagine,
    };
  }
  factory LoginModel.fromJson(Map<String, dynamic> map) {
    return LoginModel(
      username: map['username'] as String,
      password: map['password'] as String,
      linkImmagine: map['linkImmagine'] as String,
    );
  }
}
