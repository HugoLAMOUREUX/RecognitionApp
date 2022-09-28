class UserModel {
  late final String email;
  late final String password;
  late final String firstName;
  late final String lastName;
  late String uid;

  UserModel({
    this.uid = "",
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  UserModel.b({
    required this.password,
    required this.email,
    this.firstName = "",
    this.lastName = "",
    this.uid = "",
  });

  UserModel.c({
    required this.uid,
    required this.email,
    this.firstName = "",
    this.lastName = "",
    this.password = "",
  });

  set setUid(value) => uid = value;

  Map<String, dynamic> toJson() => {
        'uid:': uid,
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
      };
}
